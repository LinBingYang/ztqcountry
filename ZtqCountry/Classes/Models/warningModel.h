//
//  warningModel.h
//  ZtqNew
//
//  Created by wang zw on 12-7-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dwsModel.h"

@interface warningModel : NSObject {
	NSString *citys;  //城市列表，用;分隔
	NSString *dws_city_name;  //城市预警名称
	NSArray *dws_city_list;  //城市预警
	NSString *dws_sh_name;  //山洪预警名称
	NSArray *dws_sh_list;  //山洪预警
	NSString *dws_province_name;  //省预警名称
	NSArray *dws_province_list;  //省预警
}

@property (nonatomic, strong)NSString *citys;  //城市列表，用;分隔
@property (nonatomic, strong)NSString *dws_city_name;  //城市预警名称
@property (nonatomic, strong)NSArray *dws_city_list;  //城市预警
@property (nonatomic, strong)NSString *dws_sh_name;  //山洪预警名称
@property (nonatomic, strong)NSArray *dws_sh_list;  //山洪预警
@property (nonatomic, strong)NSString *dws_province_name;  //省预警名称
@property (nonatomic, strong)NSArray *dws_province_list;  //省预警

@end
