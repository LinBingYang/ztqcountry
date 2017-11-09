//
//  UseringViewController.h
//  ztqFj
//
//  Created by Admin on 15/5/7.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UseringViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
@property(strong,nonatomic)UITableView *m_tableview;
@property(strong,nonatomic)NSArray *datas;
@end
