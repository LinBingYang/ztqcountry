//
//  typhoonView.h
//  ZtqNew
//
//  Created by lihj on 12-11-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Place.h"
#import "PlaceMark.h"
#import "typhoonYearModel.h"
#import "typhoonDetailModel.h"

#import "MyPoint.h"

@class typhoonView;
@protocol typhoonViewDelegate <NSObject>
@required

-(void)playMapOver;
-(void)choiceMapMode:(NSInteger)t_mode;
-(void)showBottom;
-(void)pushsetMapData:(typhoonYearModel *)t_model withNum:(NSInteger)t_num withType:(NSInteger)t_type;

@end

@interface typhoonView : UIView <MKMapViewDelegate, CLLocationManagerDelegate> {
    
    __weak id <typhoonViewDelegate> delegate;
    
    
    PlaceMark* m_points;
    id superClass;
    CLLocationManager *_locationManager;
//    MKMapView* mapView;
    MKPolyline *routeLine;
    
    MKCircle* circle_10;
    MKCircle* circle_7;
    
    NSMutableArray *routesCentre;//未加定位的范围
    NSMutableArray *routes;//用来确定现实范围
    NSMutableArray *m_locations;
    NSMutableArray *m_dottedLineArray;
    NSMutableArray *m_tfsxarray;
    NSArray *m_firstPointArr;
    
    NSInteger m_tag;
    NSInteger m_tagCenter;
    NSInteger m_tagLocation;
    NSInteger currentPlayPoint;
    
    UIView *m_viewLegend;	//图例的VIEW
    
    NSString *strLat;	//定位的经度
    NSString *strLng;	//定位的纬度
    
    UIImageView *typhoonImageView;
    
    NSTimer *typhoonPlayTimer;	//台风旋转定时器
    NSTimer* showTimer;
    int m_i,m_i1,m_i2;
    
    MKAnnotationView *m_MKAnnView;
    
    typhoonYearModel *m_tfModel;
    
    BOOL canTouch;
    BOOL candw;
    NSInteger touchInt;
     PlaceMark *myplacemark;
}
@property(strong,nonatomic)MKMapView* mapView;
@property (nonatomic, weak)id delegate;
@property (nonatomic, strong) typhoonYearModel * m_tfModel;
@property (nonatomic, strong) NSTimer * showTimer;
@property (nonatomic, strong) NSTimer * typhoonPlayTimer;
@property (nonatomic, strong) NSTimer * sectytimer,*thrtytimer;
@property(assign)BOOL candw,isbz;
@property(nonatomic,strong)NSString *bigtfimg;

- (void) setMapModel:(typhoonYearModel *)tf_model;
- (void) centerMap;
//显示两点之间的线路
- (void) showMapRoute;
- (MKPolyline *)makePolylineWithLocations:(NSMutableArray *)newLocations;

- (void) didPlayMap;
- (void) didStopMap;
- (void) didChangeMap;
- (void) didFindSelf;
- (void) didImageExplain;

- (BOOL)ifLegendDisplay;
- (void)changeMapMode:(NSInteger)t_mode;

@property(nonatomic,strong)UIImageView *img;

@property(strong,nonatomic)NSString *colorstr,*color48;
@property(strong,nonatomic)MyPoint *mypoint;
@property(strong,nonatomic)NSString *distance;
@property(strong,nonatomic)UILabel *lab,*lab1;
@property(strong,nonatomic)MKAnnotationView *anview;
@property(strong,nonatomic)MKPolylineView *mkpl;

@property(strong,nonatomic)NSArray *tfmds;
@property(strong,nonatomic)MKPolylineView *bfpl,*rycpl,*bycpl,*blueycpl,*twycpl;
@property(strong,nonatomic)MKCircleView *mkcirview,*mkcirview1;//第一点路线
@property(strong,nonatomic)NSMutableArray *myanntion;//第一点标注
@property(strong,nonatomic)NSMutableArray *allloctions;
@property(strong,nonatomic)UIImageView *sectfimg,*thrtfimg;
@property(strong,nonatomic)UILabel *rlab,*bluelab,*blacklab;
@property(strong,nonatomic)NSMutableArray *timelabs;
@end

