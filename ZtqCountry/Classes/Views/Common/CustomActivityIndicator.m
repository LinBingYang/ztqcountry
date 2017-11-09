//
//  CustomActivityIndicator.m
//  ZtqCountry
//
//  Created by linxg on 14-7-30.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "CustomActivityIndicator.h"

@interface CustomActivityIndicator ()
{
    double angle;
    BOOL beginAnimation;
}

@property (strong, nonatomic) UIImageView * refreshImg;

@end

@implementation CustomActivityIndicator

- (id)initWithFrame:(CGRect)frame
{
    CGRect newFram = CGRectMake(frame.origin.x, frame.origin.y, 20, 19);
    self = [super initWithFrame:newFram];
    if (self) {
        // Initialization code
        _refreshImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 19)];
        _refreshImg.image = [UIImage imageNamed:@"刷新_03.png"];
        beginAnimation = NO;
        [self addSubview:_refreshImg];
    }
    return self;
}

-(void)startAnimation
{
    _refreshImg.hidden = NO;
    beginAnimation = YES;
    [self animation];
}

-(void)animation
{
    if(beginAnimation)
    {
        CGAffineTransform tration = CGAffineTransformRotate(_refreshImg.transform, 10);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _refreshImg.transform = tration;
        } completion:^(BOOL finished) {
            [self animation];
        }];
    }
}

-(void)stopAnimation
{
    _refreshImg.hidden = YES;
    beginAnimation = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
