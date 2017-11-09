//
//  LiveFriendTableViewCell.m
//  ZtqCountry
//
//  Created by linxg on 14-8-8.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "LiveFriendTableViewCell.h"

@implementation LiveFriendTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createViews];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}


-(void)createViews
{
    //    UIImageView * zanLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 15)];
    //    zanLogo.image = [UIImage imageNamed:@""];
    //    [self.contentView addSubview:zanLogo];
    //
    //    _numbLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 50, 15)];
    //    _numbLab.textAlignment = NSTextAlignmentLeft;
    //    _numbLab.font = [UIFont fontWithName:kBaseFont size:13];
    //    _numbLab.backgroundColor = [UIColor clearColor];
    //    _numbLab.textColor = [UIColor grayColor];
    //    [self.contentView addSubview:_numbLab];
    //
    //    _friendsBG = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 250, 40)];
    //    _friendsBG.backgroundColor = [UIColor clearColor];
    //    [self.contentView addSubview:_friendsBG];
    
    _userImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    _userImg.layer.cornerRadius = 20;
    _userImg.layer.masksToBounds = YES;
    [self.contentView addSubview:_userImg];
    
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 150, 20)];
    _userName.backgroundColor = [UIColor clearColor];
    _userName.textAlignment = NSTextAlignmentLeft;
    _userName.textColor = [UIColor blackColor];
    _userName.font = [UIFont fontWithName:kBaseFont size:15];
    [self.contentView addSubview:_userName];
    
    _commentLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 200, 15)];
    _commentLab.backgroundColor = [UIColor clearColor];
    _commentLab.textAlignment = NSTextAlignmentLeft;
    _commentLab.textColor = [UIColor grayColor];
    _commentLab.font = [UIFont fontWithName:kBaseFont size:13];
    [self.contentView addSubview:_commentLab];
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-160, 5, 150, 15)];
    _timeLab.backgroundColor = [UIColor clearColor];
    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.textColor = [UIColor grayColor];
    _timeLab.font = [UIFont fontWithName:kBaseFont size:13];
    [self.contentView addSubview:_timeLab];
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 59, CGRectGetWidth(self.frame)-50, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line];
}

//-(void)setFriendsInfos:(NSMutableArray *)friendsInfos
//{
//    float space = 20;
//    _friendsInfos = friendsInfos;
//    _numbLab.text = [NSString stringWithFormat:@"%d",friendsInfos.count];
//    int num = friendsInfos.count>6?6:friendsInfos.count;
//    [_friendsBG.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    for(int i=0;i<num;i++)
//    {
//        NSDictionary * info = [friendsInfos objectAtIndex:i];
//        NSString * imageName = [info objectForKey:@"image"];
//        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(space+(space +30)*i, 5, 30, 30)];
//        view.layer.cornerRadius = 15;
//        view.backgroundColor = [UIColor whiteColor];
//        view.layer.shadowColor = [UIColor blackColor].CGColor;
//        view.layer.shadowRadius = 1;
//        view.layer.shadowOpacity = 0.6;
//        view.layer.shadowOffset = CGSizeMake(1, 1);
//        [_friendsBG addSubview:view];
//
//        UIImageView * friendPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 26, 26)];
//        friendPhoto.layer.cornerRadius = 13;
//        friendPhoto.layer.masksToBounds = YES;
//        friendPhoto.image = [UIImage imageNamed:imageName];
//        [view addSubview:friendPhoto];
//
//        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = i;
//        [view addSubview:button];
//    }
//}
//
//-(void)buttonAction:(UIButton *)sender
//{
//    NSDictionary * info = [self.friendsInfos objectAtIndex:sender.tag];
//    NSString * imageName = [info objectForKey:@"image"];
//    if([self.delegate respondsToSelector:@selector(friendButtonClickWithImage:)])
//    {
//        [self.delegate friendButtonClickWithImage:imageName];
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
