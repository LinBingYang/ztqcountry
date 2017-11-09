//
//  AppDelegate.h
//  ZtqCountry
//
//  Created by linxg on 14-6-10.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationController.h"
#import "Alert.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <Bugly/Bugly.h>
#import "MobClick.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <CoreLocation/CLLocationManager.h>
#import "AFNetworking.h"
typedef enum {
    widgetTypeLVQX,
    widgetTypeFYCX,
    widgetTypeYJXX,
    widgetTypeother
}widgetType;
@interface AppDelegate : UIResponder <UIApplicationDelegate,alerdeleagte,WXApiDelegate,AMapLocationManagerDelegate,CLLocationManagerDelegate,GetXMLDelegate>{
    TreeNode *m_allCity;
    TreeNode *m_allprovice;
    CLLocationManager *m_locationManager;
    BOOL isdownloadsuccess;
    // 下载操作
    NSURLSessionDownloadTask *_downloadTask;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CustomNavigationController * firstNavigationController;
@property(strong,nonatomic)NSString *TSID;//预警,节日id
@property(strong,nonatomic)Alert *al;
@property(nonatomic,assign) widgetType Jumpwidget;
@property(nonatomic,retain)AMapLocationManager *locationManager;
@property(retain,nonatomic)NSString *DWcity,*DWid;
@property(strong,nonatomic)NSString *provice;
@property (nonatomic, strong) AFHTTPRequestSerializer *serializer;
@property(nonatomic,strong)NSArray *arealist;
@end
