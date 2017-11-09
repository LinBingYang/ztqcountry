//
//  rmtjCell.m
//  ZtqCountry
//
//  Created by 派克斯科技 on 16/12/21.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "rmtjCell.h"

@implementation rmtjCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)rmtjCellUpdataWithDic:(NSDictionary *)dic {
    NSString *big_img = dic[@"banner"];
    NSString *time = dic[@"time"];
    NSString *tiitle = dic[@"title"];
    NSString *hot = dic[@"hot"];
    
    if (hot.floatValue == 0) {
        self.ac_hot.hidden = YES;
    }else {
        self.ac_hot.hidden = NO;
    }
    self.ac_name.text = tiitle;
    self.ac_time.text = time;
    [self.banner setImageURL:[ShareFun makeImageUrl:big_img]];
    
    self.ac_time.adjustsFontSizeToFitWidth = YES;
    
    
    
    
}
@end
