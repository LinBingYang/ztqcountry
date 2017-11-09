//
//  LunarDB.h
//  Ztq_public
//
//  Created by linxg on 12-3-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//按公历计算的节日
@interface SolarHolidayStruct : NSObject 
{
	int Month;
	int Day;
	int Recess; //假期长度
	NSString *HolidayName;
}
@property (nonatomic, assign)int Month;
@property (nonatomic, assign)int Day;
@property (nonatomic, assign)int Recess;
@property (nonatomic, retain)NSString *HolidayName;
@end

//按农历计算的节日
@interface LunarHolidayStruct : NSObject
{
	int Month;
	int Day;
	int Recess;
	NSString *HolidayName;
}
@property (nonatomic, assign)int Month;
@property (nonatomic, assign)int Day;
@property (nonatomic, assign)int Recess;
@property (nonatomic, strong)NSString *HolidayName;
@end

//按某月第几个星期几的节日
@interface WeekHolidayStruct : NSObject
{
	int Month;
	int WeekAtMonth;
	int WeekDay;
	NSString *HolidayName;
}
@property (nonatomic, assign)int Month;
@property (nonatomic, assign)int WeekAtMonth;
@property (nonatomic, assign)int WeekDay;
@property (nonatomic, strong)NSString *HolidayName;
@end


@interface LunarDB : NSObject {
	
//基础变量
	NSDate *_date;
	int _cYear;
	int _cMonth;
	int _cDay;
	bool _cIsLeapMonth; //当月是否闰月
	bool _cIsLeapYear; //当年是否有闰月

	NSDate *MinDay;// = new DateTime(1900, 1, 30);
	NSDate *MaxDay;// = new DateTime(2049, 12, 31);
	NSDate *GanZhiStartDay;// = new DateTime(1899, 12, 22);//起始日
	NSDate *ChineseConstellationReferDay;// = new DateTime(2007, 9, 13);//28星宿参考值,本日为角
	
	NSMutableArray *sHolidayInfo;
	NSMutableArray *lHolidayInfo;
	NSMutableArray *wHolidayInfo;
	
	NSArray *_constellationName;
	NSArray *_lunarHolidayName;
	NSArray *_chineseConstellationName;
	NSArray *_yiStr;
	NSArray *_jiStr;
	NSArray *_riJianStr;
	NSArray *SolarTerm;
	NSArray *HZNum;
	NSArray *ganStr;
	NSArray *zhiStr;
	NSArray *animalStr;
	NSArray *nStr1;
	NSArray *nStr2;
	NSArray *_monthString;
}
@property (nonatomic, strong) NSDate * date;

//<公历日期初始化>
/// 用一个标准的公历日期来初使化
- (void) setSolarDate:(NSDate *)t_dt;
- (NSDate *) getSolarDate;

/// 用农历的日期来初使化
/// <param name="cy">农历年</param>
/// <param name="cm">农历月</param>
/// <param name="cd">农历日</param>
/// <param name="LeapFlag">闰月标志</param>
- (void) setLunarDate:(int)cy cm:(int)cm cd:(int)cd leap:(bool)leapMonthFlag;

///获取公历年月
- (NSString *) SolorDateString;
///获取公历周几
- (NSString *) SolorWeekDayString;
///获取公历日期
- (NSString *) SolorDayString;
/// 取农历日期表示法：农历一九九七年正月初五
- (NSString *) ChineseDateString;
/// 取当前日期的干支表示法如 甲子年乙丑月丙庚日
- (NSString *) GanZhiDateString;
/// 获取彭祖百忌。
- (NSString *) GetPengZuBaiJi;
/// 获取每日宜。
- (NSString *) GetDayYi;
/// 获取每日忌。
- (NSString *) GetDayJi;
/// 获取每日日建。
- (NSString *) GetDayRijian;
/// 获取生肖冲
- (NSString *) GetShengxiaoChong;
/// 获取每日生肖煞。
- (NSString *) GetShengxiaoSha;
/// 获取每日正冲。
- (NSString *) GetZhengChong;
/// 获取每日胎神。
- (NSString *) GetTaiSheng;
/// 28星宿计算
- (NSString *) ChineseConstellation;
/// 时辰
- (NSString *) ChineseHour;
/// 二十四节气
- (NSString *) ChineseTwentyFourDay;
/// 计算星座序号 
- (NSString *) Constellation;
/// 取属相字符串
- (NSString *) AnimalString;
//获取农历年份
- (NSString *) ChineseYear;
-(NSString *)ChineseMonth;//农历月份
- (NSString *)setBirthdaySolarDate:(NSDate *)t_dt;//农历
@end
