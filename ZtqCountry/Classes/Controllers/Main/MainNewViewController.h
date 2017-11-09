//
//  MainNewViewController.h
//  ZtqCountry
//
//  Created by Admin on 15/5/20.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityManageViewController.h"
#import "AddCityViewController.h"
#import "QBTitleView.h"
#import "TodayView.h"
#import "JHTickerView.h"
#import "MainView.h"
#import "DelitalViewController.h"
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <MapKit/MKPlacemark.h>
#import "Skview.h"
#import "AirView.h"
#import "MapView.h"
#import "ViedoView.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "RiLiView.h"
#import "CotachWeatherView.h"
#import "HourWtScrollview.h"
#import "ZXContentViewController.h"
@interface MainNewViewController : UIViewController<CityManageCellEditDelegate,QBTitleViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,skDelegate,airDelegate,mapviewDelegate,viedoDelegate,AMapLocationManagerDelegate,RiLidelegate,Cotachdelegate>{
    
    JHTickerView *ticker;
    CLLocationManager *m_locationManager;
    TreeNode *m_allCity;
    TreeNode *m_allprovice;
    NSString *trackViewURL;
    NSTimer *mynstimer;
    RiLiView *riliview;
    CotachWeatherView *mltqview;
}
@property(strong,nonatomic)QBTitleView *qbtitle;
@property(nonatomic,retain)AMapLocationManager *locationManager;
@property(retain,nonatomic)NSString *DWcity,*DWid;
@property(assign)BOOL isnetworking;
@property (strong, nonatomic) UISwipeGestureRecognizer * leftSwipe;
@property (strong, nonatomic) UISwipeGestureRecognizer * rightSwipe;
@property(strong,nonatomic)UIView *bgview;
@property(strong,nonatomic)UIView *weatherview;
@property(strong,nonatomic)TodayView *icoimgv;
@property(strong,nonatomic)UIImageView *adimgv;
@property(strong,nonatomic)UIImageView *hximg;
@property(strong,nonatomic)MainView *mainview;
@property(strong,nonatomic)Skview *skview;
@property(strong,nonatomic)AirView *airview;
@property(strong,nonatomic)MapView *mapview;
@property(strong,nonatomic)ViedoView *viedoview;

@property(assign,nonatomic)BOOL isswipe;//是否滑动
@property(assign,nonatomic)BOOL isdw;//是否定位
@property(assign,nonatomic)BOOL isdownview;//是否下拉
@property(strong,nonatomic)NSArray *warnlist;//预警列表
@property(strong,nonatomic)NSMutableArray *btns;//预警按钮

@property(strong,nonatomic)NSMutableArray *lifeinfos;//生活指数
@property (assign, nonatomic) int shzsNum;
@property(assign)float mheight;//生活指数高度

@property(strong,nonatomic)NSString *adurl,*adtitle,*adimgurl;
@property(strong,nonatomic)NSMutableArray *adtitles,*adimgurls,*adurls,*adshares;
@property(strong,nonatomic)NSMutableArray *ysadurls,*ysadimgurls,*ysadtitles,*ysadshares;
@property(strong,nonatomic)NSString *hum_l,*temp_h,*temp_l,*vis_l,*o_yjxx,*b_yjxx,*y_yjxx,*r_yjxx,*p_yjxx,*jieri,*jieqi,*chanpin,*zt;
@property(strong,nonatomic)NSDictionary *skinfo, *sjqxrInfo;//实况信息, 世界气象日分享内容

@property(strong,nonatomic)NSString *sharecontent;//分享内容
@property(assign)float viewHeight,contentHeight;
@property(strong,nonatomic)UIAlertView*mainal;
@property(strong,nonatomic)UILabel *updatelab,*wxtslab;
@property(strong,nonatomic)NSString *uptimestr;
@property(strong,nonatomic)NSString *bgurl,*ysj_weburl,*zjid,*tqzxid,*webtitle,*websharecontent,*allcityname;
@property(strong,nonatomic)NSString *centeradurl,*centeradtitle,*centershare;
@property(strong,nonatomic)NSTimer *adtimeopen,*adtimeclose;
@property(assign)BOOL isopen;//是否启动
@property(strong,nonatomic)UIImage *bgimg;
+(id)shareVC;
@property(strong,nonatomic)NSString *provice,*dwstress;
@property(strong,nonatomic)UIButton *hourbtn,*fivthBtn;
@property(assign)BOOL isnotice;//
//@property(strong,nonatomic)RiLiView *riliview;
@end
