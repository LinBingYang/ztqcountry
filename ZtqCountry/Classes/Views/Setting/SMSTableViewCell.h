//
//  SMSTableViewCell.h
//  ZtqCountry
//
//  Created by linxg on 14-8-29.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UILabel * consumptionLab;
@property (strong, nonatomic) UILabel * openWayLab;
@property (strong, nonatomic) UILabel * closeWayLab;

-(void)setTitle:(NSString *)title withConsumption:(NSString *)consumption withOpenWay:(NSString *)openWay withCloseWay:(NSString *)closeWay;

@end
