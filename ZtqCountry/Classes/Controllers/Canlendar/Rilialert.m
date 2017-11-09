//
//  Rilialert.m
//  ztqFj
//
//  Created by Admin on 15-1-4.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "Rilialert.h"

@implementation Rilialert
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//180 310
-(id)initWithLogoImage:(NSString *)imageName withTitle:(NSString *)title withContent:(NSString *)content withleftname:(NSString *)left withrightname:(NSString *)right
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    if(self)
    {
        UIImageView * fuzzyImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
        fuzzyImgV.backgroundColor = [UIColor blackColor];
        fuzzyImgV.alpha = 0.3;
        [self addSubview:fuzzyImgV];
        
        _backgroundImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 170, kScreenWidth-40, 230)];
        _backgroundImgV.image = [UIImage imageNamed:@"出行天气弹窗底座.png"];
        _backgroundImgV.userInteractionEnabled = YES;
        [self addSubview:_backgroundImgV];
        
      
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth-40, 20)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.text = title;
        [_backgroundImgV addSubview:_titleLab];
        
       
        
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(5, 40, kScreenWidth-50, 150)];
//        line.backgroundColor=[UIColor colorHelpWithRed:52 green:104 blue:168 alpha:1];
//        line.image=[UIImage imageNamed:@"日历输入框"];
        line.userInteractionEnabled=YES;
        [_backgroundImgV addSubview:line];
        
        _contentLab = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(_backgroundImgV.frame)-30, 130)];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.returnKeyType=UIReturnKeyDone;
        _contentLab.textAlignment = NSTextAlignmentLeft;
//        _contentLab.numberOfLines=0;
        _contentLab.font = [UIFont fontWithName:kBaseFont size:15];
        _contentLab.textColor = [UIColor blackColor];
//        _contentLab.text = content;
        _contentLab.delegate=self;
        _contentLab.hidden=NO;
        _contentLab.layer.borderWidth=1;
        _contentLab.layer.borderColor=[UIColor orangeColor].CGColor;
        [line addSubview:_contentLab];
        self.bglabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 300, 30)];
        [self.bglabel setBackgroundColor:[UIColor clearColor]];
        self.bglabel.text=@"亲，请输入备忘信息~";
        self.str=self.bglabel.text;
        [self.bglabel setTextColor:[UIColor blackColor]];
        self.bglabel.enabled=NO;
        [self.bglabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        [_contentLab addSubview:self.bglabel];

        
        UIImageView * lineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 180, CGRectGetWidth(_backgroundImgV.frame), 1)];
        lineImgV.image = [UIImage imageNamed:@"弹窗横向分隔线"];
        [_backgroundImgV addSubview:lineImgV];
        UIImageView * lineImgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_backgroundImgV.frame)/2, 180, 1, 50)];
        lineImgV1.image = [UIImage imageNamed:@"弹窗纵向分隔线"];
        [_backgroundImgV addSubview:lineImgV1];
        
        _firstBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 185,_backgroundImgV.width/2, 40)];
        _firstBut.tag = 1;
//        [_firstBut setBackgroundImage:[UIImage imageNamed:@"按钮左.png"] forState:UIControlStateNormal];
//        [_firstBut setBackgroundImage:[UIImage imageNamed:@"按钮左点击.png"] forState:UIControlStateHighlighted];
//        [_firstBut setBackgroundColor:[UIColor colorHelpWithRed:46 green:98 blue:183 alpha:1]];
        [_firstBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_firstBut addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_firstBut setTitle:left forState:UIControlStateNormal];
        //        [_firstBut setBackgroundColor:[UIColor yellowColor]];
        [_backgroundImgV addSubview:_firstBut];
        
        _secondBut = [[UIButton alloc] initWithFrame:CGRectMake(_backgroundImgV.width/2, 185, _backgroundImgV.width/2, 40)];
        _secondBut.tag = 2;
//        [_secondBut setBackgroundImage:[UIImage imageNamed:@"按钮右.png"] forState:UIControlStateNormal];
//        [_secondBut setBackgroundImage:[UIImage imageNamed:@"按钮右点击.png"] forState:UIControlStateHighlighted];
//        [_secondBut setBackgroundColor:[UIColor colorHelpWithRed:122 green:122 blue:122 alpha:1]];
        [_secondBut addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_secondBut setTitle:right forState:UIControlStateNormal];
        [_secondBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        [_firstBut setBackgroundColor:[UIColor redColor]];
        [_backgroundImgV addSubview:_secondBut];
    }
    return self;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        self.bglabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.bglabel.hidden = NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
//    self.str=textView.text;
    return YES;
}

-(void)buttonAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(clickButtonWithTag:withcontentstr:)])
    {
        [self.delegate clickButtonWithTag:sender.tag withcontentstr:_contentLab.text];
    }
    [self removeFromSuperview];
}
-(void)closeAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updataview" object:nil];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
