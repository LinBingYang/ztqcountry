//
//  hourscrollview.m
//  ZtqCountry
//
//  Created by Admin on 15/6/16.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "hourscrollview.h"

@implementation hourscrollview
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor clearColor];
        
    }
    return self;
}
-(void)drawlin:(float)netxvalue{
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //开始自绘图形
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //关闭抗锯齿
    CGContextSetAllowsAntialiasing(currentContext, true);

    float h=(self.maxhight.floatValue-self.minlowt.floatValue)/130;
    
    for (int i=0; i<self.valuearr.count; i++) {
        NSString  *value=self.valuearr[i];
        float x0=45*i+30;
        float y0=140-(value.floatValue-self.minlowt.floatValue)/h;
        if (i==0) {
                      CGContextMoveToPoint(currentContext, x0, y0);
        }else{
           
            CGContextAddLineToPoint(currentContext, x0 ,y0);
                   }
       
        UIImage *t_image = [UIImage imageNamed:@"24小时预报表灰色点.png"];
        UIImageView *t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        self.t_img=t_imageView;
        [self addSubview:t_imageView];
        [t_imageView setImage:t_image];
        [t_imageView setCenter:CGPointMake(x0, y0)];
        
        
        UIImageView *icon= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//        icon.image=[UIImage imageNamed:self.icons[i]];
        [self addSubview:icon];
        [icon setCenter:CGPointMake(x0, y0-25)];
        
        NSString *timestr=self.times[i];
        int time=timestr.integerValue;
        if (time>18||time<7) {
            icon.image=[UIImage imageNamed:[NSString stringWithFormat:@"n%@",self.icons[i]]];
        }else{
            
            icon.image=[UIImage imageNamed:self.icons[i]];
        }
        
        UILabel *wdlab=[[UILabel alloc]initWithFrame:CGRectMake(45*i+28, 150, 40, 20)];
        wdlab.text=self.valuearr[i];
        self.ctlab=wdlab;
        wdlab.textColor=[UIColor whiteColor];
        wdlab.font=[UIFont systemFontOfSize:12];
        wdlab.textAlignment=NSTextAlignmentCenter;
        [self addSubview:wdlab];
        [wdlab setCenter:CGPointMake(x0, y0-10)];
        
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(45*i+18, 150, 40, 20)];
        lab.text=self.times[i];
        self.timelab=lab;
        lab.textColor=[UIColor whiteColor];
        lab.font=[UIFont systemFontOfSize:12];
        lab.textAlignment=NSTextAlignmentLeft;
        [self addSubview:lab];
    }
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext,2);
    CGContextStrokePath(currentContext);
}
@end
