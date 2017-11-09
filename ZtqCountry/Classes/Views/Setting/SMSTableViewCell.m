//
//  SMSTableViewCell.m
//  ZtqCountry
//
//  Created by linxg on 14-8-29.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "SMSTableViewCell.h"
#import "UILabel+utils.h"

@interface SMSTableViewCell ()

@property (strong, nonatomic) UIView * bgView;

@end

@implementation SMSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

-(void)createView
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.frame)-10, 50)];
//    _bgView.backgroundColor = [UIColor colorHelpWithRed:247 green:238 blue:214 alpha:1];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.borderColor = [UIColor grayColor].CGColor;
    _bgView.layer.borderWidth = 1;
    [self.contentView addSubview:_bgView];
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor blueColor];
    _titleLab.font = [UIFont fontWithName:kBaseFont size:15];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLab];
//    @property (strong, nonatomic) UILabel * consumptionLab;
//    @property (strong, nonatomic) UILabel * openWayLab;
//    @property (strong, nonatomic) UILabel * closeWayLab;
    
    _consumptionLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, CGRectGetWidth(self.frame)-30, 20)];
    _consumptionLab.backgroundColor = [UIColor clearColor];
    _consumptionLab.textColor = [UIColor grayColor];
    _consumptionLab.font = [UIFont fontWithName:kBaseFont size:13];
    _consumptionLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_consumptionLab];
    
    _openWayLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, CGRectGetWidth(self.frame)-30, 20)];
    _openWayLab.numberOfLines = 0;
    _openWayLab.backgroundColor = [UIColor clearColor];
    _openWayLab.textColor = [UIColor grayColor];
    _openWayLab.font = [UIFont fontWithName:kBaseFont size:13];
    _openWayLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_openWayLab];
    
    _closeWayLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 90, CGRectGetWidth(self.frame)-30, 20)];
    _closeWayLab.numberOfLines = 0;
    _closeWayLab.backgroundColor = [UIColor clearColor];
    _closeWayLab.textColor = [UIColor grayColor];
    _closeWayLab.font = [UIFont fontWithName:kBaseFont size:13];
    _closeWayLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_closeWayLab];
    
}

- (void)awakeFromNib
{
    // Initialization code
}


-(void)setTitle:(NSString *)title withConsumption:(NSString *)consumption withOpenWay:(NSString *)openWay withCloseWay:(NSString *)closeWay
{
    _titleLab.text = title;
    _consumptionLab.text = consumption;
   float openHeight = [_openWayLab labelheight:openWay withFont:[UIFont fontWithName:kBaseFont size:13]];
    _openWayLab.frame = CGRectMake(15, 70, CGRectGetWidth(self.frame)-30, openHeight);
    _openWayLab.text = openWay;
    
    float closeHeight = [_closeWayLab labelheight:closeWay withFont:[UIFont fontWithName:kBaseFont size:13]];
    _closeWayLab.frame = CGRectMake(15, 70+openHeight+10, CGRectGetWidth(self.frame)-30, closeHeight);
    _closeWayLab.text = closeWay;
    
    _bgView.frame = CGRectMake(5, 5, CGRectGetWidth(self.frame)-10, 85+closeHeight+openHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
