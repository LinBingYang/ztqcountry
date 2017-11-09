//
//  ZXViewController.h
//  ZtqCountry
//
//  Created by Admin on 16/10/21.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import "ZXContentViewController.h"
@interface ZXViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *m_tableView;
    BOOL _reloading;
}
@property(strong,nonatomic)NSString *titlestr;

@property(nonatomic, strong)NSString *channel_id,  *count;
@property(nonatomic, assign)int page;
@property(nonatomic, strong)NSMutableArray *dataSource;
@end
