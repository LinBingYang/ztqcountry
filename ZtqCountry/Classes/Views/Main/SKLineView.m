//
//  SKLineView.m
//  ZtqCountry
//
//  Created by Admin on 15/6/26.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "SKLineView.h"

@implementation SKLineView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
-(void)getValues:(NSArray *)values withtimes:(NSArray *)times Withmax:(NSString *)maxhight Withmin:(NSString *)minlowt withnowct:(NSString *)ct withflag:(NSString *)flag{
    self.valuearr=values;
    self.times=times;
    self.maxhight=maxhight;//最值多个1位像素
    self.minlowt=minlowt;
    self.nowct=ct;
    self.flag=flag;
    NSString *v=self.valuearr.lastObject;
    float h=(self.maxhight.floatValue-self.minlowt.floatValue)/130;
    float y=140-(v.floatValue-self.minlowt.floatValue)/h;
    self.nextvalue=y;
    self.mscro=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth-90, 170)];
    self.mscro.contentSize=CGSizeMake(24*45, 150);
    [self.mscro setContentOffset:CGPointMake(values.count*45-kScreenWidth+90, 0)];
//    self.mscro.backgroundColor=[UIColor redColor];
    self.mscro.showsHorizontalScrollIndicator=NO;
    self.mscro.showsVerticalScrollIndicator=NO;
    self.mscro.delegate=self;
    [self addSubview:self.mscro];
    self.skscrol=[[SKScrollview alloc]initWithFrame:CGRectMake(0, 0, values.count*50+50, 150)];
    self.skscrol.valuearr=self.valuearr;
    self.skscrol.maxhight=self.maxhight;
    self.skscrol.minlowt=self.minlowt;
    self.skscrol.nowct=self.nowct;
    self.skscrol.times=self.times;
    self.skscrol.icons=self.icons;
    [self.mscro addSubview:self.skscrol];
    [self.skscrol drawlin:0];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //开始自绘图形
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //关闭抗锯齿
    CGContextSetAllowsAntialiasing(currentContext, true);
    CGFloat dash[] = {3, 2};
    //横轴
    CGContextMoveToPoint(currentContext, 0, 150);
    CGContextAddLineToPoint(currentContext, kScreenWidth-45, 150);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext, 0.5);
    CGContextStrokePath(currentContext);
    //纵轴
    CGContextMoveToPoint(currentContext,kScreenWidth-45, 0 );
    CGContextAddLineToPoint(currentContext, kScreenWidth-45 ,150);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext, 0.5);
    CGContextStrokePath(currentContext);
    
    //高温虚线
    CGContextSetLineDash(currentContext, 0, dash, 2);
    CGContextMoveToPoint(currentContext, 0, 10);
    CGContextAddLineToPoint(currentContext,kScreenWidth-45,10);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext,0.5);
    CGContextStrokePath(currentContext);
    //最低虚线
    CGContextSetLineDash(currentContext, 0, dash, 2);
    CGContextMoveToPoint(currentContext, 0, 150-10);
    CGContextAddLineToPoint(currentContext,kScreenWidth-45,150-10);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext,0.5);
    CGContextStrokePath(currentContext);
    //当前虚线
//    NSLog(@"%f,%f",self.maxhight.floatValue,self.minlowt.floatValue);
    float h=(self.maxhight.floatValue-self.minlowt.floatValue)/130;
    float y=140-(self.nowct.floatValue-self.minlowt.floatValue)/h;
    CGContextSetLineDash(currentContext, 0, dash, 2);
    CGContextMoveToPoint(currentContext, 0, y);
    CGContextAddLineToPoint(currentContext,kScreenWidth-45,y);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext,0.5);
    CGContextStrokePath(currentContext);
    
    if (self.signlab) {
        [self.signlab removeFromSuperview];
    }
    UILabel *flag=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-40, 0, 20, 15)];
    flag.text=self.flag;
    self.signlab=flag;
    flag.textColor=[UIColor whiteColor];
    flag.font=[UIFont systemFontOfSize:12];
    [self addSubview:flag];
    if (self.maxlab) {
        [self.maxlab removeFromSuperview];
    }
    UILabel *h_yestodaylab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-50, 15, 50, 20)];
    h_yestodaylab.text=self.maxhight;
    self.maxlab=h_yestodaylab;
    h_yestodaylab.textColor=[UIColor whiteColor];
    h_yestodaylab.font=[UIFont systemFontOfSize:12];
    h_yestodaylab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:h_yestodaylab];
    
    if (self.nowctlab) {
        [self.nowctlab removeFromSuperview];
    }
    UILabel *nowlab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-50-35, y-20, 50, 20)];
    nowlab.text=self.nowct;
    self.nowctlab=nowlab;
    nowlab.textColor=[UIColor whiteColor];
    nowlab.textAlignment=NSTextAlignmentCenter;
    nowlab.font=[UIFont systemFontOfSize:12];
    [self addSubview:nowlab];
    if (self.minlab) {
        [self.minlab removeFromSuperview];
    }
    UILabel *l_yestodaylab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-50, 150-20, 50, 20)];
    self.minlab=l_yestodaylab;
    l_yestodaylab.text=self.minlowt;
    l_yestodaylab.textColor=[UIColor whiteColor];
    l_yestodaylab.font=[UIFont systemFontOfSize:12];
    l_yestodaylab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:l_yestodaylab];
    if (self.nowlab) {
        [self.nowlab removeFromSuperview];
    }
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-50-40, 150, 40, 20)];
    lab.text=@"现在";
    self.nowlab=lab;
    lab.textColor=[UIColor whiteColor];
    lab.font=[UIFont systemFontOfSize:12];
    lab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:lab];
    
    //    NSLog(@"%f",self.nextvalue);
    if (self.isscroll==NO) {
        CGContextSetLineDash(currentContext, kScreenWidth-70, dash, 2);
        CGContextMoveToPoint(currentContext, kScreenWidth-70, y);
        CGContextAddLineToPoint(currentContext, kScreenWidth-105 ,self.nextvalue);
        [[UIColor yellowColor] set];
        CGContextSetLineWidth(currentContext,1);
        CGContextStrokePath(currentContext);
    }
    
    CGFloat lengths[] = {1,0};
    CGContextSetLineDash(currentContext, kScreenWidth-45, lengths, 2);
    CGContextMoveToPoint(currentContext, kScreenWidth-70, y);
    CGContextAddLineToPoint(currentContext, kScreenWidth-70 ,150);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext,0.5);
    CGContextStrokePath(currentContext);
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",self.mscro.contentOffset.x);
    if (self.mscro.contentOffset.x>=(self.valuearr.count*45-kScreenWidth+90)) {
        self.isscroll=NO;
    }else{
        self.isscroll=YES;
    }
    if (scrollView==self.mscro) {
        NSString *v=self.valuearr.lastObject;
        float h=(self.maxhight.floatValue-self.minlowt.floatValue)/130;
        float y=140-(v.floatValue-self.minlowt.floatValue)/h;
        self.nextvalue=y;
        [self setNeedsDisplay];
        
        //        NSLog(@"%f",self.mscro.contentOffset.x);
    }
}

@end
