//
//  Calendar.m
//  CalendarCell
//
//  Created by 黄 芦荣 on 12-3-31.
//  Copyright 2012 卓派. All rights reserved.
//

#import "Calendar.h"
#import "CalendarCell.h"
#import "LunarDB.h"
#import "datePickView.h"
#import "ShareFun.h"
#import "UIColor+ColorWithHexColor.h"
#import "UILabel+utils.h"

@interface Calendar(private)


-(void)_drawTopBarDate:(CGRect)t_frame;
@end


static int width ;
static int height;
static int dateWordsSize =20;
static int dateRow = 0;

@implementation Calendar

@synthesize m_currentDate;
@synthesize m_today;
@synthesize m_dateWords;
@synthesize calendarDelegate;


#pragma mark -
#pragma mark -init

-(id)initWithFrame:(CGRect)frame{
	
	if (self = [super initWithFrame:frame]) {
        self.isOpen = YES;
//        [self getHolidayInfos];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatAlert) name:@"creatAlert" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewYM) name:@"NewYM" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(citydatas:) name:@"rili" object:nil];
		//得到当前时间
		CFAbsoluteTime t_currentTime = CFAbsoluteTimeGetCurrent();
		m_currentDate = CFAbsoluteTimeGetGregorianDate(t_currentTime, CFTimeZoneCopyDefault());
		m_today =       CFAbsoluteTimeGetGregorianDate(t_currentTime, CFTimeZoneCopyDefault());
		
		width = self.frame.size.width;
		height = self.frame.size.height;
		self.backgroundColor = [UIColor clearColor];
        
		//整个背景图
		/*CGRect t_frame = CGRectMake(0, 0, width, height);
		 UIImageView *bg_image = [[UIImageView alloc] initWithFrame:t_frame];
		 [bg_image setImage:[UIImage imageNamed:@"backgound.png"]];
		 [self addSubview:bg_image];
		 [bg_image release];*/
		
        //        435
        
		//日历头条
		CGRect t_frame = CGRectMake(0, 0, width, 50);
		[self _drawTopBarDate:t_frame];
		
        
        yearstr=@"2014";
        monthstr=@"12";
        daystr=@"31";
		m_dateArray = [[NSMutableArray alloc] init];
        self.holidayDatas = [[NSMutableArray alloc] init];
        self.rarr=[[NSMutableArray alloc]init];
        self.larr=[[NSMutableArray alloc]init];
        
		self.memos=[[NSMutableArray alloc]init];
        self.hlist=[[NSMutableArray alloc]init];
        self.wlist=[[NSMutableArray alloc]init];
        self.years=[[NSMutableArray alloc]init];
        self.months=[[NSMutableArray alloc]init];
        self.days=[[NSMutableArray alloc]init];
        self.months=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
        for (int i=0; i<2014-1965; i++) {
            NSString *y=[NSString stringWithFormat:@"%d",2014-i];
            [self.years addObject:y];
        }
        for (int i=0; i<=[self howManyDaysInThisMonth:yearstr.intValue month:monthstr.intValue]; i++) {
            NSString *day=@"";
//            if (i<10) {
//                day=[NSString stringWithFormat:@"0%d",i];
//            }else
                day=[NSString stringWithFormat:@"%d",i];
            if (i>0) {
                [self.days addObject:day];
            }
            
        }
        //日历日期视图背景遮罩
//        _dateMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenWidth/7.0)];
//        _dateMaskView.backgroundColor = [UIColor clearColor];
//        _dateMaskView.clipsToBounds = YES;
//        [self addSubview:_dateMaskView];
        
        self.bgscro=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeitht)];
        self.bgscro.showsHorizontalScrollIndicator=NO;
        self.bgscro.showsVerticalScrollIndicator=NO;
        self.bgscro.delegate=self;
        self.bgscro.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht*2);
        [self addSubview:self.bgscro];
        
		//日历日期视图
		t_frame = CGRectMake(0, 0, width, 100);
		m_dateView = [[UIView alloc] initWithFrame:t_frame];
		m_dateView.backgroundColor = [UIColor clearColor];
		[self drawDateGrid:m_currentDate];
//		[self fillInDate:m_currentDate];
        [self getgz_cal_holiday_info];
		[self.bgscro addSubview:m_dateView];
     
		
//        UIButton * upBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-30, 50+m_dateView.frame.size.height, 35, 19)];
//        self.upBut = upBut;
//        [upBut setBackgroundImage:[UIImage imageNamed:@"shang_03.png"] forState:UIControlStateNormal];
//        [upBut addTarget:self action:@selector(upButAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:upBut];
        
        //创建第二页的视图
        UIView * secondPageBackground = [[UIView alloc] initWithFrame:CGRectMake(0, m_dateView.frame.size.height+10, kScreenWidth, CGRectGetHeight(self.frame)-( width/7.0+50+5))];
        self.secondView = secondPageBackground;
        secondPageBackground.backgroundColor = [UIColor whiteColor];
        [self.bgscro addSubview:secondPageBackground];
        
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        //        line.image = [UIImage imageNamed:@"隔条.png"];
        line.backgroundColor = [UIColor blackColor];
//        [secondPageBackground addSubview:line];
        
//        UIButton * downBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-30, -3, 35, 19)];
//        self.downBut = downBut;
//        downBut.hidden = !self.isOpen;
//        [downBut setBackgroundImage:[UIImage imageNamed:@"xia_03.png"] forState:UIControlStateNormal];
//        [downBut addTarget:self action:@selector(downButAction:) forControlEvents:UIControlEventTouchUpInside];
//        [secondPageBackground addSubview:downBut];
        
        yearstr=@"2014";
        monthstr=@"12";
        daystr=@"31";
        
        self.menoday=[NSString stringWithFormat:@"%d%d%d",m_currentDate.day,m_currentDate.month,m_currentDate.year];
        
        NSMutableArray *marr=[[setting sharedSetting].memodic objectForKey:self.menoday];
        
        for (int i=0; i<marr.count; i++) {
            NSString *cont=[[marr objectAtIndex:i]objectForKey:self.menoday];
            if (cont.length>0) {
                
                [self.memos addObject:cont];
            }
        }
        
        _holidayList = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 390+self.memos.count*50)];
        _holidayList.delegate = self;
        _holidayList.dataSource = self;
        _holidayList.separatorStyle=UITableViewCellSeparatorStyleNone;
        [secondPageBackground addSubview:_holidayList];
        
        _holidayList.scrollEnabled=NO;
        
        self.bgscro.contentSize=CGSizeMake(kScreenWidth, m_dateView.frame.size.height+_holidayList.frame.size.height+200);
//        self.bgscro.contentSize=CGSizeMake(kScreenWidth, m_dateView.frame.size.height+_holidayList.frame.size.height+200);
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClicked)];
//        [self addGestureRecognizer:tap];
//        [self getTodayinfos:nil];
        
	}
	return self;
}
-(void)today:(NSString *)day{
    [self.memos removeAllObjects];
    NSMutableArray *marr=[[setting sharedSetting].memodic objectForKey:day];
    
    for (int i=0; i<marr.count; i++) {
        NSString *cont=[[marr objectAtIndex:i]objectForKey:day];
        if (cont.length>0) {
            
            [self.memos addObject:cont];
        }
    }
    [self.holidayList reloadData];
}
-(void)creatAlert{
    Rilialert *rlal=[[Rilialert alloc]initWithLogoImage:nil withTitle:[NSString stringWithFormat:@"%@ %@",self.date,self.n_date] withContent:nil withleftname:@"保存" withrightname:@"取消"];
    rlal.delegate=self;
    [rlal show];
}
-(void)clickButtonWithTag:(int)tag withcontentstr:(NSString *)content{
    
    
    
    if (tag==1) {
        [self.memos removeAllObjects];
        
        NSString*bwday=[NSString stringWithFormat:@"%@",self.menoday];
        self.menoday=bwday;
        NSDictionary *memodic=[NSDictionary dictionaryWithObject:content forKey:bwday];
        [[setting sharedSetting ].memos addObject:memodic];

        NSMutableDictionary * allLifeDic =[[NSMutableDictionary alloc] initWithDictionary:[setting sharedSetting].memodic];
        [allLifeDic setValue:[setting sharedSetting].memos forKey:bwday];
        [setting sharedSetting].memodic = allLifeDic;
        [[setting sharedSetting] saveSetting];
        
        
        NSMutableArray *marr=[[setting sharedSetting].memodic objectForKey:self.menoday];
        
        for (int i=0; i<marr.count; i++) {
            NSString *cont=[[marr objectAtIndex:i]objectForKey:self.menoday];
            if (cont.length>0) {
                
                [self.memos addObject:cont];
            }
        }
        
//        _holidayList.frame=CGRectMake(0, 5, kScreenWidth, 390+self.memos.count*50);
//        _holidayList.scrollEnabled=NO;
//        [self.holidayList reloadData];
//        self.bgscro.contentSize=CGSizeMake(kScreenWidth, m_dateView.frame.size.height+_holidayList.frame.size.height+200);
        [self selectedCell:nil setDay:m_today.day setMonth:m_today.month setYear:m_today.year withTag:m_today.day-1];//添加后返回今天
        [self mark];

    }
    
    
   
}
-(void)NewYM{
    [self.memos removeAllObjects];
    self.isearil=YES;
    self.bwday=0;
    NSString*bwday=[NSString stringWithFormat:@"%d%d%d",self.bwday,self.bwmonth,self.bwyear];
    self.menoday=bwday;
    
    NSMutableArray *marr=[[setting sharedSetting].memodic objectForKey:self.menoday];
    for (int i=0; i<marr.count; i++) {
        NSString *cont=[[marr objectAtIndex:i]objectForKey:self.menoday];
        if (cont.length>0) {
            [self.memos addObject:cont];
        }
    }
}
-(void)citydatas:(NSNotification *)object{
    NSDictionary *dic=object.object;
    city=[dic objectForKey:@"city"];
    cityid=[dic objectForKey:@"ID"];
    [self.holidayList reloadData];
    
}
-(void)getHolidayInfosWithinfors:(NSMutableArray *)infors
{
        self.holidayDatas = [[NSMutableArray alloc] init];
    
    for (int i=0; i<infors.count; i++) {
        NSString *holiday=[[infors objectAtIndex:i]objectForKey:@"holiday"];
        NSString *date=[[infors objectAtIndex:i]objectForKey:@"date"];
        NSString *weekstr=[[infors objectAtIndex:i]objectForKey:@"week"];
        NSMutableDictionary * holidayInfoDic1 = [[NSMutableDictionary alloc] init];
        //type 用来判断是什么类型的 1代表节日节气，2代表农历 3代表宜、忌、冲
        [holidayInfoDic1 setObject:@"1" forKey:@"type"];
        NSMutableDictionary * info1 = [[NSMutableDictionary alloc] init];
        [info1 setObject:holiday forKey:@"name"];
        [info1 setObject:date forKey:@"day"];
        [info1 setObject:weekstr forKey:@"week"];
        [holidayInfoDic1 setObject:info1 forKey:@"info"];
        [self.holidayDatas addObject:holidayInfoDic1];
    }


    
    [self showselectedDate:[NSDate date]];
    
}

#pragma 备忘录
-(void)getTodayinfos:(NSArray *)infos{
    
    
//    NSString *cont=@"备忘";
//    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:@"0" forKey:@"type"];
//    [dic setObject:cont forKey:@"content"];
//    [self.holidayDatas addObject:dic];
    
    NSMutableDictionary * dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:@"1" forKey:@"type"];//1为生日查询
    [self.holidayDatas addObject:dic1];
    
    NSDateComponents *t_comps =[[NSDateComponents alloc] init];
    
    [t_comps setYear:m_currentDate.year];
    [t_comps setMonth:m_currentDate.month];
    [t_comps setDay:m_currentDate.day];
    [t_comps setHour:m_currentDate.hour];
    [t_comps setMinute:m_currentDate.minute];
    [t_comps setSecond:m_currentDate.second];
    
    NSCalendar *t_calendar =[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *Date = [t_calendar dateFromComponents:t_comps];
    if (Date) {
        [self showselectedDate:Date];//农历
    }else
    [self showselectedDate:[NSDate date]];//农历
}


#pragma mark -
#pragma mark -private moethods


//得到一个月第一天在星期几
-(int)_getFirstDayOfMonth:(CFGregorianDate)t_date{
    
	CFTimeZoneRef t_timeZone = CFTimeZoneCopyDefault();
	CFGregorianDate t_month;
	t_month.year = t_date.year;
	t_month.month = t_date.month;
	t_month.day = 1;
	t_month.hour = 0;
	t_month.minute = 0;
	t_month.second = 1;
	NSLog(@"%d",(int) CFAbsoluteTimeGetDayOfWeek(CFGregorianDateGetAbsoluteTime(t_month,t_timeZone),t_timeZone));
	return (int) CFAbsoluteTimeGetDayOfWeek(CFGregorianDateGetAbsoluteTime(t_month,t_timeZone),t_timeZone);
    
}
//得到在星期几
-(NSString *)_getDayOfMonth:(NSString *)t_date{
    
    NSString *week;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSDate *aDate = [dateFormatter dateFromString:t_date];
    [dateFormatter setDateFormat:@"EEE"];
    NSString *string = [dateFormatter stringFromDate:aDate];//  string为  周日
    if ([string isEqualToString:@"周一"]||[string isEqualToString:@"周二"]||[string isEqualToString:@"周三"]||[string isEqualToString:@"周四"]||[string isEqualToString:@"周五"]||[string isEqualToString:@"周六"]||[string isEqualToString:@"周日"]) {
        week=string;
    }else{
    if ([string isEqualToString:@"Mon"]) {
        week=@"周一";
    }
    if ([string isEqualToString:@"Tue"]) {
        week=@"周二";
    }
    if ([string isEqualToString:@"Wed"]) {
        week=@"周三";
    }
    if ([string isEqualToString:@"Thu"]) {
        week=@"周四";
    }
    if ([string isEqualToString:@"Fri"]) {
        week=@"周五";
    }
    if ([string isEqualToString:@"Sat"]) {
        week=@"周六";
    }
    if ([string isEqualToString:@"Sun"]) {
        week=@"周日";
    }
        if ([string isEqualToString:@"週一"]) {
            week=@"周一";
        }
        if ([string isEqualToString:@"週二"]) {
            week=@"周二";
        }
        if ([string isEqualToString:@"週三"]) {
            week=@"周三";
        }
        if ([string isEqualToString:@"週四"]) {
            week=@"周四";
        }
        if ([string isEqualToString:@"週五"]) {
            week=@"周五";
        }
        if ([string isEqualToString:@"週六"]) {
            week=@"周六";
        }
        if ([string isEqualToString:@"週日"]) {
            week=@"周日";
        }
    }
//    [dateFormatter setDateFormat:@"e"];
//    NSString *string1 = [dateFormatter stringFromDate:aDate]; //string1 为 1
    return week;
}
// 得到一个月的天数
-(int)_getDateCount:(CFGregorianDate)t_date{
    
	switch (t_date.month) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			return 31;
			
		case 2:
			if(t_date.year%4==0 && t_date.year%100!=0)
				return 29;
			else
				return 28;
		case 4:
		case 6:
		case 9:
		case 11:
			return 30;
		default:
			return 31;
	}
}


//显示所需要的行数
-(int)_getRowCount:(CFGregorianDate)t_date{
	
	int t_first = [self _getFirstDayOfMonth:t_date];
	int t_dateCount = [self _getDateCount:t_date];
	int t_sum = t_first + t_dateCount;
	
	if ( t_first != 7 && t_sum > 28 && t_sum != 35) {
		return t_sum/7 +1;
	}else if ((t_first == 7 && t_dateCount != 28)|| t_sum == 35) {
		return t_sum/7;
	}else {
		return t_sum/7-1;
	}
}





//日期头条显示
-(void)_drawTopBarDate:(CGRect)t_frame{
	
	float t_weekSize = (t_frame.size.width)/7;
	
	UIView *t_topBarView =[[UIView alloc] initWithFrame:t_frame];
	t_topBarView.backgroundColor = [UIColor clearColor];
	
	for (int i = 0; i <= 7; i++) {
		t_frame = CGRectMake(i*t_weekSize, 15, t_weekSize, 20);
		UILabel *weekLabel = [[UILabel alloc]initWithFrame:t_frame];
		[weekLabel setFont:[UIFont systemFontOfSize:16]];
		[weekLabel setTextAlignment:NSTextAlignmentCenter];
		[weekLabel setTextColor:[UIColor blackColor]];
		[weekLabel setBackgroundColor:[UIColor clearColor]];
		switch (i) {
			case 0:
                [weekLabel setText:@"周日"];
				break;
			case 1:
				[weekLabel setText:@"周一"];
				break;
			case 2:
				[weekLabel setText:@"周二"];
				break;
			case 3:
				[weekLabel setText:@"周三"];
				break;
			case 4:
				[weekLabel setText:@"周四"];
				break;
			case 5:
				[weekLabel setText:@"周五"];
				break;
			case 6:
				[weekLabel setText:@"周六"];
				break;
		}
        if ([weekLabel.text isEqualToString:@"周六"]||[weekLabel.text isEqualToString:@"周日" ]) {
            [weekLabel setTextColor:[UIColor redColor]];
        }
		[t_topBarView addSubview:weekLabel];
        //		[weekLabel release];
	}
	
	[self addSubview:t_topBarView];
    //	[t_topBarView release];
	
}

#pragma mark -
#pragma mark -public
- (NSString *) getChineseDay:(NSString *)t_string
{
	NSDateFormatter *t_dateFormatter = [[NSDateFormatter alloc] init];
//	[t_dateFormatter setDateStyle:kCFDateFormatterFullStyle];
	[t_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *t_date = [t_dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 16:00:00", t_string]];
    //	[t_dateFormatter release];
	
	LunarDB *t_lunarDB = [[LunarDB alloc] init];
	[t_lunarDB setSolarDate:t_date];
	NSString *t_ri = [t_lunarDB ChineseTwentyFourDay];
	NSString *t_LDBstring = [t_lunarDB ChineseDateString];
    //	[t_lunarDB release];
	
	if ([t_ri isEqualToString:@""])
	{
		NSArray *t_array1 = [t_LDBstring componentsSeparatedByString:@"月"];
		t_ri = [t_array1 objectAtIndex:1];
		if ([t_ri isEqualToString:@"初一"]) {
			NSArray *t_array2 = [[t_array1 objectAtIndex:0] componentsSeparatedByString:@"历"];
			t_ri = [NSString stringWithFormat:@"%@月", [t_array2 objectAtIndex:1]];
		}
	}
	
	return t_ri;
}
- (NSString *) getnoliday:(NSString *)t_string
{
    NSDateFormatter *t_dateFormatter = [[NSDateFormatter alloc] init];
    //	[t_dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [t_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *t_date = [t_dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 16:00:00", t_string]];
    //	[t_dateFormatter release];
    
    LunarDB *t_lunarDB = [[LunarDB alloc] init];
    [t_lunarDB setSolarDate:t_date];

    NSString *t_LDBstring = [t_lunarDB ChineseDateString];
    
    return t_LDBstring;
}
+(NSString *)getChineseHoliday:(NSString *)t_rili{
    NSString *chineseHoliday;
    NSDateFormatter *t_dateFormatter = [[NSDateFormatter alloc] init];
//	[t_dateFormatter setDateStyle:kCFDateFormatterFullStyle];
	[t_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *t_date = [t_dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 16:00:00", t_rili]];
    //	[t_dateFormatter release];
	
	LunarDB *t_lunarDB = [[LunarDB alloc] init];
	[t_lunarDB setSolarDate:t_date];
//	NSString *t_ri = [t_lunarDB ChineseTwentyFourDay];
	NSString *t_LDBstring = [t_lunarDB ChineseDateString];
  
    if ([t_LDBstring isEqualToString:@"农历正月十五"]) {
        chineseHoliday=@"元宵节";
    }
    if ([t_LDBstring isEqualToString:@"农历五月初五"]) {
        chineseHoliday=@"端午节";
    }
    if ([t_LDBstring isEqualToString:@"农历七月初七"]) {
        chineseHoliday=@"七夕节";
    }
    if ([t_LDBstring isEqualToString:@"农历八月十五"]) {
        chineseHoliday=@"中秋节";
    }
    if ([t_LDBstring isEqualToString:@"农历九月初九"]) {
        chineseHoliday=@"重阳节";
    }
    if ([t_LDBstring isEqualToString:@"农历腊月初八"]) {
        chineseHoliday=@"腊八节";
    }
//    if ([t_LDBstring isEqualToString:@"农历腊月二十五"]) {
//        chineseHoliday=@"小年";
//    }
    if ([t_LDBstring isEqualToString:@"农历腊月三十"]) {
        chineseHoliday=@"除夕";
    }
    if ([t_LDBstring isEqualToString:@"农历正月初一"]) {
        chineseHoliday=@"春节";
    }
    return chineseHoliday;
}
-(NSString *)getjieqi:(NSString *)rili{
    NSDateFormatter *t_dateFormatter = [[NSDateFormatter alloc] init];
//	[t_dateFormatter setDateStyle:kCFDateFormatterFullStyle];
	[t_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *t_date = [t_dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 16:00:00", rili]];
    //	[t_dateFormatter release];
	
	LunarDB *t_lunarDB = [[LunarDB alloc] init];
	[t_lunarDB setSolarDate:t_date];
	NSString *t_ri = [t_lunarDB ChineseTwentyFourDay];
    NSLog(@"%@",t_ri);
   
    return t_ri;
}
+(NSString *) getHolidayDayWithyear:(int )t_year Withmonth:(int)t_month Withday:(NSString *)t_day{
    NSString *holiday;
    if (t_month==1) {
        if (t_day.integerValue==1) {
            holiday=@"元旦";
        }
        
    }
    if (t_month==2&&t_day.integerValue==14) {
        holiday=@"情人节";
    }
//    if (t_month==3&&t_day.integerValue==8) {
//        holiday=@"妇女节";
//    }
    if (t_month==3&&t_day.integerValue==12) {
        holiday=@"植树节";
    }
    if (t_month==3&&t_day.integerValue==21) {
        holiday=@"世界森林日";
    }
    if (t_month==3&&t_day.integerValue==22) {
        holiday=@"世界水日";
    }
    if (t_month==3&&t_day.integerValue==23) {
        holiday=@"世界气象日";
    }
    if (t_month==6&&t_day.integerValue==5) {
        holiday=@"世界环境日";
    }
    if (t_month==4&&t_day.integerValue==1) {
        holiday=@"愚人节";
    }
    if (t_month==5&&t_day.integerValue==1) {
        holiday=@"劳动节";
    }
    if (t_month==6&&t_day.integerValue==1) {
        holiday=@"儿童节";
    }
//    if (t_month==8&&t_day.integerValue==1) {
//        holiday=@"建军";
//    }
    if (t_month==9&&t_day.integerValue==10) {
        holiday=@"教师节";
    }
    if (t_month==10&&t_day.integerValue==1) {
        holiday=@"国庆节";
    }
    if (t_month==12&&t_day.integerValue==25) {
        holiday=@"圣诞节";
    }
    return holiday;
   }
+(NSString *) getnewHolidayDayWithyear:(int )t_year Withmonth:(int)t_month Withday:(NSString *)t_day{
    NSString *holiday;
    if (t_month==1) {
        if (t_day.integerValue==1) {
            holiday=@"元旦";
        }
        
    }
    if (t_month==2&&t_day.integerValue==14) {
        holiday=@"情人节";
    }
    //    if (t_month==3&&t_day.integerValue==8) {
    //        holiday=@"妇女节";
    //    }
    if (t_month==3&&t_day.integerValue==12) {
        holiday=@"植树节";
    }
    if (t_month==4&&t_day.integerValue==1) {
        holiday=@"愚人节";
    }
    if (t_month==5&&t_day.integerValue==1) {
        holiday=@"劳动节";
    }
    if (t_month==6&&t_day.integerValue==1) {
        holiday=@"儿童节";
    }
    //    if (t_month==8&&t_day.integerValue==1) {
    //        holiday=@"建军";
    //    }
    if (t_month==9&&t_day.integerValue==10) {
        holiday=@"教师节";
    }
    if (t_month==10&&t_day.integerValue==1) {
        holiday=@"国庆节";
    }
    if (t_month==12&&t_day.integerValue==25) {
        holiday=@"圣诞节";
    }
    return holiday;
}
// 清除数据
-(void)cleanDate
{
	int count = [m_dateArray count];
	for (int i = count - 1; i >= 0; i --) {
		[[m_dateArray objectAtIndex:i] removeFromSuperview];
		[m_dateArray removeObjectAtIndex:i];
	}
	
}

//填充日期
-(void)fillInDate:(CFGregorianDate)t_date
{
	int x = 0;
	
	int t_first = [self _getFirstDayOfMonth:t_date];
	int t_dateCount = [self _getDateCount:t_date];
    
//    NSMutableArray *marr=[[NSMutableArray alloc]init];
	//--------------------------当月日期---------------------------------//
	for (int i = 0; i < t_dateCount; i++)
	{
		x = (i + t_first) % 7;
		
        
        
		NSString *t_dateWords = [NSString stringWithFormat:@"%d", i+1];
//        NSLog(@"#t_dateWords = %@#",t_dateWords);
		CalendarCell * t_cell= [m_dateArray objectAtIndex:i];
		t_cell.m_dateText.text = t_dateWords;
		t_cell.m_almanacText.text =t_dateWords;
		t_cell.m_month = t_date.month;
		t_cell.m_year = t_date.year;
    
        if ([Calendar getnewHolidayDayWithyear:t_date.year Withmonth:t_date.month Withday:t_dateWords].length>0) {
            t_cell.m_almanacText.text=[Calendar getnewHolidayDayWithyear:t_date.year Withmonth:t_date.month Withday:t_dateWords];
            t_cell.m_almanacText.textColor=[UIColor redColor];
        }else if([Calendar getChineseHoliday:[NSString stringWithFormat:@"%d-%d-%@", t_cell.m_year, t_cell.m_month, t_cell.m_dateText.text]].length>0){
            t_cell.m_almanacText.text=[Calendar getChineseHoliday:[NSString stringWithFormat:@"%d-%d-%@", t_cell.m_year, t_cell.m_month, t_cell.m_dateText.text]];
            t_cell.m_almanacText.textColor=[UIColor redColor];
        }else{
            t_cell.m_almanacText.text = [self getChineseDay:[NSString stringWithFormat:@"%d-%d-%@", t_cell.m_year, t_cell.m_month, t_cell.m_dateText.text]];
        }
        self.date=[NSString stringWithFormat:@"%d年%d月%@日", t_cell.m_year, t_cell.m_month, t_cell.m_dateText.text];
        self.n_date= [self getnoliday:[NSString stringWithFormat:@"%d-%d-%@", t_cell.m_year, t_cell.m_month, t_cell.m_dateText.text]];
        NSString *d=t_cell.m_dateText.text;
        NSString *m=[NSString stringWithFormat:@"%d",t_cell.m_month];
        if (t_cell.m_month<10) {
            m=[NSString stringWithFormat:@"0%d",t_cell.m_month];
        }
        if (d.integerValue<10) {
            d=[NSString stringWithFormat:@"0%@",t_cell.m_dateText.text];
        }
        NSString *date=[NSString stringWithFormat:@"%d-%@-%@", t_cell.m_year,m, d];
        
        if (x==0||x==6) {
            t_cell.m_dateText.textColor=[UIColor redColor];
            t_cell.m_almanacText.textColor=[UIColor redColor];
        }
        
        if ([self.hlist containsObject:date]) {
            t_cell.hwimg.image=[UIImage imageNamed:@"假期.png"];
        }
        if ([self.wlist containsObject:date]) {
            t_cell.hwimg.image=[UIImage imageNamed:@"班.png"];
        }
//        NSString *date=[NSString stringWithFormat:@"%d月%@日",t_date.month,t_cell.m_dateText.text ];
//       NSString *chineseholiday =[self getChineseHoliday:[NSString stringWithFormat:@"%d-%d-%@", t_cell.m_year, t_cell.m_month, t_cell.m_dateText.text]];
//       NSString *holiday =[self getHolidayDayWithyear:t_cell.m_year Withmonth:t_cell.m_month Withday:t_cell.m_dateText.text];
//        NSString *jieqi=[self getjieqi:[NSString stringWithFormat:@"%d-%d-%@", t_cell.m_year, t_cell.m_month, t_cell.m_dateText.text]];
//        
//        NSString *week=[self _getDayOfMonth:[NSString stringWithFormat:@"%d/%d/%@", t_cell.m_year, t_cell.m_month, t_cell.m_dateText.text]];
//        
//        NSMutableDictionary *mdic=[[NSMutableDictionary alloc]init];
//        
//        
//       
//        if (chineseholiday.length>0&&jieqi.length>0) {
//            [mdic setObject:date forKey:@"date"];
//            [mdic setObject:chineseholiday forKey:@"holiday"];
//            [mdic setObject:week forKey:@"week"];
//            [marr addObject:mdic];
//        }else if (holiday.length>0&&jieqi.length>0) {
//            [mdic setObject:date forKey:@"date"];
//            [mdic setObject:holiday forKey:@"holiday"];
//            [mdic setObject:week forKey:@"week"];
//            [marr addObject:mdic];
//        }
//        else  if (jieqi.length>0) {
//            [mdic setObject:date forKey:@"date"];
//            [mdic setObject:jieqi forKey:@"holiday"];
//            [mdic setObject:week forKey:@"week"];
//            [marr addObject:mdic];
//        }else if (chineseholiday.length>0) {
//            [mdic setObject:date forKey:@"date"];
//            [mdic setObject:chineseholiday forKey:@"holiday"];
//            [mdic setObject:week forKey:@"week"];
//            [marr addObject:mdic];
//        }else if (holiday.length>0) {
//            [mdic setObject:date forKey:@"date"];
//            [mdic setObject:holiday forKey:@"holiday"];
//            [mdic setObject:week forKey:@"week"];
//            [marr addObject:mdic];
//        }
        NSString *keyday=[NSString stringWithFormat:@"%@%d%d",t_dateWords,t_date.month,t_date.year];
        //        NSLog(@"%@",keyday);
        
        NSMutableArray *arr=[[setting sharedSetting].memodic objectForKey:keyday];
        //        NSLog(@"%@",self.menoday);
        if (arr.count>0) {
            for (int j=0; j<arr.count; j++) {
                NSDictionary *d=[arr objectAtIndex:j];
                NSString *a=[d objectForKey:keyday];
                if (a.length>0) {
                    NSDateComponents *t_comps =[[NSDateComponents alloc] init];
                    
                    [t_comps setYear:t_date.year];
                    [t_comps setMonth:t_date.month];
                    [t_comps setDay:i+2];
                    [t_comps setHour:0];
                    [t_comps setMinute:0];
                    [t_comps setSecond:1];
                    
                    NSCalendar *t_calendar =[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    
                    NSDate *t_selectedDate = [t_calendar dateFromComponents:t_comps];
                    //	[t_comps release];
                    //	[t_calendar release];
                    [self showselectedDate:t_selectedDate];
                    NSDate *date=[NSDate date];
                    NSTimeInterval interval = [t_selectedDate timeIntervalSinceDate:date];//判断是否过期
                    if (interval>0) {
                        t_cell.pointimg.image = [UIImage imageNamed:@"日期红点.png"];
                    }
                }
            }
            
        }

	}
    
    
    
//    [self getHolidayInfosWithinfors:marr];//节日节气
    [self getTodayinfos:nil];
	//--------------------------------------------------------------------//
	
	//————————————————————————————————————对今天的位置的判断——————————————————————————————————————————//
	if (m_today.year == t_date.year && m_today.month == t_date.month) {
		m_todayCell = [m_dateArray objectAtIndex:m_today.day - 1];
        //调整只看到这周的日期
//        NSLog(@"%f",m_todayCell.frame.size.height);
        CGRect oringinFrame = m_dateView.frame;
        float num = (m_today.day+t_first)/7;
        
        self.bwday=m_today.day;//备忘日期，当天日期
        NSString*bwday=[NSString stringWithFormat:@"%d%d%d",self.bwday,m_today.month,m_today.year];
        self.menoday=bwday;
        
//        NSLog(@"%d",m_today.day);
        if((m_today.day+t_first)%7!=0)
        {
            num+=1;
        }
//        if(!self.clickToday)
//        {
//            m_dateView.frame = CGRectMake(0, oringinFrame.origin.y-m_todayCell.frame.size.height*(num-1), oringinFrame.size.width, oringinFrame.size.height);
//        }
//        
//        //
//        NSLog(@"%f",m_dateView.frame.origin.y);
		m_todayCell.m_bgImage.image = [UIImage imageNamed:@"红色圈.png"];
	}
    else
    {
        int day=1;
        NSString*bwday=[NSString stringWithFormat:@"%d",day];
        self.bwday=day;
        self.menoday=bwday;
//        CGRect oringinFrame = m_dateView.frame;
//        m_dateView.frame = CGRectMake(0, 0, oringinFrame.size.width, oringinFrame.size.height);
    }
	//--------------------------------------------------------------------------------------------//
    [_holidayList reloadData];
}

//日期网格绘制
-(void)drawDateGrid:(CFGregorianDate)t_date{
	
	float t_width = (m_dateView.frame.size.width)/7;
	
	dateRow = [self _getRowCount:t_date];
    m_dateView.frame = CGRectMake(0, 0, self.frame.size.width, t_width*dateRow);
	
    
    
	int t_first = [self _getFirstDayOfMonth:t_date];
	int t_dateCount = [self _getDateCount:t_date];
	
    for (UIImageView * line in self.rarr ) {
        [line removeFromSuperview];
    }
    for (UIImageView *line in self.larr) {
        [line removeFromSuperview];
    }
    [self.larr removeAllObjects];
    [self.rarr removeAllObjects];
   //画表格
    for (int k=0; k<7; k++) {
        UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(k*t_width, 0, 0.5, t_width*dateRow)];
        line1.backgroundColor=[UIColor grayColor];
        [m_dateView addSubview:line1];
        [self.larr addObject:line1];
    }
    for (int l=0; l<=dateRow; l++) {
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, l*t_width, self.frame.size.width, 0.5)];
        line.backgroundColor=[UIColor grayColor];
        [m_dateView addSubview:line];
        [self.rarr addObject:line];
    }
	int i = 0;
	int j = 0;
	int count = 0;
	
	for (; i< dateRow; i++) {
		
		if (0 == i)
			j = t_first % 7;
		else
			j = 0;
		
		for (; j < 7; j++) {
			
			if (++ count > t_dateCount)
				return;
			
			CGRect t_frame = CGRectMake(j*t_width, i*t_width, t_width, t_width);
			CalendarCell *my_cell = [[CalendarCell alloc] initWithType:1 setFrame:t_frame];
			my_cell.delegate = self;
			[m_dateView addSubview:my_cell];
			[m_dateArray addObject:my_cell];
            my_cell.tag = m_dateArray.count -1;
		}
	}
    
}
-(void)getgz_cal_holiday_info{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [b setObject:gz_todaywt_inde forKey:@"gz_cal_holiday_info"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        NSDictionary * b = [returnData objectForKey:@"b"];
        ;
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_cal_holiday_info"];
            NSArray *holiday_list=[gz_air_qua_index objectForKey:@"holiday_list"];
            NSArray *work_list=[gz_air_qua_index objectForKey:@"work_list"];
            for (int i=0; i<holiday_list.count; i++) {
                NSString *date=[holiday_list[i] objectForKey:@"datetime"];
                [self.hlist addObject:date];
            }
            for (int i=0; i<work_list.count; i++) {
                NSString *date=[work_list[i] objectForKey:@"datetime"];
                [self.wlist addObject:date];
            }
            
        }
        [self fillInDate:m_currentDate];
        
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:YES];
       [self fillInDate:m_currentDate];
    } withCache:YES];
}
#pragma mark -
#pragma mark -button action
- (void) resetDate
{
	[self cleanDate];
	NSString *t_dateWords = [NSString stringWithFormat:@"%d年%d月",(int) m_currentDate.year, m_currentDate.month];
	[m_dateWords setText:t_dateWords];
	
	//—————————————————————切换动画效果—————————————————————————//
    //	CATransition *t_transition = [CATransition animation];
    //	t_transition.duration =0.4f;
    //	t_transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //	t_transition.type = @"push";
    //	if ([buttonFlag tag] != 0) {
    //		t_transition.subtype = kCATransitionFromRight;
    //	}else {
    //		t_transition.subtype = kCATransitionFromLeft;
    //	}
    //	t_transition.delegate =self;
    //	[self.layer addAnimation:t_transition forKey:nil];
	//------------------------------------------------------//
	
	dateRow = [self _getRowCount:m_currentDate];
	[self drawDateGrid:m_currentDate];
//	[self fillInDate:m_currentDate];
    [self getgz_cal_holiday_info];
    [self updateViewsFrame];
}
- (void) mark{
    [self cleanDate];
    NSString *t_dateWords = [NSString stringWithFormat:@"%d年%d月",(int) m_currentDate.year, m_currentDate.month];
    [m_dateWords setText:t_dateWords];
    dateRow = [self _getRowCount:m_currentDate];
    [self drawDateGrid:m_currentDate];
    [self fillInDate:m_currentDate];
    [self updateViewsFrame];
}
-(void)updateViewsFrame
{
//    self.upBut.frame = CGRectMake(kScreenWidth-30, 50+m_dateView.frame.size.height, 35, 19);
    CGRect originFram = m_dateView.frame;
    m_dateView.frame = CGRectMake(originFram.origin.x, 0, originFram.size.width, originFram.size.height);
    self.secondView.frame=CGRectMake(0, m_dateView.frame.size.height+5, kScreenWidth, 200);
//        [self downButAction:nil];

}


//向前向后一个月的日期变化
-(void)PrevNextButtonPressed:(id)buttonFlag
{
	int t_year = m_currentDate.year;
	int t_month = m_currentDate.month;
	
	if ([buttonFlag tag] != 0) {
		
		if (t_month < 12) {
			t_month += 1;
		}else {
			t_month = 1;
			t_year += 1;
		}
        
	}else {
		if (t_month > 1) {
			t_month -= 1;
		}else {
			t_month = 12;
			t_year -= 1;
		}
        
	}
	if (t_year > 2049 || t_year < 1901)
		return;
	
	m_currentDate.year = t_year;
	m_currentDate.month = t_month;
	
	[self resetDate];
}


#pragma mark -
#pragma mark -delegate Methods

-(void)selectedCell:(UIImageView *)t_image setDay:(int)t_day setMonth:(int)t_month setYear:(int)t_year withTag:(int)tag
{
//    NSLog(@"%@",self.currentSelectedCell);
    if(self.currentSelectedCell)
    {
        self.currentSelectedCell.selectedBut.selected = NO;
    }
    
    self.currentSelectedCell = [m_dateArray objectAtIndex:tag];
    
    if([self.currentSelectedCell isEqual:m_todayCell])
    {
    }
    else
    {
        self.currentSelectedCell.selectedBut.selected = YES;
    }
	NSDateComponents *t_comps =[[NSDateComponents alloc] init];
	
	[t_comps setYear:t_year];
	[t_comps setMonth:t_month];
	[t_comps setDay:t_day+1];
	[t_comps setHour:0];
	[t_comps setMinute:0];
	[t_comps setSecond:1];
	
	NSCalendar *t_calendar =[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDate *t_selectedDate = [t_calendar dateFromComponents:t_comps];
    //	[t_comps release];
    //	[t_calendar release];
	[self showselectedDate:t_selectedDate];
    
    self.date=[NSString stringWithFormat:@"%d年%d月%d日",t_year, t_month, t_day];
    
    self.n_date=[self getnoliday:[NSString stringWithFormat:@"%d-%d-%d",t_year,t_month,t_day]];
    
    NSDate *date=[NSDate date];
    NSTimeInterval interval = [t_selectedDate timeIntervalSinceDate:date];
    NSString *isbefore;
    if (interval>0) {
        isbefore=@"0";
        [self.memos removeAllObjects];
        self.isearil=YES;
        self.bwday=t_day;
        self.bwmonth=t_month;
        self.bwyear=t_year;
        NSString*bwday=[NSString stringWithFormat:@"%d%d%d",self.bwday,t_month,t_year];
        self.menoday=bwday;
        
        NSMutableArray *marr=[[setting sharedSetting].memodic objectForKey:self.menoday];
        for (int i=0; i<marr.count; i++) {
            NSString *cont=[[marr objectAtIndex:i]objectForKey:self.menoday];
            if (cont.length>0) {
                [self.memos addObject:cont];
            }
        }
        
        
    }else{
        isbefore=@"1";
        [self.memos removeAllObjects];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beforeday" object:isbefore];
    _holidayList.frame=CGRectMake(0, 5, kScreenWidth, 390+self.memos.count*50);
    _holidayList.scrollEnabled=NO;
    [self.holidayList reloadData];
    self.bgscro.contentSize=CGSizeMake(kScreenWidth, m_dateView.frame.size.height+_holidayList.frame.size.height+200);
}

- (void) showselectedDate:(NSDate *)t_date
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSInteger mint=5*60;//农历时间多加5分钟
    NSDate * nowdt = [localeDate dateByAddingTimeInterval:+mint];
    LunarDB *t_lunarDB = [[LunarDB alloc] init];
	[t_lunarDB setSolarDate:nowdt];
//    for(int i=0;i<self.holidayDatas.count;i++)
//    {
//        NSDictionary * dic = [self.holidayDatas objectAtIndex:i];
//        NSString * type = [dic objectForKey:@"type"];
//        NSLog(@"#%@#",type);
//        if([type isEqualToString:@"2"])
//        {
//            [self.holidayDatas removeObjectAtIndex:i];
//        }
//    }
//    for(int i=0;i<self.holidayDatas.count;i++)
//    {
//        NSDictionary * dic = [self.holidayDatas objectAtIndex:i];
//        NSString * type = [dic objectForKey:@"type"];
//        NSLog(@"#%@#",type);
//        if([type isEqualToString:@"3"])
//        {
//            [self.holidayDatas removeObjectAtIndex:i];
//        }
//    }
    
    NSMutableDictionary * jawudatadicInfo = [[NSMutableDictionary alloc] init];
    [jawudatadicInfo setObject:@"2" forKey:@"type"];
    NSMutableDictionary * jawuDic = [[NSMutableDictionary alloc] init];
    [jawuDic setObject:[t_lunarDB GanZhiDateString] forKey:@"day"];
    [jawudatadicInfo setObject:jawuDic forKey:@"info"];
    self.nldic=jawudatadicInfo;
    
//    [self.holidayDatas addObject:jawudatadicInfo];
    
    NSMutableDictionary * yijiDicInfo = [[NSMutableDictionary alloc] init];
    [yijiDicInfo setObject:@"3" forKey:@"type"];
    NSMutableDictionary * yijiDic = [[NSMutableDictionary alloc] init];
    [yijiDic setObject:[t_lunarDB GetDayYi] forKey:@"yi"];
    [yijiDic setObject:[t_lunarDB GetDayJi] forKey:@"ji"];
    [yijiDic setObject:[t_lunarDB GetShengxiaoChong] forKey:@"chong"];
    [yijiDic setObject:[t_lunarDB GetDayRijian] forKey:@"zhishen"];
    [yijiDic setObject:[t_lunarDB GetPengZuBaiJi] forKey:@"pengzubaiji"];
    [yijiDic setObject:[t_lunarDB ChineseConstellation] forKey:@"xinsuweifang"];
    [yijiDic setObject:[t_lunarDB GetTaiSheng] forKey:@"taishenzhanfang"];
    [yijiDicInfo setObject:yijiDic forKey:@"info"];
    self.hldic=yijiDicInfo;
//    [self.holidayDatas addObject:yijiDicInfo];
    [self.holidayList reloadData];
	//------------------黄历-------------------------------------------------------------------------------
    
}



- (void) pickDateClick
{
	NSDateFormatter *t_dateFormatter = [[NSDateFormatter alloc] init];
	[t_dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *t_minDate = [t_dateFormatter dateFromString:@"1901-01-01"];
	NSDate *t_date = [t_dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", (int)m_currentDate.year, m_currentDate.month, m_currentDate.day]];
	NSDate *t_maxDate = [t_dateFormatter dateFromString:@"2049-12-31"];
    //	[t_dateFormatter release];
	
	datePickView *dpView = [[datePickView alloc] initWithFrame:CGRectMake(0, 0, self.width, 260)];
	[dpView setDelegate:self];
	[dpView setMinDate:t_minDate andMaxDate:t_maxDate];
	[dpView setDate:t_date];
	[dpView showDatePickDlg];
	
    //	[dpView release];
}

- (void) didSelectDate:(datePickView *)dpView withDate:(NSDate *)dt withTag:(int)tag
{
	NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit;
	NSDateComponents *components = [calender components:flags fromDate:dt];
    //	[calender release];
	
	m_currentDate.year = [components year];
	m_currentDate.month = [components month];
	NSLog(@"%d,%d",(int)m_currentDate.year,m_currentDate.month);
	[self resetDate];
}

-(void)downButAction:(UIButton *)sender
{
    
    //    [self setNeedsDisplay];
    CGRect originFram = m_dateView.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
    NSLog(@"$%f$",self.secondView.frame.size.height);
    self.secondView.frame = CGRectMake(0, m_dateView.frame.size.height+50+13, kScreenWidth, CGRectGetHeight(self.frame)-(m_dateView.frame.size.height+50+13));
//    self.secondView.frame = CGRectMake(0, m_dateView.frame.size.height+50+13, kScreenWidth,  CGRectGetHeight(self.frame)-( width/7.0+50+13));
     NSLog(@"$%f$",self.secondView.frame.size.height);
    m_dateView.frame = CGRectMake(originFram.origin.x, 0, originFram.size.width, originFram.size.height);
    _dateMaskView.frame = CGRectMake(0, 50, kScreenWidth, m_dateView.frame.size.height);
    [UIView commitAnimations];
    self.downBut.hidden = YES;
    self.isOpen = NO;
    _holidayList.frame = CGRectMake(0, 20, kScreenWidth, CGRectGetHeight(self.secondView.frame)-20);
}

-(void)upButAction:(UIButton *)sender
{
    int t_first = [self _getFirstDayOfMonth:m_currentDate];
    CGRect originFram = m_dateView.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
//    self.secondView.frame = CGRectMake(0, width/7.0+50+13, kScreenWidth, CGRectGetHeight(self.frame)-(m_dateView.frame.size.height+50+13));
    self.secondView.frame = CGRectMake(0, width/7.0+50+13, kScreenWidth, CGRectGetHeight(self.frame)-( width/7.0+50+13));
    if (m_today.year == m_currentDate.year && m_today.month == m_currentDate.month) {
        int num = (m_today.day+t_first)/7;
        if((m_today.day+t_first)%7!=0)
        {
            num+=1;
        }
        m_dateView.frame = CGRectMake(0, originFram.origin.y-m_todayCell.frame.size.height*(num-1), originFram.size.width, originFram.size.height);
        //        m_dateView.frame = CGRectMake(originFram.origin.x, originFram.origin.y- m_todayCell.frame.size.height, originFram.size.width, originFram.size.height);
    }
    else
    {
        m_dateView.frame = CGRectMake(originFram.origin.x, 0, originFram.size.width, originFram.size.height);
    }
    _dateMaskView.frame = CGRectMake(0, 50, kScreenWidth, kScreenWidth/7.0);
    [UIView commitAnimations];
    self.downBut.hidden = NO;
    self.isOpen = YES;
    _holidayList.frame = CGRectMake(0, 20, kScreenWidth, CGRectGetHeight(self.secondView.frame)-20);
}


#pragma mark -tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSMutableArray *marr=[[setting sharedSetting].memodic objectForKey:self.menoday];
    if (marr.count>0) {
        for (int i=0; i<marr.count; i++) {
            NSString *cont=[[marr objectAtIndex:i]objectForKey:self.menoday];
            if (cont.length>0) {
                return 4;
            }
        }
        }
//    if (marr.count>0) {
//        return 4;
//    }
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *marr=[[setting sharedSetting].memodic objectForKey:self.menoday];
//    if (section==0) {
//        return 1;
//    }
    
    if (section==0) {
        if (self.memos.count>0) {
//            [self.memos removeAllObjects];
//            for (int i=0; i<marr.count; i++) {
//                NSString *cont=[[marr objectAtIndex:i]objectForKey:self.menoday];
//                if (cont.length>0) {
//                    [self.memos addObject:cont];
//                }
//            }
            return self.memos.count;
        }
        return 1;
    }
    if (section==1) {
        return 1;
    }
    if (section==2) {
        return 1;
    }
    if (section==3) {
        return 1;
    }
    return self.holidayDatas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableArray *marr=[[setting sharedSetting].memodic objectForKey:self.menoday];
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.section==0) {
        if (self.memos.count>0) {
            return cell.frame.size.height+5;
        }
        return 120;
    }if (indexPath.section==1) {
        if (self.memos.count>0) {
            return 120;
        }
        return 40;
    }
    if (indexPath.section==2) {
        if (self.memos.count>0) {
            return 40;
        }
        return 230;
    }
    if (indexPath.section==3) {
        return 230;
    }
//    NSDictionary * dic = [self.holidayDatas objectAtIndex:indexPath.row];
//    NSString * type =[dic objectForKey:@"type"];
//    if([type isEqualToString:@"0"])
//    {
//        return cell.frame.size.height;
//    }
//    if([type isEqualToString:@"1"])
//    {
//        return 120;
//    }
//    if([type isEqualToString:@"2"])
//    {
//        return 30;
//    }
//    if([type isEqualToString:@"3"])
//    {
//        return 230;
//    }
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSString *t_str = [NSString stringWithFormat:@"%d_%d", section, row];
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:t_str];
    if (cell != nil)
        [cell removeFromSuperview];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];

    NSArray *marr=[[self.memos reverseObjectEnumerator]allObjects];
    if (section==0) {
        if (self.memos.count>0) {
//            NSDictionary *dic=self.memos[row];
            NSString *cont=marr[row];
            if (cont.length>0) {
                UIImageView *pointimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-10, 30)];
                pointimg.image=[UIImage imageNamed:@"添加新事件底座"];
                pointimg.userInteractionEnabled=YES;
                [cell addSubview:pointimg];
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth-30, 30)];
                lab.text=cont;
                lab.textColor=[UIColor blackColor];
                lab.numberOfLines=0;
                lab.font=[UIFont systemFontOfSize:13];
                [pointimg addSubview:lab];
                [lab sizeToFit];
                CGRect cellFrame = [cell frame];
                cellFrame.origin = CGPointMake(0, 0);
                float lab_h=[lab labelheight:cont withFont:[UIFont systemFontOfSize:13]];
                lab.frame=CGRectMake(30, 0, kScreenWidth-30, lab_h+20);
                pointimg.frame=CGRectMake(5, 0, kScreenWidth-10, lab.frame.size.height);
                cellFrame.size.height=lab.frame.size.height;
                [cell setFrame:cellFrame];
                UIButton *closebtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-35, 5, 20, 20)];
                closebtn.tag=indexPath.row;
                closebtn.center=CGPointMake(kScreenWidth-35, pointimg.center.y);
                [closebtn setBackgroundImage:[UIImage imageNamed:@"banner清除二态"] forState:UIControlStateNormal];
                //                [closebtn setBackgroundImage:[UIImage imageNamed:@"删除点击"] forState:UIControlStateHighlighted];
                [closebtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
                [pointimg addSubview:closebtn];
            }
        }else{
            UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
            bgimg.backgroundColor=[UIColor colorHelpWithRed:236 green:236 blue:236 alpha:1];
            bgimg.userInteractionEnabled=YES;
            [cell addSubview:bgimg];
            UILabel *tlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth, 30)];
            tlab.text=@"你出生那天，风和日丽亦或是细雨绵绵？问问小知吧！";
            tlab.font=[UIFont systemFontOfSize:12];
            tlab.textAlignment=NSTextAlignmentLeft;
            [bgimg addSubview:tlab];
            
            UIImageView *bimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 100, 80)];
            bimg.image=[UIImage imageNamed:@"天气与命运"];
            bimg.userInteractionEnabled=YES;
            [bgimg addSubview:bimg];
            
            self.yearbtn=[[UIButton alloc]initWithFrame:CGRectMake(self.width-225, 35, 60, 25)];
            [self.yearbtn setBackgroundColor:[UIColor whiteColor]];
            self.yearbtn.tag=1001;
            [self.yearbtn setTitle:yearstr forState:UIControlStateNormal];
            [self.yearbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.yearbtn addTarget:self action:@selector(timePicker:) forControlEvents:UIControlEventTouchUpInside];
            [bgimg addSubview:self.yearbtn];
            self.monthbtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.yearbtn.frame)+15, 35, 50, 25)];
            [self.monthbtn setBackgroundColor:[UIColor whiteColor]];
            self.monthbtn.tag=1002;
            [self.monthbtn setTitle:monthstr forState:UIControlStateNormal];
            [self.monthbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.monthbtn addTarget:self action:@selector(timePicker:) forControlEvents:UIControlEventTouchUpInside];
            [bgimg addSubview:self.monthbtn];
            self.daybtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.monthbtn.frame)+15, 35, 50, 25)];
            [self.daybtn setBackgroundColor:[UIColor whiteColor]];
            self.daybtn.tag=1003;
            [self.daybtn setTitle:daystr forState:UIControlStateNormal];
            [self.daybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.daybtn addTarget:self action:@selector(timePicker:) forControlEvents:UIControlEventTouchUpInside];
            [bgimg addSubview:self.daybtn];
            self.yearbtn.titleLabel.font=[UIFont systemFontOfSize:15];
            self.monthbtn.titleLabel.font=[UIFont systemFontOfSize:15];
            self.daybtn.titleLabel.font=[UIFont systemFontOfSize:15];
            
            
            UILabel *ylab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.yearbtn.frame), 35, 15, 25)];
            ylab.text=@"年";
            ylab.font=[UIFont systemFontOfSize:14];
            [bgimg addSubview:ylab];
            
            UILabel *mlab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.monthbtn.frame), 35, 15, 25)];
            mlab.text=@"月";
            mlab.font=[UIFont systemFontOfSize:14];
            [bgimg addSubview:mlab];
            
            UILabel *dlab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.daybtn.frame), 35, 15, 25)];
            dlab.text=@"日";
            dlab.font=[UIFont systemFontOfSize:14];
            [bgimg addSubview:dlab];
            
            UIButton *citybtn=[[UIButton alloc]initWithFrame:CGRectMake(self.width-225, 65, 125, 25)];
            [citybtn setBackgroundColor:[UIColor whiteColor]];
            [citybtn setTitle:@"填写出生地区" forState:UIControlStateNormal];
            [citybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            citybtn.titleLabel.font=[UIFont systemFontOfSize:14];
            [citybtn addTarget:self action:@selector(addcity) forControlEvents:UIControlEventTouchUpInside];
            [bgimg addSubview:citybtn];
            
            if (city.length>0) {
                [citybtn setTitle:city forState:UIControlStateNormal];
            }
            UIButton *findbtn=[[UIButton alloc]initWithFrame:CGRectMake(self.width-80, 65, 60, 25)];
            [findbtn setBackgroundImage:[UIImage imageNamed:@"查询"] forState:UIControlStateNormal];
            [findbtn setTitle:@"查询" forState:UIControlStateNormal];
            [findbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            findbtn.titleLabel.font=[UIFont systemFontOfSize:14];
            [findbtn addTarget:self action:@selector(find) forControlEvents:UIControlEventTouchUpInside];
            [bgimg addSubview:findbtn];
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(self.width-225, 90, 200, 25)];
            lab.text=@"限福建地区1966~2014年间";
            lab.font=[UIFont systemFontOfSize:13];
            lab.textColor=[UIColor orangeColor];
            [bgimg addSubview:lab];
            
            }
    }
        if (section==1) {
            if (self.memos.count>0) {
                UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
                bgimg.backgroundColor=[UIColor colorHelpWithRed:236 green:236 blue:236 alpha:1];
                bgimg.userInteractionEnabled=YES;
                [cell addSubview:bgimg];
                UILabel *tlab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
                tlab.text=@"你出生那天，风和日丽亦或是细雨绵绵？问问小知吧！";
                tlab.font=[UIFont systemFontOfSize:12];
                tlab.textAlignment=NSTextAlignmentCenter;
                [bgimg addSubview:tlab];
                
                UIImageView *bimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 80, 80)];
                bimg.image=[UIImage imageNamed:@"天气与命运"];
                bimg.userInteractionEnabled=YES;
                [bgimg addSubview:bimg];
                
                self.yearbtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 35, 60, 25)];
                [self.yearbtn setBackgroundColor:[UIColor whiteColor]];
                self.yearbtn.tag=1001;
                [self.yearbtn setTitle:yearstr forState:UIControlStateNormal];
                [self.yearbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.yearbtn addTarget:self action:@selector(timePicker:) forControlEvents:UIControlEventTouchUpInside];
                [bgimg addSubview:self.yearbtn];
                self.monthbtn=[[UIButton alloc]initWithFrame:CGRectMake(175, 35, 50, 25)];
                [self.monthbtn setBackgroundColor:[UIColor whiteColor]];
                self.monthbtn.tag=1002;
                [self.monthbtn setTitle:monthstr forState:UIControlStateNormal];
                [self.monthbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.monthbtn addTarget:self action:@selector(timePicker:) forControlEvents:UIControlEventTouchUpInside];
                [bgimg addSubview:self.monthbtn];
                self.daybtn=[[UIButton alloc]initWithFrame:CGRectMake(240, 35, 50, 25)];
                [self.daybtn setBackgroundColor:[UIColor whiteColor]];
                self.daybtn.tag=1003;
                [self.daybtn setTitle:daystr forState:UIControlStateNormal];
                [self.daybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.daybtn addTarget:self action:@selector(timePicker:) forControlEvents:UIControlEventTouchUpInside];
                [bgimg addSubview:self.daybtn];
                self.yearbtn.titleLabel.font=[UIFont systemFontOfSize:15];
                self.monthbtn.titleLabel.font=[UIFont systemFontOfSize:15];
                self.daybtn.titleLabel.font=[UIFont systemFontOfSize:15];

                UILabel *ylab=[[UILabel alloc]initWithFrame:CGRectMake(160, 35, 15, 25)];
                ylab.text=@"年";
                ylab.font=[UIFont systemFontOfSize:14];
                [bgimg addSubview:ylab];
         
                UILabel *mlab=[[UILabel alloc]initWithFrame:CGRectMake(225, 35, 15, 25)];
                mlab.text=@"月";
                mlab.font=[UIFont systemFontOfSize:14];
                [bgimg addSubview:mlab];
        
                UILabel *dlab=[[UILabel alloc]initWithFrame:CGRectMake(290, 35, 15, 25)];
                dlab.text=@"日";
                dlab.font=[UIFont systemFontOfSize:14];
                [bgimg addSubview:dlab];
                
                UIButton *citybtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 65, 115, 25)];
                [citybtn setBackgroundColor:[UIColor whiteColor]];
                [citybtn setTitle:@"填写出生地区" forState:UIControlStateNormal];
                [citybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                citybtn.titleLabel.font=[UIFont systemFontOfSize:14];
                [citybtn addTarget:self action:@selector(addcity) forControlEvents:UIControlEventTouchUpInside];
                [bgimg addSubview:citybtn];
                
                if (city.length>0) {
                    [citybtn setTitle:city forState:UIControlStateNormal];
                }
                UIButton *findbtn=[[UIButton alloc]initWithFrame:CGRectMake(225, 65, 60, 25)];
                [findbtn setBackgroundImage:[UIImage imageNamed:@"查询"] forState:UIControlStateNormal];
                [findbtn setTitle:@"查询" forState:UIControlStateNormal];
                [findbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                findbtn.titleLabel.font=[UIFont systemFontOfSize:14];
                [findbtn addTarget:self action:@selector(find) forControlEvents:UIControlEventTouchUpInside];
                [bgimg addSubview:findbtn];
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(100, 90, 200, 25)];
                lab.text=@"限福建地区1966~2014年间";
                lab.font=[UIFont systemFontOfSize:12];
                lab.textColor=[UIColor orangeColor];
                [bgimg addSubview:lab];
                
            }else{
                NSDictionary * dic = self.nldic;
                NSString * type =[dic objectForKey:@"type"];
                NSDictionary * infoDic = [dic objectForKey:@"info"];
                NSString * dayStr = [infoDic objectForKey:@"day"];
                UILabel * dayLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, kScreenWidth-50, 20)];
                dayLab.backgroundColor = [UIColor clearColor];
                dayLab.textColor = [UIColor blackColor];
                dayLab.textAlignment = NSTextAlignmentLeft;
                dayLab.font = [UIFont systemFontOfSize:18];
                dayLab.text=dayStr;
                [cell addSubview:dayLab];
                
                
            }
            
        }
        if (section==2) {
            if (self.memos.count>0) {
                NSDictionary * dic = self.nldic;
                NSString * type =[dic objectForKey:@"type"];
                NSDictionary * infoDic = [dic objectForKey:@"info"];
                NSString * dayStr = [infoDic objectForKey:@"day"];
                UILabel * dayLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, kScreenWidth-50, 20)];
                dayLab.backgroundColor = [UIColor clearColor];
                dayLab.textColor = [UIColor blackColor];
                dayLab.textAlignment = NSTextAlignmentLeft;
                dayLab.font = [UIFont systemFontOfSize:18];
                dayLab.text=dayStr;
                [cell addSubview:dayLab];
            }else{
            NSDictionary * dic = self.hldic;
            NSDictionary * infoDic = [dic objectForKey:@"info"];
            NSString * yiStr = [infoDic objectForKey:@"yi"];
            NSString * jiStr = [infoDic objectForKey:@"ji"];
            NSString * chongStr = [infoDic objectForKey:@"chong"];
            NSString * zhishenStr = [infoDic objectForKey:@"zhishen"];
            NSString * pengzubaijiStr = [infoDic objectForKey:@"pengzubaiji"];
            NSString * xinsuweifangStr = [infoDic objectForKey:@"xinsuweifang"];
            NSString * taishenzhanfangStr = [infoDic objectForKey:@"taishenzhanfang"];
            UIImageView *yi=[[UIImageView alloc]initWithFrame:CGRectMake(55, 10, 20, 20)];
            yi.image=[UIImage imageNamed:@"宜"];
            [cell addSubview:yi];
            
            UILabel * yiLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 20)];
            yiLab.tag = 1;
            yiLab.backgroundColor = [UIColor clearColor];
            yiLab.textColor = [UIColor blackColor];
            yiLab.textAlignment = NSTextAlignmentLeft;
            yiLab.font = [UIFont systemFontOfSize:15];
            [cell addSubview:yiLab];
            
            
            
            UIImageView *ji=[[UIImageView alloc]initWithFrame:CGRectMake(55, 40, 20, 20)];
            ji.image=[UIImage imageNamed:@"忌"];
            [cell addSubview:ji];
            
            UILabel * jiLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 40, 200, 20)];
            jiLab.tag = 2;
            jiLab.backgroundColor = [UIColor clearColor];
            jiLab.textColor = [UIColor blackColor];
            jiLab.textAlignment = NSTextAlignmentLeft;
            jiLab.font = [UIFont systemFontOfSize:15];
            [cell addSubview:jiLab];
            
            
            UIImageView *chong=[[UIImageView alloc]initWithFrame:CGRectMake(55, 70, 20, 20)];
            chong.image=[UIImage imageNamed:@"冲"];
            [cell addSubview:chong];
            
            UILabel * chongLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, 200, 20)];
            chongLab.tag = 3;
            chongLab.backgroundColor = [UIColor clearColor];
            chongLab.textColor = [UIColor blackColor];
            chongLab.textAlignment = NSTextAlignmentLeft;
            chongLab.font = [UIFont systemFontOfSize:15];
            [cell addSubview:chongLab];
            
            
            
            UIImageView *zhishen=[[UIImageView alloc]initWithFrame:CGRectMake(28, 100, 70, 23)];
            zhishen.image=[UIImage imageNamed:@"值神"];
            [cell addSubview:zhishen];
            
            UILabel * zhishenLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 200, 20)];
            zhishenLab.tag = 4;
            zhishenLab.backgroundColor = [UIColor clearColor];
            zhishenLab.textColor = [UIColor blackColor];
            zhishenLab.textAlignment = NSTextAlignmentLeft;
            zhishenLab.font = [UIFont systemFontOfSize:15];
            [cell addSubview:zhishenLab];
            
            
            UIImageView *baiji=[[UIImageView alloc]initWithFrame:CGRectMake(28, 130, 70, 23)];
            baiji.image=[UIImage imageNamed:@"彭祖百忌"];
            [cell addSubview:baiji];
            
            UILabel * pengzubaijiLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 130, 200, 20)];
            pengzubaijiLab.tag = 5;
            pengzubaijiLab.backgroundColor = [UIColor clearColor];
            pengzubaijiLab.textColor = [UIColor blackColor];
            pengzubaijiLab.textAlignment = NSTextAlignmentLeft;
            pengzubaijiLab.font = [UIFont systemFontOfSize:15];
            [cell addSubview:pengzubaijiLab];
            
            
            
            UIImageView *xingsu=[[UIImageView alloc]initWithFrame:CGRectMake(28, 160, 70, 23)];
            xingsu.image=[UIImage imageNamed:@"星宿占方"];
            [cell addSubview:xingsu];
            
            UILabel * xinsuweifangLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 160, 200, 20)];
            xinsuweifangLab.tag = 6;
            xinsuweifangLab.backgroundColor = [UIColor clearColor];
            xinsuweifangLab.textColor = [UIColor blackColor];
            xinsuweifangLab.textAlignment = NSTextAlignmentLeft;
            xinsuweifangLab.font = [UIFont systemFontOfSize:15];
            [cell addSubview:xinsuweifangLab];
            
            
            UIImageView *taishen=[[UIImageView alloc]initWithFrame:CGRectMake(28, 190, 70, 23)];
            taishen.image=[UIImage imageNamed:@"胎神占方"];
            [cell addSubview:taishen];
            
            UILabel * taishenzhanfangLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 190, 200, 20)];
            taishenzhanfangLab.tag = 7;
            taishenzhanfangLab.backgroundColor = [UIColor clearColor];
            taishenzhanfangLab.textColor = [UIColor blackColor];
            taishenzhanfangLab.textAlignment = NSTextAlignmentLeft;
            taishenzhanfangLab.font = [UIFont systemFontOfSize:15];
            [cell addSubview:taishenzhanfangLab];
            yiLab.text = yiStr;
            jiLab.text = jiStr;
            chongLab.text = chongStr;
            zhishenLab.text = zhishenStr;
            pengzubaijiLab.text = pengzubaijiStr;
            xinsuweifangLab.text = xinsuweifangStr;
                taishenzhanfangLab.text = taishenzhanfangStr;
            
            }
        }
    if (section==3) {
        NSDictionary * dic = self.hldic;
        NSDictionary * infoDic = [dic objectForKey:@"info"];
        NSString * yiStr = [infoDic objectForKey:@"yi"];
        NSString * jiStr = [infoDic objectForKey:@"ji"];
        NSString * chongStr = [infoDic objectForKey:@"chong"];
        NSString * zhishenStr = [infoDic objectForKey:@"zhishen"];
        NSString * pengzubaijiStr = [infoDic objectForKey:@"pengzubaiji"];
        NSString * xinsuweifangStr = [infoDic objectForKey:@"xinsuweifang"];
        NSString * taishenzhanfangStr = [infoDic objectForKey:@"taishenzhanfang"];
        UIImageView *yi=[[UIImageView alloc]initWithFrame:CGRectMake(55, 10, 20, 20)];
        yi.image=[UIImage imageNamed:@"宜"];
        [cell addSubview:yi];
        
        UILabel * yiLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 20)];
        yiLab.tag = 1;
        yiLab.backgroundColor = [UIColor clearColor];
        yiLab.textColor = [UIColor blackColor];
        yiLab.textAlignment = NSTextAlignmentLeft;
        yiLab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:yiLab];
        
        
        
        UIImageView *ji=[[UIImageView alloc]initWithFrame:CGRectMake(55, 40, 20, 20)];
        ji.image=[UIImage imageNamed:@"忌"];
        [cell addSubview:ji];
        
        UILabel * jiLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 40, 200, 20)];
        jiLab.tag = 2;
        jiLab.backgroundColor = [UIColor clearColor];
        jiLab.textColor = [UIColor blackColor];
        jiLab.textAlignment = NSTextAlignmentLeft;
        jiLab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:jiLab];
        
        
        UIImageView *chong=[[UIImageView alloc]initWithFrame:CGRectMake(55, 70, 20, 20)];
        chong.image=[UIImage imageNamed:@"冲"];
        [cell addSubview:chong];
        
        UILabel * chongLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, 200, 20)];
        chongLab.tag = 3;
        chongLab.backgroundColor = [UIColor clearColor];
        chongLab.textColor = [UIColor blackColor];
        chongLab.textAlignment = NSTextAlignmentLeft;
        chongLab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:chongLab];
        
        
        
        UIImageView *zhishen=[[UIImageView alloc]initWithFrame:CGRectMake(28, 100, 70, 23)];
        zhishen.image=[UIImage imageNamed:@"值神"];
        [cell addSubview:zhishen];
        
        UILabel * zhishenLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 200, 20)];
        zhishenLab.tag = 4;
        zhishenLab.backgroundColor = [UIColor clearColor];
        zhishenLab.textColor = [UIColor blackColor];
        zhishenLab.textAlignment = NSTextAlignmentLeft;
        zhishenLab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:zhishenLab];
        
        
        UIImageView *baiji=[[UIImageView alloc]initWithFrame:CGRectMake(28, 130, 70, 23)];
        baiji.image=[UIImage imageNamed:@"彭祖百忌"];
        [cell addSubview:baiji];
        
        UILabel * pengzubaijiLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 130, 200, 20)];
        pengzubaijiLab.tag = 5;
        pengzubaijiLab.backgroundColor = [UIColor clearColor];
        pengzubaijiLab.textColor = [UIColor blackColor];
        pengzubaijiLab.textAlignment = NSTextAlignmentLeft;
        pengzubaijiLab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:pengzubaijiLab];
        
        
        
        UIImageView *xingsu=[[UIImageView alloc]initWithFrame:CGRectMake(28, 160, 70, 23)];
        xingsu.image=[UIImage imageNamed:@"星宿占方"];
        [cell addSubview:xingsu];
        
        UILabel * xinsuweifangLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 160, 200, 20)];
        xinsuweifangLab.tag = 6;
        xinsuweifangLab.backgroundColor = [UIColor clearColor];
        xinsuweifangLab.textColor = [UIColor blackColor];
        xinsuweifangLab.textAlignment = NSTextAlignmentLeft;
        xinsuweifangLab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:xinsuweifangLab];
        
        
        UIImageView *taishen=[[UIImageView alloc]initWithFrame:CGRectMake(28, 190, 70, 23)];
        taishen.image=[UIImage imageNamed:@"胎神占方"];
        [cell addSubview:taishen];
        
        UILabel * taishenzhanfangLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 190, 200, 20)];
        taishenzhanfangLab.tag = 7;
        taishenzhanfangLab.backgroundColor = [UIColor clearColor];
        taishenzhanfangLab.textColor = [UIColor blackColor];
        taishenzhanfangLab.textAlignment = NSTextAlignmentLeft;
        taishenzhanfangLab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:taishenzhanfangLab];
        yiLab.text = yiStr;
        jiLab.text = jiStr;
        chongLab.text = chongStr;
        zhishenLab.text = zhishenStr;
        pengzubaijiLab.text = pengzubaijiStr;
        xinsuweifangLab.text = xinsuweifangStr;
        taishenzhanfangLab.text = taishenzhanfangStr;
    }
        return cell;
    

//    NSDictionary * dic = [self.holidayDatas objectAtIndex:indexPath.row];
//    NSString * type =[dic objectForKey:@"type"];
//    NSDictionary * infoDic = [dic objectForKey:@"info"];
//    if ([type isEqualToString:@"0"]) {
//
//        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:t_str];
//        if (cell != nil)
//            [cell removeFromSuperview];
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor=[UIColor clearColor];
//        
//        CGRect cellFrame = [cell frame];
//        cellFrame.origin = CGPointMake(0, 0);
//        
//        cellFrame.size.height = 40;
//        
//        NSArray *arr=[dic objectForKey:@"content"];
//        for (int i=0; i<arr.count; i++) {
//            NSString *cont=arr[i];
//            if (cont.length>0) {
//                UIImageView *pointimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 30*i, kScreenWidth-10, 30)];
//                pointimg.image=[UIImage imageNamed:@"添加新事件底座"];
//                [cell addSubview:pointimg];
//                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(30, 30*i, kScreenWidth-40, 30)];
//                lab.text=cont;
//                lab.textColor=[UIColor blackColor];
//                lab.numberOfLines=0;
//                lab.font=[UIFont systemFontOfSize:13];
//                [pointimg addSubview:lab];
//                UIButton *closebtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-35, 10+20*i, 20, 20)];
//                closebtn.tag=indexPath.row;
//                [closebtn setBackgroundImage:[UIImage imageNamed:@"banner清除二态"] forState:UIControlStateNormal];
////                [closebtn setBackgroundImage:[UIImage imageNamed:@"删除点击"] forState:UIControlStateHighlighted];
//                [closebtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
//                [pointimg addSubview:closebtn];
//            }
//        }
//         cellFrame.size.height=arr.count*40;
//        return cell;
//    }
//    
//    if([type isEqualToString:@"1"])
//    {
//        
//        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:t_str];
//        if (cell != nil)
//            [cell removeFromSuperview];
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor=[UIColor clearColor];
//        
//        
//        UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
//        bgimg.backgroundColor=[UIColor colorHelpWithRed:236 green:236 blue:236 alpha:1];
//        bgimg.userInteractionEnabled=YES;
//        [cell addSubview:bgimg];
//        UILabel *tlab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
//        tlab.text=@"你出生那天，风和日丽亦或是细雨绵绵？问问小知吧！";
//        tlab.font=[UIFont systemFontOfSize:12];
//        tlab.textAlignment=NSTextAlignmentCenter;
//        [bgimg addSubview:tlab];
//        
//        UIImageView *bimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 90)];
//        bimg.image=[UIImage imageNamed:@"生日底框"];
//        bimg.userInteractionEnabled=YES;
//        [bgimg addSubview:bimg];
//        
//        
//        
//        return cell;
//    }
//    else
//    {
//        NSString * dayStr = [infoDic objectForKey:@"day"];
//        if([type isEqualToString:@"2"])
//        {
//            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"type2"];
//            if(cell == nil)
//            {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"type2"];
//                UILabel * dayLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, kScreenWidth-50, 20)];
//                dayLab.tag = 1;
//                dayLab.backgroundColor = [UIColor clearColor];
//                dayLab.textColor = [UIColor blackColor];
//                dayLab.textAlignment = NSTextAlignmentLeft;
//                dayLab.font = [UIFont systemFontOfSize:18];
//                [cell.contentView addSubview:dayLab];
//            }
//            UILabel * dayLab = (UILabel *)[cell.contentView viewWithTag:1];
//            dayLab.text = dayStr;
//            return cell;
//        }
//        else
//        {
//            NSString * yiStr = [infoDic objectForKey:@"yi"];
//            NSString * jiStr = [infoDic objectForKey:@"ji"];
//            NSString * chongStr = [infoDic objectForKey:@"chong"];
//            NSString * zhishenStr = [infoDic objectForKey:@"zhishen"];
//            NSString * pengzubaijiStr = [infoDic objectForKey:@"pengzubaiji"];
//            NSString * xinsuweifangStr = [infoDic objectForKey:@"xinsuweifang"];
//            NSString * taishenzhanfangStr = [infoDic objectForKey:@"taishenzhanfang"];
//            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"type3"];
//            if(cell == nil)
//            {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"type3"];
////                UILabel * yiTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 80, 15)];
////                yiTitleLab.text = @"宜";
////                yiTitleLab.backgroundColor = [UIColor clearColor];
////                yiTitleLab.textColor = [UIColor grayColor];
////                yiTitleLab.textAlignment = NSTextAlignmentLeft;
////                yiTitleLab.font = [UIFont fontWithName:kBaseFont size:18];
////                [cell.contentView addSubview:yiTitleLab];
//                UIImageView *yi=[[UIImageView alloc]initWithFrame:CGRectMake(55, 10, 20, 20)];
//                yi.image=[UIImage imageNamed:@"宜"];
//                [cell addSubview:yi];
//                
//                UILabel * yiLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 15)];
//                yiLab.tag = 1;
//                yiLab.backgroundColor = [UIColor clearColor];
//                yiLab.textColor = [UIColor blackColor];
//                yiLab.textAlignment = NSTextAlignmentLeft;
//                yiLab.font = [UIFont systemFontOfSize:15];
//                [cell.contentView addSubview:yiLab];
//                
//                
////                UILabel * jiTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 45, 80, 15)];
////                jiTitleLab.backgroundColor = [UIColor clearColor];
////                jiTitleLab.text = @"忌";
////                jiTitleLab.textColor = [UIColor grayColor];
////                jiTitleLab.textAlignment = NSTextAlignmentLeft;
////                jiTitleLab.font = [UIFont fontWithName:kBaseFont size:18];
////                [cell.contentView addSubview:jiTitleLab];
//                
//                UIImageView *ji=[[UIImageView alloc]initWithFrame:CGRectMake(55, 45, 20, 20)];
//                ji.image=[UIImage imageNamed:@"忌"];
//                [cell addSubview:ji];
//                
//                UILabel * jiLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 45, 200, 15)];
//                jiLab.tag = 2;
//                jiLab.backgroundColor = [UIColor clearColor];
//                jiLab.textColor = [UIColor blackColor];
//                jiLab.textAlignment = NSTextAlignmentLeft;
//                jiLab.font = [UIFont systemFontOfSize:15];
//                [cell.contentView addSubview:jiLab];
//                
////                UILabel * chongTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 70, 80, 15)];
////                chongTitleLab.backgroundColor = [UIColor clearColor];
////                chongTitleLab.text = @"冲";
////                chongTitleLab.textColor = [UIColor grayColor];
////                chongTitleLab.textAlignment = NSTextAlignmentLeft;
////                chongTitleLab.font = [UIFont fontWithName:kBaseFont size:18];
////                [cell.contentView addSubview:chongTitleLab];
//                
//                UIImageView *chong=[[UIImageView alloc]initWithFrame:CGRectMake(55, 70, 20, 20)];
//                chong.image=[UIImage imageNamed:@"冲"];
//                [cell addSubview:chong];
//                
//                UILabel * chongLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, 200, 15)];
//                chongLab.tag = 3;
//                chongLab.backgroundColor = [UIColor clearColor];
//                chongLab.textColor = [UIColor blackColor];
//                chongLab.textAlignment = NSTextAlignmentLeft;
//                chongLab.font = [UIFont systemFontOfSize:15];
//                [cell.contentView addSubview:chongLab];
//                
////                UILabel * zhishenTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 95, 80, 15)];
////                zhishenTitleLab.backgroundColor = [UIColor clearColor];
////                zhishenTitleLab.text = @"值神";
////                zhishenTitleLab.textColor = [UIColor grayColor];
////                zhishenTitleLab.textAlignment = NSTextAlignmentLeft;
////                zhishenTitleLab.font = [UIFont fontWithName:kBaseFont size:18];
////                [cell.contentView addSubview:zhishenTitleLab];
//                
//                UIImageView *zhishen=[[UIImageView alloc]initWithFrame:CGRectMake(28, 95, 70, 23)];
//                zhishen.image=[UIImage imageNamed:@"值神"];
//                [cell addSubview:zhishen];
//                
//                UILabel * zhishenLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 95, 200, 25)];
//                zhishenLab.tag = 4;
//                zhishenLab.backgroundColor = [UIColor clearColor];
//                zhishenLab.textColor = [UIColor blackColor];
//                zhishenLab.textAlignment = NSTextAlignmentLeft;
//                zhishenLab.font = [UIFont systemFontOfSize:15];
//                [cell.contentView addSubview:zhishenLab];
//                
////                UILabel * pengzubaijiTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 120, 80, 15)];
////                pengzubaijiTitleLab.backgroundColor = [UIColor clearColor];
////                pengzubaijiTitleLab.text = @"彭祖白忌";
////                pengzubaijiTitleLab.textColor = [UIColor grayColor];
////                pengzubaijiTitleLab.textAlignment = NSTextAlignmentLeft;
////                pengzubaijiTitleLab.font = [UIFont fontWithName:kBaseFont size:18];
////                [cell.contentView addSubview:pengzubaijiTitleLab];
//                
//                UIImageView *baiji=[[UIImageView alloc]initWithFrame:CGRectMake(28, 130, 70, 23)];
//                baiji.image=[UIImage imageNamed:@"彭祖百忌"];
//                [cell addSubview:baiji];
//                
//                UILabel * pengzubaijiLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 130, 200, 25)];
//                pengzubaijiLab.tag = 5;
//                pengzubaijiLab.backgroundColor = [UIColor clearColor];
//                pengzubaijiLab.textColor = [UIColor blackColor];
//                pengzubaijiLab.textAlignment = NSTextAlignmentLeft;
//                pengzubaijiLab.font = [UIFont systemFontOfSize:15];
//                [cell.contentView addSubview:pengzubaijiLab];
//                
////                UILabel * xinsuweifangTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 145, 80, 15)];
////                xinsuweifangTitleLab.backgroundColor = [UIColor clearColor];
////                xinsuweifangTitleLab.text = @"心宿位方";
////                xinsuweifangTitleLab.textColor = [UIColor grayColor];
////                xinsuweifangTitleLab.textAlignment = NSTextAlignmentLeft;
////                xinsuweifangTitleLab.font = [UIFont fontWithName:kBaseFont size:18];
////                [cell.contentView addSubview:xinsuweifangTitleLab];
//                
//                UIImageView *xingsu=[[UIImageView alloc]initWithFrame:CGRectMake(28, 165, 70, 23)];
//                xingsu.image=[UIImage imageNamed:@"星宿占方"];
//                [cell addSubview:xingsu];
//                
//                UILabel * xinsuweifangLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 165, 200, 25)];
//                xinsuweifangLab.tag = 6;
//                xinsuweifangLab.backgroundColor = [UIColor clearColor];
//                xinsuweifangLab.textColor = [UIColor blackColor];
//                xinsuweifangLab.textAlignment = NSTextAlignmentLeft;
//                xinsuweifangLab.font = [UIFont systemFontOfSize:15];
//                [cell.contentView addSubview:xinsuweifangLab];
//                
////                UILabel * taishenzhanfangTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 170, 80, 15)];
////                taishenzhanfangTitleLab.backgroundColor = [UIColor clearColor];
////                taishenzhanfangTitleLab.text = @"胎神占方";
////                taishenzhanfangTitleLab.textColor = [UIColor grayColor];
////                taishenzhanfangTitleLab.textAlignment = NSTextAlignmentLeft;
////                taishenzhanfangTitleLab.font = [UIFont fontWithName:kBaseFont size:18];
////                [cell.contentView addSubview:taishenzhanfangTitleLab];
//                
//                UIImageView *taishen=[[UIImageView alloc]initWithFrame:CGRectMake(28, 200, 70, 23)];
//                taishen.image=[UIImage imageNamed:@"胎神占方"];
//                [cell addSubview:taishen];
//                
//                UILabel * taishenzhanfangLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 200, 200, 25)];
//                taishenzhanfangLab.tag = 7;
//                taishenzhanfangLab.backgroundColor = [UIColor clearColor];
//                taishenzhanfangLab.textColor = [UIColor blackColor];
//                taishenzhanfangLab.textAlignment = NSTextAlignmentLeft;
//                taishenzhanfangLab.font = [UIFont systemFontOfSize:15];
//                [cell.contentView addSubview:taishenzhanfangLab];
//            }
//            UILabel * yiLab = (UILabel *)[cell.contentView viewWithTag:1];
//            UILabel * jiLab = (UILabel *)[cell.contentView viewWithTag:2];
//            UILabel * chongLab = (UILabel *)[cell.contentView viewWithTag:3];
//            UILabel * zhishenLab = (UILabel *)[cell.contentView viewWithTag:4];
//            UILabel * pengzubaijiLab = (UILabel *)[cell.contentView viewWithTag:5];
//            UILabel * xinsuweifangLab = (UILabel *)[cell.contentView viewWithTag:6];
//            UILabel * taishenzhanfangLab = (UILabel *)[cell.contentView viewWithTag:7];
//            yiLab.text = yiStr;
//            jiLab.text = jiStr;
//            chongLab.text = chongStr;
//            zhishenLab.text = zhishenStr;
//            pengzubaijiLab.text = pengzubaijiStr;
//            xinsuweifangLab.text = xinsuweifangStr;
//            taishenzhanfangLab.text = taishenzhanfangStr;
//            return cell;
//        }
//    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)addcity{
    if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(addcity)]){
        [self.calendarDelegate addcity];
    }
}
-(void)find{
    NSString *mstr=monthstr;
    NSString *dstr=daystr;
    if (monthstr.intValue<10) {
        mstr=[NSString stringWithFormat:@"0%@",monthstr];
    }
    if (daystr.intValue<10) {
        dstr=[NSString stringWithFormat:@"0%@",daystr];
    }
    NSString *time=[NSString stringWithFormat:@"%@%@%@",yearstr,mstr,dstr];
    NSString *day=[NSString stringWithFormat:@"%@年%@月%@日",yearstr,mstr,dstr];
    
    if (cityid.length>0) {
        if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(findActionwithtime:withcity:withcityname:withday:)]){
            [self.calendarDelegate findActionwithtime:time withcity:cityid withcityname:city withday:day];
        }
    }else{
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"请选择出生地区" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        al.tag=222;
        [al show];
    }
    
}

-(void)timePicker:(id)sender{
    UIButton *bt=(UIButton*)sender;
    
    TFSheet *tfsheet=[[TFSheet alloc] initWithHeight:250 WithSheetTitle:@""
                                         withLeftBtn:@"返回" withRightBtn:@"确认"];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 216)];
    if (kSystemVersionMore7) {
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth, 155)];
    }
    pickerView.dataSource = self;
    pickerView.delegate=self;
    pickerView.showsSelectionIndicator=YES;
    pickerView.tag=bt.tag;
    mypickerview=pickerView;
    [tfsheet.sheetBgView addSubview:pickerView];
    [tfsheet setDelegate:self];
   
    [tfsheet show];
    
    
    
}
- (void)doneBtnClicked{
    NSInteger row=[mypickerview selectedRowInComponent:0];
    NSInteger i=mypickerview.tag;
    switch (i) {
        case 1001:{
            [self.days removeAllObjects];
            yearstr=[self.years objectAtIndex:row];
            for (int i=0; i<=[self howManyDaysInThisMonth:yearstr.intValue month:monthstr.intValue]; i++) {
                NSString *day=@"";
                day=[NSString stringWithFormat:@"%d",i];
                if (i>0) {
                    [self.days addObject:day];
                }
               daystr=@"1";
            }
        }
            break;
        case 1002:{
            [self.days removeAllObjects];
            monthstr=[self.months objectAtIndex:row];
            for (int i=0; i<=[self howManyDaysInThisMonth:yearstr.intValue month:monthstr.intValue]; i++) {
                NSString *day=@"";
                day=[NSString stringWithFormat:@"%d",i];
                if (i>0) {
                    [self.days addObject:day];
                }
              daystr=@"1";
            }
        }
            break;
        case 1003:
//             [self.daybtn setTitle:[self.days objectAtIndex:row] forState:UIControlStateNormal];
            daystr=[self.days objectAtIndex:row];
            break;
        
        default:
            break;
    }
    [self.holidayList reloadData];
}
#pragma mark -
#pragma mark Picker Date Source Methods
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag==1001) {
        return self.years.count;
    }
    if (pickerView.tag==1002) {
        return self.months.count;
    }
    else
        return self.days.count;
}

#pragma mark Picker Delegate Methods
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag==1001) {
        return [self.years objectAtIndex:row];
    }
    if (pickerView.tag==1002) {
        return [self.months objectAtIndex:row];
    }
    else
        return [self.days objectAtIndex:row];}

//// pickerView 列数
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return 3;
//}
//
//// pickerView 每列个数
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    if (component == 0) {
//        return [self.years count];
//    }
//    if (component == 1) {
//        return [self.months count];
//    }
//    if (component == 2) {
//        return [self.days count];
//    }
//    return 0;
//}
//
//// 每列宽度
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    
//   
//    return 100;
//}
//// 返回选中的行
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//}
//
////返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (component == 0) {
//        return [self.years objectAtIndex:row];
//    } else if (component == 1){
//        return [self.months objectAtIndex:row];
//        
//    }else{
//        return [self.days objectAtIndex:row];
//    }
//
//}
-(void)bgClicked{
    if (mypickerview) {
        [mypickerview removeFromSuperview];
        mypickerview=nil;
    }
}
-(void)closeAction:(UIButton *)btn{
    int tag=[btn tag];
    self.btntag=tag;
    UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"是否删除该备忘录" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    al.tag=111;
    [al show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==111) {
        if (buttonIndex==0) {
            
            [self.memos removeAllObjects];
            //        NSString *bw=[NSString stringWithFormat:@"%d",self.bwday];
            NSArray *marr=[[setting sharedSetting].memodic objectForKey:self.menoday];
            
            NSMutableArray *newarr=[[NSMutableArray alloc]init];
            for (int i=0; i<marr.count; i++) {
                NSString *cont=[[marr objectAtIndex:i]objectForKey:self.menoday];
                if (cont.length>0) {
                    NSDictionary *memodic=[NSDictionary dictionaryWithObject:cont forKey:self.menoday];
                    [newarr addObject:memodic];
                }
                //        NSLog(@"%@",newarr);
            }
            [setting sharedSetting].memos=newarr;
         
            [[setting sharedSetting].memos removeObjectAtIndex:(newarr.count-self.btntag-1)];
            //     NSLog(@"%@",newarr);
            NSMutableDictionary * allLifeDic =[[NSMutableDictionary alloc] initWithDictionary:[setting sharedSetting].memodic];
            [allLifeDic setValue:[setting sharedSetting].memos forKey:self.menoday];
            [setting sharedSetting].memodic = allLifeDic;
            [[setting sharedSetting] saveSetting];
            
           
            
            [self selectedCell:nil setDay:m_today.day setMonth:m_today.month setYear:m_today.year withTag:m_today.day-1];//删除后返回今天
             [self mark];
        }else{
            return;
        }
        [self mark];
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self.holidayList) {
        CGFloat offsetY1= self.holidayList.contentOffset.y;
        CGPoint timeOffsetY1=self.bgscro.contentOffset;
        timeOffsetY1.y=offsetY1;
//        self.holidayList.contentOffset=timeOffsetY1;
        self.bgscro.contentOffset=timeOffsetY1;
    }
}
-(int)howManyDaysInThisMonth:(int)year month:(int)imonth {
    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        return 31;
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        return 30;
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return 28;
    }
    if(year%400 == 0)
        return 29;
    if(year%100 == 0)
        return 28;
    return 29;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
