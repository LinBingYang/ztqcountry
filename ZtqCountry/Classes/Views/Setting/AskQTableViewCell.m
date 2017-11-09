//
//  AskQTableViewCell.m
//  ZtqCountry
//
//  Created by linxg on 14-7-31.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "AskQTableViewCell.h"

@implementation AskQTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 270, 50)];
        _contentLab.textAlignment = NSTextAlignmentLeft;
        _contentLab.font = [UIFont fontWithName:kBaseFont size:14];
        _contentLab.textColor = [UIColor blackColor];
        _contentLab.numberOfLines=0;
        [self.contentView addSubview:_contentLab];
        _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 14, 21, 12)];
//        _arrow.image = [UIImage imageNamed:@"cjwt2箭头2_05.png"];
        [self.contentView addSubview:_arrow];
//        _separatorLine  = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(self.contentView.frame)-1, CGRectGetWidth(self.contentView.frame)-10, 1)];
//        _separatorLine.image = [UIImage imageNamed:@"cjwt隔条_03.png"];
//        [self.contentView addSubview:_separatorLine];
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

@end
