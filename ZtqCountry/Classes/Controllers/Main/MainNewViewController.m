//
//  MainNewViewController.m
//  ZtqCountry
//
//  Created by Admin on 15/5/20.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "MainNewViewController.h"
#import "BTGlassScrollView.h"
#import "MFSideMenuContainerViewController.h"
#import "BMAdScrollView.h"
#import "UILabel+utils.h"
#import "NSDictionary+UrlEncodedString.h"
#import "DelitalViewController.h"
#import "QualityOfLifeView.h"
#import "ADViewController.h"
#import "MangerLifeViewController.h"
#import "ShareSheet.h"
#import "weiboVC.h"
#import "LivePhotoViewController.h"
#import "WebViewController.h"
#import "AIrViewController.h"
#import "SkVC.h"
#import "SkMoveVC.h"
#import "QXYSViewController.h"
#import "MapVC.h"
#import "Alert.h"
#import "TSMoreVC.h"
#import "ViedoADSrcollView.h"
#import "CalendarVC.h"
#import "YJpushViewController.h"
#import "ZXViewController.h"
#import "SettingViewController.h"
#import <Social/Social.h>
#import "customActivity.h"
#import "QXXZBViewController.h"
static MainNewViewController * shareMainViewController;
static float shzshight;
@interface MainNewViewController ()<UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,NSURLConnectionDelegate,QualityOfLifeViewDelegate,ValueClickDelegate,ShareSheetDelegate,MFMessageComposeViewControllerDelegate,alerdeleagte,YSClickDelegate,UIGestureRecognizerDelegate>
//保存数据列表
@property (nonatomic,strong) NSMutableArray* listData;

//接收从服务器返回数据。
@property (strong,nonatomic) NSMutableData *datas;
@property (strong, nonatomic) UIButton * left;
@property (strong, nonatomic) UIButton * right;
@property(strong,nonatomic)UIImage *shareimg;
@property(strong,nonatomic)BMAdScrollView *bmadscro;//首页底部的轮播图
@property(strong,nonatomic)ViedoADSrcollView *ysadscro;
@property(nonatomic,strong) NSMutableArray *yjImageArray;
@property(strong,nonatomic)QualityOfLifeView * weekWeather;

@property(strong,nonatomic)Alert *myalert;//弹窗
@property(nonatomic, strong)UIView *sjqxrView;
@property(strong,nonatomic)NSTimer *mytimer;
@end

@implementation MainNewViewController
{
    BTGlassScrollView *_glassScrollView;
    
}
-(NSMutableArray *)yjImageArray
{
    if (_yjImageArray==nil) {
        _yjImageArray=[NSMutableArray array];
    }
    return _yjImageArray;
}
+(id)shareVC
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareMainViewController = [[self alloc] init];
    });
    return shareMainViewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view
    
    NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
    [userDf setObject:[setting sharedSetting].currentCityID forKey:@"currentCityID"];
    [userDf setObject:[setting sharedSetting].currentCity forKey:@"currentCity"];
    [userDf setObject:[setting sharedSetting].morencityID forKey:@"xianshiid"];
    [userDf setObject:[setting sharedSetting].app forKey:@"appid"];
    [userDf synchronize];
    self.dwstress=[setting sharedSetting].dwstreet;
    self.isswipe=NO;
    self.isdownview=NO;
    self.isopen=YES;
    self.isnotice=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshallview) name:@"refreshview" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityliebiao) name:@"AddCity" object:nil];//添加城市
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushyjxx:) name:@"pushyjxx" object:nil];//推送预警
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushholiday:) name:@"pushholiday" object:nil];//推送节日
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upview) name:@"applicationWillEnterForeground" object:nil];//进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backview) name:@"againdw" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundWidgetAction) name:@"applicationWillEnterForegroundWidgetAction" object:nil];
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationwidgetTypeYJXX) name:@"NotificationwidgetTypeYJXX" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseview) name:@"applicationDidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSHZS) name:@"addlife" object:nil];//生活指数
    self.mytimer=[NSTimer scheduledTimerWithTimeInterval:5*60 target:self selector:@selector(autorefreshview) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadysad) name:@"closeAD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navtitleview) name:@"upswitch" object:nil];//左侧开关
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundAction) name:@"applicationDidEnterBackground" object:nil];//打开更新
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setAutomaticallyAdjustsScrollViewInsets: NO];
//    self.navigationItem.title=[setting sharedSetting].currentCity;
    //    NSShadow *shadow = [[NSShadow alloc] init];
//    [shadow setShadowOffset:CGSizeMake(1, 1)];
//    [shadow setShadowColor:[UIColor blackColor]];
//    [shadow setShadowBlurRadius:1];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSShadowAttributeName: shadow};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    _left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 40)];
    [_left setBackgroundImage:[UIImage imageNamed:@"城市添加.png"] forState:UIControlStateNormal];
    [_left setBackgroundImage:[UIImage imageNamed:@"城市添加二态.png"] forState:UIControlStateHighlighted];
    [_left addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *t_cityManageItem = [[UIBarButtonItem alloc] initWithCustomView:_left];
    self.navigationItem.leftBarButtonItem = t_cityManageItem;
    _right = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 40, 37)];
    
    [_right setBackgroundImage:[UIImage imageNamed:@"个人中心.png"] forState:UIControlStateNormal];
    [_right setBackgroundImage:[UIImage imageNamed:@"个人中心 二态.png"] forState:UIControlStateHighlighted];
    [_right addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingitem = [[UIBarButtonItem alloc] initWithCustomView:_right];
    self.navigationItem.rightBarButtonItem = settingitem;
    
    
//    [self loadbgview];//获取天气背景
    self.adimgurls=[[NSMutableArray alloc]init];
    self.adtitles=[[NSMutableArray alloc]init];
    self.adurls=[[NSMutableArray alloc]init];
    self.adshares=[[NSMutableArray alloc]init];
    self.btns=[[NSMutableArray alloc]init];
    self.ysadurls=[[NSMutableArray alloc]init];
    self.ysadimgurls=[[NSMutableArray alloc]init];
    self.ysadtitles=[[NSMutableArray alloc]init];
    self.ysadshares=[[NSMutableArray alloc]init];
//    UIView *view = [self customView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,2070)];
    view.backgroundColor=[UIColor clearColor];
    _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"00.jpg"] blurredImage:nil viewDistanceFromBottom:kScreenHeitht foregroundView:view];
    
    [self.view addSubview:_glassScrollView];
    [self creatbaseview];//创建基本视图
    [self loadCachebgview];
    [self configGesture];
    if (self.isnetworking==YES) {
       [self reloadview];
    }
    
//    if (self.isnetworking==NO) {
//        NSLog(@"无网络");
////        [self getcacheinfo];
//        [self getCacheContentHeight];
//    }else{
////        [self updateMainview];//刷新首页数据
//        [self reloadview];
////        [self getContentHeight];//获取内容高度以及加载首页信息
//    }
    
    [self versionDetection];//版本检测
    //推送标签
    [self queryPushTag];
    
}
-(void)viewWillAppear:(BOOL)animated{
//    [self navtitleview];
    self.navigationController.navigationBarHidden = NO;
    QBTitleView *titleView = [[QBTitleView alloc] initWithFrame:CGRectMake(0, 0, 170, 44)];
    titleView.delegate = self;
    self.qbtitle=titleView;
    self.navigationItem.titleView=titleView;
    [self navtitleview];
//    [self loadSHZS];
    /**
     *  widget跳转
     */
    AppDelegate *appdele=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if(appdele.Jumpwidget==widgetTypeLVQX)
    {
        [self TravelAction];
        
    }else if(appdele.Jumpwidget==widgetTypeFYCX)
    {
        WindowAndRainVC *wrvc=[[WindowAndRainVC alloc]init];
        [self.navigationController pushViewController:wrvc animated:YES];
        
    }else if (appdele.Jumpwidget==widgetTypeYJXX)
    {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationwidgetTypeYJXX" object:nil];
    }
    appdele.Jumpwidget=widgetTypeother;

    
}
-(void)upview{
    if (self.mytimer.isValid) {
        [self.mytimer invalidate];
        self.mytimer=nil;
        self.mytimer=[NSTimer scheduledTimerWithTimeInterval:5*60 target:self selector:@selector(autorefreshview) userInfo:nil repeats:YES];
    }
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        isopendw=NO;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"dwswitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *dwstr=@"0";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"againdwsuccess" object:dwstr];
    }else{
        isopendw=YES;
//        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"dwswitch"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        BOOL isdw=![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
        if (isdw==YES) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"dwswitch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
//    [self backview];
    [self performSelector:@selector(backview) withObject:nil afterDelay:60];

}
-(void)backview{
    _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, 10);
    //    [self startLocation];
    BOOL isdw=![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
    if (isdw==YES) {
        self.isnotice=NO;
        [self startLocation];
    }else{
        [self navtitleview];
        [self enterapp];
    }
}
-(void)applicationWillEnterForegroundWidgetAction
{   [self.menuContainerViewController togleCenterViewController];
    /**
     *  widget跳转
     */
    AppDelegate *appdele=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if(appdele.Jumpwidget==widgetTypeLVQX)
    {
        [self TravelAction];
        
    }else if(appdele.Jumpwidget==widgetTypeFYCX)
    {
        [self fyfindaction];
        
    }else if (appdele.Jumpwidget==widgetTypeYJXX)
    {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationwidgetTypeYJXX" object:nil];
    }
    appdele.Jumpwidget=widgetTypeother;
}
-(void)NotificationwidgetTypeYJXX
{
    NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
    NSDictionary *dws_city=[userDf objectForKey:@"dws_city"];

    NSString *desc,*color,*ico,*warninfo,*put,*putstr,*fyznstr;
    desc = [dws_city objectForKey:@"title"];
    color = [dws_city objectForKey:@"color"];
    ico = [dws_city objectForKey:@"ico"];
    warninfo   = [dws_city objectForKey:@"content"];
    put=[dws_city objectForKey:@"pt"];
    putstr=[dws_city objectForKey:@"station_name"];
    fyznstr=[dws_city objectForKey:@"defend"];
    TSMoreVC *yjdelital=[[TSMoreVC alloc]init];
    yjdelital.ico=ico;
    yjdelital.titlestr=@"气象预警";
    yjdelital.fyzninfo=fyznstr;
    yjdelital.putstring=[NSString stringWithFormat:@"%@  %@",putstr,put];
    yjdelital.warninfo=warninfo;
    [self.navigationController pushViewController:yjdelital animated:YES];

}
-(void)getContentHeight{
    self.viewHeight=600;
//    float height=2000;
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if ([setting sharedSetting].currentCityID.length>0) {
        [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    }
    
    [b setObject:gz_todaywt_inde forKey:@"gz_realwt_index"];
   
    NSMutableDictionary * airdic = [[NSMutableDictionary alloc] init];
    [airdic setObject:@"1" forKey:@"type"];
    if ([setting sharedSetting].currentCityID.length>0) {
        [airdic setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    }
    [b setObject:airdic forKey:@"gz_air_qua_index"];
    
    NSMutableDictionary * ysggdic = [[NSMutableDictionary alloc] init];
    [ysggdic setObject:@"12" forKey:@"position_id"];
    [b setObject:ysggdic forKey:@"gz_ad"];
    
     NSMutableDictionary * yidic = [[NSMutableDictionary alloc] init];
    [yidic setObject:@"gz_qxys_img" forKey:@"key"];
    [b setObject:yidic forKey:@"gz_queryconfig"];
    
    NSMutableDictionary * shdic = [[NSMutableDictionary alloc] init];
    if ([setting sharedSetting].currentCityID.length>0) {
        [shdic setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    }
     [b setObject:shdic forKey:@"gz_live_index"];
    
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
//    if (self.isdownview==NO) {
//         [MBProgressHUD showHUDAddedTo:[[ShareFun shareAppDelegate] window] animated:YES];
//    }
   
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_realwt_index = [b objectForKey:@"gz_realwt_index"];
            NSDictionary *realwt=[gz_realwt_index objectForKey:@"realwt"];
            NSString *ct=[realwt objectForKey:@"ct"];
            if (self.isnotice==YES) {
                self.isnotice=NO;
            }else{
                self.isnotice=YES;
            }
            if (![ct isEqualToString:@""]) {
                self.contentHeight=610+205;
            }else{
                self.contentHeight=580;
            }
             NSDictionary * air = [b objectForKey:@"gz_air_qua_index"];
            NSDictionary *air_qua=[air objectForKey:@"air_qua"];
//            NSString *health=[air_qua objectForKey:@"health_advice"];
//            NSString *quality=[air_qua objectForKey:@"quality"];
//            NSString *pollutant=[air_qua objectForKey:@"primary_pollutant"];
            NSString *aqi=[air_qua objectForKey:@"aqi"];
            if (![aqi isEqualToString:@""]) {
                self.contentHeight=self.contentHeight+205;//空气质量高度
            }
            
            self.contentHeight=self.contentHeight+290;//地图高度
            
            //影视广告
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];
            if (adlist.count>0) {
                self.contentHeight=self.contentHeight+60;
            }
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_queryconfig"];
            NSString *value=[gz_air_qua_index objectForKey:@"value"];
            if (value.length>0) {
                self.contentHeight=self.contentHeight+180;//影视高度
            }
            //生活指数高度
            NSDictionary * shzs = [b objectForKey:@"gz_live_index"];
            NSArray * idx = [shzs objectForKey:@"live"];
            self.lifeinfos=[self creatlife:idx];
            NSMutableDictionary * info = [[NSMutableDictionary alloc] init];
            NSDictionary *lifedic=[setting sharedSetting].lifedic;
            NSArray * lifeArr = [lifedic objectForKey:@"life"];
            [info setObject:[self configLifeWith:lifeArr WithAllLifeDic:returnData] forKey:@"moduInfo"];
            NSDictionary *moduInfo=[info objectForKey:@"moduInfo"];
            NSDictionary * b1 = [moduInfo objectForKey:@"b"];
            NSDictionary * shzs1 = [b1 objectForKey:@"gz_live_index"];
            NSArray * idx1 = [shzs1 objectForKey:@"live"];
            NSInteger number = idx1.count;
            NSDictionary *lifedic1=[setting sharedSetting].lifedic;
            NSArray * lifeArr1 = [lifedic1 objectForKey:@"life"];
            if (lifeArr1.count>0) {
                int n=0;
                for(int i=0;i<lifeArr1.count-1;i++){ //循环开始元素
                    for(int j = i + 1;j < lifeArr1.count;j++){ //循环后续所有元素
                        //如果相等，则重复
                        if(lifeArr1[i] == lifeArr1[j]){
                            n=n+1;
                        }
                    }
                }
                number = lifeArr1.count-n;
            }
            if (lifeArr1==nil ) {
                if(idx.count >=4)
                {
                    number=4;
                }
                else
                {
                    number = idx.count;
                }
                
            }
            float height = 15+70+67*((number+2)/2+(number+2)%2)-67;
            
            
            if (idx1.count>=number) {
                
            }else{
                if(idx1.count >=4)
                {
                    number=4;
                }
                else
                {
                    number = idx1.count;
                }
            }
            if (idx.count>0) {
                 height = 15+70+67*((number+2)/2+(number+2)%2)-67;
//                 float height = 15+30+67*((idx.count+2)/2+(idx.count+2)%2)-67;
                self.contentHeight=self.contentHeight+height+250+10;//广告高度，和生活指数
            }else{
                self.contentHeight=self.contentHeight+250+10+115;
            }
            if (self.isnotice==YES) {
                [self loadbgview];
            }
            
        }
        
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        self.hximg.hidden=YES;
        [MBProgressHUD hideHUDForView:[[ShareFun shareAppDelegate] window] animated:YES];
    } withCache:YES];
//    return height;
}
-(float)getCacheContentHeight{
    self.viewHeight=600;
    float height=2000;
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if ([setting sharedSetting].currentCityID.length>0) {
        [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    }
    
    [b setObject:gz_todaywt_inde forKey:@"gz_realwt_index"];
    
    NSMutableDictionary * airdic = [[NSMutableDictionary alloc] init];
    [airdic setObject:@"1" forKey:@"type"];
    if ([setting sharedSetting].currentCityID.length>0) {
        [airdic setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    }
    [b setObject:airdic forKey:@"gz_air_qua_index"];
    
    NSMutableDictionary * yidic = [[NSMutableDictionary alloc] init];
    [yidic setObject:@"gz_qxys_img" forKey:@"key"];
    [b setObject:yidic forKey:@"gz_queryconfig"];
    
    NSMutableDictionary * shdic = [[NSMutableDictionary alloc] init];
    [shdic setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [b setObject:shdic forKey:@"gz_live_index"];
    
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
     [[NetWorkCenter share] getCacheWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData){
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_realwt_index = [b objectForKey:@"gz_realwt_index"];
            NSDictionary *realwt=[gz_realwt_index objectForKey:@"realwt"];
            NSString *ct=[realwt objectForKey:@"ct"];
            if (![ct isEqualToString:@""]) {
                self.contentHeight=610+205;
            }else{
                self.contentHeight=610;
            }
            NSDictionary * air = [b objectForKey:@"gz_air_qua_index"];
            NSDictionary *air_qua=[air objectForKey:@"air_qua"];
            //            NSString *health=[air_qua objectForKey:@"health_advice"];
            //            NSString *quality=[air_qua objectForKey:@"quality"];
            //            NSString *pollutant=[air_qua objectForKey:@"primary_pollutant"];
            NSString *aqi=[air_qua objectForKey:@"aqi"];
            if (![aqi isEqualToString:@""]) {
                self.contentHeight=self.contentHeight+205;
            }
            
            self.contentHeight=self.contentHeight+300;
            
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_queryconfig"];
            NSString *value=[gz_air_qua_index objectForKey:@"value"];
            if (value.length>0) {
                self.contentHeight=self.contentHeight+190;
            }
            //生活指数高度
            NSDictionary * shzs = [b objectForKey:@"gz_live_index"];
            NSArray * idx = [shzs objectForKey:@"live"];
            self.lifeinfos=[self creatlife:idx];
            NSMutableDictionary * info = [[NSMutableDictionary alloc] init];
            NSDictionary *lifedic=[setting sharedSetting].lifedic;
            NSArray * lifeArr = [lifedic objectForKey:@"life"];
            [info setObject:[self configLifeWith:lifeArr WithAllLifeDic:returnData] forKey:@"moduInfo"];
            NSDictionary *moduInfo=[info objectForKey:@"moduInfo"];
            NSDictionary * b1 = [moduInfo objectForKey:@"b"];
            NSDictionary * shzs1 = [b1 objectForKey:@"gz_live_index"];
            NSArray * idx1 = [shzs1 objectForKey:@"live"];
            NSInteger number = idx1.count;
            NSDictionary *lifedic1=[setting sharedSetting].lifedic;
            NSArray * lifeArr1 = [lifedic1 objectForKey:@"life"];
            if (lifeArr1.count>0) {
                int n=0;
                for(int i=0;i<lifeArr1.count-1;i++){ //循环开始元素
                    for(int j = i + 1;j < lifeArr1.count;j++){ //循环后续所有元素
                        //如果相等，则重复
                        if(lifeArr1[i] == lifeArr1[j]){
                            n=n+1;
                        }
                    }
                }
                number = lifeArr1.count-n;
            }
            if (lifeArr1==nil ) {
                if(idx.count >=4)
                {
                    number=4;
                }
                else
                {
                    number = idx.count;
                }
                
            }
            float height = 15+70+67*((number+2)/2+(number+2)%2)-67;
            
            
            if (idx1.count>=number) {
                
            }else{
                if(idx1.count >=4)
                {
                    number=4;
                }
                else
                {
                    number = idx1.count;
                }
            }
            if (idx.count>0) {
                height = 15+70+67*((number+2)/2+(number+2)%2)-67;
                //                 float height = 15+30+67*((idx.count+2)/2+(idx.count+2)%2)-67;
                self.contentHeight=self.contentHeight+height+250+10;//广告高度，和生活指数
            }else{
                self.contentHeight=self.contentHeight+250+50;
            }
        }
        
        [self loadCachebgview];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
    return height;
}

-(void)updingwei{
//    self.isdw=YES;
//    if (self.isdw==YES) {
        [self startLocation];
//    }
//    [self getContentHeight];
   
}

-(void)pushyjxx:(NSNotification *)object{
    self.isswipe=YES;
    NSDictionary *dws=object.object;
    NSString *desc,*color,*ico,*warninfo,*put,*putstr,*fyznstr;
    desc = [dws objectForKey:@"title"];
    color = [dws objectForKey:@"color"];
    ico = [dws objectForKey:@"ico"];
    warninfo   = [dws objectForKey:@"content"];
    put=[dws objectForKey:@"pt"];
    putstr=[dws objectForKey:@"station_name"];
    fyznstr=[dws objectForKey:@"defend"];
    TSMoreVC *yjdelital=[[TSMoreVC alloc]init];
    yjdelital.titlestr=@"气象预警";
    yjdelital.ico=ico;
    yjdelital.titlestr=desc;
    yjdelital.fyzninfo=fyznstr;
    if (putstr.length>0) {
        yjdelital.putstring=[NSString stringWithFormat:@"%@  %@",putstr,put];
    }
    yjdelital.warninfo=warninfo;
    [self.navigationController pushViewController:yjdelital animated:YES];
}
-(void)pushholiday:(NSNotification *)object{
    self.isswipe=YES;
    NSDictionary *dws=object.object;
    NSString *desc,*ico,*warninfo,*put,*putstr,*desc2,*timestr1,*nl;
    desc = [dws objectForKey:@"title"];
    ico = [dws objectForKey:@"img"];
    warninfo   = [dws objectForKey:@"des"];
    desc2=[dws objectForKey:@"des2"];
    put=[dws objectForKey:@"name"];
    putstr=[dws objectForKey:@"time"];
    if (putstr.length>0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *fromdate=[dateFormatter dateFromString:putstr];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        [outputFormatter setDateFormat:@"MM月dd日"];
        timestr1 = [outputFormatter stringFromDate:fromdate];
        nl=[self getChineseCalendarWithDate:fromdate];
    }
    
    TSMoreVC *yjdelital=[[TSMoreVC alloc]init];
    yjdelital.titlestr=@"温馨提示";
    yjdelital.ico=ico;
    yjdelital.titlestr=desc;
    if (timestr1.length>0) {
        yjdelital.putstring=[NSString stringWithFormat:@"%@农历%@发布",timestr1,nl];
    }
    yjdelital.warninfo=warninfo;
    yjdelital.fyzninfo=desc2;
    [self.navigationController pushViewController:yjdelital animated:YES];
}
//选择热门城市后的刷新
-(void)cityliebiao{
    NSLog(@"刷新城市数据");
    if (![[setting sharedSetting].currentCityID isEqualToString:[setting sharedSetting].dingweicity]) {
        self.dwstress=nil;
    }else{
        self.dwstress=[setting sharedSetting].dwstreet;
    }
    
    [[setting sharedSetting] saveSetting];
    NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
    [userDf setObject:[setting sharedSetting].currentCityID forKey:@"currentCityID"];
    [userDf setObject:[setting sharedSetting].currentCity forKey:@"currentCity"];
    [userDf setObject:[setting sharedSetting].morencityID forKey:@"xianshiid"];
    [userDf synchronize];
    self.isswipe=NO;
    self.isdownview=NO;
    self.isnotice=NO;
    [self navtitleview];
    [self refreshview];
    [self queryPushTag];
//    [self loadbgview];
//    [_glassScrollView updateview];
    
//    [self getContentHeight];
//    [_glassScrollView removeFromSuperview];
//    [self updateMainview];
//    UIView *view = [self customView];
//    _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"浮尘.jpg"] blurredImage:nil viewDistanceFromBottom:kScreenHeitht+100 foregroundView:view];
//    [self.view addSubview:_glassScrollView];
////    [self.bgview setFrame:CGRectMake(0, 0, kScreenWidth, 2000)];
////    [_glassScrollView.foregroundScrollView addSubview:self.bgview];
//    [self creatbaseview];
}
-(void)xuanzhuan{
    self.hximg.hidden=NO;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100;
    [self.hximg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
   
}
//标签查询
-(void)queryPushTag{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    if ([setting sharedSetting].devToken.length>0) {
        [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    }
    
    [b setObject:setProperty forKey:@"gz_query_pushtag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *setpust=[b objectForKey:@"gz_query_pushtag"];
        NSArray *tags=[setpust objectForKey:@"tags"];
        if (tags.count>0) {
            for (int i=0; i<tags.count; i++) {
                NSString *tagkey=[tags[i] objectForKey:@"tag_key"];
                NSString *tag_value=[tags[i] objectForKey:@"tag_value"];
                if ([tagkey isEqualToString:@"yjxx_r"]) {
                    self.r_yjxx=tag_value;
                }
                if ([tagkey isEqualToString:@"yjxx_o"]) {
                    self.o_yjxx=tag_value;
                }
                if ([tagkey isEqualToString:@"yjxx_b"]) {
                    self.b_yjxx=tag_value;
                }
                if ([tagkey isEqualToString:@"yjxx_y"]) {
                    self.y_yjxx=tag_value;
                }
                if ([tagkey isEqualToString:@"push_fj_prowarn"]) {
                    self.p_yjxx=tag_value;
                }
                if ([tagkey isEqualToString:@"hum_l"]) {
                    self.hum_l=tag_value;
                }
                
               
                if ([tagkey isEqualToString:@"temp_h"]) {
                    self.temp_h=tag_value;
                }
                if ([tagkey isEqualToString:@"temp_l"]) {
                    self.temp_l=tag_value;
                }
                if ([tagkey isEqualToString:@"tips_holiday"]) {
                    self.jieri=tag_value;
                    
                }
                if ([tagkey isEqualToString:@"tips_jieqi"]) {
                    self.jieqi=tag_value;
                    
                }
                if ([tagkey isEqualToString:@"tips_notice"]) {
                    self.chanpin=tag_value;
                }
                if ([tagkey isEqualToString:@"tips_special"]) {
                    self.zt=tag_value;
                }
               
            }
            
        }
        [self sendpush];
        
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    
}
-(void)sendpush{
    NSString *ID=[setting sharedSetting].currentCityID;
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    
    if (ID.length>0) {
        [tip setObject:ID forKey:@"push_city"];
    }
    
    
   
    if (!self.hum_l.length>0) {
        self.hum_l=@"";
    }
    if (!self.temp_h.length>0) {
        self.temp_h=@"";
    }
    if (!self.temp_l.length>0) {
        self.temp_l=@"";
    }
        if (!self.vis_l.length>0) {
        self.vis_l=@"";
    }
    
    [tip setObject:self.temp_h forKey:@"temp_h"];
    [tip setObject:self.temp_l forKey:@"temp_l"];
    [tip setObject:self.vis_l forKey:@"vis_l"];
    [tip setObject:self.hum_l forKey:@"hum_l"];
    if (!self.r_yjxx.length>0) {
        self.r_yjxx=@"1";
    }
    if (!self.o_yjxx.length>0) {
        self.o_yjxx=@"1";
    }
    if (!self.b_yjxx.length>0) {
        self.b_yjxx=@"0";
    }
    if (!self.y_yjxx.length>0) {
        self.y_yjxx=@"0";
    }
    if (!self.p_yjxx.length>0) {
        self.p_yjxx=@"1";
    }
    [tip setObject:self.r_yjxx forKey:@"yjxx_r"];
    [tip setObject:self.o_yjxx forKey:@"yjxx_o"];
    [tip setObject:self.y_yjxx forKey:@"yjxx_y"];
    [tip setObject:self.b_yjxx forKey:@"yjxx_b"];
   [tip setObject:self.p_yjxx forKey:@"push_fj_prowarn"];
    
    if (!self.jieqi.length>0) {
        self.jieqi=@"1";
    }
    if (!self.jieri.length>0) {
        self.jieri=@"1";
    }
    if (!self.chanpin.length>0) {
        self.chanpin=@"1";
    }
    if (!self.zt.length>0) {
        self.zt=@"1";
    }
    [tip setObject:self.jieri forKey:@"tips_holiday"];
    [tip setObject:self.jieqi forKey:@"tips_jieqi"];
    [tip setObject:self.chanpin forKey:@"tips_notice"];
    [tip setObject:self.zt forKey:@"tips_special"];
    [setProperty setObject:tip forKey:@"tags"];
    if ([setting sharedSetting].devToken.length>0) {
        [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    }
    [b setObject:setProperty forKey:@"gz_set_pushtag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
       
        
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    
    
}
-(void)timestrat{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:(self.icoimgv.hidden ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromLeft) forView:self.weatherview cache:YES];
    self.icoimgv.hidden = !self.icoimgv.hidden;
    self.adimgv.hidden = !self.adimgv.hidden;
    [UIView commitAnimations];

}
-(void)icoAction{
    if (self.adtimeopen.isValid) {
        [self.adtimeopen invalidate];
    }
    self.adtimeopen=nil;
    if (self.adtimeclose.isValid) {
        [self.adtimeclose invalidate];
    }
    self.adtimeclose=nil;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:(self.icoimgv.hidden ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromLeft) forView:self.weatherview cache:YES];
    self.icoimgv.hidden = !self.icoimgv.hidden;
    self.adimgv.hidden = !self.adimgv.hidden;
    [UIView commitAnimations];
    
    
}
-(void)enterapp{
    self.isopen=NO;
    [self xuanzhuan];
    NSString *uptimestr=[[NSUserDefaults standardUserDefaults]  objectForKey:@"lastUptimeStr"];
    self.updatelab.text=uptimestr;
    if ([setting sharedSetting].currentCityID.length>0) {
//        [self getContentHeight];
        self.mheight=0;
        [self loadbgview];
    }
}
-(void)reloadview{
    self.isdownview=YES;
    self.isnotice=NO;
    [self xuanzhuan];
     NSString *uptimestr=[[NSUserDefaults standardUserDefaults]  objectForKey:@"lastUptimeStr"];
    
    self.updatelab.text=uptimestr;
    if ([setting sharedSetting].currentCityID.length>0) {
//        [self getContentHeight];
        [self loadbgview];
    }
    
}
-(void)refreshallview{
    if (self.mytimer.isValid) {
        [self.mytimer invalidate];
        self.mytimer=nil;
        self.mytimer=[NSTimer scheduledTimerWithTimeInterval:5*60 target:self selector:@selector(autorefreshview) userInfo:nil repeats:YES];
    }
    self.isopen=NO;
//    self.isdownview=YES;
    self.isnotice=NO;
    BOOL isdw=![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
    if (isdw==NO) {
        self.dwstress=nil;
    }
    [self xuanzhuan];
     NSString *uptimestr=[[NSUserDefaults standardUserDefaults]  objectForKey:@"lastUptimeStr"];
    self.updatelab.text=uptimestr;
    if ([setting sharedSetting].currentCityID.length>0) {
//        [self getContentHeight];
        [self loadbgview];
    }
   
}
-(void)autorefreshview{
    self.isopen=NO;
    self.isdownview=YES;
    self.isnotice=NO;
    [self xuanzhuan];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"upleftview" object:nil];
    NSString *uptimestr=[[NSUserDefaults standardUserDefaults]  objectForKey:@"lastUptimeStr"];
    self.updatelab.text=uptimestr;
    if ([setting sharedSetting].currentCityID.length>0) {
//        [self getContentHeight];
        [self loadbgview];
    }
    
}
-(void)refreshview{
//    [self loadbgview];
//     [self xuanzhuan];
    self.isopen=NO;
    self.isnotice=NO;
    [self.updatelab removeFromSuperview];
    _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht+200);
//    [self getContentHeight];
    [self loadbgview];

}
#pragma mark - 加载主界面的信息
-(void)updateMainview{
     [self loadSKinfo];//实况信息
    [self gethours];
    [self getyjxx];
//    if (self.mapview) {
//        [self.mapview startLocation];
//    }
    [self.mainview loadSubTwoView:YES];
   
    [self loadadvice];
     [self loadadA005];//首页右边促销
    [self loadAD_A005_29];
}
//无网络情况下读取缓存
-(void)getcacheinfo{

    [self.mainview cacheServen];
    [self cacheSKinfo];
}
-(void)configGesture
{
    UISwipeGestureRecognizer * leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(centerViewControllerLeftSwiped:)];
    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    self.leftSwipe = leftSwipeRecognizer;
    leftSwipeRecognizer.delegate=self;
    UISwipeGestureRecognizer * rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(centerViewControllerRighttSwiped:)];
    [rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    self.rightSwipe = rightSwipeRecognizer;
    rightSwipeRecognizer.delegate=self;
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    [self.view addGestureRecognizer:rightSwipeRecognizer];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)centerViewControllerLeftSwiped:(id)sender{
    self.isswipe=YES;
     [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
    SettingViewController *settingVC=(SettingViewController *)self.menuContainerViewController.rightMenuViewController;
    [settingVC updateUserName];
}
-(void)centerViewControllerRighttSwiped:(id)sender{
    self.isswipe=YES;
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}
- (void)viewWillLayoutSubviews
{
    // if the view has navigation bar, this is a great place to realign the top part to allow navigation controller
    // or even the status bar
    if (self.isswipe==YES) {
        
    }else{
//        NSLog(@"%f",[self.topLayoutGuide length]);
    [_glassScrollView setTopLayoutGuideLength:[self.topLayoutGuide length]];
//        [self.bgview setFrame:CGRectMake(0, 0, kScreenWidth, 2000)];
    }
}
#pragma mark - 创建基本视图
-(void)creatbaseview{
    
    UIImageView *ztqbg1=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-220)/2, 80, 220, 220)];
    ztqbg1.image=[UIImage imageNamed:@"外环 知天气.png"];
    [_glassScrollView.foregroundScrollView addSubview:ztqbg1];
    
    
    self.weatherview=[[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-220)/2, 80, 220, 220)];
    self.weatherview.backgroundColor=[UIColor clearColor];
    [_glassScrollView.foregroundScrollView addSubview:self.weatherview];
   
    UIImageView *ztqbg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 220, 220)];
    ztqbg.image=[UIImage imageNamed:@"内圆.png"];
    [self.weatherview addSubview:ztqbg];
    
    UIImageView *hximg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 220, 220)];
    hximg.image=[UIImage imageNamed:@"外环弧线.png"];
    self.hximg=hximg;
    hximg.hidden=YES;
    [self.weatherview addSubview:hximg];
    
    self.icoimgv=[[TodayView alloc]initWithFrame:CGRectMake(20, 20, 180, 180)];
    self.icoimgv.backgroundColor=[UIColor clearColor];
    self.icoimgv.hidden=NO;
    [self.weatherview addSubview:self.icoimgv];
    self.adimgv=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 180, 180)];
    self.adimgv.hidden=YES;
    self.adimgv.backgroundColor=[UIColor clearColor];
    self.adimgv.image=[UIImage imageNamed:@"圆形加载图 大.png"];
    [self.weatherview addSubview:self.adimgv];
    UIButton *icobtn=[[UIButton alloc]initWithFrame:self.weatherview.frame];
    [icobtn addTarget:self action:@selector(icoAction) forControlEvents:UIControlEventTouchUpInside];
    [_glassScrollView.foregroundScrollView addSubview:icobtn];
    
    //吐槽按钮
    UIButton *tcbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-80, 225, 70, 25)];
    [tcbtn setTitle:@"    吐槽" forState:UIControlStateNormal];
    tcbtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [tcbtn setBackgroundImage:[UIImage imageNamed:@"按钮底座.png"] forState:UIControlStateNormal];
    [tcbtn addTarget:self action:@selector(tcAction) forControlEvents:UIControlEventTouchUpInside];
//    [_glassScrollView.foregroundScrollView addSubview:tcbtn];
    UIImageView *tcico=[[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 16, 16)];
    tcico.image=[UIImage imageNamed:@"吐槽.png"];
//    [tcbtn addSubview:tcico];
   
//    NSArray *tickerStrings = [NSArray arrayWithObjects:@"当花瓣离开花朵,暗香残留,香消在风起雨后", nil];
//    ticker = [[JHTickerView alloc] initWithFrame:CGRectMake((kScreenWidth-250)/2, 310, 250, 30)];
//    [ticker setDirection:JHTickerDirectionLTR];
////    [ticker setTickerStrings:tickerStrings];
//    [ticker setTickerSpeed:55.0f];
//    [ticker start];
//    [_glassScrollView.foregroundScrollView addSubview:ticker];
    self.wxtslab=[[UILabel alloc]initWithFrame:CGRectMake(0, 300, kScreenWidth, 30)];
    self.wxtslab.font=[UIFont systemFontOfSize:14];
    self.wxtslab.textColor=[UIColor whiteColor];
    self.wxtslab.textAlignment=NSTextAlignmentCenter;
    [_glassScrollView.foregroundScrollView addSubview:self.wxtslab];
    
    UIButton *livebtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 340, 31.5, 30.5)];
    [livebtn setBackgroundImage:[UIImage imageNamed:@"开拍.png"] forState:UIControlStateNormal];
    [livebtn setBackgroundImage:[UIImage imageNamed:@"开拍 二态.png"] forState:UIControlStateHighlighted];
    [livebtn addTarget:self action:@selector(liveAction) forControlEvents:UIControlEventTouchUpInside];
    [_glassScrollView.foregroundScrollView addSubview:livebtn];
    UIButton *sharebtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 385, 32, 33)];
    [sharebtn setBackgroundImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    [sharebtn setBackgroundImage:[UIImage imageNamed:@"分享 二态.png"] forState:UIControlStateHighlighted];
    [sharebtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [_glassScrollView.foregroundScrollView addSubview:sharebtn];
    
    
    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 420, kScreenWidth, 40)];
    bgimg.image=[UIImage imageNamed:@"首页背景条"];
    bgimg.userInteractionEnabled=YES;
    [_glassScrollView.foregroundScrollView addSubview:bgimg];
    UILabel *loclab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
    loclab.text=@"未来";
    loclab.textColor=[UIColor whiteColor];
    loclab.font=[UIFont systemFontOfSize:15];
    [bgimg addSubview:loclab];
    //趋势
   
    UIButton *btn15day=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-75, 7.5, 70, 25)];
    [btn15day setTitle:@"15天天气" forState:UIControlStateNormal];
    [btn15day setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
    [btn15day setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
    btn15day.titleLabel.font=[UIFont systemFontOfSize:15];
    [btn15day setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
    [btn15day addTarget:self action:@selector(fiveThAction:) forControlEvents:UIControlEventTouchUpInside];
//    [bgimg addSubview:btn15day];
//    self.fivthBtn = btn15day;
    UIButton *qsbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-75, 7.5, 70, 25)];
//    UIButton *qsbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-75, 7.5, 70, 25)];
    [qsbtn setTitle:@"7天天气" forState:UIControlStateNormal];
    [qsbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
    [qsbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
    qsbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [qsbtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
    [qsbtn addTarget:self action:@selector(qsAction) forControlEvents:UIControlEventTouchUpInside];
    [bgimg addSubview:qsbtn];
    
    UIButton *hourbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-147, 7.5, 70, 25)];
    self.hourbtn=hourbtn;
    [hourbtn setTitle:@"逐时预报" forState:UIControlStateNormal];
    [hourbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
    [hourbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
    hourbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [hourbtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
    [hourbtn addTarget:self action:@selector(threeAction) forControlEvents:UIControlEventTouchUpInside];
    [bgimg addSubview:hourbtn];
////    UIButton *qsbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-80, 415, 70, 28)];
//    UIButton *qsbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-75, 7.5, 70, 25)];
////    [qsbtn setTitle:@"    趋势" forState:UIControlStateNormal];
//    
//    [qsbtn setTitle:@"    未来" forState:UIControlStateNormal];
//    [qsbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
//    [qsbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
//    qsbtn.titleLabel.font=[UIFont systemFontOfSize:15];
//    [qsbtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
////    qsbtn.titleLabel.alpha=0.7;
////    [qsbtn setBackgroundImage:[UIImage imageNamed:@"按钮底座.png"] forState:UIControlStateNormal];
//    [qsbtn addTarget:self action:@selector(qsAction) forControlEvents:UIControlEventTouchUpInside];
//    [bgimg addSubview:qsbtn];
//    UIImageView *qsico=[[UIImageView alloc]initWithFrame:CGRectMake(6, 2, 18, 18)];
//    qsico.image=[UIImage imageNamed:@"趋势.png"];
//    [qsbtn addSubview:qsico];
    
    
    //首页底部内容
    if (self.mainview) {
        [self.mainview removeFromSuperview];
        self.mainview=nil;
    }
    self.mainview=[[MainView alloc]initWithFrame:CGRectMake(0, 460, kScreenWidth, 255)];
//    self.mainview.delegate=self;
    [_glassScrollView.foregroundScrollView addSubview:self.mainview];
    if (self.skview) {
        self.skview.delegate=nil;
        [self.skview removeFromSuperview];
        self.skview=nil;
    }
    self.skview=[[Skview alloc]initWithFrame:CGRectMake(0, 735, kScreenWidth, 205)];
    self.skview.delegate=self;
    [_glassScrollView.foregroundScrollView addSubview:self.skview];
    if (self.airview) {
        self.airview.delegate=nil;
        [self.airview removeFromSuperview];
        self.airview=nil;
    }
    self.airview =[[AirView alloc]initWithFrame:CGRectMake(0, 940, kScreenWidth, 55)];
    self.airview.delegate=self;
    [_glassScrollView.foregroundScrollView addSubview:self.airview];
    if (self.mapview) {
        self.mapview.delegate=nil;
        [self.mapview removeFromSuperview];
        self.mapview=nil;
    }
    self.mapview=[[MapView alloc]initWithFrame:CGRectMake(0, 1045, kScreenWidth, 290)];
    self.mapview.delegate=self;
    [_glassScrollView.foregroundScrollView addSubview:self.mapview];
    if (riliview) {
        riliview.delegate=nil;
        [riliview removeFromSuperview];
        riliview=nil;
    }
    RiLiView *rlview=[[RiLiView alloc]initWithFrame:CGRectMake(0, 1530, kScreenWidth, 150)];
    riliview=rlview;
    rlview.delegate=self;
    [_glassScrollView.foregroundScrollView addSubview:rlview];
    [self loadCotachView];
    //加载影视视图
    if (self.viedoview) {
    [self.viedoview removeFromSuperview];
    self.viedoview=nil;
    }
    self.viedoview=[[ViedoView alloc]initWithFrame:CGRectMake(0, 2150, kScreenWidth, 180)];
    self.viedoview.delegate=self;
    [_glassScrollView.foregroundScrollView addSubview:self.viedoview];
      _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, 2555);
    
    
}
- (UIView *)customView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 785)];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
//判断是否有24小时预报
-(void)gethours{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_weekwt = [[NSMutableDictionary alloc] init];
    [gz_weekwt setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [b setObject:gz_weekwt forKey:@"gz_hourswt"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_hourswt = [b objectForKey:@"gz_hourswt"];
            NSArray *hourswt_list=[gz_hourswt objectForKey:@"hourswt_list"];
            if (!(hourswt_list.count>0)) {
                self.hourbtn.hidden=YES;
            }else{
                self.hourbtn.hidden=NO;
            }
            
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        self.hximg.hidden=YES;//旋转停止
    } withCache:YES];
}
//预警
-(void)getyjxx{
   
    if (self.btns.count>0) {
        for (int i=0; i<self.btns.count; i++) {
            UIButton *btn=self.btns[i];
            [btn removeFromSuperview];
        }
    }
    
    if (self.yjImageArray.count>0) {
        for (int i=0; i<self.yjImageArray.count; i++) {
            UIImageView *ImageView=self.yjImageArray[i];
            [ImageView removeFromSuperview];
        }
    }
    
    
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * yjxx_index = [[NSMutableDictionary alloc] init];
    if ([setting sharedSetting].currentCityID.length>0) {
        [yjxx_index setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    }
    [b setObject:yjxx_index forKey:@"gz_fb_warn_index"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    NSString *str=[param urlEncodedStringCustom];
    NSDictionary *parameters = @{@"p":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * b = [responseObject objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * yjxx_index = [b objectForKey:@"gz_fb_warn_index"];
            NSArray *warn_list=[yjxx_index objectForKey:@"warn_list"];
            self.warnlist=warn_list;
            
            for (int i=0; i<warn_list.count; i++) {
                NSString *ico=[warn_list[i] objectForKey:@"ico"];
                NSNumber *area_type=[warn_list[i] objectForKey:@"area_type"];
                UIButton *yjbtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 20+i*45, 40, 33)];
                [yjbtn addTarget:self action:@selector(yjdetali:) forControlEvents:UIControlEventTouchUpInside];
                yjbtn.tag=i;
                [yjbtn setBackgroundImage:[UIImage imageNamed:ico] forState:UIControlStateNormal];
                UIImageView *yjImage=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yjbtn.frame), CGRectGetMaxY(yjbtn.frame)-15, 15, 15)];
                if ([area_type isEqualToNumber:@(1)]) {
                    yjImage.image=[UIImage imageNamed:@"省预警.png"];
                }else if([area_type isEqualToNumber:@(2)])
                {
                    yjImage.image=[UIImage imageNamed:@"市预警.png"];
                }
                [_glassScrollView.foregroundScrollView addSubview:yjbtn];
                [_glassScrollView.foregroundScrollView addSubview:yjImage];
                [self.btns addObject:yjbtn];
                [self.yjImageArray addObject:yjImage];
                if (i==0) {
                    /**
                     *  数据存到widget
                     */
                    NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
                    [userDf setObject:[warn_list[0] objectForKey:@"title"] forKey:@"desc"];
                    [userDf synchronize];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        self.hximg.hidden=YES;//旋转停止
    }];
//    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
////        NSLog(@"$%@$",responseObject);
//        NSDictionary * b = [responseObject objectForKey:@"b"];
//        if (b!=nil) {
//            NSDictionary * yjxx_index = [b objectForKey:@"gz_warn_index"];
//            NSArray *warn_list=[yjxx_index objectForKey:@"warn_list"];
//            self.warnlist=warn_list;
//           
//            for (int i=0; i<warn_list.count; i++) {
//                NSString *ico=[warn_list[i] objectForKey:@"ico"];
//                UIButton *yjbtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 20+i*45, 40, 33)];
//                [yjbtn addTarget:self action:@selector(yjdetali:) forControlEvents:UIControlEventTouchUpInside];
//                yjbtn.tag=i;
//                [yjbtn setBackgroundImage:[UIImage imageNamed:ico] forState:UIControlStateNormal];
//                [_glassScrollView.foregroundScrollView addSubview:yjbtn];
//                [self.btns addObject:yjbtn];
//                }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
}
-(void)loadadvice{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:@"1" forKey:@"position_id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_ad"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];
            if (adlist.count>0) {
                NSString *url=[adlist[0] objectForKey:@"url"];
                NSString *title=[adlist[0] objectForKey:@"title"];
                NSString *imgurl=[adlist[0] objectForKey:@"img_path"];
                self.adurl=url;
                self.adimgurl=imgurl;
                self.adtitle=title;
                NSURL *newurl = [ShareFun makeImageUrl:imgurl];
                dispatch_queue_t queue =dispatch_queue_create("loadadImage",NULL);
                dispatch_async(queue, ^{
                    
                    NSData *resultData = [NSData dataWithContentsOfURL:newurl];
                    UIImage *img = [UIImage imageWithData:resultData];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if (img) {
                            self.adimgv.image=img;
                        }
                        
                    });
                    
                });
            }
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
- (void)loadadA005 {
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:@"20" forKey:@"position_id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_ad"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
//            UIButton *imageView = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 55, 84, 40, 33)];
//            imageView.backgroundColor = [UIColor redColor];
//            [_glassScrollView.foregroundView addSubview:imageView];
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];
            if (adlist.count>0) {
                NSString *url=[adlist[0] objectForKey:@"url"];
                NSString *title=[adlist[0] objectForKey:@"title"];
                NSString *imgurl=[adlist[0] objectForKey:@"img_path"];
                NSString *fx_content=[adlist[0] objectForKey:@"fx_content"];
                self.ysj_weburl=url;
                self.webtitle=title;
                self.websharecontent=fx_content;
//                NSURL *newurl = [ShareFun makeImageUrl:imgurl];
                EGOImageView *ego=[[EGOImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 20, 50, 40)];
                [ego setImageURL:[ShareFun makeImageUrl:imgurl]];
                ego.userInteractionEnabled=YES;
                [_glassScrollView.foregroundScrollView addSubview:ego];
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
                [btn addTarget:self action:@selector(A005Action) forControlEvents:UIControlEventTouchUpInside];
                [ego addSubview:btn];

            }
            
            
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)cacheadvice{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:@"1" forKey:@"position_id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_ad"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] getCacheWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];
            NSString *url=[adlist[0] objectForKey:@"url"];
            NSString *imgurl=[adlist[0] objectForKey:@"img_path"];
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
//加载首页大广告, 首页下方的轮播图
-(void)loadMainAD{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:@"2" forKey:@"position_id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_ad"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        [[NSUserDefaults standardUserDefaults]setObject:returnData forKey:@"gz_mainad_cache"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            [self.adimgurls removeAllObjects];
            [self.adtitles removeAllObjects];
            [self.adurls removeAllObjects];
            [self.adshares removeAllObjects];
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];
            if (adlist.count>0) {
                for (int i=0; i<adlist.count; i++) {
                    NSString *url=[adlist[i] objectForKey:@"url"];
                    NSString *title=[adlist[i] objectForKey:@"title"];
                    NSString *imgurl=[adlist[i] objectForKey:@"img_path"];
                    NSString *fx_content=[adlist[i] objectForKey:@"fx_content"];
                    if (fx_content.length>0) {
                        [self.adshares addObject:fx_content];
                    }
                    [self.adurls addObject:url];
                    [self.adtitles addObject:title];
                    [self.adimgurls addObject:imgurl];
                }
                
                [self.bmadscro removeFromSuperview];
                self.bmadscro=nil;
                if (self.bmadscro==nil) {
                    if (self.mheight>0) {
                        self.bmadscro = [[BMAdScrollView alloc] initWithNameArr:self.adimgurls  titleArr:self.adtitles height:170 offsetY:self.mheight+2 offsetx:10];
                    }else
                        self.bmadscro = [[BMAdScrollView alloc] initWithNameArr:self.adimgurls  titleArr:self.adtitles height:170 offsetY:900+290 offsetx:10];
                    
                    //            self.bmadscro=adView;
                    self.bmadscro.vDelegate = self;
                    self.bmadscro.pageCenter = CGPointMake(280, 300);
                    [_glassScrollView.foregroundScrollView addSubview:self.bmadscro];
            }
                if (self.mheight>0) {
                    _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.mheight+170);
                }else{
                    _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, 1200+170);
                }
            }else{
                if (self.mheight>0) {
                    _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.mheight);
                }else{
                    _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, 1200);
                }
            }
            
                NSLog(@"%f",self.mheight);
            
                self.hximg.hidden=YES;//旋转停止
                if (self.isdownview==NO) {
                    
                    //                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD hideHUDForView:[[ShareFun shareAppDelegate] window] animated:YES];
                    
                }
                [self.updatelab removeFromSuperview];
                UILabel *tlab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
                tlab.text=self.uptimestr;
                tlab.text=self.dwstress;
                tlab.textColor=[UIColor whiteColor];
                tlab.alpha=0.7;
                tlab.font=[UIFont systemFontOfSize:14];
                tlab.textAlignment=NSTextAlignmentCenter;
                self.updatelab=tlab;
                [_glassScrollView.foregroundScrollView addSubview:tlab];
 
//            }
            
        }
        
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[ShareFun shareAppDelegate].window animated:YES];
        NSLog(@"failure");
    } withCache:YES];
}
-(void)cacheMainAD{
//    NSString * urlStr = URL_SERVER;
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
//    [gz_todaywt_inde setObject:@"2" forKey:@"position_id"];
//    [b setObject:gz_todaywt_inde forKey:@"gz_ad"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    [[NetWorkCenter share] getCacheWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
    NSDictionary *returnData=[[NSUserDefaults standardUserDefaults]objectForKey:@"gz_mainad_cache"];
    if (returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            [self.adimgurls removeAllObjects];
            [self.adtitles removeAllObjects];
            [self.adurls removeAllObjects];
            [self.adshares removeAllObjects];
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];

            for (int i=0; i<adlist.count; i++) {
                NSString *url=[adlist[i] objectForKey:@"url"];
                NSString *title=[adlist[i] objectForKey:@"title"];
                NSString *imgurl=[adlist[i] objectForKey:@"img_path"];
                NSString *fx_content=[adlist[i] objectForKey:@"fx_content"];
                if (fx_content.length>0) {
                  [self.adshares addObject:fx_content];
                }
                
                [self.adurls addObject:url];
                [self.adtitles addObject:title];
                [self.adimgurls addObject:imgurl];
            }

            [self.bmadscro removeFromSuperview];
            self.bmadscro=nil;
            if (self.bmadscro==nil) {
                if (self.mheight>0) {
                    self.bmadscro = [[BMAdScrollView alloc] initWithNameArr:self.adimgurls  titleArr:self.adtitles height:180 offsetY:self.mheight+10 offsetx:10];
                }else
                    self.bmadscro = [[BMAdScrollView alloc] initWithNameArr:self.adimgurls  titleArr:self.adtitles height:180 offsetY:910+290 offsetx:10];
                
                //            self.bmadscro=adView;
                self.bmadscro.vDelegate = self;
                self.bmadscro.pageCenter = CGPointMake(280, 300);
                [_glassScrollView.foregroundScrollView addSubview:self.bmadscro];
                if (self.mheight>0) {
                    _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.mheight+195);
                }else{
                    _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, 1200+195);
                }
            }
//            self.hximg.hidden=YES;//旋转停止
            [self.updatelab removeFromSuperview];
            UILabel *tlab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
            tlab.text=self.uptimestr;
            tlab.text=self.dwstress;
            tlab.textColor=[UIColor whiteColor];
            tlab.alpha=0.7;
            tlab.font=[UIFont systemFontOfSize:14];
            tlab.textAlignment=NSTextAlignmentCenter;
            self.updatelab=tlab;
            [_glassScrollView.foregroundScrollView addSubview:tlab];
            
        }
    }
//    } withFailure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:[ShareFun shareAppDelegate].window animated:YES];
//        NSLog(@"failure");
//    } withCache:YES];
}
-(void)loadbgview{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if ([setting sharedSetting].currentCityID.length>0) {
        [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    }
    [gz_todaywt_inde setObject:@"IOS" forKey:@"os_type"];
    [b setObject:gz_todaywt_inde forKey:@"gz_todaywt_index"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        [[NSUserDefaults standardUserDefaults]setObject:returnData forKey:@"gz_todaywt_index_cache"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_todaywt_inde = [b objectForKey:@"gz_todaywt_index"];
            NSDictionary *todaywt=[gz_todaywt_inde objectForKey:@"todaywt"];
//            NSString *wt_ico=[todaywt objectForKey:@"wt_ico"];
            NSString *back_img_max=[todaywt objectForKey:@"back_img_max"];
            NSString *back_img_min=[todaywt objectForKey:@"back_img_min"];
            NSURL *url = [ShareFun makeImageUrl:back_img_max];
            if (iPhone4) {
                url = [ShareFun makeImageUrl:back_img_min];
                back_img_max=back_img_min;
            }
            if ([self.bgurl isEqualToString:back_img_max]) {
                //判断是否同一张背景图
                _glassScrollView.foregroundView=[self customView];
                [self updateMainview];
                if (self.isopen==YES) {
                    self.adtimeopen=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timestrat) userInfo:nil repeats:NO];
                    self.adtimeclose=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timestrat) userInfo:nil repeats:NO];//广告翻转
                }
                NSString *systime=[todaywt objectForKey:@"sys_time"];
                [self.icoimgv updateMainViewData:todaywt];
                
                NSString *tip=[todaywt objectForKey:@"tip"];
                if (tip.length>0) {
                    //                [ticker setTickerStrings:tickerStrings];//温馨提示
                    self.wxtslab.text=tip;
                }
                
                [setting sharedSetting].systime=systime;
                [[setting sharedSetting] saveSetting];
            }else{
                self.bgurl=back_img_max;
            dispatch_queue_t queue =dispatch_queue_create("loadbgImage",NULL);
            dispatch_async(queue, ^{
                
                NSData *resultData = [NSData dataWithContentsOfURL:url];
                UIImage *img = [UIImage imageWithData:resultData];
                self.bgimg=img;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (img) {
                        UIView *view = [self customView];
                        _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:img blurredImage:nil viewDistanceFromBottom:kScreenHeitht foregroundView:view];
                        [self.view addSubview:_glassScrollView];
                        [_glassScrollView setTopLayoutGuideLength:[self.topLayoutGuide length]];
                        [self creatbaseview];
                        [self updateMainview];
                     
                        
                    }else{

                        _glassScrollView.foregroundView=[self customView];
                        [self updateMainview];
                    }
                    if (self.isopen==YES) {
                        self.adtimeopen=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timestrat) userInfo:nil repeats:NO];
                        self.adtimeclose=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timestrat) userInfo:nil repeats:NO];//广告翻转
                    }
                    NSString *systime=[todaywt objectForKey:@"sys_time"];
                    [self.icoimgv updateMainViewData:todaywt];
                   
                    NSString *tip=[todaywt objectForKey:@"tip"];
                    if (tip.length>0) {
                        //                [ticker setTickerStrings:tickerStrings];//温馨提示
                        self.wxtslab.text=tip;
                    }
                    
                    [setting sharedSetting].systime=systime;
                    [[setting sharedSetting] saveSetting];
                    
                });
                
            });
            }
//            if (self.isdw==YES) {
//                 [self startLocation];
//            }
//            EGOImageView *ego=[[EGOImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
//            [ego setImageURL:[ShareFun makeImageUrl:back_img_max]];
//            [self.view addSubview:ego];
//            
//
//            UIView *view = [self customView];
//            [_glassScrollView removeFromSuperview];
//            _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:ego.image blurredImage:nil viewDistanceFromBottom:kScreenHeitht+100 foregroundView:view];
//            [self.view addSubview:_glassScrollView];
//            [_glassScrollView setTopLayoutGuideLength:[self.topLayoutGuide length]];
//            [self creatbaseview];
//            [self updateMainview];
//            if (iPhone4) {
//                if (wt_ico.length>0) {
//                    NSString *bgimgname=wt_ico;
//
//                    if ([wt_ico isEqualToString:@"03"]) {
//                        bgimgname=@"07";
//                    }
//                    if ([wt_ico isEqualToString:@"04"]||[wt_ico isEqualToString:@"05"]) {
//                        bgimgname=@"04";
//                    }
//                    if ([wt_ico isEqualToString:@"08"]||[wt_ico isEqualToString:@"21"]) {
//                        bgimgname=@"08";
//                    }if ([wt_ico isEqualToString:@"09"]||[wt_ico isEqualToString:@"22"]||[wt_ico isEqualToString:@"10"]||[wt_ico isEqualToString:@"23"]||[wt_ico isEqualToString:@"24"]||[wt_ico isEqualToString:@"11"]||[wt_ico isEqualToString:@"25"]||[wt_ico isEqualToString:@"12"]) {
//                        bgimgname=@"09";
//                    }
//                    if ([wt_ico isEqualToString:@"14"]||[wt_ico isEqualToString:@"06"]||[wt_ico isEqualToString:@"19"]) {
//                        bgimgname=@"14";
//                    }
//                    if ([wt_ico isEqualToString:@"15"]||[wt_ico isEqualToString:@"26"]||[wt_ico isEqualToString:@"13"]) {
//                        bgimgname=@"15";
//                    }
//                    if ([wt_ico isEqualToString:@"16"]||[wt_ico isEqualToString:@"27"]||[wt_ico isEqualToString:@"17"]||[wt_ico isEqualToString:@"28"]) {
//                        bgimgname=@"16";
//                    }
//                    if ([wt_ico isEqualToString:@"29"]||[wt_ico isEqualToString:@"30"]) {
//                        bgimgname=@"29";
//                    }
//                    if ([wt_ico isEqualToString:@"20"]||[wt_ico isEqualToString:@"31"]) {
//                        bgimgname=@"31";
//                    }
//                    if ([wt_ico isEqualToString:@"32"]) {
//                        bgimgname=@"32";
//                    }
//                    [_glassScrollView removeFromSuperview];
//                    UIView *view = [self customView];
//                    _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_4.jpg",bgimgname]] blurredImage:nil viewDistanceFromBottom:kScreenHeitht+100 foregroundView:view];
//                    [self.view addSubview:_glassScrollView];
//                    [_glassScrollView setTopLayoutGuideLength:[self.topLayoutGuide length]];
//                    [self creatbaseview];
//                    [self updateMainview];
//                }else{
//                    [_glassScrollView removeFromSuperview];
//                    UIView *view = [self customView];
//                    _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"00_4.jpg"] blurredImage:nil viewDistanceFromBottom:kScreenHeitht+100 foregroundView:view];
//                    [self.view addSubview:_glassScrollView];
//                    [_glassScrollView setTopLayoutGuideLength:[self.topLayoutGuide length]];
//                    [self creatbaseview];
//                    [self updateMainview];
//                }
//            }else{
//                if (wt_ico.length>0) {
//                    NSString *bgimgname=wt_ico;
//                    
//                    if ([wt_ico isEqualToString:@"03"]) {
//                        bgimgname=@"07";
//                    }
//                    if ([wt_ico isEqualToString:@"04"]||[wt_ico isEqualToString:@"05"]) {
//                        bgimgname=@"04";
//                    }
//                    if ([wt_ico isEqualToString:@"08"]||[wt_ico isEqualToString:@"21"]) {
//                        bgimgname=@"08";
//                    }if ([wt_ico isEqualToString:@"09"]||[wt_ico isEqualToString:@"22"]||[wt_ico isEqualToString:@"10"]||[wt_ico isEqualToString:@"23"]||[wt_ico isEqualToString:@"24"]||[wt_ico isEqualToString:@"11"]||[wt_ico isEqualToString:@"25"]||[wt_ico isEqualToString:@"12"]) {
//                        bgimgname=@"09";
//                    }
//                    if ([wt_ico isEqualToString:@"14"]||[wt_ico isEqualToString:@"06"]||[wt_ico isEqualToString:@"19"]) {
//                        bgimgname=@"14";
//                    }
//                    if ([wt_ico isEqualToString:@"15"]||[wt_ico isEqualToString:@"26"]||[wt_ico isEqualToString:@"13"]) {
//                        bgimgname=@"15";
//                    }
//                    if ([wt_ico isEqualToString:@"16"]||[wt_ico isEqualToString:@"27"]||[wt_ico isEqualToString:@"17"]||[wt_ico isEqualToString:@"28"]) {
//                        bgimgname=@"16";
//                    }
//                    if ([wt_ico isEqualToString:@"29"]||[wt_ico isEqualToString:@"30"]) {
//                        bgimgname=@"29";
//                    }
//                    if ([wt_ico isEqualToString:@"20"]||[wt_ico isEqualToString:@"31"]) {
//                        bgimgname=@"31";
//                    }
//                    if ([wt_ico isEqualToString:@"32"]) {
//                        bgimgname=@"32";
//                    }
//                    [_glassScrollView removeFromSuperview];
//                    UIView *view = [self customView];
//                    _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",bgimgname]] blurredImage:nil viewDistanceFromBottom:kScreenHeitht+100 foregroundView:view];
//                    [self.view addSubview:_glassScrollView];
//                    [_glassScrollView setTopLayoutGuideLength:[self.topLayoutGuide length]];
//                    [self creatbaseview];
//                    [self updateMainview];
//                }else{
//                    [_glassScrollView removeFromSuperview];
//                    UIView *view = [self customView];
//                    _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"00.jpg"] blurredImage:nil viewDistanceFromBottom:kScreenHeitht+100 foregroundView:view];
//                    [self.view addSubview:_glassScrollView];
//                    [_glassScrollView setTopLayoutGuideLength:[self.topLayoutGuide length]];
//                    [self creatbaseview];
//                    [self updateMainview];
//                }
//            
//        }
        }else{
            _glassScrollView.foregroundView=[self customView];
            [self updateMainview];
        }
    } withFailure:^(NSError *error) {
        self.hximg.hidden=YES;
        NSLog(@"failure");
    } withCache:YES];
}
-(void)loadCachebgview{
//    NSString * urlStr = URL_SERVER;
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
//    [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
//    [gz_todaywt_inde setObject:@"IOS" forKey:@"os_type"];
//    [b setObject:gz_todaywt_inde forKey:@"gz_todaywt_index"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//     [[NetWorkCenter share] getCacheWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData){
    NSDictionary *returnData=[[NSUserDefaults standardUserDefaults]objectForKey:@"gz_todaywt_index_cache"];
    if (returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_todaywt_inde = [b objectForKey:@"gz_todaywt_index"];
            NSDictionary *todaywt=[gz_todaywt_inde objectForKey:@"todaywt"];
            NSString *systime=[todaywt objectForKey:@"sys_time"];
            [self.icoimgv updateMainViewData:todaywt];
            
            NSString *tip=[todaywt objectForKey:@"tip"];

            [self.icoimgv updateMainViewData:todaywt];
            if (tip.length>0) {
                //                [ticker setTickerStrings:tickerStrings];//温馨提示
                self.wxtslab.text=tip;
            }
            
            [setting sharedSetting].systime=systime;
            [[setting sharedSetting] saveSetting];
            [self getcacheinfo];
//            NSString *wt_ico=[todaywt objectForKey:@"wt_ico"];
//            NSString *back_img_max=[todaywt objectForKey:@"back_img_max"];
//            NSString *back_img_min=[todaywt objectForKey:@"back_img_min"];
//            NSURL *url = [ShareFun makeImageUrl:back_img_max];
//            if (iPhone4) {
//                url = [ShareFun makeImageUrl:back_img_min];
//            }
//            dispatch_queue_t queue =dispatch_queue_create("loadbgImage",NULL);
//            dispatch_async(queue, ^{
//                
//                NSData *resultData = [NSData dataWithContentsOfURL:url];
//                UIImage *img = [UIImage imageWithData:resultData];
//                
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    if (img) {
//                        UIView *view = [self customView];
//                        [_glassScrollView removeFromSuperview];
//                        _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:img blurredImage:nil viewDistanceFromBottom:kScreenHeitht+100 foregroundView:view];
//                        [self.view addSubview:_glassScrollView];
//                        [_glassScrollView setTopLayoutGuideLength:[self.topLayoutGuide length]];
//                        [self creatbaseview];
//                       
//                            [self getcacheinfo];
//                            
//                        //                        [self updateMainview];
//                    }else{
//                        UIView *view = [self customView];
//                        [_glassScrollView removeFromSuperview];
//                        _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"00.jpg"] blurredImage:nil viewDistanceFromBottom:kScreenHeitht+100 foregroundView:view];
//                        [self.view addSubview:_glassScrollView];
//                        [_glassScrollView setTopLayoutGuideLength:[self.topLayoutGuide length]];
//                        [self creatbaseview];
//            
//                            [self getcacheinfo];
//                            
//                        //                        [self updateMainview];
//                    }
//                    NSString *systime=[todaywt objectForKey:@"sys_time"];
//                    [self.icoimgv updateMainViewData:todaywt];
//                    
//                    NSString *tip=[todaywt objectForKey:@"tip"];
//                    
//                    NSArray *tickerStrings = [NSArray arrayWithObjects:tip, nil];
//                    [ticker setTickerStrings:tickerStrings];//温馨提示
//                    [setting sharedSetting].systime=systime;
//                    [[setting sharedSetting] saveSetting];
//                });
//                
//            });

        }
    }
//    } withFailure:^(NSError *error) {
//        NSLog(@"failure");
//        [MBProgressHUD hideHUDForView:[[ShareFun shareAppDelegate] window] animated:YES];
//    } withCache:YES];
}
-(void)loadTodayWea{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if ([setting sharedSetting].currentCityID.length>0) {
        [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    }
    [gz_todaywt_inde setObject:@"IOS" forKey:@"os_type"];
    [b setObject:gz_todaywt_inde forKey:@"gz_todaywt_index"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            if (self.isopen==YES) {
                self.adtimeopen=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timestrat) userInfo:nil repeats:NO];
                self.adtimeclose=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timestrat) userInfo:nil repeats:NO];//广告翻转
            }
            
            
            NSDictionary * gz_todaywt_inde = [b objectForKey:@"gz_todaywt_index"];
            NSDictionary *todaywt=[gz_todaywt_inde objectForKey:@"todaywt"];
            NSString *systime=[todaywt objectForKey:@"sys_time"];
            [self.icoimgv updateMainViewData:todaywt];
            //            NSString *city_name=[todaywt objectForKey:@"city_name"];
            //            NSString *wt=[todaywt objectForKey:@"wt"];
//            NSString *wt_ico=[todaywt objectForKey:@"wt_ico"];
            NSString *tip=[todaywt objectForKey:@"tip"];
            //            NSString *lowt=[todaywt objectForKey:@"lowt"];
            //            NSString *higt=[todaywt objectForKey:@"higt"];
            //            NSString *week=[todaywt objectForKey:@"week"];
//            NSArray *tickerStrings = [NSArray arrayWithObjects:tip, nil];
            if (tip.length>0) {
//                [ticker setTickerStrings:tickerStrings];//温馨提示
                self.wxtslab.text=tip;
            }
            
            [setting sharedSetting].systime=systime;
            [[setting sharedSetting] saveSetting];
            
            [[NSUserDefaults standardUserDefaults]setObject:returnData forKey:@"gz_todaywt_index_cache"];
            [[NSUserDefaults standardUserDefaults]synchronize];

//            UILabel *tlab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//            tlab.text=[NSString stringWithFormat:@"%@更新",[formatter stringFromDate:t_current]];
//            tlab.textColor=[UIColor whiteColor];
//            tlab.alpha=0.7;
//            tlab.font=[UIFont systemFontOfSize:12];
//            tlab.textAlignment=NSTextAlignmentCenter;
//            self.updatelab=tlab;
//            [_glassScrollView.foregroundScrollView addSubview:tlab];
        }
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:[[ShareFun shareAppDelegate] window] animated:YES];
    } withCache:YES];
   }
-(void)cacheTodayWea{
//    NSString * urlStr = URL_SERVER;
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
//    [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
//    [gz_todaywt_inde setObject:@"IOS" forKey:@"os_type"];
//    [b setObject:gz_todaywt_inde forKey:@"gz_todaywt_index"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    [[NetWorkCenter share] getCacheWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
    NSDictionary *returnData=[[NSUserDefaults standardUserDefaults]objectForKey:@"gz_todaywt_index_cache"];
    if (returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_todaywt_inde = [b objectForKey:@"gz_todaywt_index"];
            NSDictionary *todaywt=[gz_todaywt_inde objectForKey:@"todaywt"];
            NSString *systime=[todaywt objectForKey:@"sys_time"];
            [self.icoimgv updateMainViewData:todaywt];
            
            NSString *tip=[todaywt objectForKey:@"tip"];
            
            NSArray *tickerStrings = [NSArray arrayWithObjects:tip, nil];
            [ticker setTickerStrings:tickerStrings];//温馨提示
            [setting sharedSetting].systime=systime;
            [[setting sharedSetting] saveSetting];
        }
    }
    
//    } withFailure:^(NSError *error) {
//        NSLog(@"failure");
//    } withCache:YES];
}
-(void)loadThreewt{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if ([setting sharedSetting].currentCityID.length>0) {
        [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    }
    [b setObject:gz_todaywt_inde forKey:@"gz_tridwt_index"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_tridwt_index = [b objectForKey:@"gz_tridwt_index"];
            NSArray *tridwt_list=[gz_tridwt_index objectForKey:@"tridwt_list"];
//            [self.mainview updateThreeWt:tridwt_list];
            
        }
        [[NSUserDefaults standardUserDefaults]setObject:returnData forKey:@"gz_tridwt_index_cache"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        self.hximg.hidden=YES;
//        [MBProgressHUD hideHUDForView:[[ShareFun shareAppDelegate] window] animated:YES];
    } withCache:YES];
}
-(void)cachaeThreewt{
//    NSString * urlStr = URL_SERVER;
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
//    [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
//    [b setObject:gz_todaywt_inde forKey:@"gz_tridwt_index"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    [[NetWorkCenter share] getCacheWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
    NSDictionary *returnData=[[NSUserDefaults standardUserDefaults]objectForKey:@"gz_tridwt_index_cache"];
    if (returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_tridwt_index = [b objectForKey:@"gz_tridwt_index"];
            NSArray *tridwt_list=[gz_tridwt_index objectForKey:@"tridwt_list"];
//            [self.mainview updateThreeWt:tridwt_list];
            
        }
    }
    
        
        
//    } withFailure:^(NSError *error) {
//        NSLog(@"failure");
//    } withCache:YES];
}
-(void)loadSKinfo{
    
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if ([setting sharedSetting].currentCityID.length>0) {
        [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    }
    [b setObject:gz_todaywt_inde forKey:@"gz_realwt_index"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
//            if (self.skview) {
//                [self.skview removeFromSuperview];
//                self.skview=nil;
//            }
            NSDictionary * gz_realwt_index = [b objectForKey:@"gz_realwt_index"];
            if (gz_realwt_index!=nil) {
                NSDictionary *realwt=[gz_realwt_index objectForKey:@"realwt"];
                NSString *ct=[realwt objectForKey:@"ct"];
                [self.icoimgv updateMainSKTemData:ct];
                self.viewHeight=745;
                
                if (![ct isEqualToString:@""]) {
//                    if (!self.skview) {
                        self.skview.hidden=NO;
                    self.skview.frame=CGRectMake(0, 735, kScreenWidth, 205);
//                        self.skview=[[Skview alloc]initWithFrame:CGRectMake(0, 735, kScreenWidth, 205)];
//                        self.skview.delegate=self;
//                        [_glassScrollView.foregroundScrollView addSubview:self.skview];
                        self.skinfo=realwt;
                        [self.skview updateSK:realwt];
                        //                            [self.mainview updateSK:realwt];
                        
                        self.viewHeight=735+215;
//                    }
                    
                }else{
                    self.skview.hidden=YES;
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadAirInfo];
                });
//                [self loadAirInfo];
                _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.viewHeight);
                NSString *upt=[realwt objectForKey:@"upt"];
                NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                [inputFormatter setDateFormat:@"HH:mm"];
                long long time=upt.doubleValue;
                NSDate *t_current = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setAMSymbol:@"AM"];
                [formatter setPMSymbol:@"PM"];
                [formatter setDateFormat:@"HH:mm"];
                NSString *newuptime=[NSString stringWithFormat:@"上次更新%@",[formatter stringFromDate:t_current]];
                //            self.uptimestr=newuptime;//设置刷新后的地区
                [[NSUserDefaults standardUserDefaults] setObject:newuptime forKey:@"lastUptimeStr"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
                [userDf setObject:ct forKey:@"sstqLabel"];
                [userDf synchronize];
            }
            [[NSUserDefaults standardUserDefaults]setObject:returnData forKey:@"gz_realwt_index_cache"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:[[ShareFun shareAppDelegate] window] animated:YES];
    } withCache:YES];
   
}
-(void)cacheSKinfo{
    
//    NSString * urlStr = URL_SERVER;
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
//    [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
//    [b setObject:gz_todaywt_inde forKey:@"gz_realwt_index"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    [[NetWorkCenter share] getCacheWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
    NSDictionary *returnData=[[NSUserDefaults standardUserDefaults]objectForKey:@"gz_realwt_index_cache"];
    if (returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
//        [self.skview removeFromSuperview];
//        self.skview=nil;
        if (b!=nil) {
            NSDictionary * gz_realwt_index = [b objectForKey:@"gz_realwt_index"];
            NSDictionary *realwt=[gz_realwt_index objectForKey:@"realwt"];
//            [self.mainview updateSK:realwt];
            NSString *ct=[realwt objectForKey:@"ct"];
            [self.icoimgv updateMainSKTemData:ct];
            if (![ct isEqualToString:@""]) {
                self.skview.hidden=NO;
                self.skview.frame=CGRectMake(0, 735, kScreenWidth, 205);
//                if (!self.skview) {
//                    self.skview=[[Skview alloc]initWithFrame:CGRectMake(0, 735, kScreenWidth, 205)];
//                    self.skview.delegate=self;
//                    [_glassScrollView.foregroundScrollView addSubview:self.skview];
                    self.skinfo=realwt;
                    [self.skview updateSK:realwt];
                    //                            [self.mainview updateSK:realwt];
                    
                    self.viewHeight=735+205;
//                }
                
            }else{
                self.skview.hidden=YES;
                self.viewHeight=735;
            }
            
            _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.viewHeight);
            [self cacheAirInfo];
            
        
            
        }
    }
    
//    } withFailure:^(NSError *error) {
//        NSLog(@"failure");
//    } withCache:YES];
    
}
-(void)loadAirInfo{
    
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if ([setting sharedSetting].currentCityID.length>0) {
        [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    }
     [gz_todaywt_inde setObject:@"1" forKey:@"type"];
    [b setObject:gz_todaywt_inde forKey:@"gz_air_qua_index"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        [[NSUserDefaults standardUserDefaults]setObject:returnData forKey:@"gz_air_qua_index_cache"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSDictionary * b = [returnData objectForKey:@"b"];
//        [self.mapview removeFromSuperview];
//        self.mapview=nil;
//        [self.airview removeFromSuperview];
//        self.airview=nil;
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_air_qua_index"];
            if (gz_air_qua_index!=nil) {
                NSDictionary *air_qua=[gz_air_qua_index objectForKey:@"air_qua"];
                NSString *aqi=[air_qua objectForKey:@"aqi"];
                NSString *quality=[air_qua objectForKey:@"quality"];
                /**
                 存数据到widget
                 */
                NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
                [userDf setObject:quality forKey:@"quality"];
                [userDf setObject:aqi forKey:@"aqi"];
                [userDf synchronize];
                
                if (![aqi isEqualToString:@""]) {
//                    if (self.airview) {
//                        
//                    }else{
//                        self.airview =[[AirView alloc]initWithFrame:CGRectMake(0, self.viewHeight, kScreenWidth, 65)];
//                        self.airview.delegate=self;
//                        [_glassScrollView.foregroundScrollView addSubview:self.airview];
                    self.airview.hidden=NO;
                    self.airview.frame=CGRectMake(0, self.viewHeight, kScreenWidth, 55);
                        [self.airview updateAirInfo:air_qua];
                        self.viewHeight=self.viewHeight+95;
                        _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.viewHeight);
//                    }
                    [self.icoimgv upAirLev:quality];
                }else{
                    self.airview.hidden=YES;
                }
//                if (self.mapview) {
//                    self.mapview.delegate=nil;
//                    [self.mapview removeFromSuperview];
//                    self.mapview=nil;
//                }else{
//                    self.mapview=[[MapView alloc]initWithFrame:CGRectMake(0, self.viewHeight, kScreenWidth, 290)];
//                    self.mapview.delegate=self;
//                    [_glassScrollView.foregroundScrollView addSubview:self.mapview];
                self.mapview.frame=CGRectMake(0, self.viewHeight, kScreenWidth, 290);
                [self.mapview Getyjxx_grad_indexData];
                    self.viewHeight=self.viewHeight+290;
                    _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.viewHeight);
//                }
//                yshight=self.viewHeight+5;
//                [self loadysad];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadSHZS];});
            }
            
        }
        
     
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:[[ShareFun shareAppDelegate] window] animated:YES];
    } withCache:YES];
    
}
-(void)cacheAirInfo{
    
//    NSString * urlStr = URL_SERVER;
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
//    [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
//    [gz_todaywt_inde setObject:@"1" forKey:@"type"];
//    [b setObject:gz_todaywt_inde forKey:@"gz_air_qua_index"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    [[NetWorkCenter share] getCacheWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
    NSDictionary *returnData=[[NSUserDefaults standardUserDefaults]objectForKey:@"gz_air_qua_index_cache"];
    if (returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
//        [self.mapview removeFromSuperview];
//        self.mapview=nil;
//        [self.airview removeFromSuperview];
//        self.airview=nil;
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_air_qua_index"];
            NSDictionary *air_qua=[gz_air_qua_index objectForKey:@"air_qua"];
//            [self.mainview updateAirInfo:air_qua];
//            NSString *health=[air_qua objectForKey:@"health_advice"];
            NSString *quality=[air_qua objectForKey:@"quality"];
//            NSString *pollutant=[air_qua objectForKey:@"primary_pollutant"];
            NSString *aqi=[air_qua objectForKey:@"aqi"];
            if (![aqi isEqualToString:@""]) {
                    //                    if (self.airview) {
                    //
                    //                    }else{
                    //                        self.airview =[[AirView alloc]initWithFrame:CGRectMake(0, self.viewHeight, kScreenWidth, 65)];
                    //                        self.airview.delegate=self;
                    //                        [_glassScrollView.foregroundScrollView addSubview:self.airview];
                    self.airview.hidden=NO;
                    self.airview.frame=CGRectMake(0, self.viewHeight, kScreenWidth, 55);
                    [self.airview updateAirInfo:air_qua];
                    self.viewHeight=self.viewHeight+95;
                    _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.viewHeight);
                    //                    }
                    [self.icoimgv upAirLev:quality];
                }else{
                    self.airview.hidden=YES;
                }
                //                if (self.mapview) {
                //                    self.mapview.delegate=nil;
                //                    [self.mapview removeFromSuperview];
                //                    self.mapview=nil;
                //                }else{
                //                    self.mapview=[[MapView alloc]initWithFrame:CGRectMake(0, self.viewHeight, kScreenWidth, 290)];
                //                    self.mapview.delegate=self;
                //                    [_glassScrollView.foregroundScrollView addSubview:self.mapview];
                self.mapview.frame=CGRectMake(0, self.viewHeight, kScreenWidth, 290);
                self.viewHeight=self.viewHeight+290;
                _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.viewHeight);
            
//            yshight=self.viewHeight+5;
//            [self cacheysad];
            [self cacheshzs];
        }
    }
    
//    } withFailure:^(NSError *error) {
//        NSLog(@"failure");
//    } withCache:YES];
    
}
//影视广告
-(void)loadysad{
    self.isswipe=YES;
    [self.ysadurls removeAllObjects];
    [self.ysadimgurls removeAllObjects];
    [self.ysadtitles removeAllObjects];
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * ysggdic = [[NSMutableDictionary alloc] init];
    [ysggdic setObject:@"12" forKey:@"position_id"];
    [b setObject:ysggdic forKey:@"gz_ad"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        [[NSUserDefaults standardUserDefaults]setObject:returnData forKey:@"gz_ad_cache"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSDictionary *b=[returnData objectForKey:@"b"];
        NSDictionary *addic=[b objectForKey:@"gz_ad"];
        NSArray *adlist=[addic objectForKey:@"ad_list"];
        float imgh=50;
       
        if (adlist.count>0) {
            for (int i=0; i<adlist.count; i++) {
                NSString *url=[adlist[i] objectForKey:@"url"];
                NSString *title=[adlist[i] objectForKey:@"title"];
                NSString *imgurl=[adlist[i] objectForKey:@"img_path"];
                NSString *fx_content=[adlist[i] objectForKey:@"fx_content"];
                if (fx_content.length>0) {
                    [self.ysadshares addObject:fx_content];
                }
                [self.ysadimgurls addObject:imgurl];
                [self.ysadurls addObject:url];
                [self.ysadtitles addObject:title];
                if (i==0) {
                    NSData *resultData = [NSData dataWithContentsOfURL:[ShareFun makeImageUrl:imgurl]];
                    UIImage *img = [UIImage imageWithData:resultData];
//                    imgh=img.size.height;
                    imgh=img.size.height*kScreenWidth/img.size.width;
                    
                    
                }
            }
            
        }
        if ([[setting sharedSetting].fs isEqualToString:@"启动"]) {
            [self.ysadscro removeFromSuperview];
            self.ysadscro=nil;
            if (adlist.count>0) {
                if (self.ysadscro==nil) {
                    if (imgh==NAN) {
                        imgh=50;
                    }
                    self.ysadscro = [[ViedoADSrcollView alloc] initWithNameArr:self.ysadimgurls  titleArr:nil height:imgh offsetY:self.mheight+3 offsetx:0];
                    self.ysadscro.vDelegate=self;
                    [_glassScrollView.foregroundScrollView addSubview:self.ysadscro];
                }
                self.mheight=self.mheight+imgh+6;
            }else{
                self.mheight=shzshight;
            }
            
        }else{
            self.mheight=shzshight;
        }
//        _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.mheight);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadriliview];});
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadmltq];});
//        [self loadCotachView];
//        [self loadqxys];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:[[ShareFun shareAppDelegate] window] animated:YES];
    } withCache:YES];
    
}
-(void)cacheysad{
//    self.isswipe=YES;
    [self.ysadurls removeAllObjects];
    [self.ysadimgurls removeAllObjects];
    [self.ysadtitles removeAllObjects];
    NSDictionary *returnData=[[NSUserDefaults standardUserDefaults]objectForKey:@"gz_ad_cache"];
    if (returnData) {
        NSDictionary *b=[returnData objectForKey:@"b"];
        NSDictionary *addic=[b objectForKey:@"gz_ad"];
        NSArray *adlist=[addic objectForKey:@"ad_list"];
        float imgh=50;
        
        if (adlist.count>0) {
            for (int i=0; i<adlist.count; i++) {
                NSString *url=[adlist[i] objectForKey:@"url"];
                NSString *title=[adlist[i] objectForKey:@"title"];
                NSString *imgurl=[adlist[i] objectForKey:@"img_path"];
                NSString *fx_content=[adlist[i] objectForKey:@"fx_content"];
                if (fx_content.length>0) {
                    [self.ysadshares addObject:fx_content];
                }
                [self.ysadimgurls addObject:imgurl];
                [self.ysadurls addObject:url];
                [self.ysadtitles addObject:title];
                
            }
            
        }
        if ([[setting sharedSetting].fs isEqualToString:@"启动"]) {
            if (adlist.count>0) {
                [self.ysadscro removeFromSuperview];
                self.ysadscro=nil;
                if (self.ysadscro==nil) {
               
                    self.ysadscro = [[ViedoADSrcollView alloc] initWithNameArr:self.ysadimgurls  titleArr:nil height:imgh offsetY:self.mheight+3 offsetx:0];
                    self.ysadscro.vDelegate=self;
                    [_glassScrollView.foregroundScrollView addSubview:self.ysadscro];
                }
                self.mheight=self.mheight+imgh+6;
            }else{
                self.mheight=shzshight;
            }
            
        }else{
            self.mheight=shzshight;
        }
        [self loadriliview];
//        [self loadCotachView];
        [self cachemltq];
//        [self cacheqxys];
        
    }
    
}

-(void)loadriliview{
    riliview.frame=CGRectMake(0, self.mheight, kScreenWidth, 150);
    self.mheight=self.mheight+150;
    _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.mheight);
    
}
#pragma mark漫聊
-(void)loadmltq{
    
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [b setObject:gz_todaywt_inde forKey:@"gz_mltq_index"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        [[NSUserDefaults standardUserDefaults]setObject:returnData forKey:@"gz_mltq_index_cache"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSMutableArray *mllist=[[NSMutableArray alloc]init];
        if (b!=nil) {
            
            NSDictionary * gz_mltq_index = [b objectForKey:@"gz_mltq_index"];
            if (gz_mltq_index!=nil) {
                NSArray *infolist=[gz_mltq_index objectForKey:@"info_list"];
                if (infolist.count>0) {
                    NSArray *tqzxlist=[infolist[0] objectForKey:@"sub_list"];
                    NSString *tqid=[infolist[0] objectForKey:@"channel_id"];
                    NSArray *zjlist=[infolist[1] objectForKey:@"sub_list"];
                    NSString *zjid=[infolist[1] objectForKey:@"channel_id"];
                    self.zjid=zjid;
                    self.tqzxid=tqid;
                    NSString *name=[infolist[0] objectForKey:@"name"];
                    NSString *zjname=[infolist[1] objectForKey:@"name"];
                    if (tqzxlist.count>0) {
                        for (int i=0; i<tqzxlist.count; i++) {
                            [mllist addObject:tqzxlist[i]];
                        }
                    }
                    if (zjlist.count>0) {
                        for (int i=0; i<zjlist.count; i++) {
                            [mllist addObject:zjlist[i]];
                        }
                    }
                    [mltqview getinfoslist:mllist Withtqname:name Withzjname:zjname withcount:tqzxlist.count];
                    
                }
              
            
        }
        }
        mltqview.frame=CGRectMake(0, self.mheight, kScreenWidth, 40+mllist.count*70);
        self.mheight=self.mheight+40+mllist.count*70;
        _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.mheight);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadqxys];});
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
//        [MBProgressHUD hideHUDForView:[[ShareFun shareAppDelegate] window] animated:YES];
    } withCache:YES];
    
}
-(void)cachemltq{
    NSDictionary *returnData=[[NSUserDefaults standardUserDefaults]objectForKey:@"gz_mltq_index_cache"];
        NSDictionary * b = [returnData objectForKey:@"b"];
     NSMutableArray *mllist=[[NSMutableArray alloc]init];
        if (b!=nil) {
         
            NSDictionary * gz_mltq_index = [b objectForKey:@"gz_mltq_index"];
           
            if (gz_mltq_index!=nil) {
                NSArray *infolist=[gz_mltq_index objectForKey:@"info_list"];
                if (infolist.count>0) {
                    NSArray *tqzxlist=[infolist[0] objectForKey:@"sub_list"];
                    NSString *tqid=[infolist[0] objectForKey:@"channel_id"];
                    NSArray *zjlist=[infolist[1] objectForKey:@"sub_list"];
                    NSString *zjid=[infolist[1] objectForKey:@"channel_id"];
                    self.zjid=zjid;
                    self.tqzxid=tqid;
                    NSString *name=[infolist[0] objectForKey:@"name"];
                    NSString *zjname=[infolist[1] objectForKey:@"name"];
                    if (tqzxlist.count>0) {
                        for (int i=0; i<tqzxlist.count; i++) {
                            [mllist addObject:tqzxlist[i]];
                        }
                    }
                    if (zjlist.count>0) {
                        for (int i=0; i<zjlist.count; i++) {
                            [mllist addObject:zjlist[i]];
                        }
                    }
                    [mltqview getinfoslist:mllist Withtqname:name Withzjname:zjname withcount:tqzxlist.count];
                }
                
                
            }
            
        }
    mltqview.frame=CGRectMake(0, self.mheight, kScreenWidth, 40+mllist.count*60);
    self.mheight=self.mheight+40+mllist.count*60;
    _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.mheight);
    [self cacheqxys];
   
    
}
-(void)loadCotachView{
    if (mltqview) {
        mltqview.delegate=nil;
        [mltqview removeFromSuperview];
        mltqview=nil;
    }
    mltqview=[[CotachWeatherView alloc]initWithFrame:CGRectMake(0, 1750, kScreenWidth, 220) WithInfos:nil];
    mltqview.delegate=self;
    [_glassScrollView.foregroundScrollView addSubview:mltqview];
//    self.mheight=self.mheight+220;
//    _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.mheight);
}
//-(void)loadQXYS{
//    
//    NSString * urlStr = URL_SERVER;
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
//    [gz_todaywt_inde setObject:@"gz_qxys_img" forKey:@"key"];
//    [b setObject:gz_todaywt_inde forKey:@"gz_queryconfig"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
//        NSDictionary * b = [returnData objectForKey:@"b"];
//        [self.viedoview removeFromSuperview];
//        self.viedoview=nil;
//        if (b!=nil) {
//            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_queryconfig"];
//            NSString *value=[gz_air_qua_index objectForKey:@"value"];
////            [self.mainview updateYSInfo:value];
////            NSLog(@"%d",self.mainview.viewHeight);
//            if (!self.viedoview) {
//                self.viedoview=[[ViedoView alloc]initWithFrame:CGRectMake(0, self.viewHeight, kScreenWidth, 180)];
//                self.viedoview.delegate=self;
//                [_glassScrollView.foregroundScrollView addSubview:self.viedoview];
//                [self.viedoview updateYSInfo:value];
//                self.viewHeight=self.viewHeight+180;
//            }
//            _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.viewHeight);
//            [self loadSHZS];
//        }
//        
//        
//    } withFailure:^(NSError *error) {
//        NSLog(@"failure");
//        [MBProgressHUD hideHUDForView:[[ShareFun shareAppDelegate] window] animated:YES];
//    } withCache:YES];
//
//}
//-(void)cacheqxys{
//   
//    NSString * urlStr = URL_SERVER;
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
//    [gz_todaywt_inde setObject:@"gz_qxys_img" forKey:@"key"];
//    [b setObject:gz_todaywt_inde forKey:@"gz_queryconfig"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    [[NetWorkCenter share] getCacheWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
//        NSDictionary * b = [returnData objectForKey:@"b"];
//        [self.viedoview removeFromSuperview];
//        self.viedoview=nil;
//        if (b!=nil) {
//            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_queryconfig"];
//            NSString *value=[gz_air_qua_index objectForKey:@"value"];
////            [self.mainview updateYSInfo:value];
//            if (!self.viedoview) {
//                self.viedoview=[[ViedoView alloc]initWithFrame:CGRectMake(0, self.viewHeight, kScreenWidth, 180)];
//                self.viedoview.delegate=self;
//                [_glassScrollView.foregroundScrollView addSubview:self.viedoview];
//                [self.viedoview updateYSInfo:value];
//                self.viewHeight=self.viewHeight+180;
//            }
//            _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.viewHeight);
//            [self cacheshzs];
//        }
//        
//    } withFailure:^(NSError *error) {
//        NSLog(@"failure");
//    } withCache:YES];
//}
-(void)loadqxys{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:@"17" forKey:@"position_id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_ad"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        [[NSUserDefaults standardUserDefaults]setObject:returnData forKey:@"gz_ad17_cache"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];
            if (adlist.count>0) {
                self.viedoview.hidden=NO;
//                [self.viedoview removeFromSuperview];
//                self.viedoview=nil;
//                if (!self.viedoview) {
//                    self.viedoview=[[ViedoView alloc]initWithFrame:CGRectMake(0, self.mheight, kScreenWidth, 180)];
//                    self.viedoview.delegate=self;
//                    [_glassScrollView.foregroundScrollView addSubview:self.viedoview];
//                    
//                }
                self.viedoview.frame=CGRectMake(0, self.mheight, kScreenWidth, 180);
                [self.viedoview upYSdatas:adlist];
                self.mheight=self.mheight+180;
                _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.mheight);
                
            }else{
                self.viedoview.hidden=YES;
            }
//            [self loadSHZS];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadMainAD];});
 
        }
        
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[ShareFun shareAppDelegate].window animated:YES];
        NSLog(@"failure");
    } withCache:YES];
}
-(void)cacheqxys{
    
//    NSString * urlStr = URL_SERVER;
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
//    [gz_todaywt_inde setObject:@"17" forKey:@"position_id"];
//    [b setObject:gz_todaywt_inde forKey:@"gz_ad"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    [[NetWorkCenter share] getCacheWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
    NSDictionary *returnData=[[NSUserDefaults standardUserDefaults]objectForKey:@"gz_ad17_cache"];
    if (returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];
            if (adlist.count>0) {
                self.viedoview.hidden=NO;
                self.viedoview.frame=CGRectMake(0, self.mheight, kScreenWidth, 180);
                [self.viedoview upYSdatas:adlist];
                self.mheight=self.mheight+180;
            }else{
                self.viedoview.hidden=YES;
            }
//            [self.viedoview removeFromSuperview];
//            self.viedoview=nil;
//            if (!self.viedoview) {
//                self.viedoview=[[ViedoView alloc]initWithFrame:CGRectMake(0, self.mheight, kScreenWidth, 180)];
//                self.viedoview.delegate=self;
//                [_glassScrollView.foregroundScrollView addSubview:self.viedoview];
//                [self.viedoview upYSdatas:adlist];
//                self.mheight=self.mheight+180;
//            }
            _glassScrollView.foregroundScrollView.contentSize=CGSizeMake(kScreenWidth, self.mheight);
//            [self cacheshzs];
            [self cacheMainAD];
            
        }
    }
//    } withFailure:^(NSError *error) {
//        NSLog(@"failure");
//    } withCache:YES];
}
-(void)cacheshzs{
//    NSString * urlStr = URL_SERVER;
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    NSMutableDictionary * shzs = [[NSMutableDictionary alloc] init];
//    [shzs setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
//    [b setObject:shzs forKey:@"gz_live_index"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    [[NetWorkCenter share] getCacheWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
    NSDictionary *returnData=[[NSUserDefaults standardUserDefaults]objectForKey:@"gz_live_index_cache"];
    if (returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * shzs = [b objectForKey:@"gz_live_index"];
            NSArray * idx = [shzs objectForKey:@"live"];
            self.lifeinfos=[self creatlife:idx];
            NSMutableDictionary * info = [[NSMutableDictionary alloc] init];
            NSDictionary *lifedic=[setting sharedSetting].lifedic;
            NSArray * lifeArr = [lifedic objectForKey:@"life"];
            [info setObject:[self configLifeWith:lifeArr WithAllLifeDic:returnData] forKey:@"moduInfo"];
            NSDictionary *moduInfo=[info objectForKey:@"moduInfo"];
            NSDictionary * b1 = [moduInfo objectForKey:@"b"];
            NSDictionary * shzs1 = [b1 objectForKey:@"gz_live_index"];
            NSArray * idx1 = [shzs1 objectForKey:@"live"];
            NSInteger number = idx1.count;
            NSDictionary *lifedic1=[setting sharedSetting].lifedic;
            NSArray * lifeArr1 = [lifedic1 objectForKey:@"life"];
            if (lifeArr1.count>0) {
                int n=0;
                for(int i=0;i<lifeArr1.count-1;i++){ //循环开始元素
                    for(int j = i + 1;j < lifeArr1.count;j++){ //循环后续所有元素
                        //如果相等，则重复
                        if(lifeArr1[i] == lifeArr1[j]){
                            n=n+1;
                        }
                    }
                }
                number = lifeArr1.count-n;
            }
            if (lifeArr1==nil ) {
                if(idx.count >=4)
                {
                    number=4;
                }
                else
                {
                    number = idx.count;
                }
                
            }
            float height = 15+10+67*((number+2)/2+(number+2)%2)-67;
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            
            //生活指数本地保存的不一样，只取本地有的
            
            if (idx1.count>=number) {
                
            }else{
                if(idx1.count >=4)
                {
                    number=4;
                }
                else
                {
                    number = idx1.count;
                }
            }
            for(int i=0;i<number;i++)
            {
                height = 60*((number+2)/2+(number+2)%2)-40+20;
                if (idx1.count>0) {
                    
                    NSDictionary * idxInfo = [idx1 objectAtIndex:i];
                    NSString * create_time = [idxInfo objectForKey:@"create_time"];
                    NSString * des = [idxInfo objectForKey:@"des"];
                    NSString * ico_name = [idxInfo objectForKey:@"ico_name"];
                    NSString * ico_path = [idxInfo objectForKey:@"ico_path"];
                    NSString * index_name = [idxInfo objectForKey:@"index_name"];
                    NSString * lv = [idxInfo objectForKey:@"lv"];
                    NSString * simple_des = [idxInfo objectForKey:@"simple_des"];
                    NSString * shzs_url = [idxInfo objectForKey:@"live_url"];
                    QualityOfLifeInfo * quality = [[QualityOfLifeInfo alloc] initWithIndex_name:index_name withDes:des withSimple_des:simple_des withIco_path:ico_path withCreate_time:create_time withLv:lv withIco_name:ico_name withShzs_rul:shzs_url];
                    //                        NSLog(@"%@",[setting sharedSetting].lifedic);
                    [infos addObject:quality];
                }
                
                
            }
            //            if (infos.count>0) {
            [self.weekWeather removeFromSuperview];
            self.weekWeather=nil;
            if (!(infos.count>0)) {
                height=40;
            }
            if (!(idx.count>0)) {
                height=0;
            }
            self.weekWeather = [[QualityOfLifeView alloc] initWithFrame:CGRectMake(0, self.viewHeight, kScreenWidth, height) withInfos:infos withController:self wiheHeight:height withSerinfos:idx];
//            self.mainview.frame=CGRectMake(0, 460, kScreenWidth, self.viewHeight-290+height);
            self.mheight=self.viewHeight+height;
            shzshight=self.viewHeight+height;
            [_glassScrollView.foregroundScrollView addSubview:self.
             weekWeather];
//            }else{
//                self.mheight=self.viewHeight-35;
//            }
//            [self cacheMainAD];
            [self cacheysad];
        }
        
    }
//    } withFailure:^(NSError *error) {
//        NSLog(@"failure");
//    } withCache:YES];
    
}
-(void)loadSHZS{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * shzs = [[NSMutableDictionary alloc] init];
    if ([setting sharedSetting].currentCityID.length>0) {
        [shzs setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    }
    [b setObject:shzs forKey:@"gz_live_index"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        //        NSLog(@"success");
        //更新首界面1接界面
        
        [[NSUserDefaults standardUserDefaults]setObject:returnData forKey:@"gz_live_index_cache"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * shzs = [b objectForKey:@"gz_live_index"];
            NSArray * idx = [shzs objectForKey:@"live"];
            self.lifeinfos=[self creatlife:idx];
            NSMutableDictionary * info = [[NSMutableDictionary alloc] init];
            NSDictionary *lifedic=[setting sharedSetting].lifedic;
            NSArray * lifeArr = [lifedic objectForKey:@"life"];
            [info setObject:[self configLifeWith:lifeArr WithAllLifeDic:returnData] forKey:@"moduInfo"];
            NSDictionary *moduInfo=[info objectForKey:@"moduInfo"];
            NSDictionary * b1 = [moduInfo objectForKey:@"b"];
            NSDictionary * shzs1 = [b1 objectForKey:@"gz_live_index"];
            NSArray * idx1 = [shzs1 objectForKey:@"live"];
            NSInteger number = idx1.count;
            NSDictionary *lifedic1=[setting sharedSetting].lifedic;
            NSArray * lifeArr1 = [lifedic1 objectForKey:@"life"];
            if (lifeArr1.count>0) {
                int n=0;
                for(int i=0;i<lifeArr1.count-1;i++){ //循环开始元素
                    for(int j = i + 1;j < lifeArr1.count;j++){ //循环后续所有元素
                        //如果相等，则重复
                        if(lifeArr1[i] == lifeArr1[j]){
                            n=n+1;
                        }
                    }
                }
                number = lifeArr1.count-n;
            }
            if (lifeArr1==nil ) {
                if(idx.count >=4)
                {
                    number=4;
                }
                else
                {
                    number = idx.count;
                }
                
            }
            float height = 15+10+67*((number+2)/2+(number+2)%2)-67;
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            
            //生活指数本地保存的不一样，只取本地有的
            
            if (idx1.count>=number) {
                
            }else{
                if(idx1.count >=4)
                {
                    number=4;
                }
                else
                {
                    number = idx1.count;
                }
            }
            for(int i=0;i<number;i++)
            {
                 height = 60*((number+2)/2+(number+2)%2)-40+20;
                if (idx1.count>0) {
                   
                    NSDictionary * idxInfo = [idx1 objectAtIndex:i];
                    NSString * create_time = [idxInfo objectForKey:@"create_time"];
                    NSString * des = [idxInfo objectForKey:@"des"];
                    NSString * ico_name = [idxInfo objectForKey:@"ico_name"];
                    NSString * ico_path = [idxInfo objectForKey:@"ico_path"];
                    NSString * index_name = [idxInfo objectForKey:@"index_name"];
                    NSString * lv = [idxInfo objectForKey:@"lv"];
                    NSString * simple_des = [idxInfo objectForKey:@"simple_des"];
                    NSString * shzs_url = [idxInfo objectForKey:@"live_url"];
                    QualityOfLifeInfo * quality = [[QualityOfLifeInfo alloc] initWithIndex_name:index_name withDes:des withSimple_des:simple_des withIco_path:ico_path withCreate_time:create_time withLv:lv withIco_name:ico_name withShzs_rul:shzs_url];
                    //                        NSLog(@"%@",[setting sharedSetting].lifedic);
                    [infos addObject:quality];
                }
                
               
            }
//            if (infos.count>0) {
                [self.weekWeather removeFromSuperview];
                self.weekWeather=nil;
            if (!infos.count>0) {
                height=40;
            }
            if (!idx.count>0) {
                height=0;
            }
                self.weekWeather = [[QualityOfLifeView alloc] initWithFrame:CGRectMake(0, self.viewHeight, kScreenWidth, height) withInfos:infos withController:self wiheHeight:height withSerinfos:idx];
//                self.mainview.frame=CGRectMake(0, 460, kScreenWidth, self.viewHeight-290+height);
                self.mheight=self.viewHeight+height;
            shzshight=self.viewHeight+height;
                [_glassScrollView.foregroundScrollView addSubview:self.
                 weekWeather];
//            }else{
//                self.mheight=self.viewHeight-35;
//            }
            
//             [self loadMainAD];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadysad];});
            //首页加载完成
            
            
        }else{
            [self.weekWeather removeFromSuperview];
            self.weekWeather=nil;
            float height=0;
            NSArray *infos=[[NSArray alloc]init];
            self.weekWeather = [[QualityOfLifeView alloc] initWithFrame:CGRectMake(0, self.viewHeight, kScreenWidth, height+20) withInfos:infos withController:self wiheHeight:height withSerinfos:nil];
//            self.mainview.frame=CGRectMake(0, 460, kScreenWidth, self.viewHeight-290+height);
            self.mheight=self.viewHeight+height;
            [_glassScrollView.foregroundScrollView addSubview:self.
             weekWeather];
//            [self loadMainAD];
            [self loadysad];
        }
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[[ShareFun shareAppDelegate] window] animated:YES];
        NSLog(@"failure");
    } withCache:YES];
}
-(NSDictionary *)configLifeWith:(NSArray *)lifes WithAllLifeDic:(NSDictionary *)dic
{
    //    NSLog(@"%@",dic);
    if(lifes == nil)
    {
        return dic;
    }
    //    NSLog(@"%p",dic);
    NSMutableDictionary * newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSDictionary * b = [dic objectForKey:@"b"];
    NSDictionary * shzs = [b objectForKey:@"gz_live_index"];
    NSArray * index = [shzs objectForKey:@"live"];
    NSDictionary * h = [dic objectForKey:@"h"];
    NSDictionary * e = [dic objectForKey:@"e"];
    
    NSMutableDictionary * newB = [NSMutableDictionary dictionaryWithDictionary:b];
    NSMutableDictionary * newShzs = [NSMutableDictionary dictionaryWithDictionary:shzs];
    NSMutableDictionary * newH = [NSMutableDictionary dictionaryWithDictionary:h];
    NSMutableDictionary * newE = [NSMutableDictionary dictionaryWithDictionary:e];
    NSMutableArray * newIndex = [[NSMutableArray alloc] init];
    [newDic setObject:newH forKey:@"h"];
    [newDic setObject:newB forKey:@"b"];
    [newDic setObject:newE forKey:@"e"];
    [newB setObject:newShzs forKey:@"gz_live_index"];
    [newShzs setObject:newIndex forKey:@"live"];
    
    for (int i=0; i<index.count; i++) {
        NSDictionary * lifeInfo = [index objectAtIndex:i];
        NSString * index_name = [lifeInfo objectForKey:@"index_name"];
        
        for(int k=0;k<lifes.count;k++)
        {
            NSString * saveLifeName = [lifes objectAtIndex:k];
            if([index_name isEqualToString:saveLifeName])
            {
                [newIndex addObject:lifeInfo];
                break;
            }
        }
    }
    //    NSLog(@"##%p##",dic);
//        NSLog(@"##%p##",newDic);
    //    NSLog(@"$%@$",dic);
    return newDic;
}
-(NSMutableArray *)creatlife:(NSArray *)lifearr{
    NSMutableArray *lifeinfos=[[NSMutableArray alloc]init];
    //    NSLog(@"%@",[setting sharedSetting].lifedic);
    if (![[setting sharedSetting].lifedic objectForKey:@"life"]) {
        for (int i=0; i<lifearr.count; i++) {
            //        NSDictionary * idxInfo = [lifeinfos objectAtIndex:i];
            NSString *lifename=[[lifearr objectAtIndex:i]objectForKey:@"index_name"];
            //            NSString *lifeimg=[[lifearr objectAtIndex:i]objectForKey:@"ico_name"];
            NSString *lifeimg=[[lifearr objectAtIndex:i]objectForKey:@"ico2_path"];
            BOOL isChoose = YES;
            if (i>=4) {
                isChoose=NO;
            }
            NSMutableDictionary * dic=[[NSMutableDictionary alloc]init];
            [dic setObject:[NSNumber numberWithBool:isChoose] forKey:@"state"];
            [dic setObject:lifename forKey:@"name"];
            [dic setObject:lifeimg forKey:@"img"];
            [lifeinfos addObject:dic];
        }
    }
    else
    {
        for (int i=0; i<lifearr.count; i++) {
            //        NSDictionary * idxInfo = [lifeinfos objectAtIndex:i];
            NSString *lifename=[[lifearr objectAtIndex:i]objectForKey:@"index_name"];
            //            NSString *lifeimg=[[lifearr objectAtIndex:i]objectForKey:@"ico_name"];
            NSString *lifeimg=[[lifearr objectAtIndex:i]objectForKey:@"ico2_path"];
            BOOL isChoose = NO;
            NSMutableArray *lifeArr=[[setting sharedSetting].lifedic objectForKey:@"life"];
            for (int j=0; j<[lifeArr count]; j++) {
                NSString *lifename1=[lifeArr objectAtIndex:j];
                if ([lifename isEqualToString:lifename1]) {
                    isChoose = YES;
                }
                
            }
            NSMutableDictionary * dic=[[NSMutableDictionary alloc]init];
            [dic setObject:[NSNumber numberWithBool:isChoose] forKey:@"state"];
            [dic setObject:lifename forKey:@"name"];
            [dic setObject:lifeimg forKey:@"img"];
            [lifeinfos addObject:dic];
        }
    }
    
    return lifeinfos;
}
//版本检测
-(void)versionDetection
{
    
    [[NetWorkCenter share] postVersionWithSuccess:^(NSDictionary *returnData) {
        //        NSLog(@"%@",returnData);
        NSArray *infoArray = [returnData objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *message;
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            NSString *currentVersion=[ShareFun localVersion];
            NSString *cvnow=[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *lvnow=[lastVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            if (cvnow.integerValue<lvnow.integerValue) {
                trackViewURL = [releaseInfo objectForKey:@"trackViewUrl"];
//                NSString *title=[NSString stringWithFormat:@"知天气%@发布日志",lastVersion];
                message=[releaseInfo objectForKey:@"releaseNotes"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"知天气提示" message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                alert.tag = 10000;
                [alert show];
            }
//            NSString *cv=[currentVersion substringToIndex:1];
//            NSString *lv=[lastVersion substringToIndex:1];
//            NSString *newcv=[currentVersion substringFromIndex:4];
//            NSString *newlv=[lastVersion substringFromIndex:4];
//            if (cv.integerValue <lv.integerValue) {
//                    trackViewURL = [releaseInfo objectForKey:@"trackViewUrl"];
//                    NSString *title=[NSString stringWithFormat:@"知天气%@发布日志",lastVersion];
//                    message=[releaseInfo objectForKey:@"releaseNotes"];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
//                    alert.tag = 10000;
//                    [alert show];
//            }
//            if (cv.integerValue==lv.integerValue) {
//                if (newcv.integerValue<newlv.integerValue) {
//                    trackViewURL = [releaseInfo objectForKey:@"trackViewUrl"];
//                    NSString *title=[NSString stringWithFormat:@"知天气%@发布日志",lastVersion];
//                    message=[releaseInfo objectForKey:@"releaseNotes"];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
//                    alert.tag = 10000;
//                    [alert show];
//                }
//            }
           
        }
        
        
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[ShareFun shareAppDelegate].window animated:YES];
        NSLog(@"failue");
    }];
}
-(void)yjdetali:(UIButton *)sender{
    self.isswipe=YES;
    NSInteger tag=sender.tag;
    NSString *warn_id;
    warn_id=[self.warnlist[tag] objectForKey:@"warn_id"];
    YJpushViewController *yjdelital=[[YJpushViewController alloc]init];

    yjdelital.warnid=warn_id;
    [self.navigationController pushViewController:yjdelital animated:YES];
    //    Alert *a=[[Alert alloc]initWithLogoImage:@"by_B" withTitle:@"暴雨蓝色预警" withContent:@"暴雨蓝色拉那是啥阿三可哦啊是啤酒" WithTime:@"福建省气象局12日12时发布" withType:@"预警"];
//    self.isswipe=YES;
//    NSInteger tag=sender.tag;
//    NSString *desc,*color,*ico,*warninfo,*put,*putstr,*fyznstr,*warn_id;
//    desc = [self.warnlist[tag] objectForKey:@"title"];
//    color = [self.warnlist[tag] objectForKey:@"color"];
//    ico = [self.warnlist[tag] objectForKey:@"ico"];
//    warninfo   = [self.warnlist[tag] objectForKey:@"content"];
//    put=[self.warnlist[tag] objectForKey:@"pt"];
//    putstr=[self.warnlist[tag] objectForKey:@"station_name"];
//    fyznstr=[self.warnlist[tag] objectForKey:@"defend"];
//    warn_id=[self.warnlist[tag] objectForKey:@"warn_id"];
//    DelitalViewController *yjdelital=[[DelitalViewController alloc]init];
//    yjdelital.ico=ico;
//    yjdelital.titlestr=desc;
//    yjdelital.fyzninfo=fyznstr;
//    yjdelital.putstring=[NSString stringWithFormat:@"%@  %@",putstr,put];
//    yjdelital.warninfo=warninfo;
//    yjdelital.warnid=warn_id;
//    [self.navigationController pushViewController:yjdelital animated:YES];
//    Alert *a=[[Alert alloc]initWithLogoImage:@"by_B" withTitle:@"暴雨蓝色预警" withContent:@"暴雨蓝色拉那是啥阿三可哦啊是啤酒" WithTime:@"福建省气象局12日12时发布" withType:@"预警"];
//    [a show];
}
-(void)tcAction{
    self.isswipe=YES;
    NSLog(@"吐槽");
}
-(void)liveAction{
    self.isswipe=YES;
    LivePhotoViewController * photoVC = [[LivePhotoViewController alloc] init];
    [self.navigationController pushViewController:photoVC animated:YES];
}
#pragma mark分享
-(void)shareAction{
    
    
    self.isswipe=YES;
    [self getShareContent];
    //分享
    ShareSheet * sheet = [[ShareSheet alloc] initDefaultWithTitle:@"分享天气" withDelegate:self];
    [sheet show];
    [self performSelector:@selector(getCaptureScreen) withObject:nil afterDelay:0];
}
-(void)getCaptureScreen{
    UIImage *t_shareImage = [self captureScreen];
    self.shareimg=t_shareImage;
    NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
    if ([UIImagePNGRepresentation(t_shareImage) writeToFile:shareImagePath atomically:YES])
        NSLog(@">>write ok");
}
-(UIImageView *)creatNavBG{
    UIImageView *navimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,64)];
    navimg.backgroundColor = [UIColor clearColor];
    
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 44, 42)];
    leftimg.image=[UIImage imageNamed:@"城市添加.png"];
    [navimg addSubview:leftimg];
    UIImageView *rightimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-60, 20, 44, 42)];
    rightimg.image=[UIImage imageNamed:@"个人中心.png"];
    [navimg addSubview:rightimg];
    
    UIImageView *t_img=[[UIImageView alloc]initWithFrame:CGRectMake(80, 27, 18, 23)];
    t_img.image=self.qbtitle.image;
    [navimg addSubview:t_img];
    CGRect frame = t_img.frame;
    frame.size =self.qbtitle.imageView.frame.size;
    
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 27, 200, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text =self.qbtitle.title;
    [navimg addSubview:titleLab];
   
    CGFloat margin =6;
    CGSize imageViewSize = frame.size;
    
    CGSize actualTitleSize = [self.qbtitle.title sizeWithFont:[UIFont boldSystemFontOfSize:20] forWidth:kScreenWidth lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGRect titleLabelFrame;
    CGRect imageViewFrame;
        titleLabelFrame = CGRectMake((kScreenWidth- actualTitleSize.width) / 2, 27, actualTitleSize.width, 30);
        imageViewFrame = CGRectMake(titleLabelFrame.origin.x - (imageViewSize.width + margin), (80 - imageViewSize.height) / 2, imageViewSize.width, imageViewSize.height);
    t_img.frame=imageViewFrame;
    titleLab.frame=titleLabelFrame;
    return navimg;
}
-(UIImage *) captureScreen
{
    NSMutableArray *images=[[NSMutableArray alloc]init];
    
    //构造nav
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 64), NO, 0.0);
    [[self creatNavBG].layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images addObject:tempImage];
    
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(_glassScrollView.foregroundScrollView.contentSize, NO, 0.0);
//    UIGraphicsBeginImageContext(_glassScrollView.foregroundScrollView.contentSize);
    {
        CGPoint savedContentOffset = _glassScrollView.foregroundScrollView.contentOffset;
        CGRect savedFrame = _glassScrollView.foregroundScrollView.frame;
        
        _glassScrollView.foregroundScrollView.contentOffset = CGPointZero;
        _glassScrollView.foregroundScrollView.frame = CGRectMake(0, 0, kScreenWidth, _glassScrollView.foregroundScrollView.contentSize.height);
        [_glassScrollView.foregroundScrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        _glassScrollView.foregroundScrollView.contentOffset = savedContentOffset;
        _glassScrollView.foregroundScrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    [images addObject:image];
    //添加二维码
    UIImage *ewmimg=[UIImage imageNamed:@"指纹二维码.jpg"];
    UIImageView *ewm=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 177)];
    ewm.image=ewmimg;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 177), NO, 0.0);
    [ewm.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImage1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images addObject:tempImage1];
    
//    [self verticalImageFromArray:images];
    UIImage *newimg=[self verticalImageFromArray:images];
    
    //构造底层背景
    NSMutableArray *images1=[[NSMutableArray alloc]init];
    UIImage *img=_glassScrollView.blurredBackgroundImage;
    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 800)];
    bgimg.image=self.bgimg;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 800), NO, 0.0);
    [bgimg.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImage2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images1 addObject:tempImage2];
    
    UIImageView *bgimg1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 800, kScreenWidth, newimg.size.height-kScreenHeitht)];
    bgimg1.image=img;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(800, newimg.size.height-800), NO, 0.0);
    [bgimg1.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImage3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images1 addObject:tempImage3];
    UIImage *newbgimg=[self verticalImageFromArray:images1];
    UIGraphicsBeginImageContextWithOptions(newimg.size, NO, 0.0);
    [newbgimg drawInRect:CGRectMake(0, 0, kScreenWidth, newimg.size.height)];

//    UIGraphicsBeginImageContextWithOptions(newimg.size, NO, 0.0);
//    [img drawInRect:CGRectMake(0, 0, kScreenWidth, newimg.size.height)];
    
    [newimg drawInRect:CGRectMake(0,
                                     0,
                                     kScreenWidth,
                                     newimg.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resultingImage;
}

-(UIImage *)verticalImageFromArray:(NSArray *)imagesArray
{
    UIImage *unifiedImage = nil;
    CGSize totalImageSize = [self verticalAppendedTotalImageSizeFromImagesArray:imagesArray];
    UIGraphicsBeginImageContextWithOptions(totalImageSize, NO, 0.f);

    int imageOffsetFactor = 0;
    for (UIImage *img in imagesArray) {
        [img drawAtPoint:CGPointMake(0, imageOffsetFactor)];
        imageOffsetFactor += img.size.height;
    }
    
    unifiedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return unifiedImage;
}

-(CGSize)verticalAppendedTotalImageSizeFromImagesArray:(NSArray *)imagesArray
{
    CGSize totalSize = CGSizeZero;
    for (UIImage *im in imagesArray) {
        CGSize imSize = [im size];
        totalSize.height += imSize.height;
        // The total width is gonna be always the wider found on the array
        totalSize.width = kScreenWidth;
    }
    return totalSize;
}
-(void)getShareContent{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [gz_todaywt_inde setObject:@"WT_TRID_DAY" forKey:@"keyword"];
    [b setObject:gz_todaywt_inde forKey:@"gz_wt_share"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_wt_share"];
            NSString *sharecontent=[gz_air_qua_index objectForKey:@"share_content"];
            self.sharecontent=sharecontent;
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath
{
    NSString *shareContent = self.sharecontent;
    switch (indexPath)
    {
        case 0: {
            weiboVC *t_weibo = [[weiboVC alloc] initWithNibName:@"weiboVC" bundle:nil];
            [t_weibo setShareText:shareContent];
            [t_weibo setShareImage:@"weiboShare.png"];
            [t_weibo setShareType:1];
            [self presentViewController:t_weibo animated:YES completion:nil];
            //			[t_weibo release];
            break;
        }
        case 1:{
//            //创建分享消息对象
//            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//            
//            //创建图片内容对象
//            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//            //如果有缩略图，则设置缩略图
//            [shareObject setShareImage:self.shareimg];
//            
//            //分享消息对象设置分享内容对象
//            messageObject.shareObject = shareObject;
            NSString *url;
            if ([self.sharecontent rangeOfString:@"http"].location!=NSNotFound) {
                NSArray *arr=[self.sharecontent componentsSeparatedByString:@"http"];
                if (arr.count>0) {
                    url=[NSString stringWithFormat:@"http%@",arr[1]];
                }
            }
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            //创建图片内容对象
            //            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //            //如果有缩略图，则设置缩略图
            //            [shareObject setShareImage:self.shareimg];
            UMShareWebpageObject *shareweb=[[UMShareWebpageObject alloc]init];
            shareweb.webpageUrl=url;
            shareweb.title=@"知天气分享";
            shareweb.thumbImage=[ShareFun captureScreen];
            shareweb.descr=self.sharecontent;
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareweb;
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }];
            
            break;
        }
        case 2: {
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //如果有缩略图，则设置缩略图
            [shareObject setShareImage:self.shareimg];
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            shareObject.title=shareContent;
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }];
            break;
        }
        case 3: {
//            Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
//            
//            
//            if([messageClass canSendText])
//                
//            {
//                
//                MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
//                controller.body = shareContent;
//                controller.messageComposeDelegate = self;
//                
//                [self presentViewController:controller animated:YES completion:nil];
//                
//            }else
//            {
//                UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"不能发送，该设备不支持短信功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//                [t_alertView show];
//                
//            }
            //更多分享
            
            //要分享的内容，加在一个数组里边，初始化UIActivityViewController
            NSString *url;
            if ([self.sharecontent rangeOfString:@"http"].location!=NSNotFound) {
                url=[self.sharecontent substringToIndex:[self.sharecontent rangeOfString:@"http"].location];
            }else{
                url=self.sharecontent;
            }
            
            NSMutableArray *activityItems=[[NSMutableArray alloc] init];
            NSString *textToShare = url;
            UIImage *imageToShare = self.shareimg;
            // 本地沙盒目录
            NSURL *imageUrl=[NSURL URLWithString:@"http://www.fjqxfw.com:8099/gz_wap/"];
            [activityItems addObject:textToShare];
            if (imageToShare) {
                [activityItems addObject:imageToShare];
            }
            [activityItems addObject:imageUrl];
            
      
             UIActivityViewController *activity =[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];

            [self.navigationController presentViewController:activity animated:YES completion:nil];
            break;
        }
            
            
    }
}
//短信取消
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    //       [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 右上角广告位
-(void)A005Action{
    QXXZBViewController *webvc=[[QXXZBViewController alloc]init];
    webvc.url=self.ysj_weburl;
    webvc.titleString=self.webtitle;
    webvc.shareContent=self.websharecontent;
    [self.navigationController pushViewController:webvc animated:YES];
}

#pragma mark - 世界气象日广告位
- (void)loadAD_A005_29 {
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:@"29" forKey:@"position_id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_ad"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            //            UIButton *imageView = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 55, 84, 40, 33)];
            //            imageView.backgroundColor = [UIColor redColor];
            //            [_glassScrollView.foregroundView addSubview:imageView];
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];
            if (adlist.count>0) {
                NSString *url=[adlist[0] objectForKey:@"url"];
                NSString *title=[adlist[0] objectForKey:@"title"];
                NSString *imgurl=[adlist[0] objectForKey:@"img_path"];
                NSString *fx_content=[adlist[0] objectForKey:@"fx_content"];
                if (self.sjqxrInfo) {
                    self.sjqxrInfo = nil;
                }
                
                self.sjqxrInfo = @{@"1":url, @"2":title, @"3":fx_content};
                
                if (self.sjqxrView) {
                    [self.sjqxrView removeFromSuperview];
                    self.sjqxrView = nil;
                }
                self.sjqxrView = [[UIView alloc]initWithFrame:CGRectMake(50, 340, 120, 80)];
                EGOImageView *ego=[[EGOImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
                [ego setImageURL:[ShareFun makeImageUrl:imgurl]];
                ego.userInteractionEnabled=YES;
                [_glassScrollView.foregroundScrollView addSubview:self.sjqxrView];
                
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
                [btn addTarget:self action:@selector(A005_29Action) forControlEvents:UIControlEventTouchUpInside];
                [ego addSubview:btn];
                [self.sjqxrView addSubview:ego];
                UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(100, 55, 20, 20)];
                [bt setImage:[UIImage imageNamed:@"qxrgb"] forState:UIControlStateNormal];
                [bt addTarget:self action:@selector(cancleA005_27Action) forControlEvents:UIControlEventTouchUpInside];
                [self.sjqxrView addSubview:bt];
                
            }
            
            
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
- (void)A005_29Action {
    QXXZBViewController *webvc=[[QXXZBViewController alloc]init];
    webvc.url=self.sjqxrInfo[@"1"];
    webvc.titleString=self.sjqxrInfo[@"2"];
    webvc.shareContent=self.sjqxrInfo[@"3"];
    webvc.rightBtnType = @"sjqxr";
    [self.navigationController pushViewController:webvc animated:YES];
}
- (void)cancleA005_27Action {
    [self.sjqxrView removeFromSuperview];
    self.sjqxrView = nil;
     
}
#pragma mark 指点天气预警
-(void)MapWarnWithInfos:(NSArray *)infos Withindex:(NSInteger)index{
    self.isswipe=YES;
    NSInteger tag=index;
    NSString *warn_id;
    warn_id=[infos[tag] objectForKey:@"id"];
    YJpushViewController *yjdelital=[[YJpushViewController alloc]init];
    
    yjdelital.warnid=warn_id;
    [self.navigationController pushViewController:yjdelital animated:YES];
}
#pragma mark 专家解读
-(void)zjjdaction{
    ZXViewController *zxvc=[[ZXViewController alloc]init];
    zxvc.titlestr=@"专家解读";
    zxvc.channel_id = self.zjid;
    [self.navigationController pushViewController:zxvc animated:YES];
}
#pragma mark 天气资讯
-(void)tqzxaction{
    ZXViewController *zxvc=[[ZXViewController alloc]init];
    zxvc.titlestr=@"天气资讯";
    zxvc.channel_id = self.tqzxid;
    [self.navigationController pushViewController:zxvc animated:YES];
}
-(void)clickbtntagActionWithtag:(NSString *)tag withindex:(NSInteger)indextag{
//    NSLog(@"%@",tag);
    ZXContentViewController *zxcont=[[ZXContentViewController alloc]init];
    zxcont.wzid=tag;
    if (indextag<2) {
      zxcont.titlestr=@"天气资讯";
    }else{
        zxcont.titlestr=@"专家解读";
    }
    [self.navigationController pushViewController:zxcont animated:YES];
}
-(void)qsAction{
    //    self.isswipe=YES;
    //    SkVC *skvc=[[SkVC alloc]init];
    //    skvc.typetag=@"1";
    //    [self.navigationController pushViewController:skvc animated:YES];
    [self.mainview loadSubTwoView:YES];
}
#pragma mark - 15天天气
- (void)fiveThAction:(UIButton *)sender {
    
}

#pragma mark 三天天气
-(void)threeAction{
    if (self.mainview) {
        [self.mainview loadSubTwoView:NO];
    }
}
#pragma mark 实况天气
-(void)skAction{
    self.isswipe=YES;
    NSString *ct=[self.skinfo objectForKey:@"ct"];
    NSString *sd=[self.skinfo objectForKey:@"humidity"];
    NSString *njd=[self.skinfo objectForKey:@"visibility"];
    SkMoveVC *skmove=[[SkMoveVC alloc]init];
    skmove.nowct=ct;
    skmove.nowhum=sd;
    skmove.nowvisil=njd;
    [self.navigationController pushViewController:skmove animated:YES];
}
#pragma mark 风雨查询
-(void)fyfindaction{
    self.isswipe=YES;
    WindowAndRainVC *wrvc=[[WindowAndRainVC alloc]init];
    [self.navigationController pushViewController:wrvc animated:YES];
}

#pragma mark 空气质量
-(void)airaction{
    self.isswipe=YES;
    NSString *aircityid=[setting sharedSetting].currentCityID;
//    if ([self.allcityname rangeOfString:[setting sharedSetting].currentCity].location!=NSNotFound) {
//        NSArray *arr=[self.allcityname componentsSeparatedByString:@"-"];
//        if (arr.count>0) {
//            NSString *city=arr[0];
//            NSString *cid=[self readAirWithcity:city];
//            if (cid.length>0) {
//                aircityid=cid;
//            }
//            
//        }
//    }
    AIrViewController *airvc=[[AIrViewController alloc]init];
    airvc.countryid=aircityid;
    [self.navigationController pushViewController:airvc animated:YES];
}
#pragma  mark空气质量区级取上级
-(NSString *)readAirWithcity:(NSString *)city{
    NSString *cid=nil;
    m_allCity=m_treeNodeAllCity;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        TreeNode * t_cityname = [t_node.children objectAtIndex:2];
        NSString *t_name = t_cityname.leafvalue;
      
            if ([city isEqualToString:t_name])
            {
                //----------------------------------------------------
                t_node_child = [t_node.children objectAtIndex:5];
                TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
                NSString *Id = t_node_child1.leafvalue;
                cid=Id;
                break;
            }
        
        
    }
    return cid;
}
#pragma mark 指点天气
-(void)footWTAction{
    self.isswipe=YES;
    MapVC *mapvc=[[MapVC alloc]init];
    mapvc.mptype=@"出行";
    [self.navigationController pushViewController:mapvc animated:YES];
}
-(void)TravelAction{
    self.isswipe=YES;
    MapVC *mapvc=[[MapVC alloc]init];
    mapvc.mptype=@"旅游";
    [self.navigationController pushViewController:mapvc animated:YES];
}
-(void)typhoonAction{
    self.isswipe=YES;
    MapVC *mapvc=[[MapVC alloc]init];
    mapvc.mptype=@"台风";
    [self.navigationController pushViewController:mapvc animated:YES];
}
#pragma mark 气象影视
-(void)YingShiAction{
    self.isswipe=YES;
    QXYSViewController *qxys=[[QXYSViewController alloc]init];
    [self.navigationController pushViewController:qxys animated:YES];
}
#pragma mark 气象影视广告
-(void)YSBanerbuttonClick:(int)vid{
    if (self.ysadurls.count>0) {
        NSString *ysurl=self.ysadurls[vid-1];
        if (ysurl.length>0) {
            QXXZBViewController *webvc=[[QXXZBViewController alloc]init];
            webvc.url=ysurl;
            webvc.titleString=self.ysadtitles[vid-1];
            if (self.ysadshares.count>0) {
               webvc.shareContent=self.ysadshares[vid-1];
            }
            [self.navigationController pushViewController:webvc animated:YES];
        }
       
    }
}
#pragma mark日历
-(void)rilibtnAction{
    CalendarVC * calenda = [[CalendarVC alloc] init];
    [self.navigationController pushViewController:calenda animated:NO];
}
#pragma mark -生活指数
-(void)buttonActionWithTag:(int)tag withQualityOflifeInfo:(QualityOfLifeInfo *)lifeInfo withInfos:(NSMutableArray *)infos
{
    self.isswipe=YES;
    if (tag==1111){
        NSLog(@"更多");
        MangerLifeViewController *mglife=[[MangerLifeViewController alloc]init];
        if (self.lifeinfos.count) {
            mglife.arr=self.lifeinfos;
            
        }
        [self.navigationController pushViewController:mglife animated:YES];
       
    }else if (tag==0){
        NSLog(@"日历");
    }
    else
    {
        if(lifeInfo.shzs_url&&lifeInfo.shzs_url.length)
        {
            ADViewController *adVC = [[ADViewController alloc]init];
            adVC.url = lifeInfo.shzs_url;
            adVC.shareContent =[NSString stringWithFormat:@"%@:%@",[setting sharedSetting].currentCity,lifeInfo.des];
            adVC.titlelab.text = lifeInfo.index_name;
            adVC.titleString = lifeInfo.index_name;
            [self.navigationController pushViewController:adVC animated:YES];
            
            
        }
    }
    
}

-(void)leftAction:(UIButton *)sender{

    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}
-(void)rightAction{
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
    SettingViewController *settingVC=(SettingViewController *)self.menuContainerViewController.rightMenuViewController;
    [settingVC updateUserName];
}
//广告跳转代理方法
-(void)buttonClick:(int)vid{
//    NSLog(@"%d",vid);
    self.isswipe=YES;
    NSString *url=self.adurls[vid-1];
    if (url.length>0) {
        QXXZBViewController *adVC = [[QXXZBViewController alloc]init];
        adVC.url = self.adurls[vid-1];
        adVC.titleString =self.adtitles[vid-1];
        if (self.adshares.count>0) {
            adVC.shareContent=self.adshares[vid-1];
        }
        
        [self.navigationController pushViewController:adVC animated:YES];
    }
   
}


#pragma mark -
#pragma mark -MFSideMenuContainerViewController

- (MFSideMenuContainerViewController *)menuContainerViewController {
        return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
//    return (MFSideMenuContainerViewController *)self.parentViewController;
}
#pragma mark CityManageCellEditDelegate

-(void)citymanageCellSelectionAtIndexPath:(int)sourceIndexPath
{
    
    [self refreshview];
     [self navtitleview];
    NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
    [userDf setObject:[setting sharedSetting].currentCityID forKey:@"currentCityID"];
    [userDf setObject:[setting sharedSetting].currentCity forKey:@"currentCity"];
    [userDf setObject:[setting sharedSetting].morencityID forKey:@"xianshiid"];
    [userDf synchronize];
//    [self readxml];
//    [self updateMainView];
    
}

-(void)cityManageCellDeleteRowAtIndexPath:(NSIndexPath *)sourceIndexPath
{
    if ([setting sharedSetting].citys.count>0) {
        [setting sharedSetting].currentCity=[[setting sharedSetting].citys[0] objectForKey:@"city"];
        [setting sharedSetting].currentCityID=[[setting sharedSetting].citys[0] objectForKey:@"ID"];
        [setting sharedSetting].morencity=[[setting sharedSetting].citys[0] objectForKey:@"city"];
        [setting sharedSetting].morencityID=[[setting sharedSetting].citys[0] objectForKey:@"ID"];
        [[setting sharedSetting] saveSetting];
       
        [self navtitleview];
        [self refreshview];
        
//        [self updateMainView];
    }
    
    
}
-(void)navtitleview{
    BOOL isdw=![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
//    self.allcityname=[self readXMLwith:[setting sharedSetting].currentCityID];
    if (isdw==NO) {
        NSString *imgname = @"";
        self.updatelab.text=nil;
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:imgname,@"img",[self readXMLwith:[setting sharedSetting].currentCityID],@"city", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"navtitle" object:dic];
    }else{
    if ([[setting sharedSetting].currentCityID isEqualToString:[setting sharedSetting].dingweicity]) {
        
        NSString *imgname = @"sctqf_05.png";
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:imgname,@"img",[self readXMLwith:[setting sharedSetting].currentCityID],@"city", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"navtitle" object:dic];
    }else{
        NSString *imgname = @"";
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:imgname,@"img",[self readXMLwith:[setting sharedSetting].currentCityID],@"city", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"navtitle" object:dic];
        
    }
    }
}
-(NSString *)readXMLwith:(NSString *)cityid{
    m_allCity=m_treeNodeAllCity;
    NSString *city=[setting sharedSetting].currentCity;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:0];
        t_node_child = [t_node.children objectAtIndex:0];
        NSString *cityID = t_node_child.leafvalue;
        if ([cityID isEqualToString:cityid])
        {
           
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:6];
            NSString *cityname = t_node_child1.leafvalue;
            city=cityname;
            TreeNode *t_node_child2 = [t_node.children objectAtIndex:3];
            self.allcityname = t_node_child2.leafvalue;
            break;
        }
    }
    
    return city;
}
- (void)titleViewDidTouchUpInside:(QBTitleView *)titleView
{
    NSLog(@"Pushed");
}
//开始定位城市
- (void) startLocation
{
    
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [m_locationManager stopUpdatingLocation];
        isopendw=NO;
//        NSString *showmessage=@"您的定位服务未启用，如需开启，请设置手机中“设置->定位服务”";
//        if (iPhone5) {
//            showmessage=@"您的定位服务未启用，如需开启，请设置手机中“设置->隐私->定位服务”";
//        }
//        //	[ShareFun alertNotice:@"知天气" withMSG:showmessage cancleButtonTitle:@"确定" otherButtonTitle:nil];
//        UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"知天气" message:showmessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//        [t_alertView show];
        
        
    }
    else
    {
        isopendw=YES;
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        [self.locationManager startUpdatingLocation];
        

    }
}
#pragma mark 高德定位
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    [self.locationManager stopUpdatingLocation];
    NSString *dwstr=@"0";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"againdwsuccess" object:dwstr];
    [self navtitleview];
    [self enterapp];
}
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {

            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                [self enterapp];
                return;
            }
        }
        
        if (regeocode)
        {
            NSString *dwstr=@"1";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"againdwsuccess" object:dwstr];
            NSString *country = regeocode.formattedAddress;
            if (regeocode.city.length>0) {
                if ([country rangeOfString:regeocode.city].location!=NSNotFound) {
                    NSArray *timeArray1=[country componentsSeparatedByString:regeocode.city];
                    country=[timeArray1 objectAtIndex:1];
                }
            }
            NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
            double lat=location.coordinate.latitude;
            double lon=location.coordinate.longitude;
            NSDictionary *addressdic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",lat],@"lat",[NSString stringWithFormat:@"%f",lon],@"lon",country,@"address", nil];
            [userDef setObject:addressdic forKey:@"formattedAddress"];
            [userDef synchronize];
            
            NSString *street=regeocode.street;
            if (street.length>0) {
                [setting sharedSetting].dwstreet=street;
            }else{
                [setting sharedSetting].dwstreet=regeocode.township;
            }
            self.dwstress=[setting sharedSetting].dwstreet;
            NSString *t_city = [NSString stringWithFormat:@"%@", regeocode.district];
            if (regeocode.province.length>0) {
                self.provice=[regeocode.province substringToIndex:[regeocode.province length]-1];
            }
            if ([regeocode.city hasSuffix:@"市"])
            {
                NSArray *t_array = [regeocode.city componentsSeparatedByString:@"市"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                }
            }
            if ([regeocode.district hasSuffix:@"市"])
            {
                NSArray *t_array = [regeocode.district componentsSeparatedByString:@"市"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                    if ([self readXMLcity:t_city]==NO) {
                        if ([regeocode.city hasSuffix:@"市"])
                        {
                            NSArray *t_array = [regeocode.city componentsSeparatedByString:@"市"];
                            
                            if ([t_array count] > 0)
                            {
                                t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                            }
                        }
                    }
                }
            }
            if ([regeocode.district hasSuffix:@"县"])
            {
                NSArray *t_array = [regeocode.district componentsSeparatedByString:@"县"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                    if ([self readXMLcity:t_city]==NO) {
                        if ([regeocode.city hasSuffix:@"市"])
                        {
                            NSArray *t_array = [regeocode.city componentsSeparatedByString:@"市"];
                            
                            if ([t_array count] > 0)
                            {
                                t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                            }
                        }
                    }
                }
            }
            if ([regeocode.district hasSuffix:@"区"])
            {
                NSArray *t_array = [regeocode.district componentsSeparatedByString:@"区"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@区", [t_array objectAtIndex:0]];
                    if ([self readXMLcity:t_city]==NO) {
                        if ([regeocode.city hasSuffix:@"市"])
                        {
                            NSArray *t_array = [regeocode.city componentsSeparatedByString:@"市"];
                            
                            if ([t_array count] > 0)
                            {
                                t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                            }
                        }
                    }
                    
                }
                
            }
            self.DWcity=t_city;
            [self readXML];
            if (self.DWid.length>0) {
                NSDictionary *bfdic=[[NSUserDefaults standardUserDefaults]objectForKey:@"beforedw"];
                if (bfdic) {
                    if ([[setting sharedSetting].citys containsObject:bfdic]) {
                        [[setting sharedSetting].citys removeObject:bfdic];
                    }
                }
                NSDictionary *locationdic=[NSDictionary dictionaryWithObjectsAndKeys:country,@"address",[NSString stringWithFormat:@"%f",location.coordinate.latitude],@"lat",[NSString stringWithFormat:@"%f",location.coordinate.longitude],@"log",regeocode.province,@"provice",self.DWid,@"locationid", nil];
                [[NSUserDefaults standardUserDefaults]setObject:locationdic forKey:@"loctioninfo"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:self.DWcity,@"city",self.DWid,@"ID", nil];
                [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"beforedw"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                if (![[setting sharedSetting].citys containsObject:dic]) {
                    
                    if ([setting sharedSetting].citys.count==0) {
                        [[setting sharedSetting].citys addObject:dic];
                        [[setting sharedSetting] saveSetting];
                    }else{
                        [[setting sharedSetting].citys insertObject:dic atIndex:0 ];
                        [[setting sharedSetting] saveSetting];
                    }
                    
                }
                else{
                    
                    for (int k=0; k<[setting sharedSetting].citys.count; k++) {
                        
                        NSDictionary *nowdic=[[setting sharedSetting].citys objectAtIndex:k];
                        
                        if ([dic isEqual:nowdic]) {
                            [[setting sharedSetting].citys removeObject:nowdic];
                        }
                    }
                    
                    [[setting sharedSetting].citys insertObject:dic atIndex:0];
                    
                    
                }
                
                [setting sharedSetting].dingweicity=self.DWid;
                [setting sharedSetting].currentCityID = self.DWid;
                [setting sharedSetting].currentCity = self.DWcity;
                [setting sharedSetting].morencity=self.DWcity;
                [setting sharedSetting].morencityID=self.DWid;
             
                [[setting sharedSetting] saveSetting];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"current" object:nil];
                [self navtitleview];
                [self enterapp];
                [self queryPushTag];
                
//                [setting sharedSetting].dingweicity=self.DWid;
//                
//                [[setting sharedSetting] saveSetting];
//                if (self.mainal) {
//                    [self.mainal removeFromSuperview];
//                    self.mainal=nil;
//                }
//                if (![[setting sharedSetting].currentCity isEqualToString:t_city]) {
//                    NSString *cityname=[NSString stringWithFormat:@"你在[%@],看看天气？",t_city];
//                    if (self.myalert) {
//                        [self.myalert removeFromSuperview];
//                        self.myalert=nil;
//                    }
//                    Alert *al=[[Alert alloc]initWithTitle:@"知天气提示" withContent:cityname withleftbtn:@"是" withrightbtn:@"否"];
//                    self.myalert=al;
//                    al.delegate=self;
//                    [self.view addSubview:al];
//                    mynstimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(closeAlert) userInfo:nil repeats:NO];
//                    
//                }
            }
            NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
            [userDf setObject:[setting sharedSetting].currentCityID forKey:@"currentCityID"];
            [userDf setObject:[setting sharedSetting].currentCity forKey:@"currentCity"];
            [userDf setObject:[setting sharedSetting].morencityID forKey:@"xianshiid"];
            [userDf synchronize];
        }
    }];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            
            if ([m_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                
                [m_locationManager requestWhenInUseAuthorization];
                
            }
            
            break;
            
        default:
            
            break;
            
    }
    
    
}
#endif
#pragma mark CLLocationManager delegate
//定位成功调用
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    
    if (fabs([newLocation.timestamp timeIntervalSinceNow]) > 30.0f) {
        //若果是过期数据，忽略
        return;
    }
    
    [manager stopUpdatingLocation];
    
//    NSLog(@"定位成功！");
    self.isdw=NO;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            
          
            NSString *t_city = [NSString stringWithFormat:@"%@", placemark.subLocality];
            
            if ([placemark.locality hasSuffix:@"市"])
            {
                NSArray *t_array = [placemark.locality componentsSeparatedByString:@"市"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                }
            }
            if ([placemark.subLocality hasSuffix:@"市"])
            {
                NSArray *t_array = [placemark.subLocality componentsSeparatedByString:@"市"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                    if ([self readXMLcity:t_city]==NO) {
                        if ([placemark.locality hasSuffix:@"市"])
                        {
                            NSArray *t_array = [placemark.locality componentsSeparatedByString:@"市"];
                            
                            if ([t_array count] > 0)
                            {
                                t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                            }
                        }
                    }
                }
            }
            if ([placemark.subLocality hasSuffix:@"县"])
            {
                NSArray *t_array = [placemark.subLocality componentsSeparatedByString:@"县"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                    if ([self readXMLcity:t_city]==NO) {
                        if ([placemark.locality hasSuffix:@"市"])
                        {
                            NSArray *t_array = [placemark.locality componentsSeparatedByString:@"市"];
                            
                            if ([t_array count] > 0)
                            {
                                t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                            }
                        }
                    }
                }
            }
            if ([placemark.subLocality hasSuffix:@"区"])
            {
                NSArray *t_array = [placemark.subLocality componentsSeparatedByString:@"区"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@区", [t_array objectAtIndex:0]];
                    if ([self readXMLcity:t_city]==NO) {
                        if ([placemark.locality hasSuffix:@"市"])
                        {
                            NSArray *t_array = [placemark.locality componentsSeparatedByString:@"市"];
                            
                            if ([t_array count] > 0)
                            {
                                t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                            }
                        }
                    }
                    
                }
                
            }
            
            //    NSLog(@"哈哈%@", t_city);
            self.DWcity=t_city;
            [self readXML];
            if (self.DWid.length>0) {
              
                [setting sharedSetting].dingweicity=self.DWid;
                
                [[setting sharedSetting] saveSetting];
                if (self.mainal) {
                    [self.mainal removeFromSuperview];
                    self.mainal=nil;
                }
                if (![[setting sharedSetting].currentCity isEqualToString:t_city]) {
                    NSString *cityname=[NSString stringWithFormat:@"你在[%@],看看天气？",t_city];
                    if (self.myalert) {
                        [self.myalert removeFromSuperview];
                        self.myalert=nil;
                    }
                        Alert *al=[[Alert alloc]initWithTitle:@"知天气提示" withContent:cityname withleftbtn:@"是" withrightbtn:@"否"];
                        self.myalert=al;
                        al.delegate=self;
                        [self.view addSubview:al];
                    mynstimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(closeAlert) userInfo:nil repeats:NO];
                    
                }
                
                
            }
        }
        NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
        [userDf setObject:[setting sharedSetting].currentCityID forKey:@"currentCityID"];
        [userDf setObject:[setting sharedSetting].currentCity forKey:@"currentCity"];
        [userDf setObject:[setting sharedSetting].morencityID forKey:@"xianshiid"];
        [userDf synchronize];
    }
     ];

  
}
-(void)closeAlert{
    if (self.myalert) {
        [self.myalert removeFromSuperview];
        self.myalert=nil;
        [self moreAction];
    }
}
//定位出错时被调
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    [manager stopUpdatingLocation];
    
    NSLog(@"获取经纬度失败，失败原因：%@", [error description]);
    NSString *showmessage=@"您的定位服务未启用，如需开启，请设置手机中“设置->定位服务”";
    if (iPhone5) {
        showmessage=@"您的定位服务未启用，如需开启，请设置手机中“设置->隐私->定位服务”";
    }
    UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"知天气" message:showmessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    t_alertView.tag=10;
    [t_alertView show];
//    [ShareFun alertNotice:@"知天气" withMSG:@"操作失败,请检查网络连接！" cancleButtonTitle:@"确定" otherButtonTitle:nil];
    
    
}
//定位弹窗方法
-(void)moreAction{
    [mynstimer invalidate];//定时器停止
    [setting sharedSetting].currentCityID = self.DWid;
    [setting sharedSetting].currentCity = self.DWcity;
    [setting sharedSetting].morencity=self.DWcity;
    [setting sharedSetting].morencityID=self.DWid;
    [setting sharedSetting].dingweicity=self.DWid;
    [self cityliebiao];
    self.DWid=nil;
    self.DWcity=nil;
     [[NSNotificationCenter defaultCenter] postNotificationName:@"uptable" object:nil];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:trackViewURL];
            
            [[UIApplication sharedApplication]openURL:url];
        }
    }else{
    if (buttonIndex==1) {
        [setting sharedSetting].currentCityID = self.DWid;
        [setting sharedSetting].currentCity = self.DWcity;
        [setting sharedSetting].morencity=self.DWid;
        [setting sharedSetting].morencityID=self.DWcity;
        [self cityliebiao];
    }else{
        return;
    }
    }
}

-(BOOL)readXMLcity:(NSString *)city{
    BOOL iscity=NO;
    m_allCity=m_treeNodeAllCity;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        t_node_child = [t_node.children objectAtIndex:2];
        NSString *t_name = t_node_child.leafvalue;
        if ([t_name rangeOfString:city].location != NSNotFound||[city rangeOfString:t_name].location != NSNotFound)
        {
            iscity=YES;
        }
    }
    
    return iscity;
}
-(void)readXML{
    m_allCity=m_treeNodeAllCity;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        TreeNode * t_cityname = [t_node.children objectAtIndex:2];
        NSString *t_name = t_cityname.leafvalue;
        if ([t_node_child.leafvalue isEqualToString:[self readXMLproviceId:self.provice]]) {
            if ([self.DWcity isEqualToString:t_name])
            {
                //----------------------------------------------------
                t_node_child = [t_node.children objectAtIndex:5];
                TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
                NSString *Id = t_node_child1.leafvalue;
                [[NSUserDefaults standardUserDefaults]setObject:Id forKey:@"DWid"];
                self.DWid=Id;
                break;
            }
            if ([t_name rangeOfString:self.DWcity].location != NSNotFound||[self.DWcity rangeOfString:t_name].location != NSNotFound)
            {
                //----------------------------------------------------
                t_node_child = [t_node.children objectAtIndex:5];
                TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
                NSString *Id = t_node_child1.leafvalue;
                [[NSUserDefaults standardUserDefaults]setObject:Id forKey:@"DWid"];
                self.DWid=Id;
                break;
            }
        }
        
    }
    
    
}
-(NSString *)readXMLproviceId:(NSString *)city{
    NSString *proid=nil;
    m_allprovice=m_treeNodeProvince;
    for (int i = 0; i < [m_allprovice.children count]; i ++)
    {
        TreeNode *t_node = [m_allprovice.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        t_node_child = [t_node.children objectAtIndex:2];
        NSString *t_name = t_node_child.leafvalue;
        if ([city rangeOfString:t_name].location!=NSNotFound)
        {
            TreeNode *t_proid=[t_node.children objectAtIndex:0];
            proid=t_proid.leafvalue;
            break;
        }
    }
    
    return proid;
}
-(void)releaseview{
    self.isnotice=NO;
}
-(NSString*)getChineseCalendarWithDate:(NSDate *)date{
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags =NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@%@",m_str,d_str];
    
    return chineseCal_str;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch  {
    if (self.mainview) {
        CGPoint point = [touch locationInView:self.mainview];
        if (point.y <= 255 && point.y > 0) {
            return NO ;
        }
    }
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    if (self.mapview) {
//        self.mapview.delegate=nil;
//        [self.mapview removeFromSuperview];
//        self.mapview=nil;
//    }
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
