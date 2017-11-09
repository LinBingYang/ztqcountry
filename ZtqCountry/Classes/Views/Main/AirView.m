//
//  AirView.m
//  ZtqCountry
//
//  Created by Admin on 15/7/14.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "AirView.h"
#import "UILabel+utils.h"
@implementation AirView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        self.airlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 250, 50)];
//        self.airlab.text=@"暂无数据";
        self.airlab.textAlignment=NSTextAlignmentLeft;
        self.airlab.textColor=[UIColor whiteColor];
        self.airlab.font=[UIFont fontWithName:kBaseFont size:35];
        [self addSubview:self.airlab];
        self.aqilab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-150, 20, 60, 30)];
//        self.aqilab.text=@"暂无数据";
        self.aqilab.textAlignment=NSTextAlignmentCenter;
        self.aqilab.textColor=[UIColor whiteColor];
        self.aqilab.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.aqilab];
        self.wulanlab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-85, 20, 75, 30)];
        self.wulanlab.text=@"PM2.5";
        self.wulanlab.textAlignment=NSTextAlignmentCenter;
        self.wulanlab.adjustsFontSizeToFitWidth=YES;
        self.wulanlab.textColor=[UIColor whiteColor];
        self.wulanlab.numberOfLines=0;
        self.wulanlab.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.wulanlab];
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10, 50, 140, 1)];
        line.image=[UIImage imageNamed:@"分割线.png"];
        [self addSubview:line];
        UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-145, 50, 50, 1)];
        line1.image=[UIImage imageNamed:@"分割线.png"];
        [self addSubview:line1];
        UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-85, 50, 75, 1)];
        line2.image=[UIImage imageNamed:@"分割线.png"];
        [self addSubview:line2];
        UILabel *t_aqilab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-150, 50, 60, 30)];
        t_aqilab.text=@"AQI值";
        t_aqilab.textAlignment=NSTextAlignmentCenter;
        t_aqilab.textColor=[UIColor whiteColor];
        t_aqilab.font=[UIFont systemFontOfSize:13];
        [self addSubview:t_aqilab];
        UILabel *t_wrwlab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-87, 50, 80, 30)];
        t_wrwlab.text=@"首要污染物";
        t_wrwlab.textAlignment=NSTextAlignmentCenter;
        t_wrwlab.textColor=[UIColor whiteColor];
        t_wrwlab.font=[UIFont systemFontOfSize:13];
        [self addSubview:t_wrwlab];
//        UIImageView *wrwimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 85, 20, 22)];
//        wrwimg.image=[UIImage imageNamed:@"首要污染物.png"];
//        [self addSubview:wrwimg];
        UIImageView *aixin=[[UIImageView alloc]initWithFrame:CGRectMake(10, 55, 23, 25)];
        aixin.image=[UIImage imageNamed:@"爱心.png"];
//        [self addSubview:aixin];
        self.healthlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 55, 165, 30)];
        //        self.healthlab.text=@"首要污染物:PM10首要污染物:PM10首要污染物:PM10首要污染物:PM10v首要污染物:PM10首要污染物:PM10";
        self.healthlab.textColor=[UIColor whiteColor];
        self.healthlab.numberOfLines=0;
        self.healthlab.adjustsFontSizeToFitWidth=YES;
        self.healthlab.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.healthlab];
        
//        UIButton *detailbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-80, 5, 70, 28)];
//        [detailbtn setTitle:@"    详情" forState:UIControlStateNormal];
        UIButton *detailbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-75, 5, 70, 25)];
        [detailbtn setTitle:@"空气质量" forState:UIControlStateNormal];
         [detailbtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
        detailbtn.titleLabel.font=[UIFont systemFontOfSize:15];
//        detailbtn.titleLabel.alpha=0.7;
        [detailbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
        [detailbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];

//        [detailbtn setBackgroundImage:[UIImage imageNamed:@"按钮底座.png"] forState:UIControlStateNormal];
        [detailbtn addTarget:self action:@selector(airdetailAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:detailbtn];
        UIImageView *detailico=[[UIImageView alloc]initWithFrame:CGRectMake(7, 2, 18, 18)];
        detailico.image=[UIImage imageNamed:@"详情.png"];
//        [detailbtn addSubview:detailico];

        
    }
    return self;
}
-(void)updateAirInfo:(NSDictionary *)airinfo{
    if (airinfo) {
        
        
        NSString *health=[airinfo objectForKey:@"health_advice"];
        NSString *quality=[airinfo objectForKey:@"quality"];
        NSString *pollutant=[airinfo objectForKey:@"primary_pollutant"];
        NSString *aqi=[airinfo objectForKey:@"aqi"];
               
        if ([quality isEqualToString:@"优"]) {
            pollutant=@"无";
        }
//        float w=[self.airlab labelLength:quality withFont:[UIFont fontWithName:kBaseFont size:45]];
        self.healthlab.text=[NSString stringWithFormat:@"%@",health];
        float h=[self.healthlab labelheight:health withFont:[UIFont systemFontOfSize:15]];
        self.healthlab.frame=CGRectMake(10, 55, 165, h);
        self.airlab.text=quality;
        if ([pollutant rangeOfString:@","].location!=NSNotFound) {
            NSArray *arr=[pollutant componentsSeparatedByString:@","];
            if (arr.count>1) {
                NSString *str=arr[0];
                NSString *str1=arr[1];
                self.wulanlab.text=[NSString stringWithFormat:@"%@\n%@",str,str1];
            }
        }else if ([pollutant rangeOfString:@"("].location!=NSNotFound) {
            NSArray *arr=[pollutant componentsSeparatedByString:@"("];
            if (arr.count>1) {
                NSString *str=arr[0];
                NSString *str1=arr[1];
                self.wulanlab.text=[NSString stringWithFormat:@"%@\n(%@",str,str1];
            }
        }else{
            self.wulanlab.text=[NSString stringWithFormat:@"%@",pollutant];
        }
        
        self.aqilab.text=[NSString stringWithFormat:@"%@",aqi];
//        self.aqilab.frame=CGRectMake(25+w, 20, 200, 65);
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.healthlab.text];;
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//        [paragraphStyle setLineSpacing:3];
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.healthlab.text.length)];
//        
//        self.healthlab.attributedText = attributedString;
        
        int air=aqi.intValue;
        self.airlab.textColor=[self getAQIclolorWithAqinum:air];
        self.aqilab.textColor=[self getAQIclolorWithAqinum:air];
        self.wulanlab.textColor=[self getAQIclolorWithAqinum:air];
    }
    
}
-(UIColor *)getAQIclolorWithAqinum:(int)air{
    UIColor *airclolor=[UIColor whiteColor];
    if (air>0 &&air<51) {
        airclolor=[UIColor colorWithRed:101.0/255.0f green:240.0/255.0f blue:2.0/255.0f alpha:1.0f];
    }else
        if (air>50 && air <101) {
            airclolor=[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:28.0/255.0f alpha:1.0f];
        }else
            if (air>100 && air<151) {
                airclolor=[UIColor colorWithRed:253.0/255.0f green:164.0/255.0f blue:10.0/255.0f alpha:1.0f];
            }else
                if (air>150 && air<201) {
                    airclolor=[UIColor colorWithRed:239.0/255.0f green:8.0/255.0f blue:2.0/255.0f alpha:1.0f];
                }else
                    if (air>200 && air<301) {
                        airclolor=[UIColor colorWithRed:153.0/255.0f green:0.0/255.0f blue:153.0/255.0f alpha:1.0f];
                    }else
                        if (air>300) {
                            airclolor=[UIColor colorWithRed:139.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0f];
                        }else{
                            airclolor=[UIColor whiteColor];
                        }
    return airclolor;
}
-(void)airdetailAction{
    if ([self.delegate respondsToSelector:@selector(airAction)]) {
        [self.delegate airAction];
    }
}
@end
