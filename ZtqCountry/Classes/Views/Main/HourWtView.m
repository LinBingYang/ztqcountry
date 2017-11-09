//
//  HourWtView.m
//  ZtqCountry
//
//  Created by Admin on 15/6/15.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "HourWtView.h"

@implementation HourWtView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor clearColor];
        [self creathourView];
    }
    return self;
}
-(void)creathourView{
//    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 255)];
//    bg.userInteractionEnabled=YES;
//    [self addSubview:bg];
    CGFloat space = 3;
    
//    self.icoimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 20, 20)];
//    self.icoimg.image=[UIImage imageNamed:@"时钟"];
//    [bg addSubview:self.icoimg];
    self.timelab=[[UILabel alloc]initWithFrame:CGRectMake(space*2, space, 200, 20)];
    self.timelab.font=[UIFont systemFontOfSize:14];
    self.timelab.textColor=[UIColor whiteColor];
    [self addSubview:self.timelab];
//    self.weathlab=[[UILabel alloc]initWithFrame:CGRectMake(45, 30, kScreenWidth, 30)];
//    self.weathlab.font=[UIFont systemFontOfSize:15];
//    self.weathlab.textColor=[UIColor yellowColor];
//    [bg addSubview:self.weathlab];
    
//    UILabel *wdlab=[[UILabel alloc]initWithFrame:CGRectMake(15, 70, 200, 30)];
//    wdlab.text=@"气温单位:℃";
//    wdlab.textColor=[UIColor whiteColor];
//    wdlab.font=[UIFont systemFontOfSize:12];
//    [bg addSubview:wdlab];
    UILabel *rianlab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 200 - 2*space, space, 200, 20)];
    rianlab.text=@"雨量单位 : 毫米";
    rianlab.textColor=[UIColor whiteColor];
    rianlab.font=[UIFont systemFontOfSize:14];
    rianlab.textAlignment = NSTextAlignmentRight;
    [self addSubview:rianlab];
    
//    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 80, kScreenWidth, 1)];
//    line.backgroundColor=[UIColor whiteColor];
//    [self addSubview:line];
//    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 190+80, kScreenWidth, 1)];
//    line1.backgroundColor=[UIColor whiteColor];
//    [self addSubview:line1];
//    self.hourwt=[[HourLineView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, 180)];
//    [bg addSubview:self.hourwt];
   
    self.mscro=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20 + space, kScreenWidth, 235)];
    self.mscro.contentSize=CGSizeMake(36*45 - 30, 225);
    self.mscro.showsHorizontalScrollIndicator=NO;
    self.mscro.showsVerticalScrollIndicator=NO;
    self.mscro.bounces=NO;
    self.mscro.delegate = self;
    [self addSubview:self.mscro];
    self.hwsview=[[HourWtScrollview alloc]initWithFrame:CGRectMake(0, 0, 36*45 + 15, 235)];
    [self.mscro addSubview:self.hwsview];
    
    
   
    
}
-(void)updateviewwithico:(NSString *)ico withput:(NSString *)puttime withwt:(NSString *)wt withhig:(NSString *)hig withlowt:(NSString *)lowt withnowct:(NSString *)nowct withnowrain:(NSString *)nowrain withhourlist:(NSArray *)hourlist{

        self.mscro.contentSize = CGSizeMake(hourlist.count*45 + 15, 225);
        self.hwsview.frame = CGRectMake(0, 0, hourlist.count*45 + 15, 235);
    
    
    
    /*    desc = "\U591a\U4e91";
    "is_night" = 0;
    "is_sunrise_sunset" = "-1";
    rainfall = "0.0";
    "time_ico" = 01;
    "time_str" = "18\U65f6";
    timet = "35.0";
    winddir = "\U65e0\U98ce\U5411";
    windpow = "1\U7ea7";
    windspeed = "0.3";*/

    
//    self.icoimg.image=[UIImage imageNamed:ico];
    self.timelab.text=puttime;
    self.weathlab.text=[NSString stringWithFormat:@"今天天气:%@  %@/%@℃",wt,hig,lowt];
    float maxValue = 0;
    float minValue = 50;
    float rainmax=0;
    float rainmin=100;
    NSMutableArray *cts=[[NSMutableArray alloc]init];
    NSMutableArray *times=[[NSMutableArray alloc]init];
    NSMutableArray *icons=[[NSMutableArray alloc]init];
    NSMutableArray *rains=[[NSMutableArray alloc]init];
    NSMutableArray *weatherValues = [NSMutableArray array];
    NSMutableArray *winddir = [NSMutableArray array];
    NSMutableArray *windpow = [NSMutableArray array];
    for (NSDictionary *objc  in hourlist) {
        NSString *weatherValue = objc[@"desc"];
        NSString *windd = objc[@"winddir"];
        NSString *windp = objc[@"windpow"];
        [weatherValues addObject:weatherValue];
        [winddir addObject:windd];
        [windpow addObject:windp];
    }
    
    for (int i=0; i<hourlist.count; i++) {
        NSString *ct=[hourlist[i] objectForKey:@"timet"];
        NSString *timeicon=[hourlist[i] objectForKey:@"time_ico"];
        NSString *time=[hourlist[i] objectForKey:@"time_str"];
          NSString *rainfall=[hourlist[i] objectForKey:@"rainfall"];
        if ([ct  floatValue] > maxValue) {
            maxValue = [ct floatValue];//最大值多个5个像素
        }
        if ([ct  floatValue] < minValue) {
            minValue = [ct floatValue];
        }
        if ([rainfall  floatValue] > rainmax) {
            rainmax = [rainfall floatValue];//最大值多个5个像素
        }
        if ([rainfall  floatValue] < rainmin) {
            rainmin = [rainfall floatValue];
        }
        [cts addObject:ct];
        [times addObject:time];
        [rains addObject:rainfall];
        if (timeicon.length>0) {
            [icons addObject:timeicon];
        }
        
    }
//    if (nowrain.length>0) {
//        [rains insertObject:nowrain atIndex:0];
//    }
//    [cts insertObject:nowct atIndex:0];
//    [times insertObject:@"现在" atIndex:0];
//    [icons insertObject:@"" atIndex:0];
//    if (maxValue<hig.floatValue) {
//        maxValue=hig.floatValue;//最大值多给5个像素
//    }
//    if (minValue>lowt.floatValue) {
//        minValue=lowt.floatValue;
//    }
    NSString *newmax=[NSString stringWithFormat:@"%.1f",maxValue];
    NSString *newmin=[NSString stringWithFormat:@"%.1f",minValue];
    NSString *newmaxrain=[NSString stringWithFormat:@"%.1f",rainmax];
    NSString *newminrain=[NSString stringWithFormat:@"%.1f",rainmin];
    if (cts.count>0) {
//        [self.hourwt gethights:cts Withicons:icons withtimes:times Withmax:newmax Withmin:newmin withnowct:nowct];
        [self.hwsview gethights:cts Withicons:icons withtimes:times Withmax:newmax Withmin:newmin withnowct:nowct withrains:rains withrainmax:newmaxrain withrainmin:newminrain withWeatherValue:weatherValues winddir:winddir windpow:windpow];
//        [self.hwsview addBezierThroughPoints:cts];
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

@end
