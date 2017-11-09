//
//  HourWtScrollview.m
//  ZtqCountry
//
//  Created by Admin on 15/7/15.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "HourWtScrollview.h"
#import <objc/runtime.h>
@implementation HourWtScrollview
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor clearColor];
        
    }
    return self;
}
- (NSMutableArray *)windValues {
    if (_windValues == nil) {
        _windValues = [NSMutableArray array];
    }
    return _windValues;
}

- (NSMutableArray *)windDircationValues {
    if (_windDircationValues == nil) {
        _windDircationValues = [NSMutableArray array];
    }
    return _windDircationValues;
}

- (NSMutableArray *)weatherValues {
    if (_weatherValues == nil) {
        _weatherValues = [NSMutableArray array];
    }
    return _weatherValues;
}


-(void)gethights:(NSArray *)wd Withicons:(NSArray *)icons withtimes:(NSArray *)times Withmax:(NSString *)maxhight Withmin:(NSString *)minlowt withnowct:(NSString *)ct withrains:(NSArray *)rains withrainmax:(NSString *)rainmax withrainmin:(NSString *)rainmin withWeatherValue:(NSMutableArray *)weatherValues winddir:(NSMutableArray *)winddir windpow:(NSMutableArray *)windpow{
    self.valuearr=wd;
    self.icons=icons;
    self.times=times;
    self.maxhight=maxhight;//最值多个1位像素
    self.minlowt=minlowt;
    self.nowct=ct;
    self.rains=rains;
    self.maxrain=rainmax;
    self.minrain=rainmin;
    if (ct.floatValue<minlowt.floatValue) {
        self.minlowt=ct;
    }
    if (ct.floatValue>maxhight.floatValue) {
        self.maxhight=ct;
    }
    NSString *v=self.valuearr[0];
    float h=(self.maxhight.floatValue-self.minlowt.floatValue)/100;
    float y=170-(v.floatValue-self.minlowt.floatValue)/h;
    self.nextvalue=y;
    self.weatherValues  = weatherValues;
    self.windDircationValues = winddir;
    self.windValues = windpow;
    
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.templay removeFromSuperlayer];
    [self.rainlay removeFromSuperlayer];
    if (self.maxhight.length<=0||self.minlowt.length<=0) {
        return;
    }
    //开始自绘图形
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //关闭抗锯齿
    CGContextSetAllowsAntialiasing(currentContext, true);
    CGFloat dash[] = {0, 0};
    

   
    //当前虚线
    float h=(self.maxhight.floatValue-self.minlowt.floatValue)/80;
    float h1=(self.maxrain.floatValue-self.minrain.floatValue)/30;

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 2);
    //画底线
//    CGContextMoveToPoint(context, 80, 170);
//    CGContextAddLineToPoint(context,1070,170);
//    [[UIColor whiteColor] set];
//    CGContextClosePath(context);
    
//    //雨量曲线
    NSMutableArray *newrains=[[NSMutableArray alloc]initWithArray:self.rains];
    [self addRainBezierThroughPoints:newrains];
    //
//    CGContextSetFillColorWithColor(context, [UIColor colorHelpWithRed:53 green:119 blue:137 alpha:0.6].CGColor);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor colorHelpWithRed:53 green:119 blue:137 alpha:0.6].CGColor);
//////    NSMutableArray *newrains=[[NSMutableArray alloc]initWithArray:self.rains];
//////    [newrains insertObject:@"0.0" atIndex:self.rains.count];
//    for (int i=0; i<newrains.count; i++) {
//        NSString  *value=newrains[i];
//        float x0=45*i+30;
//        float y0=190-(value.floatValue-self.minrain.floatValue)/h1;
//        if (h1==0) {
//            y0=190;
//        }
//
//        if (i==0) {
//            CGContextMoveToPoint(context, 0, 190);
//            CGContextAddLineToPoint(context,x0,y0);
//        }
//        else{
//            CGContextAddLineToPoint(context, x0, y0);
//        }
//        if (i==newrains.count-1) {
////            CGContextMoveToPoint(context, x0, y0);
//            CGContextAddLineToPoint(context,x0,190);
//        }
//        UILabel *rainlab = [self viewWithTag:100+ i];
//        if (rainlab) {
//            
//        }else {
//         rainlab  =[[UILabel alloc]initWithFrame:CGRectMake(x0-20, 170, 45, 20)];
//            rainlab.text=newrains[i];
//            rainlab.tag = 100 + i;
//            rainlab.textColor=[UIColor whiteColor];
//            rainlab.textAlignment=NSTextAlignmentCenter;
//            rainlab.font=[UIFont systemFontOfSize:12];
//            rainlab.textAlignment=NSTextAlignmentCenter;
//            [self addSubview:rainlab];
//        }
//
//       if(i== 0) {
//            rainlab.text = [NSString stringWithFormat:@"雨量%@", newrains[0]];
//       }else  if (![newrains[i] isEqualToString:@"0.0"]&& i > 0) {
//           rainlab.text = newrains[i];
//       }
//        
//        
//        
//
//    }
//    CGContextDrawPath(context, kCGPathFill);
    


    float x10 = 0;
    float x11 = self.width;
    float y10 = 170 - (self.maxhight.floatValue - self.minlowt.floatValue) /h;
    float y11 = 170;
     CGFloat dash1[] = {3, 2};
    CGContextMoveToPoint(currentContext, x10, y10);
    CGContextSetLineDash(currentContext, x10, dash1, 2);
    CGContextAddLineToPoint(currentContext, x11, y10);
    CGContextMoveToPoint(currentContext, x10, y11);
    CGContextAddLineToPoint(currentContext, x11, y11);
    [[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:0.6] set];
    CGContextSetLineWidth(currentContext, 1);
    CGContextStrokePath(currentContext);
    CGContextMoveToPoint(currentContext, 0, 190);
    CGContextAddLineToPoint(currentContext, self.width, 190);
    [[UIColor whiteColor] set];
    CGContextSetLineDash(currentContext, 0, dash, 0);
    CGContextStrokePath(currentContext);
    
    //曲线
    [self addBezierThroughPoints:self.valuearr];
//    CGPoint lastPoint = CGPointZero;
//    NSString  *value=self.valuearr[0];
//    float x=30;
//    float y=170-(value.floatValue-self.minlowt.floatValue)/h;
//    lastPoint=CGPointMake(x, y);
//    CGContextMoveToPoint(currentContext, x, y);
    //原来
//    for (int i=0; i<self.valuearr.count; i++) {
//        NSString  *value=self.valuearr[i];
//        float x0=45*i+30;
//        float y0=170-(value.floatValue-self.minlowt.floatValue)/h;
//        
////        CGPoint point = CGPointMake(x0,y0);
////        CGFloat middlePointX = fabs((point.x - lastPoint.x)) / 2.0 + (lastPoint.x > point.x ? point.x : lastPoint.x);
////        if (i == 1 || i == self.valuearr.count - 1)
////        {
////            CGFloat controlPointY;
////            
////            if (point.y < lastPoint.y)
////            {
////                controlPointY = point.y;
////            }
////            else
////            {
////                controlPointY = lastPoint.y;
////            }
////            
////            CGPoint controlPoint = CGPointMake(middlePointX, controlPointY);
////            CGContextAddQuadCurveToPoint(context,controlPoint.x, controlPoint.y, point.x, point.y);
////        }
////        else
////        {
////            CGFloat controlPointY1 = lastPoint.y;
////            CGFloat controlPointY2 = point.y;
////            
////            CGPoint controlPoint1 = CGPointMake(middlePointX, controlPointY1);
////            CGPoint controlPoint2 = CGPointMake(middlePointX, controlPointY2);
////            CGContextAddCurveToPoint(context,controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
////        }
////        
////        lastPoint = point;
////        if (i==0) {
////
////            CGContextMoveToPoint(currentContext, x0, y0);
////
////        }else{
////          CGContextSetLineDash(currentContext, x0, dash, 0);
////            CGContextAddLineToPoint(currentContext, x0 ,y0);
////            
////        }
//        
//        UIImage *t_image = [UIImage imageNamed:@"一周趋势橙色点.png"];
//        UIImageView *t_imageView = [self viewWithTag:150 + i];
//        if (!t_imageView) {
//            t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
//            self.t_img=t_imageView;
//            t_imageView.tag = 150 + i;
//            [self addSubview:t_imageView];
//        }
//        
//        [t_imageView setImage:t_image];
//        [t_imageView setCenter:CGPointMake(x0, y0)];
//        
//        UIImageView *icon = [self viewWithTag:200 + i];
//        if (!icon) {
//            icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 25, 25)];
//            //        icon.image=[UIImage imageNamed:self.icons[i]];
//            [self addSubview:icon];
//            icon.tag = 200 + i;
//            
//        }
//        
//        [icon setCenter:CGPointMake(x0, 20)];
//        
//        
//        
//        NSString *timestr=self.times[i];
//        int time=timestr.intValue;
//        if (time>18||time<7) {
//            icon.image=[UIImage imageNamed:[NSString stringWithFormat:@"n%@",self.icons[i]]];
//        }else{
//            
//            icon.image=[UIImage imageNamed:self.icons[i]];
//        }
//        
//        UILabel *wdlab = [self viewWithTag:250 + i];
//        if (!wdlab) {
//            wdlab = [[UILabel alloc]initWithFrame:CGRectMake(45*i+23, 170, 40, 20)];
//            wdlab.textColor=[UIColor whiteColor];
//            wdlab.font=[UIFont systemFontOfSize:12];
//            wdlab.textAlignment=NSTextAlignmentCenter;
//            [self addSubview:wdlab];
//            wdlab.tag = 250 + i;
//        }
//        [wdlab setCenter:CGPointMake(x0, y0-10)];
//
//        wdlab.text=[NSString stringWithFormat:@"%@°",self.valuearr[i]];
//        
//        //时间的label 10h
//        UILabel *lab = [self viewWithTag:300 + i];
//        if (!lab) {
//            lab =[[UILabel alloc]initWithFrame:CGRectMake(45*i+11, 192, 40, 20)];
//            lab.textColor=[UIColor whiteColor];
//            lab.font=[UIFont systemFontOfSize:12];
//            lab.textAlignment=NSTextAlignmentCenter;
//            [self addSubview:lab];
//            lab.tag = 300 + i;
//        }
//        lab.text=self.times[i];
//    }
//    [[UIColor orangeColor] set];
//    CGContextSetLineWidth(currentContext,1.5);
//    CGContextStrokePath(currentContext);
    for (int i = 0 ; i < self.windDircationValues.count; i ++) {
        
        UILabel *windpow_lab = [self viewWithTag:350 + i];
        if (!windpow_lab) {
            windpow_lab = [[UILabel alloc]initWithFrame:CGRectMake(45 * i + 9, 215, 44, 20)];
            windpow_lab.textColor = [UIColor whiteColor];
            windpow_lab.font = [UIFont systemFontOfSize:12];
            windpow_lab.textAlignment = NSTextAlignmentCenter;
            [self addSubview:windpow_lab];
            windpow_lab.tag = 350 + i;
        }
        
        windpow_lab.text = self.windValues[i];
        if (i == 0) {
            windpow_lab.text = [NSString stringWithFormat:@"风力%@", self.windValues[0]];
            windpow_lab.frame = CGRectMake(5, 215,50, 20);
        }
        
        
        
        UILabel *desc_lab = [self viewWithTag:400 + i];
        if (!desc_lab) {
            desc_lab = [[UILabel alloc]initWithFrame:CGRectMake(45 * i + 11, 35, 40, 20)];
            desc_lab.textAlignment = NSTextAlignmentCenter;
            desc_lab.textColor = [UIColor whiteColor];
            desc_lab.font = [UIFont systemFontOfSize:12];
            [self addSubview:desc_lab];
            desc_lab.tag = 400 + i;
        }
        desc_lab.text = self.weatherValues[i];
        
        
        
    }
    
}
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
  
    NSString  *value = pointArray[0];
    float v=value.floatValue;
    float x = 0;
    float y = 0;
    float h=(self.maxhight.floatValue-self.minlowt.floatValue)/80;
    x=30;
    y=170-(v-self.minlowt.floatValue)/h;
    if (h==0) {
        y=170;
    }
    currentPoint=CGPointMake(x, y);
    
    [mPath moveToPoint:currentPoint]; //创建一个点
    previousPoint = mPath.currentPoint;
    for (int i = 0; i < pointArray.count; i++) {
        value = pointArray[i];
        v=value.floatValue;
        x = 0;
        y = 0;
        x=30+45*i;
        y=170-(v-self.minlowt.floatValue)/h;
        if (h==0) {
            y=170;
        }
        CGPoint pointI = CGPointMake(x, y);
        
        if (i > 0) {
            
            previousCenterPoint = CenterPointOf(mPath.currentPoint, previousPoint);
            if (i==1) {
                previousCenterPoint = CenterPointOf(currentPoint, previousPoint);
            }
            centerPoint = CenterPointOf(previousPoint, pointI);
            
            centerPointDistance = DistanceBetweenPoint(previousCenterPoint, centerPoint);
            
            obliqueAngle = ObliqueAngleOfStraightThrough(centerPoint, previousCenterPoint);
            
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
        
        //
        UIImage *t_image = [UIImage imageNamed:@"一周趋势橙色点.png"];
        UIImageView *t_imageView = [self viewWithTag:150 + i];
        if (!t_imageView) {
            t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
            self.t_img=t_imageView;
            t_imageView.tag = 150 + i;
            [self addSubview:t_imageView];
        }
        
        [t_imageView setImage:t_image];
        [t_imageView setCenter:CGPointMake(x, y)];
        
        UIImageView *icon = [self viewWithTag:200 + i];
        if (!icon) {
            icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 25, 25)];
            //        icon.image=[UIImage imageNamed:self.icons[i]];
            [self addSubview:icon];
            icon.tag = 200 + i;
            
        }
        
        [icon setCenter:CGPointMake(x, 20)];
        
        
        
        NSString *timestr=self.times[i];
        int time=timestr.intValue;
        if (time>18||time<7) {
            icon.image=[UIImage imageNamed:[NSString stringWithFormat:@"n%@",self.icons[i]]];
        }else{
            
            icon.image=[UIImage imageNamed:self.icons[i]];
        }
        
        UILabel *wdlab = [self viewWithTag:250 + i];
        if (!wdlab) {
            wdlab = [[UILabel alloc]initWithFrame:CGRectMake(45*i+23, 170, 40, 20)];
            wdlab.textColor=[UIColor whiteColor];
            wdlab.font=[UIFont systemFontOfSize:12];
            wdlab.textAlignment=NSTextAlignmentCenter;
            [self addSubview:wdlab];
            wdlab.tag = 250 + i;
        }
        [wdlab setCenter:CGPointMake(x, y-10)];
        
        wdlab.text=[NSString stringWithFormat:@"%@°",self.valuearr[i]];
        
        //时间的label 10h
        UILabel *lab = [self viewWithTag:300 + i];
        if (!lab) {
            lab =[[UILabel alloc]initWithFrame:CGRectMake(45*i+11, 192, 40, 20)];
            lab.textColor=[UIColor whiteColor];
            lab.font=[UIFont systemFontOfSize:12];
            lab.textAlignment=NSTextAlignmentCenter;
            [self addSubview:lab];
            lab.tag = 300 + i;
        }
        lab.text=self.times[i];
    }
    CAShapeLayer *clay = [CAShapeLayer layer];
    self.templay=clay;
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
- (void)addRainBezierThroughPoints:(NSArray *)pointArray
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
    float h=(self.maxrain.floatValue-self.minrain.floatValue)/30;;
//    x=30;
//    y=190-(v-self.minrain.floatValue)/h;
    currentPoint=CGPointMake(0, 190);
    
    [mPath moveToPoint:currentPoint]; //创建一个点
    previousPoint = mPath.currentPoint;
    for (int i = 0; i < pointArray.count; i++) {
        value = pointArray[i];
        v=value.floatValue;
        x = 0;
        y = 0;

        x=30+45*i;
        y=190-(v-self.minrain.floatValue)/h;
        if (h==0) {
            y=190;
        }
        CGPoint pointI = CGPointMake(x, y);
        
        if (i > 0) {
            
            previousCenterPoint = CenterPointOf(mPath.currentPoint, previousPoint);
            if (i==1) {
                previousCenterPoint = CenterPointOf(currentPoint, previousPoint);
            }
            centerPoint = CenterPointOf(previousPoint, pointI);
            
            centerPointDistance = DistanceBetweenPoint(previousCenterPoint, centerPoint);
            
            obliqueAngle = ObliqueAngleOfStraightThrough(centerPoint, previousCenterPoint);
            self.obrandious=obliqueAngle;
            previousControlPoint2 = CGPointMake(previousPoint.x - 0.5 *self.RaincontractionFactor * centerPointDistance * cos(obliqueAngle), previousPoint.y - 0.5 * self.RaincontractionFactor * centerPointDistance * sin(obliqueAngle));
            controlPoint1 = CGPointMake(previousPoint.x + 0.5 * self.RaincontractionFactor * centerPointDistance * cos(obliqueAngle), previousPoint.y + 0.5 * self.RaincontractionFactor * centerPointDistance * sin(obliqueAngle));
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
            [mPath addLineToPoint:CGPointMake(pointI.x, 190)];
            [mPath addLineToPoint:CGPointMake(0, 190)];
        }
        
        
        previousControlPoint1 = controlPoint1;
        previousPoint = pointI;
        
        

    }
    
    CAShapeLayer *clay = [CAShapeLayer layer];
    self.rainlay=clay;
    clay.strokeColor = [UIColor colorHelpWithRed:53 green:119 blue:137 alpha:0.2].CGColor;
    clay.fillColor =  [UIColor colorHelpWithRed:53 green:119 blue:137 alpha:0.6].CGColor;
    clay.lineWidth =0.01;
    clay.path = mPath.CGPath;
    clay.lineCap = kCALineCapRound;
    clay.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:clay];
    //    self.layer.shouldRasterize = YES;
    [clay setAllowsEdgeAntialiasing:YES];
    [clay setAllowsGroupOpacity:YES];
    for (int i=0; i<pointArray.count; i++) {
        value = pointArray[i];
        v=value.floatValue;
        x = 0;
        y = 0;
        
        x=30+45*i;
        y=190-(v-self.minrain.floatValue)/h;
        if (h==0) {
            y=189;
        }
        UILabel *rainlab = [self viewWithTag:500 + i];
        if (!rainlab) {
           rainlab  =[[UILabel alloc]initWithFrame:CGRectMake(x-20, 170, 45, 20)];
            rainlab.text=pointArray[i];
            rainlab.textColor=[UIColor whiteColor];
            rainlab.textAlignment=NSTextAlignmentCenter;
            rainlab.font=[UIFont systemFontOfSize:12];
            rainlab.textAlignment=NSTextAlignmentCenter;
            [self addSubview:rainlab];
            rainlab.tag=500+i;
        }
        if(i== 0) {
            rainlab.text = [NSString stringWithFormat:@"雨量%@", pointArray[0]];
        }else  if (![pointArray[i] isEqualToString:@"0.0"]&& i > 0) {
            rainlab.text = pointArray[i];
        }
    }
}
CGFloat ObliqueAngleOfStraightThrough(CGPoint point1, CGPoint point2)   //  [-π/2, 3π/2)
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

CGPoint ControlPointForTheBezierCanThrough3Point(CGPoint point1, CGPoint point2, CGPoint point3)
{
    return CGPointMake(2 * point2.x - (point1.x + point3.x) / 2, 2 * point2.y - (point1.y + point3.y) / 2);
}

CGFloat DistanceBetweenPoint(CGPoint point1, CGPoint point2)
{
    return sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
}

CGPoint CenterPointOf(CGPoint point1, CGPoint point2)
{
    return CGPointMake((point1.x + point2.x) / 2, (point1.y + point2.y) / 2);
}
- (CGFloat)contractionFactor
{
    id contractionFactorAssociatedObject = objc_getAssociatedObject(self, @selector(contractionFactor));
    if (contractionFactorAssociatedObject == nil) {
        if (self.obrandious>3.6) {
            return 0.2;
        }else
        return 0.7;
    }
    return [contractionFactorAssociatedObject floatValue];
}
- (void)setContractionFactor:(CGFloat)contractionFactor
{
    objc_setAssociatedObject(self, @selector(contractionFactor), @(contractionFactor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)RaincontractionFactor
{
    id contractionFactorAssociatedObject = objc_getAssociatedObject(self, @selector(RaincontractionFactor));
    if (contractionFactorAssociatedObject == nil) {
        if (self.obrandious>3.0) {
            return 0.2;
        }else
            return 0.6;
    }
    return [contractionFactorAssociatedObject floatValue];
}
- (void)setRainContractionFactor:(CGFloat)contractionFactor
{
    objc_setAssociatedObject(self, @selector(RaincontractionFactor), @(contractionFactor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
