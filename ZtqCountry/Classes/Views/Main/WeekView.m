//
//  WeekView.m
//  ztqFj
//
//  Created by Admin on 15/3/4.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "WeekView.h"
#import <objc/runtime.h>
@implementation WeekView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor clearColor];
//        [self setNeedsDisplay];
    }
    return self;
}
-(void)gethights:(NSArray *)hights Withlowts:(NSArray *)lowts Withmax:(float)maxhight Withmin:(float)minlowt{
    
    self.valuearr=hights;
    self.lowarr=lowts;
    self.maxhight=maxhight+2;//最值多个1位像素
    self.minlowt=minlowt-5;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.hightlay removeFromSuperlayer];
    [self.lowlay removeFromSuperlayer];
//    NSArray *hights=[[NSArray alloc]initWithObjects:self.valuearr[0],self.valuearr[1], nil];
//    NSArray *lowts=[[NSArray alloc]initWithObjects:self.lowarr[0],self.lowarr[1], nil];
//    //开始自绘图形
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    //关闭抗锯齿
//    CGContextSetAllowsAntialiasing(currentContext, true);
//    CGFloat dash[] = {0, 0};
//    for (NSInteger i=0; i<4; i++)
//    {//横轴实线 间隔23像素
//        CGContextMoveToPoint(currentContext, 35, 30+ i * 30);
//        CGContextAddLineToPoint(currentContext, 35 + 50 * 5.4, 30 + i * 30);
//    }
    //轴线
//    CGContextMoveToPoint(currentContext, 35, 30+ 3 * 30);
//    CGContextAddLineToPoint(currentContext, 35 + 50 * 5.4, 30 + 3 * 30);
//    [[UIColor whiteColor] set];
//    CGContextSetLineWidth(currentContext, 0.5);
//    CGContextStrokePath(currentContext);
//    //纵轴
//    CGContextMoveToPoint(currentContext, 35, 0 );
//    CGContextAddLineToPoint(currentContext, 35 ,120);
//    [[UIColor whiteColor] set];
//    CGContextSetLineWidth(currentContext, 0.5);
//    CGContextStrokePath(currentContext);
//    
//    
//    UILabel *h_yestodaylab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 40, 20)];
//    h_yestodaylab.text=self.valuearr[0];
//    h_yestodaylab.textColor=[UIColor whiteColor];
//    h_yestodaylab.font=[UIFont systemFontOfSize:12];
//    [self addSubview:h_yestodaylab];
//    UILabel *l_yestodaylab=[[UILabel alloc]initWithFrame:CGRectMake(10, 75, 40, 20)];
//    l_yestodaylab.text=self.lowarr[0];
//    l_yestodaylab.textColor=[UIColor whiteColor];
//    l_yestodaylab.font=[UIFont systemFontOfSize:12];
//    [self addSubview:l_yestodaylab];
    
    [self addHigthTempPoints:self.valuearr];
    [self addLowTempPoints:self.lowarr];
    
//    float cha=self.maxhight-self.minlowt;
//    float chushu=cha/90;
////    NSLog(@"*******%f",chajishu);
//    //前面2点虚线
//    for (int j=0; j<hights.count; j++) {
//        NSString  *value =hights[j];
//        float v=value.floatValue;
//        NSInteger x = 0;
//        NSInteger y = 0;
//        
//        
////        NSString *low=lowts[0];
////        float l=low.floatValue;
//        x=45.7*j+23.5;
//        y=100-(v-self.minlowt)/chushu;
//        //        NSLog(@"%f..%f",self.frame.size.height,self.frame.size.width);
//        UILabel *valuelab = [self viewWithTag:500 + j];
//        if (!valuelab) {
//            valuelab =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 18)];
//            valuelab.textColor=[UIColor whiteColor];
//            valuelab.font=[UIFont systemFontOfSize:13];
//            [self addSubview:valuelab];
//            valuelab.tag = 500 + j;
//        }
//        [valuelab setCenter:CGPointMake(x+15, y-15)];
//        valuelab.text= [NSString stringWithFormat:@"%@°", value];
//        
//        if (j==0) {
//            
//            CGContextSetLineDash(currentContext, x, dash, 2);
//            CGContextMoveToPoint(currentContext, x, y);
//            
//        }else{
////            CGContextAddQuadCurveToPoint(currentContext,x-30,y+50,x,y);
//            CGContextAddLineToPoint(currentContext, x, y);
//            
//        }
//        
//        UIImage *t_image = [UIImage imageNamed:@"一周趋势橙色点.png"];
//        
//        UIImageView *t_imageView = [self viewWithTag:550 + j];
//        if (!t_imageView) {
//            t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
//            [self addSubview:t_imageView];
//            
//            [t_imageView setImage:t_image];
//            t_imageView.tag = 550 + j;
//        }
//        [t_imageView setCenter:CGPointMake(x, y)];
//        
//        
//        
//    }
//    
//    [[UIColor orangeColor] set];
//    CGContextSetLineWidth(currentContext,2);
//    CGContextStrokePath(currentContext);
//    
//    //低温虚线
//    for (int j=0; j<lowts.count; j++) {
//        NSString  *value =lowts[j];
//        float v=value.floatValue;
//        NSInteger x = 0;
//        NSInteger y = 0;
//        
//        
////        NSString *low=lowts[0];
////        float l=low.floatValue;
//        x=45.7*j+23.5;
//        y=100-(v-self.minlowt)/chushu;
//        //        NSLog(@"%f..%f",self.frame.size.height,self.frame.size.width);
//        UILabel *valuelab = [self viewWithTag:600 + j];
//        if (!valuelab) {
//            valuelab =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 18)];
//            valuelab.textColor=[UIColor whiteColor];
//            valuelab.font=[UIFont systemFontOfSize:13];
//            [self addSubview:valuelab];
//            valuelab.tag = 600 + j;
//        }
//        [valuelab setCenter:CGPointMake(x+17, y +15)];
//        valuelab.text= [NSString stringWithFormat:@"%@°", value];
//
//        
//        if (j==0) {
//            
//            CGContextSetLineDash(currentContext, x, dash, 2);
//            CGContextMoveToPoint(currentContext, x, y);
//            
//            
//        }else{
//            
//            CGContextAddLineToPoint(currentContext, x, y);
//            
//            
//        }
//        UIImage *t_image = [UIImage imageNamed:@"一周趋势蓝点.png"];
//        UIImageView *t_imageView = [self viewWithTag:650 + j];
//        if (!t_imageView) {
//            t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
//            [self addSubview:t_imageView];
//            
//            [t_imageView setImage:t_image];
//            t_imageView.tag = 650 + j;
//        }
//        [t_imageView setCenter:CGPointMake(x, y)];
//        
//        
//    }
//    
//    [[UIColor colorHelpWithRed:24 green:119 blue:192 alpha:1] set];
//    CGContextSetLineWidth(currentContext,2);
//    CGContextStrokePath(currentContext);
//    
//    for (int j=1; j<self.valuearr.count; j++) {
//        NSString  *value = self.valuearr[j];
//        float v=value.floatValue;
//        NSInteger x = 0;
//        NSInteger y = 0;
//  
//        
////        NSString *low=self.lowarr[0];
////        float l=low.floatValue;
//        x=45.7*j+23.5;
//        y=100-(v-self.minlowt)/chushu;
//        //        NSLog(@"%f..%f",self.frame.size.height,self.frame.size.width);
//        if (j==1) {
//            
////            CGContextSetLineDash(currentContext, x, dash, 1);
//            CGContextMoveToPoint(currentContext, x, y);
//            
//        }else{
//            CGContextSetLineDash(currentContext, 0, dash, 0);
//            CGContextAddLineToPoint(currentContext, x, y);
//            
//            
//            UILabel *valuelab = [self viewWithTag:700 + j];
//            if (!valuelab) {
//                valuelab  =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 18)];
//               
//                valuelab.textColor=[UIColor whiteColor];
//                valuelab.font=[UIFont systemFontOfSize:13];
//                [self addSubview:valuelab];
//                valuelab.tag = 700 + j;
//                
//            }
//            [valuelab setCenter:CGPointMake(x+15, y-15)];
//            valuelab.text= [NSString stringWithFormat:@"%@°", value];
//        }
//        UIImage *t_image = [UIImage imageNamed:@"一周趋势橙色点.png"];
//
//        
//        UIImageView *t_imageView = [self viewWithTag:750 + j];
//        if (!t_imageView) {
//            t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
//            [self addSubview:t_imageView];
//            
//            [t_imageView setImage:t_image];
//            t_imageView.tag = 750 + j;
//        }
//        [t_imageView setCenter:CGPointMake(x, y)];
//
//        
//        
//    }
//    
//    [[UIColor orangeColor] set];
//    CGContextSetLineWidth(currentContext, 2);
//    CGContextStrokePath(currentContext);
//    
//    for (int i=1; i<self.lowarr.count; i++) {
//        NSString  *value = self.lowarr[i];
//        float v=value.floatValue;
//        NSInteger x1 = 0;
//        NSInteger y1 = 0;
//        
////        NSString *low=self.lowarr[0];
////        float l=low.floatValue;
//        x1=45.7*i+23.5;
//        y1=100-(v-self.minlowt)/chushu;
//        //        NSLog(@"%f..%f",self.frame.size.height,self.frame.size.width);
//        if (i==1) {
//            CGContextMoveToPoint(currentContext, x1, y1);
//            
//        }else{
//            CGContextAddLineToPoint(currentContext, x1, y1);
//            UILabel *valuelab = [self viewWithTag:800 + i];
//            if (!valuelab) {
//                valuelab  =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 18)];
//                
//                valuelab.textColor=[UIColor whiteColor];
//                valuelab.font=[UIFont systemFontOfSize:13];
//                [self addSubview:valuelab];
//                valuelab.tag = 800 + i;
//                
//            }
//            [valuelab setCenter:CGPointMake(x1+15, y1+15)];
//            valuelab.text= [NSString stringWithFormat:@"%@°", value];
//        }
//        
//        UIImage *t_image = [UIImage imageNamed:@"一周趋势蓝点.png"];
//        UIImageView *t_imageView = [self viewWithTag:850 + i];
//        if (!t_imageView) {
//            t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
//            [self addSubview:t_imageView];
//            
//            [t_imageView setImage:t_image];
//            t_imageView.tag = 850 + i;
//        }
//        [t_imageView setCenter:CGPointMake(x1, y1)];
//        
//    }
//    
//    [[UIColor colorHelpWithRed:24 green:119 blue:192 alpha:1] set];
//    CGContextSetLineWidth(currentContext, 2);
//    CGContextStrokePath(currentContext);
}
- (void)addHigthTempPoints:(NSArray *)pointArray
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
    float cha=self.maxhight-self.minlowt;
    float chushu=cha/90;
    float space =self.width/7;
    NSString  *value = pointArray[0];
    float v=value.floatValue;
    float x = 0;
    float y = 0;
    x=space/2;
    y=100-(v-self.minlowt)/chushu;
    if (chushu==0) {
        y=100;
    }
    currentPoint=CGPointMake(x, y);
    [mPath moveToPoint:currentPoint]; //创建一个点
    previousPoint = mPath.currentPoint;
    for (int i = 0; i < pointArray.count; i++) {
        value = pointArray[i];
        v=value.floatValue;
        x = 0;
        y = 0;
        x=space/2+space*i;
        y=100-(v-self.minlowt)/chushu;
        if (chushu==0) {
            y=100;
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
            
            [mPath addQuadCurveToPoint:previousPoint controlPoint:previousControlPoint2];
        }
        else if (i > 1 && i < pointArray.count - 1) {
            
            [mPath addCurveToPoint:previousPoint controlPoint1:previousControlPoint1 controlPoint2:previousControlPoint2];
        }
        if (i == pointArray.count - 1) {
            
            [mPath addCurveToPoint:previousPoint controlPoint1:previousControlPoint1 controlPoint2:previousControlPoint2];
            [mPath addQuadCurveToPoint:pointI controlPoint:controlPoint1];
        }
        
        
        previousControlPoint1 = controlPoint1;
        previousPoint = pointI;
        
        UILabel *valuelab = [self viewWithTag:500 + i];
        if (!valuelab) {
            valuelab =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 18)];
            valuelab.textColor=[UIColor orangeColor];
            valuelab.font=[UIFont systemFontOfSize:13];
            [self addSubview:valuelab];
            valuelab.tag = 500 + i;
        }
        [valuelab setCenter:CGPointMake(x+15, y-15)];
        valuelab.text= [NSString stringWithFormat:@"%@°", value];

        
        UIImage *t_image = [UIImage imageNamed:@"一周趋势橙色点.png"];
        
        UIImageView *t_imageView = [self viewWithTag:550 + i];
        if (!t_imageView) {
            t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
            [self addSubview:t_imageView];
            
            [t_imageView setImage:t_image];
            t_imageView.tag = 550 + i;
        }
        [t_imageView setCenter:CGPointMake(x, y)];
    }
    CAShapeLayer *clay = [CAShapeLayer layer];
    self.hightlay=clay;
    clay.strokeColor = [UIColor orangeColor].CGColor;
    clay.fillColor = nil;
    clay.lineWidth = 1.5;
    clay.path = mPath.CGPath;
    clay.lineCap = kCALineCapRound;
    clay.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:clay];
    //    self.layer.shouldRasterize = YES;
    [clay setAllowsEdgeAntialiasing:YES];
    [clay setAllowsGroupOpacity:YES];
}
- (void)addLowTempPoints:(NSArray *)pointArray
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
    float cha=self.maxhight-self.minlowt;
    float chushu=cha/90;
    float space =self.width/7;
    NSString  *value = pointArray[0];
    float v=value.floatValue;
    float x = 0;
    float y = 0;
    x=space/2;
    y=100-(v-self.minlowt)/chushu;
    if (chushu==0) {
        y=100;
    }
    currentPoint=CGPointMake(x, y);
    [mPath moveToPoint:currentPoint]; //创建一个点
    previousPoint = mPath.currentPoint;
    for (int i = 0; i < pointArray.count; i++) {
        value = pointArray[i];
        v=value.floatValue;
        x = 0;
        y = 0;
        x=space/2+space*i;
        y=100-(v-self.minlowt)/chushu;
        if (chushu==0) {
            y=100;
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
            
            [mPath addQuadCurveToPoint:previousPoint controlPoint:previousControlPoint2];
        }
        else if (i > 1 && i < pointArray.count - 1) {
            
            [mPath addCurveToPoint:previousPoint controlPoint1:previousControlPoint1 controlPoint2:previousControlPoint2];
        }
        if (i == pointArray.count - 1) {
            
            [mPath addCurveToPoint:previousPoint controlPoint1:previousControlPoint1 controlPoint2:previousControlPoint2];
            [mPath addQuadCurveToPoint:pointI controlPoint:controlPoint1];
        }
        
        
        previousControlPoint1 = controlPoint1;
        previousPoint = pointI;
        
        
        UILabel *valuelab = [self viewWithTag:600 + i];
        if (!valuelab) {
            valuelab =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 18)];
            valuelab.textColor=[UIColor colorHelpWithRed:0 green:204 blue:255 alpha:1];
            valuelab.font=[UIFont systemFontOfSize:13];
            [self addSubview:valuelab];
            valuelab.tag = 600 + i;
        }
        [valuelab setCenter:CGPointMake(x+17, y +15)];
        valuelab.text= [NSString stringWithFormat:@"%@°", value];
        
        UIImage *t_image = [UIImage imageNamed:@"一周趋势蓝点.png"];
        UIImageView *t_imageView = [self viewWithTag:650 + i];
        if (!t_imageView) {
            t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
            [self addSubview:t_imageView];
            
            [t_imageView setImage:t_image];
            t_imageView.tag = 650 + i;
        }
        [t_imageView setCenter:CGPointMake(x, y)];
    }
    CAShapeLayer *clay = [CAShapeLayer layer];
    self.lowlay=clay;
    clay.strokeColor = [UIColor colorHelpWithRed:0 green:204 blue:255 alpha:1].CGColor;
    clay.fillColor = nil;
    clay.lineWidth = 1.5;
    clay.path = mPath.CGPath;
    clay.lineCap = kCALineCapRound;
    clay.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:clay];
    //    self.layer.shouldRasterize = YES;
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
        return 0.7;
    }
    return [contractionFactorAssociatedObject floatValue];
}
- (void)setContractionFactor:(CGFloat)contractionFactor
{
    objc_setAssociatedObject(self, @selector(contractionFactor), @(contractionFactor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
