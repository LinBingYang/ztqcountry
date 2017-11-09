//
//  FootMapView.m
//  ZtqCountry
//
//  Created by Admin on 15/7/1.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "FootMapView.h"
#import "HPweatherAnnotationView.h"
@implementation FootMapView
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.marr=[[NSMutableArray alloc]init];
        self.marks=[[NSMutableArray alloc]init];
        
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        [self.locationManager startUpdatingLocation];
        
        //初始化检索对象
//        _search = [[AMapSearchAPI alloc] init];
//        _search.delegate = self;
        _search = [[AMapSearchAPI alloc] initWithSearchKey:@"7dd7294f1eb47ff26db3ec800af22024" Delegate:self];
       
        
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
        m_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
        //显示用户位置
//        m_mapView.showsUserLocation = YES;
        //  mapShowView.mapType = MKMapTypeHybrid;
        //是否可滑动
        m_mapView.scrollEnabled = YES;
        //是否可放大缩小
        m_mapView.zoomEnabled = YES;
        m_mapView.delegate = self;
        //    [m_mapView setShowsUserLocation:YES];//标注自身位置
        [self addSubview:m_mapView];
        _geocoder=[[CLGeocoder alloc]init];
        UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
        [m_mapView addGestureRecognizer:mTap];
    }
    return self;
}
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
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
    m_mapView.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.01f, 0.01f));
    //    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000);
    [m_mapView setRegion:region animated:YES];
    
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
        
        if (regeocode)
        {
            NSString *country = regeocode.formattedAddress;
            if (regeocode.city.length>0) {
                if ([country rangeOfString:regeocode.city].location!=NSNotFound) {
                    NSArray *timeArray1=[country componentsSeparatedByString:regeocode.city];
                    country=[timeArray1 objectAtIndex:1];
                }
            }
            
            self.titlecity=country;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DWCITY" object:country];
            [self getgz_weather_of_locationWithprovice:regeocode.province Withlat:self.lat Withlon:self.log withcity:country];
        }
    }];
}
- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
//     [m_mapView removeOverlay:self.route.polyline];
//    [m_mapView removeOverlays:m_mapView.overlays];
    [m_mapView removeAnnotations:[m_mapView annotations]];
    [m_mapView removeOverlays:[m_mapView overlays]];
    CGPoint touchPoint = [gestureRecognizer locationInView:m_mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [m_mapView convertPoint:touchPoint toCoordinateFromView:m_mapView];//这里touchMapCoordinate就是该点的经纬度了
    self.lat = [NSString stringWithFormat:@"%f",touchMapCoordinate.latitude];
    
    self.log = [NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
    //    NSLog(@"%f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    //根据经纬度范围显示
    m_mapView.region = MKCoordinateRegionMake(touchMapCoordinate, MKCoordinateSpanMake(0.1f, 0.1f));
    //    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(touchMapCoordinate, 1000, 1000);
    [m_mapView setRegion:region animated:YES];
    
//    [m_mapView removeAnnotations:m_mapView.annotations];
    self.mypoint=nil;
    self.mypoint = [[MyPoint alloc] initWithCoordinate:touchMapCoordinate andTitle:@"当前位置"];
    //添加标注
    [m_mapView addAnnotation:self.mypoint];
    
    //    [m_mapView reloadInputViews];
    
    CLLocation *newLocation=[[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    if (kSystemVersionMore9) {
//        newLocation=[[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude+0.00330 longitude:touchMapCoordinate.longitude-0.0049];
//    }
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeo];
    
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error) {
//        if (array.count > 0) {
//            
//            CLPlacemark *placemark = [array objectAtIndex:0];
//            NSString *country = placemark.name;
//            if ([country rangeOfString:@"省"].location!=NSNotFound) {
//                NSArray *timeArray1=[country componentsSeparatedByString:@"省"];
//                country=[timeArray1 objectAtIndex:1];
//            }
//            self.titlecity=country;
//          [self getgz_weather_of_locationWithprovice:placemark.administrativeArea Withlat:self.lat Withlon:self.log withcity:country];
//            
//        }}];
    
    
    
    
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
//        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
//        NSLog(@"ReGeo: %@", result);
        NSString *country = response.regeocode.formattedAddress;
        if ([country rangeOfString:response.regeocode.addressComponent.province].location!=NSNotFound) {
            NSArray *timeArray1=[country componentsSeparatedByString:response.regeocode.addressComponent.province];
            country=[timeArray1 objectAtIndex:1];
        }
        self.titlecity=country;
        [self getgz_weather_of_locationWithprovice:response.regeocode.addressComponent.province Withlat:self.lat Withlon:self.log withcity:country];
    }
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
    //    NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    CLLocation * showLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude-0.00330
                                                           longitude:newLocation.coordinate.longitude+0.0049];
    self.lat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    
    self.log = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
    self.mypoint=nil;
    self.mypoint = [[MyPoint alloc] initWithCoordinate:showLocation.coordinate andTitle:@"当前位置"];
    //添加标注
    [m_mapView addAnnotation:self.mypoint];
    
    //根据经纬度范围显示
    m_mapView.region = MKCoordinateRegionMake(showLocation.coordinate, MKCoordinateSpanMake(0.01f, 0.01f));
    //    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(showLocation.coordinate, 1000, 1000);
    [m_mapView setRegion:region animated:YES];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    if (kSystemVersionMore9) {
        showLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                                  longitude:newLocation.coordinate.longitude];
    }
    [geocoder reverseGeocodeLocation:showLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *country = placemark.name;
            if ([country rangeOfString:@"省"].location!=NSNotFound) {
                NSArray *timeArray1=[country componentsSeparatedByString:@"省"];
                country=[timeArray1 objectAtIndex:1];
            }
            self.titlecity=country;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DWCITY" object:country];
            [self getgz_weather_of_locationWithprovice:placemark.administrativeArea Withlat:self.lat Withlon:self.log withcity:country];
            NSLog(@"%@",placemark.administrativeArea);
            
        }
    }];
    
    
    [locationManager stopUpdatingLocation];
    
}
-(void)startaddress:(NSString *)startcity Withendaddress:(NSString *)endcity withstratcoor:(CLLocationCoordinate2D)startcoor withendcoor:(CLLocationCoordinate2D)endcoor{
    if (startcity.length>0&&!endcity.length>0) {
       
            startCoordinate=startcoor;
            
            
            [m_mapView removeAnnotations:[m_mapView annotations]];
            [m_mapView removeOverlays:[m_mapView overlays]];
            self.mypoint = [[MyPoint alloc] initWithCoordinate:startCoordinate andTitle:@"当前位置"];
            //添加标注
            [m_mapView addAnnotation:self.mypoint];
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(startCoordinate, 1000, 1000);
            [m_mapView setRegion:region animated:YES];
            
           
            [self getprovice:startCoordinate withType:@"1"];
     
    }
    if (!startcity.length>0&&endcity.length>0) {
       
            endCoordinate=endcoor;
            [m_mapView removeAnnotations:[m_mapView annotations]];
            [m_mapView removeOverlays:[m_mapView overlays]];
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(endCoordinate, 1000, 1000);
            [m_mapView setRegion:region animated:YES];
            self.mypoint=nil;
            self.mypoint = [[MyPoint alloc] initWithCoordinate:endCoordinate andTitle:@"当前位置"];
            //添加标注
            [m_mapView addAnnotation:self.mypoint];
            [self getprovice:endCoordinate withType:@"1"];
       
    }
    if (startcity.length>0&&endcity.length>0) {
        startCoordinate=startcoor;
        [self getprovice:startCoordinate withType:@"2"];
        endCoordinate=endcoor;
        [self getprovice:endCoordinate withType:@"3"];
//        [_geocoder geocodeAddressString:startcity completionHandler:^(NSArray *placemarks, NSError *error) {
//            //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
//            CLPlacemark *placemark=[placemarks firstObject];
//            CLLocation *location=placemark.location;//位置
//            startCoordinate=location.coordinate;
//            
//            [self getprovice:startCoordinate withType:@"2"];
//            [_geocoder geocodeAddressString:endcity completionHandler:^(NSArray *placemarks, NSError *error) {
//                //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
//                //            NSArray *arr=placemarks;
//                if (placemarks.count>0) {
//                    CLPlacemark *placemark=placemarks[0];
//                    
//                    CLLocation *location=placemark.location;//位置
//                    endCoordinate=location.coordinate;
//                    [self getprovice:endCoordinate withType:@"3"];
//                   
//                    
//                    
//                }
//                
//                
//            }];
//            
//        }];
    }
   
    
    
}
//获取当天数据
-(void)getstarttodaydata:(NSString *)provice withlat:(NSString *)lat Withlon:(NSString *)lon Withtype:(NSString *)type{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *ftlist = [[NSMutableDictionary alloc]init];
    
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [ftlist setObject:provice forKey:@"province"];
    [ftlist setObject:lon forKey:@"longitude"];
    [ftlist setObject:lat forKey:@"latitude"];
    [t_b setObject:ftlist forKey:@"gz_today_weather_of_location"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        
        NSDictionary *b=[returnData objectForKey:@"b"];
        NSDictionary *locwea=[b objectForKey:@"gz_today_weather_of_location"];
        NSDictionary *wt=[locwea objectForKey:@"wt"];
        NSString *wtico=[wt objectForKey:@"wt_ico"];
        if ([type isEqualToString:@"2"]) {
            self.startimg=[NSString stringWithFormat:@"w%@",wtico];
        }
        if ([type isEqualToString:@"3"]) {
            self.endimg=[NSString stringWithFormat:@"w%@",wtico];
        }
         [self goSearch];
       
        
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}

-(void)goSearch{
//    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
//    ann.coordinate = startCoordinate;
//    ann.title=@"起点";
//    self.place=ann;
//    [m_mapView addAnnotation:ann];
//    MKPointAnnotation *ann1 = [[MKPointAnnotation alloc] init];
//    ann1.coordinate = endCoordinate;
//    ann1.title=@"终点";
//    self.place1=ann1;
////    [ann1 setTitle:@"天河城"];
////    [ann1 setSubtitle:@"购物好去处"];
//    //触发viewForAnnotation
//    [m_mapView addAnnotation:ann1];
    [m_mapView removeAnnotations:self.marks];
    [m_mapView removeOverlay:self.route.polyline];
    [m_mapView removeOverlays:m_mapView.overlays];
    FootMark *fm=[[FootMark alloc]initWithCoordinate:startCoordinate andTitle:@"起点"];
    fm.mTag=1;
    fm.iconame=self.startimg;
    [m_mapView addAnnotation:fm];
    FootMark *fm1=[[FootMark alloc]initWithCoordinate:endCoordinate andTitle:@"终点"];
    fm1.mTag=2;
    fm1.iconame=self.endimg;
    [m_mapView addAnnotation:fm1];
    [self.marks addObject:fm];
    [self.marks addObject:fm1];
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:startCoordinate
                                                       addressDictionary:nil];
    
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:endCoordinate
                                                       addressDictionary:nil];
    
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    [self findDirectionsFrom:fromItem
                          to:toItem];
}
#pragma mark - Private

- (void)findDirectionsFrom:(MKMapItem *)source
                        to:(MKMapItem *)destination
{
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.destination = destination;
    request.requestsAlternateRoutes = YES;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         
         if (error) {
             
             NSLog(@"error:%@", error);
             UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"路线绘制失败" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
             [al show];
         }
         else {
             
             MKRoute *route = response.routes[0];
//             NSLog(@"%@  ^^%@",route.name,route.advisoryNotices);
//             NSArray * stepArray = [NSArray arrayWithArray:route.steps];
//             //进行遍历
//             for (int i=0; i<stepArray.count; i++) {
//                 //线路的详情节点
//                 MKRouteStep * step = stepArray[i];
//                 //在此节点处添加一个大头针
//                 MKPointAnnotation * point = [[MKPointAnnotation alloc]init];
//                 point.coordinate=step.polyline.coordinate;
//                 point.title=step.instructions;
//                 point.subtitle=step.notice;
//                 [m_mapView addAnnotation:point];
//                 //将此段线路添加到地图上
//                 [m_mapView addOverlay:step.polyline];
//             }
             
             self.route=route;
             [m_mapView addOverlay:route.polyline];
         }
     }];
     [self centerMap];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
//    [m_mapView removeOverlay:overlay];
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5.0;
    renderer.strokeColor = [UIColor colorHelpWithRed:0 green:132 blue:214 alpha:1];
    return renderer;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _coordinate.latitude = userLocation.location.coordinate.latitude;
    _coordinate.longitude = userLocation.location.coordinate.longitude;
    
    [self setMapRegionWithCoordinate:_coordinate];
}

- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion region;
    
    region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(.1, .1));
    MKCoordinateRegion adjustedRegion = [m_mapView regionThatFits:region];
//    adjustedRegion.center.latitude=(startCoordinate.latitude+endCoordinate.latitude)/2;
//    adjustedRegion.center.longitude=(startCoordinate.longitude+endCoordinate.longitude)/2;
    [m_mapView setRegion:adjustedRegion animated:YES];
}
-(void) centerMap {
     float delta=iPhone5?1.6:1.2;
    CLLocationCoordinate2D centercoordinate;
    centercoordinate.latitude=(startCoordinate.latitude+endCoordinate.latitude)/2;
    centercoordinate.longitude=(startCoordinate.longitude+endCoordinate.longitude)/2;
     MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centercoordinate, 1000, 1000);
    float censpala=(startCoordinate.latitude-endCoordinate.latitude);
    float censpalo=(startCoordinate.longitude-endCoordinate.longitude);
    if (censpala<0) {
        censpala=-censpala;
    }
    if (censpalo<0) {
        censpalo=-censpalo;
    }
    region.span.latitudeDelta=censpala*delta;
    region.span.longitudeDelta=censpalo*delta;
    region.center.latitude=(startCoordinate.latitude+endCoordinate.latitude)/2;
    region.center.longitude=(startCoordinate.longitude+endCoordinate.longitude)/2;
    [m_mapView setRegion:region animated:YES];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MyPoint class]]) {
        //如果是自己的位置的大头针,这个大头针将不重用
        MKAnnotationView *view = [[MKAnnotationView alloc]init];
//        if (view == nil)
//        {
//            //			view = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]] autorelease];
//            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]];
//            
//        }
//        else
//        {
//            view.annotation = annotation;
//        }
        [self.imageview removeFromSuperview];
        self.imageview.image=nil;
        UIImage *image = [UIImage imageNamed:@"指点天气.png"];
        
        self.imageview = [[UIImageView alloc] initWithImage:image];
        
        self.imageview.frame = CGRectMake(-10, -30, image.size.width, image.size.height);
        [view addSubview: self.imageview];
        view.tag=111;
        //        [view setImage:[UIImage imageNamed:@"定位符.png"]];
//        view.canShowCallout = YES;
        return view;
    }
    if ([annotation isKindOfClass:[FootMark class]]) {
        //如果是自己的位置的大头针,这个大头针将不重用
         FootMark *t_point = (FootMark *)annotation;
        HPweatherAnnotationView *annotationView = [[HPweatherAnnotationView alloc]init];
//        if (annotationView == nil) {
//            annotationView = [[HPweatherAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:[annotation title]];
//        }
        //设置让注解视图显示的Model 内容
        annotationView.annotation = annotation;
        annotationView.imageName=t_point.iconame;
//        for (UIView * view in [annotationView subviews])
//            
//        {
//            
//            [view removeFromSuperview];
//            
//        }
//        annotationView.image=nil;
        
//        annotationView.centerOffset = CGPointMake(5,5);
        
        //起点终点图标
//        UIImage *image = [UIImage imageNamed:@"指点天气.png"];
//        
//        UIImageView *imagev = [[UIImageView alloc] initWithImage:image];
//        
//        imagev.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//        [annotationView addSubview: imagev];
        
//        UIImage *icoimg = [UIImage imageNamed:t_point.iconame];
//        
//        UIImageView *icoimgv = [[UIImageView alloc] initWithImage:icoimg];
//        
//        icoimgv.frame = CGRectMake(-35, 0, 50, 50);
////        [annotationView addSubview: icoimgv];
//        annotationView.image=icoimg;
//        annotationView.frame=CGRectMake(-35, 0, 50, 50);
//        annotationView.tag=t_point.mTag;
//        annotationView.canShowCallout=YES;
        return annotationView;
    }
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //如果是自己的位置的大头针,这个大头针将不重用
        return nil;
    }
    //重用标志符
    static NSString *reUse = @"reUse";
    //根据重用对鞋去查找重用的大头针
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc]init];
//    if (annotationView == nil) {
//        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reUse];
//    }
//    //设置让注解视图显示的Model 内容
//    annotationView.annotation = annotation;
//    
//    for (UIView * view in [annotationView subviews])
//        
//    {
//        
//        [view removeFromSuperview];
//        
//    }
    annotationView.image=nil;
    
    annotationView.centerOffset = CGPointMake(5,5);
    
    
    UIImage *image = [UIImage imageNamed:@"指点天气.png"];
    
    UIImageView *imagev = [[UIImageView alloc] initWithImage:image];
    
    imagev.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [annotationView addSubview: imagev];
    annotationView.canShowCallout=YES;
//            annotationView.image=[UIImage imageNamed:@"指点天气"];
    
    
    
    return annotationView;
   
    
}
-(void)getgz_weather_of_locationWithprovice:(NSString *)provice Withlat:(NSString *)lat Withlon:(NSString *)lon withcity:(NSString *)city{
//    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *ftlist = [[NSMutableDictionary alloc]init];
    
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    if (provice.length>0) {
        [ftlist setObject:provice forKey:@"province"];
    }
    
    [ftlist setObject:lon forKey:@"longitude"];
    [ftlist setObject:lat forKey:@"latitude"];
    [t_b setObject:ftlist forKey:@"gz_weather_of_location"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
//       [MBProgressHUD hideHUDForView:self animated:YES];
        if (self.footaleart) {
            [self.footaleart removeFromSuperview];
            self.footaleart=nil;
        }
        NSDictionary *b=[returnData objectForKey:@"b"];
        NSDictionary *locwea=[b objectForKey:@"gz_weather_of_location"];
        NSArray*wt_list=[locwea objectForKey:@"wt_list"];
        self.footaleart=[[FootInfoAleartView alloc]initWithFrame:CGRectMake(0, self.height-180, kScreenWidth, 180)];
//        if (iPhone4) {
//            self.footaleart.frame=CGRectMake(0, 180, kScreenWidth, 180);
//        }
        [self.footaleart getdata:wt_list withaddress:city];
        [self addSubview:self.footaleart];
        
            
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
//        [MBProgressHUD hideHUDForView:self animated:YES];
        
    } withCache:YES];
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    if ([view.annotation isKindOfClass:[FootMark class]]) {
    if (view.tag==1) {
        [self getprovice:startCoordinate withType:@"1"];
    }else if (view.tag==2){
        [self getprovice:endCoordinate withType:@"1"];
    }
    }
}
//获取搜索路径的省份
-(void)getprovice:(CLLocationCoordinate2D)locatin withType:(NSString *)type{
    
    CLLocation *c = [[CLLocation alloc] initWithLatitude:locatin.latitude longitude:locatin.longitude];
    //创建位置
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:c completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *country = placemark.name;
            if ([country rangeOfString:@"市"].location!=NSNotFound) {
                NSArray *timeArray1=[country componentsSeparatedByString:@"市"];
                country=[timeArray1 objectAtIndex:1];
            }
            self.titlecity=country;
            NSString *lat=[NSString stringWithFormat:@"%f",locatin.latitude];
            NSString *lon=[NSString stringWithFormat:@"%f",locatin.longitude];
            if ([type isEqualToString:@"1"]) {
                
                [self getgz_weather_of_locationWithprovice:placemark.administrativeArea Withlat:lat Withlon:lon withcity:country];
               
            }else if ([type isEqualToString:@"2"]){
                [self getgz_weather_of_locationWithprovice:placemark.administrativeArea Withlat:lat Withlon:lon withcity:country];//获取起点天气
                [self getstarttodaydata:placemark.administrativeArea withlat:lat Withlon:lon Withtype:@"2"];
            }else if ([type isEqualToString:@"3"]){
                
                [self getstarttodaydata:placemark.administrativeArea withlat:lat Withlon:lon Withtype:@"3"];
            }
        }}];
}
@end
