//
//  ZXTableViewCell.h
//  ZtqCountry
//
//  Created by 派克斯科技 on 16/10/26.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXModel.h"
#import "EGOImageView.h"
@interface ZXTableViewCell : UITableViewCell
@property(nonatomic, strong)EGOImageView *thumbnailImage;
@property(nonatomic, strong)UILabel *titleLabel, *subtitileLabel;


- (void)updataWithModel:(ZXModel *)model;
@end
