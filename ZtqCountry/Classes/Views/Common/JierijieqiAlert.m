//
//  JierijieqiAlert.m
//  ZtqCountry
//
//  Created by linxg on 14-9-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "JierijieqiAlert.h"
#import "UILabel+utils.h"

@implementation JierijieqiAlert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)creatView
{
    
}

-(id)initWithTitle:(NSString *)titleStr withLogoImageName:(NSString *)logoStr withContentStr:(NSString *)content
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    if(self)
    {
        UIView * blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
        blurView.backgroundColor = [UIColor blackColor];
        blurView.alpha = 0.5;
        [self addSubview:blurView];
        
        UIImageView * backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (kScreenHeitht-150)/2.0, kScreenWidth-40, 150)];
        self.backgroundImageView = backgroundImageView;
        backgroundImageView.image = [UIImage imageNamed:@"warndialogbreakground.png"];
        backgroundImageView.userInteractionEnabled = YES;
        [self addSubview:backgroundImageView];
        
        UIImageView * barBackground = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, kScreenWidth-48, 40)];
        barBackground.userInteractionEnabled = YES;
        barBackground.backgroundColor = [UIColor colorHelpWithRed:58 green:134 blue:196 alpha:1];
        [backgroundImageView addSubview:barBackground];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-40, 20)];
        _titleLab.text = titleStr;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont fontWithName:kBaseFont size:15];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        [barBackground addSubview:_titleLab];
        
        
        UIButton * closeBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40-30, 10, 20, 20)];
        [closeBut setBackgroundImage:[UIImage imageNamed:@"dzbtc关闭.png"] forState:UIControlStateNormal];
        [closeBut addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [barBackground addSubview:closeBut];
        
        _logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 65, 60, 60)];
        _logoImg.image = [UIImage imageNamed:logoStr];
        [backgroundImageView addSubview:_logoImg];
        
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(90 ,50, 170, 20)];
        _contentLab.text = content;
        _contentLab.numberOfLines = 0;
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.textColor = [UIColor whiteColor];
        _contentLab.font = [UIFont fontWithName:kBaseFont size:15];
        _contentLab.textAlignment = NSTextAlignmentLeft;
        [backgroundImageView addSubview:_contentLab];
        
        float heightLab = [_contentLab labelheight:content withFont:_contentLab.font];
        _contentLab.frame = CGRectMake(90, 40+(150-heightLab-40)/2.0, 170, heightLab);
       
        
    }
    return self;
}


-(void)closeAction:(UIButton *)sender
{
    [self hiden];
}

-(void)show
{
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.1, 0.1);
    _backgroundImageView.transform = scaleTransform;
    //    [UIView ani]
    
    [UIView animateWithDuration:0.2 animations:^{
        _backgroundImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            _backgroundImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                _backgroundImageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
            } completion:^(BOOL finished) {
                _backgroundImageView.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
        _backgroundImageView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

-(void)hiden
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
