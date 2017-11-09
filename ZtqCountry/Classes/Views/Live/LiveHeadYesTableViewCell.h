//
//  LiveHeadYesTableViewCell.h
//  ZtqCountry
//
//  Created by linxg on 14-9-3.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageInfo.h"

@protocol LiveHeadYesTableViewCellDelegate <NSObject>

-(void)LiveHeadYesTableViewCellUserImageClick;
-(void)guanzhuClick;
-(void)dianzanClick;

@end

@interface LiveHeadYesTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel * userName;
@property (strong, nonatomic) UILabel * addressLab;
@property (strong, nonatomic) UIImageView * photo;
@property (strong, nonatomic) UILabel * browseNumLab;
@property (strong, nonatomic) UILabel * answerNumLab;
@property (strong, nonatomic) UILabel * attentionLab;
@property (strong, nonatomic) UIButton * guanyuBut;
@property(strong,nonatomic)UIButton *guanzhubut;
@property (weak, nonatomic) id<LiveHeadYesTableViewCellDelegate>delegate;

@property(strong,nonatomic)ImageInfo *imginfo;
@property(strong,nonatomic)NSString *facusid;

@property(strong,nonatomic)NSString *result;//关注返回结果
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withImageInfo:(ImageInfo *)info;


@end
