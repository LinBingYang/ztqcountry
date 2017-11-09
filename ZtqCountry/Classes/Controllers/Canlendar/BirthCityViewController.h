//
//  BirthCityViewController.h
//  ZtqCountry
//
//  Created by Admin on 15/12/8.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BirthCityViewController : UIViewController<UISearchBarDelegate,
UITableViewDelegate,UITableViewDataSource>{
    UITableView *m_tableView;
    UISearchBar *m_searchBar;
    
    TreeNode *m_province;
    TreeNode *m_allCity;
    
    NSMutableArray *m_provinceData;
    NSMutableArray *m_cityData;
    
    int m_provinceId;
    int sec;
    bool isShow;
    bool isSearch;
    BOOL hasLocated;
    BOOL isprovice;
   
    UIImageView *m_cmBg;
}
@property (nonatomic, weak)id delegate;
@property(nonatomic,strong)NSString *type;
@property (strong, nonatomic) UIButton * leftBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
- (void)setDataSource:(TreeNode *)t_province withCitys:(TreeNode *)t_citys;
- (void)loadProvinceList;
- (void)loadCityList;

@end
