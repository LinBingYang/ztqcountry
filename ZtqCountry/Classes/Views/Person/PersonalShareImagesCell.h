//
//  PersonalShareImagesCell.h
//  ZtqCountry
//
//  Created by linxg on 14-9-4.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonalShareImagesCellDelegate <NSObject>

-(void)PersonalSahreImagesCellImageClickWithImage:(UIImage *)image;
-(void)zanActionWithIndexPath:(int)row;

@end

@interface PersonalShareImagesCell : UITableViewCell

@property (strong, nonatomic) NSArray * images;
@property (weak, nonatomic) id<PersonalShareImagesCellDelegate>delegate;

@property(assign)int row;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMonth:(NSString *)month withDay:(NSString *)day withComment:(NSString *)comment withAddress:(NSString *)address withZanNum:(NSString *)zanNum withImages:(NSArray *)images;

@end
