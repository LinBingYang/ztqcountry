//
//  AskQTableViewCell.h
//  ZtqCountry
//
//  Created by linxg on 14-7-31.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskQTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel * contentLab;
@property (strong, nonatomic) UIImageView * arrow;
@property (assign, nonatomic) BOOL isOpen;
@property (strong, nonatomic) UIImageView * separatorLine;

@end
