//
//  AddCityViewController.h
//  ZtqCountry
//
//  Created by 林炳阳	 on 14-6-26.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCityViewController.h"
#import "ShareFun.h"
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <MapKit/MKReverseGeocoder.h>
#import <MapKit/MKPlacemark.h>
#import"BaseViewController.h"
@protocol  AddCityViewControllerDelegate<NSObject>

-(void)addCityWithSign:(int)sign;

@end


@interface AddCityViewController : UIViewController<UISearchBarDelegate,CLLocationManagerDelegate,
MKReverseGeocoderDelegate,
UIAlertViewDelegate>{
    NSMutableArray *mid,*m_provinceData,*hot_city;  //city
    BOOL hasLocated;
    CLLocationManager *m_locationManager;
    UIImageView *m_cmBg;
    __weak id<AddCityViewControllerDelegate> delegate;
    
    TreeNode *m_province;
	TreeNode *m_allCity;
	
	
}
@property(retain,nonatomic)NSArray *arr,*idarrr;
@property(retain,nonatomic)NSString *DWcity,*DWid;
@property (nonatomic, weak)id<AddCityViewControllerDelegate> delegate;
@property(strong,nonatomic)NSDictionary *dicID;
@property(strong,nonatomic)NSDictionary *dwdic;

@property(assign)float barHeight;
@property(retain,nonatomic)UIImageView *navigationBarBg;
@property(strong,nonatomic)NSString *morencity;
@end
