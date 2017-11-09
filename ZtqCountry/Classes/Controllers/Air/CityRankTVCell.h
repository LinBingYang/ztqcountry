//
//  CityRankTVCell.h
//  ztqFj
//
//  Created by 派克斯科技 on 16/8/3.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityRankTVCell : UITableViewCell
@property(nonatomic, strong)UILabel *cell_label1;

@property(nonatomic, strong)UILabel *cell_label2;

- (void)updataWithProvince:(NSString *)province city:(NSString *)city;

- (void)updataWithOnlyValue:(NSString *)value;
@end
