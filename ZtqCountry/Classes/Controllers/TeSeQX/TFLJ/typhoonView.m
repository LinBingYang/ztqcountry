//
//  typhoonView.m
//  ZtqNew
//
//  Created by lihj on 12-11-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "typhoonView.h"
#import "WildcardGestureRecognizer.h"
#import "tf_detailViewController.h"
#import "tfDetailView.h"
#import "ShareFun.h"
#import <Foundation/NSScanner.h>
@implementation typhoonView
@synthesize delegate;
@synthesize m_tfModel = m_tfModel;
@synthesize showTimer = showTimer;
@synthesize typhoonPlayTimer = typhoonPlayTimer;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [[tfDetailView shareTfDetailView] setIfHidden:NO];
        self.candw=YES;
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //		mapView.showsUserLocation = YES;
        [self.mapView setDelegate:self];
        [self addSubview:self.mapView];
        
        m_tag = 0;
        m_tagLocation = 0;
        m_tagCenter = 2;
        
        m_locations = [[NSMutableArray alloc] initWithCapacity:2];
        m_dottedLineArray = [[NSMutableArray alloc] initWithCapacity:2];
        routesCentre = [[NSMutableArray alloc] initWithCapacity:2];
        m_tfsxarray=[[NSMutableArray alloc]init];
        int y=20;
        if (kSystemVersionMore7) {
            y=0;
        }
        m_viewLegend = [[UIView alloc] initWithFrame:CGRectMake(0, -kScreenHeitht-20, kScreenWidth, kScreenHeitht-20-44)];
        //		[m_viewLegend setBackgroundColor:[UIColor colorWithRed:216.0f/255 green:241.0f/255 blue:255.0f/255 alpha:0.9]];
//        [self addSubview:m_viewLegend];
        //		[m_viewLegend release];
        
        UIImageView *t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht-44)];
        [t_imageView setBackgroundColor:[UIColor clearColor]];
        [t_imageView setImage:[UIImage imageNamed:@"imageExplain.png"]];
//        [m_viewLegend addSubview:t_imageView];
//        [m_viewLegend bringSubviewToFront:t_imageView];
        //		[t_imageView release];
        
        UIButton *t_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, kScreenHeitht-40)];
        [t_btn addTarget:self action:@selector(didImageExplain) forControlEvents:UIControlEventTouchUpInside];
        [m_viewLegend addSubview:t_btn];
        //		[t_btn release];
        
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        _locationManager.distanceFilter = 1000;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTyphoonTimer) name:@"stopTyphoonTimer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayTimer) name:@"stopPlayTimer" object:nil];
        
        self.myanntion=[[NSMutableArray alloc]init];
        self.allloctions=[[NSMutableArray alloc]init];
        
        UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
        [self.mapView addGestureRecognizer:mTap];
        //		WildcardGestureRecognizer * tapInterceptor = [[WildcardGestureRecognizer alloc] init];
        //		tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event) {
        //			if (currentPlayPoint > 0) {
        //				canTouch = NO;
        //			}
        //		};
        //		[mapView addGestureRecognizer:tapInterceptor];
    }
    return self;
}
- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    
    [self.mapView removeOverlay:self.mkpl.overlay];
    m_tagCenter=1;
    if (self.isbz==YES) {
        [self centerMap];
    }
    
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//获取地图数据
- (void)setMapModel:(typhoonYearModel *)tf_model
{
    if (tf_model != nil) {
        //		m_tfModel = [tf_model retain];
        self.m_tfModel = tf_model;
        if (self.tfmds.count==1) {
            m_tagCenter=0;
        }
    }
}

//展示路径
-(void)showMapRoute
{
    self.timelabs=[[NSMutableArray alloc]init];
    
    
    //	if(routes) {
    //		[mapView removeAnnotations:[mapView annotations]];
    //	}
    
    routes = [[NSMutableArray alloc] init];
    
    [self performSelector:@selector(drawCordon)];
    
    //	NSMutableArray *locations = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    typhoonYearModel *ty=(typhoonYearModel *)m_tfModel;
    NSString *name=ty.code;
    if (name.length>2) {
        name=[name substringFromIndex:2];
    }
    for (int i=0; i<[m_tfModel.dotted_points count]; i++) {
        typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.dotted_points objectAtIndex:i];
        
        //		Place* t_place = [[[Place alloc] init] autorelease];
        Place* t_place = [[Place alloc] init];
        t_place.name = @"北京预报";
        //		t_place.description = [NSString stringWithFormat:@"%@预报 东经:%@° 北纬:%@°", t_detail.tip, t_detail.jd, t_detail.wd];
        t_place.description = [NSString stringWithFormat:@"%@,风速%@,风力%@级(%@)",t_detail.time,t_detail.fs,t_detail.fl,t_detail.qx];
        t_place.latitude = [t_detail.wd doubleValue];
        t_place.longitude = [t_detail.jd doubleValue];
        //		PlaceMark* t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
        PlaceMark* t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
        t_placeMark.mTag = 100 + i;
        NSInteger t_int = [t_detail.tip intValue];
        if (t_int > 0) {
            t_placeMark.ftime = t_int;
            t_placeMark.fl=[t_detail.fl intValue];
            t_placeMark.time=t_detail.time;
            
            
            [self.mapView addAnnotation:t_placeMark];
        }
        if (self.m_tfModel==self.tfmds[self.tfmds.count-1]) {
            [self.myanntion addObject:t_placeMark];
        }
        
        //		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude] autorelease];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude] ;
        [routes addObject:loc];
        [locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
    }
    m_tag = 1;
    [m_dottedLineArray addObject:[self makePolylineWithLocations:locations]];
    [self.mapView addOverlay:[self makePolylineWithLocations:locations]];
    [locations removeAllObjects];
    
    for (int i=0; i<[m_tfModel.dotted_1_points count]; i++) {
        typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.dotted_1_points objectAtIndex:i];
        //		Place* t_place = [[[Place alloc] init] autorelease];
        Place* t_place = [[Place alloc] init];
        if (t_detail.qx.length>0) {
            t_place.name = @"东京预报";
            //		t_place.description = [NSString stringWithFormat:@"%@预报 东经:%@° 北纬:%@°", t_detail.tip, t_detail.jd, t_detail.wd];
            t_place.description = [NSString stringWithFormat:@"%@,风速%@,风力%@级(%@)",t_detail.time,t_detail.fs,t_detail.fl,t_detail.qx];
        }
        t_place.latitude = [t_detail.wd doubleValue];
        t_place.longitude = [t_detail.jd doubleValue];
        //		PlaceMark* t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
        PlaceMark* t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
        t_placeMark.mTag = 200 + i;
        NSInteger t_int = [t_detail.tip intValue];
        if (t_int > 0) {
            //			t_placeMark.fl = t_int + 100;
            t_placeMark.ftime = t_int;
            t_placeMark.fl=[t_detail.fl intValue];
            t_placeMark.time=t_detail.time;
            [self.mapView addAnnotation:t_placeMark];
        }
        if (self.m_tfModel==self.tfmds[self.tfmds.count-1]) {
            [self.myanntion addObject:t_placeMark];
        }
        //		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude] autorelease];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude] ;
        [routes addObject:loc];
        [locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
    }
    m_tag = 2;
    [m_dottedLineArray addObject:[self makePolylineWithLocations:locations]];
    [self.mapView addOverlay:[self makePolylineWithLocations:locations]];
    [locations removeAllObjects];
    
    for (int i=0; i<[m_tfModel.dotted_2_points count]; i++) {
        typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.dotted_2_points objectAtIndex:i];
        //		Place* t_place = [[[Place alloc] init] autorelease];
        Place* t_place = [[Place alloc] init];
        if (t_detail.qx.length>0) {
            t_place.name = @"福州预报";
            //		t_place.description = [NSString stringWithFormat:@"%@预报 东经:%@° 北纬:%@°", t_detail.tip, t_detail.jd, t_detail.wd];
            t_place.description = [NSString stringWithFormat:@"%@,风速%@,风力%@级(%@)",t_detail.time,t_detail.fs,t_detail.fl,t_detail.qx];
        }
        t_place.latitude = [t_detail.wd doubleValue];
        t_place.longitude = [t_detail.jd doubleValue];
        //		PlaceMark* t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
        PlaceMark* t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
        t_placeMark.mTag = 300 + i;
        NSInteger t_int = [t_detail.tip intValue];
        if (t_int > 0) {
            //			t_placeMark.fl = t_int + 200;
            t_placeMark.ftime = t_int;
            t_placeMark.fl=[t_detail.fl intValue];
            t_placeMark.time=t_detail.time;
            
            [self.mapView addAnnotation:t_placeMark];
        }
        if (self.m_tfModel==self.tfmds[self.tfmds.count-1]) {
            [self.myanntion addObject:t_placeMark];
        }
        //		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude] autorelease];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude];
        [routes addObject:loc];
        [locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
    }
    m_tag = 3;
    [m_dottedLineArray addObject:[self makePolylineWithLocations:locations]];
    [self.mapView addOverlay:[self makePolylineWithLocations:locations]];
    [locations removeAllObjects];
    
    for (int i=0; i<[m_tfModel.dotted_3_points count]; i++) {
        typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.dotted_3_points objectAtIndex:i];
        //		Place* t_place = [[[Place alloc] init] autorelease];
        Place* t_place = [[Place alloc] init];
        if (t_detail.qx.length>0) {
            t_place.name = @"台湾预报";
            //        t_place.description = [NSString stringWithFormat:@"%@预报 东经:%@° 北纬:%@°", t_detail.tip, t_detail.jd, t_detail.wd];
            t_place.description = [NSString stringWithFormat:@"%@,风速%@,风力%@级(%@)",t_detail.time,t_detail.fs,t_detail.fl,t_detail.qx];
        }
        t_place.latitude = [t_detail.wd doubleValue];
        t_place.longitude = [t_detail.jd doubleValue];
        //		PlaceMark* t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
        PlaceMark* t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
        t_placeMark.mTag = 500 + i;
        NSInteger t_int = [t_detail.tip intValue];
        if (t_int > 0) {
            //            t_placeMark.fl = t_int + 300;
            t_placeMark.ftime = t_int;
            t_placeMark.fl=[t_detail.fl intValue];
            t_placeMark.time=t_detail.time;
            [self.mapView addAnnotation:t_placeMark];
        }
        if (self.m_tfModel==self.tfmds[self.tfmds.count-1]) {
            [self.myanntion addObject:t_placeMark];
        }
        //		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude] autorelease];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude];
        [routes addObject:loc];
        [locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
    }
    m_tag = 8;
    [m_dottedLineArray addObject:[self makePolylineWithLocations:locations]];
    [self.mapView addOverlay:[self makePolylineWithLocations:locations]];
    [locations removeAllObjects];
    
    for (int i=0; i<[m_tfModel.ful_points count]; i++) {
        typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.ful_points objectAtIndex:i];
        
        
        //NSString *year = [[t_detail objectForKey:@"time"] substringToIndex:4];
        
        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"MMddHH"];
        NSDate *s_date = [dateformat dateFromString:t_detail.time];
        [dateformat setDateFormat:@"MM月dd日 HH时"];
        NSString *d_date = [dateformat stringFromDate:s_date];
        //		[dateformat release];
        
        //		Place* t_place = [[[Place alloc] init] autorelease];
        Place* t_place = [[Place alloc] init];
        t_place.name = [NSString stringWithFormat:@"时间:%@", d_date];
        t_place.description = [NSString stringWithFormat:@"中心风力:%@ 中心风速:%@ 中心气压:%@", t_detail.fl, t_detail.fs_max, t_detail.qy];
        t_place.latitude = [t_detail.wd doubleValue];
        t_place.longitude = [t_detail.jd doubleValue];
        //		PlaceMark *t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
        PlaceMark *t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
        t_placeMark.mTag = 400 + i;
        t_placeMark.name=name;
        if (i == [m_tfModel.ful_points count] - 1)
        {
            t_placeMark.fl = -2;
        }else
            t_placeMark.fl = [t_detail.fl intValue];
        
        [self.mapView addAnnotation:t_placeMark];
        if (self.m_tfModel==self.tfmds[self.tfmds.count-1]) {
            [self.myanntion addObject:t_placeMark];
        }
        //		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude] autorelease];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude] ;
        [routes addObject:loc];
        [self.allloctions addObject:loc];//所有点
        
        [locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
        
        if (i == 0) {
            m_firstPointArr = [[NSArray alloc] initWithObjects:loc, nil];
        }
        if (i == [m_tfModel.ful_points count] - 1) {
            [[tfDetailView shareTfDetailView] showData:m_tfModel withNum:i];
            
            [self insertSubview:[tfDetailView shareTfDetailView] belowSubview:m_viewLegend];
            
            [routesCentre addObject:loc];
            
            m_tag = 0;
            CLLocationCoordinate2D newloc = CLLocationCoordinate2DMake([t_detail.wd doubleValue], [t_detail.jd doubleValue]);
            MKCircle *t_circle_10 = [MKCircle circleWithCenterCoordinate:newloc radius:[t_detail.fl_10 doubleValue]*1000];
            MKCircle *t_circle_7 = [MKCircle circleWithCenterCoordinate:newloc radius:[t_detail.fl_7 doubleValue]*1000];
            [self.mapView addOverlay:t_circle_10];
            [self.mapView addOverlay:t_circle_7];
        }
    }
    m_tag = 4;
    
    [self.mapView addOverlay:[self makePolylineWithLocations:locations]];
    [self performSelector:@selector(startTime)];
    //根据线路确定呈现范围
    [self centerMap];
}

//用routes数组的内容 确定region的呈现范围
-(void) centerMap {
    MKCoordinateRegion region;
    
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    if (m_tagCenter == 1)
    {
        if (routesCentre.count>0) {
            for(int idx = 0; idx < routesCentre.count; idx++)
            {
                CLLocation* currentLocation = [routesCentre objectAtIndex:idx];
                if(currentLocation.coordinate.latitude > maxLat)
                    maxLat = currentLocation.coordinate.latitude;
                if(currentLocation.coordinate.latitude < minLat)
                    minLat = currentLocation.coordinate.latitude;
                if(currentLocation.coordinate.longitude > maxLon)
                    maxLon = currentLocation.coordinate.longitude;
                if(currentLocation.coordinate.longitude < minLon)
                    minLon = currentLocation.coordinate.longitude;
            }
        }else{
            maxLat=26.08;
            minLat=26.08;
            maxLon=119.3;
            minLon=119.3;
        }
        
        region.span.latitudeDelta  = 20.0;
        region.span.longitudeDelta = 20.0;
    }
    else if(m_tagCenter==0)
    {
        if (routes.count>0) {
            for(int idx = 0; idx < routes.count; idx++)
            {
                CLLocation* currentLocation = [routes objectAtIndex:idx];
                if(currentLocation.coordinate.latitude > maxLat)
                    maxLat = currentLocation.coordinate.latitude;
                if(currentLocation.coordinate.latitude < minLat)
                    minLat = currentLocation.coordinate.latitude;
                if(currentLocation.coordinate.longitude > maxLon)
                    maxLon = currentLocation.coordinate.longitude;
                if(currentLocation.coordinate.longitude < minLon)
                    minLon = currentLocation.coordinate.longitude;
            }
            float delta=iPhone5?1.7:1.2;
            region.span.latitudeDelta  = (maxLat - minLat)*delta;
            region.span.longitudeDelta = (maxLon - minLon)*delta;
        }else{
            maxLat=26.08;
            minLat=26.08;
            maxLon=119.3;
            minLon=119.3;
            region.span.latitudeDelta  = 10;
            region.span.longitudeDelta =10;
        }
        
        
    }else{
        if (self.allloctions.count>0) {
            for(int idx = 0; idx < self.allloctions.count; idx++)
            {
                CLLocation* currentLocation = [self.allloctions objectAtIndex:idx];
                if(currentLocation.coordinate.latitude > maxLat)
                    maxLat = currentLocation.coordinate.latitude;
                if(currentLocation.coordinate.latitude < minLat)
                    minLat = currentLocation.coordinate.latitude;
                if(currentLocation.coordinate.longitude > maxLon)
                    maxLon = currentLocation.coordinate.longitude;
                if(currentLocation.coordinate.longitude < minLon)
                    minLon = currentLocation.coordinate.longitude;
            }
        }else{
            maxLat=26.08;
            minLat=26.08;
            maxLon=119.3;
            minLon=119.3;
        }
        float delta=1.7;
        region.span.latitudeDelta  = (maxLat - minLat)*delta;
        region.span.longitudeDelta = (maxLon - minLon)*delta;
    }
    region.center.latitude     = (maxLat + minLat) / 2;
    region.center.longitude    = (maxLon + minLon) / 2;
    //	region = MKCoordinateRegionMakeWithDistance(region.center, 2000000, 2000000);
    [self.mapView setRegion:region animated:YES];
}

//画警戒线
- (void)drawCordon
{
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    //    [locations addObject:[NSString stringWithFormat:@"%f,%f", 34.0, 132.0]];
    //    [locations addObject:[NSString stringWithFormat:@"%f,%f", 22.0, 132.0]];
    //    [locations addObject:[NSString stringWithFormat:@"%f,%f", 15.0, 125.0]];
    //    [locations addObject:[NSString stringWithFormat:@"%f,%f", 15.0, 110.0]];
    //    m_tag = 5;
    //    [mapView addOverlay:[self makePolylineWithLocations:locations]];
    //    [locations removeAllObjects];
    //
    //    [locations addObject:[NSString stringWithFormat:@"%f,%f", 34.0, 127.0]];
    //    [locations addObject:[NSString stringWithFormat:@"%f,%f", 22.0, 127.0]];
    //    [locations addObject:[NSString stringWithFormat:@"%f,%f", 15.0, 110.0]];
    //    m_tag = 6;
    //    [mapView addOverlay:[self makePolylineWithLocations:locations]];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *tfpath = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [tfpath setObject:@"0" forKey:@"warn_line_type"];
    [t_b setObject:tfpath forKey:@"typho_warn_line"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        //        NSLog(@"%@",returnData);
        [locations removeAllObjects];
        NSDictionary *b=[returnData objectForKey:@"b"];
        NSDictionary *typho_warn_line=[b objectForKey:@"typho_warn_line"];
        NSArray *warn_line_list=[typho_warn_line objectForKey:@"warn_line_list"];
        for (int i=0; i<warn_line_list.count; i++) {
            NSString *lon=[warn_line_list[i] objectForKey:@"lon"];
            NSString *lat=[warn_line_list[i] objectForKey:@"lag"];
            NSString *loct=[NSString stringWithFormat:@"%@,%@", lat, lon];
            [locations addObject:loct];
            
        }
        
        m_tag = 5;
        self.colorstr=[typho_warn_line objectForKey:@"color"];
        [self.mapView addOverlay:[self makePolylineWithLocations:locations]];
        NSString *txt_lon=[typho_warn_line objectForKey:@"txt_lon"];
        NSString *txt_lat=[typho_warn_line objectForKey:@"txt_lag"];
        float lat=txt_lat.floatValue;
        float lon=txt_lon.floatValue;
        
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lat,lon);
        self.mypoint=nil;
        self.mypoint = [[MyPoint alloc] initWithCoordinate:coords andTitle:@"24"];
        //添加标注
        [self.mapView addAnnotation:self.mypoint];
        //        CGPoint point =[mapView convertCoordinate:coords toPointToView:mapView];
        //        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(100, 60, 20, 100)];
        //        lab.text=@"24小时警戒线";
        //        lab.textColor=[UIColor redColor];
        //        lab.numberOfLines=0;
        //        lab.font=[UIFont systemFontOfSize:12];
        //        [mapView addSubview:lab];
        [self get48];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
    
    
    
    //	[locations release];
}

-(void)get48{
    //48小时
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    NSMutableDictionary *t_dic1 = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h1 = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b1 = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *tfpath1 = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h1 setObject:[setting sharedSetting].app forKey:@"p"];
    [tfpath1 setObject:@"1" forKey:@"warn_line_type"];
    [t_b1 setObject:tfpath1 forKey:@"typho_warn_line"];
    [t_dic1 setObject:t_h1 forKey:@"h"];
    [t_dic1 setObject:t_b1 forKey:@"b"];
    
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic1 withFlag:10 withSuccess:^(NSDictionary *returnData) {
        //        NSLog(@"%@",returnData);
        [locations removeAllObjects];
        NSDictionary *b=[returnData objectForKey:@"b"];
        NSDictionary *typho_warn_line=[b objectForKey:@"typho_warn_line"];
        NSArray *warn_line_list=[typho_warn_line objectForKey:@"warn_line_list"];
        for (int i=0; i<warn_line_list.count; i++) {
            NSString *lon=[warn_line_list[i] objectForKey:@"lon"];
            NSString *lat=[warn_line_list[i] objectForKey:@"lag"];
            NSString *loct=[NSString stringWithFormat:@"%@,%@", lat, lon];
            [locations addObject:loct];
            
        }
        m_tag = 6;
        self.color48=[typho_warn_line objectForKey:@"color"];
        [self.mapView addOverlay:[self makePolylineWithLocations:locations]];
        NSString *txt_lon=[typho_warn_line objectForKey:@"txt_lon"];
        NSString *txt_lat=[typho_warn_line objectForKey:@"txt_lag"];
        float lat=txt_lat.floatValue;
        float lon=txt_lon.floatValue;
        
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lat,lon);
        self.mypoint=nil;
        self.mypoint = [[MyPoint alloc] initWithCoordinate:coords andTitle:@"48"];
        //添加标注
        [self.mapView addAnnotation:self.mypoint];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
//根据坐标点生成线路
- (MKPolyline *)makePolylineWithLocations:(NSMutableArray *)newLocations{
    MKMapPoint *pointArray = malloc(sizeof(CLLocationCoordinate2D)* newLocations.count);
    for(int i = 0; i < newLocations.count; i++)
    {
        // break the string down even further to latitude and longitude fields.
        NSString* currentPointString = [newLocations objectAtIndex:i];
        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        CLLocationDegrees latitude  = [[latLonArr objectAtIndex:0] doubleValue];
        CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        pointArray[i] = MKMapPointForCoordinate(coordinate);
    }
    
    routeLine = [MKPolyline polylineWithPoints:pointArray count:newLocations.count];
    free(pointArray);
    return routeLine;
}

#pragma mark mapView delegate functions
//地图动（拖拽，放大，缩小，双击）
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
}
//结束（拖拽，放大，缩小，双击）
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
}

//显示Annotation
- (MKAnnotationView *)mapView:(MKMapView *)tmapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    /// 判断是否是自己
    if ([annotation isKindOfClass:[MyPoint class]]) {
        //如果是自己的位置的大头针,这个大头针将不重用
        MyPoint *t_point = (MyPoint *)annotation;
        //        MKAnnotationView *view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:[annotation title]];
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
        MKAnnotationView *view=[[MKAnnotationView alloc]init];
        if ([t_point.title isEqualToString:@"24"]) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(-5, -50, 20, 100)];
            lab.text=@"24小时警戒线";
            lab.textColor=[self getColor:self.colorstr];
            lab.numberOfLines=0;
            lab.font=[UIFont systemFontOfSize:12];
            [view addSubview:lab];
        }else if ([t_point.title isEqualToString:@"48"]){
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(-5, -50, 20, 100)];
            lab.text=@"48小时警戒线";
            lab.textColor=[self getColor:self.color48];
            lab.numberOfLines=0;
            lab.font=[UIFont systemFontOfSize:12];
            [view addSubview:lab];
        }
        
        
        return view;
    }
    if ([annotation isKindOfClass:[PlaceMark class]])
    {
        PlaceMark *t_point = (PlaceMark *)annotation;
        
        NSInteger x = t_point.mTag;
        NSInteger t_fl = t_point.fl;
        NSInteger t_yctime = t_point.ftime;
        NSString *time=t_point.time;
        //        NSLog(@"%@",time);
        
        //		MKAnnotationView *view = (MKAnnotationView *)[tmapView dequeueReusableAnnotationViewWithIdentifier:[annotation title]];
        MKAnnotationView *view=[[MKAnnotationView alloc]init];
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
        imgview.userInteractionEnabled=YES;
        self.img=imgview;
        
        //            imgview.frame = CGRectMake(-10, -10, 20, 20);
        [view addSubview:imgview];
        
        view.tag = t_point.mTag;
        if (view == nil)
        {
            ////			view = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]] autorelease];
            //            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]];
            //            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
            //            imgview.userInteractionEnabled=YES;
            //            self.img=imgview;
            //
            ////            imgview.frame = CGRectMake(-10, -10, 20, 20);
            //            [view addSubview:imgview];
            //
            //			view.tag = t_point.mTag;
        }
        else
        {
            view.annotation = annotation;
        }
        if (view.tag==111) {
            
            self.img=nil;
            view.canShowCallout = YES;
            return view;
            
        }
        if (t_fl == -1) {
            view.image=[UIImage imageNamed:@"指点天气.png"];
            
            return view;
        }
        else if (t_fl == -2)
        {
            typhoonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-15, -15, 30, 30)];
            [typhoonImageView setImage:[UIImage imageNamed:@"台风"]];
            [view addSubview:typhoonImageView];
            if (self.tfmds.count==2) {
                if (self.m_tfModel==self.tfmds[self.tfmds.count-2]) {
                    self.sectfimg = [[UIImageView alloc] initWithFrame:CGRectMake(-15, -15, 30, 30)];
                    self.sectfimg.image=[UIImage imageNamed:@"台风"];
                    [view addSubview:self.sectfimg];
                }
            }
            if (self.tfmds.count==3) {
                self.sectfimg = [[UIImageView alloc] initWithFrame:CGRectMake(-15, -15, 30, 30)];
                self.thrtfimg = [[UIImageView alloc] initWithFrame:CGRectMake(-15, -15, 30, 30)];
                if (self.m_tfModel==self.tfmds[self.tfmds.count-2]) {
                    self.sectfimg.image=[UIImage imageNamed:@"台风"];
                    [view addSubview:self.sectfimg];
                }
                if (self.m_tfModel==self.tfmds[self.tfmds.count-3]) {
                    self.thrtfimg.image=[UIImage imageNamed:@"台风"];
                    [view addSubview:self.thrtfimg];
                }
            }
            
            //			[self.img setImage:[UIImage imageNamed:@"yellow.png"]];
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
            imgview.userInteractionEnabled=YES;
            //            [imgview setImage:[UIImage imageNamed:@"yellow.png"]];
            imgview.backgroundColor=[UIColor whiteColor];
            [view addSubview:imgview];
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, -5, 20, 20)];
            lab.text=t_point.name;
            lab.font=[UIFont systemFontOfSize:10];
            [imgview addSubview:lab];
            view.canShowCallout=YES;
            
        }
        else if (t_fl <= 7 && t_fl >0) {
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
            imgview.userInteractionEnabled=YES;
            [imgview setImage:[UIImage imageNamed:@"green"]];
            [view addSubview:imgview];
            //			[self.img setImage:[UIImage imageNamed:@"green.png"]];
            
        }
        else if (t_fl <= 9 && t_fl >= 8) {
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
            imgview.userInteractionEnabled=YES;
            [imgview setImage:[UIImage imageNamed:@"blue.png"]];
            [view addSubview:imgview];
            //			[self.img setImage:[UIImage imageNamed:@"blue.png"]];
            
        }
        else if (t_fl <= 11 && t_fl >= 10) {
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
            imgview.userInteractionEnabled=YES;
            [imgview setImage:[UIImage imageNamed:@"yellow.png"]];
            [view addSubview:imgview];
            //			[self.img setImage:[UIImage imageNamed:@"yellow.png"]];
            
        }
        else if (t_fl <= 13 && t_fl >= 12) {
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
            imgview.userInteractionEnabled=YES;
            [imgview setImage:[UIImage imageNamed:@"darkYellow.png"]];
            [view addSubview:imgview];
            //			[self.img setImage:[UIImage imageNamed:@"darkYellow.png"]];
            
        }
        else if (t_fl <= 15 && t_fl >= 14) {
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
            imgview.userInteractionEnabled=YES;
            [imgview setImage:[UIImage imageNamed:@"cyan.png"]];
            [view addSubview:imgview];
            //			[self.img setImage:[UIImage imageNamed:@"cyan.png"]];
            
        }
        else if (t_fl >= 16 && t_fl < 24) {
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
            imgview.userInteractionEnabled=YES;
            [imgview setImage:[UIImage imageNamed:@"red.png"]];
            [view addSubview:imgview];
            //			[self.img setImage:[UIImage imageNamed:@"red.png"]];
            
        }
        if (t_yctime == 24 || t_yctime == 48 || t_yctime == 72 || t_yctime == 96)
        {
            self.img=nil;
            
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(-50, -20, 200, 40)];
            //            lab.text=t_point.time;
            self.rlab=lab;
            //            lab.textColor=[UIColor redColor];
            lab.numberOfLines=0;
            lab.font=[UIFont systemFontOfSize:13];
            if (view.tag==t_point.mTag) {
                lab.text=time;
            }
            if (x>=200&&x<300) {
                lab.textColor=[UIColor colorHelpWithRed:108 green:108 blue:108 alpha:1];
            }else
                if (x>=300&&x<400) {
                    lab.textColor=[UIColor blueColor];
                }else
                    if (x>=500) {
                        lab.textColor=[UIColor colorHelpWithRed:232 green:174 blue:59 alpha:1];
                    }else{
                        lab.textColor=[UIColor redColor];
                    }
            [view addSubview:lab];
            [self.timelabs addObject:lab];
            
            if (t_fl <= 7 && t_fl >0) {
                UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
                imgview.userInteractionEnabled=YES;
                [imgview setImage:[UIImage imageNamed:@"green"]];
                [view addSubview:imgview];
                //			[self.img setImage:[UIImage imageNamed:@"green.png"]];
                
            }
            else if (t_fl <= 9 && t_fl >= 8) {
                UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
                imgview.userInteractionEnabled=YES;
                [imgview setImage:[UIImage imageNamed:@"blue.png"]];
                [view addSubview:imgview];
                //			[self.img setImage:[UIImage imageNamed:@"blue.png"]];
                
            }
            else if (t_fl <= 11 && t_fl >= 10) {
                UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
                imgview.userInteractionEnabled=YES;
                [imgview setImage:[UIImage imageNamed:@"yellow.png"]];
                [view addSubview:imgview];
                //			[self.img setImage:[UIImage imageNamed:@"yellow.png"]];
                
            }
            else if (t_fl <= 13 && t_fl >= 12) {
                UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
                imgview.userInteractionEnabled=YES;
                [imgview setImage:[UIImage imageNamed:@"darkYellow.png"]];
                [view addSubview:imgview];
                //			[self.img setImage:[UIImage imageNamed:@"darkYellow.png"]];
                
            }
            else if (t_fl <= 15 && t_fl >= 14) {
                UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
                imgview.userInteractionEnabled=YES;
                [imgview setImage:[UIImage imageNamed:@"cyan.png"]];
                [view addSubview:imgview];
                //			[self.img setImage:[UIImage imageNamed:@"cyan.png"]];
                
            }
            else if (t_fl >= 16 && t_fl < 24) {
                UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
                imgview.userInteractionEnabled=YES;
                [imgview setImage:[UIImage imageNamed:@"red.png"]];
                [view addSubview:imgview];
                //			[self.img setImage:[UIImage imageNamed:@"red.png"]];
                
            }
            //			[view setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%dh_red.png", t_fl]]];
        }
        
        else if (t_fl == 124 || t_fl == 148 || t_fl == 172 || t_fl == 196)
        {
            self.img=nil;
            
            //            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(-25, -10, 100, 20)];
            //            lab.text=t_point.time;
            //                 self.blacklab=lab;
            //            lab.textColor=[UIColor blackColor];
            //            lab.numberOfLines=0;
            //            lab.font=[UIFont fontWithName:kBaseFont size:12];
            //            [view addSubview:lab];
            //			[view setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%dh_black.png", t_fl - 100]]];
        }
        else if (t_fl == 224 || t_fl == 248 || t_fl == 272 || t_fl == 296)
        {
            self.img=nil;
            
            //            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(-25, -10, 100, 20)];
            //            lab.text=t_point.time;
            //            self.bluelab=lab;
            //            lab.textColor=[UIColor blueColor];
            //            lab.numberOfLines=0;
            //            lab.font=[UIFont fontWithName:kBaseFont size:12];
            //            [view addSubview:lab];
            //			[view setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%dh_blue.png", t_fl - 200]]];
        }
        /*
         显示点击时间、详情页面
         */
        view.canShowCallout = YES;
        //        view.draggable=YES;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        btn.tag = x;
        //		[btn addTarget:self action:@selector(btnaction:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(btnaction:) forControlEvents:UIControlEventTouchUpInside];
        //		view.rightCalloutAccessoryView = btn;
        
        
        return view;
    }
    else
    {
        if ([annotation.title isEqualToString:@"Current Location"])
        {
            //annotation.title = @"我的位置";
            
            MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
            newAnnotation.pinColor = MKPinAnnotationColorRed;
            newAnnotation.canShowCallout = YES;
            
            return newAnnotation;
        }
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //	NSLog(@"1view%d",view.tag);
    self.isbz=NO;
    touchInt = view.tag;
    if (currentPlayPoint == 0) {
        [[tfDetailView shareTfDetailView] setIfHidden:NO];//点击不隐藏数据栏
        
        //        NSInteger t_type = touchInt / 100;
        //
        //        NSInteger t_tag;
        //        if (t_type > 3)
        //            t_tag = touchInt % 100 + (t_type - 4) * 100;
        //        else
        //            t_tag = touchInt % 100;
        //
        //        if (t_type > 4)
        //            t_type = 4;
        //        if (delegate && [delegate respondsToSelector:@selector(pushsetMapData:withNum:withType:)]) {
        ////            [self.delegate pushsetMapData:m_tfModel withNum:t_tag withType:t_type];
        //        }
        
        
        
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    //	NSLog(@"2view%d",view.tag);
    //    self.isbz=NO;
    if (touchInt == view.tag) {
        [[tfDetailView shareTfDetailView] setIfHidden:NO];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        m_tag ++;
        if (m_tag % 2 == 1)
        {
            //			MKCircleView* circleView = [[[MKCircleView alloc] initWithOverlay:overlay] autorelease];
            MKCircleView* circleView = [[MKCircleView alloc] initWithOverlay:overlay];
            circleView.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
            circleView.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
            circleView.lineWidth = 3.0;
            self.mkcirview=circleView;
            return circleView;
        }
        else if (m_tag % 2 == 0)
        {
            //			MKCircleView* circleView = [[[MKCircleView alloc] initWithOverlay:overlay] autorelease];
            MKCircleView* circleView = [[MKCircleView alloc] initWithOverlay:overlay];
            circleView.fillColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
            circleView.strokeColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
            circleView.lineWidth = 3.0;
            self.mkcirview1=circleView;
            return circleView;
        }
    }
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        //		MKPolylineView *routeLineView = [[[MKPolylineView alloc] initWithPolyline:routeLine] autorelease];
        MKPolylineView *routeLineView = [[MKPolylineView alloc] initWithPolyline:routeLine];
        routeLineView.fillColor = [UIColor clearColor];
        routeLineView.lineWidth = 4.0;
        
        if (m_tag == 1) {
            routeLineView.strokeColor = [UIColor redColor];
            routeLineView.lineDashPattern = [NSArray arrayWithObjects: [NSNumber numberWithInt:10], nil];
            self.rycpl=routeLineView;
        }
        else if (m_tag == 2) {
            routeLineView.strokeColor = [UIColor colorHelpWithRed:108 green:108 blue:108 alpha:1];
            routeLineView.lineDashPattern = [NSArray arrayWithObjects: [NSNumber numberWithInt:10], nil];
            self.bycpl=routeLineView;
        }
        else if (m_tag == 3) {
            routeLineView.strokeColor = [UIColor blueColor];
            routeLineView.lineDashPattern = [NSArray arrayWithObjects: [NSNumber numberWithInt:10], nil];
            self.blueycpl=routeLineView;
        }
        else if (m_tag == 4) {
            routeLineView.strokeColor = [UIColor redColor];
            self.bfpl=routeLineView;
        }
        else if (m_tag == 8) {
            routeLineView.strokeColor = [UIColor colorHelpWithRed:232 green:174 blue:59 alpha:1];
            routeLineView.lineDashPattern = [NSArray arrayWithObjects: [NSNumber numberWithInt:10], nil];
            self.twycpl=routeLineView;
        }
        else if (m_tag == 5) {
            //            routeLineView.strokeColor = [UIColor yellowColor];
            //            routeLineView.lineDashPattern = [NSArray arrayWithObjects: [NSNumber numberWithInt:10], nil];
            routeLineView.lineWidth = 2.5;
            routeLineView.strokeColor = [self getColor:self.colorstr];
            
            
        }
        else if (m_tag == 6) {
            //            routeLineView.strokeColor = [UIColor redColor];
            //            routeLineView.lineDashPattern = [NSArray arrayWithObjects: [NSNumber numberWithInt:10], nil];
            routeLineView.lineWidth = 2.5;
            routeLineView.strokeColor = [self getColor:self.color48];
        }
        else if (m_tag == 7) {
            //            routeLineView.strokeColor = [UIColor redColor];
            //            routeLineView.lineDashPattern = [NSArray arrayWithObjects: [NSNumber numberWithInt:10], nil];
            routeLineView.lineWidth = 2.0;
            routeLineView.strokeColor = [UIColor colorHelpWithRed:244 green:244 blue:244 alpha:1];
            self.mkpl=routeLineView;
        }
        m_tag = 0;
        return routeLineView;
    }
    return nil;
}

#pragma mark btn action
- (void)btnaction:(id)sender
{
    UIButton *t_btn = (UIButton *)sender;
    NSInteger t_btnTag = t_btn.tag;
    
    NSInteger t_type = t_btnTag / 100;
    
    NSInteger t_tag;
    if (t_type > 3)
        t_tag = t_btnTag % 100 + (t_type - 4) * 100;
    else
        t_tag = t_btnTag % 100;
    
    if (t_type > 4)
        t_type = 4;
    if (delegate && [delegate respondsToSelector:@selector(pushsetMapData:withNum:withType:)]) {
        [self.delegate pushsetMapData:m_tfModel withNum:t_tag withType:t_type];
    }
    //	tf_detailViewController *t_mapDetailViewController = [[tf_detailViewController alloc] init];
    //	[t_mapDetailViewController setMapData:m_tfModel withNum:t_tag withType:t_type];
    //	[mainEntry.navigationController pushViewController:t_mapDetailViewController animated:!kSystemVersionMore7];
}

- (void)addAnn
{   [self.rlab removeFromSuperview];
    typhoonYearModel *ty=(typhoonYearModel *)m_tfModel;
    NSString *name=ty.code;
    if (name.length>2) {
        name=[name substringFromIndex:2];
    }
    if (currentPlayPoint == [m_tfModel.ful_points count]) {
        [self performSelector:@selector(stopPlayTimer)];
        currentPlayPoint = 0;
        
        if (delegate && [delegate respondsToSelector:@selector(playMapOver)]) {
            self.candw=YES;
            [delegate playMapOver];
        }
        
        //		NSMutableArray *locations = [[[NSMutableArray alloc] init] autorelease];
        NSMutableArray *locations = [[NSMutableArray alloc] init];
        for (int i=0; i<[m_tfModel.dotted_points count]; i++) {
            typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.dotted_points objectAtIndex:i];
            
            //			Place* t_place = [[[Place alloc] init] autorelease];
            Place* t_place = [[Place alloc] init];
            t_place.name = @"北京预报";
            t_place.description = [NSString stringWithFormat:@"%@,风速%@,风力%@级(%@)",t_detail.time,t_detail.fs,t_detail.fl,t_detail.qx];
            t_place.latitude = [t_detail.wd doubleValue];
            t_place.longitude = [t_detail.jd doubleValue];
            //		PlaceMark* t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
            PlaceMark* t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
            t_placeMark.mTag = 100 + i;
            NSInteger t_int = [t_detail.tip intValue];
            if (t_int > 0) {
                t_placeMark.ftime = t_int;
                t_placeMark.fl=[t_detail.fl intValue];
                t_placeMark.time=t_detail.time;
                [self.mapView addAnnotation:t_placeMark];
            }
            if (self.m_tfModel==self.tfmds[self.tfmds.count-1]) {
                [self.myanntion addObject:t_placeMark];
            }
            [locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
        }
        m_tag = 1;
        [m_dottedLineArray addObject:[self makePolylineWithLocations:locations]];
        [self.mapView addOverlay:[m_dottedLineArray objectAtIndex:0]];
        [locations removeAllObjects];
        
        for (int i=0; i<[m_tfModel.dotted_1_points count]; i++) {
            typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.dotted_1_points objectAtIndex:i];
            //			Place* t_place = [[[Place alloc] init] autorelease];
            Place* t_place = [[Place alloc] init];
            if (t_detail.qx.length>0) {
                t_place.name = @"东京预报";
                t_place.description = [NSString stringWithFormat:@"%@,风速%@,风力%@级(%@)",t_detail.time,t_detail.fs,t_detail.fl,t_detail.qx];
            }
            t_place.latitude = [t_detail.wd doubleValue];
            t_place.longitude = [t_detail.jd doubleValue];
            //		PlaceMark* t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
            PlaceMark* t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
            t_placeMark.mTag = 200 + i;
            NSInteger t_int = [t_detail.tip intValue];
            if (t_int > 0) {
                //			t_placeMark.fl = t_int + 100;
                t_placeMark.ftime = t_int;
                t_placeMark.fl=[t_detail.fl intValue];
                t_placeMark.time=t_detail.time;
                [self.mapView addAnnotation:t_placeMark];
            }
            
            if (self.m_tfModel==self.tfmds[self.tfmds.count-1]) {
                [self.myanntion addObject:t_placeMark];
            }
            [locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
        }
        m_tag = 2;
        [m_dottedLineArray addObject:[self makePolylineWithLocations:locations]];
        [self.mapView addOverlay:[m_dottedLineArray objectAtIndex:1]];
        [locations removeAllObjects];
        
        for (int i=0; i<[m_tfModel.dotted_2_points count]; i++) {
            typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.dotted_2_points objectAtIndex:i];
            //			Place* t_place = [[[Place alloc] init] autorelease];
            Place* t_place = [[Place alloc] init];
            if (t_detail.qx.length>0) {
                t_place.name = @"福州预报";
                t_place.description = [NSString stringWithFormat:@"%@,风速%@,风力%@级(%@)",t_detail.time,t_detail.fs,t_detail.fl,t_detail.qx];
            }
            t_place.latitude = [t_detail.wd doubleValue];
            t_place.longitude = [t_detail.jd doubleValue];
            //		PlaceMark* t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
            PlaceMark* t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
            t_placeMark.mTag = 300 + i;
            NSInteger t_int = [t_detail.tip intValue];
            if (t_int > 0) {
                //			t_placeMark.fl = t_int + 200;
                t_placeMark.ftime = t_int;
                t_placeMark.fl=[t_detail.fl intValue];
                t_placeMark.time=t_detail.time;
                
                [self.mapView addAnnotation:t_placeMark];
            }
            if (self.m_tfModel==self.tfmds[self.tfmds.count-1]) {
                [self.myanntion addObject:t_placeMark];
            }
            [locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
        }
        m_tag = 3;
        [m_dottedLineArray addObject:[self makePolylineWithLocations:locations]];
        [self.mapView addOverlay:[m_dottedLineArray objectAtIndex:2]];
        [locations removeAllObjects];
        
        for (int i=0; i<[m_tfModel.dotted_3_points count]; i++) {
            typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.dotted_3_points objectAtIndex:i];
            //			Place* t_place = [[[Place alloc] init] autorelease];
            Place* t_place = [[Place alloc] init];
            if (t_detail.qx.length>0) {
                t_place.name = @"台湾预报";
                t_place.description = [NSString stringWithFormat:@"%@,风速%@,风力%@级(%@)",t_detail.time,t_detail.fs,t_detail.fl,t_detail.qx];
            }
            t_place.latitude = [t_detail.wd doubleValue];
            t_place.longitude = [t_detail.jd doubleValue];
            //		PlaceMark* t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
            PlaceMark* t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
            t_placeMark.mTag = 500 + i;
            NSInteger t_int = [t_detail.tip intValue];
            if (t_int > 0) {
                //            t_placeMark.fl = t_int + 300;
                t_placeMark.ftime = t_int;
                t_placeMark.fl=[t_detail.fl intValue];
                t_placeMark.time=t_detail.time;
                [self.mapView addAnnotation:t_placeMark];
            }
            if (self.m_tfModel==self.tfmds[self.tfmds.count-1]) {
                [self.myanntion addObject:t_placeMark];
            }
            [locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
        }
        m_tag = 8;
        [m_dottedLineArray addObject:[self makePolylineWithLocations:locations]];
        [self.mapView addOverlay:[m_dottedLineArray objectAtIndex:3]];
        [locations removeAllObjects];
        
        return;
    }
    [[tfDetailView shareTfDetailView] showData:m_tfModel withNum:currentPlayPoint];
    
    typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.ful_points objectAtIndex:currentPlayPoint];
    //
    if (currentPlayPoint > 0) {
        [self.mapView removeOverlay:circle_10];
        [self.mapView removeOverlay:circle_7];
    }
    
    CLLocationCoordinate2D newloc = CLLocationCoordinate2DMake([t_detail.wd doubleValue], [t_detail.jd doubleValue]);
    circle_10 = nil;
    circle_7 = nil;
    circle_10 = [MKCircle circleWithCenterCoordinate:newloc radius:[t_detail.fl_10 doubleValue]*1000];
    circle_7 = [MKCircle circleWithCenterCoordinate:newloc radius:[t_detail.fl_7 doubleValue]*1000];
    [self.mapView addOverlay:circle_10];
    [self.mapView addOverlay:circle_7];
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"MMddHH"];
    NSDate *s_date = [dateformat dateFromString:t_detail.time];
    [dateformat setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *d_date = [dateformat stringFromDate:s_date];
    //	[dateformat release];
    
    //	Place* t_place = [[[Place alloc] init] autorelease];
    Place* t_place = [[Place alloc] init];
    t_place.name = [NSString stringWithFormat:@"时间:%@", d_date];
    t_place.description = [NSString stringWithFormat:@"经度:%@ 维度:%@ 中心风力:%@ 中心风速:%@ 中心气压:%@ 七级风圈半径:%@ 十级风圈半径:%@",t_detail.wd,t_detail.jd, t_detail.fl, t_detail.fs_max, t_detail.qy,t_detail.fl_7,t_detail.fl_10];
    t_place.latitude = [t_detail.wd doubleValue];
    t_place.longitude = [t_detail.jd doubleValue];
    //	PlaceMark *t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
    PlaceMark *t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
    t_placeMark.mTag = 400 + currentPlayPoint;
    t_placeMark.name=name;
    if (currentPlayPoint == [m_tfModel.ful_points count] - 1)
    {
        t_placeMark.fl = -2;
    }else
        t_placeMark.fl = [t_detail.fl intValue];
    //	t_placeMark.time=t_detail.time;
    [self.mapView addAnnotation:t_placeMark];
    if (self.tfmds.count>0) {
        if (self.m_tfModel==self.tfmds[self.tfmds.count-1]) {
            [self.myanntion addObject:t_placeMark];
        }
    }
    
    //	CLLocation *loc = [[[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude] autorelease];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude];
    [routesCentre removeAllObjects];
    [routesCentre addObject:loc];
    m_tagCenter = 1;
    
    if (canTouch == YES)
        [self centerMap];
    
    //mapView.centerCoordinate = t_placeMark.coordinate;
    
    [m_locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
    
    if ([m_locations count] > 2) {
        [m_locations removeObjectAtIndex:0];
    }
    
    m_tag = 4;
    
    [self.mapView addOverlay:[self makePolylineWithLocations:m_locations]];
    
    currentPlayPoint ++;
}

#pragma mark Bottom button action
//播放地图按钮
//可以播放
- (void)didPlayMap
{
    
    [[tfDetailView shareTfDetailView] setIfHidden:NO];
    
    m_tagLocation = 0;
    canTouch = YES;
    self.candw=NO;
    if ([m_locations count] > 0) {
        [m_locations removeAllObjects];
    }
    
    //	[mapView removeAnnotations:[mapView annotations]];
    //	[mapView removeOverlays:[mapView overlays]];
    [self.mapView removeOverlay:self.bfpl.overlay];
    [self.mapView removeOverlay:self.mkcirview.overlay];
    [self.mapView removeOverlay:self.mkcirview1.overlay];
    [self.mapView removeOverlay:self.rycpl.overlay];
    [self.mapView removeOverlay:self.bycpl.overlay];
    [self.mapView removeOverlay:self.blueycpl.overlay];
    [self.mapView removeOverlay:self.twycpl.overlay];
    [self.mapView removeOverlay:self.mkpl.overlay];
    [self.mapView removeAnnotations:self.myanntion];
    [self.mapView removeAnnotation:myplacemark];
    for (MKPolylineView *p in m_tfsxarray) {
        [self.mapView removeOverlay:p.overlay];
    }
    [m_tfsxarray removeAllObjects];
    [self performSelector:@selector(drawCordon)];
    
    circle_10 = nil;
    circle_7 = nil;
    
    if ([m_dottedLineArray count] > 0) {
        [m_dottedLineArray removeAllObjects];
    }
    
    [routesCentre removeAllObjects];
    if (m_firstPointArr.count>0) {
        [routesCentre addObject:[m_firstPointArr objectAtIndex:0]];
    }
    
    
    [self centerMap];
    [self.myanntion removeAllObjects];
    self.showTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(addAnn)
                                                    userInfo:nil
                                                     repeats:YES];
    currentPlayPoint = 0;
}

- (void) didStopMap
{
    for (int i=0; i<self.timelabs.count; i++) {
        UILabel *lab=self.timelabs[i];
        [lab removeFromSuperview];
    }//删除台风时间避免重用
    [self.timelabs removeAllObjects];
    self.candw=YES;
    [self performSelector:@selector(stopPlayTimer)];
    currentPlayPoint = 0;
    m_tagLocation = 0;
    
    [self.mapView removeAnnotations:[self.mapView annotations]];
    [self.mapView removeOverlays:[self.mapView overlays]];
    [self performSelector:@selector(drawCordon)];
    
    if ([m_dottedLineArray count] > 0) {
        [m_dottedLineArray removeAllObjects];
    }
    
    [routesCentre removeAllObjects];
    
    m_tagCenter = 1;
    for (int i=0; i<self.tfmds.count; i++) {
        self.m_tfModel=self.tfmds[i];
        [self showMapRoute];
    }
    
    //    NSMutableArray *locations = [[NSMutableArray alloc] init];
    //
    //	for (int i=0; i<[m_tfModel.dotted_points count]; i++) {
    //		typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.dotted_points objectAtIndex:i];
    //
    ////		Place* t_place = [[[Place alloc] init] autorelease];
    //        Place* t_place = [[Place alloc] init];
    //		t_place.name = @"北京预报";
    //		t_place.description = [NSString stringWithFormat:@"%@预报 东经:%@° 北纬:%@°", t_detail.tip, t_detail.jd, t_detail.wd];
    //		t_place.latitude = [t_detail.wd doubleValue];
    //		t_place.longitude = [t_detail.jd doubleValue];
    ////		PlaceMark* t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
    //        PlaceMark* t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
    //		t_placeMark.mTag = 100 + i;
    //		NSInteger t_int = [t_detail.tip intValue];
    //		if (t_int > 0) {
    //			t_placeMark.fl = t_int;
    //
    //			[mapView addAnnotation:t_placeMark];
    //		}
    //
    //		[locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
    //	}
    //	m_tag = 1;
    //	[m_dottedLineArray addObject:[self makePolylineWithLocations:locations]];
    //	[mapView addOverlay:[m_dottedLineArray objectAtIndex:0]];
    //	[locations removeAllObjects];
    //	for (int i=0; i<[m_tfModel.dotted_1_points count]; i++) {
    //		typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.dotted_1_points objectAtIndex:i];
    //
    ////		Place* t_place = [[[Place alloc] init] autorelease];
    //        Place* t_place = [[Place alloc] init];
    //		t_place.name = @"东京预报";
    //		t_place.description = [NSString stringWithFormat:@"%@预报 东经:%@° 北纬:%@°", t_detail.tip, t_detail.jd, t_detail.wd];
    //		t_place.latitude = [t_detail.wd doubleValue];
    //		t_place.longitude = [t_detail.jd doubleValue];
    ////		PlaceMark* t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
    //        PlaceMark* t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
    //		t_placeMark.mTag = 200 + i;
    //		NSInteger t_int = [t_detail.tip intValue];
    //		if (t_int > 0) {
    //			t_placeMark.fl = t_int + 100;
    //			[mapView addAnnotation:t_placeMark];
    //		}
    //
    //		[locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
    //	}
    //	m_tag = 2;
    //	[m_dottedLineArray addObject:[self makePolylineWithLocations:locations]];
    //	[mapView addOverlay:[m_dottedLineArray objectAtIndex:1]];
    //	[locations removeAllObjects];
    //	for (int i=0; i<[m_tfModel.dotted_2_points count]; i++) {
    //		typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.dotted_2_points objectAtIndex:i];
    //
    ////		Place* t_place = [[[Place alloc] init] autorelease];
    //        Place* t_place = [[Place alloc] init];
    //		t_place.name = @"福州预报";
    //		t_place.description = [NSString stringWithFormat:@"%@预报 东经:%@° 北纬:%@°", t_detail.tip, t_detail.jd, t_detail.wd];
    //		t_place.latitude = [t_detail.wd doubleValue];
    //		t_place.longitude = [t_detail.jd doubleValue];
    ////		PlaceMark* t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
    //        PlaceMark* t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
    //		t_placeMark.mTag = 300 + i;
    //		NSInteger t_int = [t_detail.tip intValue];
    //		if (t_int > 0) {
    //			t_placeMark.fl = t_int + 200;
    //			[mapView addAnnotation:t_placeMark];
    //		}
    //
    //		[locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
    //	}
    //	m_tag = 3;
    //	[m_dottedLineArray addObject:[self makePolylineWithLocations:locations]];
    //	[mapView addOverlay:[m_dottedLineArray objectAtIndex:2]];
    //	[locations removeAllObjects];
    //
    //	for (int i=0; i<[m_tfModel.ful_points count]; i++) {
    //		typhoonDetailModel *t_detail = (typhoonDetailModel *)[m_tfModel.ful_points objectAtIndex:i];
    //
    //		//NSString *year = [[t_detail objectForKey:@"time"] substringToIndex:4];
    //
    //		NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    //		[dateformat setDateFormat:@"MMddHH"];
    //		NSDate *s_date = [dateformat dateFromString:t_detail.time];
    //		[dateformat setDateFormat:@"MM月dd日 HH时"];
    //		NSString *d_date = [dateformat stringFromDate:s_date];
    ////		[dateformat release];
    //
    ////		Place* t_place = [[[Place alloc] init] autorelease];
    //        Place* t_place = [[Place alloc] init];
    //		if (i == [m_tfModel.ful_points count] - 1) {
    //			t_place.name = @"当前位置";
    //		}else {
    //			t_place.name = [NSString stringWithFormat:@"时间:%@", d_date];
    //		}
    //		t_place.description = [NSString stringWithFormat:@"中心风力:%@ 中心风速:%@ 中心气压:%@", t_detail.fl, t_detail.fs_max, t_detail.qy];
    //		t_place.latitude = [t_detail.wd doubleValue];
    //		t_place.longitude = [t_detail.jd doubleValue];
    ////		PlaceMark *t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
    //        PlaceMark *t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
    //		t_placeMark.mTag = 400 + i;
    //		if (i == [m_tfModel.ful_points count] - 1)
    //		{
    //			t_placeMark.fl = -2;
    //		}else
    //			t_placeMark.fl = [t_detail.fl intValue];
    //
    //		[mapView addAnnotation:t_placeMark];
    //
    //		[locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
    //
    //		if (i == [m_tfModel.ful_points count] - 1) {
    //			[[tfDetailView shareTfDetailView] showData:m_tfModel withNum:i];
    //
    ////			CLLocation *loc = [[[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude] autorelease];
    //            CLLocation *loc = [[CLLocation alloc] initWithLatitude:t_placeMark.coordinate.latitude longitude:t_placeMark.coordinate.longitude] ;
    //			[routesCentre addObject:loc];
    //			CLLocationCoordinate2D newloc = CLLocationCoordinate2DMake([t_detail.wd doubleValue], [t_detail.jd doubleValue]);
    //			MKCircle *t_circle_10 = [MKCircle circleWithCenterCoordinate:newloc radius:[t_detail.fl_10 doubleValue]*1000];
    //			MKCircle *t_circle_7 = [MKCircle circleWithCenterCoordinate:newloc radius:[t_detail.fl_7 doubleValue]*1000];
    //			[mapView addOverlay:t_circle_10];
    //			[mapView addOverlay:t_circle_7];
    //		}
    //	}
    //	m_tag = 4;
    //
    //	[mapView addOverlay:[self makePolylineWithLocations:locations]];
    //
    //    //根据线路确定呈现范围
    //	[self centerMap];
}

//定位地图按钮
- (void) didFindSelf
{
    [self.mapView removeOverlay:self.mkpl.overlay];
    self.isbz=YES;
    if (self.candw==YES) {
        //        for (int i=0; i<self.tfmds.count; i++) {
        
        NSMutableArray *locations = [[NSMutableArray alloc] init];
        if (!strLat || [strLat isEqualToString:@""]) {
//            [ShareFun alertNotice:nil withMSG:@"获取您的位置信息失败，请在设置中打开定位服务！" cancleButtonTitle:@"确定" otherButtonTitle:nil];
            UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"获取您的位置信息失败，请在设置中打开定位服务！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            t_alertView.tag=10;
            [t_alertView show];
            return;
        }
        m_tagCenter = 0;
        m_tagLocation++;
        canTouch = NO;
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[strLat doubleValue] longitude:[strLng doubleValue]];
        [routes addObject:loc];
        
        //	Place* t_place = [[[Place alloc] init] autorelease];
        Place* t_place = [[Place alloc] init];
        t_place.name = @"我的位置";
        t_place.latitude = [strLat doubleValue];
        t_place.longitude = [strLng doubleValue];
        //	PlaceMark* t_placeMark = [[[PlaceMark alloc] initWithPlace:t_place] autorelease];
        PlaceMark* t_placeMark = [[PlaceMark alloc] initWithPlace:t_place];
        t_placeMark.fl = -1;
        
        [self.mapView addAnnotation:t_placeMark];
        
        [self centerMap];
        m_tag=7;
        
        typhoonYearModel *ty=m_tfModel;
        NSString *name=ty.name;
        if ([name rangeOfString:@"风"].location!=NSNotFound) {
            NSArray *timeArray1=[name componentsSeparatedByString:@"风"];
            name=[timeArray1 objectAtIndex:1];
        }
        if (ty.ful_points.count>0) {
            typhoonDetailModel *t_detail = (typhoonDetailModel *)[ty.ful_points objectAtIndex:ty.ful_points.count-1];
            CLLocation *tfloc = [[CLLocation alloc] initWithLatitude:[t_detail.wd doubleValue] longitude:[t_detail.jd doubleValue]];
            [locations addObject:[NSString stringWithFormat:@"%f,%f", [strLat doubleValue], [strLng doubleValue]]];
            [locations addObject:[NSString stringWithFormat:@"%f,%f", [t_detail.wd doubleValue], [t_detail.jd doubleValue]]];
            
            [self.mapView addOverlay:[self makePolylineWithLocations:locations]];
            CLLocationDistance kilometers=[tfloc distanceFromLocation:loc];  //米
            self.distance=[NSString stringWithFormat:@"%.0f",kilometers/1000];
            
            //    CLLocation *tcloc = [[CLLocation alloc] initWithLatitude:([t_detail.wd doubleValue]+[strLat doubleValue])/2 longitude:([t_detail.jd doubleValue]+[strLng doubleValue])/2];
            Place* t_place1 = [[Place alloc] init];
            t_place1.name = [NSString stringWithFormat:@"您距离%@台风中心%@公里",name,self.distance];
            t_place1.latitude = ([t_detail.wd doubleValue]+[strLat doubleValue])/2;
            t_place1.longitude = ([t_detail.jd doubleValue]+[strLng doubleValue])/2;
            
            PlaceMark* t_placeMark1 = [[PlaceMark alloc] initWithPlace:t_place1];
            t_placeMark1.fl = -5;
            t_placeMark1.mTag=111;
            myplacemark=t_placeMark1;
            [self.mapView addAnnotation:t_placeMark1];
            
            [self.mapView selectAnnotation:t_placeMark1 animated:YES];
        }
    }
    
    
    //    }
}

//图例按钮事件
- (void)didImageExplain
{
    if (m_viewLegend.frame.origin.y >= 0) {
        if (delegate && [delegate respondsToSelector:@selector(showBottom)]) {
            [delegate showBottom];
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [m_viewLegend setFrame:CGRectMake(0, -kScreenHeitht, self.width, kScreenHeitht-20-44)];
        if (kSystemVersionMore7) {
            [m_viewLegend setFrame:CGRectMake(0, -kScreenHeitht-20, self.width, kScreenHeitht-20-44)];
        }
        
        [UIView commitAnimations];
    }else {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [m_viewLegend setFrame:CGRectMake(0, 0, self.width, kScreenHeitht-20-44)];
        [UIView commitAnimations];
    }
}

- (void)changeMapMode:(NSInteger)t_mode
{
    if (t_mode == 1)
    {
        self.mapView.mapType = MKMapTypeStandard;
    }
    else if (t_mode == 2)
    {
        [self.mapView setMapType:MKMapTypeHybrid];
    }
}

//地图切换按钮事件
- (void)didChangeMap
{
    NSInteger t_mapMode;
    if (self.mapView.mapType == MKMapTypeHybrid) {
        self.mapView.mapType = MKMapTypeStandard;
        t_mapMode = 1;
    }else {
        [self.mapView setMapType:MKMapTypeHybrid];
        t_mapMode = 2;
    }
    if (delegate && [delegate respondsToSelector:@selector(choiceMapMode:)]) {
        [delegate choiceMapMode:t_mapMode];
    }
}
- (void) showtfview
{
    for (int i=0; i<self.timelabs.count; i++) {
        UILabel *lab=self.timelabs[i];
        [lab removeFromSuperview];
    }//删除台风时间避免重用
    self.candw=YES;
    [self performSelector:@selector(stopPlayTimer)];
    currentPlayPoint = 0;
    m_tagLocation = 0;
    
    [self.mapView removeAnnotations:[self.mapView annotations]];
    [self.mapView removeOverlays:[self.mapView overlays]];
    [self performSelector:@selector(drawCordon)];
    
    if ([m_dottedLineArray count] > 0) {
        [m_dottedLineArray removeAllObjects];
    }
    
    [routesCentre removeAllObjects];
    if (self.tfmds.count>1) {
        m_tagCenter = 2;
    }
    else{
        m_tagCenter = 1;
    }
    for (int i=0; i<self.tfmds.count; i++) {
        self.m_tfModel=self.tfmds[i];
        [self showMapRoute];
    }
    
}
//点击返回按钮时判断图例是否展示
- (BOOL)ifLegendDisplay
{
    if (m_viewLegend.frame.origin.y >= 0) {
        if (delegate && [delegate respondsToSelector:@selector(showBottom)]) {
            [delegate showBottom];
        }
        [m_viewLegend setFrame:CGRectMake(0, 0, self.width, kScreenHeitht-20-44)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [m_viewLegend setFrame:CGRectMake(0, -kScreenHeitht-20, self.width, kScreenHeitht-20-44)];
        [UIView commitAnimations];
        return YES;
    }else {
        return NO;
    }
}

#pragma mark locationManager CALLBACK_API
//定位成功：获取经纬度信息
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];
    
    strLat = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.4f",newLocation.coordinate.latitude]];
    strLng = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.4f",newLocation.coordinate.longitude]];
}

//定位失败，提示
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    static int i = 0;
    if (i == 0) {
//        [ShareFun alertNotice:nil withMSG:@"获取您的位置信息失败，请在设置中打开定位服务！" cancleButtonTitle:@"确定" otherButtonTitle:nil];
        i++;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
#pragma mark NSTimer
//台风旋转的动画
-(void)renderView
{
    int j = m_i%4;
    
    CGAffineTransform transform;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatCount:1];
    
    transform = CGAffineTransformMakeRotation(-j*M_PI/2);
    typhoonImageView.transform = transform;
    [UIView commitAnimations];
    
    if (++ m_i == 4)
        m_i = 0;
}
-(void)renderView1
{
    int j = m_i1%4;
    
    CGAffineTransform transform;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatCount:1];
    
    transform = CGAffineTransformMakeRotation(-j*M_PI/2);
    self.sectfimg.transform=transform;
    [UIView commitAnimations];
    
    if (++ m_i1 == 4)
        m_i1 = 0;
}
-(void)renderView2
{
    int j = m_i2%4;
    
    CGAffineTransform transform;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatCount:1];
    
    transform = CGAffineTransformMakeRotation(-j*M_PI/2);
    self.thrtfimg.transform=transform;
    [UIView commitAnimations];
    
    if (++ m_i2 == 4)
        m_i2 = 0;
}
//台风旋转的定时器
- (void)startTime 
{
    typhoonDetailModel *t=self.m_tfModel.ful_points.lastObject;
    NSInteger img=t.fl.integerValue;
    self.bigtfimg=@"台风.png";
    
    //    if (img == -2)
    //    {
    //        self.bigtfimg=@"yellowbig.png";
    //    }
    //    else if (img <= 7 && img != -2) {
    //        self.bigtfimg=@"greenbig.png";
    //    }
    //    else if (img <= 9 && img >= 8) {
    //       
    //        self.bigtfimg=@"bluebig.png";
    //    }
    //    else if (img <= 11 && img >= 10) {
    //   
    //        self.bigtfimg=@"yellowbig.png";
    //    }
    //    else if (img <= 13 && img >= 12) {
    //     
    //        self.bigtfimg=@"darkbig.png";
    //    }
    //    else if (img <= 15 && img >= 14) {
    //       
    //        self.bigtfimg=@"cyanbig.png";
    //    }
    //    else if (img >= 16 && img < 24) {
    //        
    //        self.bigtfimg=@"redbig.png";
    //    }
    
    if(typhoonPlayTimer == nil)
    {
        m_i = 1;
        
        //		typhoonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-15, -15, 30, 30)];
        //		[typhoonImageView setImage:[UIImage imageNamed:self.bigtfimg]];
        [typhoonImageView setBackgroundColor:[UIColor clearColor]];
        self.typhoonPlayTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                               selector:@selector(renderView)
                                                               userInfo:nil repeats:YES];
    }
    if(self.sectytimer == nil)
    {
        m_i1 = 1;
        //        self.sectfimg= [[UIImageView alloc] initWithFrame:CGRectMake(-15, -15, 30, 30)];
        self.sectytimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                         selector:@selector(renderView1)
                                                         userInfo:nil repeats:YES];
    }
    if(self.thrtytimer == nil)
    {
        m_i2 = 1;
        //        self.thrtfimg= [[UIImageView alloc] initWithFrame:CGRectMake(-15, -15, 30, 30)];
        self.thrtytimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                         selector:@selector(renderView2)
                                                         userInfo:nil repeats:YES];
    }
}

- (void)stopTyphoonTimer
{
    if (typhoonPlayTimer) {
        [typhoonPlayTimer invalidate];
        //		[typhoonPlayTimer release];
        typhoonPlayTimer = nil;
    }
}

- (void)stopPlayTimer
{
    if (showTimer) {
        [showTimer invalidate];
        //		[showTimer release];
        showTimer = nil;
    }
}
- (UIColor *)getColor:(NSString *)hexColor
{
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end

