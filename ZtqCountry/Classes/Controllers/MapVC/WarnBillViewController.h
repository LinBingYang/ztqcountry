//
//  WarnBillViewController.h
//  ZtqCountry
//
//  Created by Admin on 15/8/25.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarnBillViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView * web;
@property (strong, nonatomic) UIActivityIndicatorView * activity;
@property (strong, nonatomic) NSString * url;
@property(strong,nonatomic)NSString *code;
@property (strong, nonatomic) NSString * shareContent;
@property (strong, nonatomic) UILabel * titlelab;
@property (strong, nonatomic) NSString * titleString;

@property (strong, nonatomic) UIButton * leftBut;
@property (strong, nonatomic) UILabel * titleLab,*alllab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
@end
