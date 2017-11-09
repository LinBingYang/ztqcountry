//
//  ROCheckOrderCell.h
//  RenrenSDKDemo
//
//  Created by xiawh on 11-10-19.
//  Copyright 2011年 renren-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ROCheckOrderCell : UITableViewCell {
    UILabel *_orderNum;
    UILabel *_tradingVolume;
    UILabel *_orderTime;
    UILabel *_orderStatus;
    UILabel *_serialNum;
    UILabel *_description;
    UIButton *_repair;
}

@property (strong ,nonatomic)IBOutlet UILabel *orderNum;
@property (strong ,nonatomic)IBOutlet UILabel *tradingVolume;
@property (strong ,nonatomic)IBOutlet UILabel *orderTime;
@property (strong ,nonatomic)IBOutlet UILabel *orderStatus;
@property (strong ,nonatomic)IBOutlet UIButton *repair;
@property (strong ,nonatomic)IBOutlet UILabel *serialNum;
@property (strong ,nonatomic)IBOutlet UILabel *description;

- (IBAction)repairOrder:(id)sender;

@end
