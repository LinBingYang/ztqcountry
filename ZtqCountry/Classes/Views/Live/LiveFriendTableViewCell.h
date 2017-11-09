//
//  LiveFriendTableViewCell.h
//  ZtqCountry
//
//  Created by linxg on 14-8-8.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiveFriendButtonClickDelegate <NSObject>

-(void)friendButtonClickWithImage:(NSString *)img;

@end

@interface LiveFriendTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView * userImg;
@property (strong, nonatomic) UILabel * userName;
@property (strong, nonatomic) UILabel * commentLab;
@property (strong, nonatomic) UILabel * timeLab;
//@property (strong, nonatomic) NSMutableArray * friendsInfos;
//@property (strong, nonatomic) UILabel * numbLab;
//@property (strong, nonatomic) UIView * friendsBG;
//@property (weak, nonatomic) id<LiveFriendButtonClickDelegate>delegate;

@end
