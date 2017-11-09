//
//  FcModel.m
//  ZtqNew
//
//  Created by wang zw on 12-6-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FcModel.h"


@implementation FcModel

@synthesize gdt;  //公历日期
@synthesize week;  //星期
@synthesize wd_ico;  //天气图标
@synthesize wd;  //天气描述
@synthesize higt;  //最高温
@synthesize lowt;  //最低温
@synthesize wd_daytime;  //白天天气描述
@synthesize wd_daytime_ico;  //白天天气图标
@synthesize wd_night;  //晚上天气描述
@synthesize wd_night_ico;  //晚上天气图标
@synthesize wind;  //风况
@synthesize isnight;
//- (void) dealloc
//{
//	[gdt release];
//	[week release];
//	[wd_ico release];
//	[wd release];
//	[higt release];
//	[lowt release];
//	[wd_daytime release];
//	[wd_daytime_ico release];
//	[wd_night release];
//	[wd_night_ico release];
//	[wind release];
//	
//	[super dealloc];
//}

@end
