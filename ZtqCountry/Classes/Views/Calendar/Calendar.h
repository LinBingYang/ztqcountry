//
//  Calendar.h
//  CalendarCell
//
//  Created by 黄 芦荣 on 12-3-31.
//  Copyright 2012 卓派. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CalendarCell.h"
#import "Rilialert.h"
#import "YearAndMonthList.h"
#import "TFSheet.h"
@class Calendar;
@protocol CalendarDelegate <NSObject>
-(void)addcity;
-(void)findActionwithtime:(NSString *)time withcity:(NSString *)city withcityname:(NSString *)cityname withday:(NSString *)day;

@required

//-(void)showselectedDate:(CFGregorianDate)t_date;
-(void)showselectedDate:(NSDate *)t_date;

@end


@interface Calendar : UIView <CalendarCellDelegate,UITableViewDataSource,UITableViewDelegate,riliAlertDelegate,YAMlistDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
	
    //	id<CalendarDelegate>calendarDelegate;
    __weak id<CalendarDelegate>calendarDelegate;
	
	CFGregorianDate m_currentDate;
	CFGregorianDate m_today;
	
	CalendarCell *m_todayCell;
	UILabel *m_dateWords;
	UIView *m_dateView;
	
	NSMutableArray *m_dateArray;
    UIPickerView *mypickerview;
    NSString *yearstr,*monthstr,*daystr;
    NSString *city,*cityid;
    
	
}
@property (nonatomic, assign) BOOL clickToday;
@property (nonatomic, assign)CFGregorianDate m_currentDate;
@property (nonatomic, assign)CFGregorianDate m_today;
@property(nonatomic, readonly)UILabel *m_dateWords;
@property(nonatomic, strong) UITableView * holidayList;
@property (nonatomic, strong) NSMutableArray * holidayDatas;
@property (nonatomic, strong) UIView * dateMaskView;
@property (nonatomic, strong) CalendarCell * currentSelectedCell;
@property(strong,nonatomic)UIScrollView *bgscro;
@property(strong,nonatomic)YearAndMonthList *yearlist,*monthlist,*daylist;
@property(strong,nonatomic)NSMutableArray *years,*months,*days;
@property(strong,nonatomic)UIButton *yearbtn,*monthbtn,*daybtn;

@property (assign)int bwday;
@property(assign)int bwmonth;
@property(assign)int bwyear;
@property(strong,nonatomic)NSString *menoday;
@property(assign)BOOL isearil;//是否早于当天
@property(strong,nonatomic)NSMutableArray *memos;
@property(assign)int btntag;//删除哪一个


@property(nonatomic, weak)id<CalendarDelegate>calendarDelegate;

@property(nonatomic, assign)BOOL isOpen;
@property (nonatomic, strong) UIView * secondView;
@property (nonatomic, strong) UIButton * upBut;
@property (nonatomic, strong) UIButton * downBut;
@property(assign)int nowmonth,nowday;
@property(nonatomic,strong)NSDictionary *nldic,*hldic;
@property(strong,nonatomic)NSMutableArray *hlist,*wlist;
@property(strong,nonatomic)NSMutableArray *rarr,*larr;
@property(strong,nonatomic)NSString *date,*n_date;//新历农历
-(void)cleanDate;
-(void)fillInDate:(CFGregorianDate)t_date;
-(void)drawDateGrid:(CFGregorianDate)t_date;
- (void) resetDate;
-(void)today:(NSString *)day;
-(void)mark;
+ (NSString *) getHolidayDayWithyear:(int )t_year Withmonth:(int)t_month Withday:(NSString *)t_day;
+(NSString *)getChineseHoliday:(NSString *)t_rili;
-(void)getgz_cal_holiday_info;//获取节假日
@end
