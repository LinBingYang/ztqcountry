//
//  SstqModel.h
//  ZtqNew
//
//  Created by linxg on 12-6-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SstqModel : NSObject {
	
	NSString *gdt;	//公历日期
	NSString *ldt;	//农历日期
	NSString *week;	//星期
	NSString *upt;	//更新时间 2012-06-11 10:43
	NSString *ct;	//当前温度
	NSString *wd;	//天气描述
	NSString *wd_ico;//天气图标
	NSString *higt;	//高温
	NSString *lowt;	//低温
	NSString *wind;	//风描述
	NSString *wd_daytime;//白天天气描述
	NSString *wd_night;//晚上天气描述
    NSString *wd_night_ico;//晚上天气图标
	BOOL isNight;//判断是否为夜晚数据
	NSString *humidity;  //湿度
    NSString *pm25;//pm25
    NSString *sixhtq;//6小时预报
    NSString *is_early;//是否为凌晨数据
    NSString *tsrz;//节日
    NSString *recome;//专题
    NSString *topic;//推荐
    NSString *topfx;//广告头
    NSString *downfx;//广告尾
    NSString *recome_fx;//分享
    NSString *topic_fx;//分享
    NSString *aqi;//aqi
    
    NSMutableArray *Data;
}

@property(nonatomic, strong)NSString *ct;	//当前温度
@property(nonatomic, strong)NSString *gdt;	//公历日期
@property(nonatomic, strong)NSString *ldt;	//农历日期
@property(nonatomic, strong)NSString *higt;	//高温
@property(nonatomic, strong)NSString *lowt;	//低温
@property(nonatomic, strong)NSString *upt;	//更新时间 2012-06-11 10:43
@property(nonatomic, strong)NSString *wd;	//天气描述
@property(nonatomic, strong)NSString *wd_ico;//天气图标
@property(nonatomic, strong)NSString *week;	//星期
@property(nonatomic, strong)NSString *wind;	//风描述
@property(nonatomic, strong)NSString *wd_daytime;	//白天天气描述
@property(nonatomic, strong)NSString *wd_night;	//晚上天气描述
@property (nonatomic, assign) BOOL isNight;//判断是否为夜晚数据
@property(nonatomic, strong)NSString *humidity;  //湿度
@property(nonatomic,strong)NSString *pm25;
@property(nonatomic,strong)NSString *sixhtq;
@property(nonatomic,strong)NSString *is_early;
@property(nonatomic,strong)NSString *tsrz;//节日
@property(nonatomic,strong) NSString *wd_night_ico;//晚上天气图标
@property(nonatomic,strong)NSString *recome;
@property(nonatomic,strong)NSString *topic;
@property(nonatomic,strong)NSString *topfx;
@property(nonatomic,strong)NSString *downfx;
@property(nonatomic,strong)NSString *recome_fx;
@property(nonatomic,strong)NSString *topic_fx;
@property(nonatomic,strong)NSString *aqi;

@property(nonatomic,strong)NSMutableArray*Data;
@end
