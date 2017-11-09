//
//  SettingCell.m
//  ZtqCountry
//
//  Created by linxg on 14-7-9.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self creatViews];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)creatViews
{
//    _logoImagV = [[UIImageView alloc] initWithFrame:CGRectMake(50, 5, 30, 30)];
//    [self.contentView addSubview:_logoImagV];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 100, 30)];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:15];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor grayColor];
    [self.contentView addSubview:_titleLab];
    
//    _settingSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 5, 60, 30)];
//    _settingSwitch.on = NO;
//    [_settingSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//    [self.contentView addSubview:_settingSwitch];
}

-(void)switchAction:(UISwitch *)sender
{
    if([self.delegate respondsToSelector:@selector(settingWithSwitch:withIndexPath:)])
    {
        [self.delegate settingWithSwitch:sender.on withIndexPath:self.IP];
    }
}

@end
