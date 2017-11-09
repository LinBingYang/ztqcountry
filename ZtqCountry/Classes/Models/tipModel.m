//
//  tipModel.m
//  ZtqNew
//
//  Created by wang zw on 12-6-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "tipModel.h"


@implementation tipModel

@synthesize desc;  //简短描述
@synthesize inf;  //信息内容
@synthesize ico;  //信息图标
@synthesize colo;  //字体颜色
@synthesize url;  //信息链接
@synthesize pt;  //开始显示时间
@synthesize et;  //结束显示时间
@synthesize typ;  //信息类型

@synthesize put_str;

//- (void) dealloc
//{
//	[put_str release];
//	[desc release];
//	[inf release];
//	[ico release];
//	[colo release];
//	[url release];
//	[pt release];
//	[et release];
//	[typ release];
//
//	
//	[super dealloc];
//}

@end
