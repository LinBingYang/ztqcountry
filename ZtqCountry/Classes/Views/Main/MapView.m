//
//  MapView.m
//  ZtqCountry
//
//  Created by Admin on 15/7/14.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "MapView.h"

@implementation MapView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnarrs=[[NSMutableArray alloc]init];
        self.backgroundColor=[UIColor clearColor];
        UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        bgimg.image=[UIImage imageNamed:@"首页背景条"];
        bgimg.userInteractionEnabled=YES;
        [self addSubview:bgimg];
        
        UILabel *loclab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
        loclab.text=@"指点天气";
        loclab.textColor=[UIColor whiteColor];
        loclab.font=[UIFont systemFontOfSize:15];
        [bgimg addSubview:loclab];
        UIButton *foot=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-219, 7.5, 70, 25)];
        [foot setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
        [foot setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
        [foot setTitle:@"出行天气" forState:UIControlStateNormal];
        [foot setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
        foot.titleLabel.font=[UIFont systemFontOfSize:15];
        [foot addTarget:self action:@selector(footAction) forControlEvents:UIControlEventTouchUpInside];
        [bgimg addSubview:foot];
        UIButton *travelbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-147, 7.5, 70, 25)];
        [travelbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
        [travelbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
        [travelbtn setTitle:@"旅游气象" forState:UIControlStateNormal];
        [travelbtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
        travelbtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [travelbtn addTarget:self action:@selector(travelAction) forControlEvents:UIControlEventTouchUpInside];
        [bgimg addSubview:travelbtn];
        UIButton *tybtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-75, 7.5, 70, 25)];
        [tybtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
        [tybtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
        [tybtn setTitle:@"台风路径" forState:UIControlStateNormal];
        [tybtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
        tybtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [tybtn addTarget:self action:@selector(tyAction) forControlEvents:UIControlEventTouchUpInside];
        [bgimg addSubview:tybtn];

        
        UIImageView *locimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 25, 25)];
        locimg.image=[UIImage imageNamed:@"定位.png"];
        [self addSubview:locimg];
        self.loctalab=[[UILabel alloc]initWithFrame:CGRectMake(38, 38, kScreenWidth-38, 40)];
        self.loctalab.textAlignment=NSTextAlignmentLeft;
            self.loctalab.text=@"定位中";
        self.loctalab.numberOfLines=0;
        self.loctalab.textColor=[UIColor whiteColor];
        self.loctalab.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.loctalab];
        UIImageView *aixin=[[UIImageView alloc]initWithFrame:CGRectMake(10, 75,23, 25)];
        aixin.image=[UIImage imageNamed:@"爱心.png"];
        [self addSubview:aixin];
        self.wxlab=[[UILabel alloc]initWithFrame:CGRectMake(38, 68, kScreenWidth-50, 40)];
        self.wxlab.textAlignment=NSTextAlignmentLeft;
        self.wxlab.text=@"查看出行天气，掌握天气动态~";
        self.wxlab.textColor=[UIColor yellowColor];
        self.wxlab.font=[UIFont systemFontOfSize:13];
        self.wxlab.numberOfLines=0;
        [self addSubview:self.wxlab];
        
//        locationManager = [[CLLocationManager alloc] init];
//        locationManager.distanceFilter = 5.0f;
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        locationManager.delegate = self;
//        if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0))
//        {
//            //设置定位权限，仅ios8有意义
//            [locationManager requestAlwaysAuthorization];
//        }
//        [locationManager startUpdatingLocation];
//        self.locationManager = [[AMapLocationManager alloc] init];
//        self.locationManager.delegate = self;
//        self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
//        [self.locationManager startUpdatingLocation];
        
        m_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 110, kScreenWidth, 180)];
        m_mapView.userInteractionEnabled=YES;
        //是否可滑动
        m_mapView.scrollEnabled = YES;
        //是否可放大缩小
        m_mapView.zoomEnabled = YES;
        m_mapView.delegate = self;
        [self addSubview:m_mapView];
        
        if (isopendw==YES) {
            NSDictionary *dic=[[NSUserDefaults standardUserDefaults]objectForKey:@"loctioninfo"];
            self.lat =[dic objectForKey:@"lat"];
            
            self.log = [dic objectForKey:@"log"];
            self.provice=[dic objectForKey:@"provice"];
            self.DWid=[dic objectForKey:@"locationid"];
            CLLocation *loc=[[CLLocation alloc]initWithLatitude:self.lat.floatValue longitude:self.log.floatValue];
            self.mypoint=nil;
            self.mypoint = [[MyPoint alloc] initWithCoordinate:loc.coordinate andTitle:@"当前位置"];
            //添加标注
            [m_mapView addAnnotation:self.mypoint];
            
            
            //根据经纬度范围显示
            m_mapView.region = MKCoordinateRegionMake(loc.coordinate, MKCoordinateSpanMake(0.0045f, 0.0045f));
            //    //放大地图到自身的经纬度位置。
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, 3000, 3000);
            [m_mapView setRegion:region animated:YES];
            self.loctalab.text=[dic objectForKey:@"address"];
            if (self.provice.length>0) {
                [self loadmapweather_tip];
                [self Getyjxx_grad_indexData];
            }
        }
        
        
        UIButton *mapbut1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
        [mapbut1 addTarget:self action:@selector(footAction) forControlEvents:UIControlEventTouchUpInside];
        [m_mapView addSubview:mapbut1];
        UIButton *morebtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-40, 10, 31, 29)];
        [morebtn setBackgroundImage:[UIImage imageNamed:@"指点天气图标点击常态"] forState:UIControlStateNormal];
        [morebtn setBackgroundImage:[UIImage imageNamed:@"指点天气图标点击二态"] forState:UIControlStateHighlighted];
        [morebtn addTarget:self action:@selector(footAction) forControlEvents:UIControlEventTouchUpInside];
        [m_mapView addSubview:morebtn];
        
        UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 110+180+9, kScreenWidth, 1)];
        line1.image=[UIImage imageNamed:@"分割线.png"];
//        [self addSubview:line1];
        _search = [[AMapSearchAPI alloc] initWithSearchKey:@"7dd7294f1eb47ff26db3ec800af22024" Delegate:self];
    }
    return self;
}
- (void)startLocation
{
    
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [self.locationManager stopUpdatingLocation];
 
    }
    else
    {
        
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        [self.locationManager startUpdatingLocation];
        
        
    }
}
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    self.loctalab.text=@"定位中";
    [self.locationManager stopUpdatingLocation];
}
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    
    self.lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    
    self.log = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    
    self.mypoint=nil;
    self.mypoint = [[MyPoint alloc] initWithCoordinate:location.coordinate andTitle:@"当前位置"];
    //添加标注
    [m_mapView addAnnotation:self.mypoint];
    
    
    //根据经纬度范围显示
    m_mapView.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.0045f, 0.0045f));
    //    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 3000, 3000);
    [m_mapView setRegion:region animated:YES];
    
    self.locationManager.delegate=nil;
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
//        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
//            NSLog(@"reGeocode:%@", regeocode);
            NSString *country = regeocode.formattedAddress;
            
            self.provice=regeocode.province;
            if (regeocode.city.length>0) {
                if ([country rangeOfString:regeocode.city].location!=NSNotFound) {
                    NSArray *timeArray1=[country componentsSeparatedByString:regeocode.city];
                    country=[timeArray1 objectAtIndex:1];
                }
                self.loctalab.text=country;
                if (self.provice.length>0) {
                    [self loadmapweather_tip];
                }
            }
            
            
            
            
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
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //如果是自己的位置的大头针,这个大头针将不重用
        return nil;
    }
    //重用标志符
    static NSString *reUse = @"reUse";
    //根据重用对鞋去查找重用的大头针
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reUse];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reUse];
    }
    //设置让注解视图显示的Model 内容
    annotationView.annotation = annotation;
    [self.bg removeFromSuperview];
    self.bg=nil;
    for (UIView * view in [annotationView subviews])
        
    {
        
        [view removeFromSuperview];
        
    }
    
    annotationView.image=nil;
    [self.imageview removeFromSuperview];
    self.imageview.image=nil;
    
    if (self.bg==nil) {
        self.bg=[[UIImageView alloc]initWithFrame:CGRectMake(annotationView.frame.size.width+10, annotationView.frame.size.width-50, 50, 50)];
//        self.bg.image=[UIImage imageNamed:@"温度蓝底"];
        self.bg.userInteractionEnabled=YES;
        [annotationView addSubview:self.bg];
        self.ctlab=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 50, 30)];
        self.ctlab.textColor=[UIColor whiteColor];
        self.ctlab.textAlignment=NSTextAlignmentCenter;
        self.ctlab.font=[UIFont systemFontOfSize:14];
        [self.bg addSubview:self.ctlab];
        annotationView.centerOffset = CGPointMake(5,5);
        
        
        UIImage *image = [UIImage imageNamed:@"指点天气.png"];
        
        self.imageview = [[UIImageView alloc] initWithImage:image];
        
        self.imageview.frame = CGRectMake(-16.5, -37, image.size.width, image.size.height);
        [annotationView addSubview: self.imageview];
        //        annotationView.image=[UIImage imageNamed:@"定位符"];
    }
    
    
    return annotationView;
    
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
//        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
//        NSLog(@"ReGeo: %@", result);
        self.provice=response.regeocode.addressComponent.province;
        NSString *country=response.regeocode.formattedAddress;
        if ([country rangeOfString:@"省"].location!=NSNotFound) {
            NSArray *timeArray1=[country componentsSeparatedByString:@"省"];
            country=[timeArray1 objectAtIndex:1];
            }
        self.loctalab.text=country;
        if (self.provice.length>0) {
            [self loadmapweather_tip];
        }
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation * showLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude-0.00330
                                                           longitude:newLocation.coordinate.longitude+0.0049];
    if (kSystemVersionMore9) {
        showLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                                  longitude:newLocation.coordinate.longitude];
    }
//    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
//    regeo.location = [AMapGeoPoint locationWithLatitude:showLocation.coordinate.latitude longitude:showLocation.coordinate.longitude];
//    regeo.radius = 10000;
//    regeo.requireExtension = YES;
//    //发起逆地理编码
//    [_search AMapReGoecodeSearch: regeo];
    [geocoder reverseGeocodeLocation:showLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            [locationManager stopUpdatingLocation];
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *country = placemark.name;
            self.provice=placemark.administrativeArea;
            if ([country rangeOfString:@"省"].location!=NSNotFound) {
                NSArray *timeArray1=[country componentsSeparatedByString:@"省"];
                country=[timeArray1 objectAtIndex:1];
            }
            
            self.loctalab.text=country;
            if (self.provice.length>0) {
                [self loadmapweather_tip];
            }
            
        }
    }];
    
    //    NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    
    self.lat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    
    self.log = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
    self.mypoint=nil;
    self.mypoint = [[MyPoint alloc] initWithCoordinate:showLocation.coordinate andTitle:@"当前位置"];
    //添加标注
    [m_mapView addAnnotation:self.mypoint];
    
    
    //根据经纬度范围显示
    m_mapView.region = MKCoordinateRegionMake(showLocation.coordinate, MKCoordinateSpanMake(0.0045f, 0.0045f));
    //    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(showLocation.coordinate, 3000, 3000);
    [m_mapView setRegion:region animated:YES];
    
    
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    self.loctalab.text=@"定位失败";
    [locationManager stopUpdatingLocation];
}
-(void)loadmapweather_tip{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:self.provice forKey:@"province"];
    [gz_todaywt_inde setObject:self.log forKey:@"longitude"];
    [gz_todaywt_inde setObject:self.lat forKey:@"latitude"];
    [b setObject:gz_todaywt_inde forKey:@"gz_forecast_weather_tip"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_forecast_weather_tip"];
            NSString *value=[gz_air_qua_index objectForKey:@"tip"];
            self.wxlab.text=value;
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
//网格预警
-(void)Getyjxx_grad_indexData{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * yjxx_grad_index = [[NSMutableDictionary alloc] init];
    if (self.provice.length>0) {
        [yjxx_grad_index setObject:self.provice forKey:@"province"];
    }
    if (self.DWid.length>0) {
        [yjxx_grad_index setObject:self.DWid forKey:@"area"];
    }
    [b setObject:yjxx_grad_index forKey:@"gz_yjxx_grad_index"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * yjxx_grad_index = [b objectForKey:@"gz_yjxx_grad_index"];
            NSArray *list=[yjxx_grad_index objectForKey:@"dataList"];
            self.warnlists=list;
            [self CreatWarns:list];
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)CreatWarns:(NSArray *)lists{
    for (UIButton *btn in self.btnarrs) {
        [btn removeFromSuperview];
    }
    [self.btnarrs removeAllObjects];
    for (int i=0; i<lists.count; i++) {
        UIButton *wbtn=[[UIButton alloc]initWithFrame:CGRectMake(5+45*i, 5, 38, 30)];
        NSString *iconame=[lists[i] objectForKey:@"ico"];
        [wbtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",iconame]] forState:UIControlStateNormal];
        wbtn.tag=i;
        [wbtn addTarget:self action:@selector(warnAction:) forControlEvents:UIControlEventTouchUpInside];
        [m_mapView addSubview:wbtn];
        [self.btnarrs addObject:wbtn];
    }
}
-(void)warnAction:(UIButton *)sender{
   
    if([self.delegate respondsToSelector:@selector(MapWarnWithInfos:Withindex:)])
    {
        [self.delegate MapWarnWithInfos:self.warnlists Withindex:sender.tag];
    }
}
-(void)footAction{
    
    if ([self.delegate respondsToSelector:@selector(footWTAction)]) {
        [self.delegate footWTAction];
    }
}
-(void)travelAction{
    if ([self.delegate respondsToSelector:@selector(TravelAction)]) {
        [self.delegate TravelAction];
    }
}
-(void)tyAction{
    if ([self.delegate respondsToSelector:@selector(typhoonAction)]) {
        [self.delegate typhoonAction];
    }
}
-(void)dealloc{
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
    [m_mapView removeAnnotations:m_mapView.annotations];
}
@end
