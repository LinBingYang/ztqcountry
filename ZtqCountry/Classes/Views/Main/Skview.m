//
//  Skview.m
//  ZtqCountry
//
//  Created by Admin on 15/7/14.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "Skview.h"
#import "UILabel+utils.h"
@implementation Skview
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        bgimg.image=[UIImage imageNamed:@"首页背景条"];
        bgimg.userInteractionEnabled=YES;
        [self addSubview:bgimg];
        
        UILabel *loclab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
        loclab.text=@"现在";
        loclab.textColor=[UIColor whiteColor];
        loclab.font=[UIFont systemFontOfSize:15];
        [bgimg addSubview:loclab];
//        UIButton *skbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-80, 15, 70, 28)];
//        [skbtn setTitle:@"    实况" forState:UIControlStateNormal];
        UIButton *skbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-219, 7.5, 70, 25)];
        [skbtn setTitle:@"整点实况" forState:UIControlStateNormal];
        skbtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [skbtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
//        skbtn.titleLabel.alpha=0.7;
        [skbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
        [skbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
//        [skbtn setBackgroundImage:[UIImage imageNamed:@"按钮底座.png"] forState:UIControlStateNormal];
        [skbtn addTarget:self action:@selector(skAction) forControlEvents:UIControlEventTouchUpInside];
        [bgimg addSubview:skbtn];
        UIImageView *tcico=[[UIImageView alloc]initWithFrame:CGRectMake(6, 1, 18, 18)];
        tcico.image=[UIImage imageNamed:@"实况.png"];
//        [skbtn addSubview:tcico];
        
        UIButton *fycxbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-147, 7.5, 70, 25)];
        [fycxbtn setTitle:@"风雨查询" forState:UIControlStateNormal];
        fycxbtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [fycxbtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
        [fycxbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
        [fycxbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
        [fycxbtn addTarget:self action:@selector(fyAction) forControlEvents:UIControlEventTouchUpInside];
        [bgimg addSubview:fycxbtn];
        
        UIButton *kqzlbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-75, 7.5, 70, 25)];
        [kqzlbtn setTitle:@"空气质量" forState:UIControlStateNormal];
        kqzlbtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [kqzlbtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
        [kqzlbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
        [kqzlbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
        [kqzlbtn addTarget:self action:@selector(airAction) forControlEvents:UIControlEventTouchUpInside];
        [bgimg addSubview:kqzlbtn];
        //实时温度℃
        _realTemperatureLab = [[UILabel alloc] initWithFrame:CGRectMake(10,35 , 180, 130)];
        _realTemperatureLab.textAlignment = NSTextAlignmentLeft;
        _realTemperatureLab.textColor = [UIColor whiteColor];
        _realTemperatureLab.text=@"37.5";
        _realTemperatureLab.adjustsFontSizeToFitWidth = YES;
        _realTemperatureLab.font = [UIFont fontWithName:kWeatherFont size:65];
        _realTemperatureLab.backgroundColor = [UIColor clearColor];
        [self addSubview:_realTemperatureLab];
        //新增更新时间
        UILabel *uptimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(kqzlbtn.frame)+5, CGRectGetMinY(_realTemperatureLab.frame)+10, 200, 30)];
        NSDate *nowdate=[NSDate date];
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm更新"];
        [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
        NSString *updatetimeStr=[dateFormat stringFromDate:nowdate];
        uptimeLabel.textColor=[UIColor whiteColor];
        uptimeLabel.adjustsFontSizeToFitWidth = YES;
        uptimeLabel.font = [UIFont systemFontOfSize:13];
        uptimeLabel.text=updatetimeStr;
        self.uptimeLabel=uptimeLabel;
        [self addSubview:uptimeLabel];
        
        self.pointtempLab = [[UILabel alloc] initWithFrame:CGRectMake(45,42 , 130, 130)];
        self.pointtempLab.textAlignment = NSTextAlignmentLeft;
        self.pointtempLab.textColor = [UIColor whiteColor];
        self.pointtempLab.adjustsFontSizeToFitWidth = YES;
        self.pointtempLab.font = [UIFont fontWithName:kWeatherFont size:40];
        self.pointtempLab.backgroundColor = [UIColor clearColor];
        [self addSubview:self.pointtempLab];
        _sign = [[UILabel alloc] initWithFrame:CGRectMake(185,45, 60, 130)];
        _sign.textAlignment = NSTextAlignmentLeft;
        _sign.textColor = [UIColor whiteColor];
        _sign.adjustsFontSizeToFitWidth = YES;
        _sign.font = [UIFont fontWithName:kWeatherFont size:32];
        _sign.backgroundColor = [UIColor clearColor];
        [self addSubview:_sign];
        UIImageView *sdico=[[UIImageView alloc]initWithFrame:CGRectMake(10, 132, 20, 22)];
        sdico.image=[UIImage imageNamed:@"湿度.png"];
        self.sdimg=sdico;
        [self addSubview:sdico];
        UIImageView *njdico=[[UIImageView alloc]initWithFrame:CGRectMake(10, 175, 21, 20)];
        njdico.image=[UIImage imageNamed:@"能见度.png"];
        self.njdimg=njdico;
        [self addSubview:njdico];
        self.shidulab=[[UILabel alloc]initWithFrame:CGRectMake(38, 130, 200, 30)];
//        self.shidulab.text=@"20%";
        self.shidulab.textColor=[UIColor whiteColor];
        self.shidulab.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.shidulab];
        self.visilab=[[UILabel alloc]initWithFrame:CGRectMake(38, 170, 200, 30)];
//        self.visilab.text=@"10000m";
        self.visilab.textColor=[UIColor whiteColor];
        self.visilab.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.visilab];
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(5, 205, kScreenWidth-10, 0.5)];
//        line.image=[UIImage imageNamed:@"分割线.png"];
//        line.alpha=0.5;
        line.backgroundColor=[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1];
        line.alpha=0.05;
        [self addSubview:line];
        
        //日出日落
        //        self.drawarc=[[DrawArc alloc]initWithFrame:CGRectMake(160, 160, 140, 120)];
        //        [self addSubview:self.drawarc];
        UIImageView *lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(self.width-160, 170, 140, 1)];
        lineimg.backgroundColor=[UIColor whiteColor];
        line.alpha=0.7;
        [self addSubview:lineimg];
        
        UIBezierPath *path=[UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(self.width-90,170) radius:60 startAngle:M_PI endAngle:0 clockwise:YES];
        arcLayer=[CAShapeLayer layer];
        arcLayer.path=path.CGPath;//46,169,230
        arcLayer.fillColor=[UIColor clearColor].CGColor;
        arcLayer.strokeColor=[UIColor colorWithWhite:1 alpha:0.7].CGColor;
        arcLayer.lineWidth=2;
        arcLayer.lineJoin=kCALineJoinRound;
        arcLayer.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:1],nil];
        [self.layer addSublayer:arcLayer];
        
        LineProgressView *lineProgressView = [[LineProgressView alloc] initWithFrame:CGRectMake(self.width-90, 170, 200, 160)];
        lineProgressView.center=CGPointMake(self.width-100, 160);
        lineProgressView.backgroundColor = [UIColor clearColor];
        lineProgressView.delegate = self;
        lineProgressView.total = 100;
        lineProgressView.color =[UIColor clearColor];
        lineProgressView.radius = 60;
        //        lineProgressView.innerRadius = 60;
        lineProgressView.startAngle = M_PI;
        lineProgressView.endAngle = M_PI*2;
        lineProgressView.animationDuration = 2.0;
        lineProgressView.layer.shouldRasterize = YES;
        self.linep=lineProgressView;
        [self addSubview:lineProgressView];
        //        [lineProgressView setCompleted:80 animated:YES];
        
        
        self.sunriselab=[[UILabel alloc]initWithFrame:CGRectMake(self.width-167, 175, 100, 20)];
        self.sunriselab.textColor=[UIColor whiteColor];
        self.sunriselab.font=[UIFont systemFontOfSize:13];
        //        self.sunriselab.text=@"5:25";
        [self addSubview:self.sunriselab];
        self.sunsetlab=[[UILabel alloc]initWithFrame:CGRectMake(self.width-75, 175, 100, 20)];
        self.sunsetlab.textColor=[UIColor whiteColor];
        self.sunsetlab.font=[UIFont systemFontOfSize:13];
        //        self.sunsetlab.text=@"18:25";
        [self addSubview:self.sunsetlab];
       
    }
    return self;
}
-(void)updateSK:(NSDictionary *)skinfo{
   
    //当前太阳位置
    NSDateFormatter *dateFormtter=[[NSDateFormatter alloc] init];
    [dateFormtter setDateFormat:@"HH:mm"];
    NSString *dateString=[dateFormtter stringFromDate:[NSDate date]];
    NSDate *nowdate=[NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: nowdate];
//    NSDate *localeDate = [nowdate  dateByAddingTimeInterval: interval];
    NSInteger mint=2*60;//时间减2分钟
    NSDate * nowdt = [nowdate dateByAddingTimeInterval:-mint];
//    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormtter setDateFormat:@"HH:mm更新"];
    [dateFormtter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *dateString1=[dateFormtter stringFromDate:nowdt];
    self.uptimeLabel.text=dateString1;

    NSString *ct=[skinfo objectForKey:@"ct"];
    NSString *visibility=[skinfo objectForKey:@"visibility"];
    NSString *humidity=[skinfo objectForKey:@"humidity"];
    NSString *sunrise_time=[skinfo objectForKey:@"sunrise_time"];
    NSString *sunset_time=[skinfo objectForKey:@"sunset_time"];
    if (humidity.length>0) {
        self.sdimg.hidden=NO;
        self.shidulab.hidden=NO;
        self.shidulab.text=[NSString stringWithFormat:@"相对湿度 %@%%",humidity];
    }else{
        self.sdimg.hidden=YES;
        self.shidulab.hidden=YES;
    }
    if (visibility.length>0) {
        self.njdimg.hidden=NO;
        self.visilab.hidden=NO;
        self.visilab.text=[NSString stringWithFormat:@"能见度 %@m",visibility];
    }else{
        self.njdimg.hidden=YES;
        self.visilab.hidden=YES;
    }
    
    self.sunriselab.text=[NSString stringWithFormat:@"%@日出",sunrise_time];
    self.sunsetlab.text=[NSString stringWithFormat:@"日落%@",sunset_time];
    float cha=[self intervalFromLastDate:sunset_time toTheDate:sunrise_time];
    float nowcha=[self intervalFromLastDate:dateString toTheDate:sunrise_time];
    self.percent=nowcha/cha;
    if (self.percent>=1) {
        self.percent=1;
    }
    if (self.percent<=0||cha==0) {
        self.percent=0;
    }
    [self.linep setCompleted:self.percent*100 animated:YES];
    //    ct=@"37.5";
    _sign.text = @"℃";
    _sign.frame =CGRectMake(185,45, 60, 130);
    _realTemperatureLab.frame =CGRectMake(10,35 , 180, 130);
    if (ct.length>0) {
        float width = [_realTemperatureLab labelLength:ct withFont:[UIFont fontWithName:kWeatherFont size:65]];
        CGRect originFram = _realTemperatureLab.frame;
        _realTemperatureLab.frame = CGRectMake(10, originFram.origin.y-15, width, originFram.size.height);
        CGRect originSignFram = _sign.frame;
        _sign.frame = CGRectMake(originFram.origin.x+width+3, originSignFram.origin.y, originSignFram.size.width, originSignFram.size.height);
        //把小数点拆开
        if ([ct rangeOfString:@"."].location!=NSNotFound) {
            float width = [_realTemperatureLab labelLength:ct withFont:[UIFont fontWithName:kWeatherFont size:65]];
            CGRect originFram = _realTemperatureLab.frame;
            CGRect originSignFram = _sign.frame;
            _sign.frame = CGRectMake(originFram.origin.x+width-15+15, originSignFram.origin.y-20, originSignFram.size.width, originSignFram.size.height);
            self.pointtempLab.hidden=NO;
            NSArray *cts=[ct componentsSeparatedByString:@"."];
            NSString *newct=cts[0];
            _realTemperatureLab.text=[NSString stringWithFormat:@"%@.",newct];
            NSString *pointct=cts[1];
            self.pointtempLab.text=[NSString stringWithFormat:@"%@",pointct];
            //小数点前面大于2个字节
//            if (newct.length>1) {
//                self.pointtempLab.frame=CGRectMake(100, 46-15, 80, 65);
//                _sign.frame = CGRectMake(originFram.origin.x+width-15, originSignFram.origin.y-15, originSignFram.size.width, originSignFram.size.height);
//            }else{
//                self.pointtempLab.frame=CGRectMake(60, 46-15, 80, 65);
//                
//            }
            CGSize size = [[NSString stringWithFormat:@"%@.",newct] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:kWeatherFont size:65]}];
            CGSize size1 = [pointct sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:kWeatherFont size:40]}];
            CGSize adjustedSize1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
            self.pointtempLab.frame=CGRectMake(size.width+6, 61, size1.width, 65);
            _sign.frame = CGRectMake(adjustedSize1.width+size1.width+5, originSignFram.origin.y-15, originSignFram.size.width, originSignFram.size.height);
        }else{
            _realTemperatureLab.text=ct;
            self.pointtempLab.hidden=YES;
            CGSize size1 = [ct sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:kWeatherFont size:65]}];
            _sign.frame = CGRectMake(originFram.origin.x+size1.width, originSignFram.origin.y-15, originSignFram.size.width, originSignFram.size.height);
//            _sign.frame = CGRectMake(originFram.origin.x+width-10, originSignFram.origin.y-15, originSignFram.size.width, originSignFram.size.height);
        }
    }
}
-(void)skAction{
    if ([self.delegate respondsToSelector:@selector(skAction)]) {
        [self.delegate skAction];
    }
}
-(void)fyAction{
    if ([self.delegate respondsToSelector:@selector(fyfindaction)]) {
        [self.delegate fyfindaction];
    }
}
-(void)airAction{
    if ([self.delegate respondsToSelector:@selector(airaction)]) {
        [self.delegate airaction];
    }
}
- (float)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    float cha=0;
    if (dateString1.length>0) {
        NSArray *timeArray1=[dateString1 componentsSeparatedByString:@":"];
        dateString1=[timeArray1 objectAtIndex:0];
        NSString *hour=[timeArray1 objectAtIndex:1];
        float h=hour.floatValue/60;
        float allhour=dateString1.floatValue+h;
        if (dateString2.length>0) {
            NSArray *timeArray2=[dateString2 componentsSeparatedByString:@":"];
            dateString2=[timeArray2 objectAtIndex:0];
            NSString *hour1=[timeArray2 objectAtIndex:1];
            float h1=hour1.floatValue/60;
            float allhour1=dateString2.floatValue+h1;
            cha=allhour-allhour1;
        }
        
    }
    
//    NSLog(@"%f",cha);
    
    return cha;
}
@end
