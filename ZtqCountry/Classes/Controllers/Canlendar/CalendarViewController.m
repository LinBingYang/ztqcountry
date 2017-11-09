//
//  CalendarViewController.m
//  ZtqNew
//
//  Created by wang zw on 12-7-2.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarViewController.h"
#import "LunarDB.h"
#import "ShareFun.h"

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    bgImgV.backgroundColor = [UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1];
    [self.view addSubview:bgImgV];
	self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    if (kSystemVersionMore7) {
        self.edgesForExtendedLayout=UIEventSubtypeNone;
    }
	
//	self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden= NO;
	
	UIButton *t_buttonR = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	[t_buttonR setBackgroundColor:[UIColor clearColor]];
	[t_buttonR setImage:[UIImage imageNamed:@"cssz返回.png"] forState:UIControlStateNormal];
    [t_buttonR setImage:[UIImage imageNamed:@"cssz返回点击.png"] forState:UIControlStateHighlighted];
	[t_buttonR addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *t_barButtonR = [[UIBarButtonItem alloc] initWithCustomView:t_buttonR];
//	UIBarButtonItem *t_barButtonR = [[[UIBarButtonItem alloc] initWithCustomView:t_buttonR] autorelease];
//	[t_buttonR release];
	self.navigationItem.leftBarButtonItem = t_barButtonR;
	
	UIButton *t_buttonL = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
	[t_buttonL setBackgroundColor:[UIColor clearColor]];
	[t_buttonL setImage:[UIImage imageNamed:@"黄历今标.png"] forState:UIControlStateNormal];
	[t_buttonL addTarget:self action:@selector(todayAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *t_barButtonL = [[UIBarButtonItem alloc] initWithCustomView:t_buttonL];
//	UIBarButtonItem *t_barButtonL = [[[UIBarButtonItem alloc] initWithCustomView:t_buttonL] autorelease];
//	[t_buttonL release];
	self.navigationItem.rightBarButtonItem = t_barButtonL;
	
	//-----------------------------------------------------------------------------------------------------
	m_calendar = [[Calendar alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 435)];
	m_calendar.calendarDelegate = self;
	[self.view addSubview:m_calendar];
//	[m_calendar release];
	//-----------------------------------------------------------------------------------------------------
}



- (void) backAction
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) todayAction
{
	m_calendar.m_currentDate = m_calendar.m_today;
	[m_calendar cleanDate];
	[m_calendar drawDateGrid:m_calendar.m_today];
	[m_calendar fillInDate:m_calendar.m_today];
	NSString *t_dateWords = [[NSString alloc] initWithFormat:@"%d年%d月",(int)m_calendar.m_today.year, m_calendar.m_today.month];
	m_calendar.m_dateWords.text = t_dateWords;
//	[t_dateWords release];
}

#pragma mark calendarDelegate
- (void) showselectedDate:(NSDate *)t_date
{
	UIView *t_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[t_view setBackgroundColor:[UIColor clearColor]];
	
	UIButton *t_close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 480)];
	[t_close addTarget:self action:@selector(closeDialog) forControlEvents:UIControlEventTouchUpInside];
	[t_view addSubview:t_close];
//	[t_close release];
	
	UIImageView *t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(38, 110, self.view.width-76, 259)];
	[t_imageView setImage:[UIImage imageNamed:@"下拉框弹出背景.png"]];
	[t_view addSubview:t_imageView];
//	[t_imageView release];
	
	UIImageView *t_titleBg = [[UIImageView alloc] initWithFrame:CGRectMake(42, 115, self.view.width-84, 30)];
	[t_titleBg setImage:[UIImage imageNamed:@"下拉框背景.png"]];
	[t_view addSubview:t_titleBg];
//	[t_titleBg release];
	
	UILabel *t_title = [[UILabel alloc] initWithFrame:CGRectMake(42, 115, 234, 30)];
	[t_title setBackgroundColor:[UIColor clearColor]];
	[t_title setTextAlignment:UITextAlignmentCenter];
	[t_title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
	t_title.text = @"黄历";
	[t_view addSubview:t_title];
//	[t_title release];
	
	UIImageView *t_line = [[UIImageView alloc] initWithFrame:CGRectMake(42, 150, 234, 3)];
	[t_line setImage:[UIImage imageNamed:@"下拉框弹出分割线.png"]];
	[t_view addSubview:t_line];
//	[t_line release];
	
	//------------------黄历-------------------------------------------------------------------------------
	LunarDB *t_lunarDB = [[LunarDB alloc] init];
	[t_lunarDB setSolarDate:t_date];
	
	UIImageView *t_yi = [[UIImageView alloc] initWithFrame:CGRectMake(68, 160, 25, 25)];
	[t_yi setImage:[UIImage imageNamed:@"almanac_yi.png"]];
	[t_view addSubview:t_yi];
//	[t_yi release];
	
	UILabel *t_dayYi = [[UILabel alloc] initWithFrame:CGRectMake(113, 160, 160, 25)];
	[t_dayYi setBackgroundColor:[UIColor clearColor]];
	[t_dayYi setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[t_view addSubview:t_dayYi];
//	[t_dayYi release];
	t_dayYi.text = [t_lunarDB GetDayYi];
	
	UIImageView *t_ji = [[UIImageView alloc] initWithFrame:CGRectMake(68, 188, 25, 25)];
	[t_ji setImage:[UIImage imageNamed:@"almanac_ji.png"]];
	[t_view addSubview:t_ji];
//	[t_ji release];
	
	UILabel *t_dayJi = [[UILabel alloc] initWithFrame:CGRectMake(113, 188, 160, 25)];
	[t_dayJi setBackgroundColor:[UIColor clearColor]];
	[t_dayJi setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[t_view addSubview:t_dayJi];
//	[t_dayJi release];
	t_dayJi.text = [t_lunarDB GetDayJi];
	
	UIImageView *t_chong = [[UIImageView alloc] initWithFrame:CGRectMake(68, 216, 25, 25)];
	[t_chong setImage:[UIImage imageNamed:@"almanac_chong.png"]];
	[t_view addSubview:t_chong];
//	[t_chong release];
	
	UILabel *t_dayChong = [[UILabel alloc] initWithFrame:CGRectMake(113, 216, 160, 25)];
	[t_dayChong setBackgroundColor:[UIColor clearColor]];
	[t_dayChong setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[t_view addSubview:t_dayChong];
//	[t_dayChong release];
	t_dayChong.text = [t_lunarDB GetShengxiaoChong];
	
	UILabel *t_zhishenIco = [[UILabel alloc] initWithFrame:CGRectMake(48, 244, 65, 18)];
	[t_zhishenIco setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"almanac_yellow.png"]]];
	[t_zhishenIco setTextAlignment:UITextAlignmentCenter];
	[t_zhishenIco setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[t_zhishenIco setText:@"值 神"];
	[t_view addSubview:t_zhishenIco];
//	[t_zhishenIco release];
	
	UILabel *t_zhishen = [[UILabel alloc] initWithFrame:CGRectMake(123, 244, 150, 18)];
	[t_zhishen setBackgroundColor:[UIColor clearColor]];
	[t_zhishen setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[t_view addSubview:t_zhishen];
//	[t_zhishen release];
	t_zhishen.text = [t_lunarDB GetDayRijian];
	
	UILabel *t_pengZuBaiJiIco = [[UILabel alloc] initWithFrame:CGRectMake(48, 264, 65, 18)];
	[t_pengZuBaiJiIco setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"almanac_yellow.png"]]];
	[t_pengZuBaiJiIco setTextAlignment:UITextAlignmentCenter];
	[t_pengZuBaiJiIco setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[t_pengZuBaiJiIco setText:@"彭祖百忌"];
	[t_view addSubview:t_pengZuBaiJiIco];
//	[t_pengZuBaiJiIco release];
	
	UILabel *t_pengZuBaiJi = [[UILabel alloc] initWithFrame:CGRectMake(123, 264, 150, 18)];
	[t_pengZuBaiJi setBackgroundColor:[UIColor clearColor]];
	[t_pengZuBaiJi setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[t_view addSubview:t_pengZuBaiJi];
//	[t_pengZuBaiJi release];
	t_pengZuBaiJi.text = [t_lunarDB GetPengZuBaiJi];
	
	UILabel *t_xingxiuIco = [[UILabel alloc] initWithFrame:CGRectMake(48, 284, 65, 18)];
	[t_xingxiuIco setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"almanac_yellow.png"]]];
	[t_xingxiuIco setTextAlignment:UITextAlignmentCenter];
	[t_xingxiuIco setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[t_xingxiuIco setText:@"星宿位方"];
	[t_view addSubview:t_xingxiuIco];
//	[t_xingxiuIco release];
	
	UILabel *t_xingxiu = [[UILabel alloc] initWithFrame:CGRectMake(123, 284, 150, 18)];
	[t_xingxiu setBackgroundColor:[UIColor clearColor]];
	[t_xingxiu setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[t_view addSubview:t_xingxiu];
//	[t_xingxiu release];
	t_xingxiu.text = [t_lunarDB ChineseConstellation];
	
	UILabel *t_taishenIco = [[UILabel alloc] initWithFrame:CGRectMake(48, 304, 65, 18)];
	[t_taishenIco setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"almanac_yellow.png"]]];
	[t_taishenIco setTextAlignment:NSTextAlignmentCenter];
	[t_taishenIco setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[t_taishenIco setText:@"胎神占方"];
	[t_view addSubview:t_taishenIco];
//	[t_taishenIco release];
	
	UILabel *t_taishen = [[UILabel alloc] initWithFrame:CGRectMake(123, 304, 150, 18)];
	[t_taishen setBackgroundColor:[UIColor clearColor]];
	[t_taishen setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[t_view addSubview:t_taishen];
//	[t_taishen release];
	t_taishen.text = [t_lunarDB GetTaiSheng];
	
//	[t_lunarDB release];
	//---------------------------------------------------------------------------------------------------------------
	
	UIImageView *t_end = [[UIImageView alloc] initWithFrame:CGRectMake(155, 322, 114, 42)];
	[t_end setImage:[UIImage imageNamed:@"widget_logo.png"]];
	[t_view addSubview:t_end];
//	[t_end release];

	t_dialog = [[PCSDialog alloc] initWithFrame:CGRectMake(0, 0, self.view.width,kScreenHeitht)];
	[t_dialog setDialogView:t_view];
//	[t_view release];
	[t_dialog show];
//	[t_dialog release];

}

- (void) closeDialog
{
	[t_dialog close];
}

@end
