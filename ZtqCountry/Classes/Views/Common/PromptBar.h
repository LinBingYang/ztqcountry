//
//  PromptBar.h
//  ZtqCountry
//
//  Created by linxg on 14-7-16.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptBar : UIView

@property (weak, nonatomic) UIView * onView;

-(id)initWithMessage:(NSString *)message withOnView:(UIView *)onView;


-(void)showWithAnimation:(BOOL)animation;

@end
