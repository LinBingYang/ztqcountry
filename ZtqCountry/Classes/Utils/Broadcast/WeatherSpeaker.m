//
//  WeatherSpeaker.m
//  HttpTest
//
//  Created by on 11-12-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherSpeaker.h"

static WeatherSpeaker *shareWeatherSpeaker;

@implementation WeatherSpeaker
@synthesize speaking, delegate;

+ (id) shareWeatherSpeaker
{
	@synchronized(self){
        if (!shareWeatherSpeaker) {
            shareWeatherSpeaker = [[WeatherSpeaker alloc] init];
        }
    }
    return shareWeatherSpeaker;
}

- (id)init
{
	if (self = [super init])
	{
		textArray = [[NSMutableArray alloc] initWithCapacity:4];
		
		textLib = [[NSMutableArray alloc] initWithCapacity:4];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"知天气为您播报最新天气预报" forKey:@"知天气为您播报最新天气预报"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"今天白天" forKey:@"今天白天"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"今天夜间" forKey:@"今天夜间"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"明天白天" forKey:@"明天白天"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"明天夜间" forKey:@"明天夜间"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"后天白天" forKey:@"后天白天"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"后天夜间" forKey:@"后天夜间"]];
		
		[textLib addObject:[NSDictionary dictionaryWithObject:@"最高温度零下" forKey:@"最高温度零下"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"最低温度零下" forKey:@"最低温度零下"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"最高温度" forKey:@"最高温度"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"最低温度" forKey:@"最低温度"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"现在温度" forKey:@"现在温度"]];

		[textLib addObject:[NSDictionary dictionaryWithObject:@"晴转" forKey:@"晴转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"晴" forKey:@"晴"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"多云转" forKey:@"多云转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"多云" forKey:@"多云"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"暴雨转" forKey:@"暴雨转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"暴雨" forKey:@"暴雨"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"暴雪转" forKey:@"暴雪转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"暴雪" forKey:@"暴雪"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"小雨转" forKey:@"小雨转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"小雨" forKey:@"小雨"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"小雪转" forKey:@"小雪转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"小雪" forKey:@"小雪"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"阵雪转" forKey:@"阵雪转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"阵雪" forKey:@"阵雪"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"大雨转" forKey:@"大雨转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"大雨" forKey:@"大雨"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"中雨转" forKey:@"中雨转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"中雨" forKey:@"中雨"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"中雪" forKey:@"中雪"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"冻雨转" forKey:@"冻雨转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"冻雨" forKey:@"冻雨"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"大雪转" forKey:@"大雪转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"大雪" forKey:@"大雪"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"大暴雨转" forKey:@"大暴雨转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"大暴雨" forKey:@"大暴雨"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"阵风" forKey:@"阵风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"雨夹雪转" forKey:@"雨夹雪转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"雨夹雪" forKey:@"雨夹雪"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"雪暴" forKey:@"雪暴"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"雾转" forKey:@"雾转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"雾凇" forKey:@"雾凇"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"雾" forKey:@"雾"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"霜" forKey:@"霜"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"霾" forKey:@"霾"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"露" forKey:@"露"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"龙卷" forKey:@"龙卷"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"雷阵雨转" forKey:@"雷阵雨转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"雷阵雨并伴有冰雹转" forKey:@"雷阵雨并伴有冰雹转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"雷阵雨并伴有冰雹" forKey:@"雷阵雨并伴有冰雹"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"雷阵雨" forKey:@"雷阵雨"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"雷暴" forKey:@"雷暴"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"静风" forKey:@"静风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"飑" forKey:@"飑"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"阵雨转" forKey:@"阵雨转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"阵雨" forKey:@"阵雨"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"阴转" forKey:@"阴转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"阴" forKey:@"阴"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"西南偏西风" forKey:@"西南偏西风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"西南风" forKey:@"西南风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"西风11-12级转" forKey:@"西风11-12级转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"西风9-10级转" forKey:@"西风9-10级转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"西风7-8级转" forKey:@"西风7-8级转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"西风5-6级转" forKey:@"西风5-6级转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"西风3-4级转" forKey:@"西风3-4级转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"西风1-2级转" forKey:@"西风1-2级转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"西风" forKey:@"西风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"闪电" forKey:@"闪电"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"轻雾" forKey:@"轻雾"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"烟幕" forKey:@"烟幕"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"西南偏南风" forKey:@"西南偏南风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"西北偏西风" forKey:@"西北偏西风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"西北偏北风" forKey:@"西北偏北风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"西北风" forKey:@"西北风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"特大暴雨转" forKey:@"特大暴雨转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"特大暴雨" forKey:@"特大暴雨"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"沙尘暴转" forKey:@"沙尘暴转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"沙尘暴" forKey:@"沙尘暴"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"米每秒" forKey:@"米每秒"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"结冰" forKey:@"结冰"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"积雪" forKey:@"积雪"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"浮尘转" forKey:@"浮尘转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"浮尘" forKey:@"浮尘"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"扬沙转" forKey:@"扬沙转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"扬沙" forKey:@"扬沙"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"星期一" forKey:@"星期一"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"星期二" forKey:@"星期二"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"星期三" forKey:@"星期三"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"星期四" forKey:@"星期四"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"星期五" forKey:@"星期五"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"星期六" forKey:@"星期六"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"星期日" forKey:@"星期日"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"强沙尘暴转" forKey:@"强沙尘暴转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"强沙尘暴" forKey:@"强沙尘暴"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"极光" forKey:@"极光"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"南风" forKey:@"南风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"大风" forKey:@"大风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"吹雪" forKey:@"吹雪"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"尘卷风" forKey:@"尘卷风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"东南偏南风" forKey:@"东南偏南风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"东南偏东风" forKey:@"东南偏东风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"东南风" forKey:@"东南风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"东风" forKey:@"东风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"东北偏东风" forKey:@"东北偏东风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"东北偏北风" forKey:@"东北偏北风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"东北风" forKey:@"东北风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"北风" forKey:@"北风"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"11-12级" forKey:@"11-12级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"9-10级" forKey:@"9-10级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"7-8级" forKey:@"7-8级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"5-6级" forKey:@"5-6级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"3-4级" forKey:@"3-4级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"1-2级" forKey:@"1-2级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"12级" forKey:@"12级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"11级" forKey:@"11级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"10级" forKey:@"10级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"9级" forKey:@"9级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"8级" forKey:@"8级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"7级" forKey:@"7级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"6级" forKey:@"6级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"5级" forKey:@"5级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"4级" forKey:@"4级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"3级" forKey:@"3级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"2级" forKey:@"2级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"1级" forKey:@"1级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"0级" forKey:@"0级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"40摄氏度" forKey:@"40℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"39摄氏度" forKey:@"39℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"38摄氏度" forKey:@"38℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"37摄氏度" forKey:@"37℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"36摄氏度" forKey:@"36℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"35摄氏度" forKey:@"35℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"34摄氏度" forKey:@"34℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"33摄氏度" forKey:@"33℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"32摄氏度" forKey:@"32℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"31摄氏度" forKey:@"31℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"30摄氏度" forKey:@"30℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"29摄氏度" forKey:@"29℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"28摄氏度" forKey:@"28℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"27摄氏度" forKey:@"27℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"26摄氏度" forKey:@"26℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"25摄氏度" forKey:@"25℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"24摄氏度" forKey:@"24℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"23摄氏度" forKey:@"23℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"22摄氏度" forKey:@"22℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"21摄氏度" forKey:@"21℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"20摄氏度" forKey:@"20℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"19摄氏度" forKey:@"19℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"18摄氏度" forKey:@"18℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"17摄氏度" forKey:@"17℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"16摄氏度" forKey:@"16℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"15摄氏度" forKey:@"15℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"14摄氏度" forKey:@"14℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"13摄氏度" forKey:@"13℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"12摄氏度" forKey:@"12℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"11摄氏度" forKey:@"11℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"10摄氏度" forKey:@"10℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"9摄氏度" forKey:@"9℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"8摄氏度" forKey:@"8℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"7摄氏度" forKey:@"7℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"6摄氏度" forKey:@"6℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"5摄氏度" forKey:@"5℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"4摄氏度" forKey:@"4℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"3摄氏度" forKey:@"3℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"2摄氏度" forKey:@"2℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"1摄氏度" forKey:@"1℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"0摄氏度" forKey:@"0℃"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"40" forKey:@"40"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"39" forKey:@"39"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"38" forKey:@"38"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"37" forKey:@"37"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"36" forKey:@"36"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"35" forKey:@"35"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"34" forKey:@"34"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"33" forKey:@"33"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"32" forKey:@"32"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"31" forKey:@"31"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"30" forKey:@"30"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"29" forKey:@"29"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"28" forKey:@"28"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"27" forKey:@"27"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"26" forKey:@"26"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"25" forKey:@"25"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"24" forKey:@"24"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"23" forKey:@"23"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"22" forKey:@"22"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"21" forKey:@"21"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"20" forKey:@"20"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"19" forKey:@"19"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"18" forKey:@"18"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"17" forKey:@"17"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"16" forKey:@"16"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"15" forKey:@"15"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"14" forKey:@"14"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"13" forKey:@"13"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"12" forKey:@"12"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"11" forKey:@"11"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"10" forKey:@"10"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"9" forKey:@"9"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"8" forKey:@"8"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"7" forKey:@"7"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"6" forKey:@"6"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"5" forKey:@"5"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"4" forKey:@"4"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"3" forKey:@"3"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"2"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"1"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"0"]];	
		[textLib addObject:[NSDictionary dictionaryWithObject:@"转" forKey:@"转"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"偏" forKey:@"偏"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"至" forKey:@"至"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"到" forKey:@"-"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"到" forKey:@"到"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"或" forKey:@"或"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"点" forKey:@"."]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"级" forKey:@"级"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@" " forKey:@" "]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"，" forKey:@"，"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"。" forKey:@"。"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"福州" forKey:@"福州"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"三明" forKey:@"三明"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"上杭" forKey:@"上杭"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"东山" forKey:@"东山"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"云霄" forKey:@"云霄"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"仙游" forKey:@"仙游"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"光泽" forKey:@"光泽"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"华安" forKey:@"华安"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"南安" forKey:@"南安"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"南平" forKey:@"南平"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"南靖" forKey:@"南靖"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"厦门" forKey:@"厦门"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"同安" forKey:@"同安"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"古田" forKey:@"古田"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"周宁" forKey:@"周宁"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"宁化" forKey:@"宁化"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"宁德" forKey:@"宁德"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"大田" forKey:@"大田"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"安溪" forKey:@"安溪"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"寿宁" forKey:@"寿宁"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"将乐" forKey:@"将乐"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"尤溪" forKey:@"尤溪"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"屏南" forKey:@"屏南"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"崇武" forKey:@"崇武"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"平和" forKey:@"平和"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"平潭" forKey:@"平潭"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"建宁" forKey:@"建宁"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"建瓯" forKey:@"建瓯"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"建阳" forKey:@"建阳"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"德化" forKey:@"德化"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"惠安" forKey:@"惠安"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"政和" forKey:@"政和"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"明溪" forKey:@"明溪"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"晋江" forKey:@"晋江"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"松溪" forKey:@"松溪"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"柘荣" forKey:@"柘荣"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"武夷山" forKey:@"武夷山"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"武平" forKey:@"武平"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"永安" forKey:@"永安"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"永定" forKey:@"永定"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"永春" forKey:@"永春"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"永泰" forKey:@"永泰"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"沙县" forKey:@"沙县"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"泉州" forKey:@"泉州"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"泰宁" forKey:@"泰宁"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"浦城" forKey:@"浦城"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"清流" forKey:@"清流"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"漳州" forKey:@"漳州"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"漳平" forKey:@"漳平"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"漳浦" forKey:@"漳浦"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"石狮" forKey:@"石狮"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"福安" forKey:@"福安"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"福州" forKey:@"福州"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"福清" forKey:@"福清"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"福鼎" forKey:@"福鼎"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"秀屿港" forKey:@"秀屿港"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"秀屿" forKey:@"秀屿"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"罗源" forKey:@"罗源"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"莆田" forKey:@"莆田"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"诏安" forKey:@"诏安"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"连城" forKey:@"连城"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"连江" forKey:@"连江"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"邵武" forKey:@"邵武"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"长乐" forKey:@"长乐"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"长汀" forKey:@"长汀"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"长泰" forKey:@"长泰"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"闽侯" forKey:@"闽侯"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"闽清" forKey:@"闽清"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"霞浦" forKey:@"霞浦"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"顺昌" forKey:@"顺昌"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"龙岩" forKey:@"龙岩"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"龙海" forKey:@"龙海"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"背景音-5" forKey:@"背景音-5"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"大" forKey:@"大"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"中" forKey:@"中"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"小" forKey:@"小"]];
		[textLib addObject:[NSDictionary dictionaryWithObject:@"零下" forKey:@"零下"]];

	}
	return self;
}

//- (void)dealloc
//{
//	[textLib release];
//	[textArray release];
//	[m_player release];
//	[m_playerBg release];
//	[super dealloc];
//}

- (void) speakWeather:(NSString *)text
{
	if (text == nil || [text length] == 0)
		return;
	
	[textArray removeAllObjects];
//	[textArray release];
	textArray = [[NSMutableArray alloc] initWithCapacity:4];

	NSString *textCopy = text;
	NSString *key = nil;
	NSString *value = nil;
	NSInteger length = [text length];
	int i = 0;
	
	while (i < length)
	{
		textCopy = [text substringFromIndex:i];
		for (int j=0; j<[textLib count]; j++)
		{
			NSDictionary *t_dic = (NSDictionary *)[textLib objectAtIndex:j];
			NSArray *allkeys = [t_dic allKeys];
			if ([allkeys count] > 0)
			{
				key = [allkeys objectAtIndex:0];
				value = [t_dic objectForKey:key];
				if ([textCopy hasPrefix:key])
				{
					[textArray addObject:value];
					i = i + [key length] - 1;
					break;
				}
			}
		}
		i++;
	}


	idx = 0;
	[self speakTextWithIndex:0];
	speaking = YES;
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	if (flag == YES)
	{
		idx++;
		if (m_player != nil)
		{
//			[m_player release];
			m_player = nil;
		}
		[self speakTextWithIndex:idx];
	}
	else 
	{
		[self stopSpeaking];
	}

}

- (void) speakTextWithIndex:(NSInteger) t_idx
{
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
	if (idx >= [textArray count])
	{
		[self stopSpeaking];
		return;
	}
    
    @autoreleasepool {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [[AVAudioSession sharedInstance] setDelegate:self];
        NSError *error = nil;
        BOOL b = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
        b = [audioSession setActive:YES error:&error];
        
        if (idx == 0)
        {
            NSString *soundPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"/yy_ios/背景音-5.mp3"];
            //[[NSBundle mainBundle] pathForResource:@"背景音-5" ofType:@"mp3"];
  
            NSURL * soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
            m_playerBg = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
//            NSLog(@"####pbg=%p####",m_playerBg);
            m_playerBg.meteringEnabled = YES;
            m_playerBg.volume = 1.0;
            //	t_player.delegate = self;
            [m_playerBg prepareToPlay];
            [m_playerBg play];
            
            
        }
        
        NSString *t_str = [textArray objectAtIndex:idx];
        NSString *t_str2 = [t_str stringByAppendingPathExtension:@"wav"];
        NSString *soundPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"/yy_ios/%@", t_str2]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:soundPath])
        {
            idx++;
            [self speakTextWithIndex:idx];
            return;
        }
        
        //[[NSBundle mainBundle] pathForResource:[textLib objectForKey:[textArray objectAtIndex:idx]] ofType:@"wav"];
        NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
        m_player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
//        NSLog(@"####p=%p####",m_player);
        m_player.meteringEnabled = YES;
        m_player.volume = 1.0;
        m_player.delegate = self;
        [m_player prepareToPlay];
        [m_player play];

    }
	
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [[AVAudioSession sharedInstance] setDelegate:self];
//    NSError *error = nil;
//    BOOL b = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
//	b = [audioSession setActive:YES error:&error];
//	
//	
//	if (idx == 0)
//	{
//		NSString *soundPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"/yy_ios/背景音-5.mp3"];
//		//[[NSBundle mainBundle] pathForResource:@"背景音-5" ofType:@"mp3"];
//		NSURL * soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
//		m_playerBg = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
//		m_playerBg.meteringEnabled = YES;
//		m_playerBg.volume = 1.0;
//		//	t_player.delegate = self;
//		[m_playerBg prepareToPlay];
//		[m_playerBg play];
//	}
//
//	NSString *t_str = [textArray objectAtIndex:idx];
//	NSString *t_str2 = [t_str stringByAppendingPathExtension:@"wav"];
//	NSString *soundPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"/yy_ios/%@", t_str2]];
//	if (![[NSFileManager defaultManager] fileExistsAtPath:soundPath])
//	{
//		idx++;
//		[self speakTextWithIndex:idx];
//		return;
//	}
//	
//	//[[NSBundle mainBundle] pathForResource:[textLib objectForKey:[textArray objectAtIndex:idx]] ofType:@"wav"];
//	NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
//	m_player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
//	m_player.meteringEnabled = YES;
//	m_player.volume = 1.0;
//	m_player.delegate = self;
//	[m_player prepareToPlay];
//	[m_player play];
//	
//	
//	
//
//
//	[pool release];
}

- (void) stopSpeaking
{
	idx = 0;
	speaking = NO;
	if (m_player != nil)
	{
		[m_player stop];
		m_player = nil;
	}
	if (m_playerBg != nil)
	{
		[m_playerBg stop];
		m_playerBg = nil;
	}
	
	if (delegate != nil)
		[delegate didPlayFinish];
}
@end
