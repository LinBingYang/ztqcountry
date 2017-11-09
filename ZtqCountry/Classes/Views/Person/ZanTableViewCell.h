//
//  ZanTableViewCell.h
//  ZtqCountry
//
//  Created by linxg on 14-8-31.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZanTableViewCellDelegate <NSObject>

-(void)zanTableViewCellAttentionClickWithIndexPath:(NSIndexPath *)indexPath withState:(BOOL)state;

@end

@interface ZanTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView * personImgV;
@property (strong, nonatomic) UILabel * nameLab;
@property (strong, nonatomic) UIButton * attentionBut;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (weak, nonatomic) id<ZanTableViewCellDelegate>delegate;

@end
