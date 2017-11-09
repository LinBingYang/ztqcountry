//
//  LiveCityTableViewCell.m
//  ZtqCountry
//
//  Created by linxg on 14-8-8.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "LiveCityTableViewCell.h"

@implementation LiveCityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView * positioningLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
        positioningLogo.image = [UIImage imageNamed:@"csss2ngs_33.png"];
        [self.contentView addSubview:positioningLogo];
        
        UILabel * cityLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200, 20)];
        cityLab.textColor = [UIColor grayColor];
        cityLab.backgroundColor = [UIColor clearColor];
        cityLab.textAlignment = NSTextAlignmentLeft;
        cityLab.text = @"福州";
        [self.contentView addSubview:cityLab];
        
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowRadius = 1;
        
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
