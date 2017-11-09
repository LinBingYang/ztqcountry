//
//  MapVC.h
//  ZtqCountry
//
//  Created by Admin on 15/6/23.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "typhoonView.h"
#import "typhoonYearModel.h"
#import "TFListView.h"
#import "NewTflistView.h"
#import "FootMapView.h"
#import "LYMapView.h"
#import "TravelViewController.h"
#import "moreTravelController.h"
#import "TravelCollectVC.h"
#import "TLViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>

@interface MapVC : UIViewController<tflistDelegate,UITextFieldDelegate,lyDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate, AMapSearchDelegate,tfAlertDelegate>{
    typhoonView *m_typhoonView;
    typhoonYearModel *tf_yearModel;
    
    UIBarButtonItem *m_btnPlay;
    NSMutableArray *tf_list;
    NSInteger m_mapMode;
    NSString *m_title;
    UIView *m_viewLegend;	//图例的VIEW
    NewTflistView *newtflistview;
    
     CLGeocoder *_geocoder;
    CLLocationCoordinate2D startcoor,endcoor;
    UISearchBar *startsearchBar,*endsearchbar;
    UISearchDisplayController *searchDisplayController,*endsdisp;
   
}
@property(nonatomic,copy) NSString *sharecontent;
@property(nonatomic,strong) UIImage *shareimg;
@property(strong,nonatomic)UIImageView *selectimg;//按钮选择背景条
@property(strong,nonatomic)NSString *mptype;//地图类型
@property(strong,nonatomic)UIView *bgview;
@property (nonatomic, strong)NSString *currentCode;//台风编号
@property(strong,nonatomic)UIButton *bfbtn;
@property(assign)BOOL isexpent;//是否展开图例
@property(strong,nonatomic)TFListView *tflistview;
@property(strong,nonatomic)NSString *warnbill;//台风警报单
@property(assign)BOOL isbofang;//是否播放
@property(strong,nonatomic)NSString *tfcode;

@property(strong,nonatomic)UIButton *tflistbtn;
@property(assign)BOOL cancj;//是否测距
@property(strong,nonatomic)NSMutableArray *tfmodels,*tfdatas;
//
@property(strong,nonatomic)UITextField *starttf,*endtf;
@property(strong,nonatomic)FootMapView *footview;
@property(strong,nonatomic)NSString *locationcity;//定位城市
@property(strong,nonatomic)NSString *tftype;

@property(strong,nonatomic)NSArray *searchcitys;//搜索地址
@property (nonatomic, strong) AMapSearchAPI *search;
@property(nonatomic,strong)AMapInputTipsSearchRequest *maprequest;
@property (nonatomic, strong) AMapGeocode *geocode;



@property(strong,nonatomic)LYMapView *lymapview;

@property(assign)float barHeight;
@property(retain,nonatomic)UIImageView *navigationBarBg;
@end
