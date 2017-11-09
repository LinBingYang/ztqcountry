//
//  SKMoveView.m
//  ZtqCountry
//
//  Created by Admin on 15/6/19.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "SKMoveView.h"

@implementation SKMoveView
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
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.width)];
    bg.userInteractionEnabled=YES;
    self.bgimg=bg;
    [self addSubview:bg];
    self.icoimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 25, 25)];
    [bg addSubview:self.icoimg];
    self.timelab=[[UILabel alloc]initWithFrame:CGRectMake(45, 0, kScreenWidth-45, 30)];
    self.timelab.font=[UIFont systemFontOfSize:15];
    self.timelab.textColor=[UIColor whiteColor];
    [bg addSubview:self.timelab];
    
//    self.skline=[[SKLineView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, 180)];
//    [bg addSubview:self.skline];
    
    
    
    UIImageView *rightimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 245, 15, 10)];
    rightimg.image=[UIImage imageNamed:@"实况时间轴滑动图标"];
//    [bg addSubview:rightimg];
}
-(void)upWithicon:(NSString *)imgname Withtitle:(NSString *)titlename Withdatas:(NSMutableArray *)datas WithTimes:(NSMutableArray *)times Withnowinfo:(NSString *)now Withflag:(NSString *)flag{
    NSMutableArray *mdatas=[[NSMutableArray alloc]init];
    NSMutableArray *mtimes=[[NSMutableArray alloc]init];
    mdatas=datas;
    mtimes=times;
//    [mdatas insertObject:now atIndex:0];
//    [mtimes insertObject:@"现在" atIndex:0];
    
    self.icoimg.image=[UIImage imageNamed:imgname];
    self.timelab.text=titlename;
    float maxValue = 0;
    float minValue = 100000;
    for (int i=0; i<datas.count; i++) {
        NSString *ct=datas[i];
        if ([flag isEqualToString:@"℃"]) {
            if ([ct  floatValue] > maxValue) {
                maxValue = [ct floatValue];//最大值多个5个像素
            }
            if ([ct  floatValue] < minValue) {
                minValue = [ct floatValue];
            }
        }
        if ([flag isEqualToString:@"%"]) {
            if ([ct  floatValue] > maxValue) {
                maxValue = [ct floatValue];//最大值多个5个像素
            }
            if ([ct  floatValue] < minValue) {
                minValue = [ct floatValue];
            }
        }
        if ([flag isEqualToString:@"m"]) {
            if ([ct  floatValue] > maxValue) {
                maxValue = [ct floatValue];//最大值多个5个像素
            }
            if ([ct  floatValue] < minValue) {
                minValue = [ct floatValue];
            }
        }
        if ([flag isEqualToString:@"mm"]) {
            if ([ct  floatValue] > maxValue) {
                maxValue = [ct floatValue];//最大值多个5个像素
            }
            if ([ct  floatValue] < minValue) {
                minValue = [ct floatValue];
            }
        }
       
    }

    
    
    NSString *newmax=[NSString stringWithFormat:@"%.1f",maxValue];
    NSString *newmin=[NSString stringWithFormat:@"%.1f",minValue];
   
//    [self.skline getValues:datas withtimes:times Withmax:newmax Withmin:newmin withnowct:now withflag:flag];
    if (datas.count>5) {
        if (self.mscro) {
            [self.mscro removeFromSuperview];
            self.mscro=nil;
        }
        self.mscro=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50,kScreenWidth, 210)];
        self.mscro.contentSize=CGSizeMake(mdatas.count*32+32, 190);
        [self.mscro setContentOffset:CGPointMake(mdatas.count*32-kScreenWidth+32, 0)];
        //    self.mscro.backgroundColor=[UIColor redColor];
        self.mscro.showsHorizontalScrollIndicator=NO;
        self.mscro.showsVerticalScrollIndicator=NO;
        self.mscro.bounces=NO;
        [self.bgimg addSubview:self.mscro];
        self.skwtsc=[[SkWtScrollview alloc]initWithFrame:CGRectMake(0, 0, mdatas.count*32+32, 190)];
        //    self.skwtsc.backgroundColor=[UIColor yellowColor];
        [self.mscro addSubview:self.skwtsc];
        [self.skwtsc getValues:mdatas withtimes:mtimes Withmax:newmax Withmin:newmin withnowct:now withflag:flag];
    }else{
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 30)];
        lab.text=@"暂无数据";
        self.lab=lab;
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:15];
        lab.textColor=[UIColor whiteColor];
        [self.bgimg addSubview:lab];
    }
    
    

}
@end
