//
//  JierijieqiAlert.h
//  ZtqCountry
//
//  Created by linxg on 14-9-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JierijieqiAlert : UIView

@property (strong, nonatomic) UIImageView * logoImg;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UILabel * contentLab;
@property (strong, nonatomic) UIImageView * backgroundImageView;

-(void)show;
-(void)hiden;

-(id)initWithTitle:(NSString *)titleStr withLogoImageName:(NSString *)logoStr withContentStr:(NSString *)content;

@end


