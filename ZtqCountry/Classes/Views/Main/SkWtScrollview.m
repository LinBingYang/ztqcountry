//
//  SkWtScrollview.m
//  ZtqCountry
//
//  Created by Admin on 15/7/16.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "SkWtScrollview.h"
#import <objc/runtime.h>
@implementation SkWtScrollview
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
    
//    NSString *v=self.valuearr.lastObject;
//    float h=(self.maxhight.floatValue-self.minlowt.floatValue)/130;
//    float y=140-(v.floatValue-self.minlowt.floatValue)/h;
//    self.nextvalue=y;
    
//    [self addBezierThroughPoints:self.valuearr];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
     NSArray *nows=[[NSArray alloc]initWithObjects:self.valuearr[0],self.valuearr[1], nil];
    //开始自绘图形
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //关闭抗锯齿
    CGContextSetAllowsAntialiasing(currentContext, true);
    CGFloat dash[] = {3, 2};
    //横轴
    CGContextMoveToPoint(currentContext, self.valuearr.count*m_width+m_width, 0);
    CGContextAddLineToPoint(currentContext, 0, 0);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext, 1);
    CGContextStrokePath(currentContext);
    
    CGContextMoveToPoint(currentContext, self.valuearr.count*m_width+m_width, 190);
    CGContextAddLineToPoint(currentContext, 0, 190);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext, 1);
    CGContextStrokePath(currentContext);
//    //纵轴
//    CGContextMoveToPoint(currentContext,self.valuearr.count*45, 0 );
//    CGContextAddLineToPoint(currentContext, self.valuearr.count*45 ,150);
//    [[UIColor whiteColor] set];
//    CGContextSetLineWidth(currentContext, 0.5);
//    CGContextStrokePath(currentContext);
    if (self.maxhight.doubleValue>0.0) {
        //高温虚线
        CGContextSetLineDash(currentContext, 0, dash, 2);
        CGContextMoveToPoint(currentContext, self.valuearr.count*m_width+m_width, 40);
        CGContextAddLineToPoint(currentContext,0,40);
        [[UIColor whiteColor] set];
        CGContextSetLineWidth(currentContext,0.5);
        CGContextStrokePath(currentContext);
    }
   
    //最低虚线
    CGContextSetLineDash(currentContext, 0, dash, 2);
    CGContextMoveToPoint(currentContext, self.valuearr.count*m_width+m_width, 190-40);
    CGContextAddLineToPoint(currentContext,0,190-40);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext,0.5);
    CGContextStrokePath(currentContext);
    //当前虚线
    //    NSLog(@"%f,%f",self.maxhight.floatValue,self.minlowt.floatValue);
    float h=(self.maxhight.floatValue-self.minlowt.floatValue)/110;
    float y;
    if (h>0) {
         y=150-(self.nowct.floatValue-self.minlowt.floatValue)/h;
    }
    
    
    if (self.signlab) {
        [self.signlab removeFromSuperview];
    }
    UILabel *flag=[[UILabel alloc]initWithFrame:CGRectMake(self.valuearr.count*45+10, 0, 20, 15)];
    flag.text=self.flag;
    self.signlab=flag;
    flag.textColor=[UIColor whiteColor];
    flag.font=[UIFont systemFontOfSize:12];
//    [self addSubview:flag];
    if (self.maxlab) {
        [self.maxlab removeFromSuperview];
    }
    UILabel *h_yestodaylab=[[UILabel alloc]initWithFrame:CGRectMake(self.valuearr.count*45, 0, 50, 20)];
    h_yestodaylab.text=self.maxhight;
    self.maxlab=h_yestodaylab;
    h_yestodaylab.textColor=[UIColor whiteColor];
    h_yestodaylab.font=[UIFont systemFontOfSize:11];
    h_yestodaylab.textAlignment=NSTextAlignmentCenter;
//    [self addSubview:h_yestodaylab];
    
    if (self.nowctlab) {
        [self.nowctlab removeFromSuperview];
    }
    UILabel *nowlab=[[UILabel alloc]initWithFrame:CGRectMake(self.valuearr.count*45, y-20, 50, 20)];
    nowlab.text=self.nowct;
    self.nowctlab=nowlab;
    nowlab.textColor=[UIColor whiteColor];
    nowlab.textAlignment=NSTextAlignmentCenter;
    nowlab.font=[UIFont systemFontOfSize:11];
//    [self addSubview:nowlab];
    if (self.minlab) {
        [self.minlab removeFromSuperview];
    }
    UILabel *l_yestodaylab=[[UILabel alloc]initWithFrame:CGRectMake(self.valuearr.count*45, 150-20, 50, 20)];
    self.minlab=l_yestodaylab;
    l_yestodaylab.text=self.minlowt;
    l_yestodaylab.textColor=[UIColor whiteColor];
    l_yestodaylab.font=[UIFont systemFontOfSize:11];
    l_yestodaylab.textAlignment=NSTextAlignmentCenter;
//    [self addSubview:l_yestodaylab];
    if (self.nowlab) {
        [self.nowlab removeFromSuperview];
    }
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-50, 130, 40, 20)];
    lab.text=@"现在";
    self.nowlab=lab;
    lab.textColor=[UIColor whiteColor];
    lab.font=[UIFont systemFontOfSize:11];
    lab.textAlignment=NSTextAlignmentCenter;
//    [self addSubview:lab];
    [self addBeforeTwoBezierThroughPoints:nows];//前面两点
    [self addBezierThroughPoints:self.valuearr];//虚线后面
    [self addFullPoints:self.valuearr];//填充
/*
    for (int i=0; i<nows.count; i++) {
        NSString  *value=nows[i];
        float x0=(self.valuearr.count*m_width+20)-m_width*i-8;
        float y0=150;
        if (h>0) {
          y0=150-(value.floatValue-self.minlowt.floatValue)/h;
        }
        
        if (i==0) {
            CGContextSetLineDash(currentContext, x0, dash, 1.5);
            
            CGContextMoveToPoint(currentContext, x0, y0);
            UIImage *t_image = [UIImage imageNamed:@"黄点.png"];
            UIImageView *t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
            self.t_img=t_imageView;
            [self addSubview:t_imageView];
            [t_imageView setImage:t_image];
            [t_imageView setCenter:CGPointMake(x0, y0)];
            
        }else{
            
            CGContextAddLineToPoint(currentContext, x0 ,y0);
            
        }
        

        
        
        
        
        UILabel *wdlab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-m_width*i-15, 150, 40, 20)];
        wdlab.text=nows[i];
        wdlab.textColor=[UIColor whiteColor];
        wdlab.font=[UIFont systemFontOfSize:12];
        wdlab.textAlignment=NSTextAlignmentCenter;
        float newmax=self.maxhight.integerValue;
        NSString *newhight=[NSString stringWithFormat:@"%.1f",newmax];
        if ([self.flag isEqualToString:@"m"]) {
            newhight=[NSString stringWithFormat:@"%.f",newmax];
        }
        
        [wdlab setCenter:CGPointMake(x0, y0-10)];
        if (i==0) {
            [wdlab setCenter:CGPointMake(x0, y0-10)];
            wdlab.font=[UIFont systemFontOfSize:12];
//            if (![nows[0] isEqualToString:newhight]) {
                [self addSubview:wdlab];
//            }
        }
        UILabel *maxlab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-15, 150, 40, 20)];
        float onemax=self.maxhight.floatValue;
        NSString *onemaxvalue=[NSString stringWithFormat:@"%.f",onemax];
        if ([self.flag isEqualToString:@"℃"]) {
            onemaxvalue=[NSString stringWithFormat:@"%.1f",onemax];
        }
        maxlab.text=onemaxvalue;
        maxlab.textColor=[UIColor whiteColor];
        maxlab.font=[UIFont systemFontOfSize:12];
        maxlab.textAlignment=NSTextAlignmentCenter;
        
        if (i==0) {
            NSString *v=self.valuearr[0];
            float fv=v.floatValue;
            if (fv==self.maxhight.floatValue) {
                
            }else
                [self addSubview:maxlab];
        }
        [maxlab setCenter:CGPointMake(x0, 22)];
        UILabel *minlab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-15, 150, 40, 20)];
        float onemin=self.minlowt.floatValue;
        NSString *oneminvalue=[NSString stringWithFormat:@"%.f",onemin];
        if ([self.flag isEqualToString:@"℃"]) {
            oneminvalue=[NSString stringWithFormat:@"%.1f",onemin];
        }
        minlab.text=oneminvalue;
        minlab.textColor=[UIColor whiteColor];
        minlab.font=[UIFont systemFontOfSize:12];
        minlab.textAlignment=NSTextAlignmentCenter;
        
        if (i==0) {
            NSString *v=self.valuearr[0];
            float fv=v.floatValue;
            if (fv==self.minlowt.floatValue) {
                
            }else
                [self addSubview:minlab];
        }
        [minlab setCenter:CGPointMake(x0, 160)];
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-m_width*i-15, 170, 40, 20)];
        lab.text=self.times[i];
        
        lab.textColor=[UIColor whiteColor];
        lab.font=[UIFont systemFontOfSize:12];
        lab.textAlignment=NSTextAlignmentLeft;
        
        if (i==0) {
             lab.textColor=[UIColor yellowColor];
            [self addSubview:lab];
        }
        
    }
    [[UIColor yellowColor] set];
    CGContextSetLineWidth(currentContext,1.5);
    CGContextStrokePath(currentContext);
    
    for (int i=1; i<self.valuearr.count; i++) {
        NSString  *value=self.valuearr[i];
        float x0=(self.valuearr.count*m_width+20)-m_width*i-8;
        float y0=150;
        if (h>0) {
            y0=150-(value.floatValue-self.minlowt.floatValue)/h;
        }
        if (i==1) {
            
            CGContextMoveToPoint(currentContext, x0, y0);
            
        }else{
            CGContextSetLineDash(currentContext, x0, dash, 0);
            CGContextAddLineToPoint(currentContext, x0 ,y0);
            
        }
        
        UIImage *t_image = [UIImage imageNamed:@"24小时预报表灰色点.png"];
        UIImageView *t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        self.t_img=t_imageView;
        [self addSubview:t_imageView];
        [t_imageView setImage:t_image];
        [t_imageView setCenter:CGPointMake(x0, y0)];
        
        
        UILabel *wdlab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-m_width*i-15, 150, 40, 20)];
        wdlab.text=self.valuearr[i];
        
        wdlab.textColor=[UIColor whiteColor];
        wdlab.font=[UIFont systemFontOfSize:12];
        wdlab.textAlignment=NSTextAlignmentCenter;
     
        if (i%2==0&&i!=1) {
           [self addSubview:wdlab];
        }
        [wdlab setCenter:CGPointMake(x0, y0-10)];
        
        
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-m_width*i-15, 170, 40, 20)];
        lab.text=self.times[i];
        
        lab.textColor=[UIColor whiteColor];
        lab.font=[UIFont systemFontOfSize:12];
        lab.textAlignment=NSTextAlignmentLeft;
        [self addSubview:lab];
        
    }
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(currentContext,1.5);
    CGContextStrokePath(currentContext);
    
    //填充
    CGContextMoveToPoint(currentContext,self.valuearr.count*m_width+m_width, 190-40);
    CGContextAddLineToPoint(currentContext,30,150);
    [[UIColor whiteColor] set];
    CGContextClosePath(currentContext);
    UIColor *c;
    if ([self.flag isEqualToString:@"℃"]) {
        c=[UIColor colorHelpWithRed:178 green:246 blue:104 alpha:0.2];
    }
    if ([self.flag isEqualToString:@"%"]) {
        c=[UIColor colorHelpWithRed:66 green:160 blue:186 alpha:0.2];
    }
    if ([self.flag isEqualToString:@"m"]) {
        c=[UIColor colorHelpWithRed:255 green:255 blue:255 alpha:0.2];
    }
    if ([self.flag isEqualToString:@"mm"]) {
        c=[UIColor colorHelpWithRed:53 green:119 blue:137 alpha:1];
    } 
    CGContextSetFillColorWithColor(currentContext, c.CGColor);
    CGContextSetStrokeColorWithColor(currentContext, c.CGColor);
    for (int i=0; i<self.valuearr.count; i++) {
        NSString  *value=self.valuearr[i];
        float x0=(self.valuearr.count*m_width+20)-m_width*i-8;
        float y0=150-(value.floatValue-self.minlowt.floatValue)/h;
        if (h==0) {
            y0=150;
        }
        
        if (i==0) {
            CGContextMoveToPoint(currentContext, self.valuearr.count*m_width+m_width, 150);
            CGContextAddLineToPoint(currentContext,x0,y0);
        }
        else{
            CGContextAddLineToPoint(currentContext, x0, y0);
        }
        if (i==self.valuearr.count-1) {
            CGContextAddLineToPoint(currentContext,x0,150);
        }
        
    }

    CGContextDrawPath(currentContext, kCGPathFill);
 */
    
}
#pragma mark 加载前面虚线两点
- (void)addBeforeTwoBezierThroughPoints:(NSArray *)pointArray
{
    
    UIBezierPath *mPath = [UIBezierPath bezierPath];
    mPath.lineCapStyle = kCGLineCapRound;//拐弯处为弧线
    mPath.lineJoinStyle = kCGLineJoinRound;
    CGPoint previousPoint = CGPointZero;
    
    CGPoint previousCenterPoint = CGPointZero;
    CGPoint centerPoint = CGPointZero;
    CGFloat centerPointDistance = 0;
    
    CGFloat obliqueAngle = 0;
    
    CGPoint previousControlPoint1 = CGPointZero;
    CGPoint previousControlPoint2 = CGPointZero;
    CGPoint controlPoint1 = CGPointZero;
    CGPoint currentPoint = CGPointZero;
    
    NSString  *value = pointArray[0];
    float v=value.floatValue;
    float x = 0;
    float y = 0;
    float h=(self.maxhight.floatValue-self.minlowt.floatValue)/110;
    x=(self.valuearr.count*m_width+20)-8;
    y=150;
    if (h>0) {
        y=150-(value.floatValue-self.minlowt.floatValue)/h;
    }
    
    currentPoint=CGPointMake(x, y);
    
    [mPath moveToPoint:currentPoint]; //创建一个点
    previousPoint = mPath.currentPoint;
    for (int i = 0; i < pointArray.count; i++) {
        value = pointArray[i];
        v=value.floatValue;
        x=(self.valuearr.count*m_width+20)-m_width*i-8;
        y=150;
        if (h>0) {
            y=150-(value.floatValue-self.minlowt.floatValue)/h;
        }
        CGPoint pointI = CGPointMake(x, y);
        
        if (i > 0) {
            
            previousCenterPoint =[self CenterPointOfWithP1:mPath.currentPoint WithP2:previousPoint];
            if (i==1) {
                previousCenterPoint =[self CenterPointOfWithP1:currentPoint WithP2:previousPoint];
            }
            centerPoint =[self CenterPointOfWithP1:previousPoint WithP2:pointI];
            
            centerPointDistance = [self DistanceBetweenPointWithP1:previousCenterPoint WithP2:centerPoint];
            
            obliqueAngle = [self ObliqueAngleOfStraightThroughPoint1:centerPoint Point2:previousCenterPoint];
            
            previousControlPoint2 = CGPointMake(previousPoint.x - 0.5 * self.contractionFactor * centerPointDistance * cos(obliqueAngle), previousPoint.y - 0.5 * self.contractionFactor * centerPointDistance * sin(obliqueAngle));
            controlPoint1 = CGPointMake(previousPoint.x + 0.5 * self.contractionFactor * centerPointDistance * cos(obliqueAngle), previousPoint.y + 0.5 * self.contractionFactor * centerPointDistance * sin(obliqueAngle));
        }
        if (i == 1) {
            
            [mPath addQuadCurveToPoint:pointI controlPoint:previousControlPoint2];
        }
        
        
        previousControlPoint1 = controlPoint1;
        previousPoint = pointI;
        
        //
        UIImage *t_image = [UIImage imageNamed:@"黄点.png"];
        UIImageView *t_imageView = [self viewWithTag:150 + i];
        if (!t_imageView) {
            t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
            self.t_img=t_imageView;
            t_imageView.tag = 150 + i;
            [self addSubview:t_imageView];
        }
        
        [t_imageView setImage:t_image];
        [t_imageView setCenter:CGPointMake(x, y)];
        
        UILabel *wdlab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-m_width*i-15, 150, 40, 20)];
        wdlab.text=pointArray[i];
        wdlab.textColor=[UIColor whiteColor];
        wdlab.font=[UIFont systemFontOfSize:12];
        wdlab.textAlignment=NSTextAlignmentCenter;
        float newmax=self.maxhight.integerValue;
        NSString *newhight=[NSString stringWithFormat:@"%.1f",newmax];
        if ([self.flag isEqualToString:@"m"]) {
            newhight=[NSString stringWithFormat:@"%.f",newmax];
        }
        
        [wdlab setCenter:CGPointMake(x, y-10)];
        if (i==0) {
            [wdlab setCenter:CGPointMake(x, y-10)];
            wdlab.font=[UIFont systemFontOfSize:12];
            //            if (![nows[0] isEqualToString:newhight]) {
            [self addSubview:wdlab];
            //            }
        }
        UILabel *maxlab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-15, 150, 40, 20)];
        float onemax=self.maxhight.floatValue;
        NSString *onemaxvalue=[NSString stringWithFormat:@"%.f",onemax];
        if ([self.flag isEqualToString:@"℃"]) {
            onemaxvalue=[NSString stringWithFormat:@"%.1f",onemax];
        }
        maxlab.text=onemaxvalue;
        maxlab.textColor=[UIColor whiteColor];
        maxlab.font=[UIFont systemFontOfSize:12];
        maxlab.textAlignment=NSTextAlignmentCenter;
        
        if (i==0) {
            NSString *v=self.valuearr[0];
            float fv=v.floatValue;
            if (fv==self.maxhight.floatValue) {
                
            }else
                [self addSubview:maxlab];
        }
        [maxlab setCenter:CGPointMake(x, 22)];
        UILabel *minlab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-15, 150, 40, 20)];
        float onemin=self.minlowt.floatValue;
        NSString *oneminvalue=[NSString stringWithFormat:@"%.f",onemin];
        if ([self.flag isEqualToString:@"℃"]) {
            oneminvalue=[NSString stringWithFormat:@"%.1f",onemin];
        }
        minlab.text=oneminvalue;
        minlab.textColor=[UIColor whiteColor];
        minlab.font=[UIFont systemFontOfSize:12];
        minlab.textAlignment=NSTextAlignmentCenter;
        
        if (i==0) {
            NSString *v=self.valuearr[0];
            float fv=v.floatValue;
            if (fv==self.minlowt.floatValue) {
                
            }else
                [self addSubview:minlab];
        }
        [minlab setCenter:CGPointMake(x, 160)];
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-m_width*i-15, 170, 40, 20)];
        lab.text=self.times[i];
        
        lab.textColor=[UIColor whiteColor];
        lab.font=[UIFont systemFontOfSize:12];
        lab.textAlignment=NSTextAlignmentLeft;
        
        if (i==0) {
            lab.textColor=[UIColor yellowColor];
            [self addSubview:lab];
        }
    }
    CAShapeLayer *clay = [CAShapeLayer layer];
    clay.strokeColor = [UIColor yellowColor].CGColor;
    clay.fillColor = nil;
    clay.lineDashPattern = @[@2, @5];
    clay.lineWidth = 1.5;
    clay.path = mPath.CGPath;
    clay.lineCap = kCALineCapRound;
    clay.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:clay];
    [clay setAllowsEdgeAntialiasing:YES];
    [clay setAllowsGroupOpacity:YES];
    
//    for (int i=0; i<pointArray.count; i++) {
//        UILabel *wdlab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-m_width*i-15, 150, 40, 20)];
//        wdlab.text=pointArray[i];
//        wdlab.textColor=[UIColor whiteColor];
//        wdlab.font=[UIFont systemFontOfSize:12];
//        wdlab.textAlignment=NSTextAlignmentCenter;
//        float newmax=self.maxhight.integerValue;
//        NSString *newhight=[NSString stringWithFormat:@"%.1f",newmax];
//        if ([self.flag isEqualToString:@"m"]) {
//            newhight=[NSString stringWithFormat:@"%.f",newmax];
//        }
//        
//        [wdlab setCenter:CGPointMake(x, y-10)];
//        if (i==0) {
//            [wdlab setCenter:CGPointMake(x, y-10)];
//            wdlab.font=[UIFont systemFontOfSize:12];
//            //            if (![nows[0] isEqualToString:newhight]) {
//            [self addSubview:wdlab];
//            //            }
//        }
//        UILabel *maxlab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-15, 150, 40, 20)];
//        float onemax=self.maxhight.floatValue;
//        NSString *onemaxvalue=[NSString stringWithFormat:@"%.f",onemax];
//        if ([self.flag isEqualToString:@"℃"]) {
//            onemaxvalue=[NSString stringWithFormat:@"%.1f",onemax];
//        }
//        maxlab.text=onemaxvalue;
//        maxlab.textColor=[UIColor whiteColor];
//        maxlab.font=[UIFont systemFontOfSize:12];
//        maxlab.textAlignment=NSTextAlignmentCenter;
//        
//        if (i==0) {
//            NSString *v=self.valuearr[0];
//            float fv=v.floatValue;
//            if (fv==self.maxhight.floatValue) {
//                
//            }else
//                [self addSubview:maxlab];
//        }
//        [maxlab setCenter:CGPointMake(x, 22)];
//        UILabel *minlab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-15, 150, 40, 20)];
//        float onemin=self.minlowt.floatValue;
//        NSString *oneminvalue=[NSString stringWithFormat:@"%.f",onemin];
//        if ([self.flag isEqualToString:@"℃"]) {
//            oneminvalue=[NSString stringWithFormat:@"%.1f",onemin];
//        }
//        minlab.text=oneminvalue;
//        minlab.textColor=[UIColor whiteColor];
//        minlab.font=[UIFont systemFontOfSize:12];
//        minlab.textAlignment=NSTextAlignmentCenter;
//        
//        if (i==0) {
//            NSString *v=self.valuearr[0];
//            float fv=v.floatValue;
//            if (fv==self.minlowt.floatValue) {
//                
//            }else
//                [self addSubview:minlab];
//        }
//        [minlab setCenter:CGPointMake(x, 160)];
//        
//        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-m_width*i-15, 170, 40, 20)];
//        lab.text=self.times[i];
//        
//        lab.textColor=[UIColor whiteColor];
//        lab.font=[UIFont systemFontOfSize:12];
//        lab.textAlignment=NSTextAlignmentLeft;
//        
//        if (i==0) {
//            lab.textColor=[UIColor yellowColor];
//            [self addSubview:lab];
//        }
//    }
}
#pragma mark 虚线后面数据曲线
- (void)addBezierThroughPoints:(NSArray *)pointArray
{
    
    UIBezierPath *mPath = [UIBezierPath bezierPath];
    mPath.lineCapStyle = kCGLineCapRound;//拐弯处为弧线
    mPath.lineJoinStyle = kCGLineJoinRound;
    CGPoint previousPoint = CGPointZero;
    
    CGPoint previousCenterPoint = CGPointZero;
    CGPoint centerPoint = CGPointZero;
    CGFloat centerPointDistance = 0;
    
    CGFloat obliqueAngle = 0;
    
    CGPoint previousControlPoint1 = CGPointZero;
    CGPoint previousControlPoint2 = CGPointZero;
    CGPoint controlPoint1 = CGPointZero;
    CGPoint currentPoint = CGPointZero;
    
    NSString  *value = pointArray[1];
    float v=value.floatValue;
    float x = 0;
    float y = 0;
    float h=(self.maxhight.floatValue-self.minlowt.floatValue)/110;
    x=(self.valuearr.count*m_width+20)-m_width-8;
    y=150;
    if (h>0) {
        y=150-(value.floatValue-self.minlowt.floatValue)/h;
    }
 
    currentPoint=CGPointMake(x, y);
    
    [mPath moveToPoint:currentPoint]; //创建一个点
    previousPoint = mPath.currentPoint;
    for (int i = 1; i < pointArray.count; i++) {
        value = pointArray[i];
        v=value.floatValue;
        x=(self.valuearr.count*m_width+20)-m_width*i-8;
        y=150;
        if (h>0) {
            y=150-(value.floatValue-self.minlowt.floatValue)/h;
        }
      
        CGPoint pointI = CGPointMake(x, y);
        
        if (i > 1) {
            
            previousCenterPoint =[self CenterPointOfWithP1:mPath.currentPoint WithP2:previousPoint];
            if (i==2) {
                previousCenterPoint =[self CenterPointOfWithP1:currentPoint WithP2:previousPoint];
            }
            centerPoint =[self CenterPointOfWithP1:previousPoint WithP2:pointI];
            
            centerPointDistance = [self DistanceBetweenPointWithP1:previousCenterPoint WithP2:centerPoint];
            
            obliqueAngle = [self ObliqueAngleOfStraightThroughPoint1:centerPoint Point2:previousCenterPoint];
            self.liney=y;
            previousControlPoint2 = CGPointMake(previousPoint.x - 0.5 * self.contractionFactor * centerPointDistance * cos(obliqueAngle), previousPoint.y - 0.5 * self.contractionFactor * centerPointDistance * sin(obliqueAngle));
            controlPoint1 = CGPointMake(previousPoint.x + 0.5 * self.contractionFactor * centerPointDistance * cos(obliqueAngle), previousPoint.y + 0.5 * self.contractionFactor * centerPointDistance * sin(obliqueAngle));
        }
        if (i == 2) {
            
            [mPath addQuadCurveToPoint:previousPoint controlPoint:previousControlPoint2];
        }
        else if (i > 2 && i < pointArray.count - 1) {
            
            [mPath addCurveToPoint:previousPoint controlPoint1:previousControlPoint1 controlPoint2:previousControlPoint2];
        }
        if (i == pointArray.count - 1) {
            
            [mPath addCurveToPoint:previousPoint controlPoint1:previousControlPoint1 controlPoint2:previousControlPoint2];
            [mPath addQuadCurveToPoint:pointI controlPoint:controlPoint1];
        }
        
        
        previousControlPoint1 = controlPoint1;
        previousPoint = pointI;
        
        //
        UIImage *t_image = [UIImage imageNamed:@"24小时预报表灰色点.png"];
        UIImageView *t_imageView = [self viewWithTag:150 + i];
        if (!t_imageView) {
            t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
            self.t_img=t_imageView;
            t_imageView.tag = 150 + i;
            [self addSubview:t_imageView];
        }
        
        [t_imageView setImage:t_image];
        [t_imageView setCenter:CGPointMake(x, y)];
        UILabel *wdlab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-m_width*i-15, 150, 40, 20)];
        wdlab.text=self.valuearr[i];
        
        wdlab.textColor=[UIColor whiteColor];
        wdlab.font=[UIFont systemFontOfSize:12];
        wdlab.textAlignment=NSTextAlignmentCenter;
        
        if (i%2==0&&i!=1) {
            [self addSubview:wdlab];
        }
        [wdlab setCenter:CGPointMake(x, y-10)];
        
        
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake((self.valuearr.count*m_width+20)-m_width*i-15, 170, 40, 20)];
        lab.text=self.times[i];
        
        lab.textColor=[UIColor whiteColor];
        lab.font=[UIFont systemFontOfSize:12];
        lab.textAlignment=NSTextAlignmentLeft;
        [self addSubview:lab];
    }
    CAShapeLayer *clay = [CAShapeLayer layer];
    clay.strokeColor = [UIColor whiteColor].CGColor;
    
    clay.fillColor = nil;
    clay.lineWidth = 1.5;
    clay.path = mPath.CGPath;
    clay.lineCap = kCALineCapRound;
    clay.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:clay];
    [clay setAllowsEdgeAntialiasing:YES];
    [clay setAllowsGroupOpacity:YES];
  
}
#pragma mark 填充
- (void)addFullPoints:(NSArray *)pointArray
{
    
    UIBezierPath *mPath = [UIBezierPath bezierPath];
    mPath.lineCapStyle = kCGLineCapRound;//拐弯处为弧线
    mPath.lineJoinStyle = kCGLineJoinRound;
    CGPoint previousPoint = CGPointZero;
    
    CGPoint previousCenterPoint = CGPointZero;
    CGPoint centerPoint = CGPointZero;
    CGFloat centerPointDistance = 0;
    
    CGFloat obliqueAngle = 0;
    
    CGPoint previousControlPoint1 = CGPointZero;
    CGPoint previousControlPoint2 = CGPointZero;
    CGPoint controlPoint1 = CGPointZero;
    CGPoint currentPoint = CGPointZero;
    
    NSString  *value = pointArray[1];
    float v=value.floatValue;
    float x = 0;
    float y = 0;
    float h=(self.maxhight.floatValue-self.minlowt.floatValue)/110;
    x=(self.valuearr.count*m_width+20)-8;
    y=150;
    if (h>0) {
        y=150-(value.floatValue-self.minlowt.floatValue)/h;
    }
    
    currentPoint=CGPointMake(x, y);
    
    [mPath moveToPoint:CGPointMake(x, 150)]; //创建一个点
    [mPath addLineToPoint:CGPointMake(x,y)];
    previousPoint = mPath.currentPoint;
    for (int i = 0; i < pointArray.count; i++) {
        value = pointArray[i];
        v=value.floatValue;
        x=(self.valuearr.count*m_width+20)-m_width*i-8;
        y=150;
        if (h>0) {
            y=150-(value.floatValue-self.minlowt.floatValue)/h;
        }
     
        CGPoint pointI = CGPointMake(x, y);
        
        if (i > 0 ){
            
            previousCenterPoint =[self CenterPointOfWithP1:mPath.currentPoint WithP2:previousPoint];
            if (i==1) {
                previousCenterPoint =[self CenterPointOfWithP1:currentPoint WithP2:previousPoint];
            }
            centerPoint =[self CenterPointOfWithP1:previousPoint WithP2:pointI];
            
            centerPointDistance = [self DistanceBetweenPointWithP1:previousCenterPoint WithP2:centerPoint];
            
            obliqueAngle = [self ObliqueAngleOfStraightThroughPoint1:centerPoint Point2:previousCenterPoint];
            self.fully=y;
            previousControlPoint2 = CGPointMake(previousPoint.x - 0.5 * self.contractionFactor * centerPointDistance * cos(obliqueAngle), previousPoint.y - 0.5 * self.contractionFactor * centerPointDistance * sin(obliqueAngle));
            controlPoint1 = CGPointMake(previousPoint.x + 0.5 * self.contractionFactor * centerPointDistance * cos(obliqueAngle), previousPoint.y + 0.5 * self.contractionFactor * centerPointDistance * sin(obliqueAngle));
        }
        if (i == 1) {
            
            [mPath addQuadCurveToPoint:previousPoint controlPoint:previousControlPoint2];
        }
        else if (i > 1 && i < pointArray.count - 1) {
            
            [mPath addCurveToPoint:previousPoint controlPoint1:previousControlPoint1 controlPoint2:previousControlPoint2];
        }
        if (i == pointArray.count - 1) {
            
            [mPath addCurveToPoint:previousPoint controlPoint1:previousControlPoint1 controlPoint2:previousControlPoint2];
            [mPath addQuadCurveToPoint:pointI controlPoint:controlPoint1];
//            [mPath addLineToPoint:CGPointMake(self.valuearr.count*m_width+m_width, 150)];
            [mPath addLineToPoint:CGPointMake(pointI.x, 150)];
        }
        
        
        previousControlPoint1 = controlPoint1;
        previousPoint = pointI;
        
       
        
    }
    UIColor *c;
    if ([self.flag isEqualToString:@"℃"]) {
        c=[UIColor colorHelpWithRed:178 green:246 blue:104 alpha:0.2];
    }
    if ([self.flag isEqualToString:@"%"]) {
        c=[UIColor colorHelpWithRed:66 green:160 blue:186 alpha:0.2];
    }
    if ([self.flag isEqualToString:@"m"]) {
        c=[UIColor colorHelpWithRed:255 green:255 blue:255 alpha:0.2];
    }
    if ([self.flag isEqualToString:@"mm"]) {
        c=[UIColor colorHelpWithRed:53 green:119 blue:137 alpha:0.6];
    }
    CAShapeLayer *clay = [CAShapeLayer layer];
    clay.strokeColor =c.CGColor;
    
    clay.fillColor =c.CGColor;
    clay.lineWidth = 0.1;
    clay.path = mPath.CGPath;
    clay.lineCap = kCALineCapRound;
    clay.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:clay];
    [clay setAllowsEdgeAntialiasing:YES];
    [clay setAllowsGroupOpacity:YES];
}
-(CGFloat) ObliqueAngleOfStraightThroughPoint1:(CGPoint)point1 Point2:(CGPoint) point2   //  [-π/2, 3π/2)
{
    CGFloat obliqueRatio = 0;
    CGFloat obliqueAngle = 0;
    
    if (point1.x > point2.x) {
        
        obliqueRatio = (point2.y - point1.y) / (point2.x - point1.x);
        obliqueAngle = atan(obliqueRatio);
    }
    else if (point1.x < point2.x) {
        
        obliqueRatio = (point2.y - point1.y) / (point2.x - point1.x);
        obliqueAngle = M_PI + atan(obliqueRatio);
    }
    else if (point2.y - point1.y >= 0) {
        
        obliqueAngle = M_PI/2;
    }
    else {
        obliqueAngle = -M_PI/2;
    }
//    NSLog(@"弧度%f",obliqueAngle);
    return obliqueAngle;
}

-(CGPoint) ControlPointForTheBezierCanThrough3PointWithP1:(CGPoint) point1 WithP2:( CGPoint) point2 WithP3:( CGPoint) point3
{
    return CGPointMake(2 * point2.x - (point1.x + point3.x) / 2, 2 * point2.y - (point1.y + point3.y) / 2);
}

-(CGFloat) DistanceBetweenPointWithP1:(CGPoint) point1 WithP2:( CGPoint) point2
{
    return sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
}

-(CGPoint) CenterPointOfWithP1:(CGPoint) point1 WithP2:( CGPoint) point2
{
    return CGPointMake((point1.x + point2.x) / 2, (point1.y + point2.y) / 2);
}
- (CGFloat)contractionFactor
{
    id contractionFactorAssociatedObject = objc_getAssociatedObject(self, @selector(contractionFactor));
    if (contractionFactorAssociatedObject == nil) {
//        NSLog(@"%f",self.obrandious);
        if (self.fully==150||self.liney==150) {
            return 0.1;
        }else
        return 0.5;
    }
    return [contractionFactorAssociatedObject floatValue];
}
- (void)setContractionFactor:(CGFloat)contractionFactor
{
    objc_setAssociatedObject(self, @selector(contractionFactor), @(contractionFactor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
