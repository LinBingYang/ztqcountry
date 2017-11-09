//
//  Alert.m
//  ZtqCountry
//
//  Created by linxg on 14-8-1.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "Alert.h"

@interface Alert ()

@property (strong, nonatomic) UIImageView * backgroundImgV;

@end

@implementation Alert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//180 310
-(id)initWithLogoImage:(NSString *)imageName withTitle:(NSString *)title withContent:(NSString *)content WithTime:(NSString *)putime withType:(NSString *)type
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    if(self)
    {
        UIImageView * fuzzyImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
        fuzzyImgV.backgroundColor = [UIColor blackColor];
        fuzzyImgV.alpha = 0.5;
        [self addSubview:fuzzyImgV];
        
        _backgroundImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 170, kScreenWidth-30, 180)];
        _backgroundImgV.image = [UIImage imageNamed:@"推送弹窗底座.png"];
        _backgroundImgV.userInteractionEnabled = YES;
        [self addSubview:_backgroundImgV];
        
        if ([type isEqualToString:@"预警"]) {
             _logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 40, 35)];
        }else{
             _logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 40, 40)];
        }
        _logoImgV.image = [UIImage imageNamed:imageName];
        [_backgroundImgV addSubview:_logoImgV];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, CGRectGetWidth(_backgroundImgV.frame)-70-20, 20)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.text = title;
        [_backgroundImgV addSubview:_titleLab];
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(70, 36, CGRectGetWidth(_backgroundImgV.frame)-70-20, 1)];
        line.image = [UIImage imageNamed:@"弹窗分隔线"];
        [_backgroundImgV addSubview:line];
        UILabel *timelab=[[UILabel alloc]initWithFrame:CGRectMake(70, 37, CGRectGetWidth(_backgroundImgV.frame)-70-20, 20)];
        timelab.textAlignment=NSTextAlignmentCenter;
        timelab.text=putime;
        timelab.font=[UIFont systemFontOfSize:13];
        timelab.textColor=[UIColor blackColor];
        [_backgroundImgV addSubview:timelab];
        
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, CGRectGetWidth(_backgroundImgV.frame)-40, 20)];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textColor = [UIColor blackColor];
        _contentLab.text = content;
        _contentLab.numberOfLines=0;
        [_backgroundImgV addSubview:_contentLab];
        
        UIImageView * lineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 130, CGRectGetWidth(_backgroundImgV.frame), 1)];
        lineImgV.image = [UIImage imageNamed:@"弹窗横向分隔线"];
        [_backgroundImgV addSubview:lineImgV];
        UIImageView * lineImgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_backgroundImgV.frame)/2, 130, 1, 50)];
        lineImgV1.image = [UIImage imageNamed:@"弹窗纵向分隔线"];
        [_backgroundImgV addSubview:lineImgV1];
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 135, CGRectGetWidth(_backgroundImgV.frame)/2-0.5, 45)];
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImgV addSubview:button];
        UIButton * rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_backgroundImgV.frame)/2-0.5, 135, CGRectGetWidth(_backgroundImgV.frame)/2-0.5, 45)];
        [rightbutton setTitle:@"更多" forState:UIControlStateNormal];
        [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightbutton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImgV addSubview:rightbutton];
    }
    return self;
}
-(id)initWithcontetnt:(NSString *)content{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    if(self)
    {
        _backgroundImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 170, kScreenWidth-20, 180)];
        _backgroundImgV.image = [UIImage imageNamed:@"fkyj2弹框_03.png"];
        _backgroundImgV.userInteractionEnabled = YES;
        [self addSubview:_backgroundImgV];
        
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, CGRectGetWidth(_backgroundImgV.frame)-40, 20)];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = [UIFont fontWithName:kBaseFont size:15];
        _contentLab.textColor = [UIColor blackColor];
        _contentLab.text = content;
        [_backgroundImgV addSubview:_contentLab];
        UIImageView * lineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 130, CGRectGetWidth(_backgroundImgV.frame)-30, 1)];
        lineImgV.image = [UIImage imageNamed:@"bbjc隔条_03"];
        [_backgroundImgV addSubview:lineImgV];
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(20, 135, CGRectGetWidth(_backgroundImgV.frame)-40, 30)];
//        [button setBackgroundImage:[UIImage imageNamed:@"bbjc点击_03"] forState:UIControlStateHighlighted];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImgV addSubview:button];
    }
    return self;
}
-(id)initWithTitle:(NSString *)title withContent:(NSString *)content withleftbtn:(NSString *)lefttitle withrightbtn:(NSString *)righttitle
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    if(self)
    {
        UIImageView * fuzzyImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
        fuzzyImgV.backgroundColor = [UIColor blackColor];
        fuzzyImgV.alpha = 0.5;
        [self addSubview:fuzzyImgV];
        
        _backgroundImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 170, kScreenWidth-40, 150)];
        _backgroundImgV.image = [UIImage imageNamed:@"推送弹窗底座.png"];
        _backgroundImgV.userInteractionEnabled = YES;
        [self addSubview:_backgroundImgV];
        
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(_backgroundImgV.frame), 30)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont fontWithName:kBaseFont size:17];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.text = title;
        [_backgroundImgV addSubview:_titleLab];
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, CGRectGetWidth(_backgroundImgV.frame), 1)];
        line.image = [UIImage imageNamed:@"弹窗分隔线"];
        [_backgroundImgV addSubview:line];
       
        
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, CGRectGetWidth(_backgroundImgV.frame)-40, 40)];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textColor = [UIColor blackColor];
        _contentLab.text = content;
        _contentLab.numberOfLines=0;
        [_backgroundImgV addSubview:_contentLab];
        
        UIImageView * lineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(_backgroundImgV.frame), 1)];
        lineImgV.image = [UIImage imageNamed:@"弹窗横向分隔线"];
        [_backgroundImgV addSubview:lineImgV];
        UIImageView * lineImgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_backgroundImgV.frame)/2, 100, 1, 50)];
        lineImgV1.image = [UIImage imageNamed:@"弹窗纵向分隔线"];
        [_backgroundImgV addSubview:lineImgV1];
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 105, CGRectGetWidth(_backgroundImgV.frame)/2-0.5, 45)];
        [button setTitle:lefttitle forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImgV addSubview:button];
        UIButton * rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_backgroundImgV.frame)/2-0.5, 105, CGRectGetWidth(_backgroundImgV.frame)/2-0.5, 45)];
        [rightbutton setTitle:righttitle forState:UIControlStateNormal];
        rightbutton.titleLabel.font=[UIFont systemFontOfSize:15];
        [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightbutton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImgV addSubview:rightbutton];
    }
    return self;
}
-(void)buttonAction:(UIButton *)sender
{
    [self removeFromSuperview];
}
-(void)rightAction{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(moreAction)]) {
        [self.delegate moreAction];
    }
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
