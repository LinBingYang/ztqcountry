//
//  PersonImageCell.h
//  ZtqCountry
//
//  Created by linxg on 14-8-13.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonImageCellDelegate <NSObject>

-(void)personImageClick;
-(void)userInteractionWithTag:(int)tag;
//-(void)guanzhuAction;

@end

@interface PersonImageCell : UITableViewCell

@property (strong, nonatomic) UIImageView * userImg_Max;
@property (strong, nonatomic) UIImageView * userImg_Min;
@property(strong,nonatomic)UIButton * guanzhubtn;//关注img
@property (strong, nonatomic) UILabel * userName;
@property (strong, nonatomic) UILabel * browseNum;//浏览次数
@property (strong, nonatomic) UILabel * friendNum;//好友个数
@property (strong, nonatomic) UILabel * zanNum;//赞个数
@property (strong, nonatomic) UILabel * shareNum;//分享个数
@property (strong, nonatomic) UIButton * userImgButton;
@property (weak, nonatomic)id<PersonImageCellDelegate>delegate;

-(void)setImageforUserImg_MaxWithImage:(UIImage *)image;


@end
