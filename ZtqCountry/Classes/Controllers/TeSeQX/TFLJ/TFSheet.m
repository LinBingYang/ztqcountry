//
//  TFSheet.m
//  ZtqCountry
//
//  Created by Admin on 14-9-24.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "TFSheet.h"

@implementation TFSheet
@synthesize delegate;
@synthesize view;
@synthesize titleview;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithHeight:(float)height WithSheetTitle:(NSString*)title withLeftBtn:(NSString *)leftTitle withRightBtn:(NSString *)rightTitle
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, [UIScreen mainScreen].bounds.size.height)];
    if (self) {
        
        //半透明黑色遮挡层
        UIView * barrierView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [UIScreen mainScreen].bounds.size.height)];
        barrierView.backgroundColor = [UIColor blackColor];
        barrierView.alpha = 0.3;
        [self addSubview:barrierView];
        //添加手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [barrierView addGestureRecognizer:tap];
        _sheetBgView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeitht-height, kScreenWidth, height)];
//        _sheetBgView.userInteractionEnabled=YES;
        _sheetBgView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_sheetBgView];
        UIView *bgimg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        bgimg.backgroundColor=[UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1];
//        bgimg.userInteractionEnabled=YES;
        [_sheetBgView addSubview:bgimg];

        UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 160, 30)];
        [t_label setText:title];
        [t_label setTextColor:[UIColor whiteColor]];
        [t_label setBackgroundColor:[UIColor clearColor]];
        [t_label setTextAlignment:NSTextAlignmentCenter];
        //        [bgimg addSubview:t_label];
        [bgimg addSubview:t_label];
        
        UIButton *leftbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
        [leftbtn setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
        [leftbtn setBackgroundImage:[UIImage imageNamed:@"返回点击.png"] forState:UIControlStateHighlighted];
        [leftbtn addTarget:self action:@selector(docancel) forControlEvents:UIControlEventTouchUpInside];
        [bgimg addSubview:leftbtn];
        
        
        UIButton *rigthbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50, 5, 50, 30)];
        [rigthbtn setTitle:@"确认" forState:UIControlStateNormal];
        [rigthbtn addTarget:self action:@selector(doneaction) forControlEvents:UIControlEventTouchUpInside];
        [bgimg addSubview:rigthbtn];
//        [bgimg bringSubviewToFront:rigthbtn];
    }
    return self;
}

-(void)doneaction{
    if (delegate && [delegate respondsToSelector:@selector(doneBtnClicked)]) {
        [delegate doneBtnClicked];
    }
    [self hide];
}

-(void)docancel{
        [self hide];
}
-(void)show
{
    CGRect originFram = _sheetBgView.frame;
    CGRect newFram = CGRectOffset(originFram, 0, +CGRectGetHeight(originFram));
    _sheetBgView.frame = newFram;
    
    if([[self class] isSubclassOfClass:[UIViewController class]]){
        UIView * addView = [(UIViewController *)self.delegate view];
        [addView addSubview:self];
    }else{
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:self];
    }
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    _sheetBgView.frame = originFram;
    [UIView commitAnimations];
}

-(void)hide
{
    [self.sheetBgView removeFromSuperview];
    self.sheetBgView = nil;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect originFram = _sheetBgView.frame;
        CGRect newFram = CGRectOffset(originFram, 0, +CGRectGetHeight(originFram));
        _sheetBgView.frame = newFram;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
//        _sheetBgView.hidden=YES;
    }];
}
@end
