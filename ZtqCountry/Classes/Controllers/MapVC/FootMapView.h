//
//  FootMapView.h
//  ZtqCountry
//
//  Created by Admin on 15/7/1.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyPoint.h"
#import "FootMark.h"
#import "FootInfoAleartView.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
@interface FootMapView : UIView<CLLocationManagerDelegate,MKMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>{
    CLLocationManager    *locationManager;
    MKMapView            *m_mapView;
    CLGeocoder *_geocoder;
     CLLocationCoordinate2D startCoordinate;
    CLLocationCoordinate2D endCoordinate;
    CLLocationCoordinate2D _coordinate;
}
@property(nonatomic,retain)AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *search;
@property(strong,nonatomic)NSString *log,*lat;//经纬
@property(strong,nonatomic)NSMutableArray *marr;
@property(strong,nonatomic)UIImageView *imageview;
@property(strong,nonatomic)NSString *titlecity;
@property(strong,nonatomic)MyPoint *mypoint;
@property(strong,nonatomic)MKRoute *route;
@property(strong,nonatomic)UIImageView *img;
@property(strong,nonatomic)NSMutableArray *marks;
@property(strong,nonatomic)FootInfoAleartView *footaleart;
@property(strong,nonatomic)NSString *startimg,*endimg;
-(void)startaddress:(NSString *)startcity Withendaddress:(NSString *)endcity withstratcoor:(CLLocationCoordinate2D)startcoor withendcoor:(CLLocationCoordinate2D)endcoor;
@end
