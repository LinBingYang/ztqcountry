//
//  GRZXViewController.h
//  ztqFj
//
//  Created by Admin on 15-1-19.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageInfo.h"
@interface GRZXViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UIButton * leftBut,*rightBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;

@property (strong, nonatomic) UITableView * table;
@property(strong,nonatomic)ImageInfo *infodata;
@property(strong,nonatomic)NSString *username;
@property(strong,nonatomic)NSString *type;//返回类型
@end
