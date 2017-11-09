//
//  QualityOfLifeView.m
//  ZtqCountry
//
//  Created by linxg on 14-7-3.
//  Copyright (c) 2014年 yyf. All rights reserved.
//
//宽 300

#import "QualityOfLifeView.h"
#define QOLBaseTag 2000

#import "ChineseHoliDay.h"

@implementation QualityOfLifeInfo


-(id)initWithIndex_name:(NSString *)index_name
                withDes:(NSString *)des
         withSimple_des:(NSString *)simple_des
           withIco_path:(NSString *)ico_path
        withCreate_time:(NSString *)create_time
                 withLv:(NSString *)lv
           withIco_name:(NSString *)ico_name
           withShzs_rul:(NSString *)shzs_url
{
    self = [super init];
    if(self)
    {
        self.index_name = index_name;
        self.des = des;
        self.simple_des = simple_des;
        self.ico_path = ico_path;
        self.create_time = create_time;
        self.lv = lv;
        self.ico_name = ico_name;
        self.shzs_url = shzs_url;
//        self.contentStrs = contentStrs;
//        self.contentImages = contentImages;
    }
    return self;
}

@end

@implementation QualityOfLifeView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withInfos:(NSArray *)infos withController:(id)controller wiheHeight:(float)heigh withSerinfos:(NSArray *)serinfos;
{
    self = [super initWithFrame:frame];
    if(self)
    {
//        NSDateComponents * componets = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
//        NSInteger month = [componets month];
        
        
         self.newinfos=[[NSMutableArray alloc]init];
        self.delegate = controller;
        m_lunarDB = [[LunarDB alloc] init];
        [self updateView:[NSDate date]];
        if ([m_lunarDB ChineseMonth].length>0) {
            [self getgz_in_imagewithid:[m_lunarDB ChineseMonth]];
        }
        
        
        self.controller = controller;
        self.infos = infos;
        float width = CGRectGetWidth(self.frame)/2.0;
        float hight = 60;
//        NSLog(@"%d",infos.count);
        self.backgroundColor = [UIColor clearColor];

//        UIButton *detailbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-90, 0, 70, 25)];
//        [detailbtn setTitle:@"    更多" forState:UIControlStateNormal];
//        detailbtn.titleLabel.font=[UIFont systemFontOfSize:14];
//        detailbtn.tag=1111;
//        [detailbtn setBackgroundImage:[UIImage imageNamed:@"按钮底座.png"] forState:UIControlStateNormal];
//        [detailbtn addTarget:self action:@selector(shzsButAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:detailbtn];
//        UIImageView *detailico=[[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 16, 16)];
//        detailico.image=[UIImage imageNamed:@"更多.png"];
//        [detailbtn addSubview:detailico];
        for(int i=0;i<infos.count+1;i++)
        {
            
            
            int line = (i+1)/2;//第几行
            int column = (i+1)%2;//第几列
            UIImageView * bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(column*width, line*hight, width, hight)];
            bgImgV.backgroundColor = [UIColor clearColor];
            bgImgV.userInteractionEnabled = YES;
            [self addSubview:bgImgV];
            
            if (i==0) {
              
//                UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 2, kScreenWidth, 40)];
//                bgimg.image=[UIImage imageNamed:@"首页背景条"];
//                bgimg.userInteractionEnabled=YES;
//                [self addSubview:bgimg];
//                
//                UILabel *loclab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
//                loclab.text=@"日历中心";
//                loclab.textColor=[UIColor whiteColor];
//                loclab.font=[UIFont systemFontOfSize:15];
//                [bgimg addSubview:loclab];
//                UIButton *birthbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-85, 7.5, 80, 25)];
//                [birthbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
//                [birthbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
//                [birthbtn setTitle:@"出生日天气" forState:UIControlStateNormal];
//                [birthbtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
//                birthbtn.titleLabel.font=[UIFont systemFontOfSize:14];
//                [birthbtn addTarget:self action:@selector(findbirth) forControlEvents:UIControlEventTouchUpInside];
//                [bgimg addSubview:birthbtn];
//                
//                UIImageView * rilibg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42, kScreenWidth, 110)];
//                rilibg.image=[UIImage imageNamed:@"日历入口背景"];
//                rilibg.userInteractionEnabled=YES;
////                [self addSubview:rilibg];
//                
//                UIButton *rilibtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 42, kScreenWidth, 110)];
//                [rilibtn addTarget:self action:@selector(riliAction) forControlEvents:UIControlEventTouchUpInside];
//                [self addSubview:rilibtn];
//                
//                UIImageView * lineimg2 = [[UIImageView alloc] initWithFrame:CGRectMake(85, 45, 5, 72)];
//                lineimg2.image=[UIImage imageNamed:@"首页竖"];
//                [self addSubview:lineimg2];
//                
//
//                
//                bgImgV.frame=CGRectMake(0, 0, width*2, hight+130);
                
            }
            else{
                bgImgV.frame=CGRectMake(column*width, line*hight-20, width, hight);
                UIImageView * lineimg = [[UIImageView alloc] initWithFrame:CGRectMake(5, line*hight-20, kScreenWidth-10, 0.7)];
                lineimg.backgroundColor = [UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1];
                lineimg.alpha=0.1;
                [self addSubview:lineimg];
                UIImageView * lineimg1 = [[UIImageView alloc] initWithFrame:CGRectMake(width, line*hight+1-20,0.8, hight-1)];
                lineimg1.backgroundColor = [UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1];
                lineimg1.alpha=0.1;
                [self addSubview:lineimg1];
            }
            if (i==infos.count&&infos.count>0){
                UIImageView * lineimg = [[UIImageView alloc] initWithFrame:CGRectMake(5, line*hight+hight-20, kScreenWidth-10, 0.7)];
                lineimg.backgroundColor = [UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1];
                lineimg.alpha=0.1;
                [self addSubview:lineimg];
            }
            
            UIImageView * lineimg1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, line*hight+30,1, hight)];
            lineimg1.backgroundColor = [UIColor whiteColor];
//            [self addSubview:lineimg1];
            UIImageView * lineimg2 = [[UIImageView alloc] initWithFrame:CGRectMake(width*2, line*hight+30,1, hight)];
            lineimg2.backgroundColor = [UIColor whiteColor];
//            [self addSubview:lineimg2];
            
            
            EGOImageView * iconImgV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
            [bgImgV addSubview:iconImgV];
            
            UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, width-60, 20)];
            titleLab.backgroundColor = [UIColor clearColor];
            titleLab.textAlignment = NSTextAlignmentRight;
            titleLab.textColor = [UIColor colorHelpWithRed:214 green:214 blue:214 alpha:1];
            titleLab.font = [UIFont systemFontOfSize:15];
            [bgImgV addSubview:titleLab];
            
            UILabel * introductionLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 35, width-60, 15)];
            introductionLab.backgroundColor = [UIColor clearColor];
            introductionLab.textAlignment = NSTextAlignmentRight;
            introductionLab.textColor = [UIColor colorHelpWithRed:214 green:214 blue:214 alpha:1];
            introductionLab.font = [UIFont systemFontOfSize:13];
            [bgImgV addSubview:introductionLab];
            
            UIImageView * layerImg =[[UIImageView alloc] initWithFrame:CGRectMake(3, 3, width, hight)];
            [bgImgV addSubview:layerImg];
            
            UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, hight)];
            but.tag = i;
//            if (i==infos.count+2) {
//                but.tag=1111;
//            }
            
            [but setBackgroundColor:[UIColor clearColor]];
            [but addTarget:self action:@selector(shzsButAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgImgV addSubview:but];
            
            if(i==0)
            {
                if (serinfos.count>0) {
                    
                    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
                    bgimg.image=[UIImage imageNamed:@"首页背景条"];
                    bgimg.userInteractionEnabled=YES;
                    [self addSubview:bgimg];
                    UILabel *shlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, 30)];
                    shlab.textColor=[UIColor whiteColor];
                    shlab.text=@"生活指数";
                    shlab.font=[UIFont systemFontOfSize:15];
                    [bgimg addSubview:shlab];
                    
                    UIButton *mangebtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-75, 7.5, 70, 25)];
                    [mangebtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
                    [mangebtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
                    [mangebtn setTitle:@"卡片管理" forState:UIControlStateNormal];
                    [mangebtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
                    mangebtn.titleLabel.font=[UIFont systemFontOfSize:14];
                    mangebtn.tag=1111;
                    [mangebtn addTarget:self action:@selector(shzsButAction:) forControlEvents:UIControlEventTouchUpInside];
                    [bgimg addSubview:mangebtn];
                }
               
//                self.rl_img = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"圆形加载图 小"]];
//                self.rl_img.frame=CGRectMake(kScreenWidth-80, 50, 75, 75);
//                [bgImgV addSubview:self.rl_img];
////                iconImgV.frame = CGRectMake(kScreenWidth-80, 10, 60, 60);
////                iconImgV.image = [UIImage imageNamed:@"日历.png"];
//                titleLab.frame=CGRectMake(105, 70, 250, 25);//星期
//                introductionLab.frame=CGRectMake(105, 45, 250, 25);//乙未年
//                titleLab.font=[UIFont systemFontOfSize:15];
//                introductionLab.font=[UIFont systemFontOfSize:15];
//                titleLab.textColor=[UIColor whiteColor];
//                introductionLab.textColor=[UIColor whiteColor];
//                
//                
////                UILabel *m_lab=[[UILabel alloc]initWithFrame:CGRectMake(30, 92, 60, 30)];
//                UILabel *m_lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, 90, 25)];
//                m_lab.textColor=[UIColor whiteColor];
//                m_lab.textAlignment=NSTextAlignmentCenter;
//                m_lab.font=[UIFont fontWithName:kWeatherFont size:14];
////                m_lab.text=[m_lunarDB SolorDateString];
//                m_lab.text=[self today:[NSDate date]];
//                [self addSubview:m_lab];
//                
//                UIImageView *xline=[[UIImageView alloc]initWithFrame:CGRectMake(20, 71, 50, 35)];
//                xline.image=[UIImage imageNamed:@"日期斜杠"];
//                xline.userInteractionEnabled=YES;
////                [self addSubview:xline];
//                //第几号
////                UILabel * haoLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 80, 35)];
//                UILabel * haoLab = [[UILabel alloc] initWithFrame:CGRectMake(2, 75, 80, 40)];
//                haoLab.backgroundColor = [UIColor clearColor];
//                haoLab.textAlignment = NSTextAlignmentCenter;
//                haoLab.textColor = [UIColor whiteColor];
//                haoLab.font = [UIFont fontWithName:kWeatherFont size:40];
//                haoLab.adjustsFontSizeToFitWidth = YES;
//                haoLab.text = [m_lunarDB SolorDayString];
//                [self addSubview:haoLab];
//                
//                
//                
//                UILabel *jieri=[[UILabel alloc]initWithFrame:CGRectMake(105, 95, 250, 25)];
//                jieri.textColor=[UIColor whiteColor];
//                jieri.font=[UIFont systemFontOfSize:15];
//                jieri.numberOfLines=0;
//             
//                if ([self getholiday].length>0) {
//                    jieri.text=[NSString stringWithFormat:@"%@/%@",[self getspecial],[self getholiday]];
//                }else{
//                    jieri.text=[self getspecial];
//                }
//                
//                [self addSubview:jieri];
//                
//
//                NSString * chineseDate = [m_lunarDB SolorWeekDayString];
//                titleLab.text = chineseDate;
//                
//                
//                titleLab.textAlignment=NSTextAlignmentLeft;
//                NSString * introductionStr =[m_lunarDB ChineseYear];
//                introductionLab.text = introductionStr;
//                
//                
//                introductionLab.textAlignment=NSTextAlignmentLeft;
//                UIImageView *aixin=[[UIImageView alloc]initWithFrame:CGRectMake(10, 125,20, 22)];
//                aixin.image=[UIImage imageNamed:@"爱心.png"];
//                [self addSubview:aixin];
//                UILabel *rililab=[[UILabel alloc]initWithFrame:CGRectMake(40, 120, kScreenWidth-40, 30)];
//                rililab.textColor=[UIColor yellowColor];
//                rililab.text=@"查询出生日天气，揭晓关于你的天意！";
//                rililab.font=[UIFont systemFontOfSize:14];
//                [self addSubview:rililab];
            }
            else
            {
                
                    if(i>0&&i<infos.count+1)
                    {

                        
                        
                        QualityOfLifeInfo * info = infos[i-1];
//                        UIImage * icoImg = [UIImage imageNamed:info.ico_name];
//                        if(icoImg!=nil)
//                        {
//                            iconImgV.image = icoImg;
//                        }
//                        else
//                        {
//                            [iconImgV setImageURL:[ShareFun makeImageUrl:info.ico_path]];
//                        }
                        [iconImgV setImageURL:[ShareFun makeImageUrl:info.ico_path]];
                        titleLab.text = [NSString stringWithFormat:@"%@指数",info.index_name];
                        introductionLab.text = info.simple_des;
                                             
                       
                    }
                
                
            }

            
        }
      
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
- (void)updateView:(NSDate *)dt
{
	m_currentDate = dt;
	[m_lunarDB setSolarDate:dt];
}


-(void)lifeQualityAction:(UIButton *)sender
{
    int indexPath = sender.tag - QOLBaseTag;
    QualityOfLifeInfo * info = self.infos[indexPath];
    //跳转界面
}


//-(NSString *)calculateChineseHoliDay
//{
//    NSString * chineseHoliDay = nil;
//    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
//    NSInteger day = [components day];
//    NSInteger month = [components month];
//    NSInteger year = [components year];
//    chineseHoliDay = [ChineseHoliDay getLunarSpecialDate:year Month:month Day:day];
//    if(chineseHoliDay == nil)
//    {
//        NSDate * tomorrow = [[NSDate date] dateByAddingTimeInterval:24*60*60];
//        NSDateComponents * componets = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:tomorrow];
//        NSInteger day = [components day];
//        NSInteger month = [components month];
//        NSInteger year = [components year];
//        NSString * chd = [ChineseHoliDay getLunarSpecialDate:year Month:month Day:day];
//        if(chd.length)
//        {
//            chineseHoliDay = [NSString stringWithFormat:@"明日%@",chd];
//        }
//    }
//    return chineseHoliDay;
//}
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
-(void)shzsButAction:(UIButton *)sender
{
    QualityOfLifeInfo * info = nil;
    NSLog(@"%d",sender.tag);
    if(sender.tag >0 && sender.tag<self.infos.count+1)
    {
        info = self.infos[sender.tag -1];
    }
    if([self.delegate respondsToSelector:@selector(buttonActionWithTag:withQualityOflifeInfo:withInfos:)])
    {
        [self.delegate buttonActionWithTag:sender.tag withQualityOflifeInfo:info withInfos:self.newinfos];
    }
}
//-(void)riliAction{
//    if([self.delegate respondsToSelector:@selector(rilibtnAction)])
//    {
//        [self.delegate rilibtnAction];
//    }
//}
//-(void)findbirth{
//    if([self.delegate respondsToSelector:@selector(rilibtnAction)])
//    {
//        [self.delegate rilibtnAction];
//    }
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
