//
//  DelitalViewController.h
//  ZtqCountry
//
//  Created by Admin on 14-8-20.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface DelitalViewController : UIViewController<MFMessageComposeViewControllerDelegate>{
    UIScrollView *m_scroll;
}
@property (strong, nonatomic) UIButton * leftBut,*rightBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;

@property(strong,nonatomic)NSString *ico;//预警图标
@property(strong,nonatomic)NSString *guidestr;
@property(strong,nonatomic)NSString *imgName;//插图
@property(strong,nonatomic)NSString *titlestr;
@property(strong,nonatomic)NSString *putstring;//发布
@property(strong,nonatomic)NSString *type;//类型
@property(strong,nonatomic)NSString *warninfo;//发布内容
@property(strong,nonatomic)NSString *fyzninfo;//防御指南
@property(strong,nonatomic)NSString *warnid;//发布
@property(strong,nonatomic)NSMutableArray *warnarr;

@property (strong, nonatomic) UIWebView * web;
@property (strong, nonatomic) NSString * url;
@property(strong,nonatomic)UIImage *shareimg;
@property(strong,nonatomic)NSString *sharecontent;//分享内容
@end
