//
//  MyWRserverViewController.h
//  ZtqCountry
//
//  Created by Admin on 16/1/13.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "BaseViewController.h"

@interface MyWRserverViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@end
