//
//  LiveUserInfoCell.h
//  ZtqCountry
//
//  Created by linxg on 14-8-18.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiveUserInfoCellDelegate <NSObject>

-(void)liveUserImageClick;

@end

@interface LiveUserInfoCell : UITableViewCell

@property (strong, nonatomic) UIImageView * userImgV;
@property (strong, nonatomic) UILabel * userNameLabel;
@property (strong, nonatomic) UILabel * browseLabel;
@property (weak, nonatomic) id<LiveUserInfoCellDelegate>delegate;

@end
