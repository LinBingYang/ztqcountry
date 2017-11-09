//
//  LaunchViewController.h
//  ZtqCountry
//
//  Created by linxg on 14-6-25.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import "PCSScrollView.h"
#import "SelectCityViewController.h"
#import "MainNewViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
@interface LaunchViewController : UIViewController<CLLocationManagerDelegate,
UIScrollViewDelegate,UIAlertViewDelegate,AMapLocationManagerDelegate>
{
    CLLocationManager *m_locationManager;
    PCSScrollView *m_pcsScrollView;
    UIScrollView *ydsrcollview;
    NSDictionary *m_currentCity;
    TreeNode *m_allCity;
    TreeNode *m_allprovice;
    BOOL isdw;
}
@property(nonatomic,retain)AMapLocationManager *locationManager;
@property(nonatomic,strong)UILabel *betalab;
@property(retain,nonatomic)NSString *DWcity,*DWid;
@property(strong,nonatomic)NSString *provice;
@property(assign)BOOL isbtnselect;
@property(assign)BOOL isfirst;//是否第一次安装
@property(assign)BOOL ispass,isgotomain;
@property(strong,nonatomic)NSTimer *mytimer;
@end
