//
//  CpggVC.h
//  ZtqCountry
//
//  Created by Admin on 15/7/7.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "BaseViewController.h"

@interface CpggVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView *m_tableview;
@property(strong,nonatomic)NSArray *notice_list;
@property(strong,nonatomic)UIScrollView *bgscrol;
@end
