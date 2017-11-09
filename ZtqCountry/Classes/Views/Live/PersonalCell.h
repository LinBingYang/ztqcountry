//
//  PersonalCell.h
//  ZtqCountry
//
//  Created by linxg on 14-8-8.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCell : UIView

@property (strong, nonatomic) UILabel * timeLab;
@property (strong, nonatomic) UILabel * weekLab;
@property (strong, nonatomic) NSMutableArray * cellInfos;
@property (assign, nonatomic) float height;


-(id)initWithTime:(NSString *)time withWeek:(NSString *)week withCellInfos:(NSMutableArray *)infos withOriginY:(float)Y;

@end
