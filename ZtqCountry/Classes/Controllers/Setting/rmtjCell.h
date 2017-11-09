//
//  rmtjCell.h
//  ZtqCountry
//
//  Created by 派克斯科技 on 16/12/21.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"


@interface rmtjCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ac_name;
@property (weak, nonatomic) IBOutlet UILabel *ac_time;
@property (weak, nonatomic) IBOutlet UIImageView *ac_hot;

@property (weak, nonatomic) IBOutlet EGOImageView *banner;


- (void)rmtjCellUpdataWithDic:(NSDictionary *)dic;

@end
