//
//  tipModel.h
//  ZtqNew
//
//  Created by wang zw on 12-6-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface tipModel : NSObject {

	NSString *desc;  //简短描述
	NSString *inf;  //信息内容
	NSString *ico;  //信息图标
	NSString *colo;  //字体颜色
	NSString *url;  //信息链接
	NSString *pt;  //开始显示时间
	NSString *et;  //结束显示时间
	NSString *typ;  //信息类型
	
	NSString *put_str;
    

}

@property (nonatomic, strong)NSString *desc;  //简短描述
@property (nonatomic, strong)NSString *inf;  //信息内容
@property (nonatomic, strong)NSString *ico;  //信息图标
@property (nonatomic, strong)NSString *colo;  //字体颜色
@property (nonatomic, strong)NSString *url;  //信息链接
@property (nonatomic, strong)NSString *pt;  //开始显示时间
@property (nonatomic, strong)NSString *et;  //结束显示时间
@property (nonatomic, strong)NSString *typ;  //信息类型
@property (nonatomic, strong)NSString *put_str;


@end
