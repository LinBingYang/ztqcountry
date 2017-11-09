//
//  LYMapView.h
//  ZtqCountry
//
//  Created by Admin on 15/7/3.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LYMark.h"
#import "EGOImageView.h"
@class LYMapView;
@protocol lyDelegate <NSObject>

- (void)lyclick:(NSString *)cityid Withcityname:(NSString *)cityname;

@end
@interface LYMapView : UIView<CLLocationManagerDelegate,MKMapViewDelegate>{
    CLLocationManager    *locationManager;
    MKMapView            *m_mapView;
    CLGeocoder *_geocoder;
    CLLocationCoordinate2D _coordinate;
}
@property(strong,nonatomic)NSMutableArray *marr,*citynamearr;
@property(strong,nonatomic)UIImageView *bgimg;
@property(strong,nonatomic)EGOImageView *img;
@property (weak, nonatomic) id<lyDelegate>delegate;
@end
