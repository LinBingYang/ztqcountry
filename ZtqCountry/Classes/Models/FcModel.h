//
//  FcModel.h
//  ZtqNew
//
//  Created by wang zw on 12-6-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FcModel : NSObject {

	NSString *gdt;  //公历日期
	NSString *week;  //星期
	NSString *wd_ico;  //天气图标
	NSString *wd;  //天气描述
	NSString *higt;  //最高温
	NSString *lowt;  //最低温
	NSString *wd_daytime;  //白天天气描述
	NSString *wd_daytime_ico;  //白天天气图标
	NSString *wd_night;  //晚上天气描述
	NSString *wd_night_ico;  //晚上天气图标
	NSString *wind;  //风况
    NSString *isnight;
}

@property(nonatomic, strong)NSString *gdt;	//公历日期
@property(nonatomic, strong)NSString *week;	//星期
@property(nonatomic, strong)NSString *wd_ico;//天气图标
@property(nonatomic, strong)NSString *wd;	//天气描述
@property(nonatomic, strong)NSString *higt;	//最高温
@property(nonatomic, strong)NSString *lowt;	//最低温
@property(nonatomic, strong)NSString *wd_daytime;  //白天天气描述
@property(nonatomic, strong)NSString *wd_daytime_ico;  //白天天气图标
@property(nonatomic, strong)NSString *wd_night;  //晚上天气描述
@property(nonatomic, strong)NSString *wd_night_ico;  //晚上天气图标
@property(nonatomic, strong)NSString *wind;  //风况
@property(nonatomic,strong)NSString *isnight;
@end
