//
//  PromptBar.m
//  ZtqCountry
//
//  Created by linxg on 14-7-16.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "PromptBar.h"

static PromptBar * sharePromptBar = nil;

@interface PromptBar ()

@property (strong, nonatomic) UILabel * message;
@property (assign, nonatomic) BOOL animating;

@end

@implementation PromptBar


//+(id)shareWithMessage:(NSString *)message withOnView:(UIView *)onView
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharePromptBar = [[self alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
//    });
//    [sharePromptBar setInfoWithMessage:message withOnView:onView];
//    return sharePromptBar;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithMessage:(NSString *)message withOnView:(UIView *)onView
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    if(self)
    {
        [self setInfoWithMessage:message withOnView:onView];
    }
    return self;
    
}

-(void)setInfoWithMessage:(NSString *)message withOnView:(UIView *)onView
{
    self.onView = onView;
    self.backgroundColor = [UIColor clearColor];
    UILabel * messageLab = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, kScreenWidth-2, 25)];
    self.message = messageLab;
    messageLab.textAlignment = NSTextAlignmentCenter;
    messageLab.text = message;
    messageLab.font = [UIFont fontWithName:kBaseFont size:15];
    //        messageLab.backgroundColor = [UIColor grayColor];
    messageLab.backgroundColor = [UIColor colorHelpWithRed:81 green:145 blue:168 alpha:1];
    //    messageLab.backgroundColor = [UIColor blueColor];
    messageLab.textColor = [UIColor whiteColor];
    
    CGRect pathRect = messageLab.bounds;
    pathRect.size = messageLab.frame.size;
    
    messageLab.layer.shadowOpacity = 0.7;
    messageLab.layer.shadowRadius = 1;
    messageLab.layer.shadowColor = [UIColor blackColor].CGColor;
    messageLab.layer.shadowOffset = CGSizeMake(1, 1);
    
    messageLab.layer.shadowPath = [UIBezierPath bezierPathWithRect:pathRect].CGPath;
    [self addSubview:messageLab];
}


-(void)showWithAnimation:(BOOL)animation
{
    self.animating = YES;
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window bringSubviewToFront:self];
    [window addSubview:self];
    if(animation)
    {
        CATransition * animation = [CATransition animation];
        animation.duration = 0.5;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromBottom;
        [self.message.layer addAnimation:animation forKey:@"animation"];
        [self performSelector:@selector(hidenWithAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:2];
        //        self.message.frame = CGRectMake(1, 1, kScreenWidth-2, 30);
        //        [self addSubview:self.message];
    }
    else
    {
        [self addSubview:self.message];
        [self performSelector:@selector(hidenWithAnimation:) withObject:[NSNumber numberWithBool:NO] afterDelay:2];
    }
    
}

-(void)hidenWithAnimation:(BOOL)animation
{
    
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:2];
        [self.message removeFromSuperview];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.message cache:NO];
        [UIView setAnimationDidStopSelector:@selector(stop)];
        [UIView commitAnimations];
    
}

-(void)stop
{
    [self removeFromSuperview];
    self.animating = NO;
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
