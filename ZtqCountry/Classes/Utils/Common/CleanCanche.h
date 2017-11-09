//
//  CleanCanche.h
//  ZtqCountry
//
//  Created by Admin on 15/7/7.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CleanCanche : UIView
@property (strong, nonatomic) UIImageView * logoImgV;
@property (strong, nonatomic) UILabel * titleLab;
-(id)initWithview:(UIView *)view withTitle:(NSString *)title withtype:(NSString *)type;
-(void)show;
-(void)hideenview;
@end
