//
//  LiveHeadNoTableViewCell.h
//  ZtqCountry
//
//  Created by linxg on 14-9-3.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageInfo.h"
@protocol zanDelegte <NSObject>

-(void)zanActionWithTag;
-(void)grzxAction;
@end
@interface LiveHeadNoTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel * userName;
@property (strong, nonatomic) UILabel * addressLab;
@property (strong, nonatomic) UIImageView * photo;
@property (strong, nonatomic) UILabel * browseNumLab;
@property (strong, nonatomic) UILabel * answerNumLab;
@property (strong, nonatomic) UILabel * attentionLab;
@property (strong, nonatomic) UIButton * guanyuBut;
@property (weak, nonatomic) id<zanDelegte>delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withImageInfo:(ImageInfo *)info withtype:(int)type;

@end
