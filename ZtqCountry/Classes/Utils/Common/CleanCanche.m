//
//  CleanCanche.m
//  ZtqCountry
//
//  Created by Admin on 15/7/7.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "CleanCanche.h"
@interface CleanCanche ()

@property (strong, nonatomic) UIImageView * backgroundImgV;

@end
@implementation CleanCanche
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

//180 310
-(id)initWithview:(UIView *)view withTitle:(NSString *)title withtype:(NSString *)type
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    if(self)
    {
        _backgroundImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 160, 120)];
        _backgroundImgV.center=self.center;
        _backgroundImgV.image=[UIImage imageNamed:@"缓存清理底座"];
        _backgroundImgV.alpha=0.8;
        _backgroundImgV.userInteractionEnabled=YES;
        [self addSubview:_backgroundImgV];
        UIView *icoview=[[UIView alloc]initWithFrame:CGRectMake((160-40)/2, 30, 40, 40)];
        icoview=view;
        icoview.frame=CGRectMake((160-40)/2, 40, 40, 40);
//        icoview.center=_backgroundImgV.center;
        [_backgroundImgV addSubview:icoview];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0,80 , 160, 30)];
        lab.text=title;
        lab.font=[UIFont systemFontOfSize:15];
        lab.textColor=[UIColor whiteColor];
        lab.textAlignment=NSTextAlignmentCenter;
        [_backgroundImgV addSubview:lab];
    }
    return self;
}
-(void)hideenview
{
    [self removeFromSuperview];
}

-(void)show
{
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.1, 0.1);
    _backgroundImgV.transform = scaleTransform;
    //    [UIView ani]
    
    [UIView animateWithDuration:0.2 animations:^{
        _backgroundImgV.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            _backgroundImgV.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                _backgroundImgV.transform = CGAffineTransformMakeScale(1.05, 1.05);
            } completion:^(BOOL finished) {
                //                _bgImgV.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
        _backgroundImgV.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
@end
