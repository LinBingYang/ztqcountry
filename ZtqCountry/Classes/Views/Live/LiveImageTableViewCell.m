//
//  LiveImageTableViewCell.m
//  ZtqCountry
//
//  Created by linxg on 14-8-8.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "LiveImageTableViewCell.h"

@implementation LiveImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withImageInfo:(ImageInfo *)info
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        float width = info.width;
        float height = info.height;
        NSString *thumbURL = info.thumbURL;
        float newHeight = height/width*CGRectGetWidth(self.frame);
        _photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), newHeight)];
        if([info.imageType isEqualToString:@"1"])
        {
            _photo.image = [UIImage imageNamed:thumbURL];
        }
        else
        {
            if([info.imageType isEqualToString:@"2"])
            {
                _photo.image = [UIImage imageWithData:info.imageData];
            }
        }
        
        [self.contentView addSubview:_photo];
        
        
        //        UIView * userPhotoBg = [[UIView alloc] initWithFrame:CGRectMake(15, newHeight-20, 50, 50)];
        //        userPhotoBg.backgroundColor = [UIColor colorHelpWithRed:248 green:243 blue:209 alpha:1];
        //        userPhotoBg.layer.cornerRadius = 25;
        //        [self.contentView addSubview:userPhotoBg];
        //
        //        _userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(20, newHeight-15, 40, 40)];
        //        _userPhoto.layer.cornerRadius = 20;
        //        _userPhoto.layer.masksToBounds = YES;
        //        _userPhoto.image = [UIImage imageNamed:@"200852691557175_2.jpg"];
        //        [self.contentView addSubview:_userPhoto];
        
        UIImageView * blur = [[UIImageView alloc] initWithFrame:CGRectMake(0, newHeight-50, CGRectGetWidth(self.frame), 50)];
        blur.image = [UIImage imageNamed:@"图片底下阴影.png"];
        [self.contentView addSubview:blur];
        
        UIView * infoBG = [[UIView alloc] initWithFrame:CGRectMake(0, newHeight-50, CGRectGetWidth(self.frame), 50)];
        infoBG.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:infoBG];
        
        UIImageView * addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 10, 15)];
        addressIcon.image = [UIImage imageNamed:@"位置.png"];
        [infoBG addSubview:addressIcon];
        
        _addressLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 150, 15)];
        _addressLab.font = [UIFont fontWithName:kBaseFont size:15];
        _addressLab.textAlignment = NSTextAlignmentLeft;
        _addressLab.backgroundColor = [UIColor clearColor];
        _addressLab.textColor = [UIColor whiteColor];
        [infoBG addSubview:_addressLab];
        
        _shareTime = [[UILabel alloc] initWithFrame:CGRectMake(35, 30, 150, 15)];
        _shareTime.font = [UIFont fontWithName:kBaseFont size:15];
        _shareTime.textAlignment = NSTextAlignmentLeft;
        _shareTime.backgroundColor = [UIColor clearColor];
        _shareTime.textColor = [UIColor whiteColor];
        [infoBG addSubview:_shareTime];
        
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(190, 10, 50, 15)];
        _userName.font = [UIFont fontWithName:kBaseFont size:15];
        _userName.adjustsFontSizeToFitWidth = YES;
        _userName.textAlignment = NSTextAlignmentLeft;
        _userName.backgroundColor = [UIColor clearColor];
        _userName.textColor = [UIColor whiteColor];
        [infoBG addSubview:_userName];
        
        UIView * shu1 = [[UIView alloc] initWithFrame:CGRectMake(241, 5, 1, 40)];
        shu1.backgroundColor = [UIColor whiteColor];
        shu1.alpha = 0.3;
        [infoBG addSubview:shu1];
        
        UIImageView * commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(252, 10, 15, 15)];
        commentIcon.image = [UIImage imageNamed:@"评论.png"];
        [infoBG addSubview:commentIcon];
        
        _commentNumLab = [[UILabel alloc] initWithFrame:CGRectMake(240, 30, 40, 15)];
        _commentNumLab.font = [UIFont fontWithName:kBaseFont size:15];
        _commentNumLab.adjustsFontSizeToFitWidth = YES;
        _commentNumLab.textAlignment = NSTextAlignmentCenter;
        _commentNumLab.backgroundColor = [UIColor clearColor];
        _commentNumLab.textColor = [UIColor whiteColor];
        [infoBG addSubview:_commentNumLab];
        
        UIView * shu2 = [[UIView alloc] initWithFrame:CGRectMake(281, 5, 1, 40)];
        shu2.alpha = 0.3;
        shu2.backgroundColor = [UIColor whiteColor];
        [infoBG addSubview:shu2];
        
        UIImageView * zanIcon = [[UIImageView alloc] initWithFrame:CGRectMake(292, 10, 15, 15)];
        zanIcon.image = [UIImage imageNamed:@"点赞.png"];
        [infoBG addSubview:zanIcon];
        
        _zanNumLab = [[UILabel alloc] initWithFrame:CGRectMake(280, 30, 40, 15)];
        _zanNumLab.font = [UIFont fontWithName:kBaseFont size:15];
        _zanNumLab.adjustsFontSizeToFitWidth = YES;
        _zanNumLab.textAlignment = NSTextAlignmentCenter;
        _zanNumLab.backgroundColor = [UIColor clearColor];
        _zanNumLab.textColor = [UIColor whiteColor];
        [infoBG addSubview:_zanNumLab];
        
        //        UIButton * userPhotoBut = [[UIButton alloc] initWithFrame:CGRectMake(15, newHeight-20, 50, 50)];
        //        [userPhotoBut addTarget:self action:@selector(userPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [self.contentView addSubview:userPhotoBut];
        
        
        //        _userName = [[UILabel alloc] initWithFrame:CGRectMake(70, newHeight+7, 150, 20)];
        //        _userName.textAlignment = NSTextAlignmentLeft;
        //        _userName.backgroundColor = [UIColor clearColor];
        //        _userName.textColor = [UIColor blackColor];
        //        _userName.font = [UIFont fontWithName:kBaseFont size:15];
        //        _userName.text = @"旅行专家";
        //        [self.contentView addSubview:_userName];
        //
        //        _browseNumb = [[UILabel alloc] initWithFrame:CGRectMake(230, newHeight+2, 80, 15)];
        //        _browseNumb.textAlignment = NSTextAlignmentLeft;
        //        _browseNumb.backgroundColor = [UIColor clearColor];
        //        _browseNumb.textColor = [UIColor grayColor];
        //        _browseNumb.font = [UIFont fontWithName:kBaseFont size:13];
        //        _browseNumb.text = @"88次浏览";
        //        [self.contentView addSubview:_browseNumb];
        //
        //        _shareTime = [[UILabel alloc] initWithFrame:CGRectMake(230, newHeight+18, 80, 15)];
        //        _shareTime.textAlignment = NSTextAlignmentLeft;
        //        _shareTime.backgroundColor = [UIColor clearColor];
        //        _shareTime.textColor = [UIColor grayColor];
        //        _shareTime.font = [UIFont fontWithName:kBaseFont size:13];
        //        _shareTime.text = @"08:27";
        //        [self.contentView addSubview:_shareTime];
    }
    return self;
}

-(void)userPhotoClick:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(LiveImageUserButClick:)])
    {
        [self.delegate LiveImageUserButClick:@"200852691557175_2.jpg"];
    }
}

@end
