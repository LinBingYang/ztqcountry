//
//  Alrert.m
//  Label
//
//  Created by 林炳阳	 on 14-4-23.
//  Copyright (c) 2014年 林炳阳	. All rights reserved.
//

#import "Alrert.h"
#define kAlertWidth 300
#define kAlertHeight 150

@implementation Alrert{
    BOOL _leftLeave;
}

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}
#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithTitle:(NSString *)title imageView:(UIImage *)image contentText:(NSString *)content leftButtonTitle:(NSString *)leftTitle{
    if (self = [super init]) {

        self.imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAlertWidth, kAlertHeight)];
        self.imageview.image=image;
        self.imageview.tag=10101010;
        [self addSubview:self.imageview];
        self.imageview.userInteractionEnabled=YES;
//        self.backimag=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, kAlertWidth, kAlertHeight)];
//       // self.backimag.image=[UIImage imageNamed:@"七夕_03"];
//        [self addSubview:self.backimag];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kTitleYOffset, kAlertWidth, kTitleHeight)];
        self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        self.alertTitleLabel.textColor = [UIColor whiteColor];
        self.alertTitleLabel.backgroundColor=[UIColor clearColor];
        [self.imageview addSubview:self.alertTitleLabel];
        
        CGFloat contentLabelWidth = kAlertWidth - 16;
        self.alertContentLabel = [[UITextView alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5+75, CGRectGetMaxY(self.alertTitleLabel.frame)+20, contentLabelWidth-80, 60)];
       
        self.alertContentLabel.textColor = [UIColor whiteColor];
        self.alertContentLabel.scrollEnabled=YES;
        self.alertContentLabel.delegate=self;
        self.alertContentLabel.editable=NO;
        self.alertContentLabel.showsVerticalScrollIndicator=YES;
        self.alertContentLabel.autoresizingMask=UIViewAutoresizingFlexibleHeight;//自适高度
        self.alertContentLabel.returnKeyType= UIReturnKeyDefault;
        self.alertContentLabel.textAlignment=NSTextAlignmentJustified;//两端对齐
        self.alertContentLabel.backgroundColor=[UIColor clearColor];
        self.alertContentLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.imageview addSubview:self.alertContentLabel];
        
        
        self.alertTitleLabel.text = [NSString stringWithFormat:@"  %@",title];
        self.alertContentLabel.text = content;
        
        

        CGRect leftBtnFrame;

        
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 130.0f
#define kButtonHeight 40.0f
#define kButtonBottomOffset 10.0f
       
            leftBtnFrame = CGRectMake(265, 0,35, 35);

            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];

            self.leftBtn.frame = leftBtnFrame;
        
        }

     [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"关闭_03.png"] forState:UIControlStateNormal];
    
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftBtn];
    
        
    
        
    
    return self;
}
- (void)leftBtnClicked:(id)sender
{
    _leftLeave = YES;
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock();
    }
}
- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)show
{
    UIWindow *shareWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake((CGRectGetWidth(shareWindow.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, kAlertWidth, kAlertHeight);
    [shareWindow addSubview:self];
}
- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIWindow *shareWindow = [UIApplication sharedApplication].keyWindow;
    CGRect afterFrame = CGRectMake((CGRectGetWidth(shareWindow.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(shareWindow.bounds), kAlertWidth, kAlertHeight);
    
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
            } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIWindow *shareWindow = [UIApplication sharedApplication].keyWindow;
    if(![shareWindow viewWithTag:10101010])
    {
        self.backImageView = [[UIView alloc] initWithFrame:shareWindow.bounds];
    }
//    if (!self.backImageView) {
//        self.backImageView = [[UIView alloc] initWithFrame:shareWindow.bounds];
//    }
    self.backImageView.backgroundColor = [UIColor blackColor];
    self.backImageView.alpha = 0.8f;
    [shareWindow addSubview:self.backImageView];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(shareWindow.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(shareWindow.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
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
