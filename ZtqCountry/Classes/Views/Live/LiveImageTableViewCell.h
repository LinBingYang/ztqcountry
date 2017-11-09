//
//  LiveImageTableViewCell.h
//  ZtqCountry
//
//  Created by linxg on 14-8-8.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageInfo.h"

@protocol LiveImageDelegate <NSObject>

-(void)LiveImageUserButClick:(NSString *)imageName;

@end

@interface LiveImageTableViewCell : UITableViewCell

//@property (strong, nonatomic) UIImageView * userPhoto;
@property (strong, nonatomic) UILabel * userName;
@property (strong, nonatomic) UILabel * addressLab;
//@property (strong, nonatomic) UILabel * browseNumb;
@property (strong, nonatomic) UILabel * shareTime;
@property (strong, nonatomic) UIImageView * photo;
@property (strong, nonatomic) UILabel * commentNumLab;
@property (strong, nonatomic) UILabel * zanNumLab;
@property (weak, nonatomic) id<LiveImageDelegate>delegate;


@property (assign, nonatomic) BOOL zanState;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withImageInfo:(ImageInfo *)info;

@end
