//
//  CalendarVC.m
//  ZtqCountry
//
//  Created by linxg on 14-9-3.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "CalendarVC.h"

@interface CalendarVC ()

@end

@implementation CalendarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_lunarDB = [[LunarDB alloc] init];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closelistview) name:@"closelist" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenbtn:) name:@"beforeday" object:nil];
    CFAbsoluteTime t_currentTime = CFAbsoluteTimeGetCurrent();
    m_currentDate = CFAbsoluteTimeGetGregorianDate(t_currentTime, CFTimeZoneCopyDefault());
    m_today =       CFAbsoluteTimeGetGregorianDate(t_currentTime, CFTimeZoneCopyDefault());
    
    [self createNavigationBar];
    UIImageView * bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight)];
    bgImgV.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:bgImgV];
	self.view.backgroundColor = [UIColor whiteColor];
    if (kSystemVersionMore7) {
        self.edgesForExtendedLayout=UIEventSubtypeNone;
    }
    
    _m_calendar = [[Calendar alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight)];
	_m_calendar.calendarDelegate = self;
	[self.view addSubview:_m_calendar];
    
    
}

-(void)createNavigationBar
{
    self.barHiden = NO;
    self.rightBut.frame = CGRectMake(kScreenWidth-30-15,27.0, 30, 30);
	[self.rightBut setBackgroundImage:[UIImage imageNamed:@"红色圈.png"] forState:UIControlStateNormal];
//    self.rightBut.center = CGPointMake(kScreenWidth-30, self.navigationBarBg.center.y);
    [self.rightBut setTitle:@"今" forState:UIControlStateNormal];
	[self.rightBut addTarget:self action:@selector(todayAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.years=[[NSMutableArray alloc]init];
    
    self.months=[[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    for (int i=0; i<2020-1965; i++) {
        NSString *y=[NSString stringWithFormat:@"%d",2020-i];
        [self.years addObject:y];
    }
//    UIButton * previousMonthBut = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, 11, 15)];
//    previousMonthBut.tag = 0;
//    previousMonthBut.center = CGPointMake(86, self.navigationBarBg.center.y);
//    [previousMonthBut setBackgroundImage:[UIImage imageNamed:@"日期前.png"] forState:UIControlStateNormal];
//    [previousMonthBut addTarget:self action:@selector(previousMonthAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationBarBg addSubview:previousMonthBut];
    
    self.yearbtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2-70, 27, 60, 30)];
    [self.yearbtn setBackgroundColor:[UIColor whiteColor]];
    self.yearbtn.tag=1001;
    [self.yearbtn setTitle:[NSString stringWithFormat:@"%d",(int)m_currentDate.year] forState:UIControlStateNormal];
    [self.yearbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.yearbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.yearbtn addTarget:self action:@selector(timePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.yearbtn];
    
//    self.yearlist=[[YearAndMonthList alloc]initWithFrame:CGRectMake(80, 27, 60, 30)];
//    [self.yearlist setList:self.years];
//    self.yearlist.delegate=self;
//    [self.view addSubview:self.yearlist];
//    [self.yearlist.button setTitle:[NSString stringWithFormat:@"%d",(int)m_currentDate.year] forState:UIControlStateNormal];
    UILabel *ylab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.yearbtn.frame)+5, 27, 20, 30)];
    ylab.text=@"年";
    ylab.textColor=[UIColor whiteColor];
    ylab.font=[UIFont systemFontOfSize:15];
    [self.navigationBarBg addSubview:ylab];
    
    
    self.monthbtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ylab.frame), 27, 40, 30)];
    [self.monthbtn setBackgroundColor:[UIColor whiteColor]];
    self.monthbtn.tag=1002;
    [self.monthbtn setTitle:[NSString stringWithFormat:@"%d",(int)m_currentDate.month] forState:UIControlStateNormal];
    [self.monthbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.monthbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.monthbtn addTarget:self action:@selector(timePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.monthbtn];
//    self.monthlist=[[YearAndMonthList alloc]initWithFrame:CGRectMake(165, 27, 40, 30)];
//    [self.monthlist setList:self.months];
//    self.monthlist.delegate=self;
//    [self.view addSubview:self.monthlist];
//    [self.monthlist.button setTitle:[NSString stringWithFormat:@"%d",m_currentDate.month] forState:UIControlStateNormal];
    UILabel *mlab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.monthbtn.frame)+5, 27, 20, 30)];
    mlab.text=@"月";
    mlab.textColor=[UIColor whiteColor];
    mlab.font=[UIFont systemFontOfSize:15];
    [self.navigationBarBg addSubview:mlab];
    
    UIButton *editbtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-84, 30, 24, 24)];
    self.editbtn=editbtn;
    [editbtn setBackgroundImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [editbtn setBackgroundImage:[UIImage imageNamed:@"编辑点击态"] forState:UIControlStateHighlighted];
    [editbtn addTarget:self action:@selector(editbtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:editbtn];
    
    _dateWordLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 27, 100, 30)];
//    _dateWordLab.center = CGPointMake(160, self.navigationBarBg.center.y);
    _dateWordLab.backgroundColor = [UIColor clearColor];
    _dateWordLab.textAlignment = NSTextAlignmentCenter;
    _dateWordLab.textColor = [UIColor whiteColor];
    _dateWordLab.font = [UIFont fontWithName:kBaseFont size:25];
    _dateWordLab.text = [NSString stringWithFormat:@"%d.%d",(int)m_currentDate.year,m_currentDate.month];
    _dateWordLab.adjustsFontSizeToFitWidth = YES;
//    [self.navigationBarBg addSubview:_dateWordLab];
    
//    UIButton * nextMonthBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-101, 0, 11, 15)];
//    nextMonthBut.tag = 1;
//    nextMonthBut.center = CGPointMake((kScreenWidth-101)+6, self.navigationBarBg.center.y);
//    [nextMonthBut setBackgroundImage:[UIImage imageNamed:@"日期后.png"] forState:UIControlStateNormal];
//    [nextMonthBut addTarget:self action:@selector(previousMonthAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationBarBg addSubview:nextMonthBut];
    
}
-(void)closelistview{
    if ([self.yearlist.isopen isEqualToString:@"1"]) {
        [self.yearlist setShowList:NO];
    }
    if ([self.monthlist.isopen isEqualToString:@"1"]) {
        [self.monthlist setShowList:NO];
    }

}
-(void)editbtnAction{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"creatAlert" object:nil];
    
    
}
-(void)hidenbtn:(NSNotification *)object{
    NSString *isbefore=object.object;
    if ([isbefore isEqualToString:@"0"]) {
        self.editbtn.hidden=NO;
    }else{
        self.editbtn.hidden=YES;
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma 日历查询和城市选择
-(void)findActionwithtime:(NSString *)time withcity:(NSString *)city withcityname:(NSString *)cityname withday:(NSString *)day{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyyMMddHH"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%@16",time]];
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:time forKey:@"birthday"];
    [gz_todaywt_inde setObject:city forKey:@"station_id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_cal_birth_simple_info"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_cal_birth_simple_info"];
            self.birthsimpledic=gz_air_qua_index;
            
        }
        BirthdayViewController *bhvc=[[BirthdayViewController alloc]init];
        bhvc.ispay=YES;
        bhvc.data=self.birthsimpledic;
        bhvc.birthday=time;
        bhvc.cityid=city;
        bhvc.cityname=cityname;
        bhvc.time=day;
        bhvc.chineseday=[m_lunarDB setBirthdaySolarDate:date];
        [self.navigationController pushViewController:bhvc animated:YES];
        
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withCache:YES];
}
-(void)addcity{
    BirthCityViewController *select=[[BirthCityViewController alloc]init];
    [select setDataSource: m_treeNodebirthcity withCitys:m_treeNodebirthcountry];
    select.type=@"日历";
    [self.navigationController pushViewController:select animated:YES];
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
         [self.yearbtn setTitle:[self.years objectAtIndex:row] forState:UIControlStateNormal];
            NSString *year=self.years[row];
            m_currentDate.year =year.intValue;
            m_currentDate.month=self.monthbtn.titleLabel.text.intValue;
            m_currentDate.day=1;
            _m_calendar.m_currentDate = m_currentDate;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewYM" object:nil];

            NSString *memoday = [[NSString alloc] initWithFormat:@"%d%d%d", m_currentDate.day, m_currentDate.month,(int)m_currentDate.year];
            [_m_calendar today:memoday];
            [_m_calendar resetDate];
        }
            break;
        case 1002:{
            [self.monthbtn setTitle:[self.months objectAtIndex:row] forState:UIControlStateNormal];
            NSString *month=self.months[row];
            m_currentDate.month = month.intValue;
            m_currentDate.year=self.yearbtn.titleLabel.text.intValue;
            m_currentDate.day=1;
            _m_calendar.m_currentDate = m_currentDate;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewYM" object:nil];
            NSString *memoday = [[NSString alloc] initWithFormat:@"%d%d%d", m_currentDate.day, m_currentDate.month,(int)m_currentDate.year];
            [_m_calendar today:memoday];
            [_m_calendar resetDate];
        }
            break;
        
            
        default:
            break;
    }
  
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
    return 0;
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
        return nil;
}

-(void)YAMdidSelect:(YearAndMonthList *)list withIndex:(NSInteger)index{
    if (list==self.yearlist) {
        [self.yearlist.button setTitle:self.years[index] forState:UIControlStateNormal];
        NSString *year=self.years[index];
        m_currentDate.year =year.intValue;
        _m_calendar.m_currentDate = m_currentDate;
    }
    if (list==self.monthlist) {
        [self.monthlist.button setTitle:self.months[index] forState:UIControlStateNormal];
        NSString *month=self.months[index];
        m_currentDate.month = month.intValue;
        _m_calendar.m_currentDate = m_currentDate;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewYM" object:nil];
    [_m_calendar resetDate];
}
- (void) todayAction
{
    NSString *memoday = [[NSString alloc] initWithFormat:@"%d%d%d", _m_calendar.m_today.day, _m_calendar.m_today.month,(int)_m_calendar.m_today.year];
    
	_m_calendar.m_currentDate = _m_calendar.m_today;
    _m_calendar.clickToday = YES;
//	[_m_calendar cleanDate];
//	[_m_calendar drawDateGrid:_m_calendar.m_today];
//	[_m_calendar fillInDate:_m_calendar.m_today];
//    [_m_calendar resetDate];
    [_m_calendar mark];
    [_m_calendar today:memoday];
	NSString *t_dateWords = [[NSString alloc] initWithFormat:@"%d年%d月",(int)_m_calendar.m_today.year, _m_calendar.m_today.month];
	_m_calendar.m_dateWords.text = t_dateWords;
    

//    _dateWordLab.text=[NSString stringWithFormat:@"%d.%d",(int)_m_calendar.m_today.year,_m_calendar.m_today.month];
    [self.monthbtn setTitle:[NSString stringWithFormat:@"%d",(int)_m_calendar.m_today.month] forState:UIControlStateNormal];
    [self.yearbtn setTitle:[NSString stringWithFormat:@"%d",(int)_m_calendar.m_today.year] forState:UIControlStateNormal];
    //	[t_dateWords release];
}

#pragma mark calendarDelegate
- (void) showselectedDate:(NSDate *)t_date
{
	UIView *t_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 480)];
	[t_view setBackgroundColor:[UIColor clearColor]];
	
	UIButton *t_close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 480)];
	[t_close addTarget:self action:@selector(closeDialog) forControlEvents:UIControlEventTouchUpInside];
	[t_view addSubview:t_close];
    //	[t_close release];
	
	UIImageView *t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(38, 110, self.view.width-76, 259)];
	[t_imageView setImage:[UIImage imageNamed:@"下拉框弹出背景.png"]];
	[t_view addSubview:t_imageView];
    //	[t_imageView release];
	
	UIImageView *t_titleBg = [[UIImageView alloc] initWithFrame:CGRectMake(42, 115, 234, 30)];
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
    
	t_dialog = [[PCSDialog alloc] initWithFrame:CGRectMake(0, 0, 320,kScreenHeitht)];
	[t_dialog setDialogView:t_view];
    //	[t_view release];
	[t_dialog show];
    //	[t_dialog release];
    
}

- (void) closeDialog
{
	[t_dialog close];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//前一个月
-(void)previousMonthAction:(UIButton *)sender
{
    int t_year = m_currentDate.year;
	int t_month = m_currentDate.month;
	
	if ([sender tag] != 0) {
		
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
    _m_calendar.m_currentDate = m_currentDate;
//	NSLog(@"$%hhd$",_m_calendar.m_currentDate.month);
    NSString *t_dateWords = [NSString stringWithFormat:@"%d.%d",(int) m_currentDate.year, m_currentDate.month];
	[_dateWordLab setText:t_dateWords];
	[_m_calendar resetDate];
}

////后一个月
//-(void)nextMonthAction:(UIButton *)sender
//{
//	int t_year = m_currentDate.year;
//	int t_month = m_currentDate.month;
//
//	if ([buttonFlag tag] != 0) {
//
//		if (t_month < 12) {
//			t_month += 1;
//		}else {
//			t_month = 1;
//			t_year += 1;
//		}
//
//	}else {
//		if (t_month > 1) {
//			t_month -= 1;
//		}else {
//			t_month = 12;
//			t_year -= 1;
//		}
//
//	}
//	if (t_year > 2049 || t_year < 1901)
//		return;
//
//	m_currentDate.year = t_year;
//	m_currentDate.month = t_month;
//
//	[self resetDate];
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
