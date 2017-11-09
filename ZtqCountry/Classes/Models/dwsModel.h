//
//  dwsModel.h
//  ZtqNew
//
//  Created by wang zw on 12-6-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface dwsModel : NSObject {

	NSString *colo;  //颜色
	NSString *desc;  //简短描述
	NSString *et;  //结束显示时间
	NSString *ico;  //开始显示时间
	NSString *inf;  //信息内容
	NSString *pt;  //开始显示时间
	
	NSString *typ;  //山洪预警类型
	NSString *url;  //山洪预警html链接
	NSString *putStr; //发布时间及气象台描述
}

@property (nonatomic, strong)NSString *colo;  //颜色
@property (nonatomic, strong)NSString *desc;  //简短描述
@property (nonatomic, strong)NSString *et;  //结束显示时间
@property (nonatomic, strong)NSString *ico;  //开始显示时间
@property (nonatomic, strong)NSString *inf;  //信息内容
@property (nonatomic, strong)NSString *pt;  //开始显示时间

@property (nonatomic, strong)NSString *typ;  //山洪预警类型
@property (nonatomic, strong)NSString *url;  //山洪预警html链接
@property (nonatomic, strong)NSString *putStr; //发布时间及气象台描述

@end
