//
//  HDWebJSbean.m
//  ztqFj
//
//  Created by 胡彭飞 on 2017/1/20.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import "HDWebJSbean.h"

@implementation HDWebJSbean
-(void)my:(NSString *)message1 Share:(NSString *)message2
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReciviceWebBeanData" object:@{@"act_id":message1,@"share_type":message2}];


}
@end
