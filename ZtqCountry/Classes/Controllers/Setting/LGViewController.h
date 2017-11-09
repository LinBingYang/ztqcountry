//
//  LGViewController.h
//  ZtqCountry
//
//  Created by Admin on 14-8-18.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import "XGPwdViewController.h"
@interface LGViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(strong,nonatomic)UITextField* name,*password;
@property(strong,nonatomic)NSDictionary *dic;
@property(strong,nonatomic)UIImageView *imagev;
@property(strong,nonatomic)UIScrollView *bgscro;

@property(strong,nonatomic)NSString *userid;//用户id

@property (strong, nonatomic) UITableView * lgtableview;
@property (strong, nonatomic) NSArray * datas,*icons;
@property(strong,nonatomic)NSString *type;//进入登录界面的类型
@end
