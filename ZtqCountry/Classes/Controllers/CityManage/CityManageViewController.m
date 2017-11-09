//
//  CityManageViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-6-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "CityManageViewController.h"
#import "CityTableViewCell.h"
#import "MFSideMenuContainerViewController.h"
#import "setting.h"
//#import "NetWorkCenter.h"
#import "MainNewViewController.h"

#import "NSDictionary+UrlEncodedString.h"
#import "LivePhotoViewController.h"
#import "SomeSettingViewController.h"
#define Width kScreenWidth/6*5
@interface CityManageViewController ()
@property (strong, nonatomic) NSMutableDictionary * weatherInfoDic;

@end

@implementation CityManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.weatherInfoDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateview) name:@"uptable" object:nil];//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dwblock:) name:@"againdwsuccess" object:nil];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=YES;
    if (kSystemVersionMore7) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
       
    }
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.locationTimeout = 3;
    //   逆地理请求超时时间，可修改，最小2s
    self.locationManager.reGeocodeTimeout = 3;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    
    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    bgimg.image=[UIImage imageNamed:@"城市编辑背景.png"];
    bgimg.userInteractionEnabled=YES;
    [self.view addSubview:bgimg];
    
    self.editBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.editBtn.frame=CGRectMake(Width-60, 27, 50, 31);
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    self.editBtn.titleLabel.font=[UIFont systemFontOfSize:17];
//    [self.editBtn setBackgroundImage:[UIImage imageNamed:@"cssz编辑"] forState:UIControlStateNormal];
//    [self.editBtn setBackgroundImage:[UIImage imageNamed:@"cssz编辑点击"] forState:UIControlStateHighlighted];
    [self.editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [bgimg addSubview:self.editBtn];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(current:) name:@"current" object:nil];//当前城市
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingWeather) name:@"upleftview" object:nil];
    self.marr=[[NSMutableArray alloc]initWithCapacity:10];
    
    
    float height=[[setting sharedSetting].citys count]*50;
    m_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, Width-5,height+72)  style:UITableViewStylePlain];
    
	m_tableview.backgroundColor = [UIColor clearColor];
    m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
	m_tableview.autoresizesSubviews = YES;
	m_tableview.showsHorizontalScrollIndicator = NO;
	m_tableview.showsVerticalScrollIndicator = NO;
	m_tableview.delegate = self;
	m_tableview.dataSource = self;
	[bgimg addSubview:m_tableview];
    
    UIButton *leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame=CGRectMake(15, 25,30, 30);
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [bgimg addSubview:leftbtn];
    
    self.addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame=CGRectMake(5, height+105,Width-10 , 40);
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"城市天气底座"] forState:UIControlStateNormal];
//    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"cssz加号点击"] forState:UIControlStateHighlighted];
    [self.addBtn setTitle:@"+  继续添加城市" forState:UIControlStateNormal];
    self.addBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.addBtn addTarget:self action:@selector(AddCity) forControlEvents:UIControlEventTouchUpInside];
    [bgimg addSubview:self.addBtn];
    
    UIButton *tsbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    tsbtn.frame=CGRectMake((Width-140)/3, kScreenHeitht-70,70, 65);
    [tsbtn setBackgroundImage:[UIImage imageNamed:@"左侧按钮底.png"] forState:UIControlStateNormal];
    [tsbtn setBackgroundImage:[UIImage imageNamed:@"左侧按钮底点击.png"] forState:UIControlStateHighlighted];
    [tsbtn addTarget:self action:@selector(TSAction) forControlEvents:UIControlEventTouchUpInside];
    [bgimg addSubview:tsbtn];
    UIImageView *tsimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    tsimg.image=[UIImage imageNamed:@"风雨查询"];
    [tsbtn addSubview:tsimg];
    UILabel *tslab=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, tsbtn.frame.size.width, 25)];
    tslab.text=@"风雨查询";
    tslab.textAlignment=NSTextAlignmentCenter;
    tslab.textColor=[UIColor whiteColor];
    tslab.font=[UIFont systemFontOfSize:15];
    [tsbtn addSubview:tslab];
    
    UIButton *SJbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    SJbtn.frame=CGRectMake((Width-140)/3*2+70, kScreenHeitht-70,70, 65);
    [SJbtn setBackgroundImage:[UIImage imageNamed:@"左侧按钮底.png"] forState:UIControlStateNormal];
    [SJbtn setBackgroundImage:[UIImage imageNamed:@"左侧按钮底点击.png"] forState:UIControlStateHighlighted];
    [SJbtn addTarget:self action:@selector(SJAction) forControlEvents:UIControlEventTouchUpInside];
    [bgimg addSubview:SJbtn];
    UIImageView *sjimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    sjimg.image=[UIImage imageNamed:@"亲情服务"];
    [SJbtn addSubview:sjimg];
    UILabel *sjlab=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, tsbtn.frame.size.width, 25)];
    sjlab.text=@"亲情服务";
    sjlab.textAlignment=NSTextAlignmentCenter;
    sjlab.textColor=[UIColor whiteColor];
    sjlab.font=[UIFont systemFontOfSize:15];
    [SJbtn addSubview:sjlab];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(myHandleTableviewCellLongPressed:)];
    
    longPress.minimumPressDuration = 1.0;
    [m_tableview addGestureRecognizer:longPress];
    
    [[setting sharedSetting] loadSetting];
    self.delegate = [MainNewViewController shareVC];
    UISwipeGestureRecognizer * rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(centerViewControllerRighttSwiped:)];
    [rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:rightSwipeRecognizer];
}
-(void)updateview{
    [m_tableview reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatatableview) name:@"dingweiupdata" object:nil];
    self.DWcity=[setting sharedSetting].dingweicity;
    
    for (int i=0; i<[[setting sharedSetting].citys count]; i++) {
        NSString *strcity=[[[setting sharedSetting].citys objectAtIndex:i]objectForKey:@"ID"];
        if ([self.DWcity isEqualToString:strcity]) {
            _isDW=YES;
        }
        
    }
    BOOL isdw=![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
    if (isdw==NO) {
        _isDW=NO;
    }

    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"dwswitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"upswitch" object:nil];
        _isDW=NO;
    }
    [m_tableview reloadData];
   
    float height=[[setting sharedSetting].citys count]*50;
    
//    BOOL isdw=![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
//    if (isdw==YES) {
//        _isDW=YES;
//    }else{
//        _isDW=NO;
//    }
//    if (_isDW==NO) {
//        height=([[setting sharedSetting].citys count]+1)*50;
//    }
    if (_isClick==NO) {
        m_tableview.frame=CGRectMake(0, 60, Width-5, height+72);
        
        self.addBtn.frame=CGRectMake(5, height+105,Width-10 , 40);
    }else{
        m_tableview.frame=CGRectMake(0, 60, kScreenWidth, height+72);
        self.addBtn.frame=CGRectMake(5, height+105,kScreenWidth-10 , 40);
    }
    
    //    if (_isDW==YES) {
    //        if ([[setting sharedSetting].citys count]>7) {
    //            self.addBtn.hidden=YES;
    //        }else{
    //            self.addBtn.hidden=NO;
    //        }
    //    }else{
    if (iPhone4) {
        if ([[setting sharedSetting].citys count]>5) {
            self.addBtn.hidden=YES;
        }else{
            self.addBtn.hidden=NO;
        }
    }else{
    if ([[setting sharedSetting].citys count]>7) {
        self.addBtn.hidden=YES;
    }else{
        self.addBtn.hidden=NO;
    }
    }
    //    }
    
    [self loadingWeather];
}
-(void)updatatableview{
    _isDW=YES;
    [m_tableview reloadData];
}
-(void)AddCity{
    
  
//        CATransition *animation = [CATransition animation];
//        animation.delegate = self;
//        animation.duration = 0.5;
//        animation.timingFunction = UIViewAnimationCurveEaseInOut;
//        animation.type = kCATransitionReveal;
//        animation.subtype = kCATransitionFromLeft;
//        [self.navigationController.view.layer addAnimation:animation forKey:@"animation"];
        AddCityViewController *addcity=[[AddCityViewController alloc]init];
        addcity.delegate=self;
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        [self.navigationController pushViewController:addcity animated:YES];
    
}
-(void)leftAction{
    [m_tableview setEditing:NO animated:YES];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _isClick=NO;
    float height=[[setting sharedSetting].citys count]*50;
//    if (_isDW==NO) {
//        height=([[setting sharedSetting].citys count]+1)*50;
//    }
    m_tableview.frame=CGRectMake(0, 60, Width-5, height+72);
    self.addBtn.frame=CGRectMake(5, height+105,Width-10 , 40);
    self.editBtn.frame=CGRectMake(Width-60, 27, 50, 30);
    MFSideMenuContainerViewController * container =[self.navigationController.viewControllers objectAtIndex:1];
    [container setMenuWidth:Width animated:YES];
    [container togleCenterViewController];
}
-(void)centerViewControllerRighttSwiped:(id)sender{
    [m_tableview setEditing:NO animated:YES];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _isClick=NO;
    float height=[[setting sharedSetting].citys count]*50;
//    if (_isDW==NO) {
//        height=([[setting sharedSetting].citys count]+1)*50;
//    }
    m_tableview.frame=CGRectMake(0, 60, Width-5, height+72);
    self.addBtn.frame=CGRectMake(5, height+105,Width-10 , 40);
    self.editBtn.frame=CGRectMake(Width-60, 27, 50, 30);
    MFSideMenuContainerViewController * container =[self.navigationController.viewControllers objectAtIndex:1];
    [container setMenuWidth:Width animated:YES];
    [container togleCenterViewController];
    [m_tableview reloadData];
}
-(void)TSAction{
    WindowAndRainVC *wrvc=[[WindowAndRainVC alloc]init];
//    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [self.navigationController pushViewController:wrvc animated:YES];
}
-(void)SJAction{
//    NSLog(@"实景");
//    LivePhotoViewController *livep=[[LivePhotoViewController alloc]init];
//    [self.navigationController pushViewController:livep animated:YES];
    QQFirstVC*qq=[[QQFirstVC alloc]init];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [self.navigationController pushViewController:qq animated:YES];
}
-(void)edit:(id)sender{
    UIButton *b=sender;
    if (_isClick==NO) {
//        [b setBackgroundImage:[UIImage imageNamed:@"sctq确定"] forState:UIControlStateNormal];
        [b setTitle:@"确认" forState:UIControlStateNormal];
        [m_tableview setEditing:YES animated:YES];
        _isClick=YES;
        MFSideMenuContainerViewController * container = [MFSideMenuContainerViewController containerWithCenterViewController:nil leftMenuViewController:self rightMenuViewController:nil];
        [container setMenuWidth:kScreenWidth animated:YES];
        float height=[[setting sharedSetting].citys count]*50;
//        if (_isDW==NO) {
//            height=([[setting sharedSetting].citys count]+1)*50;
//        }
        m_tableview.frame=CGRectMake(0, 60, kScreenWidth, height+72);
        self.addBtn.frame=CGRectMake(5, height+105,kScreenWidth-10 , 40);
        self.editBtn.frame=CGRectMake(kScreenWidth-65, 27, 50, 30);
    }else{
        [m_tableview setEditing:NO animated:YES];
//        [b setBackgroundImage:[UIImage imageNamed:@"cssz编辑"] forState:UIControlStateNormal];
        [b setTitle:@"编辑" forState:UIControlStateNormal];
        _isClick=NO;
        MFSideMenuContainerViewController * container = [MFSideMenuContainerViewController containerWithCenterViewController:nil leftMenuViewController:self rightMenuViewController:nil];
        [container setMenuWidth:kScreenWidth/6*5 animated:YES];
        float height=[[setting sharedSetting].citys count]*50;
//        if (_isDW==NO) {
//            height=([[setting sharedSetting].citys count]+1)*50;
//        }
        m_tableview.frame=CGRectMake(0, 60, self.view.width-5, height+72);
        self.addBtn.frame=CGRectMake(5, height+105,self.view.width-10 , 40);
        self.editBtn.frame=CGRectMake(self.view.width-60, 27, 50, 30);
    }

    [m_tableview reloadData];
    
    
}
//当前城市
-(void)current:(NSNotification *)sender{
    self.DWcity=[setting sharedSetting].dingweicity;
    for (int i=0; i<[[setting sharedSetting].citys count]; i++) {
        NSString *strcity=[[[setting sharedSetting].citys objectAtIndex:i]objectForKey:@"ID"];
        if ([self.DWcity isEqualToString:strcity]) {
            _isDW=YES;
        }
        
    }
    [self loadingWeather];
}
////选择城市的值
//- (void)reloadView: (NSNotification *)sender
//{
//    NSDictionary *dic= sender.object;
//    NSString *selectcity=[dic objectForKey:@"city"];
//    NSString *ID=[dic objectForKey:@"ID"];
//    [setting sharedSetting].currentCity=selectcity;
//    [setting sharedSetting].currentCityID=ID;
//    [[setting sharedSetting].citys addObject:dic];
//    [[setting sharedSetting] saveSetting];
//}
////热门城市的值
//-(void)city:(NSNotification*)sender{
//   NSDictionary *dic= sender.object;
//    NSString *city=[dic objectForKey:@"city"];
//    NSString * ID = [dic objectForKey:@"ID"];
//    [setting sharedSetting].currentCityID = ID;
//    [setting sharedSetting].currentCity = city;
//    [[setting sharedSetting].citys addObject:dic];
//    [[setting sharedSetting] saveSetting];
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isDW==NO) {
        return 1;
    }
    return 2;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    if (section==0) {
        
            return 35;
        }
    return 0;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *bgview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(40, 2.5, 200, 30)];
    lab.font = [UIFont systemFontOfSize:15];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = @"城市自动定位";
    lab.textColor=[UIColor whiteColor];
    [bgview addSubview:lab];
//    UISwitch * RSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 2.5, 60, 15)];
//    if (_isClick==YES) {
//        RSwitch.frame=CGRectMake(260, 2.5, 60, 15);
//    }
//    RSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
//    RSwitch.on = ![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
//    [RSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//    [bgview addSubview:RSwitch];
//    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
//    {
//        RSwitch.on = NO;
//    }
    _zjswitch = [[ZJSwitch alloc] initWithFrame:CGRectMake(Width-60,2.5, 60, 20)];
    if (_isClick==YES) {
        _zjswitch.frame=CGRectMake(kScreenWidth-60, 2.5, 60, 20);
    }

    _zjswitch.onTintColor = [UIColor colorHelpWithRed:0 green:157 blue:205 alpha:1];
    _zjswitch.tintColor = [UIColor whiteColor];
    _zjswitch.thumbTintColor = [UIColor whiteColor];
    _zjswitch.transform = CGAffineTransformMakeScale(0.85, 0.85);
    _zjswitch.onText = @"开";
    _zjswitch.offText = @"关";
    _zjswitch.on = ![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
    if (_zjswitch.on==NO) {
        _zjswitch.style=ZJSwitchStyleBorder;
    }else{
        _zjswitch.style = ZJSwitchStyleNoBorder;
    }
    [_zjswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [bgview addSubview:_zjswitch];
    
    
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        _zjswitch.on = NO;
    }
    return bgview;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isDW==NO) {
//        if (section==0) {
//            return 1;
//        }if (section==1) {
        return [[setting sharedSetting].citys count];
//        }
    }else{
        if (section==0) {
            return 1;
        }if (section==1) {
            return [[setting sharedSetting].citys count]-1;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    int row = indexPath.row;
    int section = indexPath.section;
    
    NSString *t_str = [NSString stringWithFormat:@"cell %d_%d", section, row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:t_str];
    
    if(cell != nil)
        [cell removeFromSuperview];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    

    if(_isDW == NO)
    {
//        if(indexPath.section == 0)
//        {
//            
//            UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"城市天气底座.png"]];
//            m_image.userInteractionEnabled=YES;
//            if (self.isClick==NO) {
//                [m_image setFrame:CGRectMake(5, 3, 260, 45)];
//            }else
//                [m_image setFrame:CGRectMake(5, 3, kScreenWidth-10, 45)];
//            
//            [cell addSubview:m_image];
//            UIImageView *titleImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 18, 25)];
//            titleImg.image=[UIImage imageNamed:@"定位.png"];
//            [cell addSubview:titleImg];
//            UILabel *city_labe=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 50)];
//            city_labe.textColor=[UIColor whiteColor];
//            city_labe.font=[UIFont systemFontOfSize:16];
//            city_labe.backgroundColor=[UIColor clearColor];
//            city_labe.textAlignment=NSTextAlignmentLeft;
//            [cell addSubview:city_labe];
//            city_labe.text=@"定位失败";
//        }else{
        
        if ([setting sharedSetting].citys.count>0) {
            UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"城市天气底座.png"]];
            m_image.userInteractionEnabled=YES;
            if (self.isClick==NO) {
                [m_image setFrame:CGRectMake(5, 3, Width-10, 45)];
            }else
                [m_image setFrame:CGRectMake(5, 3, kScreenWidth-10, 45)];
            
            [cell addSubview:m_image];
            UIImageView *titleImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 17, 20, 19)];
            [cell addSubview:titleImg];
            UILabel *city_labe=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 50)];
            city_labe.textColor=[UIColor whiteColor];
            city_labe.font=[UIFont systemFontOfSize:16];
           city_labe.backgroundColor=[UIColor clearColor];
            city_labe.textAlignment=NSTextAlignmentLeft;
            [cell addSubview:city_labe];
            UIImageView *ico=[[UIImageView alloc]initWithFrame:CGRectMake(140, 10, 30, 30)];
            [cell addSubview:ico];
            UILabel *sstqlab=[[UILabel alloc]initWithFrame:CGRectMake(190, 0, 100, 50)];
            sstqlab.textColor=[UIColor whiteColor];
            sstqlab.backgroundColor=[UIColor clearColor];
            sstqlab.font= [UIFont systemFontOfSize:14];
            [cell addSubview:sstqlab];
            

            UIImageView *icoImg=[[UIImageView alloc]initWithFrame:CGRectMake(180, 10, 20, 20)];
            [cell addSubview:icoImg];
            UILabel *hlwd=[[UILabel alloc]initWithFrame:CGRectMake(210, 0, 100, 50)];
            hlwd.textColor=[UIColor blackColor];
            hlwd.backgroundColor=[UIColor clearColor];
            hlwd.font= [UIFont systemFontOfSize:12];
            [cell addSubview:hlwd];
            
            NSDictionary * cityInfo = [[setting sharedSetting].citys objectAtIndex:indexPath.row];
            NSString * cityID = [cityInfo objectForKey:@"ID"];

            
            NSDictionary * cityWeatherInfo = [self.weatherInfoDic objectForKey:cityID];
            if(cityWeatherInfo != nil)
            {

                NSString * lowt = [cityWeatherInfo objectForKey:@"lowt"];
                NSString * higt = [cityWeatherInfo objectForKey:@"higt"];
                NSString *iconame=[cityWeatherInfo objectForKey:@"wd_daytime_ico"];
                NSString *wt_night_ico=[cityWeatherInfo objectForKey:@"wd_night_ico"];
                NSString *isnight=[cityWeatherInfo objectForKey:@"is_night"];
                if ([isnight isEqualToString:@"1"]) {
//                    sstqlab.text=[NSString stringWithFormat:@"%@°/%@°",lowt,higt];
                    sstqlab.text=[NSString stringWithFormat:@"%@°/%@°",higt,lowt];
                    ico.image=[UIImage imageNamed:[NSString stringWithFormat:@"n%@",wt_night_ico]];
                }else{
                    sstqlab.text=[NSString stringWithFormat:@"%@°/%@°",higt,lowt];
                    ico.image=[UIImage imageNamed:iconame];
                }
            }
            
            
            NSDictionary *dic=[[setting sharedSetting].citys objectAtIndex:indexPath.row];
            NSString *city=[dic objectForKey:@"city"];
            city_labe.text=[self readXMLwith:cityID];
//            BOOL isdw=![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
//            if (isdw==YES) {
//                if (![[setting sharedSetting].dingweicity isEqualToString:[setting sharedSetting].morencityID]) {
//                    if ([city isEqualToString:[setting sharedSetting].morencity]) {
//                        titleImg.image=[UIImage imageNamed:@"主页图标.png"];
//                    }
//                }
//            }else{
            
                    if ([city isEqualToString:[setting sharedSetting].morencity]) {
                        titleImg.image=[UIImage imageNamed:@"主页图标.png"];
                        m_image.image=[UIImage imageNamed:@"左侧选择城市背景.png"];
                    }
                
//            }
            
        
        }
//        }
        

    }
    else
    {
        
            if(indexPath.section == 0)
            {
                
                UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"城市天气底座.png"]];
                m_image.userInteractionEnabled=YES;
                if (self.isClick==NO) {
                    [m_image setFrame:CGRectMake(5, 3, Width-10, 45)];
                }else
                    [m_image setFrame:CGRectMake(5, 3, kScreenWidth-10, 45)];
                
                [cell addSubview:m_image];
                UIImageView *titleImg=[[UIImageView alloc]initWithFrame:CGRectMake(12, 13, 20, 25)];
                titleImg.image=[UIImage imageNamed:@"定位.png"];
                [cell addSubview:titleImg];
                UILabel *city_labe=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 50)];
                city_labe.textColor=[UIColor whiteColor];
                city_labe.font=[UIFont systemFontOfSize:16];
                city_labe.backgroundColor=[UIColor clearColor];
                city_labe.textAlignment=NSTextAlignmentLeft;
                [cell addSubview:city_labe];
                UIImageView *ico=[[UIImageView alloc]initWithFrame:CGRectMake(140, 10, 30, 30)];
                [cell addSubview:ico];
                UILabel *sstqlab=[[UILabel alloc]initWithFrame:CGRectMake(190, 0, 100, 50)];
                sstqlab.textColor=[UIColor whiteColor];
                sstqlab.backgroundColor=[UIColor clearColor];
                sstqlab.font= [UIFont systemFontOfSize:14];
                [cell addSubview:sstqlab];
                
                
                UIImageView *icoImg=[[UIImageView alloc]initWithFrame:CGRectMake(180, 10, 20, 20)];
                [cell addSubview:icoImg];
                UILabel *hlwd=[[UILabel alloc]initWithFrame:CGRectMake(210, 0, 100, 50)];
                hlwd.textColor=[UIColor blackColor];
                hlwd.backgroundColor=[UIColor clearColor];
                hlwd.font= [UIFont systemFontOfSize:12];
                [cell addSubview:hlwd];
                NSDictionary * cityInfo = [[setting sharedSetting].citys objectAtIndex:0];
                NSString * cityID = [cityInfo objectForKey:@"ID"];
                NSDictionary * cityWeatherInfo = [self.weatherInfoDic objectForKey:cityID];
                if(cityWeatherInfo != nil)
                {
                    
                    NSString * lowt = [cityWeatherInfo objectForKey:@"lowt"];
                    NSString * higt = [cityWeatherInfo objectForKey:@"higt"];
                    NSString *iconame=[cityWeatherInfo objectForKey:@"wd_daytime_ico"];
                    NSString *wt_night_ico=[cityWeatherInfo objectForKey:@"wd_night_ico"];
                    NSString *isnight=[cityWeatherInfo objectForKey:@"is_night"];
                    if ([isnight isEqualToString:@"1"]) {
//                        sstqlab.text=[NSString stringWithFormat:@"%@°/%@°",lowt,higt];
                        sstqlab.text=[NSString stringWithFormat:@"%@°/%@°",higt,lowt];
                        ico.image=[UIImage imageNamed:[NSString stringWithFormat:@"n%@",wt_night_ico]];
                    }else{
                        sstqlab.text=[NSString stringWithFormat:@"%@°/%@°",higt,lowt];
                        ico.image=[UIImage imageNamed:iconame];
                    }
                
                }
                NSDictionary *dic=[[setting sharedSetting].citys objectAtIndex:0];
                NSString *city=[dic objectForKey:@"city"];
                city_labe.text=[self readXMLwith:cityID];
                if ([city isEqualToString:[setting sharedSetting].morencity]) {
                    m_image.image=[UIImage imageNamed:@"左侧选择城市背景.png"];
                }
                
            }if(indexPath.section == 1){
                if ([setting sharedSetting].citys.count>1) {
                    UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"城市天气底座.png"]];
                    m_image.userInteractionEnabled=YES;
                    if (self.isClick==NO) {
                        [m_image setFrame:CGRectMake(5, 3, Width-10, 45)];
                    }else
                        [m_image setFrame:CGRectMake(5, 3, kScreenWidth-10, 45)];
                    
                    [cell addSubview:m_image];
                    UIImageView *titleImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 17, 20, 19)];
                    [cell addSubview:titleImg];
                    UILabel *city_labe=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 50)];
                    city_labe.textColor=[UIColor whiteColor];
                    city_labe.font=[UIFont systemFontOfSize:16];
                    city_labe.backgroundColor=[UIColor clearColor];
                    city_labe.textAlignment=NSTextAlignmentLeft;
                    [cell addSubview:city_labe];
                    UIImageView *ico=[[UIImageView alloc]initWithFrame:CGRectMake(140, 10, 30, 30)];
                    [cell addSubview:ico];
                    UILabel *sstqlab=[[UILabel alloc]initWithFrame:CGRectMake(190, 0, 100, 50)];
                    sstqlab.textColor=[UIColor whiteColor];
                    sstqlab.backgroundColor=[UIColor clearColor];
                    sstqlab.font= [UIFont systemFontOfSize:14];
                    [cell addSubview:sstqlab];
                    
                    
                    UIImageView *icoImg=[[UIImageView alloc]initWithFrame:CGRectMake(180, 10, 20, 20)];
                    [cell addSubview:icoImg];
                    UILabel *hlwd=[[UILabel alloc]initWithFrame:CGRectMake(210, 0, 100, 50)];
                    hlwd.textColor=[UIColor blackColor];
                    hlwd.backgroundColor=[UIColor clearColor];
                    hlwd.font= [UIFont systemFontOfSize:12];
                    [cell addSubview:hlwd];
                    
                    NSDictionary * cityInfo = [[setting sharedSetting].citys objectAtIndex:indexPath.row+1];
                    NSString * cityID = [cityInfo objectForKey:@"ID"];
                    
                    
                    NSDictionary * cityWeatherInfo = [self.weatherInfoDic objectForKey:cityID];
                    if(cityWeatherInfo != nil)
                    {
                        NSString * lowt = [cityWeatherInfo objectForKey:@"lowt"];
                        NSString * higt = [cityWeatherInfo objectForKey:@"higt"];
                        NSString *iconame=[cityWeatherInfo objectForKey:@"wd_daytime_ico"];
                        NSString *wt_night_ico=[cityWeatherInfo objectForKey:@"wd_night_ico"];
                        NSString *isnight=[cityWeatherInfo objectForKey:@"is_night"];
                        if ([isnight isEqualToString:@"1"]) {
//                            sstqlab.text=[NSString stringWithFormat:@"%@°/%@°",lowt,higt];
                            sstqlab.text=[NSString stringWithFormat:@"%@°/%@°",higt,lowt];
                            ico.image=[UIImage imageNamed:[NSString stringWithFormat:@"n%@",wt_night_ico]];
                        }else{
                            sstqlab.text=[NSString stringWithFormat:@"%@°/%@°",higt,lowt];
                            ico.image=[UIImage imageNamed:iconame];
                        }
                    }
                    
                    
                    NSDictionary *dic=[[setting sharedSetting].citys objectAtIndex:indexPath.row+1];
                    NSString *city=[dic objectForKey:@"city"];
                    city_labe.text=[self readXMLwith:cityID];
                    BOOL isdw=![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
                    if (isdw==YES) {
                        if (![[setting sharedSetting].dingweicity isEqualToString:[setting sharedSetting].morencityID]) {
                            if ([city isEqualToString:[setting sharedSetting].morencity]) {
                                titleImg.image=[UIImage imageNamed:@"主页图标.png"];
                                m_image.image=[UIImage imageNamed:@"左侧选择城市背景.png"];
                            }
                        }
                    }
                    
                    
                }
            }
        
        
        }
        
    
    
    return cell;
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
        }
    }
    
    return city;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str=nil;
    NSString *ID=nil;
//    int returnIP = 0;
    
    int IP = 0;
    if (_isDW==YES) {
        if(indexPath.section ==0)
        {
//            returnIP = indexPath.row;
//            IP = indexPath.row;
            str=[[[setting sharedSetting].citys objectAtIndex:0] objectForKey:@"city"];
            ID=[[[setting sharedSetting].citys objectAtIndex:0] objectForKey:@"ID"];
        }
        else
        {
//            returnIP = indexPath.row + 1;
//            IP = indexPath.row +1;
            str=[[[setting sharedSetting].citys objectAtIndex:indexPath.row+1] objectForKey:@"city"];
            ID=[[[setting sharedSetting].citys objectAtIndex:indexPath.row+1] objectForKey:@"ID"];
        }
        
    }
    else{

//        if (indexPath.section==0) {
//            return;
//        }
        str=[[[setting sharedSetting].citys objectAtIndex:indexPath.row] objectForKey:@"city"];
        ID=[[[setting sharedSetting].citys objectAtIndex:indexPath.row] objectForKey:@"ID"];
        
        
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:str, @"city",ID,@"ID", [NSNumber numberWithInt:IP],@"IP",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelect" object:dic];
    
    [setting sharedSetting].currentCity=str;
    [setting sharedSetting].currentCityID=ID;
    [setting sharedSetting].morencity=str;
    [setting sharedSetting].morencityID=ID;
    [[setting sharedSetting] saveSetting];
    MFSideMenuContainerViewController * container =[self.navigationController.viewControllers objectAtIndex:1];
    
    [container togleCenterViewController];
    [m_tableview reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCity" object:nil];
//    if([self.delegate respondsToSelector:@selector(citymanageCellSelectionAtIndexPath:)])
//    {
//        [self.delegate citymanageCellSelectionAtIndexPath:returnIP];
//    }
    

}
-(BOOL)tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //打开编辑
    if (_isDW==YES) {
        if (indexPath.section==0) {
            return NO;
        }if (indexPath.section==1) {
            if ([[[[setting sharedSetting].citys objectAtIndex:indexPath.row+1]objectForKey:@"ID"] isEqualToString:[setting sharedSetting].morencityID]) {
                return NO;
            }else{
                return YES;
            }
        }
    }else{
        if ([setting sharedSetting].citys.count>0) {
            if ([[[[setting sharedSetting].citys objectAtIndex:indexPath.row]objectForKey:@"ID"] isEqualToString:[setting sharedSetting].morencityID]) {
                return NO;
            }else{
                return YES;
            }
        }
        
    }

    
    
//    NSDictionary *dic=[setting sharedSetting].citys[indexPath.row];
//    NSString *cityid=[dic objectForKey:@"ID"];
////    if (![setting sharedSetting].dingweicity.length>0) {
//        if ([cityid isEqualToString:[setting sharedSetting].morencityID]) {
//            return NO;
//        }
//    }
//    if ([cityid isEqualToString:[setting sharedSetting].dingweicity]) {
//        return NO;
//    }
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //允许移动
//    if (_isDW==NO) {
//        return YES;
//    }else{
//        if (indexPath.section==0) {
//            return NO;
//        }if (indexPath.section==1) {
//            return YES;
//        }
//        
//    }
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        if (_isDW==YES) {
            if (indexPath.section==0) {
                [[setting sharedSetting].citys removeObjectAtIndex:0];
//                [setting sharedSetting].dingweicity=nil;
                _isDW=NO;
                //        [m_tableview deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
                [m_tableview reloadData];
                
            }else{
                [[setting sharedSetting].citys removeObjectAtIndex:indexPath.row+1];
                [m_tableview deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
                
            }
        }else{
            NSDictionary *dic=[setting sharedSetting].citys[indexPath.row];
            NSString *cityid=[dic objectForKey:@"ID"];
            if ([cityid isEqualToString:[setting sharedSetting].morencityID]) {
                UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"默认城市无法删除" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [al show];
                return;
            }else{
            [[setting sharedSetting].citys removeObjectAtIndex:indexPath.row];  //删除数组里的数据
            [m_tableview deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
            }
        }
        [[setting sharedSetting] saveSetting];
        
        //        [m_tableview deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
        
        
        //        [self viewWillAppear:YES];
        //添加按钮的高度
        float height=[[setting sharedSetting].citys count]*50;
//        if (_isDW==NO) {
//            height=([[setting sharedSetting].citys count]+1)*50;
//        }
         if (_isClick==NO) {
            m_tableview.frame=CGRectMake(0, 60, Width-5, height+72);
        
             self.addBtn.frame=CGRectMake(5, height+105,Width-10 , 40);
         }else{
             m_tableview.frame=CGRectMake(0, 60, kScreenWidth, height+72);
             self.addBtn.frame=CGRectMake(5, height+105,kScreenWidth-10 , 40);
         }
    }
    
    NSString *city=[setting sharedSetting].morencity;
    NSString *ID=[setting sharedSetting].morencityID;
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:city, @"city",ID,@"ID", nil];
    if (![[setting sharedSetting].citys containsObject:dic]) {
        [setting sharedSetting].morencity=nil;
        [setting sharedSetting].morencityID=nil;
        if ([setting sharedSetting].citys.count>0) {
            [setting sharedSetting].currentCity=[[[setting sharedSetting].citys objectAtIndex:0]objectForKey:@"city"];
            [setting sharedSetting].currentCityID=[[[setting sharedSetting].citys objectAtIndex:0]objectForKey:@"ID"];
        }
    }else{
        [setting sharedSetting].currentCity=city;
        [setting sharedSetting].currentCityID=ID;
    }
    //是否删除了默认城市
    
    
    [[setting sharedSetting] saveSetting];
    if ([[setting sharedSetting].citys count]>8) {
        self.addBtn.hidden=YES;
    }else{
        self.addBtn.hidden=NO;
    }
//    if([self.delegate respondsToSelector:@selector(cityManageCellDeleteRowAtIndexPath:)])
//    {
//        [self.delegate cityManageCellDeleteRowAtIndexPath:indexPath];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCity" object:nil];
    //    [m_tableview reloadData];

}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
//           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleNone;
//    //打开编辑模式后，默认情况下每行左边会出现红的删除按钮，这个方法就是关闭这些按钮的
//}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSUInteger fromRow = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];
    
    id object = [[setting sharedSetting].citys  objectAtIndex:fromRow];
    [[setting sharedSetting].citys  removeObjectAtIndex:fromRow];
    [[setting sharedSetting].citys  insertObject:object atIndex:toRow];
    [[setting sharedSetting] saveSetting];
    
    [self viewWillAppear:YES];
    [m_tableview reloadData];
    
    if([self.delegate respondsToSelector:@selector(cityManageCellMoveRowAtIndexPath:toIndexPath:)])
    {
        [self.delegate cityManageCellMoveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}
-(void)myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [m_tableview setEditing:YES animated:YES];
        
//        NSLog(@"UIGestureRecognizerStateBegan");
//        CGPoint ponit=[gestureRecognizer locationInView:m_tableview];
//        NSLog(@" CGPoint ponit=%f %f",ponit.x,ponit.y);
//        NSIndexPath* path=[m_tableview indexPathForRowAtPoint:ponit];
//        NSLog(@"row:%d",path.row);
//        int currRow=path.row;
        
        
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        //未用
        //[m_tableview reloadData];
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        //未用
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [m_tableview resignFirstResponder];
    [m_tableview setEditing:NO animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dwblock:(NSNotification *)ob{
    NSString *str=ob.object;
    if ([str isEqualToString:@"0"]) {
        _isDW=NO;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"dwswitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        _isDW=YES;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"dwswitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [m_tableview reloadData];
}
-(void)switchAction:(UISwitch *)sender{
    if (sender.on==YES) {//打开定位
        if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            NSString *showmessage=@"您的定位服务未启用，如需开启，请设置手机中“设置->定位服务”";
            if (iPhone5) {
                showmessage=@"您的定位服务未启用，如需开启，请设置手机中“设置->隐私->定位服务”";
            }
            UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"知天气" message:showmessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            t_alertView.tag=10;
            [t_alertView show];
            sender.on=NO;
            return;
        }
        sender.on=NO;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"dwswitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"againdw" object:nil];
//        _isDW=YES;
       
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"dwswitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        [setting sharedSetting].dingweicity=nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"upswitch" object:nil];
        _isDW=NO;
        [m_tableview reloadData];
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
-(void)loadingWeather
{
    float height=([[setting sharedSetting].citys count])*50;
    if (_isClick==NO) {
        m_tableview.frame=CGRectMake(0, 60, Width-5, height+72);
        self.editBtn.frame=CGRectMake(Width-60, 27, 50, 31);
        self.addBtn.frame=CGRectMake(5, height+105,Width-10 , 40);
    }else{
        m_tableview.frame=CGRectMake(0, 60, kScreenWidth, height+72);
        self.addBtn.frame=CGRectMake(5, height+105,kScreenWidth-10 , 40);
        self.editBtn.frame=CGRectMake(kScreenWidth-60, 27, 50, 31);
    }
    if([setting sharedSetting].citys.count)
    {
        NSString * urlStr = URL_SERVER;
        NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
        NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
        [h setObject:[setting sharedSetting].app forKey:@"p"];
        
        for(int i=0;i<[setting sharedSetting].citys.count;i++)
        {
            NSMutableDictionary * sstq = [[NSMutableDictionary alloc] init];
            NSDictionary * currentCityInfo = [[setting sharedSetting].citys objectAtIndex:i];
            NSString * currentID = [currentCityInfo objectForKey:@"ID"];
            [sstq setObject:currentID forKey:@"county_id"];
            [b setObject:sstq forKey:[NSString stringWithFormat:@"gz_weekwt_s_y#%@",currentID]];
        }
        
        
        NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
        [param setObject:h forKey:@"h"];
        [param setObject:b forKey:@"b"];
//        NSLog(@"%@",param);
         [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
//            NSLog(@"#%@#",returnData);
            NSDictionary * b = [returnData objectForKey:@"b"];
            for(int i=0;i<[setting sharedSetting].citys.count;i++)
            {
                NSDictionary * cityInfo = [[setting sharedSetting].citys objectAtIndex:i];
                NSString * cityID = [cityInfo objectForKey:@"ID"];
                NSString * newKey = [NSString stringWithFormat:@"gz_weekwt_s_y#%@",cityID];
                NSDictionary * sstqForCityInfo = [b objectForKey:newKey];
                NSArray * weekinfos = [sstqForCityInfo objectForKey:@"weekwt_list"];
                if (weekinfos.count>0) {
                    [self.weatherInfoDic setObject:weekinfos[1] forKey:cityID];
                }
            }
            [m_tableview reloadData];

        } withFailure:^(NSError *error) {
             NSLog(@"failure");
        } withCache:YES];
    }

}
-(void)recogedCity{
    
    
    self.locationManager.delegate=nil;
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
      
            NSLog(@"reGeocode:%@", regeocode);
            NSString *country = regeocode.formattedAddress;
            if (regeocode.city.length>0) {
                if ([country rangeOfString:regeocode.city].location!=NSNotFound) {
                    NSArray *timeArray1=[country componentsSeparatedByString:regeocode.city];
                    country=[timeArray1 objectAtIndex:1];
                }
            }
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:country,@"address",[NSString stringWithFormat:@"%f",location.coordinate.latitude],@"lat",[NSString stringWithFormat:@"%f",location.coordinate.longitude],@"log",regeocode.province,@"provice", nil];
            [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"loctioninfo"];
            [[NSUserDefaults standardUserDefaults]synchronize];
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
            self.swdwcity=t_city;
            [self readXML];
            if (self.swdwid.length>0) {
                NSDictionary *bfdic=[[NSUserDefaults standardUserDefaults]objectForKey:@"beforedw"];
                if (bfdic) {
                    if ([[setting sharedSetting].citys containsObject:bfdic]) {
                        [[setting sharedSetting].citys removeObject:bfdic];
                    }
                }
                
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:self.swdwcity,@"city",self.swdwid,@"ID", nil];
                
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
                
                [setting sharedSetting].dingweicity=self.swdwid;
                BOOL isdw=![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
                if (isdw==YES) {
                    if (street.length>0) {
                        [setting sharedSetting].dwstreet=street;
                    }else{
                        [setting sharedSetting].dwstreet=regeocode.township;
                    }
                    [setting sharedSetting].currentCityID = self.swdwid;
                    [setting sharedSetting].currentCity = self.swdwcity;
                    [setting sharedSetting].morencity=self.swdwcity;
                    [setting sharedSetting].morencityID=self.swdwid;
                }else{
                    [setting sharedSetting].dwstreet=nil;
                }
                [[setting sharedSetting] saveSetting];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCity" object:nil];
                [self loadingWeather];
            }
            
        }
    }];
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
            if ([self.swdwcity isEqualToString:t_name])
            {
                //----------------------------------------------------
                t_node_child = [t_node.children objectAtIndex:5];
                TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
                NSString *Id = t_node_child1.leafvalue;
                [[NSUserDefaults standardUserDefaults]setObject:Id forKey:@"DWid"];
                self.swdwid=Id;
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
        if ([city isEqualToString:t_name])
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
