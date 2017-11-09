//
//  PCSDialog.m
//  Ztq_public
//
//  Created by linxg on 12-3-22.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PCSDialog.h"


static UIWindow *maskWindowPCS = nil;

@interface PCSDialog(PrivateMethods)

+ (void)maskWindowPresent;
+ (void)maskWindowDismiss;
+ (void)maskWindowAddDlgView:(PCSDialog *)dlgView;
+ (void)maskWindowRemovedlgView:(PCSDialog *)dlgView;
@end


@implementation PCSDialog

+ (void)maskWindowPresent{
	
	if (!maskWindowPCS) {
		
		maskWindowPCS = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
		maskWindowPCS.windowLevel = UIWindowLevelStatusBar + 1;
		maskWindowPCS.backgroundColor = [UIColor clearColor];
		[maskWindowPCS makeKeyAndVisible];
		maskWindowPCS.hidden  = NO;
	}
}

+ (void)maskWindowDismiss{
	
	if (maskWindowPCS) {
//		[maskWindowPCS release];
		maskWindowPCS = nil;
	}
}

+ (void)maskWindowAddDlgView:(PCSDialog *)dlgView{
	
	if (!maskWindowPCS || [maskWindowPCS.subviews containsObject:dlgView]) {
		return;
	}
	
	[maskWindowPCS addSubview:dlgView];
	dlgView.hidden = NO;
}

+ (void)maskWindowRemovedlgView:(PCSDialog *)dlgView{
	
	if (!maskWindowPCS || ![maskWindowPCS.subviews containsObject:dlgView]) {
		return;
	}
	
	[dlgView removeFromSuperview];
	dlgView.hidden = YES;
}

- (void) setDialogView:(UIView *)dlgView
{
	if (dlgView == nil)
		return;
	
	[_dlgView removeFromSuperview];
	_dlgView = dlgView;
	
	
	CGRect t_frame = _dlgView.frame;
	t_frame.origin.y = -t_frame.size.height;
	[self setFrame:t_frame];
	[self addSubview:_dlgView];
}

-(void) show {
	
	[PCSDialog maskWindowPresent];
	[PCSDialog maskWindowAddDlgView:self];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	CGRect rect = [self frame];
	rect.origin.y = 0.0f;
	[self setFrame:rect];
	[UIView commitAnimations];
}

- (void) close {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];	
	CGRect rect = [self frame];
	rect.origin.y = -10.0f - rect.size.height;
	[self setFrame:rect];
	[UIView commitAnimations];
	[self performSelector:@selector(removeFromView) withObject:nil afterDelay:0.3f];
}

- (void) removeFromView {

	if (_dlgView != nil)
		[_dlgView removeFromSuperview];
	[PCSDialog maskWindowRemovedlgView:self];
	[PCSDialog maskWindowDismiss];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

//- (void)dealloc {
//    [super dealloc];
//}

@end
