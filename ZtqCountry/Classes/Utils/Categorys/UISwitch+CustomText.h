//
//  UISwitch+CustomText.h
//  ZtqCountry
//
//  Created by linxg on 14-8-8.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISwitch (CustomText)

@property (nonatomic, readonly) UILabel * label1;
@property (nonatomic, readonly) UILabel * label2;


+(UISwitch *)switchWithLeftText:(NSString *)tag1 andRight:(NSString *)tag2;

@end
