//
//  UpgradeAlert.m
//  ZtqCountry
//
//  Created by linxg on 14-8-1.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "UpgradeAlert.h"
#import "UILabel+utils.h"

@interface UpgradeAlert ()

@property (strong, nonatomic) UIImageView * bgImage;

@end

@implementation UpgradeAlert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithLogo:(NSString *)logoName withTitle:(NSString *)title withContent:(NSString *)content withFirstButton:(NSString *)first withSecondButton:(NSString *)second withDelegate:(id)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    if(self)
    {
        self.delegate = delegate;
        self.backgroundColor = [UIColor clearColor];
        float space = 0;
        if(kSystemVersionMore7)
        {
            space = 64;
        }
        else
        {
            space = 44;
        }
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, space, kScreenWidth-10, kScreenHeitht-space-20)];
        _bgImage.userInteractionEnabled = YES;
        _bgImage.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgImage];
        
        _logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(115, 40, 80, 80)];
        _logoImg.image = [UIImage imageNamed:logoName];
        [_bgImage addSubview:_logoImg];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 170, kScreenWidth-10-30, 20)];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = [UIFont fontWithName:kBaseFont size:18];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.text = title;
        [_bgImage addSubview:_titleLab];
        
        UIScrollView * contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 205, kScreenWidth-10, kScreenHeitht-205-60-20-space -20)];
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.showsVerticalScrollIndicator = NO;
        [_bgImage addSubview:contentScrollView];
        
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, kScreenWidth-10-15, 20)];
        _contentLab.numberOfLines = 0;
        _contentLab.textAlignment = NSTextAlignmentLeft;
        _contentLab.font = [UIFont fontWithName:kBaseFont size:15];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.textColor = [UIColor grayColor];
        _contentLab.text = content;
        float height = [_contentLab labelheight:content withFont:[UIFont fontWithName:kBaseFont size:15]];
        _contentLab.frame = CGRectMake(25, 0, kScreenWidth-10-15, height);
        [contentScrollView addSubview:_contentLab];
        contentScrollView.contentSize = CGSizeMake(kScreenWidth-10, height+10);
        
        
        _firstBut = [[UIButton alloc] initWithFrame:CGRectMake(35, kScreenHeitht-60-space-20, 100, 35)];
        _firstBut.tag = 1;
        [_firstBut setBackgroundImage:[UIImage imageNamed:@"sjtc升级.png"] forState:UIControlStateNormal];
        [_firstBut setBackgroundImage:[UIImage imageNamed:@"sjtc升级点击.png"] forState:UIControlStateHighlighted];
        [_firstBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_firstBut addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        [_firstBut setTitle:first forState:UIControlStateNormal];
        [_bgImage addSubview:_firstBut];
        
        _secondBut = [[UIButton alloc] initWithFrame:CGRectMake(125, kScreenHeitht-60-space-20, 100, 35)];
        _secondBut.tag = 2;
        [_secondBut setBackgroundImage:[UIImage imageNamed:@"sjtc取消.png"] forState:UIControlStateNormal];
        [_secondBut setBackgroundImage:[UIImage imageNamed:@"sjtc取消点击.png"] forState:UIControlStateHighlighted];
        [_secondBut addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        [_secondBut setTitle:second forState:UIControlStateNormal];
        [_secondBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bgImage addSubview:_secondBut];

    }
    return self;
}


-(void)butAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(clickButtonWithTag:)])
    {
        [self.delegate clickButtonWithTag:sender.tag];
    }
    [self hiden];
}

-(void)show
{
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.1, 0.1);
    _bgImage.transform = scaleTransform;
    //    [UIView ani]
    
    [UIView animateWithDuration:0.2 animations:^{
        _bgImage.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            _bgImage.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                _bgImage.transform = CGAffineTransformMakeScale(1.05, 1.05);
            } completion:^(BOOL finished) {
                //                _bgImgV.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
        _bgImage.transform = CGAffineTransformMakeScale(1, 1);
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
