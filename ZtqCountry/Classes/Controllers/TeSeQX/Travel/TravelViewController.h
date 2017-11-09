//
//  TravelViewController.h
//  ZtqNew
//
//  Created by linxg on 12-6-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetXMLData.h"
#import "moreTravelController.h"


@interface TravelViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{

	UITableView *m_tableView;
	UISearchBar *m_searchBar;
	
	TreeNode *m_province;
	TreeNode *m_allCity,*m_travelcity;
	
	NSMutableArray *m_provinceData;
	NSMutableArray *m_cityData;
    NSMutableArray *cityid;
    UIImageView *m_gdBg;
    NSMutableArray *searcharr,*searcharrid;
    NSMutableArray *secarrs;
    BOOL isprovice;
	int m_provinceId;
	int sec;
	bool isShow;
	bool isSearch;
}
@property(assign)float barhight;
@property(strong,nonatomic)NSString *provicename;
@property(strong,nonatomic)NSMutableArray *citys,*cityids;
- (void)setDataSource:(TreeNode *)t_province withCitys:(TreeNode *)t_citys;
- (void)loadProvinceList;
- (void)loadCityList;
- (void)rightBtn;
@end
