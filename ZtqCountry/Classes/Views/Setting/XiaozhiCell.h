//
//  XiaozhiCell.h
//  ZtqCountry
//
//  Created by linxg on 14-8-29.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XiaozhiDelegate <NSObject>

-(void)downloadWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface XiaozhiCell : UITableViewCell

@property (strong, nonatomic) UIImageView * logoImgV;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UILabel * platformLab;
@property (strong, nonatomic) UILabel * contentLab;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (strong, nonatomic) UIView * line;
@property (strong, nonatomic) UIView * bgView;
@property (strong, nonatomic) UIView * blackBg;
@property (weak, nonatomic) id<XiaozhiDelegate>delegate;


-(void)setLogo:(UIImage *)logo withTitle:(NSString *)title withPlatform:(NSString *)platform withContent:(NSString *)content withIndexPath:(NSIndexPath *)indexPath withDelegate:(id)delegate;


@end
