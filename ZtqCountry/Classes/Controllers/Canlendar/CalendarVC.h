//
//  CalendarVC.h
//  ZtqCountry
//
//  Created by linxg on 14-9-3.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import "Calendar.h"
#import "PCSDialog.h"
#import "LunarDB.h"
#import "YearAndMonthList.h"
#import "TFSheet.h"
#import "BirthCityViewController.h"
#import "BirthdayViewController.h"

@interface CalendarVC : BaseViewController<CalendarDelegate,YAMlistDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
	LunarDB *m_lunarDB;
	PCSDialog *t_dialog;
    CFGregorianDate m_today;
    CFGregorianDate m_currentDate;
    UIPickerView *mypickerview;
    TreeNode *m_allCity;
    TreeNode *m_allArea;
}
@property(strong,nonatomic)YearAndMonthList *yearlist,*monthlist;
@property (strong, nonatomic) UILabel * dateWordLab;
@property (strong, nonatomic) Calendar *m_calendar;
@property(strong,nonatomic)NSArray *months;
@property(strong,nonatomic)NSMutableArray *years;
@property(strong,nonatomic)UIButton *yearbtn,*monthbtn;
@property(strong,nonatomic)NSDictionary *birthsimpledic;
@property(strong,nonatomic)UIButton *editbtn;
@end
