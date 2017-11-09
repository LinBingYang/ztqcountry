//
//  popInfoView.m
//  ZtqNew
//
//  Created by wang zw on 12-10-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "popInfoView.h"
#import "ShareFun.h"

@interface popInfoView (Private)

- (void)bounceOutAnimationStopped;
- (void)bounceInAnimationStopped;
- (void)bounceNormalAnimationStopped;
- (void)allAnimationsStopped;

@end

@implementation popInfoView

@synthesize panelView;

- (id)initWithFrame:(CGRect)t_frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, self.width, 480)])
    {
        // background settings
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		
//		UIButton *t_closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//		[t_closeBtn setBackgroundColor:[UIColor clearColor]];
//		[t_closeBtn addTarget:self action:@selector(onCloseButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
//		[self addSubview:t_closeBtn];
//		[t_closeBtn release];
		
        // add the panel view
        panelView = [[UIView alloc] initWithFrame:t_frame];
        //[panelView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.55]];
		[panelView setClipsToBounds:YES];
        [self addSubview:panelView];
    }
    return self;
}

//- (void)dealloc
//{
//    [panelView release], panelView = nil;
//	
//    [super dealloc];
//}

#pragma mark Actions

- (void)onCloseButtonTouched:(id)sender
{
    [self hide:YES];
}

#pragma mark Animations

- (void)bounceOutAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
    [panelView setAlpha:0.8];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
	[UIView commitAnimations];
}

- (void)bounceInAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceNormalAnimationStopped)];
    [panelView setAlpha:1.0];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
	[UIView commitAnimations];
}

- (void)bounceNormalAnimationStopped
{
    [self allAnimationsStopped];
}

- (void)allAnimationsStopped
{
    // nothing shall be done here
}

#pragma mark Dismiss

- (void)hideAndCleanUp
{
	[self removeFromSuperview];
}

#pragma mark Public Methods

- (void)show:(BOOL)animated
{
//	UIWindow *window = [UIApplication sharedApplication].keyWindow;
//	if (!window)
//	{
//		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//	}
//	[window addSubview:self];
	
	//为了使present出的微博分享页面，使用这种下面方式添加，若不需要此效果，请删除#import "ShareFun.h"，并使用上面方式添加
	[[[ShareFun shareAppDelegate] window].rootViewController.view addSubview:self];
    
    if (animated)
    {
        [panelView setAlpha:0];
        CGAffineTransform transform = CGAffineTransformIdentity;
        [panelView setTransform:CGAffineTransformScale(transform, 0.3, 0.3)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounceOutAnimationStopped)];
        [panelView setAlpha:0.5];
        [panelView setTransform:CGAffineTransformScale(transform, 1.1, 1.1)];
        [UIView commitAnimations];
    }
    else
    {
        [self allAnimationsStopped];
    }
}

- (void)hide:(BOOL)animated
{
	if (animated)
    {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hideAndCleanUp)];
		[self setAlpha:0];
		[UIView commitAnimations];
	} 
    [self hideAndCleanUp];
}

@end
