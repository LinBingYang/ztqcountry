//
//  TQYBViewController.h
//  ZtqCountry
//
//  Created by linxg on 14-8-29.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"

@interface TQYBViewController :  UIViewController
@property (strong, nonatomic) UIButton * leftBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
@property (strong, nonatomic) UIButton * rightBut;

@property(strong,nonatomic)NSString *strid;
@property(strong,nonatomic)NSDictionary *tqdic;
@end
