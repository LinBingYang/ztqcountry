//
//  PersonImageCell.m
//  ZtqCountry
//
//  Created by linxg on 14-8-13.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "PersonImageCell.h"
#import "UIImage+Blur.h"

@implementation PersonImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)createView
{
    _userImg_Max = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 250)];
    [self.contentView addSubview:_userImg_Max];
    
    //    UIImageView * userImg_MinBG = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-80)/2.0, 40, 80, 80)];
    //    userImg_MinBG.backgroundColor = [UIColor whiteColor];
    //    userImg_MinBG.layer.cornerRadius = 40;
    //    userImg_MinBG.layer.masksToBounds = YES;
    //    [self.contentView addSubview:userImg_MinBG];
    
    _userImgButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-80)/2.0, 40, 80, 80)];
    [_userImgButton addTarget:self action:@selector(userImgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_userImgButton];
    
    _userImg_Min = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-80)/2.0, 40, 80, 80)];
    _userImg_Min.layer.cornerRadius = 40;
    _userImg_Min.layer.masksToBounds = YES;
    [self.contentView addSubview:_userImg_Min];
    
    _guanzhubtn=[[UIButton alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-80)/2.0, 160, 60, 20)];
    [_guanzhubtn setBackgroundImage:[UIImage imageNamed:@"grzx1@张三背景.png"] forState:UIControlStateNormal];
    
    [self.contentView addSubview:_guanzhubtn];
    
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, CGRectGetWidth(self.frame), 20)];
    _userName.backgroundColor = [UIColor clearColor];
    _userName.textColor = [UIColor whiteColor];
    _userName.font = [UIFont fontWithName:kBaseFont size:18];
    _userName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_userName];
    
    UIImageView * blureBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250-50, CGRectGetWidth(self.frame), 50)];
    blureBackground.image = [UIImage imageNamed:@"粉丝 浏览量透明黑色背景xiugai.png"];
    [self.contentView addSubview:blureBackground];
    
    
    
    UIView * barBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 250-50, CGRectGetWidth(self.frame), 50)];
    barBackground.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:barBackground];
    
    float space = (CGRectGetWidth(self.frame)-75)/4.0;
    _browseNum = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, space-15-5, 20)];
    _browseNum.backgroundColor = [UIColor clearColor];
    _browseNum.textColor = [UIColor whiteColor];
    _browseNum.font = [UIFont fontWithName:kBaseFont size:15];
    _browseNum.textAlignment = NSTextAlignmentLeft;
    [barBackground addSubview:_browseNum];
    
    UIImageView * browseIcon = [[UIImageView alloc] initWithFrame:CGRectMake(space-15, 10, 20, 19)];
    browseIcon.image = [UIImage imageNamed:@"grzxsc浏览量.png"];
    [barBackground addSubview:browseIcon];
    
    UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(space, 5, 25, 40)];
    line1.image = [UIImage imageNamed:@"grzxsc斜线.png"];
    [barBackground addSubview:line1];
    
    UIButton * browseBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)/4.0, 50)];
    browseBut.tag = 1;
    [browseBut setBackgroundImage:[UIImage imageNamed:@"粉丝点赞图片点击选择.png"] forState:UIControlStateHighlighted];
    [browseBut addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    [barBackground addSubview:browseBut];
    
    _friendNum = [[UILabel alloc] initWithFrame:CGRectMake(space+25+5, 20, space-15-5, 20)];
    _friendNum.backgroundColor = [UIColor clearColor];
    _friendNum.textColor = [UIColor whiteColor];
    _friendNum.font = [UIFont fontWithName:kBaseFont size:15];
    _friendNum.textAlignment = NSTextAlignmentLeft;
    [barBackground addSubview:_friendNum];
    
    UIImageView * friendIcon = [[UIImageView alloc] initWithFrame:CGRectMake(space + (space+25)-15, 10, 20, 19)];
    friendIcon.image = [UIImage imageNamed:@"grzxsc粉丝.png"];
    [barBackground addSubview:friendIcon];
    
    UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(space*2+25, 5, 25, 40)];
    line2.image = [UIImage imageNamed:@"grzxsc斜线.png"];
    [barBackground addSubview:line2];
    
    UIButton * friendBut = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/4.0, 0, CGRectGetWidth(self.frame)/4.0, 50)];
    friendBut.tag = 2;
    [friendBut setBackgroundImage:[UIImage imageNamed:@"粉丝点赞图片点击选择.png"] forState:UIControlStateHighlighted];
    [friendBut addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    [barBackground addSubview:friendBut];
    
    _zanNum = [[UILabel alloc] initWithFrame:CGRectMake((space+25)*2+5, 20, space-15-5, 20)];
    _zanNum.backgroundColor = [UIColor clearColor];
    _zanNum.textColor = [UIColor whiteColor];
    _zanNum.font = [UIFont fontWithName:kBaseFont size:15];
    _zanNum.textAlignment = NSTextAlignmentLeft;
    [barBackground addSubview:_zanNum];
    
    UIImageView * zanIcon = [[UIImageView alloc] initWithFrame:CGRectMake((space+25)*3-25-15, 10, 20, 19)];
    zanIcon.image = [UIImage imageNamed:@"grzxsc点赞1.png"];
    [barBackground addSubview:zanIcon];
    
    UIImageView * line3 = [[UIImageView alloc] initWithFrame:CGRectMake((space+25)*3-25, 5, 25, 40)];
    line3.image = [UIImage imageNamed:@"grzxsc斜线.png"];
    [barBackground addSubview:line3];
    
    UIButton * zanBut = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2.0, 0, CGRectGetWidth(self.frame)/4.0, 50)];
    zanBut.tag = 3;
    [zanBut setBackgroundImage:[UIImage imageNamed:@"粉丝点赞图片点击选择.png"] forState:UIControlStateHighlighted];
    [zanBut addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    [barBackground addSubview:zanBut];
    
    _shareNum = [[UILabel alloc] initWithFrame:CGRectMake((space+25)*3+5, 20, space-15-5, 20)];
    _shareNum.backgroundColor = [UIColor clearColor];
    _shareNum.textColor = [UIColor whiteColor];
    _shareNum.font = [UIFont fontWithName:kBaseFont size:15];
    _shareNum.textAlignment = NSTextAlignmentLeft;
    [barBackground addSubview:_shareNum];
    
    UIImageView * shareIcon = [[UIImageView alloc] initWithFrame:CGRectMake((space+25)*4-25-20-5, 10, 20, 19)];
    shareIcon.image = [UIImage imageNamed:@"grzxsc美图.png"];
    [barBackground addSubview:shareIcon];
    UIButton * shareBut = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/4.0*3, 0, CGRectGetWidth(self.frame)/4.0, 50)];
    shareBut.tag = 4;
    [shareBut setBackgroundImage:[UIImage imageNamed:@"粉丝点赞图片点击选择.png"] forState:UIControlStateHighlighted];
    [shareBut addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    [barBackground addSubview:shareBut];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(UIImage *)getBlureImageWithImage:(UIImage *)image
{
    //    UIImage * image = [ShareFun scaleFromImage:self.weatherBG.image toSize:self.weatherBG.frame.size];
    
    //    CGImageRef sourceImageRef = [image CGImage];
    //    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(0, 20, size.width, size.height));
    //    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    //    CGImageRelease(newImageRef);
    UIImage * blurImage = [image blurredImage:0.1];
    return blurImage;
}

-(void)setImageforUserImg_MaxWithImage:(UIImage *)image
{
    UIImage * blureImage = [self getBlureImageWithImage:image];
    _userImg_Max.image = blureImage;
}

-(void)userImgButtonAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(personImageClick)])
    {
        [self.delegate personImageClick];
    }
}
//-(void)guanzhuAction:(UIButton *)sender{
//    if([self.delegate respondsToSelector:@selector(guanzhuAction)])
//    {
//        [self.delegate guanzhuAction];
//    }
//}
-(void)butAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(userInteractionWithTag:)])
    {
        [self.delegate userInteractionWithTag:sender.tag];
    }
}

@end
