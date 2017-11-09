//
//  MapBottomViewCell.h
//  ZtqCountry
//
//  Created by 派克斯科技 on 17/1/13.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapBottomViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UIImageView *aqiImg;
@property (weak, nonatomic) IBOutlet UILabel *levelPoll;
@property (weak, nonatomic) IBOutlet UILabel *aqinum;

@end
