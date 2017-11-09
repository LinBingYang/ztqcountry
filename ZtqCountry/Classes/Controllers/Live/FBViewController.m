//
//  FBViewController.m
//  ztqFj
//
//  Created by Admin on 15-1-20.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "FBViewController.h"
#import "LGViewController.h"
#import "GRZXViewController.h"
#import "SBJson.h"
#import "NSDictionary+UrlEncodedString.h"
#import "LivePhotoViewController.h"
@interface FBViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) UIScrollView * backgroundScrollView;
@property(strong,nonatomic)UIImageView *annoimg;
@property(strong,nonatomic)UIButton *selectbtn;
@property(strong,nonatomic)NSString *weastr;
@property(strong,nonatomic)NSMutableArray *btnarr;
@property(assign)BOOL isclick;
@property (strong, nonatomic) UITextView * commentTF;
@property(strong,nonatomic)UITextField *nicktf,*addresstf,*timetf;
@property(nonatomic,strong)UILabel *bglabel;
@property (strong, nonatomic) NSString * str;
@property (strong, nonatomic) UILabel * wordNumLab;
@property(strong,nonatomic)NSString *username;
@end

@implementation FBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    self.navigationController.navigationBarHidden = YES;
    //    self.title = @"推送设置";
    float place = 0;
    if(kSystemVersionMore7)
    {
        place = 20;
    }
    self.view.backgroundColor=[UIColor whiteColor];
    self.barHeight = 44+ place;
    _navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    _navigationBarBg.userInteractionEnabled = YES;
    //    _navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:27 green:92 blue:189 alpha:1];
    _navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:_navigationBarBg];
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [_navigationBarBg addSubview:leftimg];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upsjview) name:@"sjlogin" object:nil];
    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
//    [_leftBut setBackgroundImage:[UIImage imageNamed:@"jc返回.png"] forState:UIControlStateNormal];
//    [_leftBut setBackgroundImage:[UIImage imageNamed:@"jc返回点击.png"] forState:UIControlStateHighlighted];
    [_leftBut addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 12+place, 200, 20)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor whiteColor];
    [_navigationBarBg addSubview:_titleLab];
    
    //定位
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.distanceFilter = 5.0f;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    locationManager.delegate = self;
//    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0))
//    {
//        //设置定位权限，仅ios8有意义
//        [locationManager requestAlwaysAuthorization];
//    }
//    [locationManager startUpdatingLocation];
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
    
    //    self.barHiden = NO;
    self.titleLab.text = @"我的观察报告";
//    _rightBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-45, 7+place, 30, 30)];
////    _rightBut.center = CGPointMake(kScreenWidth-65+25, self.leftBut.center.y);
//    _rightBut.titleLabel.font = [UIFont fontWithName:kBaseFont size:15];
////    [_rightBut setTitle:@"发布" forState:UIControlStateNormal];
//    [_rightBut setBackgroundImage:[UIImage imageNamed:@"时间_05.png"] forState:UIControlStateNormal];
//    [_rightBut setBackgroundImage:[UIImage imageNamed:@"污染_05.png"] forState:UIControlStateHighlighted];
//    [_rightBut addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
//    [_navigationBarBg addSubview:_rightBut];
    self.username=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjusername"];
    self.weaarr=[[NSArray alloc]initWithObjects:@"晴好",@"阴天",@"水涝",@"大风",@"小雨",@"大雾",@"山洪",@"高温",@"中雨",@"冰雹",@"台风",@"干旱",@"大雨",@"降雪",@"结冰",@"其他", nil];
    self.btnarr=[[NSMutableArray alloc]init];
    self.isclick=NO;

    
    
    //-----------------键盘-----------------------
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}
-(void)upsjview{
    self.username=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjusername"];
    [self creatViews];
}
#pragma mark 高德定位
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    [self.locationManager stopUpdatingLocation];
    [self creatViews];
}
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
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
//            NSLog(@"reGeocode:%@", regeocode);
            NSString *country = regeocode.formattedAddress;
            //            NSString *city=placemark.locality;
            NSString *t_city = [NSString stringWithFormat:@"%@", regeocode.district];
            
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
                }
            }
            if ([regeocode.district hasSuffix:@"县"])
            {
                NSArray *t_array = [regeocode.district componentsSeparatedByString:@"县"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                }
            }
            if (regeocode.city.length>0) {
                if ([country rangeOfString:regeocode.city].location!=NSNotFound) {
                    NSArray *timeArray1=[country componentsSeparatedByString:regeocode.city];
                    country=[timeArray1 objectAtIndex:1];
                }
            }else{
                if ([country rangeOfString:regeocode.province].location!=NSNotFound) {
                    
                    if ([regeocode.province hasSuffix:@"市"])
                    {
                        NSArray *t_array = [regeocode.province componentsSeparatedByString:@"市"];
                        
                        if ([t_array count] > 0)
                        {
                            t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                        }
                    }
                }
            }
            
            self.titlecity=country;
            self.DWcity=regeocode.formattedAddress;
            self.DWid=[self readXML:t_city];
            [self creatViews];
        }else{
            [self creatViews];
        }
    }];
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            
            if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                
                [locationManager requestWhenInUseAuthorization];
                
            }
            
            break;
            
        default:
            
            break;
            
    }
}

#endif
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    CLLocation * showLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude-0.00330
                                                           longitude:newLocation.coordinate.longitude+0.0049];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:showLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *country = placemark.name;
//            NSString *city=placemark.locality;
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
                }
            }
            if ([placemark.subLocality hasSuffix:@"县"])
            {
                NSArray *t_array = [placemark.subLocality componentsSeparatedByString:@"县"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                }
            }
            
            if ([country rangeOfString:@"省"].location!=NSNotFound) {
                NSArray *timeArray1=[country componentsSeparatedByString:@"省"];
                country=[timeArray1 objectAtIndex:1];
            }
            self.titlecity=country;
            self.DWcity=placemark.locality;
            self.DWid=[self readXML:t_city];
            [self creatViews];
        }else{
            [self creatViews];
        }
    }];
    
    
    [locationManager stopUpdatingLocation];
    
}
//定位出错时被调
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    
    [manager stopUpdatingLocation];
    [self creatViews];
}
//定位城市id
-(NSString *)readXML:(NSString *)city{
    m_allArea=m_treeNodeAllCity;
    
    for (int i = 0; i < [m_allArea.children count]; i ++)
    {
        TreeNode *t_node = [m_allArea.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:2];
        NSString *t_name = t_node_child.leafvalue;
        if ([city isEqualToString:t_name])
        {
            //----------------------------------------------------
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
            NSString *Id = t_node_child1.leafvalue;
            self.DWid=Id;
            break;
        }
        if ([t_name rangeOfString:city].location != NSNotFound||[city rangeOfString:t_name].location != NSNotFound)
        {
    
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
            NSString *Id = t_node_child1.leafvalue;
            self.DWid=Id;
            break;
        }
    }
    
    return self.DWid;
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)creatViews
{
    UIScrollView * backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight)];
  
    self.backgroundScrollView = backgroundScrollView;
    backgroundScrollView.showsHorizontalScrollIndicator = NO;
    backgroundScrollView.backgroundColor = [UIColor colorHelpWithRed:237 green:237 blue:237 alpha:1];
    backgroundScrollView.showsVerticalScrollIndicator = NO;
    backgroundScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeitht-self.barHiden);
    if (iPhone4) {
        backgroundScrollView.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht+100);
    }
    [self.view addSubview:backgroundScrollView];
    
    UILabel *titlelab=[[UILabel alloc]initWithFrame:CGRectMake(13, 15, 80, 30)];
    titlelab.text=@"天气实景:";
    titlelab.textColor=[UIColor colorHelpWithRed:84 green:83 blue:83 alpha:1];
    titlelab.font=[UIFont systemFontOfSize:15];
//    [backgroundScrollView addSubview:titlelab];
   
    UIImageView *annoimg=[[UIImageView alloc]initWithFrame:CGRectMake(60, 15, kScreenWidth-120, 150)];
    self.annoimg=annoimg;
    annoimg.image=self.fbimage;
    annoimg.contentMode = UIViewContentModeScaleAspectFit;
    annoimg.clipsToBounds = YES;
    [backgroundScrollView addSubview:annoimg];
    
     //view
    UIView *weatherview=[[UIView alloc]initWithFrame:CGRectMake(10, 180, kScreenWidth-20, 150)];
    weatherview.backgroundColor=[UIColor whiteColor];
    [backgroundScrollView addSubview:weatherview];
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 1)];
    line.backgroundColor=[UIColor grayColor];
    [weatherview addSubview:line];
    UIImageView *v_line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 150)];
    v_line.backgroundColor=[UIColor grayColor];
    [weatherview addSubview:v_line];
    UIImageView *vr_line=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-21, 0, 1, 150)];
    vr_line.backgroundColor=[UIColor grayColor];
    [weatherview addSubview:vr_line];
    UILabel *wealab=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
    wealab.text=@"天气状况:";
    wealab.textColor=[UIColor colorHelpWithRed:84 green:83 blue:83 alpha:1];
    wealab.font=[UIFont systemFontOfSize:14];
    [weatherview addSubview:wealab];
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 29, kScreenWidth-20, 1)];
    line1.backgroundColor=[UIColor grayColor];
    [weatherview addSubview:line1];
    for (int i=0; i<4; i++) {
        UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 29+30*i+30, kScreenWidth-20, 1)];
        line2.backgroundColor=[UIColor grayColor];
        [weatherview addSubview:line2];
    }
    for (int j=0; j<3; j++) {
        UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(74+75*j, 30, 1, 120)];
        line1.backgroundColor=[UIColor grayColor];
        [weatherview addSubview:line1];
    }
    for (int row=0; row<[self.weaarr count]/4+1; row++) {
        for (int i = 0; i < [self.weaarr count]; i ++) {
            int t_row = i /4;
            if (t_row==row) {
             
                int x = 0+(i%4)*75;
                UILabel *tlab=[[UILabel alloc]initWithFrame:CGRectMake(x, 30*row+30, 75, 30)];
                tlab.text=self.weaarr[i];
                tlab.textAlignment=NSTextAlignmentCenter;
                tlab.textColor=[UIColor colorHelpWithRed:84 green:83 blue:83 alpha:1];
                tlab.font=[UIFont systemFontOfSize:14];
                [weatherview addSubview:tlab];
              
                UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(x, 30*row+35, 20, 20)];
                self.selectbtn=btn;
                btn.tag=i;
                [btn setBackgroundImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                [weatherview addSubview:btn];
                if (i==self.weaarr.count-1) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                    self.weastr=@"其他";
                }
                [self.btnarr addObject:btn];
            }
        }
    }
    
    //desview
    [self creatdesview];

//    UIButton *fbbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2-35, 530, 70, 35)];
//    [fbbtn setTitle:@"发布" forState:UIControlStateNormal];
////    [fbbtn setBackgroundImage:[UIImage imageNamed:@"提交_03"] forState:UIControlStateNormal];
////    [fbbtn setBackgroundImage:[UIImage imageNamed:@"提交点击"] forState:UIControlStateHighlighted];
//    [fbbtn setBackgroundColor:[UIColor colorHelpWithRed:23 green:112 blue:181 alpha:1]];
//    [fbbtn addTarget:self action:@selector(fbAction) forControlEvents:UIControlEventTouchUpInside];
//    [backgroundScrollView addSubview:fbbtn];
    
  
    
}
-(void)creatdesview{
    UIView *desview=[[UIView alloc]initWithFrame:CGRectMake(10, 340, kScreenWidth-20, 180)];
    desview.backgroundColor=[UIColor whiteColor];
    [self.backgroundScrollView addSubview:desview];
    UIImageView *tline=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 1)];
    tline.backgroundColor=[UIColor grayColor];
    [desview addSubview:tline];
    UIImageView *tline1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 179, kScreenWidth-20, 1)];
    tline1.backgroundColor=[UIColor grayColor];
    [desview addSubview:tline1];
    UIImageView *tline2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 180)];
    tline2.backgroundColor=[UIColor grayColor];
    [desview addSubview:tline2];
    UIImageView *tline3=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-21, 0, 1, 180)];
    tline3.backgroundColor=[UIColor grayColor];
    [desview addSubview:tline3];
    UILabel *wzlab=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 60, 30)];
    wzlab.text=@"位    置:";
    wzlab.font=[UIFont systemFontOfSize:14];
    wzlab.textColor=[UIColor colorHelpWithRed:84 green:83 blue:83 alpha:1];
    [desview addSubview:wzlab];
    UIImageView *addressimg=[[UIImageView alloc]initWithFrame:CGRectMake(65, 5, kScreenWidth-95, 30)];
    addressimg.image=[UIImage imageNamed:@"输入框"];
    addressimg.userInteractionEnabled=YES;
    [desview addSubview:addressimg];
    UIImageView *editimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-120, 5, 22, 20)];
    editimg.image=[UIImage imageNamed:@"编辑图标"];
    [addressimg addSubview:editimg];
    UITextField *addresstf=[[UITextField alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-100, 30)];
    self.addresstf=addresstf;
    addresstf.returnKeyType=UIReturnKeyDone;
    self.addresstf.delegate=self;
    if (self.titlecity.length>0) {
        addresstf.placeholder=self.titlecity;
    }else{
        if ([[setting sharedSetting].currentCity isEqualToString:@"省会福州"]) {
            addresstf.placeholder=@"福州市";
        }else{
            addresstf.placeholder=[setting sharedSetting].currentCity;
        }
    }
    [addressimg addSubview:addresstf];
    
    UILabel *sjlab=[[UILabel alloc]initWithFrame:CGRectMake(5, 45, 60, 30)];
    sjlab.text=@"时    间:";
    sjlab.font=[UIFont systemFontOfSize:14];
    sjlab.textColor=[UIColor colorHelpWithRed:84 green:83 blue:83 alpha:1];
    [desview addSubview:sjlab];
    UIImageView *sjimg=[[UIImageView alloc]initWithFrame:CGRectMake(65, 45, kScreenWidth-95, 30)];
    sjimg.image=[UIImage imageNamed:@"输入框"];
    sjimg.userInteractionEnabled=YES;
    [desview addSubview:sjimg];
    UIImageView *timeimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-125, 5, 20, 20)];
    timeimg.image=[UIImage imageNamed:@"日期"];
    [sjimg addSubview:timeimg];
    UITextField *sjtf=[[UITextField alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-100, 30)];
    sjtf.placeholder=[self currentDate];
     sjtf.returnKeyType=UIReturnKeyDone;
    self.timetf=sjtf;
    self.timetf.delegate=self;
    [sjimg addSubview:sjtf];
    
    UILabel *nicklab=[[UILabel alloc]initWithFrame:CGRectMake(5, 80, 60, 30)];
    nicklab.text=@"昵    称:";
    nicklab.font=[UIFont systemFontOfSize:14];
    nicklab.textColor=[UIColor colorHelpWithRed:84 green:83 blue:83 alpha:1];
    [desview addSubview:nicklab];
    UIImageView *nickimg=[[UIImageView alloc]initWithFrame:CGRectMake(65, 80, 160, 30)];
    nickimg.image=[UIImage imageNamed:@"输入框"];
    nickimg.userInteractionEnabled=YES;
    [desview addSubview:nickimg];
    UITextField *nicktf=[[UITextField alloc]initWithFrame:CGRectMake(5, 0, 159, 30)];
    self.nicktf=nicktf;
    nicktf.returnKeyType=UIReturnKeyDone;
    self.nicktf.delegate=self;
    if (self.username.length>0) {
       nicktf.placeholder=self.username;
    }else{
        nicktf.placeholder=@"陌生人";
    }
    [nickimg addSubview:nicktf];
    UIButton *loginbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-90, 80, 60, 30)];
    [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    loginbtn.layer.cornerRadius = 10;
    loginbtn.layer.masksToBounds = YES;
//    [loginbtn setBackgroundImage:[UIImage imageNamed:@"提交_03"] forState:UIControlStateNormal];
    [loginbtn setBackgroundColor:[UIColor colorHelpWithRed:23 green:112 blue:181 alpha:1]];
    [loginbtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [desview addSubview:loginbtn];
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    if (!userid.length>0) {
        loginbtn.hidden=NO;
    }else{
        loginbtn.hidden=YES;
    }

    UILabel *deslab=[[UILabel alloc]initWithFrame:CGRectMake(5, 120, 65, 30)];
    deslab.text=@"图片描述:";
    deslab.font=[UIFont systemFontOfSize:14];
    deslab.textColor=[UIColor colorHelpWithRed:84 green:83 blue:83 alpha:1];
    [desview addSubview:deslab];
    UIImageView *desimg=[[UIImageView alloc]initWithFrame:CGRectMake(65, 120, 160, 50)];
    desimg.image=[UIImage imageNamed:@"输入框"];
    desimg.userInteractionEnabled=YES;
    [desview addSubview:desimg];
    self.commentTF=[[UITextView alloc]initWithFrame:CGRectMake(5, 5, 145, 40)];
    self.commentTF.delegate=self;
    self.commentTF.returnKeyType=UIReturnKeyDone;
    self.commentTF.hidden=NO;
    [desimg addSubview:self.commentTF];
    
    
    
    self.bglabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-100, 20)];
    [self.bglabel setBackgroundColor:[UIColor clearColor]];
    self.bglabel.text=@"请输入您的描述";
    self.str=self.bglabel.text;
    [self.bglabel setTextColor:[UIColor blackColor]];
    self.bglabel.enabled=NO;
    [self.bglabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [self.commentTF addSubview:self.bglabel];
    
    _wordNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(desimg.frame)-30, 20)];
    _wordNumLab.backgroundColor = [UIColor clearColor];
    _wordNumLab.textAlignment = NSTextAlignmentRight;
    _wordNumLab.font = [UIFont fontWithName:kBaseFont size:12];
    _wordNumLab.textColor = [UIColor grayColor];
    _wordNumLab.text = @"0";
    [desimg addSubview:_wordNumLab];
    
    UILabel * wordAcountLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(desimg.frame)-30, 30, 30, 20)];
    wordAcountLab.backgroundColor = [UIColor clearColor];
    wordAcountLab.textAlignment = NSTextAlignmentLeft;
    wordAcountLab.font = [UIFont fontWithName:kBaseFont size:12];
    wordAcountLab.textColor = [UIColor grayColor];
    wordAcountLab.text = @"/100";
    [desimg addSubview:wordAcountLab];
    UIButton *fbbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-90, 122, 60, 30)];
    [fbbtn setTitle:@"发布" forState:UIControlStateNormal];
    [fbbtn setBackgroundImage:[UIImage imageNamed:@"实景提交按钮常态"] forState:UIControlStateNormal];
    [fbbtn setBackgroundImage:[UIImage imageNamed:@"实景提交按钮二态"] forState:UIControlStateHighlighted];
    //    [fbbtn setBackgroundImage:[UIImage imageNamed:@"提交_03"] forState:UIControlStateNormal];
    //    [fbbtn setBackgroundImage:[UIImage imageNamed:@"提交点击"] forState:UIControlStateHighlighted];
//    fbbtn.layer.cornerRadius = 10;
//    fbbtn.layer.masksToBounds = YES;
//    [fbbtn setBackgroundColor:[UIColor colorHelpWithRed:23 green:112 blue:181 alpha:1]];
    [fbbtn addTarget:self action:@selector(fbAction) forControlEvents:UIControlEventTouchUpInside];
    [desview addSubview:fbbtn];
}
-(void)click:(UIButton *)sender{
    NSInteger tag=sender.tag;
    UIButton *t_btn = sender;
//    if (self.isclick==NO) {
    
        [t_btn setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        self.weastr=self.weaarr[tag];
        self.isclick=YES;
        for (int i=0; i<self.btnarr.count; i++) {
            UIButton *btn=self.btnarr[i];
            if (btn.tag!=t_btn.tag) {
                [btn setBackgroundImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
            }
            
        }
//    }else{
//        [t_btn setBackgroundImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
//        self.isclick=NO;
//    }
    
}
-(void)fbAction{
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
//    if (!userid.length>0) {
//        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"请先登录账号" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [al show];
//        return;
//    }else{
    
        NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *sjkppublicItem = [NSMutableDictionary dictionaryWithCapacity:4];
        [t_h setObject:[setting sharedSetting].app forKey:@"p"];
        if (self.commentTF.text.length>0) {
             [sjkppublicItem setObject:self.commentTF.text forKey:@"des"];
        }
        if (self.weastr.length>0) {
             [sjkppublicItem setObject:self.weastr forKey:@"weather"];
        }
        if (self.titlecity.length>0) {
            [sjkppublicItem setObject:self.titlecity forKey:@"address"];
        }else{
            [sjkppublicItem setObject:[setting sharedSetting].currentCity forKey:@"address"];
        }
        if (userid.length>0) {
        [sjkppublicItem setObject:userid forKey:@"user_id"];
        }
    
         NSString * time = [self currentDate];
            [sjkppublicItem setObject:time forKey:@"dateTime"];
    [sjkppublicItem setObject:[setting getSysUid] forKey:@"imei"];
    if (self.DWid.length>0) {
        [sjkppublicItem setObject:self.DWid forKey:@"county_id"];
    }else  {
        [sjkppublicItem setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    }
        [t_b setObject:sjkppublicItem forKey:@"gz_scenery_push"];
        [t_dic setObject:t_h forKey:@"h"];
        [t_dic setObject:t_b forKey:@"b"];
        
        NSString *t_str=[t_dic urlEncodedStringCustom];

        NSDictionary *parameters = @{@"p":t_str};
       [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    if (kSystemVersionMore8) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
           manager.responseSerializer.acceptableContentTypes  =[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript" ,@"text/plain" , nil];
    [manager POST:ONLINE_URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>   formData) {
        UIImage *img = [self imageCompressForWidth:self.fbimage targetWidth:kScreenWidth];//压缩图片
        
        NSData *imageData =UIImageJPEGRepresentation(img,1.0);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"temp.jpg" mimeType:@"multipart/form-data"];
    } progress:^(NSProgress *  uploadProgress) {
        
    } success:^(NSURLSessionDataTask *  task, id   responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSDictionary *t_b = [responseObject objectForKey:@"b"];
        NSDictionary *sjkp=[t_b objectForKey:@"gz_scenery_push"];
        NSString *result=[sjkp objectForKey:@"result"];
        if ([result isEqualToString:@"1"]) {
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"嘿嘿,提交成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            al.tag=111;
            [al show];
            
        }else{
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"哎呀,提交失败,再试试吧" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            al.tag=222;
            [al show];
        }
        
        

    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"哎呀,提交失败,再试试吧" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        al.tag=222;
        [al show];
    }];
    }else{
        NSString *tmpfilename=[NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]];
        NSURL *tmpfileurl=[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tmpfilename]];
        NSMutableURLRequest *mrq=[[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:ONLINE_URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>   formData) {
            UIImage *img = [self imageCompressForWidth:self.fbimage targetWidth:kScreenWidth];//压缩图片
            NSData *imageData =UIImageJPEGRepresentation(img,1.0);
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"temp.jpg" mimeType:@"multipart/form-data"];
        } error:(nil)];
        [[AFHTTPRequestSerializer serializer]requestWithMultipartFormRequest:mrq writingStreamContentsToFile:tmpfileurl completionHandler:^(NSError *  error) {
            AFURLSessionManager *maneger=[[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            maneger.responseSerializer=[AFHTTPResponseSerializer serializer];
            NSURLSessionUploadTask *uploadtask=[maneger uploadTaskWithRequest:mrq fromFile:tmpfileurl progress:nil completionHandler:^(NSURLResponse *  response, id   responseObject, NSError *  error) {
                [[NSFileManager defaultManager]removeItemAtURL:tmpfileurl error:nil];
                if (error) {
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                }else{
                    NSDictionary* jdic = [NSJSONSerialization
                                          JSONObjectWithData:responseObject
                                          options:kNilOptions
                                          error:&error];
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                    NSDictionary *t_b = [jdic objectForKey:@"b"];
                    NSDictionary *sjkp=[t_b objectForKey:@"gz_scenery_push"];
                    NSString *result=[sjkp objectForKey:@"result"];
                    if ([result isEqualToString:@"1"]) {
                        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"嘿嘿,提交成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        al.tag=111;
                        [al show];
                        
                    }else{
                        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"哎呀,提交失败,再试试吧" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        al.tag=222;
                        [al show];
                    }
                }
            }];
            [uploadtask resume];
        }];
    }
//        [manager POST:ONLINE_URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
////            UIImage *img = [self scaleToSize:self.fbimage size:CGSizeMake(kScreenWidth,kScreenHeitht)];//压缩图片
//            UIImage *img = [self imageCompressForWidth:self.fbimage targetWidth:kScreenWidth];//压缩图片
//            
//            NSData *imageData =UIImageJPEGRepresentation(img,1.0);
//            [formData appendPartWithFileData:imageData name:@"file" fileName:@"temp.jpg" mimeType:@"multipart/form-data"];
//        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
////            NSLog(@"Success: %@", responseObject);
//            [MBProgressHUD hideHUDForView:self.view animated:NO];
//            NSDictionary *t_b = [responseObject objectForKey:@"b"];
//            NSDictionary *sjkp=[t_b objectForKey:@"gz_scenery_push"];
//            NSString *result=[sjkp objectForKey:@"result"];
//            if ([result isEqualToString:@"1"]) {
////                LivePhotoViewController *live=[[LivePhotoViewController alloc]init];
////                live.signle=@"1";
////                [self.navigationController pushViewController:live animated:YES];
//                UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"嘿嘿,提交成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//                al.tag=111;
//                [al show];
//                
//            }else{
//                UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"哎呀,提交失败,再试试吧" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//                al.tag=222;
//                [al show];
//            }
//            
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//           [MBProgressHUD hideHUDForView:self.view animated:NO];
//            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"哎呀,提交失败,再试试吧" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//            al.tag=222;
//            [al show];
//        }];
//    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==111) {
        if (buttonIndex==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updatesjkp" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            return;
        }
    }
    if (alertView.tag==333) {
        if (buttonIndex==0) {
            return;
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(NSString *)currentDate
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * dateStr = [formatter stringFromDate:[NSDate date]];
    return dateStr;
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)leftAction{
    UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"真心付水流,小知叹可惜,真的要放弃吗?" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"放弃", nil];
    al.tag=333;
    [al show];
    
}
-(void)loginAction{
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    if (userid.length>0) {
        GRZXViewController *grzx=[[GRZXViewController alloc]init];
        [self.navigationController pushViewController:grzx animated:YES];
    }else{
        LGViewController *lg=[[LGViewController alloc]init];
        lg.type=@"观察";
        [self.navigationController pushViewController:lg animated:YES];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.commentTF resignFirstResponder];
    [self.nicktf resignFirstResponder];
    [self.addresstf resignFirstResponder];
    [self.timetf resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nicktf resignFirstResponder];
    [self.addresstf resignFirstResponder];
    [self.timetf resignFirstResponder];
    return YES;
}
#pragma mark - UITextView
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.bglabel.hidden = YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.bglabel.hidden = YES;
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.commentTF resignFirstResponder];
        return NO;
    }
    if (![text isEqualToString:@""]) {
        self.bglabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.bglabel.hidden = NO;
    }
    
    NSString * new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    self.wordNumLab.text = [NSString stringWithFormat:@"%d",new.length];
    NSInteger res = 100-[new length];
    if(res > 0)
    {
        return YES;
    }
    else
    {
        NSRange rg = {0,[text length]+res};
        if(rg.length>0)
        {
            NSString * s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"您的评论超出了指定范围请重写" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alre show];
        return NO;
    }
}
#pragma mark keyboardWillhe
- (void)changeShareContentHeight:(float)t_height withDuration:(float)t_dration
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:t_dration];
    [UIView setAnimationDelegate:self];
    if (iPhone4) {
        [self.backgroundScrollView setContentOffset:CGPointMake(0, 280)];
    }else{
    [self.backgroundScrollView setContentOffset:CGPointMake(0, 300)];
    }
    [UIView commitAnimations];
}
-(void)changeNewview
{
    [self.backgroundScrollView setContentOffset:CGPointMake(0, 0)];
    
}
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self changeShareContentHeight:keyboardRect.size.height withDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGRect keyboardRect = [animationDurationValue CGRectValue];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    //    [self changeShareContentHeight:keyboardRect.size.height withDuration:animationDuration];
    [self changeNewview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
