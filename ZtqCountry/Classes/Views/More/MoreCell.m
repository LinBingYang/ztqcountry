
//
//  MoreCell.m
//  ZtqCountry
//
//  Created by linxg on 14-7-9.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "MoreCell.h"

@implementation MoreCell

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
    _logoImagV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 11, 18, 18)];
//    [self.contentView addSubview:_logoImagV];
    
    UIImageView * verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(69, 13, 1, 14)];
    self.verticalLine = verticalLine;
    verticalLine.image = [UIImage imageNamed:@"sz竖隔条.png"];
//    [self.contentView addSubview:verticalLine];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 30)];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.font = [UIFont systemFontOfSize:15];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLab];
    
    _horizontalLine = [[UIImageView alloc] initWithFrame:CGRectMake(2, CGRectGetHeight(self.contentView.frame)-1, CGRectGetWidth(self.contentView.frame)-4, 1)];
    _horizontalLine.image = [UIImage imageNamed:@"sz横隔条.png"];
//    [self.contentView addSubview:_horizontalLine];
}

@end
