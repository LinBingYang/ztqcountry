//
//  BirthdayViewController.h
//  ZtqCountry
//
//  Created by Admin on 15/12/7.
//  Copyright © 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGViewController.h"
#import "ShareSheet.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"
@interface BirthdayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ShareSheetDelegate>
@property(assign)float barHeight;
@property(retain,nonatomic)UIImageView *navigationBarBg;
@property(strong,nonatomic)UIScrollView *bgscr;
@property(strong,nonatomic)NSDictionary *data;
@property(strong,nonatomic)UILabel *deslab,*zflab,*celldeslab;
@property(strong,nonatomic)UIImageView *wximg,*zfbimg,*wechaimg,*aliimg;
@property(strong,nonatomic)NSString *birthday,*cityid,*productid,*paytype,*userid,*username,*time,*cityname,*chineseday;
@property(strong,nonatomic)UITableView *m_tableview;
@property(strong,nonatomic)NSDictionary *birthdaydic;
@property(strong,nonatomic)UIImage *shareimg;
@property(strong,nonatomic)NSString *sharecontent;//分享内容
@property(assign)BOOL ispay;

@end
