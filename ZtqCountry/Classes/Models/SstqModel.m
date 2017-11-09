//
//  SstqModel.m
//  ZtqNew
//
//  Created by linxg on 12-6-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SstqModel.h"

@implementation SstqModel

@synthesize ct;		//当前温度
@synthesize gdt;	//公历日期
@synthesize ldt;	//农历日期
@synthesize higt;	//高温
@synthesize lowt;	//低温
@synthesize upt;	//更新时间 2012-06-11 10:43
@synthesize wd;		//天气描述
@synthesize wd_ico;	//天气图标
@synthesize week;	//星期
@synthesize wind;	//风描述
@synthesize wd_daytime;	//白天天气描述
@synthesize wd_night;	//晚上天气描述
@synthesize isNight;  //判断是否为夜晚数据
@synthesize humidity;  //湿度
@synthesize pm25;
@synthesize sixhtq;
@synthesize is_early;
@synthesize tsrz;//节日
@synthesize wd_night_ico;//晚上天气图标
@synthesize recome;
@synthesize topic;
@synthesize topfx;
@synthesize downfx;
@synthesize recome_fx;
@synthesize topic_fx;
@synthesize aqi;
@synthesize Data;
//
//- (void) dealloc
//{
//	[ct release];
//	[gdt release];
//	[ldt release];
//	[higt release];
//	[lowt release];
//	[upt release];
//	[wd release];
//	[wd_ico release];
//	[week release];
//	[wind release];
//	[wd_daytime release];
//	[wd_night release];
//	[humidity release];
//    [pm25 release];
//    [sixhtq release];
//    [is_early release];
//    [tsrz release];
//	[wd_night_ico release];
//    [recome release];
//    [topic release];
//    [topfx release];
//    [downfx release];
//    [recome_fx release];
//    [topic_fx release];
//	[super dealloc];
//}

@end
