//
//  ROCheckDialogViewController.h
//  RenrenSDKDemo
//
//  Created by xiawh on 11-10-17.
//  Copyright 2011年 renren-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROBaseDialogViewController.h"
#import "ROPayDialogViewController.h"
#import "ROCheckOrderCell.h"
#import "ROPayOrderInfo.h"

@protocol RenrenCheckDialogDelegate <NSObject>

@optional
- (void)renrenRepairOrder:(ROPayOrderInfo *)order andPresentController:(id)viewController;
@end

@interface ROCheckDialogViewController : ROBaseDialogViewController <UITableViewDelegate,UITableViewDataSource,RenrenPayDialogDelegate>{
    UITableView *_orderView;
    NSMutableArray *_result;
    __weak id<RenrenCheckDialogDelegate> _delegate;
//    id<RenrenCheckDialogDelegate> _delegate;
}
@property (nonatomic,strong)UITableView *orderView;
@property (nonatomic,strong)NSMutableArray *result;
@property (nonatomic,weak)id<RenrenCheckDialogDelegate> delegate;

- (void)repairOrder:(ROCheckOrderCell*)cell;
@end
