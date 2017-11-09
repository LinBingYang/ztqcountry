//
//  HourLineView.m
//  ZtqCountry
//
//  Created by Admin on 15/6/15.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "HourLineView.h"

@implementation HourLineView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
-(void)gethights:(NSArray *)wd Withicons:(NSArray *)icons withtimes:(NSArray *)times Withmax:(NSString *)maxhight Withmin:(NSString *)minlowt withnowct:(NSString *)ct{
    self.valuearr=wd;
    self.icons=icons;
    self.times=times;
    self.maxhight=maxhight;//最值多个1位像素
    self.minlowt=minlowt;
    self.nowct=ct;
//    self.valuearr=[[NSArray alloc]initWithObjects:@"22",@"20",@"18",@"18",@"25",@"28",@"33",@"15",@"28",@"30",@"33",@"31",@"22",@"22", nil];
    NSString *v=self.valuearr[0];
     float h=(self.maxhight.floatValue-self.minlowt.floatValue)/130;
    float y=140-(v.floatValue-self.minlowt.floatValue)/h;
    self.nextvalue=y;
    self.mscro=[[UIScrollView alloc]initWithFrame:CGRectMake(90, 0, kScreenWidth, 170)];
    self.mscro.contentSize=CGSizeMake(24*45+150, 150);
    self.mscro.showsHorizontalScrollIndicator=NO;
    self.mscro.showsVerticalScrollIndicator=NO;
    self.mscro.delegate=self;
    [self addSubview:self.mscro];
    self.hscrllview=[[hourscrollview alloc]initWithFrame:CGRectMake(0, 0, 24*45+50, 150)];
    self.hscrllview.valuearr=self.valuearr;
    self.hscrllview.maxhight=self.maxhight;
    self.hscrllview.minlowt=self.minlowt;
    self.hscrllview.nowct=self.nowct;
    self.hscrllview.times=self.times;
    self.hscrllview.icons=self.icons;
    [self.mscro addSubview:self.hscrllview];
    [self.hscrllview drawlin:0];
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
    CGContextMoveToPoint(currentContext, 45, 150);
    CGContextAddLineToPoint(currentContext, 45 + 50 * 24, 150);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext, 0.5);
    CGContextStrokePath(currentContext);
    //纵轴
    CGContextMoveToPoint(currentContext, 45, 0 );
    CGContextAddLineToPoint(currentContext, 45 ,150);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext, 0.5);
    CGContextStrokePath(currentContext);
    
    //高温虚线
    CGContextSetLineDash(currentContext, 45, dash, 2);
    CGContextMoveToPoint(currentContext, 45, 10);
    CGContextAddLineToPoint(currentContext,45+50*24,10);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext,0.5);
    CGContextStrokePath(currentContext);
    //最低虚线
    CGContextSetLineDash(currentContext, 45, dash, 2);
    CGContextMoveToPoint(currentContext, 45, 150-10);
    CGContextAddLineToPoint(currentContext,45+50*24,150-10);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext,0.5);
    CGContextStrokePath(currentContext);
    //当前虚线
    NSLog(@"%f,%f",self.maxhight.floatValue,self.minlowt.floatValue);
    float h=(self.maxhight.floatValue-self.minlowt.floatValue)/130;
    float y=140-(self.nowct.floatValue-self.minlowt.floatValue)/h;
    CGContextSetLineDash(currentContext, 45, dash, 2);
    CGContextMoveToPoint(currentContext, 45, y);
    CGContextAddLineToPoint(currentContext,45+50*24,y);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext,0.5);
    CGContextStrokePath(currentContext);
    
    if (self.signlab) {
        [self.signlab removeFromSuperview];
    }
    UILabel *flag=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 20, 15)];
    flag.text=@"℃";
    self.signlab=flag;
    flag.textColor=[UIColor whiteColor];
    flag.font=[UIFont systemFontOfSize:12];
    [self addSubview:flag];
    if (self.maxlab) {
        [self.maxlab removeFromSuperview];
    }
    UILabel *h_yestodaylab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 40, 20)];
    h_yestodaylab.text=self.maxhight;
    self.maxlab=h_yestodaylab;
    h_yestodaylab.textColor=[UIColor whiteColor];
    h_yestodaylab.font=[UIFont systemFontOfSize:12];
    h_yestodaylab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:h_yestodaylab];
    
    if (self.nowctlab) {
        [self.nowctlab removeFromSuperview];
    }
    UILabel *nowlab=[[UILabel alloc]initWithFrame:CGRectMake(10+35, y-20, 40, 20)];
    nowlab.text=self.nowct;
    self.nowctlab=nowlab;
    nowlab.textColor=[UIColor whiteColor];
    nowlab.textAlignment=NSTextAlignmentCenter;
    nowlab.font=[UIFont systemFontOfSize:12];
    [self addSubview:nowlab];
    if (self.minlab) {
        [self.minlab removeFromSuperview];
    }
    UILabel *l_yestodaylab=[[UILabel alloc]initWithFrame:CGRectMake(10, 150-20, 40, 20)];
    self.minlab=l_yestodaylab;
    l_yestodaylab.text=self.minlowt;
    l_yestodaylab.textColor=[UIColor whiteColor];
    l_yestodaylab.font=[UIFont systemFontOfSize:12];
    l_yestodaylab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:l_yestodaylab];
    if (self.nowlab) {
        [self.nowlab removeFromSuperview];
    }
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10+40, 150, 40, 20)];
    lab.text=@"现在";
    self.nowlab=lab;
    lab.textColor=[UIColor whiteColor];
    lab.font=[UIFont systemFontOfSize:12];
    lab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:lab];
    
//    NSLog(@"%f",self.nextvalue);
    if (self.isscroll==NO) {
        CGContextSetLineDash(currentContext, 70, dash, 2);
        CGContextMoveToPoint(currentContext, 70, y);
        CGContextAddLineToPoint(currentContext, 120 ,self.nextvalue);
        [[UIColor yellowColor] set];
        CGContextSetLineWidth(currentContext,1);
        CGContextStrokePath(currentContext);
    }
   
    CGFloat lengths[] = {1,0};
    CGContextSetLineDash(currentContext, 45, lengths, 2);
    CGContextMoveToPoint(currentContext, 70, y);
    CGContextAddLineToPoint(currentContext, 70 ,150);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext,0.5);
    CGContextStrokePath(currentContext);
   
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.mscro.contentOffset.x<=0) {
        self.isscroll=NO;
    }else{
        self.isscroll=YES;
    }
    if (scrollView==self.mscro) {
        NSInteger i=self.mscro.contentOffset.x/45;
            if (self.mscro.contentOffset.x>=0) {
                NSString *value=self.valuearr[i];
                float h=(self.maxhight.floatValue-self.minlowt.floatValue)/130;
                float y=140-(value.floatValue-self.minlowt.floatValue)/h;
                self.nextvalue=y;
//                [self.hscrllview drawlin:y];
                [self setNeedsDisplay];
            }
        
        
//        NSLog(@"%f",self.mscro.contentOffset.x);
    }
}
@end
