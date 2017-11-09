//
//  ROCheckNavigationViewController.h
//  RenrenSDKDemo
//
//  Created by xiawh on 11-11-14.
//  Copyright (c) 2011年 renren－inc. All rights reserved.
//

#import "ROBaseNavigationViewController.h"

@interface ROCheckNavigationViewController : ROBaseNavigationViewController <UITableViewDataSource,UITableViewDelegate>{
    UITableView *_orderView;
    NSMutableArray *_result;
    __weak id<RenrenCheckDialogDelegate> _delegate;
//    id<RenrenCheckDialogDelegate> _delegate;
}
@property (nonatomic,strong)UITableView *orderView;
@property (nonatomic,strong)NSMutableArray *result;
@property (nonatomic,weak)id<RenrenCheckDialogDelegate> delegate;

- (void)repairOrder:(ROCheckOrderCell*)cell;

- (id)initWithResult:(NSMutableArray *)result;
@end
