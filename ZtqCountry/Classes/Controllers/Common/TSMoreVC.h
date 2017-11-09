//
//  TSMoreVC.h
//  ZtqCountry
//
//  Created by Admin on 15/7/10.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface TSMoreVC : UIViewController<MFMessageComposeViewControllerDelegate>{
    UIScrollView *m_scroll;
}
@property (strong, nonatomic) UIButton * leftBut,*rightBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;

@property(strong,nonatomic)NSString *tsid;

@property(strong,nonatomic)NSString *ico;//预警图标
@property(strong,nonatomic)NSString *guidestr;
@property(strong,nonatomic)NSString *imgName;//插图
@property(strong,nonatomic)NSString *titlestr;
@property(strong,nonatomic)NSString *putstring;//发布
@property(strong,nonatomic)NSString *type;//类型
@property(strong,nonatomic)NSString *warninfo;//发布内容
@property(strong,nonatomic)NSString *fyzninfo;//防御指南
@property(strong,nonatomic)NSMutableArray *warnarr;

@property (strong, nonatomic) UIWebView * web;
@property (strong, nonatomic) NSString * url;
@property(strong,nonatomic)UIImage *shareimg;

@end
