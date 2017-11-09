//
//  WebViewController.h
//  ZtqCountry
//
//  Created by Admin on 15/6/10.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView * web;
@property (strong, nonatomic) UIActivityIndicatorView * activity;
@property (strong, nonatomic) NSString * url,*userid,*sharetype,*nolgurl,*urlact_id,*url_type;
@property (strong, nonatomic) NSString * shareContent;
@property (strong, nonatomic) UILabel * titlelab;
@property (strong, nonatomic) NSString * titleString,*sharecontent;
@property (nonatomic, strong) JSContext *jsContext;
@property(assign)BOOL isshare,isback;
@property(assign)float barhight;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (strong, nonatomic) UILabel * titleLab;
@property(strong,nonatomic)UIImage *shareimg;
@end
