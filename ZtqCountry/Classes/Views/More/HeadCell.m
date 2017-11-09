//
//  HeadCell.m
//  ZtqCountry
//
//  Created by linxg on 14-7-9.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "HeadCell.h"

@implementation HeadCell

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
    _logoImagV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 5, 90, 90)];
    _logoImagV.image = [UIImage imageNamed:@"logo.png"];
    [self.contentView addSubview:_logoImagV];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth-50, 20)];
    _nameLab.textAlignment = NSTextAlignmentCenter;
    _nameLab.font = [UIFont fontWithName:kBaseFont size:18];
    _nameLab.backgroundColor = [UIColor clearColor];
    _nameLab.textColor = [UIColor grayColor];
    [self.contentView addSubview:_nameLab];

}

@end
