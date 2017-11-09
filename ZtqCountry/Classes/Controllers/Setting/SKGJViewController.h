//
//  SKGJViewController.h
//  ZtqCountry
//
//  Created by linxg on 14-8-28.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"

@interface SKGJViewController : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) UIButton * leftBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
@property (strong, nonatomic) UIButton * rightBut;

@property(strong,nonatomic)NSString *strid;
@property(strong,nonatomic)NSDictionary *skdic;
@property(strong,nonatomic)NSString *tscity,*tsid;
@property(strong,nonatomic)UISwitch *sender;
@property(strong,nonatomic)NSString *hum_h,*hum_l,*rain_h,*temp_h,*temp_l,*vis_l,*wspeed_h;
@property(strong,nonatomic)NSString *noticetype;

@property(assign)BOOL isedit;
@end
