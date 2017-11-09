//
//  CityManageViewController.h
//  ZtqCountry
//
//  Created by linxg on 14-6-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
#import "AddCityViewController.h"
#import "SstqModel.h"
#import "QQFirstVC.h"
#import "WindowAndRainVC.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "ZJSwitch.h"
@protocol CityManageCellEditDelegate <NSObject>


-(void)cityManageCellMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
-(void)cityManageCellDeleteRowAtIndexPath:(NSIndexPath *)sourceIndexPath;
-(void)citymanageCellSelectionAtIndexPath:(int )sourceIndexPath;

@end


@interface CityManageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,
MKReverseGeocoderDelegate,
UIAlertViewDelegate,AddCityViewControllerDelegate,AMapLocationManagerDelegate>{
    UITableView *m_tableview;
    NSArray *timearr;
    NSArray *titlearr;
    NSMutableArray *m_array,*arr;
    TreeNode *m_allCity;
    TreeNode *m_allprovice;
    CLLocationManager *m_locationManager;
    
}
@property(retain,nonatomic)NSString *swdwcity,*swdwid;//开关
@property(strong,nonatomic)NSString *provice;
@property(retain,nonatomic)NSString *DWcity,*city;
@property(nonatomic,retain)AMapLocationManager *locationManager;
@property(retain,nonatomic)NSDictionary *dic;
@property(strong,nonatomic)UIButton *addBtn,*editBtn;
@property(nonatomic ,assign) BOOL isClick,isDW;
//@property(nonatomic ,assign) BOOL isDW;
@property(nonatomic, weak) id<CityManageCellEditDelegate>delegate;
@property(strong,nonatomic)SstqModel *sstqmodel;
@property(strong,nonatomic)NSMutableArray *marr;
@property(strong,nonatomic)ZJSwitch *zjswitch;
- (void) startLocation;
@end
