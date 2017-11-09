//
//  MapView.h
//  ZtqCountry
//
//  Created by Admin on 15/7/14.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyPoint.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapLocationKit/AMapLocationKit.h>
@protocol mapviewDelegate<NSObject>

-(void)footWTAction;
-(void)TravelAction;
-(void)typhoonAction;
-(void)MapWarnWithInfos:(NSArray *)infos Withindex:(NSInteger)index;

@end
@interface MapView : UIView<CLLocationManagerDelegate,MKMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>{
    CLLocationManager    *locationManager;
    MKMapView            *m_mapView;
}
@property(nonatomic,retain)AMapLocationManager *locationManager;
@property(strong,nonatomic)MyPoint *mypoint;
@property(strong,nonatomic)UILabel *loctalab;//当前位置
@property(strong,nonatomic)UILabel *wxlab;//温馨提示
@property(strong,nonatomic)UIImageView *bg,*imageview;
@property(strong,nonatomic)UILabel *ctlab;
@property(strong,nonatomic)NSString *log,*lat;//经纬
@property(strong,nonatomic)NSString *provice;//定位省
@property(nonatomic, weak) id<mapviewDelegate>delegate;
@property (nonatomic, strong) AMapSearchAPI *search;
@property(strong,nonatomic)NSArray *warnlists;
@property(retain,nonatomic)NSString *DWid;
@property(strong,nonatomic)NSMutableArray *btnarrs;
-(void)startLocation;
-(void)Getyjxx_grad_indexData;
@end
