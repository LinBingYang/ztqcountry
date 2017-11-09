//
//  LaunchViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-6-25.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "LaunchViewController.h"
#import "CityManageViewController.h"
#import "SettingViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "ShareFun.h"
#import "AddCityViewController.h"
//#import "NetWorkCenter.h"
#import "EGOImageView.h"

#import "Reachability.h"
@interface LaunchViewController ()

@property (strong, nonatomic) EGOImageView * startImgV;
@property (strong, nonatomic) UILabel * LogoImgV;
@property (strong, nonatomic) UILabel * nameLab;
@property (strong, nonatomic) UILabel * versionLab;

@property(assign)BOOL isnetwork;//判断是否有网络

@end

@implementation LaunchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.navigationController.navigationBarHidden = YES;
    self.isbtnselect=NO;
    self.isfirst=NO;
    
    [self ManegerCitys];//管理部分错误城市
    //获取当前网络类型
    Reachability *r= [Reachability reachabilityForInternetConnection];
    if ([r currentReachabilityStatus] == NotReachable) {
        self.isnetwork=NO;
    }
    if ([r currentReachabilityStatus] == ReachableViaWiFi) {
        self.isnetwork=YES;
    }
    if ([r currentReachabilityStatus] == ReachableViaWWAN) {
        self.isnetwork=YES;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(network) name:@"NONet" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nextlaunch) name:@"complatecity" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendIOSpush) name:@"tokensuccess" object:nil];
    //启动页面图片
    _startImgV = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    _startImgV.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    if (iPhone4) {
        _startImgV.image = [UIImage imageNamed:@"Default-480h@2x.png"];
    }
    [self.view addSubview:_startImgV];
    
    UIImageView *t_logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    [t_logo setFrame:CGRectMake(58, 160, 208, 83)];
    [self.view addSubview:t_logo];

    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(40, kScreenHeitht-160, kScreenWidth-80, 40)];
 
    self.versionLab=version;
    [version setText:[NSString stringWithFormat:@"Ver  %@", [ShareFun localVersion]]];
    [version setTextAlignment:NSTextAlignmentCenter];
    [version setTextColor:[UIColor whiteColor]];

    [version setBackgroundColor:[UIColor clearColor]];
    [version setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    [self.view addSubview:version];
    UILabel *betalab=[[UILabel alloc]initWithFrame:CGRectMake(190, kScreenHeitht-112, 60, 30)];
    betalab.text=@"beta";
    self.betalab=betalab;
    betalab.textColor=[UIColor whiteColor];
    [betalab setShadowColor:[UIColor blackColor]];
    [betalab setShadowOffset:CGSizeMake(1, 1)];
    [betalab setBackgroundColor:[UIColor clearColor]];
    [betalab setFont:[UIFont fontWithName:@"Helvetica" size:20]];

    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:@"TestFirst"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:path] == NO)
    {
        
        self.isfirst=YES;

        
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
//     [[GetXMLData alloc] startRead:@"provinceList" withObject:self withFlag:0];
    

}
-(void)nextlaunch{
   
    [self startLocation];
//    if (!m_treeNodeAllCity) {
//        [[GetXMLData alloc] startRead:@"cityList" withObject:self withFlag:6];
//    }
  
}
-(void)ManegerCitys{
    NSArray *deletecitys=[[NSArray alloc]initWithObjects:@"临潼区", nil];
    
    for (int j=0; j<deletecitys.count; j++) {
        NSString *delcity=deletecitys[j];
        for (int i=0; i<[setting sharedSetting].citys.count; i++) {
            NSString *city=[[[setting sharedSetting].citys objectAtIndex:i]objectForKey:@"city"];
            if ([delcity isEqualToString:city]) {
                [[setting sharedSetting].citys removeObjectAtIndex:i];
                if ([setting sharedSetting].citys.count>0) {
                    [setting sharedSetting].currentCity=[[[setting sharedSetting].citys objectAtIndex:0]objectForKey:@"city"];
                    [setting sharedSetting].currentCityID=[[[setting sharedSetting].citys objectAtIndex:0]objectForKey:@"ID"];
                    [setting sharedSetting].morencity=[setting sharedSetting].currentCity;
                    [setting sharedSetting].morencityID=[setting sharedSetting].currentCityID;
                    [[setting sharedSetting] saveSetting];
                }
                
            }
        }
        
    }
}
-(void)network{
    self.isnetwork=NO;
}
-(void)loadFishing{


    if (self.isfirst==YES) {
        
    
    UIScrollView *ydsrc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    ydsrcollview=ydsrc;
    ydsrcollview.delegate = self;
    ydsrcollview.bounces = NO;
    ydsrcollview.pagingEnabled = YES;
    ydsrcollview.userInteractionEnabled = YES;
    ydsrcollview.showsHorizontalScrollIndicator = NO;
    ydsrcollview.showsVerticalScrollIndicator = NO;
    ydsrcollview.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht*3);
    [self.view addSubview:ydsrcollview];
		
        
		UIView *t_view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
		UIImageView *t_image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
		[t_image1 setImage:[UIImage imageNamed:@"引导页1ios4.png"]];
        if (iPhone5) {
            [t_image1 setImage:[UIImage imageNamed:@"引导页1ios5.png"]];
        }
		[t_view1 addSubview:t_image1];
        
    [ydsrcollview addSubview:t_view1];

		
		UIView *t_view2 = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeitht, kScreenWidth, kScreenHeitht)];
		UIImageView *t_image2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
		[t_image2 setImage:[UIImage imageNamed:@"引导页2ios4.png"]];
        if (iPhone5) {
            [t_image2 setImage:[UIImage imageNamed:@"引导页2ios5.png"]];
        }
		[t_view2 addSubview:t_image2];
		[ydsrcollview addSubview:t_view2];

		UIView *t_view3 = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeitht*2, kScreenWidth, kScreenHeitht)];
		UIImageView *t_image3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
		[t_image3 setImage:[UIImage imageNamed:@"引导页3ios4.png"]];
        if (iPhone5) {
            [t_image3 setImage:[UIImage imageNamed:@"引导页3ios5.png"]];
        }
		[t_view3 addSubview:t_image3];
        
    
        UIButton *t_next = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeitht-300, kScreenWidth, 300)];
		[t_next setBackgroundColor:[UIColor clearColor]];
        [t_next addTarget:self action:@selector(firstgo) forControlEvents:UIControlEventTouchUpInside];
		
		[ydsrcollview addSubview:t_view3];
        [t_view3 addSubview:t_next];
		
        CATransition *animation = [CATransition animation];
//        animation.delegate = self;
        animation.duration = 0.5;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromBottom;
        [ydsrcollview setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
        [[self.view layer] addAnimation:animation forKey:@"animation"];
//        if ([setting sharedSetting].app.length>0&&[setting sharedSetting].devToken.length>0) {
//        [self sendIOSpush];
//        
//        }
    }
else{
    [self loadthemeImg];//主题插图}
    }
}
-(void)loadthemeImg
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * ztq_img = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    [ztq_img setObject:@"I" forKey:@"phone_type"];

    [b setObject:ztq_img forKey:@"gz_wt_index_img"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    
    [[NetWorkCenter share] postHttpWithUrl:URL_SERVER withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {

        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary * ztq_img = [b objectForKey:@"gz_wt_index_img"];
        NSDictionary * dataList = [ztq_img objectForKey:@"index_img"];
        NSString * url=nil;
        if (kScreenHeitht>500) {
            url=[dataList objectForKey:@"big_img_url"];
        }else{
            url=[dataList objectForKey:@"small_img_url"];
        }
        
        
        if(url.length)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];

            [_startImgV setImageURL:[ShareFun makeImageUrl:url]];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_startImgV cache:NO];
            [UIView commitAnimations];

        }
        else
        {
            UIImage * img = nil;
            if(kScreenHeitht >500)
            {
                img= [UIImage imageNamed:@"晴"];
            }
            else
            {
                img = [UIImage imageNamed:@"晴"];
            }
            self.versionLab.hidden=YES;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//            [UIView setAnimationDuration:0.5];
            _startImgV.image = img;
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_startImgV cache:NO];
            [UIView commitAnimations];
            
            
        }
       
        self.versionLab.hidden=YES;
        self.betalab.hidden=YES;
        _startImgV.userInteractionEnabled=YES;
        UIButton *passbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-70, 25, 60, 30)];
        [passbtn setBackgroundImage:[UIImage imageNamed:@"跳过按钮"] forState:UIControlStateNormal];
        //        [passbtn setTitle:@"跳过" forState:UIControlStateNormal];
        [passbtn addTarget:self action:@selector(passaction) forControlEvents:UIControlEventTouchUpInside];
        [_startImgV addSubview:passbtn];
        if (self.ispass==NO) {
            if ([setting sharedSetting].currentCity.length>0&&[setting sharedSetting].citys.count>0) {
             
                    self.mytimer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(gotoMainVC) userInfo:nil repeats:NO];
                    //                    [self performSelector:@selector(gotoMainVC) withObject:nil afterDelay:1.5];//停留时间
                
            }else{
                
                self.mytimer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(gotoCity) userInfo:nil repeats:NO];
                //                [self performSelector:@selector(gotoCity) withObject:nil afterDelay:1.5];
            }
        }
    } withFailure:^(NSError *error) {
        if (self.ispass==NO) {
            if ([setting sharedSetting].currentCity.length>0) {
             
                    [self gotoMainVC];
                    
                
            }else{
                
                [self gotoCity];
                
            }
        }
    } withCache:YES];
//    if (![setting sharedSetting].currentCityID.length>0) {
//       [self performSelector:@selector(gotoCity) withObject:nil afterDelay:3];
//    }else{
//        [self performSelector:@selector(gotoMainVC) withObject:nil afterDelay:3];
//    }


}
-(void)firstgo{
    if (self.isbtnselect==NO) {
        self.isbtnselect=YES;
        if (([setting sharedSetting].currentCityID.length>0)) {
            [self gotoMainVC];
        }else{
            [self gotoCity];
        }
    }
    
}
-(void)passaction{
    if (self.mytimer.isValid) {
        [self.mytimer invalidate];
        self.mytimer=nil;
    }
    
    self.ispass=YES;
    if (([setting sharedSetting].citys.count<=0)) {
       [self gotoCity];
    }else{
       [self gotoMainVC];
    }
}
-(void)gotoCity{
    

    MainNewViewController * mainVC = [MainNewViewController shareVC];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mainVC];
    
    CityManageViewController * cityManageVC = [[CityManageViewController alloc] init];
    
    SettingViewController * settingVC = [[SettingViewController alloc] init];
    
    MFSideMenuContainerViewController * container = [MFSideMenuContainerViewController
                                                     containerWithCenterViewController:nav
                                                     leftMenuViewController:cityManageVC
                                                     rightMenuViewController:settingVC];
    mainVC.isnetworking=self.isnetwork;
    
    SelectCityViewController *addcity=[[SelectCityViewController alloc]init];
    [addcity setDataSource: m_treeNodeProvince withCitys:m_treeNodeAllCity];
    [addcity setDelegate:self];
    [self.navigationController pushViewController:container animated:NO];
    
    [self.navigationController pushViewController:addcity animated:NO];
  
}
-(void)gotoMainVC
{
    if (self.isgotomain==NO) {
        MainNewViewController * mainVC = [MainNewViewController shareVC];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mainVC];
        CityManageViewController * cityManageVC = [[CityManageViewController alloc] init];
        
        SettingViewController * settingVC = [[SettingViewController alloc] init];
        
        MFSideMenuContainerViewController * container = [MFSideMenuContainerViewController
                                                         containerWithCenterViewController:nav
                                                         leftMenuViewController:cityManageVC
                                                         rightMenuViewController:settingVC];

        mainVC.isnetworking=self.isnetwork;
        [self.navigationController pushViewController:container animated:YES];
        self.isgotomain=YES;
    }
    
    
}

-(void)initApp
{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * init = [[NSMutableDictionary alloc] init];
    if ([setting getMainApp].length>0) {
        [init setObject:[setting getMainApp] forKey:@"app"];
    }
    if ([setting getmodel].length>0) {
        [init setObject:[setting getmodel] forKey:@"xh"];
    }
    if ([setting getSysVersion].length>0) {
        [init setObject:[setting getSysVersion] forKey:@"sys"];
    }
    
    if ([setting getSysUid].length>0) {
        [init setObject:[setting getSysUid] forKey:@"imei"];
    }
    if ([setting getImsi].length>0) {
        [init setObject:[setting getImsi] forKey:@"sim"];
    }
    if ([setting getMainVersion].length>0) {
        [init setObject:[setting getMainVersion] forKey:@"sv"];
    }
    
    [b setObject:init forKey:@"init"];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    NSString *str=[param urlEncodedStringCustom];
    NSDictionary *parameters = @{@"p":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * b = [responseObject objectForKey:@"b"];
        NSDictionary * init = [b objectForKey:@"init"];
        [setting sharedSetting].app = [init objectForKey:@"pid"];
        [[setting sharedSetting]saveSetting];
        [self sendIOSpush];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
    }];

    
}
-(void)sendIOSpush{
    
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    if ([setting sharedSetting].devToken.length>0) {
        [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    }
    [b setObject:setProperty forKey:@"gz_set_pushtag_ios"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSLog(@"%@",returnData);
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    
}
#pragma mark xml delegate

-(void)readFinish:(TreeNode *)p_treeNode withFlag:(int)p_flag
{
	if(p_flag == 0)
	{
		m_treeNodeProvince = p_treeNode;
		NSLog(@"privince list load finish!");
		
		[[GetXMLData alloc] startRead:@"cityList" withObject:self withFlag:1];
	}
	else if (p_flag == 1)
	{
		m_treeNodeAllCity = p_treeNode;
		NSLog(@"city list load finish!");

        [self startLocation];
        
		[[GetXMLData alloc] startRead:@"landscapeList" withObject:self withFlag:2];
	}
	else if (p_flag == 2)
	{
		m_treeNodelLandscape = p_treeNode;
		NSLog(@"landscape list load finish!");
//		[self performSelector:@selector(loadFishing) withObject:nil afterDelay:1];
        [[GetXMLData alloc] startRead:@"t_area" withObject:self withFlag:3];
		//isGetXML = YES;
		
	}
    else if (p_flag==3){
        m_treeNodearea=p_treeNode;
        [[GetXMLData alloc] startRead:@"birth_city" withObject:self withFlag:4];
    }
    else if (p_flag==4){
        m_treeNodebirthcity=p_treeNode;
        [[GetXMLData alloc] startRead:@"birth_county" withObject:self withFlag:5];
    }
    else if (p_flag==5){
        m_treeNodebirthcountry=p_treeNode;
        NSLog(@"XML is finish!");
    }else if (p_flag == 6)
    {
        m_treeNodeAllCity = p_treeNode;
        if (!m_treeNodelLandscape) {
            [[GetXMLData alloc] startRead:@"landscapeList" withObject:self withFlag:7];
        }
    }else if (p_flag == 7)
    {
        m_treeNodelLandscape = p_treeNode;
    }
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
//        UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"知天气" message:showmessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//        t_alertView.tag=10;
//        [t_alertView show];
        [self loadFishing];//加载主题
        
    }
    else
    {
        isopendw=YES;
        //   定位超时时间，可修改，最小2s
        self.locationManager.locationTimeout = 3;
        //   逆地理请求超时时间，可修改，最小2s
        self.locationManager.reGeocodeTimeout = 3;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        [self.locationManager startUpdatingLocation];
        if (self.isfirst==NO) {
            [self performSelector:@selector(recogedCity) withObject:nil afterDelay:2];
        }
        
        
    }
}
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    [self.locationManager stopUpdatingLocation];
    if (isdw==NO) {
        [self loadFishing];//加载主题
        isdw=YES;
    }
}
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    
    
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (self.isfirst==YES) {
        [self performSelector:@selector(recogedCity) withObject:nil afterDelay:1];
    }
    
}
-(void)recogedCity{
    
    
    self.locationManager.delegate=nil;
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (isdw==NO) {
            [self loadFishing];//加载主题
            isdw=YES;
        }
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        if (regeocode)
        {
            //            [m_locationManager stopUpdatingLocation];
//            NSLog(@"location1:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
//            NSLog(@"reGeocode:%@", regeocode);
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
            NSLog(@"哈哈%@", t_city);
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
                
                BOOL isdw=![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
                if (isdw==YES) {
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
                    
                    if (street.length>0) {
                        [setting sharedSetting].dwstreet=street;
                    }else{
                        [setting sharedSetting].dwstreet=regeocode.township;
                    }
                    [setting sharedSetting].currentCityID = self.DWid;
                    [setting sharedSetting].currentCity = self.DWcity;
                    [setting sharedSetting].morencity=self.DWcity;
                    [setting sharedSetting].morencityID=self.DWid;
                }else{
                    [setting sharedSetting].dwstreet=nil;
                }
                
                
                
                [[setting sharedSetting] saveSetting];
            }
            
        }
        NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
        [userDf setObject:[setting sharedSetting].currentCityID forKey:@"currentCityID"];
        [userDf setObject:[setting sharedSetting].currentCity forKey:@"currentCity"];
        [userDf setObject:[setting sharedSetting].morencityID forKey:@"xianshiid"];
        [userDf synchronize];
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
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error) {
//        NSLog(@"%@",error);
        if (array.count > 0) {
//            NSLog(@"定位成功！");
            [manager stopUpdatingLocation];
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            NSLog(@"反向地理编码成功，城市： %@", placemark.subLocality);
            
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
            NSLog(@"哈哈%@", t_city);
            self.DWcity=t_city;
            [self readXML];
            if (self.DWid.length>0) {
                //        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:t_city, @"city",self.DWid,@"ID", nil];
                //    [[NSUserDefaults standardUserDefaults]setObject:t_city forKey:@"DWcity"];
                [setting sharedSetting].dingweicity=self.DWid;
                [setting sharedSetting].currentCityID = self.DWid;
                [setting sharedSetting].currentCity = self.DWcity;
                [setting sharedSetting].morencity=self.DWcity;
                [setting sharedSetting].morencityID=self.DWid;
                //        if (![[setting sharedSetting].citys containsObject:dic]) {
                //            [[setting sharedSetting].citys insertObject:dic atIndex:0];
                //        }
                
                [[setting sharedSetting] saveSetting];
            }
        }
        //         [self performSelector:@selector(loadFishing) withObject:nil afterDelay:1];
        
    }];
}

//定位出错时被调
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    [manager stopUpdatingLocation];
   
    
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
