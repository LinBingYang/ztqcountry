//
//  CustomSheet.m
//  ztqFj
//
//  Created by Admin on 15/6/12.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "CustomSheet.h"

@implementation CustomSheet
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(id)initWithupbtn:(NSString *)upname Withdownbtn:(NSString *)downname WithCancelbtn:(NSString *)cacelname withDelegate:(id)delegate{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    if(self){
        //半透明黑色遮挡层
        self.delegate=delegate;
        UIView * barrierView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
        barrierView.backgroundColor = [UIColor clearColor];
        barrierView.alpha = 0.3;
        [self addSubview:barrierView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [barrierView addGestureRecognizer:tap];
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
        [barrierView addGestureRecognizer:swipeDown];
        UISwipeGestureRecognizer *swipeup = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        [swipeup setDirection:UISwipeGestureRecognizerDirectionUp];
        [barrierView addGestureRecognizer:swipeup];
        UISwipeGestureRecognizer *swipeDown1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        [swipeDown1 setDirection:UISwipeGestureRecognizerDirectionRight];
        [barrierView addGestureRecognizer:swipeDown1];
        UISwipeGestureRecognizer *swipeup1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        [swipeup1 setDirection:UISwipeGestureRecognizerDirectionLeft];
        [barrierView addGestureRecognizer:swipeup1];
        UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, kScreenHeitht-150, kScreenWidth-20, 91)];
        bgimg.userInteractionEnabled=YES;
        bgimg.backgroundColor=[UIColor whiteColor];
        bgimg.layer.masksToBounds=YES;
        [bgimg.layer setCornerRadius:8.0];
        [bgimg.layer setBorderWidth:0.5];
        [bgimg.layer setBorderColor:[UIColor grayColor].CGColor];
        [self addSubview:bgimg];
        UIButton *paizhao=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        paizhao.backgroundColor=[UIColor whiteColor];
//        [paizhao.layer setMasksToBounds:YES];
//        [paizhao.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
//        [paizhao.layer setBorderWidth:0.5]; //边框宽度
        [paizhao setTitle:upname forState:UIControlStateNormal];
//        [paizhao.layer setBorderColor:[UIColor grayColor].CGColor];
        paizhao.titleLabel.font=[UIFont fontWithName:kBaseFont size:17];
        [paizhao setTitleColor:[UIColor colorHelpWithRed:248 green:87 blue:61 alpha:1] forState:UIControlStateNormal];
        paizhao.frame=CGRectMake(0, 0, kScreenWidth-20, 46);
        [paizhao addTarget:self action:@selector(btnaction:) forControlEvents:UIControlEventTouchUpInside];
        paizhao.tag=1;
        [bgimg addSubview:paizhao];
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth-20, 1)];
        line.backgroundColor=[UIColor colorHelpWithRed:210 green:210 blue:210 alpha:1];
        [bgimg addSubview:line];
        UIButton *xcbtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        xcbtn.backgroundColor=[UIColor whiteColor];
//        [xcbtn.layer setMasksToBounds:YES];
//        [xcbtn.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
//        [xcbtn.layer setBorderWidth:0.5]; //边框宽度
//        [xcbtn.layer setBorderColor:[UIColor grayColor].CGColor];
        [xcbtn setTitle:downname forState:UIControlStateNormal];
        xcbtn.titleLabel.font=[UIFont fontWithName:kBaseFont size:17];
        [xcbtn setTitleColor:[UIColor colorHelpWithRed:0 green:108 blue:253 alpha:1] forState:UIControlStateNormal];
        xcbtn.frame=CGRectMake(0, 46, kScreenWidth-20, 45);
        [xcbtn addTarget:self action:@selector(btnaction:) forControlEvents:UIControlEventTouchUpInside];
        xcbtn.tag=2;
        [bgimg addSubview:xcbtn];
        UIButton *cacelbtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        cacelbtn.backgroundColor=[UIColor whiteColor];
        [cacelbtn.layer setBorderColor:[UIColor grayColor].CGColor];
        [cacelbtn.layer setMasksToBounds:YES];
        [cacelbtn.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
        [cacelbtn.layer setBorderWidth:0.5]; //边框宽度
        [cacelbtn setTitle:@"取消" forState:UIControlStateNormal];
        cacelbtn.titleLabel.font=[UIFont fontWithName:kBaseFont size:17];
        [cacelbtn setTitleColor:[UIColor colorHelpWithRed:0 green:108 blue:253 alpha:1] forState:UIControlStateNormal];
        cacelbtn.frame=CGRectMake(10, kScreenHeitht-150+46+50, kScreenWidth-20, 45);
        [cacelbtn addTarget:self action:@selector(btnaction:) forControlEvents:UIControlEventTouchUpInside];
        cacelbtn.tag=3;
        [self addSubview:cacelbtn];
    }
    return self;
}
-(void)show
{
    CGRect originFram = self.frame;
    CGRect newFram = CGRectOffset(originFram, 0, +CGRectGetHeight(originFram));
    self.frame = newFram;
    
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
    self.frame = originFram;
    [UIView commitAnimations];
}

-(void)btnaction:(UIButton*)sender{
    [self hide];
    NSInteger tag=sender.tag;
    if ([self.delegate respondsToSelector:@selector(SheetClickWithIndexPath:)]) {
        [self.delegate SheetClickWithIndexPath:tag];
    }
    if ([self.delegate respondsToSelector:@selector(SheetClickWithIndexPath:WithACSheet:)]) {
        [self.delegate SheetClickWithIndexPath:tag WithACSheet:self];
    }
    
}
-(void)hide{
  
    [self removeFromSuperview];
}
- (void)swipeAction:(UISwipeGestureRecognizer *)sender
{
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect originFram = self.frame;
//        CGRect newFram = CGRectOffset(originFram, 0, +CGRectGetHeight(originFram));
//        self.frame = newFram;
//    } completion:^(BOOL finished) {
        [self removeFromSuperview];
//    }];
}
@end
