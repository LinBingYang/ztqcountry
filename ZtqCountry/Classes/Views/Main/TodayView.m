//
//  TodayView.m
//  ZtqCountry
//
//  Created by Admin on 15/6/2.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "TodayView.h"

@implementation TodayView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        NSLog(@"%f,%f",self.frame.size.width,self.frame.size.height);
        self.icoimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 70, 70)];
        self.icoimg.userInteractionEnabled=YES;
        self.icoimg.center=CGPointMake(self.frame.size.width/2, 50);
        [self addSubview:self.icoimg];
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.frame.size.height/2+15, 160, 1)];
        line.backgroundColor=[UIColor whiteColor];
        line.alpha=0.5;
        [self addSubview:line];
        self.wtlab=[[UILabel alloc]initWithFrame:CGRectMake(10, self.frame.size.height/2 - 5, 100, 20)];
        self.wtlab.textColor=[UIColor whiteColor];
//        self.wtlab.backgroundColor=[UIColor redColor];
        self.wtlab.textAlignment=NSTextAlignmentLeft;
        self.wtlab.numberOfLines=0;
        self.wtlab.font=[UIFont systemFontOfSize:15];
        self.wtlab.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.wtlab];
        self.wdlab=[[UILabel alloc]initWithFrame:CGRectMake(110, self.frame.size.height/2 - 5, self.width - 120, 20)];
        self.wdlab.textColor=[UIColor whiteColor];
        self.wdlab.textAlignment=NSTextAlignmentRight;
        self.wdlab.font=[UIFont systemFontOfSize:15];
        self.wdlab.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.wdlab];
        
        self.sklab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height / 2 + 15, self.width, self.height / 2 - 40)];
        self.sklab.textColor = [UIColor yellowColor];
        self.sklab.font = [UIFont systemFontOfSize:28];
//        self.sklab.text = @"N / A";
        self.sklab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.sklab];
//        [self updateMainSKTemData:@"35.5"];
        UIImageView *b=[[UIImageView alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(self.sklab.frame)-5, 20, 18)];
//        b.image=[UIImage imageNamed:@"良"];
        self.airicon=b;
        [self addSubview:b];
    }
    return self;
}
-(void)updateMainViewData:(NSDictionary *)dataDic{
    NSDictionary *todaywt=dataDic;
//    NSString *city_name=[todaywt objectForKey:@"city_name"];
    NSString *isnight=[todaywt objectForKey:@"is_night"];
    NSString *wt=[todaywt objectForKey:@"wt"];
    NSString *wt_ico=[todaywt objectForKey:@"wt_ico"];
//    NSString *tip=[todaywt objectForKey:@"tip"];
    NSString *lowt=[todaywt objectForKey:@"lowt"];
    NSString *higt=[todaywt objectForKey:@"higt"];
//    NSString *week=[todaywt objectForKey:@"week"];
    if ([isnight isEqualToString:@"1"]) {
        self.icoimg.image=[UIImage imageNamed:[NSString stringWithFormat:@"n%@",wt_ico]];
    }else{
        self.icoimg.image=[UIImage imageNamed:wt_ico];
    }
    
    self.wdlab.text=[NSString stringWithFormat:@"%@/%@℃",higt,lowt];
    self.wtlab.text=wt;
}

- (void)updateMainSKTemData:(NSString *)str {
    if (str.length > 0) {
    NSMutableAttributedString *sktext = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@℃",str]];
    [sktext addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:35] range:NSMakeRange(0, sktext.length - 1)];
    [sktext addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(sktext.length - 1, 1)];
    [sktext addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:10] range:NSMakeRange(sktext.length - 1, 1)];
    self.sklab.attributedText = sktext;
    }else{
        self.sklab.text = @"N / A";
    }
}
-(void)upAirLev:(NSString *)airlev{
    self.airicon.image=[UIImage imageNamed:airlev];
}


@end
