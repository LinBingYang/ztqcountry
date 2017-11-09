//
//  LunarDB.m
//  Ztq_public
//
//  Created by linxg on 12-3-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LunarDB.h"

#define MAX_COUNT_LUNARDATE 151
#define MAX_COUNT_TERNINFO 24

//基础常量
const int MinYear = 1900;
const int MaxYear = 2050;
const int GanZhiStartYear = 1864; //干支计算起始年
const int AnimalStartYear = 1900; //1900年为鼠年


#pragma mark 阴历数据
/// <summary>
/// 来源于网上的农历数据
/// </summary>
/// <remarks>
/// 数据结构如下，共使用17位数据
/// 第17位：表示闰月天数，0表示29天   1表示30天
/// 第16位-第5位（共12位）表示12个月，其中第16位表示第一月，如果该月为30天则为1，29天为0
/// 第4位-第1位（共4位）表示闰月是哪个月，如果当年没有闰月，则置0
///</remarks>
static int LunarDateArray[MAX_COUNT_LUNARDATE]= {
    0x04BD8,0x04AE0,0x0A570,0x054D5,0x0D260,0x0D950,0x16554,0x056A0,0x09AD0,0x055D2,
    0x04AE0,0x0A5B6,0x0A4D0,0x0D250,0x1D255,0x0B540,0x0D6A0,0x0ADA2,0x095B0,0x14977,
    0x04970,0x0A4B0,0x0B4B5,0x06A50,0x06D40,0x1AB54,0x02B60,0x09570,0x052F2,0x04970,
    0x06566,0x0D4A0,0x0EA50,0x06E95,0x05AD0,0x02B60,0x186E3,0x092E0,0x1C8D7,0x0C950,
    0x0D4A0,0x1D8A6,0x0B550,0x056A0,0x1A5B4,0x025D0,0x092D0,0x0D2B2,0x0A950,0x0B557,
    0x06CA0,0x0B550,0x15355,0x04DA0,0x0A5B0,0x14573,0x052B0,0x0A9A8,0x0E950,0x06AA0,
    0x0AEA6,0x0AB50,0x04B60,0x0AAE4,0x0A570,0x05260,0x0F263,0x0D950,0x05B57,0x056A0,
    0x096D0,0x04DD5,0x04AD0,0x0A4D0,0x0D4D4,0x0D250,0x0D558,0x0B540,0x0B6A0,0x195A6,
    0x095B0,0x049B0,0x0A974,0x0A4B0,0x0B27A,0x06A50,0x06D40,0x0AF46,0x0AB60,0x09570,
    0x04AF5,0x04970,0x064B0,0x074A3,0x0EA50,0x06B58,0x055C0,0x0AB60,0x096D5,0x092E0,
    0x0C960,0x0D954,0x0D4A0,0x0DA50,0x07552,0x056A0,0x0ABB7,0x025D0,0x092D0,0x0CAB5,
    0x0A950,0x0B4A0,0x0BAA4,0x0AD50,0x055D9,0x04BA0,0x0A5B0,0x15176,0x052B0,0x0A930,
    0x07954,0x06AA0,0x0AD50,0x05B52,0x04B60,0x0A6E6,0x0A4E0,0x0D260,0x0EA65,0x0D530,
    0x05AA0,0x076A3,0x096D0,0x04BD7,0x04AD0,0x0A4D0,0x1D0B6,0x0D250,0x0D520,0x0DD45,
    0x0B5A0,0x056D0,0x055B2,0x049B0,0x0A577,0x0A4B0,0x0AA50,0x1B255,0x06D20,0x0ADA0,
    0x14B63
};

static double sTermInfo[MAX_COUNT_TERNINFO] = {
    0, 21208, 42467, 63836, 85337,
    107014, 128867, 150921, 173149, 195551,
    218072, 240693, 263343, 285989, 308563,
    331033, 353350, 375494, 397447, 419210,
    440795, 462224, 483532, 504758};

@interface LunarDB (PrivateMethods)
- (int) GetChineseMonthDays:(int)year  month:(int)month;
- (int) GetChineseLeapMonth:(int)year;
- (int) GetChineseLeapMonthDays:(int)year;
- (int) GetChineseYearDays:(int)year;
- (NSString *) GetChineseHour:(NSDate *)dt;
- (NSString *) ChineseYearString;
- (NSString *) ChineseMonthString;
- (NSString *) ChineseDayString;
- (NSString *) GanZhiYearString;
- (NSString *) GanZhiMonthString;
- (NSString *) GanZhiDayString;
- (int) GetZhiMonthIdx;
- (int) dayOffset:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (int) dayOfYear:(NSDate *)t_date;

- (int) GetChineseEraOfDay;
- (double) Tail:(double)x;
- (double) rem:(double)x w:(double)w;
- (int) IfGregorian:(int)y m:(int)m d:(int)d opt:(int)opt;
- (int) DayDifference:(int)y m:(int)m d:(int)d;
- (double) EquivalentStandardDay:(int)y m:(int)m d:(int)d;

- (bool) BitTest32:(int)num bitPos:(int)bitpostion;
- (bool) IsLeapYear:(int)year;
- (bool) CheckDateLimit:(NSDate *)t_dt;
- (bool) CheckChineseDateLimit:(int)year month:(int)month day:(int)day leap:(bool)leapMonth;
- (NSInteger) Animal;
- (NSString *) ConvertNumToChineseNum:(int)n;
- (NSString *) ConvertWeekToChinsesWeek:(int)w;
- (NSString *) ConvertMonthToEnglish:(int)month;

@end


@implementation SolarHolidayStruct
@synthesize Month;
@synthesize Day;
@synthesize Recess;
@synthesize HolidayName;
@end


@implementation LunarHolidayStruct
@synthesize Month;
@synthesize Day;
@synthesize Recess;
@synthesize HolidayName;
@end


@implementation WeekHolidayStruct
@synthesize Month;
@synthesize WeekAtMonth;
@synthesize WeekDay;
@synthesize HolidayName;
@end



@implementation LunarDB

#pragma mark PublicMethods
- (id)init
{
    if (self == [super init])
    {
#pragma mark 星座数据
        _constellationName =
        [[NSArray alloc] initWithObjects:
         @"白羊座", @"金牛座", @"双子座",
         @"巨蟹座", @"狮子座", @"处女座",
         @"天秤座", @"天蝎座", @"射手座",
         @"摩羯座", @"水瓶座", @"双鱼座", nil];
        
#pragma mark 二十四节气
        _lunarHolidayName =
        [[NSArray alloc] initWithObjects:
         @"小寒", @"大寒", @"立春", @"雨水",
         @"惊蛰", @"春分", @"清明", @"谷雨",
         @"立夏", @"小满", @"芒种", @"夏至",
         @"小暑", @"大暑", @"立秋", @"处暑",
         @"白露", @"秋分", @"寒露", @"霜降",
         @"立冬", @"小雪", @"大雪", @"冬至", nil];
        
#pragma mark 二十八星宿
        _chineseConstellationName =
        [[NSArray alloc] initWithObjects:
         //四          五        六        日        一        二        三
         @"角木蛟", @"亢金龙", @"女土蝠", @"房日兔", @"心月狐", @"尾火虎", @"箕水豹",
         @"斗木獬", @"牛金牛", @"氐土貉", @"虚日鼠", @"危月燕", @"室火猪", @"壁水獝",
         @"奎木狼", @"娄金狗", @"胃土彘", @"昴日鸡", @"毕月乌", @"觜火猴", @"参水猿",
         @"井木犴", @"鬼金羊", @"柳土獐", @"星日马", @"张月鹿", @"翼火蛇", @"轸水蚓", nil];
        
#pragma mark 宜数据
        _yiStr =
        [[NSArray alloc] initWithObjects:
         @"出行,上任,会友,上书,见工",//建
         @"除服,疗病,出行,拆卸,入宅",//除
         @"祈福,祭祀,结亲,开市,交易",//满
         @"祭祀,修墳,涂泥,餘事勿取" ,//平
         @"交易,立券,会友,签約,納畜",//定
         @"祈福,祭祀,求子,结婚,立约",//执
         @"日值月破 大事不宜",//破
         @"经营,交易,求官,納畜,動土" ,//危
         @"祈福,入学,开市,求医,成服",//成
         @"祭祀,求财,签约,嫁娶,订盟",//收
         @"疗病,结婚,交易,入仓,求职",//开
         @"祭祀,交易,收财,安葬", nil];//闭
        
#pragma mark 忌数据
        _jiStr =
        [[NSArray alloc] initWithObjects:
         @"动土,开仓,嫁娶,纳采",//建
         @"求官,上任,开张,搬家,探病 ",//除
         @"服药,求医,栽种,动土,迁移",//满
         @"移徙.入宅.嫁娶.开市.安葬" ,//平
         @"种植,置业,卖田,掘井,造船",//定
         @"开市,交易,搬家,远行 ",//执
         @"日值月破 大事不宜",//破
         @"登高,行船.安床.入宅.博彩" ,//危
         @"词讼,安門,移徙",//成
         @"开市.安床.安葬.入宅.破土",//收
         @"安葬,动土,针灸",//开
         @"宴会,安床,出行,嫁娶,移徙", nil];//闭
        
#pragma mark 日建
        _riJianStr =
        [[NSArray alloc] initWithObjects:
         @"建日", @"除日", @"满日", @"平日", @"定日", @"执日", @"破日", @"危日", @"成日", @"收日", @"开日", @"闭日", nil];
        
        
#pragma mark 节气数据
        SolarTerm =
        [[NSArray alloc] initWithObjects:
         @"小寒", @"大寒", @"立春", @"雨水", @"惊蛰", @"春分",
         @"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至",
         @"小暑", @"大暑", @"立秋", @"处暑", @"白露", @"秋分",
         @"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至", nil];
        
#pragma mark 农历相关数据
        HZNum =
        [[NSArray alloc] initWithObjects:@"零", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", nil];
        
        ganStr =
        [[NSArray alloc] initWithObjects:
         @"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", @"癸",nil];
        
        zhiStr =
        [[NSArray alloc] initWithObjects:
         @"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥", @"子", nil];
        
        animalStr =
        [[NSArray alloc] initWithObjects:
         @"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪", nil];
        
        nStr1 =
        [[NSArray alloc] initWithObjects:
         @"日", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", nil];
        
        nStr2 =
        [[NSArray alloc] initWithObjects:
         @"初", @"十", @"廿", @"卅", nil];
        
        _monthString =
        [[NSArray alloc] initWithObjects:
         @"出错", @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月",@"腊月", nil];
        
        MinDay = [[NSDate alloc] initWithString:@"1900-1-30 00:00:00 +0000"];
        MaxDay = [[NSDate alloc] initWithString:@"2049-12-31 00:00:00 +0000"];
        GanZhiStartDay = [[NSDate alloc] initWithString:@"1899-12-22 00:00:00 +0000"];
        ChineseConstellationReferDay = [[NSDate alloc] initWithString:@"2007-9-13 00:00:00 +0000"];
        
        //		_date = [[NSDate date] retain];
        
        //		NSDate *date2 = [[NSDate alloc]initWithString:@"2012-3-31 12:00:00 +0000"];
        //		[self setSolarDate:date2];
        //		[date2 release];
        //		NSLog(@"公历＝%@", [self SolorDateString]);
        //		NSLog(@"公历＝%@", [self SolorDayString]);
        //		NSLog(@"公历＝%@", [self SolorWeekDayString]);
        //		NSLog(@"农历＝%@", [self ChineseDateString]);
        //		NSLog(@"天干地支＝%@", [self GanZhiDateString]);
        //		NSLog(@"彭祖百忌=%@", [self GetPengZuBaiJi]);
        //		NSLog(@"忌＝%@", [self GetDayJi]);
        //		NSLog(@"宜＝%@", [self GetDayYi]);
        //		NSLog(@"生肖冲＝%@", [self GetShengxiaoChong]);
        //		NSLog(@"生肖煞＝%@", [self GetShengxiaoSha]);
        //		NSLog(@"正冲=%@", [self GetZhengChong]);
        //		NSLog(@"胎神=%@", [self GetTaiSheng]);
        //		NSLog(@"日建=%@", [self GetDayRijian]);
        //		NSLog(@"星座=%@", [self Constellation]);
        //		NSLog(@"属相=%@", [self AnimalString]);
        //		NSLog(@"星宿=%@", [self ChineseConstellation]);
        //		NSLog(@"二十四节气=%@", [self ChineseTwentyFourDay]);
    }
    return self;
}

- (void)dealloc
{
    [MaxDay release];
    [MinDay release];
    [GanZhiStartDay release];
    [ChineseConstellationReferDay release];
    [_date release];
    [super dealloc];
}

- (void) setSolarDate:(NSDate *)t_dt
{
    bool isDateOK = [self CheckDateLimit:t_dt];
    //	if (!isDateOK)
    //	{
    //		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"超出可转换的日期！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //		[alertView show];
    //		[alertView release];
    //		return;
    //	}
    
    
    [_date release];
    _date = [t_dt retain];
    
    int i;
    int leap;
    int temp;
    int offset;
    [self CheckDateLimit:t_dt];
    //农历日期计算部分
    leap = 0;
    temp = 0;
    
    offset = [self dayOffset:MinDay toDate:_date];
    
    for (i = MinYear; i <= MaxYear; i++)
    {
        temp = [self GetChineseYearDays:i];  //求当年农历年天数
        if (offset - temp < 1)
            break;
        else
        {
            offset = offset - temp;
        }
    }
    _cYear = i;
    leap = [self GetChineseLeapMonth:_cYear];//计算该年闰哪个月
    //设定当年是否有闰月
    if (leap > 0)
    {
        _cIsLeapYear = true;
    }
    else
    {
        _cIsLeapYear = false;
    }
    _cIsLeapMonth = false;
    for (i = 1; i <= 12; i++)
    {
        //闰月
        if ((leap > 0) && (i == leap + 1) && (_cIsLeapMonth == false))
        {
            _cIsLeapMonth = true;
            i = i - 1;
            temp = [self GetChineseLeapMonthDays:_cYear]; //计算闰月天数
        }
        else
        {
            _cIsLeapMonth = false;
            temp = [self GetChineseMonthDays:_cYear month:i];//计算非闰月天数
        }
        offset = offset - temp;
        if (offset <= 0) break;
    }
    offset = offset + temp;
    _cMonth = i;
    _cDay = offset;
}

- (NSDate *) getSolarDate
{
    return _date;
}

- (void) setLunarDate:(int)cy cm:(int)cm cd:(int)cd leap:(bool)leapMonthFlag
{
    int i, leap, Temp, offset;
    [self CheckChineseDateLimit:cy month:cm day:cd leap:leapMonthFlag];
    _cYear = cy;
    _cMonth = cm;
    _cDay = cd;
    offset = 0;
    for (i = MinYear; i < cy; i++)
    {
        Temp = [self GetChineseYearDays:i]; //求当年农历年天数
        offset = offset + Temp;
    }
    leap = [self GetChineseLeapMonth:cy];// 计算该年应该闰哪个月
    if (leap != 0)
    {
        _cIsLeapYear = true;
    }
    else
    {
        _cIsLeapYear = false;
    }
    if (cm != leap)
    {
        _cIsLeapMonth = false;  //当前日期并非闰月
    }
    else
    {
        _cIsLeapMonth = leapMonthFlag;  //使用用户输入的是否闰月月份
    }
    
    if ((_cIsLeapYear == false) || //当年没有闰月
        (cm < leap)) //计算月份小于闰月
    {
        for (i = 1; i < cm; i++)
        {
            Temp = [self GetChineseMonthDays:cy month:i];//计算非闰月天数
            offset = offset + Temp;
        }
        //检查日期是否大于最大天
        //		if (cd > GetChineseMonthDays(cy, cm))
        //		{
        //			throw new ChineseCalendarException("不合法的农历日期");
        //		}
        offset = offset + cd; //加上当月的天数
        
    }
    else   //是闰年，且计算月份大于或等于闰月
    {
        for (i = 1; i < cm; i++)
        {
            //			Temp = GetChineseMonthDays(cy, i); //计算非闰月天数
            offset = offset + Temp;
        }
        if (cm > leap) //计算月大于闰月
        {
            //			Temp = GetChineseLeapMonthDays(cy);   //计算闰月天数
            offset = offset + Temp;               //加上闰月天数
            //			if (cd > GetChineseMonthDays(cy, cm))
            //			{
            //				throw new ChineseCalendarException("不合法的农历日期");
            //			}
            offset = offset + cd;
        }
        else  //计算月等于闰月
        {
            //如果需要计算的是闰月，则应首先加上与闰月对应的普通月的天数
            if (_cIsLeapMonth == true) //计算月为闰月
            {
                //				Temp = GetChineseMonthDays(cy, cm); //计算非闰月天数
                offset = offset + Temp;
            }
            //			if (cd > GetChineseLeapMonthDays(cy))
            //			{
            //				throw new ChineseCalendarException("不合法的农历日期");
            //			}
            offset = offset + cd;
        }
    }
    
    //	_date = MinDay.AddDays(offset);
    
}

///获取公历年月
- (NSString *) SolorDateString
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger flag = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents* dc = [gregorian components:flag fromDate:_date];
    
//    NSString *dateString = [NSString stringWithFormat:@"%d年%d月", [dc year], [dc month]];//年和月
    NSString *dateString = [NSString stringWithFormat:@"%ld月", (long)[dc month]];
    return dateString;
}

///获取公历周
- (NSString *) SolorWeekDayString
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger flag = NSWeekdayCalendarUnit;
    NSDateComponents* dc = [gregorian components:flag fromDate:_date];
    
    NSString *dateString = [NSString stringWithFormat:@"星期%@", [self ConvertWeekToChinsesWeek:[dc weekday] - 1]];
    return dateString;
}
///获取公历日期
- (NSString *) SolorDayString
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger flag = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents* dc = [gregorian components:flag fromDate:_date];
    
    NSString *dateString = [NSString stringWithFormat:@"%d", [dc day]];
    return dateString;
}

/// 取农历日期表示法：农历一九九七年正月初五
- (NSString *) ChineseDateString
{
    if (_cIsLeapMonth == true)
    {
        return [NSString stringWithFormat:@"%@%@%@%@%@", @"农历", @"", @"闰", [self ChineseMonthString], [self ChineseDayString]];
    }
    else
    {
        //        [self getChineseCalendarWithDate:_date];
        return [NSString stringWithFormat:@"%@%@%@%@",@"农历", @"", [self ChineseMonthString], [self ChineseDayString]];
    }
}
/// 取农历日期表示法：农历一九九七年正月初五
- (NSString *) ChineseYear
{
    if (_cIsLeapMonth == true)
    {
        return [NSString stringWithFormat:@"%@%@%@%@%@", [self getChineseCalendarWithDate:_date], @"", @"闰", [self ChineseMonthString], [self ChineseDayString]];
    }
    else
    {
        //        [self getChineseCalendarWithDate:_date];
        return [NSString stringWithFormat:@"%@%@%@%@", [self getChineseCalendarWithDate:_date], @"", [self ChineseMonthString], [self ChineseDayString]];
    }
}
- (NSString *)setBirthdaySolarDate:(NSDate *)t_dt
{
    bool isDateOK = [self CheckDateLimit:t_dt];
    
    
    [_date release];
    _date = [t_dt retain];
    
    int i;
    int leap;
    int temp;
    int offset;
    [self CheckDateLimit:t_dt];
    //农历日期计算部分
    leap = 0;
    temp = 0;
    
    offset = [self dayOffset:MinDay toDate:_date];
    
    for (i = MinYear; i <= MaxYear; i++)
    {
        temp = [self GetChineseYearDays:i];  //求当年农历年天数
        if (offset - temp < 1)
            break;
        else
        {
            offset = offset - temp;
        }
    }
    _cYear = i;
    leap = [self GetChineseLeapMonth:_cYear];//计算该年闰哪个月
    //设定当年是否有闰月
    if (leap > 0)
    {
        _cIsLeapYear = true;
    }
    else
    {
        _cIsLeapYear = false;
    }
    _cIsLeapMonth = false;
    for (i = 1; i <= 12; i++)
    {
        //闰月
        if ((leap > 0) && (i == leap + 1) && (_cIsLeapMonth == false))
        {
            _cIsLeapMonth = true;
            i = i - 1;
            temp = [self GetChineseLeapMonthDays:_cYear]; //计算闰月天数
        }
        else
        {
            _cIsLeapMonth = false;
            temp = [self GetChineseMonthDays:_cYear month:i];//计算非闰月天数
        }
        offset = offset - temp;
        if (offset <= 0) break;
    }
    offset = offset + temp;
    _cMonth = i;
    _cDay = offset;
    if (_cIsLeapMonth == true)
    {
        return [NSString stringWithFormat:@"%@%@", [self ChineseMonthString], [self ChineseDayString]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@%@",  [self ChineseMonthString], [self ChineseDayString]];
    }
}
- (NSString *) ChineseMD
{
    if (_cIsLeapMonth == true)
    {
        return [NSString stringWithFormat:@"%@%@", [self ChineseMonthString], [self ChineseDayString]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@%@",  [self ChineseMonthString], [self ChineseDayString]];
    }
}
-(NSString *)ChineseMonth{
    NSString *month=[self ChineseMonthString];
    if ([month isEqualToString:@"正月"]) {
        month=@"1";
    }
    if ([month isEqualToString:@"二月"]) {
        month=@"2";
    }
    if ([month isEqualToString:@"三月"]) {
        month=@"3";
    }
    if ([month isEqualToString:@"四月"]) {
        month=@"4";
    }
    if ([month isEqualToString:@"五月"]) {
        month=@"5";
    }
    if ([month isEqualToString:@"六月"]) {
        month=@"6";
    }
    if ([month isEqualToString:@"七月"]) {
        month=@"7";
    }
    if ([month isEqualToString:@"八月"]) {
        month=@"8";
    }
    if ([month isEqualToString:@"九月"]) {
        month=@"9";
    }
    if ([month isEqualToString:@"十月"]) {
        month=@"10";
    }
    if ([month isEqualToString:@"十一月"]) {
        month=@"11";
    }
    if ([month isEqualToString:@"腊月"]) {
        month=@"12";
    }
    return month;
}
//获取农历年份
-(NSString*)getChineseCalendarWithDate:(NSDate *)date{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSLog(@"%d_%d_%d  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    //    NSString *chineseCal_str =[NSString stringWithFormat: @"%@%@%@",y_str,m_str,d_str];
    //
    //
    //    return chineseCal_str;
    return y_str;
}

/// 取当前日期的干支表示法如 甲子年乙丑月丙庚日
- (NSString *) GanZhiDateString
{
//    return [NSString stringWithFormat:@"%@%@%@", [self GanZhiYearString], [self GanZhiMonthString], [self GanZhiDayString]];
    return [NSString stringWithFormat:@"%@", [self ChineseYear]];
}

/// 获取彭祖百忌。
- (NSString *) GetPengZuBaiJi
{
    NSArray *g = [NSArray arrayWithObjects:@"甲不开仓 ", @"乙不栽植 ", @"丙不修灶 ", @"丁不剃头 ", @"戊不受田 ", @"己不破券 ", @"庚不经络 ", @"辛不合酱 ", @"壬不泱水 ", @"癸不词讼 ", nil];
    NSArray *z = [NSArray arrayWithObjects:@"子不问卜", @"丑不冠带", @"寅不祭祀", @"卯不穿井", @"辰不哭泣", @"巳不远行", @"午不苫盖", @"未不服药", @"申不安床", @"酉不会客", @"戌不吃犬", @"亥不嫁娶", nil];
    int ceod = [self GetChineseEraOfDay] - 1;
    NSString *temp = nil;
    
    int a = ceod % 10;
    int b = ceod % 12;
    a = 10-abs(ceod)%10;
    b = 12-abs(ceod) % 12;
    if (ceod >= 0)
    {
        temp = [NSString stringWithFormat:@"%@%@", [g objectAtIndex:ceod % 10], [z objectAtIndex:ceod % 12]];
    }
    else if (ceod < 0)
    {
        temp = [NSString stringWithFormat:@"%@%@", [g objectAtIndex:10-abs(ceod)%10], [z objectAtIndex:12-abs(ceod) % 12]];
    }
    return temp;
}

/// 获取每日宜。
- (NSString *) GetDayYi
{
    int monthIndex = [self GetZhiMonthIdx];
    if (monthIndex > 10)
    {
        monthIndex = monthIndex - 10;
    }
    else
    {
        monthIndex = monthIndex + 2;
    }
    
    int dayIndex, offset;
    offset = [self dayOffset:GanZhiStartDay toDate:_date];
    dayIndex = offset % 60;
    dayIndex = dayIndex % 12;
    
    NSString *result = nil;
    int index = (dayIndex-monthIndex + 12) % 12;
    result = [_yiStr objectAtIndex:index];
    return result;
}

/// 获取每日忌。
- (NSString *) GetDayJi
{
    int monthIndex = [self GetZhiMonthIdx];
    if (monthIndex > 10)
    {
        monthIndex = monthIndex - 10;
    }
    else
    {
        monthIndex = monthIndex + 2;
    }
    int dayIndex, offset;
    offset = [self dayOffset:GanZhiStartDay toDate:_date];
    dayIndex = offset % 60;
    dayIndex = dayIndex % 12;
    
    NSString *result = nil;
    int index = (dayIndex-monthIndex + 12) % 12;
    result = [_jiStr objectAtIndex:index];
    return result;
}

/// 获取每日日建。
- (NSString *) GetDayRijian
{
    int monthIndex = [self GetZhiMonthIdx];
    if (monthIndex > 10)
    {
        monthIndex = monthIndex - 10;
    }
    else
    {
        monthIndex = monthIndex + 2;
    }
    int dayIndex, offset;
    offset = [self dayOffset:GanZhiStartDay toDate:_date];
    dayIndex = offset % 60;
    dayIndex = dayIndex % 12;
    
    NSString *result = nil;
    int index = (dayIndex-monthIndex + 12) % 12;
    result = [_riJianStr objectAtIndex:index];
    return result;
}

/// 获取每日生肖相冲。
- (NSString *) GetShengxiaoChong
{
    int dayIndex, offset;
    offset = [self dayOffset:GanZhiStartDay toDate:_date];
    dayIndex = offset % 60;
    dayIndex = dayIndex % 12;
    
    
    NSString *animal = nil;
    switch (dayIndex)
    {
        case 0:
            animal = @"马";
            break;
        case 1:
            animal = @"羊";
            break;
        case 2:
            animal = @"猴";
            break;
        case 3:
            animal = @"鸡";
            break;
        case 4:
            animal = @"狗";
            break;
        case 5:
            animal = @"猪";
            break;
        case 6:
            animal = @"鼠";
            break;
        case 7:
            animal = @"牛";
            break;
        case 8:
            animal = @"虎";
            break;
        case 9:
            animal = @"兔";
            break;
        case 10:
            animal = @"龙";
            break;
        case 11:
            animal = @"蛇";
            break;
        default:
            break;
    }
    NSString *chong = [NSString stringWithFormat:@"%@%@", @"冲", animal];
    return chong;
}

/// 获取每日生肖煞。
- (NSString *) GetShengxiaoSha
{
    int dayIndex, offset;
    offset = [self dayOffset:GanZhiStartDay toDate:_date];
    
    dayIndex = offset % 60;
    dayIndex = dayIndex % 12;
    
    NSString *dir = nil;
    switch (dayIndex)
    {
        case 0:
            dir = @"南";
            break;
        case 1:
            dir = @"东";
            break;
        case 2:
            dir = @"北";
            break;
        case 3:
            dir = @"西";
            break;
        case 4:
            dir = @"南";
            break;
        case 5:
            dir = @"东";
            break;
        case 6:
            dir = @"北";
            break;
        case 7:
            dir = @"西";
            break;
        case 8:
            dir = @"南";
            break;
        case 9:
            dir = @"东";
            break;
        case 10:
            dir = @"北";
            break;
        case 11:
            dir = @"西";
            break;
        default:
            break;
    }
    NSString *sha = [NSString stringWithFormat:@"%@%@", @"煞", dir];
    return sha;
}

/// 获取每日正冲。
- (NSString *) GetZhengChong
{
    int dayIndex, offset, tian, di;
    offset = [self dayOffset:GanZhiStartDay toDate:_date];
    dayIndex = offset % 60;
    
    tian = dayIndex % 10;
    di = dayIndex % 12;
    
    NSString *tianStr = nil;
    NSString *diStr = nil;
    switch (tian)
    {
        case 0:
            tianStr = @"戊"; ;
            break;
        case 1:
            tianStr = @"己";
            break;
        case 2:
            tianStr = @"庚";
            break;
        case 3:
            tianStr = @"辛";
            break;
        case 4:
            tianStr = @"壬";
            break;
        case 5:
            tianStr = @"癸";
            break;
        case 6:
            tianStr = @"甲";
            break;
        case 7:
            tianStr = @"乙";
            break;
        case 8:
            tianStr = @"丙";
            break;
        case 9:
            tianStr = @"丁";
            break;
        default:
            break;
    }
    
    switch (di)
    {
        case 0:
            diStr = @"午"; ;
            break;
        case 1:
            diStr = @"未";
            break;
        case 2:
            diStr = @"申";
            break;
        case 3:
            diStr = @"酉";
            break;
        case 4:
            diStr = @"戌";
            break;
        case 5:
            diStr = @"亥";
            break;
        case 6:
            diStr = @"子";
            break;
        case 7:
            diStr = @"丑";
            break;
        case 8:
            diStr = @"寅";
            break;
        case 9:
            diStr = @"卯";
            break;
        case 10:
            diStr = @"辰";
            break;
        case 11:
            diStr = @"巳";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@%@", tianStr, diStr];
}

/// 获取每日胎神。
- (NSString *) GetTaiSheng
{
    int dayIndex, offset, tian, di;
    offset = [self dayOffset:GanZhiStartDay toDate:_date];
    dayIndex = offset % 60;
    
    tian = dayIndex % 10;
    di = dayIndex % 12;
    
    NSString *taisheng1 = nil;
    NSString *taisheng2 = nil;
    NSString *taisheng3 = nil;
    
    if(tian == 0 || tian == 5)
    {
        taisheng1 = @"门";
    }
    else if(tian == 1 || tian == 6)
    {
        taisheng1 = @"碓磨";
    }
    else if(tian == 2 || tian == 7)
    {
        taisheng1 = @"厨灶";
    }
    else if(tian == 3 || tian == 8)
    {
        taisheng1 = @"仓库";
    }
    else if(tian == 4 || tian == 9)
    {
        taisheng1 = @"房床";
    }
    
    if(di == 0 || di == 6)
    {
        taisheng2 = @"碓";
    }
    else if(di == 1 || di == 7)
    {
        taisheng2 = @"厕道";
    }
    else if(di == 2 || di == 8)
    {
        taisheng2 = @"炉";
    }
    else if(di == 3 || di == 9)
    {
        taisheng2 = @"大门";
    }
    else if(di == 4 || di == 10)
    {
        taisheng2 = @"鸡栖";
    }
    else if(di == 5 || di == 11)
    {
        taisheng2 = @"床";
    }
    
    NSString *ganzhiri = [NSString stringWithFormat:@"%@%@", [ganStr objectAtIndex:dayIndex % 10], [zhiStr objectAtIndex:dayIndex % 12]];
    if ([ganzhiri isEqualToString:@"辛未"] || [ganzhiri isEqualToString:@"壬申"] || [ganzhiri isEqualToString:@"癸酉"] || [ganzhiri isEqualToString:@"甲戌"] || [ganzhiri isEqualToString:@"乙亥"] || [ganzhiri isEqualToString:@"丙子"] || [ganzhiri isEqualToString:@"丁丑"])
    {
        taisheng3 = @"外西南";
    }
    else if ([ganzhiri isEqualToString:@"戊寅"] || [ganzhiri isEqualToString:@"己卯"])
    {
        taisheng3 = @"外正南";
    }
    else if ([ganzhiri isEqualToString:@"庚辰"] || [ganzhiri isEqualToString:@"辛巳"])
    {
        taisheng3 = @"外正西";
    }
    else if ([ganzhiri isEqualToString:@"壬午"] || [ganzhiri isEqualToString:@"甲申"] || [ganzhiri isEqualToString:@"癸未"] || [ganzhiri isEqualToString:@"乙酉"] || [ganzhiri isEqualToString:@"丙戌"] || [ganzhiri isEqualToString:@"丁亥"] )
    {
        taisheng3 = @"外西北";
    }
    else if ([ganzhiri isEqualToString:@"戊子"] || [ganzhiri isEqualToString:@"己丑"] || [ganzhiri isEqualToString:@"庚寅"] || [ganzhiri isEqualToString:@"辛卯"] || [ganzhiri isEqualToString:@"壬辰"])
    {
        taisheng3 = @"外正北";
    }
    else if ([ganzhiri isEqualToString:@"癸巳"] || [ganzhiri isEqualToString:@"甲午"] || [ganzhiri isEqualToString:@"乙未"] || [ganzhiri isEqualToString:@"丙申"] || [ganzhiri isEqualToString:@"丁酉"])
    {
        taisheng3 = @"房内北";
    }
    else if ([ganzhiri isEqualToString:@"戊戌"] || [ganzhiri isEqualToString:@"己亥"] || [ganzhiri isEqualToString:@"庚子"] || [ganzhiri isEqualToString:@"辛丑"] || [ganzhiri isEqualToString:@"壬寅"] || [ganzhiri isEqualToString:@"癸卯"])
    {
        taisheng3 = @"房内南";
    }
    else if ([ganzhiri isEqualToString:@"甲辰"] || [ganzhiri isEqualToString:@"乙巳"] || [ganzhiri isEqualToString:@"丙午"] || [ganzhiri isEqualToString:@"丁未"] || [ganzhiri isEqualToString:@"戊申"] )
    {
        taisheng3 = @"房内东";
    }
    else if ([ganzhiri isEqualToString:@"己酉"] || [ganzhiri isEqualToString:@"庚戌"] || [ganzhiri isEqualToString:@"辛亥"] || [ganzhiri isEqualToString:@"壬子"] || [ganzhiri isEqualToString:@"癸丑"] || [ganzhiri isEqualToString:@"甲寅"])
    {
        taisheng3 = @"外东北";
    }
    else if ([ganzhiri isEqualToString:@"乙卯"] || [ganzhiri isEqualToString:@"丙辰"] || [ganzhiri isEqualToString:@"丁巳"] || [ganzhiri isEqualToString:@"戊午"] || [ganzhiri isEqualToString:@"己未"] )
    {
        taisheng3 = @"外正东";
    }
    else if ([ganzhiri isEqualToString:@"庚申"] || [ganzhiri isEqualToString:@"辛酉"] || [ganzhiri isEqualToString:@"壬戌"] || [ganzhiri isEqualToString:@"癸亥"] || [ganzhiri isEqualToString:@"甲子"] || [ganzhiri isEqualToString:@"乙丑"])
    {
        taisheng3 = @"外东南";
    }
    else if ([ganzhiri isEqualToString:@"丙寅"] || [ganzhiri isEqualToString:@"丁卯"] || [ganzhiri isEqualToString:@"戊辰"] || [ganzhiri isEqualToString:@"己巳"] || [ganzhiri isEqualToString:@"庚午"])
    {
        taisheng3 = @"外正南";
    }
    return [NSString stringWithFormat:@"%@,%@,%@", taisheng1, taisheng2, taisheng3];
}

/// 28星宿计算
- (NSString *) ChineseConstellation
{
    int offset = 0;
    int modStarDay = 0;
    offset = [self dayOffset:ChineseConstellationReferDay toDate:_date];
    
    modStarDay = offset % 28;
    return (modStarDay >= 0 ? [_chineseConstellationName objectAtIndex:modStarDay] : [_chineseConstellationName objectAtIndex:27 + modStarDay]);
}

/// 时辰
- (NSString *) ChineseHour
{
    return [self GetChineseHour:_date];
}

/// 定气法计算二十四节气,二十四节气是按地球公转来计算的，并非是阴历计算的
/// 节气的定法有两种。古代历法采用的称为"恒气"，即按时间把一年等分为24份，
/// 每一节气平均得15天有余，所以又称"平气"。现代农历采用的称为"定气"，即
/// 按地球在轨道上的位置为标准，一周360°，两节气之间相隔15°。由于冬至时地
/// 球位于近日点附近，运动速度较快，因而太阳在黄道上移动15°的时间不到15天。
/// 夏至前后的情况正好相反，太阳在黄道上移动较慢，一个节气达16天之多。采用
/// 定气时可以保证春、秋两分必然在昼夜平分的那两天。
- (NSString *) ChineseTwentyFourDay
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger flag = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dcNow = [gregorian components:flag fromDate:_date];
    
    NSDate *baseDate = [[[NSDate alloc] initWithString:@"1900-01-05 18:05:00 +0000"] autorelease];//有变1900-01-06 02:05:00
    
    NSDate *newDate = nil;
    
    
    
    double num;
    int y;
    NSString *tempStr = nil;
    y = [dcNow year];
    for (int i = 1; i <= 24; i++)
    {
        num = 525948.76 * (y - 1900) + sTermInfo[i - 1];
        newDate = [baseDate dateByAddingTimeInterval:num * 60];//按秒计算
        
        if ([self dayOfYear:newDate] == [self dayOfYear:_date])
        {
            tempStr = [SolarTerm objectAtIndex:i - 1];
            return tempStr;
            break;
        }
    }
    return @"";
}
///当前日期前一个最近节气
//- (NSString *) ChineseTwentyFourPrevDay
//{
//	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
//	NSInteger flag = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
//	NSDateComponents *dcNow = [gregorian components:flag fromDate:_date];
//
//	NSDate *baseDate = [[[NSDate alloc] initWithString:@"1900-01-06 02:05:00 +0800"] autorelease];
//	NSDate *newDate = nil;
//
//	double num;
//	int y;
//	NSString *tempStr = nil;
//	y = [dcNow year];
//	for (int i = 24; i >= 1; i--)
//	{
//		num = 525948.76 * (y - 1900) + sTermInfo[i - 1];
//
//		newDate = [baseDate addTimeInterval:num * 60];//按秒计算
//		int dd = [newDate timeIntervalSinceDate:_date];
//
//		if (dd <= 0)
//		{
//
//			tempStr = string.Format("{0}[{1}]", SolarTerm[i - 1], newDate.ToString("yyyy-MM-dd"));
//			break;
//		}
//	}
//	return tempStr;
//}
///当前日期后一个最近节气
//- (NSString *) ChineseTwentyFourNextDay
//{
//	DateTime baseDateAndTime = new DateTime(1900, 1, 6, 2, 5, 0); //#1/6/1900 2:05:00 AM#
//	DateTime newDate;
//	double num;
//	int y;
//	string tempStr = "";
//	y = this._date.Year;
//	for (int i = 1; i <= 24; i++)
//	{
//		num = 525948.76 * (y - 1900) + sTermInfo[i - 1];
//		newDate = baseDateAndTime.AddMinutes(num);//按分钟计算
//		if (newDate.DayOfYear > _date.DayOfYear)
//		{
//			tempStr = string.Format("{0}[{1}]", SolarTerm[i - 1], newDate.ToString("yyyy-MM-dd"));
//			break;
//		}
//	}
//	return tempStr;
//}


/// 计算指定日期的星座序号
- (NSString *) Constellation
{
    int index = 0;
    int y, m, d;
    
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger flag = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents* dc = [gregorian components:flag fromDate:_date];
    
    y = [dc year];
    m = [dc month];
    d = [dc day];
    
    y = m * 100 + d;
    if (((y >= 321) && (y <= 419))) { index = 0; }
    else if ((y >= 420) && (y <= 520)) { index = 1; }
    else if ((y >= 521) && (y <= 620)) { index = 2; }
    else if ((y >= 621) && (y <= 722)) { index = 3; }
    else if ((y >= 723) && (y <= 822)) { index = 4; }
    else if ((y >= 823) && (y <= 922)) { index = 5; }
    else if ((y >= 923) && (y <= 1022)) { index = 6; }
    else if ((y >= 1023) && (y <= 1121)) { index = 7; }
    else if ((y >= 1122) && (y <= 1221)) { index = 8; }
    else if ((y >= 1222) || (y <= 119)) { index = 9; }
    else if ((y >= 120) && (y <= 218)) { index = 10; }
    else if ((y >= 219) && (y <= 320)) { index = 11; }
    else { index = 0; }
    return [_constellationName objectAtIndex:index];
}

/// 取属相字符串
- (NSString *) AnimalString
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger flag = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents* dc = [gregorian components:flag fromDate:_date];
    
    int offset = [dc year] - AnimalStartYear; //阳历计算
    //int offset = this._cYear - AnimalStartYear;　农历计算
    return [animalStr objectAtIndex:offset % 12];
}

#pragma mark PrivateMethods
//传回农历 y年m月的总天数
- (int) GetChineseMonthDays:(int)year  month:(int)month
{
    if ([self BitTest32:LunarDateArray[year - MinYear] & 0x0000FFFF bitPos:(16 - month)])
    {
        return 30;
    }
    else
    {
        return 29;
    }
    return 29;
}

//传回农历 y年闰哪个月 1-12 , 没闰传回 0
- (int) GetChineseLeapMonth:(int)year
{
    return LunarDateArray[year - MinYear] & 0xF;
}

//传回农历 y年闰月的天数
- (int) GetChineseLeapMonthDays:(int)year
{
    if ([self GetChineseLeapMonth:year] != 0)
    {
        if ((LunarDateArray[year - MinYear] & 0x10000) != 0)
        {
            return 30;
        }
        else
        {
            return 29;
        }
    }
    else
    {
        return 0;
    }
}

/// 取农历年一年的天数
- (int) GetChineseYearDays:(int)year
{
    int i, f, sumDay, info;
    sumDay = 348; //29天 X 12个月
    i = 0x8000;
    info = LunarDateArray[year - MinYear] & 0x0FFFF;
    //计算12个月中有多少天为30天
    for (int m = 0; m < 12; m++)
    {
        f = info & i;
        if (f != 0)
        {
            sumDay++;
        }
        i = i >> 1;
    }
    return sumDay + [self GetChineseLeapMonthDays:year];
}


/// 获得当前时间的时辰
- (NSString *) GetChineseHour:(NSDate *)dt
{
    int _hour, _minute, offset, i;
    int indexGan;
    //NSString *ganHour = nil;
    NSString *zhiHour = nil;
    
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger flag = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents* dc = [gregorian components:flag fromDate:dt];
    
    //计算时辰的地支
    _hour = [dc hour];    //获得当前时间小时
    _minute = [dc minute];  //获得当前时间分钟
    if (_minute != 0) _hour += 1;
    offset = _hour / 2;
    if (offset >= 12) offset = 0;
    
    zhiHour = [zhiStr objectAtIndex:offset];
    
    //计算天干
    i = [self dayOffset:GanZhiStartDay toDate:_date] % 60;
    
    indexGan = ((i % 10 + 1) * 2 - 1) % 10 - 1; //ganStr[i % 10] 为日的天干,(n*2-1) %10得出地支对应,n从1开始
    NSMutableArray *tmpGan = [[[NSMutableArray alloc] initWithCapacity:32] autorelease];
    [tmpGan addObject:[ganStr objectAtIndex:indexGan]];
    for (int cc=0; cc<indexGan+2; cc++)
        [tmpGan addObject:[ganStr objectAtIndex:cc]];//凑齐12位
    
    NSString *tmpString = [NSString stringWithFormat:@"%@%@", [ganStr objectAtIndex:indexGan], [zhiStr objectAtIndex:indexGan]];
    return tmpString;
}

/// 取农历年字符串如，一九九七年
- (NSString *) ChineseYearString
{
    NSMutableString *tempStr = [[[NSMutableString alloc] initWithCapacity:8] autorelease];
    NSString *nums = [NSString stringWithFormat:@"%d", _cYear];
    for (int i = 0; i < [nums length]; i++)
    {
        NSString *num = [nums substringWithRange:NSMakeRange(i, 1)];
        [tempStr appendString:[self ConvertNumToChineseNum:[num intValue]]];
    }
    
    [tempStr appendString:@"年"];
    return tempStr;
}

/// 农历月份字符串
- (NSString *) ChineseMonthString
{
    return [_monthString objectAtIndex:_cMonth];
}

/// 农历日中文表示
- (NSString *) ChineseDayString
{
    switch (_cDay)
    {
        case 0:
            return @"";
        case 10:
            return @"初十";
        case 20:
            return @"二十";
        case 30:
            return @"三十";
        default:
            return [NSString stringWithFormat:@"%@%@", [nStr2 objectAtIndex:_cDay / 10], [nStr1 objectAtIndex:_cDay % 10]];
    }
}

/// 取农历年的干支表示法如 乙丑年
- (NSString *) GanZhiYearString
{
    int i = (_cYear - GanZhiStartYear) % 60; //计算干支
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@", [ganStr objectAtIndex:i%10], [zhiStr objectAtIndex:i%12], @"年"];
    return tempStr;
}

/// 取干支的月表示字符串，注意农历的闰月不记干支
- (NSString *) GanZhiMonthString
{
    int zhiIndex;
    NSString *zhi;
    zhiIndex = [self GetZhiMonthIdx];
    if (zhiIndex > 10)
    {//加个=号
        zhiIndex = zhiIndex - 10;
    }
    else
    {
        zhiIndex = zhiIndex + 2;
    }
    zhiIndex = zhiIndex % 12;
    zhi = [zhiStr objectAtIndex:zhiIndex];
    //根据当年的干支年的干来计算月干的第一个
    int ganIndex = 1;
    NSString *gan;
    int i = (_cYear - GanZhiStartYear) % 60; //计算干支
    switch (i % 10)
    {
        case 0: //甲
            ganIndex = 3;
            break;
        case 1: //乙
            ganIndex = 5;
            break;
        case 2: //丙
            ganIndex = 7;
            break;
        case 3: //丁
            ganIndex = 9;
            break;
        case 4: //戊
            ganIndex = 1;
            break;
        case 5: //己
            ganIndex = 3;
            break;
        case 6: //庚
            ganIndex = 5;
            break;
        case 7: //辛
            ganIndex = 7;
            break;
        case 8: //壬
            ganIndex = 9;
            break;
        case 9: //癸
            ganIndex = 1;
            break;
    }
    int t_index=(ganIndex+zhiIndex-3) % 10;
    if (t_index<0) {
        t_index=0-t_index;
    }
    //	gan = [NSString stringWithFormat:@"%@", [ganStr objectAtIndex:(ganIndex+zhiIndex-3) % 10]];
    gan = [NSString stringWithFormat:@"%@", [ganStr objectAtIndex:t_index]];
    return [NSString stringWithFormat:@"%@%@%@", gan,  zhi, @"月"];
}

/// 取干支日表示法
- (NSString *) GanZhiDayString
{
    int i, offset;
    offset = [self dayOffset:GanZhiStartDay toDate:_date];
    i = offset % 60;
    
    return [NSString stringWithFormat:@"%@%@%@", [ganStr objectAtIndex:i%10], [zhiStr objectAtIndex:i%12], @"日"];
}

- (int) GetZhiMonthIdx
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger flag = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dcNow = [gregorian components:flag fromDate:_date];
    
    NSDate *baseDate = [[[NSDate alloc] initWithString:@"1900-01-06 02:05:00 +0000"] autorelease];
    NSDate *newDate = nil;
    
    double num;
    int y;
    
    y = [dcNow year];
    int solarIdx = 0;
    int idx = 0;
    for (int i = MAX_COUNT_TERNINFO; i >= 1; i--)
    {
        num = 525948.76 * (y - 1900) + sTermInfo[i - 1];
        newDate = [baseDate dateByAddingTimeInterval:num * 60];//按秒计算
        
        if ([self dayOfYear:newDate] <= [self dayOfYear:_date])
        {
            solarIdx = i - 1;
            break;
        }
    }
    if (solarIdx >= 0 && solarIdx < 2)
    {
        idx = 11;
    }
    else if (solarIdx >= 2 && solarIdx < 4)
    {
        idx = 0;
    }
    else if (solarIdx >= 4 && solarIdx < 6)
    {
        idx = 1;
    }
    else if (solarIdx >= 6 && solarIdx < 8)
    {
        idx = 2;
    }
    else if (solarIdx >= 8 && solarIdx < 10)
    {
        idx = 3;
    }
    else if (solarIdx >= 10 && solarIdx < 12)
    {
        idx = 4;
    }
    else if (solarIdx >= 12 && solarIdx < 14)
    {
        idx = 5;
    }
    else if (solarIdx >= 14 && solarIdx < 16)
    {
        idx = 6;
    }
    else if (solarIdx >= 16 && solarIdx < 18)
    {
        idx = 7;
    }
    else if (solarIdx >= 18 && solarIdx < 20)
    {
        idx = 8;
    }
    else if (solarIdx >= 20 && solarIdx < 22)
    {
        idx = 9;
    }
    else if (solarIdx >= 22 && solarIdx < 24)
    {
        idx = 10;
    }
    return idx;
}

//计算两个日期间差多少天
- (int) dayOffset:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:fromDate toDate:toDate options:0];
    int offset = [comps day];
    return offset;
}

//计算日期属于该年第几天
- (int) dayOfYear:(NSDate *)t_date;
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger flag = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dc = [gregorian components:flag fromDate:t_date];
    
    int day,month,year,sum;
    day = [dc day];
    month = [dc month];
    year = [dc year];
    sum = 0;
    bool leap = [self IsLeapYear:year];
    
    switch(month)/*先计算某月以前月份的总天数*/
    {
        case 1:sum=0;break;
        case 2:sum=31;break;
        case 3:sum=59;break;
        case 4:sum=90;break;
        case 5:sum=120;break;
        case 6:sum=151;break;
        case 7:sum=181;break;
        case 8:sum=212;break;
        case 9:sum=243;break;
        case 10:sum=273;break;
        case 11:sum=304;break;
        case 12:sum=334;break;
        default:sum=0;break;
    }
    sum=sum+day;
    
    if(leap&&month>2)/*如果是闰年且月份大于2,总天数应该加一天*/
        sum++;
    return sum;
}

/// 获取日柱。
- (int) GetChineseEraOfDay
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger flag = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dc = [gregorian components:flag fromDate:_date];
    
    double gzD = ([dc hour] < 23) ? [self EquivalentStandardDay:[dc year] m:[dc month] d:[dc day]] : [self EquivalentStandardDay:[dc year] m:[dc month] d:[dc day]] + 1;
    return (int)round((double)[self rem:(int)gzD + 15 w:60]);
}

/// 返回x的小数尾数，若x为负值，则是1-小数尾数
- (double) Tail:(double)x
{
    return x - floor(x);
}

/// 广义求余
- (double) rem:(double)x w:(double)w
{
    return [self Tail:x / w] * w;
}

/// 判断y年m月(1,2,..,12,下同)d日是Gregorian历还是Julian历（opt=1,2,3分别表示标准日历,Gregorge历和Julian历）,是则返回1，是Julian历则返回0，若是Gregorge历所删去的那10天则返回-1
- (int) IfGregorian:(int)y m:(int)m d:(int)d opt:(int)opt
{
    if (opt == 1)
    {
        if (y > 1582 || (y == 1582 && m > 10) || (y == 1582 && m == 10 && d > 14))
            return (1);  //Gregorian
        else
            if (y == 1582 && m == 10 && d >= 5 && d <= 14)
                return (-1);  //空
            else
                return (0);  //Julian
    }
    
    if (opt == 2)
        return (1);  //Gregorian
    if (opt == 3)
        return (0);  //Julian
    return (-1);
}

/// 返回阳历y年m月d日的日差天数（在y年年内所走过的天数，如2000年3月1日为61）
- (int) DayDifference:(int)y m:(int)m d:(int)d
{
    int ifG = [self IfGregorian:y m:m d:d opt:1];
    int monL[] = { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    if (ifG == 1){
        if ((y % 100 != 0 && y % 4 == 0) || (y % 400 == 0))
            monL[2] += 1;
        else
            if (y % 4 == 0)
                monL[2] += 1;
    }
    int v = 0;
    for (int i = 0; i <= m - 1; i++)
    {
        v += monL[i];
    }
    v += d;
    if (y == 1582)
    {
        if (ifG == 1)
            v -= 10;
        if (ifG == -1)
            v = 0;  //infinity
    }
    return v;
}

/// 返回等效标准天数（y年m月d日相应历种的1年1月1日的等效(即对Gregorian历与Julian历是统一的)天数）
- (double) EquivalentStandardDay:(int)y m:(int)m d:(int)d
{
    double v = (y - 1) * 365 + floor((double)((y - 1) / 4)) + [self DayDifference:y m:m d:d] - 2;  //Julian的等效标准天数
    if (y > 1582)
        v += -floor((double)((y - 1) / 100)) + floor((double)((y - 1) / 400)) + 2;  //Gregorian的等效标准天数
    return v;
}



/// 测试某位是否为真
- (bool) BitTest32:(int)num bitPos:(int)bitpostion
{
    if ((bitpostion > 31) || (bitpostion < 0))
        return false;
    
    int bit = 1 << bitpostion;
    if ((num & bit) == 0)
    {
        return false;
    }
    else
    {
        return true;
    }
}

///是否公历闰年
- (bool) IsLeapYear:(int)year
{
    bool isLeap = false;
    if (year % 4 == 0)
        isLeap = true;
    if (year % 100 == 0)
        isLeap = false;
    if (year % 400 == 0)
        isLeap = true;
    return isLeap;
}

//检测公历日期是否合理
- (bool) CheckDateLimit:(NSDate *)t_dt
{
    if (t_dt == nil)
        return false;
    
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger flag = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents* dc = [gregorian components:flag fromDate:t_dt];
    
    int year = [dc year];
    if (year < 1900 || year > 2049)
        return false;
    
    return true;
}

/// 检查农历日期是否合理
- (bool) CheckChineseDateLimit:(int)year month:(int)month day:(int)day leap:(bool)leapMonth
{
    if ((year < 1900) || (year > 2049))
    {
        return false;
    }
    if ((month < 1) || (month > 12))
    {
        return false;
    }
    if ((day < 1) || (day > 30)) //中国的月最多30天
    {
        return false;
    }
    int leap = [self GetChineseLeapMonth:year];// 计算该年应该闰哪个月
    if (([self IsLeapYear:year] == true) && (month != leap))
    {
        return false;
    }
    return true;
}


/// 将0-9转成汉字形式
- (NSString *) ConvertNumToChineseNum:(int)n
{
    if (n < 0 || n > 9)
        return nil;
    return [HZNum objectAtIndex:n];
}

- (NSString *) ConvertWeekToChinsesWeek:(int)w
{
    if (w < 0 || w > 7)
        return nil;
    return [nStr1 objectAtIndex:w];
    
}

/// 计算属相的索引，注意虽然属相是以农历年来区别的，但是目前在实际使用中是按公历来计算的
/// 鼠年为1,其它类推
- (NSInteger) Animal
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger flag = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents* dc = [gregorian components:flag fromDate:_date];
    
    int offset = [dc year] - AnimalStartYear;
    return (offset % 12) + 1;
}

/// 将月份转成英文表示
- (NSString *) ConvertMonthToEnglish:(int)month
{
    switch (month)
    {
        case 1:
            return @"January";
        case 2:
            return @"February";
        case 3:
            return @"March";
        case 4:
            return @"April";
        case 5:
            return @"May";
        case 6:
            return @"June";
        case 7:
            return @"July";
        case 8:
            return @"August";
        case 9:
            return @"September";
        case 10:
            return @"October";
        case 11:
            return @"November";
        case 12:
            return @"December";
    }
    return @"";
}

/// 将星期几转成数字表示
//private int ConvertDayOfWeek(DayOfWeek dayOfWeek)
//{
//	switch (dayOfWeek)
//	{
//		case DayOfWeek.Sunday:
//			return 1;
//		case DayOfWeek.Monday:
//			return 2;
//		case DayOfWeek.Tuesday:
//			return 3;
//		case DayOfWeek.Wednesday:
//			return 4;
//		case DayOfWeek.Thursday:
//			return 5;
//		case DayOfWeek.Friday:
//			return 6;
//		case DayOfWeek.Saturday:
//			return 7;
//		default:
//			return 0;
//	}
//}

/// 比较当天是不是指定的第周几
//private bool CompareWeekDayHoliday(DateTime date, int month, int week, int day)
//{
//	bool ret = false;
//	if (date.Month == month) //月份相同
//	{
//		if (ConvertDayOfWeek(date.DayOfWeek) == day) //星期几相同
//		{
//			DateTime firstDay = new DateTime(date.Year, date.Month, 1);//生成当月第一天
//			int i = ConvertDayOfWeek(firstDay.DayOfWeek);
//			int firWeekDays = 7 - ConvertDayOfWeek(firstDay.DayOfWeek) + 1; //计算第一周剩余天数
//			if (i > day)
//			{
//				if ((week - 1) * 7 + day + firWeekDays == date.Day)
//				{
//					ret = true;
//				}
//			}
//			else
//			{
//				if (day + firWeekDays + (week - 2) * 7 == date.Day)
//				{
//					ret = true;
//				}
//			}
//		}
//	}
//	return ret;
//}

/// 计算中国农历节日
//public string ChineseCalendarHoliday
//{
//	get
//	{
//		string tempStr = "";
//		if (this._cIsLeapMonth == false) //闰月不计算节日
//		{
//			foreach (LunarHolidayStruct lh in lHolidayInfo)
//			{
//				if ((lh.Month == this._cMonth) && (lh.Day == this._cDay))
//				{
//					tempStr = lh.HolidayName;
//					break;
//				}
//			}
//			//对除夕进行特别处理
//			if (this._cMonth == 12)
//			{
//				int i = GetChineseMonthDays(this._cYear, 12); //计算当年农历12月的总天数
//				if (this._cDay == i) //如果为最后一天
//				{
//					tempStr = "除夕";
//				}
//			}
//		}
//		return tempStr;
//	}
//}

/// 按某月第几周第几日计算的节日
//public string WeekDayHoliday
//{
//	get
//	{
//		string tempStr = "";
//		foreach (WeekHolidayStruct wh in wHolidayInfo)
//		{
//			if (CompareWeekDayHoliday(_date, wh.Month, wh.WeekAtMonth, wh.WeekDay))
//			{
//				tempStr = wh.HolidayName;
//				break;
//			}
//		}
//		return tempStr;
//	}
//}

/// 按公历日计算的节日
//public string DateHoliday
//{
//	get
//	{
//		string tempStr = "";
//		foreach (SolarHolidayStruct sh in sHolidayInfo)
//		{
//			if ((sh.Month == _date.Month) && (sh.Day == _date.Day))
//			{
//				tempStr = sh.HolidayName;
//				break;
//			}
//		}
//		return tempStr;
//	}
//}

@end
