//
//  YujingPushViewController.h
//  ZtqCountry
//
//  Created by linxg on 14-8-29.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"

@interface YujingPushViewController : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) UIButton * leftBut,*rightBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;


@property(strong,nonatomic)NSString *strid;
@property(strong,nonatomic)NSDictionary *yujingcitydic;
@property(strong,nonatomic)NSString *tscity,*tsid;
@property(strong,nonatomic)NSString *o_yjxx,*b_yjxx,*y_yjxx,*r_yjxx,*p_yjxx;//预警信息开关
@property(assign)BOOL isedit;
-(void)sendpush;
@end
