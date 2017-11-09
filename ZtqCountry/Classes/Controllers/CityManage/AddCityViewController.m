//
//  AddCityViewController.m
//  ZtqCountry
//
//  Created by 林炳阳	 on 14-6-26.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "AddCityViewController.h"
#import "CityManageViewController.h"
#import "SettingViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "UILabel+utils.h"
@interface AddCityViewController ()

@property (strong, nonatomic) UIButton * locationBut;
@property(strong,nonatomic)UIScrollView *bgscr;
@end

@implementation AddCityViewController

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
    // Do any additional setup after loading the view.
   
	

    
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    self.barHeight=place+44;
    
    self.navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    self.navigationBarBg.userInteractionEnabled = YES;
    self.navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
//    self.navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1];
    [self.view addSubview:self.navigationBarBg];
    
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [_navigationBarBg addSubview:leftimg];
    
   
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
//    [leftBut setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
//    [leftBut setImage:[UIImage imageNamed:@"cssz返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:leftBut];
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, self.view.width-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"选择城市";
    [self.navigationBarBg addSubview:titleLab];
    
    self.view.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
    
    self.bgscr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht)];
    self.bgscr.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht+150);
    if (iPhone4) {
        self.bgscr.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht+250);
    }
    self.bgscr.showsHorizontalScrollIndicator=NO;
    self.bgscr.showsVerticalScrollIndicator=NO;
    self.bgscr.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.bgscr];
    
    hot_city=[[NSMutableArray alloc]init];
    
    
    UIImageView *searchimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 40)];
    searchimg.image=[UIImage imageNamed:@"搜索框"];
    searchimg.userInteractionEnabled=YES;
    [self.bgscr addSubview:searchimg];
    UISearchBar *t_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 40)];
	t_searchBar.placeholder =[NSString stringWithFormat:@"当前城市:%@",[self readXMLwith:[setting sharedSetting].currentCityID]];
	[ShareFun cleanBackground:t_searchBar];
//    if (kSystemVersionMore7) {
//        t_searchBar.layer.borderColor=[[UIColor grayColor]CGColor];
//        t_searchBar.layer.borderWidth=1;
//    }
    
	t_searchBar.delegate = self;
    [searchimg addSubview:t_searchBar];
    
    UILabel *t_label=[[UILabel alloc]initWithFrame:CGRectMake(15, 50, 100, 50)];
    t_label.textColor=[UIColor blackColor];
    t_label.backgroundColor=[UIColor clearColor];
    [t_label setFont:[UIFont systemFontOfSize:15]];
    [t_label setText:@"热门城市"];
    [self.bgscr addSubview:t_label];

    m_provinceData=[[NSMutableArray alloc]init];
    mid=[[NSMutableArray alloc]init];
    [self getgz_hot_city];

    self.DWcity=[setting sharedSetting].dingweicity;
    [self readXML];
    //    self.DWid=[[NSUserDefaults standardUserDefaults]objectForKey:@"DWid"];
    NSLog(@"%@",self.DWid);
//    if (self.DWcity&&self.DWid) {
//        [m_provinceData replaceObjectAtIndex:0 withObject:self.DWcity];
//        [mid replaceObjectAtIndex:0 withObject:self.DWid];
//    }
    [self CreatBtn];
    
 
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
-(void)dwcity{


}
-(void)getgz_hot_city{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
//    [gz_todaywt_inde setObject:@"1"forKey:@"type"];
    [b setObject:gz_todaywt_inde forKey:@"gz_hot_city"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (b!=nil) {
            NSDictionary *gz_hot_city=[b objectForKey:@"gz_hot_city"];
            NSArray *citylist=[gz_hot_city objectForKey:@"hot_city_list"];
            for (int i=0; i<citylist.count; i++) {
                NSString *cityname=[citylist[i] objectForKey:@"city_name"];
                NSString *cityid=[citylist[i] objectForKey:@"city_id"];
                [m_provinceData addObject:cityname];
                [mid addObject:cityid];
            }
        }
        [self CreatBtn];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = NO;
}
-(void)CreatBtn{
    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 90, kScreenWidth, kScreenHeitht)];
    bgimg.backgroundColor=[UIColor whiteColor];
    bgimg.userInteractionEnabled=YES;
    [self.bgscr addSubview:bgimg];
    if (iPhone4) {
        bgimg.frame=CGRectMake(0, 90, kScreenWidth, kScreenHeitht+50);
    }
    for (int row=0; row<([m_provinceData count]+2)/3; row++) {
        for (int i = 0; i < [m_provinceData count]; i ++) {
            int t_row = i / 3;
            if (t_row==row) {
                
                UIButton *t_btn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                NSString *city=[m_provinceData objectAtIndex:i];
                NSString *ID=[mid objectAtIndex:i];
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:city, @"city",ID,@"ID", nil];
                [hot_city addObject:dic];
                if (i==0&&row==0) {
                    self.locationBut = t_btn;
                }

                int x = 0+(i%3)*kScreenWidth/3;
                t_btn.frame = CGRectMake(x, 40*row, kScreenWidth/3, 50);
                    t_btn.tag=i;
            
                

               
                    if ([[mid objectAtIndex:i]isEqualToString:[setting sharedSetting].dingweicity]) {
                        UIImageView *addimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 13, 15, 22)];
                        [addimg setImage:[UIImage imageNamed:@"城市定位.png"]];
                        [t_btn addSubview:addimg];
                    }
                    else{
                    if ([[m_provinceData objectAtIndex:i]isEqualToString:[setting sharedSetting].morencity]) {
                        float w=[t_btn.titleLabel labelLength:city withFont:[UIFont systemFontOfSize:16.5]];
                        NSString *str=[m_provinceData objectAtIndex:i];
                        UIImageView *addimg=[[UIImageView alloc]initWithFrame:CGRectMake(w/2, 14, 18, 18)];
                        [addimg setImage:[UIImage imageNamed:@"选择城市部分默认图标.png"]];
                        [t_btn addSubview:addimg];
                        addimg.center=CGPointMake(t_btn.width/2-w, t_btn.height/2);
                        if (str.length>3) {
                             addimg.center=CGPointMake(t_btn.width/2-w+15, t_btn.height/2);
                        }
                        
                    }
                    else if ([[setting sharedSetting].citys containsObject:[hot_city objectAtIndex:i]]){
                        float w=[t_btn.titleLabel labelLength:city withFont:[UIFont systemFontOfSize:16.5]];
                        UIImageView *addimg=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth/3-45)/2, 45, w+5, 2)];
                        [addimg setImage:[UIImage imageNamed:@"下标注.png"]];
                        [t_btn addSubview:addimg];
                        addimg.center=CGPointMake(t_btn.width/2, 45);
                    
                    }
                }
                
                
                [t_btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
              
                

                [t_btn setTitle:city forState:UIControlStateNormal];
                    [t_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                t_btn.titleLabel.font=[UIFont systemFontOfSize:16.5];
                    [t_btn setBackgroundColor:[UIColor clearColor]];
                    [bgimg addSubview:t_btn];
                    
                
                
//                    if (i%3==0) {
//                        x = 12+(i%3)*100;
//                    }else if (i%3 == 1) {
//                        x = 20+(i%3)*100;
//                    }else if (i%3 == 2) {
//                        x = 28+(i%3)*100;
//                   	}
            }
        }
        
        self.bgscr.contentSize=CGSizeMake(kScreenWidth, 200+(m_provinceData.count+2)/3*40);
    }
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SelectCityViewController *select=[[SelectCityViewController alloc]init];
    [select setDataSource: m_treeNodeProvince withCitys:m_treeNodeAllCity];
    [select setDelegate:self];
    [self.navigationController pushViewController:select animated:YES];
    return NO;
}

-(void)buttonclick:(id)sender{
    NSUInteger tag = [sender tag];
    //    for (int i=0; i<[[setting sharedSetting].citys  count]; i++) {
    //        self.morencity = [[[setting sharedSetting].citys objectAtIndex:i]objectForKey:@"city"];
    //
    //        if ([[m_provinceData objectAtIndex:tag] isEqualToString:self.morencity])
    //        {
    //            [ShareFun alertNotice:@"知天气" withMSG:@"该城市已经添加！" cancleButtonTitle:@"确定" otherButtonTitle:nil];
    //            return;
    //        }
    //    }
    
    
    if([[mid objectAtIndex:tag]isEqualToString:[setting sharedSetting].dingweicity])
    {
        
            NSString *city=[m_provinceData objectAtIndex:tag];
            NSString *ID=[mid objectAtIndex:tag];
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:city, @"city",ID,@"ID", nil];
            [setting sharedSetting].currentCityID = ID;
            [setting sharedSetting].currentCity = city;
            [setting sharedSetting].morencity=city;
            [setting sharedSetting].morencityID=ID;
//            if (![[setting sharedSetting].citys containsObject:dic]) {
//                if ([setting sharedSetting].citys.count==0) {
//                    [[setting sharedSetting].citys addObject:dic];
//                    [[setting sharedSetting] saveSetting];
//                }else{
//                    [[setting sharedSetting].citys insertObject:dic atIndex:0 ];
//                    [[setting sharedSetting] saveSetting];
//                }
//                //定位城市 放在第一个
//            }
        if (![[setting sharedSetting].citys containsObject:dic]) {
            
            [[setting sharedSetting].citys addObject:dic];
            //            NSLog(@"lalalala:%d",[setting sharedSetting].citys.count);
            [[setting sharedSetting] saveSetting];
        }

            if([self.delegate respondsToSelector:@selector(addCityWithSign:)])
            {
                [self.delegate addCityWithSign:0];
            }
//            if (![[setting sharedSetting].citys containsObject:dic]) {
//                
//                [[setting sharedSetting].citys addObject:dic];
//                [[setting sharedSetting] saveSetting];
//            }
            MFSideMenuContainerViewController * container =[self.navigationController.viewControllers objectAtIndex:1];
            [container togleCenterViewController];
            [self.navigationController popToViewController:container animated:NO];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCity" object:nil];
        
        
    }else{
        
        
        NSString *city=[m_provinceData objectAtIndex:tag];
        NSString *ID=[mid objectAtIndex:tag];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:city, @"city",ID,@"ID", nil];
        
        [setting sharedSetting].currentCityID = ID;
        [setting sharedSetting].currentCity = city;
        [setting sharedSetting].morencity=city;
        [setting sharedSetting].morencityID=ID;
//        if(![ID isEqualToString:[setting sharedSetting].dingweicity])
//        {
//            [setting sharedSetting].dingweicity=nil;
//        }
        [[setting sharedSetting] saveSetting];
        if([self.delegate respondsToSelector:@selector(addCityWithSign:)])
        {
            //如果是定位城市的 sign=0；其他1
            [self.delegate addCityWithSign:1];
        }
        
        MFSideMenuContainerViewController * container =[self.navigationController.viewControllers objectAtIndex:1];
        [container togleCenterViewController];
        [self.navigationController popToViewController:container animated:NO];
        
        if (![[setting sharedSetting].citys containsObject:dic]) {
            
            [[setting sharedSetting].citys addObject:dic];
//            NSLog(@"lalalala:%d",[setting sharedSetting].citys.count);
            [[setting sharedSetting] saveSetting];
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCity" object:nil];
        
    }
}
- (void)leftBtn:(id)sender
{
   // NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"Selectcity"];
    [self.navigationController popViewControllerAnimated:YES];
//    [MBProgressHUD hideHUDForView:[[ShareFun shareAppDelegate] window] animated:NO];
//    if ([[setting sharedSetting].citys count]==0) {
//        UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"嗨，你还未设置城市，是否退出知天气" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
//        t_alertView.tag=101;
//		[t_alertView show];
//    }else{
//    [self.navigationController popViewControllerAnimated:YES];
////    MFSideMenuContainerViewController * container =[self.navigationController.viewControllers objectAtIndex:1];
////    [container togleCenterViewController];
////        [self.navigationController popToViewController:container animated:NO];
//    }
}
//定位城市id
-(void)readXML{
    m_allCity=m_treeNodeAllCity;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        t_node_child = [t_node.children objectAtIndex:2];
        NSString *t_name = t_node_child.leafvalue;
        if ([self.DWcity isEqualToString:t_name])
        {
            //----------------------------------------------------
            t_node_child = [t_node.children objectAtIndex:5];
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
            NSString *Id = t_node_child1.leafvalue;
            [[NSUserDefaults standardUserDefaults]setObject:Id forKey:@"DWid"];
            self.DWid=Id;
        }
    }
    
    
}
//开始定位城市
//开始定位城市
- (void) startLocation
{
	if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
	{
        [m_locationManager stopUpdatingLocation];
        
        NSString *showmessage=@"您的定位服务未启用，如需开启，请设置手机中“设置->定位服务”";
        if (iPhone5) {
            showmessage=@"您的定位服务未启用，如需开启，请设置手机中“设置->隐私->定位服务”";
        }
        //	[ShareFun alertNotice:@"知天气" withMSG:showmessage cancleButtonTitle:@"确定" otherButtonTitle:nil];
        UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"知天气" message:showmessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
		[t_alertView show];
        //		[t_alertView release];
        
	}
	else
	{
		hasLocated = NO;
		m_locationManager = [[CLLocationManager alloc] init];
		m_locationManager.delegate = self;
        if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0))
        {
            //设置定位权限，仅ios8有意义
            [m_locationManager requestAlwaysAuthorization];
        }
        

		//        NSLog(@"PURPOSE = %@",m_locationManager.purpose);
		//选择定位的方式为最优的状态，他又四种方式在文档中能查到
		m_locationManager.desiredAccuracy=kCLLocationAccuracyBest;
		//发生事件的最小距离间隔
		m_locationManager.distanceFilter = 1000.0f;
		[m_locationManager startUpdatingLocation];
		
//    [MBProgressHUD showHUDAddedTo:[[ShareFun shareAppDelegate] window] animated:NO];
	}
}

- (void) startLocationfirst
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"myone"];
   
	if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
	{
        [m_locationManager stopUpdatingLocation];
        
        NSString *showmessage=@"您的定位服务未启用，如需开启，请设置手机中“设置->定位服务”";
        if (iPhone5) {
            showmessage=@"您的定位服务未启用，如需开启，请设置手机中“设置->隐私->定位服务”";
        }
        UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"知天气" message:showmessage delegate:self cancelButtonTitle:@"不再提示" otherButtonTitles:@"确定",nil];
        t_alertView.tag=10;
		[t_alertView show];
      
        
	}
	else
	{
        NSLog(@"第一次定位");
		hasLocated = NO;
		m_locationManager = [[CLLocationManager alloc] init];
		m_locationManager.delegate = self;
        if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0))
        {
            //设置定位权限，仅ios8有意义
            [m_locationManager requestAlwaysAuthorization];
        }
        

		//        NSLog(@"PURPOSE = %@",m_locationManager.purpose);
		//选择定位的方式为最优的状态，他又四种方式在文档中能查到
		m_locationManager.desiredAccuracy=kCLLocationAccuracyBest;
		//发生事件的最小距离间隔
		m_locationManager.distanceFilter = 1000.0f;
		[m_locationManager startUpdatingLocation];
//		[MBProgressHUD showHUDAddedTo:[[ShareFun shareAppDelegate] window] animated:NO];
		
	}
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

#pragma mark alertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10) {
        if (buttonIndex==0) {
            NSLog(@"不再提示自动定位");
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"fabucity"];
        }
    }if (alertView.tag==101) {
        if (buttonIndex==1) {
            exit(0);
        }
    }
}
#pragma mark CLLocationManager delegate
//定位成功调用
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	if (hasLocated)
		return;
	
	if (fabs([newLocation.timestamp timeIntervalSinceNow]) > 30.0f) {
        //若果是过期数据，忽略
		return;
	}
	
	[manager stopUpdatingLocation];
	hasLocated = YES;
	NSLog(@"定位成功！");
	CLLocationCoordinate2D loc = [newLocation coordinate];
	
    //	NSLog(@"%f",loc.latitude);
    //	NSLog(@"%f",loc.longitude);
	
	MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc]initWithCoordinate:newLocation.coordinate];
    geocoder.delegate = self;
	//启动gecoder
    [geocoder start];
}

//定位出错时被调
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	if (hasLocated)
		return;
	
	[manager stopUpdatingLocation];
	hasLocated = YES;
//    [MBProgressHUD hideHUDForView:[[ShareFun shareAppDelegate] window] animated:NO];
    int t_fitst=[[NSUserDefaults standardUserDefaults] integerForKey:@"myone"];
    if (t_fitst==1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"fabucity"];
        return;
    }
    
    
    
    NSLog(@"获取经纬度失败，失败原因：%@", [error description]);
    [ShareFun alertNotice:@"知天气" withMSG:@"操作失败,请检查网络连接！" cancleButtonTitle:@"确定" otherButtonTitle:nil];
    
    
}

//反向地理编码
#pragma mark MKReverseGeocoderDelegate
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
//	[MBProgressHUD hideHUDForView :[[ShareFun shareAppDelegate] window] animated:NO];
	NSLog(@"反向地理编码成功，城市： %@", placemark.locality);
	
	NSString *t_city = [NSString stringWithFormat:@"%@ %@", placemark.locality, @"(当前定位城市)"];
  
	if ([placemark.locality hasSuffix:@"市"])
	{
		NSArray *t_array = [placemark.locality componentsSeparatedByString:@"市"];
		
		if ([t_array count] > 0)
		{
			t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
		}
	}
	
	NSLog(@"哈哈%@", t_city);
//    [[NSUserDefaults standardUserDefaults]setObject:t_city forKey:@"DWcity"];
    [setting sharedSetting].dingweicity=t_city;
    [[setting sharedSetting] saveSetting];
    
    [self.locationBut setTitle:t_city forState:UIControlStateNormal];
    UIImageView *addimg=[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 15, 15)];
    [addimg setImage:[UIImage imageNamed:@"csss2ngs_33"]];
    [self.locationBut addSubview:addimg];
    [self dwcity];
   	//[m_provinceData replaceObjectAtIndex:0 withObject:t_city];
	
}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder
      didFailWithError:(NSError *)error
{
//    [MBProgressHUD hideHUDForView :[[ShareFun shareAppDelegate] window] animated:NO];
    NSLog(@"反向地理编码失败，失败原因 : %@", [error description]);
	[ShareFun alertNotice:@"知天气" withMSG:@"很抱歉，自动定位失败，请重试！" cancleButtonTitle:@"确定" otherButtonTitle:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
