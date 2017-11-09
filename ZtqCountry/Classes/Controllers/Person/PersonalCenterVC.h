//
//  PersonalCenterVC.h
//  ZtqCountry
//
//  Created by linxg on 14-8-13.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import "PersonCenterModel.h"
@interface PersonalCenterVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIButton * leftBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
@property (strong, nonatomic) UIButton * rightBut;

@property (strong, nonatomic) UITableView * table;
@property (strong, nonatomic) NSData * userImage;
@property (strong, nonatomic) NSString * userName;
@property (assign, nonatomic) int type;//0代表自己的个人中心，1代表别人的个人中心；
@property(strong,nonatomic)NSString *backtype;

@property(strong,nonatomic)NSString *itemid;
@property(strong,nonatomic)NSString *facusid;
@property(assign)BOOL isguanzhu;
@property(strong,nonatomic)UIButton *guanzhubut;

@end
