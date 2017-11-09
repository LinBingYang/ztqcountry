//
//  LiveUserInfoCell.m
//  ZtqCountry
//
//  Created by linxg on 14-8-18.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "LiveUserInfoCell.h"

@implementation LiveUserInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

-(void)createView
{
    _userImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    _userImgV.layer.cornerRadius = 20;
    _userImgV.layer.masksToBounds = YES;
    [self.contentView addSubview:_userImgV];
    
    //    UIButton * userBut = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    //    [userBut addTarget:self action:@selector(userButAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.contentView addSubview:userBut];
    
    UIImageView * boxBackgroundImgV = [[UIImageView alloc] initWithFrame:CGRectMake(51, 12, CGRectGetWidth(self.frame)-51-10, 36)];
    boxBackgroundImgV.image = [UIImage imageNamed:@"个人关注背景.png"];
    boxBackgroundImgV.userInteractionEnabled = YES;
    [self.contentView addSubview:boxBackgroundImgV];
    
    float width = CGRectGetWidth(boxBackgroundImgV.frame)/4;
    float height = CGRectGetHeight(boxBackgroundImgV.frame);
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    _userNameLabel.font = [UIFont fontWithName:kBaseFont size:15];
    _userNameLabel.textColor = [UIColor blackColor];
    [boxBackgroundImgV addSubview:_userNameLabel];
    
    UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 5, 1, 21)];
    line1.image = [UIImage imageNamed:@"个人关注背景隔条.png"];
    [boxBackgroundImgV addSubview:line1];
    
    //关注
    UIButton * addFocusOn = [[UIButton alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    [addFocusOn setTitle:@"+关注" forState:UIControlStateNormal];
    [addFocusOn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addFocusOn addTarget: self action:@selector(addFocusOnAction:) forControlEvents:UIControlEventTouchUpInside];
    addFocusOn.titleLabel.font = [UIFont fontWithName:kBaseFont size:15];
    [boxBackgroundImgV addSubview:addFocusOn];
    
    UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(width*2, 5, 1, 21)];
    line2.image = [UIImage imageNamed:@"个人关注背景隔条.png"];
    [boxBackgroundImgV addSubview:line2];
    
    UIButton * forward = [[UIButton alloc] initWithFrame:CGRectMake(2*width, 0, width, height)];
    [forward setTitle:@"转发" forState:UIControlStateNormal];
    [forward setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forward addTarget:self action:@selector(forwarding:) forControlEvents:UIControlEventTouchUpInside];
    forward.titleLabel.font = [UIFont fontWithName:kBaseFont size:15];
    [boxBackgroundImgV addSubview:forward];
    
    UIImageView * line3 = [[UIImageView alloc] initWithFrame:CGRectMake(width*3, 5, 1, 21)];
    line3.image = [UIImage imageNamed:@"个人关注背景隔条.png"];
    [boxBackgroundImgV addSubview:line3];
    
    _browseLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*3, 0, width, height)];
    _browseLabel.backgroundColor = [UIColor clearColor];
    _browseLabel.textAlignment = NSTextAlignmentCenter;
    _browseLabel.font = [UIFont fontWithName:kBaseFont size:15];
    _browseLabel.textColor = [UIColor blackColor];
    [boxBackgroundImgV addSubview:_browseLabel];
    
}

-(void)addFocusOnAction:(UIButton *)sender
{
    
}

-(void)forwarding:(UIButton *)sender
{
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)userButAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(liveUserImageClick)])
    {
        [self.delegate liveUserImageClick];
    }
}

@end
