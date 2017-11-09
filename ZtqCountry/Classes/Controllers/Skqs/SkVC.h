//
//  SkVC.h
//  ZtqCountry
//
//  Created by Admin on 15/6/15.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekWeatherView.h"
#import "BMAdScrollView.h"
#import "HourWtView.h"
@interface SkVC : UIViewController<ValueClickDelegate>
///bar的高度
@property(assign)float barHeight;
///导航条的背景图
@property(retain,nonatomic)UIImageView *navigationBarBg;
///背景滚动视图
@property(strong,nonatomic)UIScrollView *bgscr;
@property(strong,nonatomic)UIImageView *bgimg,*selectimg;
///一周和24小时button
@property(strong,nonatomic)UIButton *weekbtn,*hourbtn;
@property(strong,nonatomic)NSString *typetag;//一周还是24
@property(strong,nonatomic)WeekWeatherView *weekwtview;
@property(strong,nonatomic)BMAdScrollView *bmadscro;//广告
@property(strong,nonatomic)NSString *adurl,*adtitle,*adimgurl;
@property(strong,nonatomic)NSMutableArray *adtitles,*adimgurls,*adurls;
@property(strong,nonatomic)HourWtView *hourwt;
@property(strong,nonatomic)UILabel *lab;
@property(strong,nonatomic)NSArray *hourlist;
@end
