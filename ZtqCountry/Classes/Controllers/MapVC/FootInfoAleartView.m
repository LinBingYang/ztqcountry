//
//  FootInfoAleartView.m
//  ZtqCountry
//
//  Created by Admin on 15/7/2.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "FootInfoAleartView.h"

@implementation FootInfoAleartView
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.bgscro=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
        self.bgscro.contentSize=CGSizeMake(kScreenWidth*3, 140);
        self.bgscro.showsHorizontalScrollIndicator=NO;
        self.bgscro.showsVerticalScrollIndicator=NO;
        self.bgscro.backgroundColor=[UIColor clearColor];
        [self addSubview:self.bgscro];
    }
    return self;
}
-(void)getdata:(NSArray *)datas withaddress:(NSString *)address{
    self.bgscro.contentSize=CGSizeMake(250*datas.count+50, 140);
    for (int i=0; i<datas.count; i++) {
        NSDictionary *wt=datas[i];
        NSString *date=[wt objectForKey:@"date"];
        NSString *humidity=[wt objectForKey:@"humidity"];
        NSString *short_time=[wt objectForKey:@"short_time"];
        NSString *temp=[wt objectForKey:@"temp"];
        NSString *week=[wt objectForKey:@"week"];
        NSString *wt_ico=[wt objectForKey:@"wt_ico"];
        NSString *wea=[wt objectForKey:@"wt"];
        UIImageView *alview=[[UIImageView alloc]initWithFrame:CGRectMake(40+260*i, 15, 250, 120)];
        alview.image=[UIImage imageNamed:@"出行天气弹窗底座"];
        alview.userInteractionEnabled=YES;
        [self.bgscro addSubview:alview];
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, alview.frame.size.width, 1)];
        line.image=[UIImage imageNamed:@"出行天气弹窗分隔线"];
        [alview addSubview:line];
        UIImageView *xx=[[UIImageView alloc]initWithFrame:CGRectMake(alview.frame.size.width-25, 5, 20, 20)];
        xx.image=[UIImage imageNamed:@"出行天气弹窗删除常态"];
        [alview addSubview:xx];
        UIButton *closebtn=[[UIButton alloc]initWithFrame:CGRectMake(alview.frame.size.width-60, 5, 60, 40)];

        [closebtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [alview addSubview:closebtn];
        UILabel *citylab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, alview.frame.size.width-30, 40)];
        citylab.text=address;
        citylab.numberOfLines=0;
        citylab.textColor=[UIColor blackColor];
        citylab.font=[UIFont systemFontOfSize:14];
        [alview addSubview:citylab];
        UILabel *datelab=[[UILabel alloc]initWithFrame:CGRectMake(5, 50, 90, 20)];
        datelab.text=short_time;
        datelab.textAlignment=NSTextAlignmentCenter;
        datelab.textColor=[UIColor blackColor];
        datelab.font=[UIFont systemFontOfSize:14];
        [alview addSubview:datelab];
        UILabel *weeklab=[[UILabel alloc]initWithFrame:CGRectMake(5, 70, 90, 20)];
        weeklab.text=[NSString stringWithFormat:@"%@",date];
        weeklab.numberOfLines=0;
        weeklab.textAlignment=NSTextAlignmentCenter;
        weeklab.textColor=[UIColor blackColor];
        weeklab.font=[UIFont systemFontOfSize:13];
        [alview addSubview:weeklab];
        UILabel *wqlab=[[UILabel alloc]initWithFrame:CGRectMake(5, 90, 90, 20)];
        wqlab.text=[NSString stringWithFormat:@"%@",week];
        wqlab.numberOfLines=0;
        wqlab.textAlignment=NSTextAlignmentCenter;
        wqlab.textColor=[UIColor blackColor];
        wqlab.font=[UIFont systemFontOfSize:13];
        [alview addSubview:wqlab];
        UIImageView *icoimg=[[UIImageView alloc]initWithFrame:CGRectMake(95, 50, 50, 50)];
        icoimg.image=[UIImage imageNamed:[NSString stringWithFormat:@"ww%@",wt_ico]];
        [alview addSubview:icoimg];
        
        UILabel *ctlab=[[UILabel alloc]initWithFrame:CGRectMake(145, 50, 100, 20)];
        if (temp.length>0) {
            ctlab.text=[NSString stringWithFormat:@"%@℃",temp];
        }
        
        ctlab.textAlignment=NSTextAlignmentCenter;
        ctlab.textColor=[UIColor blackColor];
        ctlab.font=[UIFont systemFontOfSize:14];
        [alview addSubview:ctlab];
        UILabel *wealab=[[UILabel alloc]initWithFrame:CGRectMake(145, 70, 100, 20)];
        wealab.text=wea;
        wealab.numberOfLines=0;
        wealab.textAlignment=NSTextAlignmentCenter;
        wealab.textColor=[UIColor blackColor];
        wealab.font=[UIFont systemFontOfSize:13];
        [alview addSubview:wealab];
        UILabel *sdlab=[[UILabel alloc]initWithFrame:CGRectMake(145, 90, 100, 20)];
        if (humidity.length>0) {
            sdlab.text=[NSString stringWithFormat:@"相对湿度%@%%",humidity];
        }
        sdlab.numberOfLines=0;
        sdlab.textAlignment=NSTextAlignmentCenter;
        sdlab.textColor=[UIColor blackColor];
        sdlab.font=[UIFont systemFontOfSize:13];
        [alview addSubview:sdlab];
    }
    
}
-(void)closeAction{
    [self removeFromSuperview];
}
@end
