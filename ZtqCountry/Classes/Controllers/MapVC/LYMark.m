//
//  LYMark.m
//  ZtqCountry
//
//  Created by Admin on 15/7/3.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "LYMark.h"

@implementation LYMark
-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString *)t{
    self = [super init];
    if(self){
        _coordinate = c;
        _title = t;
    }
    return self;
}
@end
