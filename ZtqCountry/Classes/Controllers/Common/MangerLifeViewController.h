//
//  MangerLifeViewController.h
//  ZtqCountry
//
//  Created by Admin on 14-10-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"

@interface MangerLifeViewController : UIViewController
@property(strong,nonatomic)NSMutableArray *arr;
@property(strong,nonatomic)UIButton *cellbtn;
@property(strong,nonatomic)NSString *name;//指数名字
@property(strong,nonatomic)UIImageView *xzimg;
@property(strong,nonatomic)NSMutableArray *marr;

@property (strong, nonatomic) UIButton * leftBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
@property(assign)BOOL click;
@end
