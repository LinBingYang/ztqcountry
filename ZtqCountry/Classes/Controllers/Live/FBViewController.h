//
//  FBViewController.h
//  ztqFj
//
//  Created by Admin on 15-1-20.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface FBViewController : UIViewController<CLLocationManagerDelegate,UIAlertViewDelegate,AMapLocationManagerDelegate>{
    CLLocationManager    *locationManager;
    TreeNode *m_allArea;
}
@property(nonatomic,retain)AMapLocationManager *locationManager;
@property (strong, nonatomic) UIButton * leftBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
@property (strong, nonatomic) UIButton * rightBut;
@property(strong,nonatomic)UIImage *fbimage;
@property(strong,nonatomic)NSArray *weaarr;
@property(strong,nonatomic)NSString *parentid;
@property(strong,nonatomic)NSString *titlecity;//位置
@property(assign)int btntag;
@property(retain,nonatomic)NSString *DWcity,*DWid;
@end
