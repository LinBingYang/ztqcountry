//
//  SelectCityViewController.h
//  ZtqCountry
//
//  Created by 林炳阳	 on 14-6-30.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetXMLData.h"
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <MapKit/MKReverseGeocoder.h>
#import <MapKit/MKPlacemark.h>
#import"BaseViewController.h"
@class SelectCityViewController;
@protocol  SelectCityViewControllerDelegate<NSObject>
@required

-(void)didSelectedCity:(NSDictionary *)cityData;

@end
@interface SelectCityViewController : UIViewController<UISearchBarDelegate,
UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,
UIAlertViewDelegate>{
    __weak id<SelectCityViewControllerDelegate> delegate;
	
	UITableView *m_tableView;
	UISearchBar *m_searchBar;
	
	TreeNode *m_province;
	TreeNode *m_allCity;
	
	NSMutableArray *m_provinceData;
	NSMutableArray *m_cityData;
	NSMutableArray *secarrs;
    NSMutableArray *searcharr;
	int m_provinceId;
	int sec;
	bool isShow;
	bool isSearch;
	BOOL hasLocated;
    BOOL isprovice;
    CLLocationManager *m_locationManager;
    UIImageView *m_cmBg;
}
@property (nonatomic, weak)id delegate;
@property(nonatomic,strong)NSString *type;
@property (strong, nonatomic) UIButton * leftBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
@property(strong,nonatomic)NSMutableArray *citys;
- (void)setDataSource:(TreeNode *)t_province withCitys:(TreeNode *)t_citys;
- (void)loadProvinceList;
- (void)loadCityList;
@end
