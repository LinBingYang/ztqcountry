//
//  WRPayViewController.h
//  ZtqCountry
//
//  Created by Admin on 16/1/14.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import "PayMonthList.h"
#import <CommonCrypto/CommonDigest.h>
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"
@interface WRPayViewController : UIViewController<monthlistDelegate,UIAlertViewDelegate>{
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
@property(strong,nonatomic)NSString *pirce,*paytype,*orderid,*userid,*sign,*month,*type;
@property(strong,nonatomic)UIImageView *wximg,*zfbimg,*wechaimg,*aliimg;
@property(strong,nonatomic)NSMutableArray *names,*values,*totals;

@end
