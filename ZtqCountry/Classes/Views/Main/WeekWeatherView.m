//
//  WeekWeatherView.m
//  ZtqCountry
//
//  Created by linxg on 14-7-3.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "WeekWeatherView.h"


@implementation weekWeatherInfo

-(id)initWithGdt:(NSString *)gdt
        withWeek:(NSString *)week
          withWd:(NSString *)wd
      withWd_ico:(NSString *)wd_ico
        withHigt:(NSString *)higt
        withLowt:(NSString *)lowt
        withWind:(NSString *)wind
    withWd_night:(NSString *)wd_night
  withWd_daytime:(NSString *)wd_daytime
withWd_night_ico:(NSString *)wd_night_ico
withWd_daytime_ico:(NSString *)wd_daytime_ico
withWt:(NSString *)wt withsunrise:(NSString *)sunrise withsunset:(NSString *)sunset

{
    self = [super init];
    if(self)
    {
        self.gdt = gdt;
        self.week = week;
        self.wd = wd;
        self.wd_ico = wd_ico;
        self.higt = higt;
        self.lowt = lowt;
        self.wind = wind;
        self.wd_night = wd_night;
        self.wd_daytime = wd_daytime;
        self.wd_night_ico = wd_night_ico;
        self.wd_daytime_ico = wd_daytime_ico;
        self.wt=wt;
        self.sunrise=sunrise;
        self.sunset=sunset;
    }
    return self;
}

@end

@interface WeekWeatherView ()

@property(strong ,nonatomic) UIScrollView * bgScroll;

@end

@implementation WeekWeatherView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _weeks = [[NSMutableArray alloc] init];
        _times = [[NSMutableArray alloc] init];
        _icons = [[NSMutableArray alloc] init];
        _nighticons=[[NSMutableArray alloc]init];
//        _weathers = [[NSMutableArray alloc] init];
        _wtdays = [[NSMutableArray alloc] init];
        _wtnights = [[NSMutableArray alloc] init];
        _upTemperatures = [[NSMutableArray alloc] init];
        _downTemperatures = [[NSMutableArray alloc] init];
        _butarr=[[NSMutableArray alloc]init];
        _infosarr=[[NSMutableArray alloc]init];
        _winds=[[NSMutableArray alloc]init];
        _sunrises=[[NSMutableArray alloc]init];
        _sunsets=[[NSMutableArray alloc]init];
        _gdts=[[NSMutableArray alloc]init];
        _indexs=[[NSMutableArray alloc]init];
        [self createquxian];

    }
    return self;
}
-(void)createquxian{
    float bgHeight = 390;
    UIImageView * background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, bgHeight)];
    background.userInteractionEnabled = YES;
    background.backgroundColor=[UIColor clearColor];
//    background.image = [UIImage imageNamed:@"首页-晴_02"];
    [self addSubview:background];
    
    
    self.dayico=[[UIImageView alloc]initWithFrame:CGRectMake(130, 10+230, 30, 30)];
    //    [background addSubview:self.dayico];
    self.nightico=[[UIImageView alloc]initWithFrame:CGRectMake(170, 10+230, 30, 30)];
    //    [background addSubview:self.nightico];
    
    
    UIScrollView * bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, bgHeight-5)];
    
    bgScrollView.backgroundColor = [UIColor clearColor];
    self.bgScroll = bgScrollView;
    bgScrollView.showsHorizontalScrollIndicator = YES;
    bgScrollView.showsVerticalScrollIndicator = YES;
    [background addSubview:bgScrollView];
    //一周曲线view
    WeekView *v_week=[[WeekView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 100)];
    self.m_weekview=v_week;
    [bgScrollView addSubview:v_week];
    
    float space = CGRectGetWidth(self.frame)/7.2;
    bgScrollView.contentSize = CGSizeMake(space*7, bgHeight-5);
    for(int i=0;i<7;i++)
    {
        UILabel * weekLab = [[UILabel alloc] initWithFrame:CGRectMake(i*space, 5, space, 20)];
        
        weekLab.backgroundColor = [UIColor clearColor];
        weekLab.adjustsFontSizeToFitWidth = YES;
        if(i==0){
//            UIImageView *todaySelectBackgroundView=[[UIImageView alloc] initWithFrame:CGRectMake(28, 0, space-16,235)];
//            todaySelectBackgroundView.image=[UIImage imageNamed:@"一周选择.png"];
//            [bgScrollView addSubview:todaySelectBackgroundView];
            weekLab.textColor = [UIColor whiteColor];
            
        }
        else{
            weekLab.textColor = [UIColor whiteColor];
        }
        weekLab.textAlignment = NSTextAlignmentCenter;
        //        weekLab.text=@"周一";
        weekLab.font = [UIFont systemFontOfSize:15];
        [bgScrollView addSubview:weekLab];
        [_weeks addObject:weekLab];
        UILabel * gdtLab = [[UILabel alloc] initWithFrame:CGRectMake(i*space, 30, space, 30)];
        
        gdtLab.backgroundColor = [UIColor clearColor];
        gdtLab.adjustsFontSizeToFitWidth = YES;
        
        gdtLab.textColor = [UIColor whiteColor];
        
        gdtLab.textAlignment = NSTextAlignmentCenter;
        //                gdtLab.text=@"3/18";
        gdtLab.font = [UIFont systemFontOfSize:13];
                [bgScrollView addSubview:gdtLab];
        [self.gdts addObject:gdtLab];
        
        UIImageView *iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake((space/2.0)-15+i*space, 60, 30, 30)];
        [bgScrollView addSubview:iconImgV];
        [_icons addObject:iconImgV];
        UIImageView *nighticonImgV = [[UIImageView alloc] initWithFrame:CGRectMake((space/2.0)-15+i*space, 205, 30, 30)];
        [bgScrollView addSubview:nighticonImgV];
        [_nighticons addObject:nighticonImgV];
        
        //无效的button
        UIButton *bgbut=[[UIButton alloc]initWithFrame:CGRectMake(i*space, -40, space, 200)];
        bgbut.tag=i;
        self.bgbtn=bgbut;
        [bgbut addTarget:self action:@selector(delitaAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.m_weekview addSubview:bgbut];
//        [self.butarr addObject:bgbut];
        
       //无效的label;
        UILabel * wtdaylab = [[UILabel alloc] initWithFrame:CGRectMake(i*space, 60, space, 30)];
        wtdaylab.adjustsFontSizeToFitWidth = YES;
        wtdaylab.numberOfLines=0;
        wtdaylab.textColor = [UIColor whiteColor];
        wtdaylab.textAlignment = NSTextAlignmentCenter;
        wtdaylab.font = [UIFont systemFontOfSize:13];
        [bgScrollView addSubview:wtdaylab];
        [self.wtdays addObject:wtdaylab];
        //无效的label;
        UILabel * wtnightlab = [[UILabel alloc] initWithFrame:CGRectMake(i*space, 160, space, 30)];
        wtnightlab.adjustsFontSizeToFitWidth = YES;
        wtnightlab.numberOfLines=0;
        wtnightlab.textColor = [UIColor redColor];
        wtnightlab.textAlignment = NSTextAlignmentCenter;
        wtnightlab.font = [UIFont systemFontOfSize:13];
        [bgScrollView addSubview:wtnightlab];
        [self.wtnights addObject:wtnightlab];
        

        UILabel * windLab = [[UILabel alloc] initWithFrame:CGRectMake(i*space, 240, space, 20)];
        
        windLab.backgroundColor = [UIColor clearColor];
        windLab.adjustsFontSizeToFitWidth = YES;
        
        windLab.textColor = [UIColor whiteColor];
        
        windLab.textAlignment = NSTextAlignmentCenter;
//        windLab.text=@"3级";
        windLab.font = [UIFont systemFontOfSize:13];
        [bgScrollView addSubview:windLab];
        [_winds addObject:windLab];
        
        
        UILabel * sunriseLab = [[UILabel alloc] initWithFrame:CGRectMake(i*space, 265, space, 25)];
        
        sunriseLab.backgroundColor = [UIColor clearColor];
        sunriseLab.adjustsFontSizeToFitWidth = YES;
        
        sunriseLab.textColor = [UIColor whiteColor];
        
        sunriseLab.textAlignment = NSTextAlignmentCenter;
//        sunriseLab.text=@"5:25";
        sunriseLab.font = [UIFont systemFontOfSize:13];
        [bgScrollView addSubview:sunriseLab];
        [_sunrises addObject:sunriseLab];
        
        UILabel * sunsetLab = [[UILabel alloc] initWithFrame:CGRectMake(i*space, 295, space, 25)];
        
        sunsetLab.backgroundColor = [UIColor clearColor];
        sunsetLab.adjustsFontSizeToFitWidth = YES;
        
        sunsetLab.textColor = [UIColor whiteColor];
        
        sunsetLab.textAlignment = NSTextAlignmentCenter;
//        sunsetLab.text=@"5:25";
        sunsetLab.font = [UIFont systemFontOfSize:13];
        [bgScrollView addSubview:sunsetLab];
        [_sunsets addObject:sunsetLab];
        
    }
    UIImageView *windimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 245, 17, 17)];
    windimg.image=[UIImage imageNamed:@"风力图标"];
//    [bgScrollView addSubview:windimg];
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(15, 265, kScreenWidth-25, 1)];
    line.image=[UIImage imageNamed:@"24小时预报表时刻线"];
    [bgScrollView addSubview:line];
//    UIImageView *sunriseimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 320, 15, 17)];
//    sunriseimg.image=[UIImage imageNamed:@"日出图标"];
//    [bgScrollView addSubview:sunriseimg];
//    UIImageView *sunsetimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 350, 15, 17)];
//    sunsetimg.image=[UIImage imageNamed:@"日落图标"];
//    [bgScrollView addSubview:sunsetimg];
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(15, 325, kScreenWidth-25, 1)];
    line1.image=[UIImage imageNamed:@"24小时预报表时刻线"];
    [bgScrollView addSubview:line1];
    
}


-(void)setupViewWithInfos:(NSMutableArray *)infos
{
    float space = CGRectGetWidth(self.frame)/7.2;
    self.infosarr=infos;
    float maxValue = 0;
    float minValue = 50;
    NSMutableArray *hights=[[NSMutableArray alloc]init];
    NSMutableArray *lowts=[[NSMutableArray alloc]init];
    for(int i=0;i<infos.count;i++)
    {
//        if (i==1) {
//            [self delitaAction:self.butarr[1]];
//        }
        
        weekWeatherInfo * info = [infos objectAtIndex:i];
        UILabel * weekLab = self.weeks[i];
        //        UILabel * timeLab = self.times[i];
        UIImageView * iconImagV = self.icons[i];
        UIImageView * nighticonImagV = self.nighticons[i];
//        UILabel * weatherLab = self.weathers[i];
        UILabel * daylab = self.wtdays[i];
        UILabel * nightlab = self.wtnights [i];
        UILabel *windlab=self.winds[i];
//#pragma mark - 日出和日落
        UILabel *sunriselab=self.sunrises[i];
        UILabel *sunsetlab=self.sunsets[i];
        ///gdtlab 公历的日期
        UILabel *gdtlab=self.gdts[i];
        if (i==0) {
            weekLab.text=@"昨天";
            sunriselab.frame=CGRectMake(12, 265, space-12, 25);
            sunsetlab.frame=CGRectMake(12, 295, space-12, 25);
            
        }else if(i==1){
            weekLab.text=@"今天";
        }else if(i==2){
            weekLab.text=@"明天";
        }
        else{
            weekLab.text = info.week;
        }
        if (i<_indexs.count) {
//            if ([_indexs[i] isEqualToString:@"0"]) {
                weekLab.text = info.week;
//            }
        }
       
        NSString *wt=info.wt;
        if ([wt rangeOfString:@"转"].location!=NSNotFound) {
            NSArray *timeArray1=[wt componentsSeparatedByString:@"转"];
            if (timeArray1.count>0) {
                daylab.text=[timeArray1 objectAtIndex:0];
                nightlab.text=[timeArray1 objectAtIndex:1];
            }
            
        }else{
            daylab.text=wt;
            nightlab.text=wt;
        }
//        weatherLab.text=info.wt;
//        daylab.text=@"晴";
//        nightlab.text=@"多云";
        
        if (i == 0) {
            windlab.text = @"风力";
            sunriselab.text = @"日出";
            sunsetlab.text = @"日落";
        }else {
            sunriselab.text=info.sunrise;
            sunsetlab.text=info.sunset;
            windlab.text=info.wind;
        }
//        if (i==0) {
//            sunriselab.text=[NSString stringWithFormat:@"日出%@",info.sunrise];
//            sunsetlab.text=[NSString stringWithFormat:@"日落%@",info.sunset];
//        }
        NSString*date=[info.gdt substringFromIndex:4];
        NSString *month=[date substringFromIndex:2];
        NSString *riqi=[date substringToIndex:2];
        NSString *newdate=[NSString stringWithFormat:@"%@/%@",riqi,month];
        gdtlab.text=newdate;
        
        iconImagV.image=[UIImage imageNamed:info.wd_daytime_ico];
        nighticonImagV.image=[UIImage imageNamed:[NSString stringWithFormat:@"n%@",info.wd_night_ico]];
        NSString *hight=[NSString stringWithFormat:@"%@℃",info.higt];
        NSString *lowt=[NSString stringWithFormat:@"%@℃",info.lowt];
        [hights addObject:hight];
        [lowts addObject:lowt];
        if ([info.higt  floatValue] > maxValue) {
            maxValue = [info.higt floatValue];
        }
        if ([info.lowt  floatValue] < minValue) {
            minValue = [info.lowt floatValue];
        }
        
        
    }
    [self.m_weekview gethights:hights Withlowts:lowts Withmax:maxValue Withmin:minValue];
    
    
}
-(void)delitaAction:(UIButton *)sender{
    NSUInteger tag = [sender tag];

}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
