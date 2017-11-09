//
//  NewsViewController.h
//  ztqFj
//
//  Created by Admin on 14-12-17.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "artTitleModel.h"
//#import "MoreInfoViewController.h"
@interface NewsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *m_tableView;
    NSMutableArray *m_titleModelArr;
    int t_count;
}
@property(strong,nonatomic)NSString *titstr,*type;
@property(strong,nonatomic)NSArray *datas;
@end
