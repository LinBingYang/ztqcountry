//
//  WeekWeatherView.h
//  ZtqCountry
//
//  Created by linxg on 14-7-3.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekView.h"
@interface weekWeatherInfo : NSObject

//@property (strong, nonatomic) NSMutableArray * weekInfos;
//@property (strong, nonatomic) NSMutableArray * timeInfos;
//@property (strong, nonatomic) NSMutableArray * iconInfos;
//@property (strong, nonatomic) NSMutableArray * weatherInfos;
//@property (strong, nonatomic) NSMutableArray * temperatureInfos;
@property (strong, nonatomic) NSString * gdt;//公历日期
@property (strong, nonatomic) NSString * week;//星期
@property (strong, nonatomic) NSString * wd;//天气描述
@property (strong, nonatomic) NSString * wd_ico;//天气图标
@property (strong, nonatomic) NSString * higt;//最高温
@property (strong, nonatomic) NSString * lowt;//最低温
@property (strong, nonatomic) NSString * wind;//风描述
@property (strong, nonatomic) NSString * wd_night;//夜间天气
@property (strong, nonatomic) NSString * wd_daytime;//白天天气
@property (strong, nonatomic) NSString * wd_night_ico;//夜间天气图标
@property (strong, nonatomic) NSString * wd_daytime_ico;//白天天气图标
@property(strong,nonatomic)NSString *wt,*windows,*sunrise,*sunset;

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
          withWt:(NSString *)wt
     withsunrise:(NSString*)sunrise
      withsunset:(NSString *)sunset;

@end

@interface WeekWeatherView : UIView

@property (strong, nonatomic) NSMutableArray * weeks;
@property (strong, nonatomic) NSMutableArray * times;
@property (strong, nonatomic) NSMutableArray * icons;
@property (strong, nonatomic) NSMutableArray * nighticons;
@property (strong, nonatomic) NSMutableArray * weathers,*wtdays,*wtnights;
@property (strong, nonatomic) NSMutableArray * upTemperatures;
@property (strong, nonatomic) NSMutableArray * downTemperatures;
@property(strong,nonatomic)NSMutableArray *gdts,*winds,*sunrises,*sunsets;

@property(strong,nonatomic)NSMutableArray *butarr;
@property(strong,nonatomic)NSMutableArray *infosarr;
@property(strong,nonatomic)NSMutableArray *indexs;
@property(strong,nonatomic)UIImageView *dayico,*nightico;
@property(strong,nonatomic)WeekView *m_weekview;//新增曲线
@property(strong,nonatomic)UIButton *bgbtn;

-(void)setupViewWithInfos:(NSMutableArray *)infos;

@end
