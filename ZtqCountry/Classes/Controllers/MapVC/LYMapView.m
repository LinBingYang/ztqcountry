//
//  LYMapView.m
//  ZtqCountry
//
//  Created by Admin on 15/7/3.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "LYMapView.h"

@implementation LYMapView
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.marr=[[NSMutableArray alloc]init];
        self.citynamearr=[[NSMutableArray alloc]init];

        m_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht-50)];
        //显示用户位置
        m_mapView.showsUserLocation = NO;
        //是否可滑动
        m_mapView.scrollEnabled = YES;
        //是否可放大缩小
        m_mapView.zoomEnabled = YES;
        m_mapView.delegate = self;
        
        [self addSubview:m_mapView];
        _geocoder=[[CLGeocoder alloc]init];
        [self getgz_tour_hotcity_list];
    }
    return self;
}
-(void)getgz_tour_hotcity_list{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *ftlist = [[NSMutableDictionary alloc]init];
    
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [t_b setObject:ftlist forKey:@"gz_tour_hotcity_list"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        
        NSDictionary *b=[returnData objectForKey:@"b"];
        NSDictionary *locwea=[b objectForKey:@"gz_tour_hotcity_list"];
        NSArray *hot_tour_list=[locwea objectForKey:@"hot_tour_list"];
        [self getlocation:hot_tour_list];
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
-(void)getlocation:(NSArray *)hotlylist{

    [self.marr removeAllObjects];
    [self.citynamearr removeAllObjects];
    for (int i=0; i<hotlylist.count; i++) {
        NSString *city_id=[hotlylist[i] objectForKey:@"city_id"];
        NSString *stationlat=[hotlylist[i] objectForKey:@"stationlat"];
        NSString *stationlon=[hotlylist[i] objectForKey:@"stationlon"];
        NSString *city_url=[hotlylist[i] objectForKey:@"city_url"];
        NSString *city_name=[hotlylist[i] objectForKey:@"city_name"];
        _coordinate.latitude=stationlat.floatValue;
        _coordinate.longitude=stationlon.floatValue;
        LYMark *lymark=[[LYMark alloc]initWithCoordinate:_coordinate andTitle:city_name];
        lymark.mTag=i;
        lymark.cityid=city_id;
        lymark.iconame=city_url;
        [self.marr addObject:city_id];
        [self.citynamearr addObject:city_name];
        [m_mapView addAnnotation:lymark];
//        m_mapView.region = MKCoordinateRegionMake(_coordinate, MKCoordinateSpanMake(1.2, 1.2));
    }
    [self centerMap];
}
-(void) centerMap {
   
    CLLocationCoordinate2D centercoordinate;
    centercoordinate.latitude=31.9;
    centercoordinate.longitude=110.3;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centercoordinate, 1500, 1500);
   
    region.span.latitudeDelta=25;
    region.span.longitudeDelta=25;
    region.center.latitude=31.9;
    region.center.longitude=110.3;
    
    [m_mapView setRegion:region animated:YES];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
   
//    if ([annotation isKindOfClass:[LYMark class]]) {
//        //如果是自己的位置的大头针,这个大头针将不重用
//        LYMark *t_point = (LYMark *)annotation;
//        MKAnnotationView *view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:[annotation title]];
//        if (view == nil)
//        {
//            //			view = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]] autorelease];
//            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]];
//            view.tag=t_point.mTag;
//        }
//        else
//        {
//            view.annotation = annotation;
//        }
//        
//        EGOImageView *ego=[[EGOImageView alloc]initWithFrame:CGRectMake(-27.5, 0, 55, 55)];
//        [ego setImageURL:[ShareFun makeImageUrl:t_point.iconame]];
//        ego.userInteractionEnabled=YES;
//        [view addSubview:ego];
//        view.tag=t_point.mTag;
////        [view setImage:ego.image];
//        view.canShowCallout = NO;
//        
//        
//        //        [view setImage:[UIImage imageNamed:@"定位符.png"]];
//        
//        return view;
//    }
    if ([annotation isKindOfClass:[LYMark class]]) {
        //如果是自己的位置的大头针,这个大头针将不重用
        LYMark *t_point = (LYMark *)annotation;
        
        MKAnnotationView *view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:[annotation title]];
        
        if (view == nil)
        {
            
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]];
            EGOImageView *imgview = [[EGOImageView alloc] initWithFrame:CGRectMake(-27.5,-27.5, 55, 55)];
            imgview.userInteractionEnabled=YES;
            [imgview setImageURL:[ShareFun makeImageUrl:t_point.iconame]];
            [view addSubview:imgview];
//            view.canShowCallout=YES;
            view.tag = t_point.mTag;
        }
        else
        {
            view.annotation = annotation;
        }
        return view;
//        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:[annotation title]];
//        if (annotationView == nil) {
//            annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:[annotation title]];
//        }
//        //设置让注解视图显示的Model 内容
//        annotationView.annotation = annotation;
//        for (UIView * view in [annotationView subviews])
//            
//        {
//            
//            [view removeFromSuperview];
//            
//        }
//
//        annotationView.image=nil;
//        annotationView.userInteractionEnabled=YES;
////        annotationView.centerOffset = CGPointMake(5,5);
//        
////        NSURL *url = [ShareFun makeImageUrl:t_point.iconame];
////        dispatch_queue_t queue =dispatch_queue_create("loadtrouImage",NULL);
////        dispatch_async(queue, ^{
////            
////            NSData *resultData = [NSData dataWithContentsOfURL:url];
////            UIImage *img = [UIImage imageWithData:resultData];
////           
////            dispatch_sync(dispatch_get_main_queue(), ^{
////                if (img) {
//////                    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
//////                    bgimg.image=img;
//////                    bgimg.userInteractionEnabled=YES;
//////                    [annotationView addSubview:bgimg];
////                    [annotationView setImage:img];
////                    annotationView.frame=CGRectMake(0, 0, 55, 55);
////                    annotationView.tag=t_point.mTag;
//////                    annotationView.canShowCallout=NO;
////                    
////                }
////                
////            });
////            
////        });
//        
//        EGOImageView *ego=[[EGOImageView alloc]initWithFrame:CGRectMake(-27.5, 0, 55, 55)];
//        [ego setImageURL:[ShareFun makeImageUrl:t_point.iconame]];
//        ego.userInteractionEnabled=YES;
////        [annotationView addSubview:ego];
//        annotationView.tag=t_point.mTag;
////         annotationView.canShowCallout=YES;
//        [annotationView setImage:ego.image];
//        annotationView.frame=CGRectMake(0, 0, 55, 55);
//        return annotationView;
    }
    
    return nil;
    
    
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[LYMark class]]) {
    NSInteger tag=view.tag;
    if ([self.delegate respondsToSelector:@selector(lyclick:Withcityname:)]) {
        [self.delegate lyclick:self.marr[tag] Withcityname:self.citynamearr[tag]];
    }
    }
}

@end
