//
//  PayViewController.h
//  ZtqCountry
//
//  Created by Admin on 15/8/21.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayMonthList.h"
#import <CommonCrypto/CommonDigest.h>
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"
@interface PayViewController : UIViewController<monthlistDelegate,UIAlertViewDelegate>{
    NSString *payUrl;
    
    //lash_errcode;
    long     last_errcode;
    //debug信息
    NSMutableString *debugInfo;
    NSString *appid,*mchid,*spkey;
}
@property (strong, nonatomic) UIButton * leftBut;
@property (strong, nonatomic) UILabel * titleLab,*alllab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
@property(strong,nonatomic)PayMonthList *monlist;
@property(strong,nonatomic)NSArray *months;
@property(strong,nonatomic)NSString *pirce,*paytype,*orderid,*userid,*sign,*month;
@property(strong,nonatomic)UIImageView *wximg,*zfbimg,*wechaimg,*aliimg;
@property(strong,nonatomic)NSMutableArray *names,*values;

@end
