//
//  RiLiView.m
//  ZtqCountry
//
//  Created by Admin on 16/10/20.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "RiLiView.h"
#import "ChineseHoliDay.h"

@implementation RiLiView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        nstr1 =
        [[NSArray alloc] initWithObjects:
         @"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
                m_lunarDB = [[LunarDB alloc] init];
                [self updateView];
                if ([m_lunarDB ChineseMonth].length>0) {
                    [self getgz_in_imagewithid:[m_lunarDB ChineseMonth]];
                }
                UIImageView * bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
                bgImgV.backgroundColor = [UIColor clearColor];
                bgImgV.userInteractionEnabled = YES;
                self.tbgimg=bgImgV;
                [self addSubview:bgImgV];
                UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 2, kScreenWidth, 40)];
                bgimg.image=[UIImage imageNamed:@"首页背景条"];
                bgimg.userInteractionEnabled=YES;
                [bgImgV addSubview:bgimg];
        
                UILabel *loclab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
                loclab.text=@"日历中心";
                loclab.textColor=[UIColor whiteColor];
                loclab.font=[UIFont systemFontOfSize:15];
                [bgimg addSubview:loclab];
                UIButton *birthbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-85, 7.5, 80, 25)];
                [birthbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
                [birthbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
                [birthbtn setTitle:@"出生日天气" forState:UIControlStateNormal];
                [birthbtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
                birthbtn.titleLabel.font=[UIFont systemFontOfSize:14];
                [birthbtn addTarget:self action:@selector(findbirth) forControlEvents:UIControlEventTouchUpInside];
                [bgimg addSubview:birthbtn];
        
        UIButton *rilibtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 42, kScreenWidth, 110)];
        [rilibtn addTarget:self action:@selector(riliAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rilibtn];
        
                UIImageView * lineimg2 = [[UIImageView alloc] initWithFrame:CGRectMake(85, 45, 5, 72)];
                lineimg2.image=[UIImage imageNamed:@"首页竖"];
                [self addSubview:lineimg2];
        
                self.rl_img = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"圆形加载图 小"]];
                self.rl_img.frame=CGRectMake(kScreenWidth-80, 50, 75, 75);
                [bgImgV addSubview:self.rl_img];
        
                UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 70, 250, 25)];
                titleLab.backgroundColor = [UIColor clearColor];
                titleLab.textAlignment = NSTextAlignmentRight;
                titleLab.textColor = [UIColor whiteColor];
                titleLab.font = [UIFont systemFontOfSize:15];
                [bgImgV addSubview:titleLab];
        
                UILabel * introductionLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 45, 250, 25)];
                introductionLab.backgroundColor = [UIColor clearColor];
                introductionLab.textAlignment = NSTextAlignmentRight;
                introductionLab.textColor = [UIColor whiteColor];
                introductionLab.font = [UIFont systemFontOfSize:13];
                [bgImgV addSubview:introductionLab];
        
        
                //                UILabel *m_lab=[[UILabel alloc]initWithFrame:CGRectMake(30, 92, 60, 30)];
                UILabel *m_lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, 90, 25)];
                m_lab.textColor=[UIColor whiteColor];
                m_lab.textAlignment=NSTextAlignmentCenter;
                m_lab.font=[UIFont fontWithName:kWeatherFont size:14];
                //                m_lab.text=[m_lunarDB SolorDateString];
                m_lab.text=[self today:[NSDate date]];
                [self addSubview:m_lab];
        
                UIImageView *xline=[[UIImageView alloc]initWithFrame:CGRectMake(20, 71, 50, 35)];
                xline.image=[UIImage imageNamed:@"日期斜杠"];
                xline.userInteractionEnabled=YES;
                //                [self addSubview:xline];
                //第几号
                //                UILabel * haoLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 80, 35)];
                UILabel * haoLab = [[UILabel alloc] initWithFrame:CGRectMake(2, 75, 80, 40)];
                haoLab.backgroundColor = [UIColor clearColor];
                haoLab.textAlignment = NSTextAlignmentCenter;
                haoLab.textColor = [UIColor whiteColor];
                haoLab.font = [UIFont fontWithName:kWeatherFont size:40];
                haoLab.adjustsFontSizeToFitWidth = YES;
                haoLab.text = [self SolorDayStringWithdate:[NSDate date]];
                [self addSubview:haoLab];
        
        
        
                UILabel *jieri=[[UILabel alloc]initWithFrame:CGRectMake(105, 95, 250, 25)];
                jieri.textColor=[UIColor whiteColor];
                jieri.font=[UIFont systemFontOfSize:15];
                jieri.numberOfLines=0;
        
                if ([self getholiday].length>0) {
                    jieri.text=[NSString stringWithFormat:@"%@/%@",[self getspecial],[self getholiday]];
                }else{
                    jieri.text=[self getspecial];
                }
        
                [self addSubview:jieri];
        
        
                NSString * chineseDate = [self SolorWeekDayStringwithdate:[NSDate date]];
                titleLab.text = chineseDate;
        
        
                titleLab.textAlignment=NSTextAlignmentLeft;
                NSString * introductionStr =[m_lunarDB ChineseYear];
                introductionLab.text = introductionStr;
        
        
                introductionLab.textAlignment=NSTextAlignmentLeft;
                UIImageView *aixin=[[UIImageView alloc]initWithFrame:CGRectMake(10, 125,20, 22)];
                aixin.image=[UIImage imageNamed:@"爱心.png"];
                [self addSubview:aixin];
                UILabel *rililab=[[UILabel alloc]initWithFrame:CGRectMake(40, 120, kScreenWidth-40, 30)];
                rililab.textColor=[UIColor yellowColor];
                rililab.text=@"查询出生日天气，揭晓关于你的天意！";
                rililab.font=[UIFont systemFontOfSize:14];
                [self addSubview:rililab];
        
        
    }
    return self;
}
//获取日历图片
-(void)getgz_in_imagewithid:(NSString *)month{
    
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:month forKey:@"id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_in_image"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        ;
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_in_image"];
            NSString *image=[gz_air_qua_index objectForKey:@"image"];
            [self.rl_img setImageURL:[ShareFun makeImageUrl:image]];
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
    
}
-(NSString *)getholiday{
    NSString * HoliDay = nil;
    NSString *chineseHoliDay=nil;
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSString *newday=[NSString stringWithFormat:@"%d",day];
    HoliDay=[Calendar getHolidayDayWithyear:year Withmonth:month Withday:newday];
    NSString *rili=[NSString stringWithFormat:@"%d-%d-%@",year, month, newday];
    chineseHoliDay=[Calendar getChineseHoliday:rili];
    if (HoliDay.length>0&&chineseHoliDay.length>0) {
        return chineseHoliDay;
    }
    if (HoliDay.length>0) {
        return HoliDay;
    }
    if (chineseHoliDay.length>0) {
        return chineseHoliDay;
    }
    return chineseHoliDay;
}
-(NSString *)today:(NSDate *)da{
    NSDateFormatter*outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月"];
    NSString*str = [outputFormatter stringFromDate:da];
    //    NSLog(@"testDate:%@",str);
    return str;
}
///获取公历日期
- (NSString *) SolorDayStringWithdate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSInteger flag = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents* dc = [gregorian components:flag fromDate:date];
    
    NSString *dateString = [NSString stringWithFormat:@"%d", [dc day]];
    return dateString;
}
///获取公历周
- (NSString *) SolorWeekDayStringwithdate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSInteger flag = NSWeekdayCalendarUnit;
    NSDateComponents* dc = [gregorian components:flag fromDate:date];
    
    NSString *dateString = [NSString stringWithFormat:@"星期%@", [self ConvertWeekToChinsesWeek:[dc weekday] - 1]];
    return dateString;
}
- (NSString *) ConvertWeekToChinsesWeek:(int)w
{
    if (w < 0 || w > 7)
        return nil;
    return [nstr1 objectAtIndex:w];
    
}
-(NSString *)getspecial{
    NSString * chineseHoliDay = nil;
    
    NSDate * tomorrow = [[NSDate date] dateByAddingTimeInterval:24*60*60];
    NSDateComponents * componets = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger day = [componets day];
    NSInteger month = [componets month];
    NSInteger year = [componets year];
    NSString * chd = [ChineseHoliDay getLunarSpecialDate:year Month:month Day:day];
    //    if(chd.length)
    //    {
    //        chineseHoliDay = [NSString stringWithFormat:@"明日%@",chd];
    //    }
    return chd;
}
- (void)updateView
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSInteger mint=5*60;//农历时间多加5分钟
    NSDate * nowdt = [localeDate dateByAddingTimeInterval:+mint];
    m_currentDate = nowdt;
    [m_lunarDB setSolarDate:nowdt];
}

-(void)riliAction{
    if([self.delegate respondsToSelector:@selector(rilibtnAction)])
    {
        [self.delegate rilibtnAction];
    }
}
-(void)findbirth{
    if([self.delegate respondsToSelector:@selector(rilibtnAction)])
    {
        [self.delegate rilibtnAction];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
