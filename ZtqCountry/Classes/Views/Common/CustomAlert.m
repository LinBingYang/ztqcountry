//
//  CustomAlert.m
//  ZtqCountry
//
//  Created by linxg on 14-7-22.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "CustomAlert.h"

@interface CustomAlert ()

@property (strong, nonatomic) UIImageView * bgImgV;

@end

@implementation CustomAlert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithMessage:(NSString *)message
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        _bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 250, kScreenWidth-40, 55)];
        _bgImgV.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgImgV];
        
        UIImageView * logo = [[UIImageView alloc] initWithFrame:CGRectMake(25, 8, 40, 40)];
        logo.backgroundColor = [UIColor blueColor];
//        logo.image = [UIImage imageNamed:@"logo.png"];
        [_bgImgV addSubview:logo];
        
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(88, 8, kScreenWidth-40-20-88, 55-16)];
        lab.text = message;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor blueColor];
        lab.numberOfLines = 0;
        lab.font = [UIFont fontWithName:kBaseFont size:15];
        [_bgImgV addSubview:lab];
    }
    return self;
}


-(void)show
{
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.1, 0.1);
    _bgImgV.transform = scaleTransform;
//    [UIView ani]
    
    [UIView animateWithDuration:0.2 animations:^{
        _bgImgV.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            _bgImgV.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                _bgImgV.transform = CGAffineTransformMakeScale(1.05, 1.05);
            } completion:^(BOOL finished) {
//                _bgImgV.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
        _bgImgV.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

-(void)hide
{
    [self removeFromSuperview];
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
