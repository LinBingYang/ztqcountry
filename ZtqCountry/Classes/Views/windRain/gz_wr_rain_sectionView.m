//
//  gz_wr_rain_sectionView.m
//  ZtqCountry
//
//  Created by hpf on 16/1/14.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "gz_wr_rain_sectionView.h"
#import "TFSheet.h"
#import "MBProgressHUD.h"
@interface gz_wr_rain_sectionView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong) NSMutableArray *dateArray;//不包含小时的数据dd
@property(nonatomic,strong) NSMutableDictionary *dateArrayYYYY;//不包含小时的数据 YYYY-MM-dd
@property(nonatomic,strong) NSMutableDictionary *dateArrayYYYYMMdd;//不包含小时的数据 YYYYMMdd
@property(nonatomic,strong) NSMutableDictionary *timeDict;//包含小时的数据
/**
 *  开始时间的年月日 和 小时选择Btn
 */
@property(nonatomic,weak) UIButton *hourStartBtn;
@property(nonatomic,weak) UIButton *dateStartBtn;
/**
 *  结束时间的年月日 和 小时选择Btn
 */
@property(nonatomic,weak) UIButton *hourEndBtn;
@property(nonatomic,weak) UIButton *dateEndBtn;

@property(nonatomic,strong) UIPickerView *pickDateView;

@property(nonatomic,weak) UILabel *rainstaticsLabel;
@property(nonatomic,weak) UILabel *rainMMLabel;
@property(nonatomic,weak) UIImageView *rainstaticsImage;
@end

@implementation gz_wr_rain_sectionView
-(NSMutableArray *)dateArray //所有数据传递给TimeChoseView.H   再由TimeChoseView.H传递给TimeStatisticsView 和TimeStartEndView  这个是时间范围的数据加载计算！！时间选择限制：限制为前5天及当天前一个整点时刻。
{
    /**
     *  计算UIpickerView数据  时间选择限制：限制为前5天及当天前一个整点时刻。
     */
    if (_dateArray==nil) {
        _dateArray=[[NSMutableArray alloc] init];
        _timeDict=[[NSMutableDictionary alloc] init];
        _dateArrayYYYY=[[NSMutableDictionary alloc] init];
        _dateArrayYYYYMMdd=[[NSMutableDictionary alloc] init];
        NSDate *today = [[NSDate alloc] init];
        
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        for (int i = 0; i < 6; i++) {
            
            NSDate *Dayago = [today dateByAddingTimeInterval: -(secondsPerDay * i)];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"dd"];
            dateFormatter.timeZone=[NSTimeZone systemTimeZone];
            //用[NSDate date]可以获取系统当前时间
            NSString *currentDateStr = [dateFormatter stringFromDate:Dayago];
            //输出格式为：2010-10-27 10:22:13
            [_dateArray addObject:currentDateStr];
            
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString *currentDateYYYYMMdd = [dateFormatter stringFromDate:Dayago];
            [_dateArrayYYYY setObject:currentDateYYYYMMdd forKey:currentDateStr];
            
            [dateFormatter setDateFormat:@"YYYYMMdd"];
            NSString *currentDateYYYYMMdd1 = [dateFormatter stringFromDate:Dayago];
            [_dateArrayYYYYMMdd setObject:currentDateYYYYMMdd1 forKey:currentDateStr];
            /**
             获取小时数据
             */
            [dateFormatter setDateFormat:@"HH"];
            NSMutableArray *mutableArray=[NSMutableArray array];
            if (i==0) {
                NSString *hour=[dateFormatter stringFromDate:Dayago];
                //                NSLog(@"%@",hour);
                for (int i=0; i<hour.intValue+1; i++) {
                    [mutableArray addObject:[NSString stringWithFormat:@"%d",i]];
                    
                }
                
            }else if(i<6){
                
                for (int i=0; i<24; i++) {
                    [mutableArray addObject:[NSString stringWithFormat:@"%d",i]];
                }
                [_timeDict setObject:mutableArray forKey:currentDateStr];
            }
//            else{
//                NSString *hour=[dateFormatter stringFromDate:Dayago];
//                for (int i=hour.intValue; i<24; i++) {
//                    [mutableArray addObject:[NSString stringWithFormat:@"%d",i]];
//                }
//                
//            }
            [_timeDict setObject:mutableArray forKey:currentDateStr];
            
            
            
        }
    }
    
    return _dateArray;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self setupfirstbar];
        [self setupsecondbar];
        [self setupchaxun];
        [self initchaxunTime];
//        [self initchaxunResult];
    }
    return self;
}
-(void)initchaxunResult
{
    UIImageView *rainstaticsImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.dateEndBtn.frame)+50, (self.frame.size.width-20)*0.5, 35)];
    [rainstaticsImage setImage:[UIImage imageNamed:@"降雨统计时段.png"]];
    [self addSubview:rainstaticsImage];
    UILabel *rainstatic=[[UILabel alloc] initWithFrame:rainstaticsImage.bounds];
    rainstatic.text=@"降雨统计时段区间";
    rainstatic.textAlignment=NSTextAlignmentCenter;
    rainstatic.font=[UIFont systemFontOfSize:14];
    [rainstaticsImage addSubview:rainstatic];
    
    
    UIImageView *rainMMImage=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rainstaticsImage.frame), CGRectGetMinY(rainstaticsImage.frame), (self.frame.size.width-20)*0.5, 35)];
    [rainMMImage setImage:[UIImage imageNamed:@"降雨统计时段.png"]];
    [self addSubview:rainMMImage];
    UILabel *rainMM=[[UILabel alloc] initWithFrame:rainMMImage.bounds];
    rainMM.font=[UIFont systemFontOfSize:14];
    rainMM.textAlignment=NSTextAlignmentCenter;
    rainMM.text=@"降雨总量(mm)";
    [rainMMImage addSubview:rainMM];
    
    UILabel *rainstaticsLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(rainstaticsImage.frame), (self.frame.size.width-20)*0.5, 50)];
    rainstaticsLabel.backgroundColor=[UIColor whiteColor];
    self.rainstaticsLabel=rainstaticsLabel;
    rainstaticsLabel.font=[UIFont systemFontOfSize:13];
    rainstaticsLabel.textAlignment=NSTextAlignmentCenter;
    rainstaticsLabel.numberOfLines=0;
    rainstaticsLabel.text=@"您未查询任何时段区间";
    [self addSubview:rainstaticsLabel];
    
    
    UILabel *rainMMLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rainstaticsImage.frame), CGRectGetMaxY(rainstaticsImage.frame), (self.frame.size.width-20)*0.5, 50)];
    rainMMLabel.backgroundColor=[UIColor whiteColor];
    self.rainMMLabel=rainMMLabel;
    rainMMLabel.font=[UIFont systemFontOfSize:13];
    rainMMLabel.textAlignment=NSTextAlignmentCenter;
    rainMMLabel.numberOfLines=0;
    rainMMLabel.text=@"0";
    [self addSubview:rainMMLabel];
    
    UIView *shuxian=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rainstaticsImage.frame)-1, CGRectGetMinY(rainstaticsImage.frame), 1, CGRectGetHeight(rainstaticsImage.frame)+CGRectGetHeight(rainMMLabel.frame))];
    shuxian.backgroundColor=[UIColor colorHelpWithRed:219 green:219 blue:219 alpha:1];
    [self addSubview:shuxian];

}
-(void)initchaxunTime
{
    NSDate *now=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    dateFormatter.timeZone=[NSTimeZone systemTimeZone];
//    NSString *currentDateStr = [dateFormatter stringFromDate:now];
    NSDate *lastoneHour=[now dateByAddingTimeInterval:0];
    [dateFormatter setDateFormat:@"HH"];
    NSString *hour=[dateFormatter stringFromDate:lastoneHour];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
     [dateFormatter setDateFormat:@"dd"];
//    NSString *today=[dateFormatter stringFromDate:now];
    
     NSDate *yesterdayDate=[now dateByAddingTimeInterval:-24*60*60];
        NSString *yesterday=[dateFormatter stringFromDate:yesterdayDate];
//    NSString *labelStr=[[dateFormatter stringFromDate:lastoneHour] stringByAppendingFormat:@" %@时",hour];
//    NSString *foreStr=[dateFormatter stringFromDate:lastoneHour];
    //以08时为分界，08时之前默认显示的查询时间段为昨日20：00 -当前整点时间，08时之后默认显示的查询时段为当日0：0 -当前整点时间。点击查询按钮，查询结果显示在表格中。
       if (hour.intValue>8) {//08时之后
           [self.dateStartBtn setTitle:self.dateArray[0] forState:UIControlStateNormal];
           [self.hourStartBtn setTitle:@"0:00" forState:UIControlStateNormal];
       }else{//08时之前
           [self.dateStartBtn setTitle:yesterday forState:UIControlStateNormal];
           [self.hourStartBtn setTitle:[NSString stringWithFormat:@"20:00"] forState:UIControlStateNormal];
       }
    [self.dateEndBtn setTitle:self.dateArray[0] forState:UIControlStateNormal];
    [self.hourEndBtn setTitle:[NSString stringWithFormat:@"%@:00",hour] forState:UIControlStateNormal];
}
-(void)setupchaxun
{
    UIButton *dateBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*0.8, CGRectGetMaxY(self.dateEndBtn.frame)+10, 50, 25)];
        [dateBtn setTitle:[NSString stringWithFormat:@"查询"] forState:UIControlStateNormal];
    [dateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dateBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [dateBtn setBackgroundImage:[UIImage imageNamed:@"查询 常态.png"] forState:UIControlStateNormal];
    [dateBtn setBackgroundImage:[UIImage imageNamed:@"查询 点击态.png"] forState:UIControlStateHighlighted];
    [dateBtn addTarget:self action:@selector(chaxunBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dateBtn];

}
-(void)setupsecondbar
{

    //结束时间
    CGFloat heightOne=25;
    UILabel *endTimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.dateStartBtn.frame)+5, 65, heightOne)];
    endTimeLabel.text=@"结束时间:";
    endTimeLabel.font=[UIFont systemFontOfSize:13];
    endTimeLabel.textColor=[UIColor colorWithRed:28/255.0 green:97/255.0 blue:191/255.0 alpha:1];
    
    [self addSubview:endTimeLabel];
    //结束时间选择日期
    UIButton *dateBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(endTimeLabel.frame)+5, CGRectGetMinY(endTimeLabel.frame), 70, heightOne)];
    dateBtn.adjustsImageWhenHighlighted=NO;
    //        NSLog(@"%@",[NSString stringWithFormat:@"%@",self.dateArray[0]]);
//    [dateBtn setTitle:[NSString stringWithFormat:@"%@",self.dateArray[0]] forState:UIControlStateNormal];
    [dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       dateBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 15);
    dateBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [dateBtn setBackgroundImage:[UIImage imageNamed:@"时刻.png"] forState:UIControlStateNormal];
    self.dateEndBtn=dateBtn;
    dateBtn.tag=2;
    [dateBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dateBtn];
    //日 label
    UILabel  *dayLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dateBtn.frame)+10, CGRectGetMinY(dateBtn.frame), 15,  dateBtn.frame.size.height)];
    dayLabel.text=@"日";
    dayLabel.font=[UIFont systemFontOfSize:13];
    [self addSubview:dayLabel];
    //小时选则
    UIButton *hourBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    hourBtn.frame=CGRectMake(CGRectGetMaxX(dayLabel.frame)+10, CGRectGetMinY(endTimeLabel.frame), 70, dateBtn.frame.size.height);
    [hourBtn setBackgroundImage:[UIImage imageNamed:@"时刻.png"] forState:UIControlStateNormal];
    
    //        hourBtn.titleLabel.text=@"000009";
//    NSString *keyStr=[NSString stringWithFormat:@"%@",self.dateEndBtn.titleLabel.text];
//    NSArray *array=self.timeDict[keyStr];
//    [hourBtn setTitle:[NSString stringWithFormat:@"%@",array[0]] forState:UIControlStateNormal];
    hourBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    hourBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 7, 0, 0);
    [hourBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //        [hourBtn setTintColor:[UIColor blueColor]];
    hourBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    self.hourEndBtn=hourBtn;
    hourBtn.tag=3;
    [hourBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hourBtn];
   
    
}
-(void)setupfirstbar
{
    //开始时间
     CGFloat heighttwo=25;
    UILabel *tjsj=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 65, heighttwo)];
    tjsj.text=@"开始时间:";
    tjsj.font=[UIFont systemFontOfSize:13];
    tjsj.textColor=[UIColor colorWithRed:28/255.0 green:97/255.0 blue:191/255.0 alpha:1];
    
    [self addSubview:tjsj];
    //开始时间选择日期
    UIButton *dateBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tjsj.frame)+5, 5, 70, heighttwo)];
    dateBtn.adjustsImageWhenHighlighted=NO;
    //        NSLog(@"%@",[NSString stringWithFormat:@"%@",self.dateArray[0]]);
    
    [dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dateBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        dateBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 15);
    [dateBtn setBackgroundImage:[UIImage imageNamed:@"时刻.png"] forState:UIControlStateNormal];
    self.dateStartBtn=dateBtn;
    dateBtn.tag=0;
    [dateBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dateBtn];
    //日 label
    UILabel  *dayLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dateBtn.frame)+10, 5, 15,  dateBtn.frame.size.height)];
    dayLabel.text=@"日";
    dayLabel.font=[UIFont systemFontOfSize:13];
    [self addSubview:dayLabel];
    //小时选则
    UIButton *hourBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    hourBtn.frame=CGRectMake(CGRectGetMaxX(dayLabel.frame)+10, 5, 70, dateBtn.frame.size.height);
    [hourBtn setBackgroundImage:[UIImage imageNamed:@"时刻.png"] forState:UIControlStateNormal];
    
    //        hourBtn.titleLabel.text=@"000009";
    
    hourBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
      hourBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 7, 0, 0);
    [hourBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //        [hourBtn setTintColor:[UIColor blueColor]];
    hourBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    self.hourStartBtn=hourBtn;
    hourBtn.tag=1;
    [hourBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hourBtn];
 
}
-(void)chaxunBtnClick
{
    
    /**
     开始和结束时间判断 开始时间不能晚于结束时间！
     */
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:00"];
    
    NSString *startHour=self.hourStartBtn.titleLabel.text;
    NSRange range=[startHour rangeOfString:@":"];
    if (range.length>0) {
        startHour=[startHour substringToIndex:range.location];
    }
    if (startHour.integerValue<10) {
        startHour=[NSString stringWithFormat:@"0%@",startHour];
        
    }
    NSString *endHour=self.hourEndBtn.titleLabel.text;
    NSRange range1=[endHour rangeOfString:@":"];
    if (range.length>0) {
        endHour=[endHour substringToIndex:range1.location];
    }
    if (endHour.integerValue<10) {
        endHour=[NSString stringWithFormat:@"0%@",endHour];
    }
    
    NSDate *date1=[dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@:00",self.dateArrayYYYY[self.dateStartBtn.titleLabel.text],startHour]];
    NSDate *date2=[dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@:00",self.dateArrayYYYY[self.dateEndBtn.titleLabel.text],endHour]];
    NSComparisonResult result=[date1 compare:date2];
    if (result!=NSOrderedAscending) {
        //        MBProgressHUD *hd=[[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        //        hd
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
        view.backgroundColor=[UIColor redColor];
        UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"知天气提示" message:@"您输入的结束时间有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [t_alertView show];
        return;
    }
    //发送网络请求  并且设置
    //设置发送格式
  
    NSString *startTime=[[self.dateArrayYYYY[self.dateStartBtn.titleLabel.text] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByAppendingString:startHour];
    NSString *endTime=[[self.dateArrayYYYY[self.dateEndBtn.titleLabel.text] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByAppendingString:endHour];
//    NSLog(@"%@  %@",startTime,endTime);
    
    //网络请求
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary *gz_wr_rain_section = [[NSMutableDictionary alloc] init];
    [b setObject:gz_wr_rain_section forKey:@"gz_wr_rain_section"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [gz_wr_rain_section setObject:self.cityid.length>0 ? self.cityid:[setting sharedSetting].currentCityID forKey:@"county_id"];
  [gz_wr_rain_section setObject:startTime forKey:@"begin_time"];
    [gz_wr_rain_section setObject:endTime forKey:@"end_time"];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:0 withSuccess:^(NSDictionary *returnData) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        //                NSLog(@"%@",returnData);
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *gz_wr_rain_section=[b objectForKey:@"gz_wr_rain_section"];
        if(self.rainstaticsImage)
        {
            [self.rainstaticsImage removeFromSuperview];
        }
        [self initchaxunResult];
        self.rainstaticsLabel.text=gz_wr_rain_section[@"time_section"];
        self.rainMMLabel.text=gz_wr_rain_section[@"r_num"];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:YES];
    } withCache:YES];

}
-(void)dateBtnClick:(UIButton *)Btn//年月日选择  小时选择
{
    TFSheet *tfsheet=[[TFSheet alloc] initWithHeight:250 WithSheetTitle:@""
                                         withLeftBtn:@"返回" withRightBtn:@"确认"];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 216)];
    if (kSystemVersionMore7) {
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth, 155)];
    }
    pickerView.dataSource = self;
    pickerView.delegate=self;
    pickerView.showsSelectionIndicator=YES;
    pickerView.tag=Btn.tag;
    self.pickDateView=pickerView;
    [pickerView selectRow:0 inComponent:0 animated:YES];
    [tfsheet.sheetBgView addSubview:pickerView];
    [tfsheet setDelegate:self];
    [tfsheet show];
}
#pragma mark UIpickerView 数据源

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag==0||pickerView.tag==2) {
        return self.dateArray.count;
    }else if (pickerView.tag==1) {
        NSString *keyStr=[NSString stringWithFormat:@"%@",self.dateStartBtn.titleLabel.text];
        NSArray *array=self.timeDict[keyStr];
        return array.count;
    }else
    {
        NSString *keyStr=[NSString stringWithFormat:@"%@",self.dateEndBtn.titleLabel.text];
        NSArray *array=self.timeDict[keyStr];
        return array.count;
    }
    
}

#pragma mark UIpickerView 代理
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag==0||pickerView.tag==2) {
        return self.dateArrayYYYYMMdd[self.dateArray[row]];
    }else if(pickerView.tag==1){
        NSString *keyStr=[NSString stringWithFormat:@"%@",self.dateStartBtn.titleLabel.text];
        NSArray *array=self.timeDict[keyStr];
        NSString *timeStr=array[row];
        timeStr=[NSString stringWithFormat:@"%@:00",timeStr];
        return timeStr;
    }else
    {
        NSString *keyStr=[NSString stringWithFormat:@"%@",self.dateEndBtn.titleLabel.text];
        NSArray *array=self.timeDict[keyStr];
        NSString *timeStr=array[row];
        timeStr=[NSString stringWithFormat:@"%@:00",timeStr];
        return timeStr;
    }
    
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kScreenWidth;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 20;
}

#pragma mark TFSheet 代理
- (void)doneBtnClicked
{
    NSUInteger i=self.pickDateView.tag;
    switch (i) {
        case 0:
        {
            [self.dateStartBtn setTitle:[NSString stringWithFormat:@"%@",self.dateArray[[self.pickDateView selectedRowInComponent:0]]] forState:UIControlStateNormal];
            NSString *keyStr=[NSString stringWithFormat:@"%@",self.dateStartBtn.titleLabel.text];
            NSArray *array=self.timeDict[keyStr];
            NSString *timeStr=array[0];
            timeStr=[NSString stringWithFormat:@"%@:00",timeStr];
            [self.hourStartBtn setTitle:timeStr forState:UIControlStateNormal];
//            [self.hourStartBtn setTitle:array[0] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            NSArray *array= self.timeDict[self.dateStartBtn.titleLabel.text];
            NSString *timeStr=array[[self.pickDateView selectedRowInComponent:0]];
            timeStr=[NSString stringWithFormat:@"%@:00",timeStr];
            [self.hourStartBtn setTitle:timeStr forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [self.dateEndBtn setTitle:[NSString stringWithFormat:@"%@",self.dateArray[[self.pickDateView selectedRowInComponent:0]]] forState:UIControlStateNormal];
            NSString *keyStr=[NSString stringWithFormat:@"%@",self.dateEndBtn.titleLabel.text];
            NSArray *array=self.timeDict[keyStr];
            NSString *timeStr=array[0];
            timeStr=[NSString stringWithFormat:@"%@:00",timeStr];
            [self.hourEndBtn setTitle:timeStr forState:UIControlStateNormal];
            
        }
            break;
        case 3:
        {
            NSArray *array= self.timeDict[self.dateEndBtn.titleLabel.text];
            NSString *timeStr=array[[self.pickDateView selectedRowInComponent:0]];
            timeStr=[NSString stringWithFormat:@"%@:00",timeStr];
            [self.hourEndBtn setTitle:timeStr forState:UIControlStateNormal];
        }
            break;
            
    }
    
    
    
}

@end
