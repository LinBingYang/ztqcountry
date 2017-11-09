//
//  ZXModel.m
//  ZtqCountry
//
//  Created by 派克斯科技 on 16/10/26.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "ZXModel.h"

@implementation ZXModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    NSLog(@"%@-----%@", value, key);
    if ([key isEqualToString:@"id"]) {
        self.IId = value;
    }
}


@end
