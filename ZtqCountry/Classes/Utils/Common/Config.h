//
//  Config.h
//  ZtqCountry
//
//  Created by linxg on 14-6-10.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#ifndef ZtqCountry_Config_h
#define ZtqCountry_Config_h

#define kUMAppKey                   @"507fcab25270157b37000010"
#define kWXAppId                    @"wxe8c03b44d818926e"
#define kShareUrl                   @"weather.ikan365.cn"
#define kSystemVersionMore7         ([[UIDevice currentDevice].systemVersion doubleValue]>=7.0)
#define kSystemVersionMore8         ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0)
#define kSystemVersionMore9         ([[UIDevice currentDevice].systemVersion doubleValue]>=9.0)
#define kScreenHeitht               (kSystemVersionMore7?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.height-20)//[UIScreen mainScreen].bounds.size.height
#define kScreenWidth                [UIScreen mainScreen].bounds.size.width
#define kBaseFont                   @"Helvetica"
#define kWeatherFont                @"STHeitiTC-Light"//HelveticaNeue-UltraLight//Roboto
#define iPhone5                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define kMinVersoin (@"10313")
#define kMinApp (@"20002")//客户端标志
#define kReleaseDate (@"20131127")
#define kReleaseChannel (@"00000000");

#define kTestAddress @"http://218.85.78.125:8066/ztq30_gz/service.do"//测试
#define kDevelopment @"http://112.5.138.42:8099/ztq30_gz/service.do"//开发
#define ONLINE_URL @"http://www.fjqxfw.cn:8088/ztq30_gz/service.do"//
//#define ONLINE_URL @"http://218.104.235.90:8088/ztq30_gz/service.do"//线上
//#define kDevelopment @"http://112.5.138.42:8099/ztq30Service/service.do"
//#define ONLINE_URL @"http://ztq30.aikanonline.com/service.do"//线上

//微博 邮箱地址
#define ZTQ_SINA_WEIBO @"http://weibo.com/ztqkhd2011"
#define ZTQ_TX_WEIBO @"http://t.qq.com/ztq-zsqx"
#define ZTQ_Email @"ztq@china1168.com"

#define TEXT_SHARE_SMS @"我现在正在使用“知天气”掌上气象客户端，发觉还挺好用的，好东西大家齐分享，分享地址为：http://wap.weather.ikan365.cn。"

//定义存储在NSUserdefault中设置的名字
#define kSettingSwithchs            @"settingSwithchs"    //天气闹钟设置
#define kYuyinVersion               @"yuyinVersion"
#define kClockCity                  @"clockCity"//闹钟里面设置的城市
#define kYujingPushOpen             @"yujingtuisongkaiguan"//预警推送开关
#define kYujingPushCity             @"yujingtuisongcity"//预警推送城市
#define kTianqiPushOpen             @"tianqituisongkaiguan"//天气推送开关
#define kTianqiPushCity             @"tianqituisongcity"//天气推送城市
#define kJieriPushOpen              @"jierituisong"//节日推送
#define kJieqiPushOpen              @"jieqituisong"//节气推送
#define kzhuantiPushOpen            @"zhuantituisong"//专题推送
#define kchanpinPushOpen            @"chanpintuisong"//产品公告
#define kAutoShareOpen              @"autoShare"//自动分享

#define XYSSL_BASE64_C

#endif
