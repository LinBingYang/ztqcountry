//
//  LineProgressLayer.m
//  Layer
//
//  Created by Carver Li on 14-12-1.
//
//

#import "LineProgressLayer.h"
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@implementation LineProgressLayer

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self)
    {
        if ([layer isKindOfClass:[LineProgressLayer class]])
        {
            LineProgressLayer *other = layer;
            self.total = other.total;
            self.color = other.color;
            self.completed = other.completed;
            self.completedColor = other.completedColor;
            
            self.radius = other.radius;
            self.innerRadius = other.innerRadius;
            
            self.startAngle = other.startAngle;
            self.endAngle = other.endAngle;
            self.x=other.x;
            self.y=other.y;
            self.shouldRasterize = YES;
        }
    }
    
    return self;
}

+ (id)layer
{
    LineProgressLayer *result = [[LineProgressLayer alloc] init];
    
    return result;
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"completed"])
    {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)contextRef
{
    CGFloat originalRadius = _radius;
    CGFloat totalAngle = _endAngle - _startAngle;
    
    CGRect rect = self.bounds;
    
    CGFloat x0 = (rect.size.width - 2*_radius)/2.0 + _radius;
    CGFloat y0 = (rect.size.height - 2*_radius)/2.0 + _radius;
    
    CGContextSetLineJoin(contextRef, kCGLineJoinRound);
    CGContextSetFlatness(contextRef, 1.0);
    CGContextSetAllowsAntialiasing(contextRef, true);
    CGContextSetShouldAntialias(contextRef, true);
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
    
    CGContextSetLineWidth(contextRef,1.0f);     //设置线条宽度
    
    
    for (int i = 0; i < _total; i++) {
        CGContextMoveToPoint(contextRef, x0, y0);
        
        CGFloat x = x0 + cosf(_startAngle + totalAngle*i/_total)*_radius;
        CGFloat y = y0 + sinf(_startAngle + totalAngle*i/_total)*_radius;
        
        CGContextAddLineToPoint(contextRef, x, y);
        CGContextSetStrokeColorWithColor(contextRef, _color.CGColor);   //设置颜色
        CGContextSetFillColorWithColor(contextRef, _color.CGColor);
        CGContextDrawPath(contextRef, kCGPathFillStroke);
        
        
    }

    CGFloat x = x0 + cosf(_startAngle + totalAngle*_completed/_total)*_radius;
    CGFloat y = y0+ sinf(_startAngle + totalAngle*_completed/_total)*_radius;
    for (int i = 0; i < _completed; i++) {
        
        CGContextMoveToPoint(contextRef, x0, y0);
        
        if (i + 1 == _completed) {
            _radius += 10;//箭头
            
            
        }
        else {
            _radius = originalRadius;
        }
        
        CGFloat x = x0 + cosf(_startAngle + totalAngle*i/_total)*_radius;
        CGFloat y = y0+ sinf(_startAngle + totalAngle*i/_total)*_radius;
        
        CGContextAddLineToPoint(contextRef, x, y);
        CGContextSetStrokeColorWithColor(contextRef, _completedColor.CGColor);  //设置完成颜色
        CGContextSetFillColorWithColor(contextRef, _completedColor.CGColor);
        CGContextDrawPath(contextRef, kCGPathFillStroke);
        
        if (i + 1 == _completed) {
            _radius = originalRadius;
            break;
        }
    }
  
    CGFloat x1 = x0 + cosf(_startAngle + totalAngle*_completed/_total)*_radius;
    CGFloat y1 = y0+ sinf(_startAngle + totalAngle*_completed/_total)*_radius;
    
    CGImageRef image;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"日出日落.png" ofType:nil];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
//    UIImage *i=[self renderImage:[UIImage imageNamed:@"日出日落.png"] atSize:CGSizeMake(50, 50)];
    image = CGImageRetain(img.CGImage);
//    CGRect imageRect;
//    
//    imageRect.origin = CGPointMake(x1, y1);//设置第一张图的位置，右图中imageRect.origin = CGPointMake(32.0, 112.0);
//    imageRect.size = CGSizeMake(20,20);
    CGContextDrawImage(contextRef, CGRectMake(x1, y1, 20, 20), image);
    //指针
    
    
//    CGContextAddLineToPoint(contextRef, x, y);
//    CGContextSetStrokeColorWithColor(contextRef, [UIColor redColor].CGColor);  //设置完成颜色
//    CGContextSetFillColorWithColor(contextRef, _completedColor.CGColor);
//    CGContextDrawPath(contextRef, kCGPathFillStroke);
//    self.contents=(id)[UIImage imageNamed:@"背景"].CGImage;
    //画圆覆盖内部线条
    CGContextAddArc(contextRef, x0, y0, _innerRadius, 0, 2*M_PI, 0);
    CGContextSetFillColorWithColor(contextRef, CGColorCreateCopy(self.backgroundColor));
    CGContextSetStrokeColorWithColor(contextRef, [UIColor clearColor].CGColor);     //设置内圆无颜色
    CGContextDrawPath(contextRef, kCGPathFillStroke);
}
//- (UIImage *)renderImage:(UIImage *)image atSize:(CGSize)size
//{
//    UIGraphicsBeginImageContext(size);
//    [image drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
//    
//    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
