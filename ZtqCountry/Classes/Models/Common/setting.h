//
//  setting.h
//  Ztq_public
//
//  Created by yu lz on 12-1-4.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "config.h"
#import "OpenUDID.h"
#import "SSKeychain.h"

#include <ifaddrs.h>
#include <arpa/inet.h>


//SSKeychain的几个参数
#define pcsserviceName @"com.pcs.Service"
#define appAccount @"OpenUDID"

@interface setting : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
	NSMutableArray *citys;
    NSMutableArray *memos;
	NSString *app;
    NSString *currentCity;
    NSString * currentCityID;
	NSString *fs;
    NSString *morencity;
    NSString *morencityID;
    NSString *dingweicity;
    NSString *systime;
    NSString *dwstreet;
//	NSInteger idx;
//	NSInteger index;//首页生活指数选择
//	NSInteger updateInterval;//更新间隔，单位秒
//	NSInteger provinceIndex;//插件省份索引
	
	NSString *appFile;
	NSString *devToken;
	NSDictionary *lifedic;
	//静态信息，从服务端获取
//	NSString *info_shareWeather;
//	NSString *info_recommend;
//	NSString *ztq_about;
    
    
}

@property (nonatomic, retain)NSMutableArray *citys;
@property (nonatomic, retain)NSMutableArray *memos;
@property (nonatomic, retain)NSString *app;
@property (nonatomic, retain)NSString *currentCity;
@property (nonatomic, retain)NSString *currentCityID;
@property (nonatomic, retain)NSString *dingweicity;
@property (nonatomic, retain)NSString *morencity;
@property (nonatomic, retain)NSString *morencityID;
@property(nonatomic,retain)NSString *systime;
@property (nonatomic, retain)NSString *fs;
@property(nonatomic,retain)NSDictionary *lifedic;
@property(nonatomic,strong)NSString *dwstreet;
@property (nonatomic, strong) NSMutableDictionary * meterologicalDic;
@property (nonatomic,strong)NSMutableDictionary *memodic;//日历备忘信息
//@property (nonatomic)NSInteger idx;
//@property (nonatomic)NSInteger index;
//@property (nonatomic)NSInteger updateInterval;
//@property (nonatomic)NSInteger provinceIndex;
@property (nonatomic, retain)NSString *devToken;

@property (nonatomic, retain)NSString *info_shareWeather;
@property (nonatomic, retain)NSString *info_recommend;
@property (nonatomic, retain)NSString *ztq_about;

@property (strong, nonatomic) NSMutableData * themeImgData;
@property (strong, nonatomic) UIImage * themeImg;


+ (setting*) sharedSetting;
- (void) loadSetting;
- (void) saveSetting;

//获取软件版本号
+ (NSString *) getMainVersion;
//获取软件编号
+ (NSString *) getMainApp;
//获取发布渠道
+ (NSString *) getChannel;
//获取系统硬件编号(唯一编码)
+ (NSString *) getSysUid;
//获取系统版本号
+ (NSString *) getSysVersion;
//获取SIM卡编号
+ (NSString *) getImsi;
//获取手机型号
+ (NSString *) getmodel;
//获取主屏幕高度
+ (NSInteger) getMainScreenHeght;
//获取主屏幕宽度
+ (NSInteger) getMainScreenWidth;
//获取8位随机验证码
+(NSString *)getcode;

//-(void)loadthemeImg;
//
//-(void)initApp;
//+(void)pretreatmentWeather;
//+(void)pretreatmentMainView;
//+(void)pretreatmentOtherView;



@end
