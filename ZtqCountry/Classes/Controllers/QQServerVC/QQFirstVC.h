//
//  QQFirstVC.h
//  ZtqCountry
//
//  Created by Admin on 15/8/19.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMAdScrollView.h"
#import "AddServerViewController.h"
#import "PayViewController.h"
@interface QQFirstVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,ValueClickDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *seringarr,*noserarr;
@property(strong,nonatomic)NSMutableArray *adtitles,*adimgurls,*adurls;
@property(strong,nonatomic)BMAdScrollView *bmadscro;//广告
@property(strong,nonatomic)NSString *empty_tip;
@end
