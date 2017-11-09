//
//  CityRankTVCell.m
//  ztqFj
//
//  Created by 派克斯科技 on 16/8/3.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "CityRankTVCell.h"

@implementation CityRankTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cell_label1=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100,30)];
        [self.cell_label1 setTextAlignment:NSTextAlignmentLeft];
        [self.cell_label1 setBackgroundColor:[UIColor clearColor]];
        [self.cell_label1 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [self.cell_label1 setTextColor:[UIColor blackColor]];
        
        self.cell_label2=[[UILabel alloc]initWithFrame:CGRectMake(70, 0, 100,30)];
        [self.cell_label2 setTextAlignment:NSTextAlignmentCenter];
        [self.cell_label2 setBackgroundColor:[UIColor clearColor]];
        [self.cell_label2 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [self.cell_label2 setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:self.cell_label1];
        [self.contentView addSubview:self.cell_label2];
        
    }
    return self;
}
- (void)updataWithProvince:(NSString *)province city:(NSString *)city {
    self.cell_label1.text = province;
    self.cell_label2.text = city;
    self.cell_label2.hidden  = NO;
}
- (void)updataWithOnlyValue:(NSString *)value {
    self.cell_label2.hidden = YES;
    self.cell_label1.text = value;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
