//
//  AboutView.m
//  AboutView
//
//  Created by 黄 芦荣 on 12-3-19.
//  Copyright 2012 卓派. All rights reserved.
//

#import "AboutView.h"
#import "ShareFun.h"

static const int titleSize = 20;

static UIWindow *maskWindow = nil;

@interface AboutView(PrivateMethods)


+(void)maskWindowPresent;
+ (void)maskWindowDismiss;
+(void)maskWindowAddAbout:(AboutView *)aboutView;
+ (void)maskWindowRemoveAbout:(AboutView *)aboutView;
@end

@implementation AboutView

@synthesize aboutImageView;
@synthesize logoImageView;
@synthesize title;
@synthesize content;
@synthesize my_button;
@synthesize text;


+(void)maskWindowPresent{
	
	if (!maskWindow) {
		
		maskWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
		maskWindow.windowLevel = UIWindowLevelStatusBar + 1;
		maskWindow.backgroundColor = [UIColor clearColor];
		[maskWindow makeKeyAndVisible];
		maskWindow.hidden  = NO;
	}
}

+ (void)maskWindowDismiss{
	
	if (maskWindow) {
//		[maskWindow release];
		maskWindow = nil;
	}
}

+(void)maskWindowAddAbout:(AboutView *)aboutView{
	
	if (!maskWindow || [maskWindow.subviews containsObject:aboutView]) {
		return;
	}
	
	[maskWindow addSubview:aboutView];
	aboutView.hidden = NO;
}

+ (void)maskWindowRemoveAbout:(AboutView *)aboutView{
	
	if (!maskWindow || ![maskWindow.subviews containsObject:aboutView]) {
		return;
	}
	
	[aboutView removeFromSuperview];
	aboutView.hidden = YES;
}


-(void)show{
	
	[AboutView maskWindowPresent];
	[AboutView maskWindowAddAbout:self];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.6f];
	CGRect rect = [self frame];
	rect.origin.y = 0.0f;
	[self setFrame:rect];
	[UIView commitAnimations];
}

-(void)removeFromView{
	
    if([self.delegate respondsToSelector:@selector(AboutViewBack)])
    {
        [self.delegate AboutViewBack];
    }
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	[UIView beginAnimations:nil context:context];
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//	[UIView setAnimationDuration:0.8f];	
//	CGRect rect = [self frame];
//	rect.origin.y = -10.0f - rect.size.height;
//	[self setFrame:rect];
//	[UIView commitAnimations];
//	[self performSelector:@selector(close) withObject:nil afterDelay:0.6f];
}

-(void)close{
	
	[AboutView maskWindowRemoveAbout:self];
	[AboutView maskWindowDismiss];
	
}


#pragma mark -
#pragma mark -AboutViewInit

-(id)initWithFrame:(CGRect)frame{
	
//	frame.origin.y = - frame.size.height;
	if(self = [super initWithFrame:frame]){
		
		[self setAlpha:1.0f];
		[self setBackgroundColor:[UIColor clearColor]];
		
		int origin_x = 0;
		int origin_y = 0;
		int offset = 0;
		int max_content_h = frame.size.height-80 ;
		aboutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(origin_x, origin_y, frame.size.width, frame.size.height)];
        aboutImageView.backgroundColor = [UIColor whiteColor];
//		[aboutImageView setImage:[UIImage imageNamed:@"对话框背景.png"]];
		[self addSubview:aboutImageView];
//		[aboutImageView release];
		
		
		CGRect t_frame = CGRectMake(0, 0, frame.size.width, max_content_h);
		UIFont *font = [UIFont systemFontOfSize:15];
		CGSize textSize =  [text sizeWithFont:font constrainedToSize:t_frame.size lineBreakMode:UILineBreakModeCharacterWrap];
		if (textSize.height > max_content_h)
		{//超过最大高度，content高度进行压缩
			
		}
		else 
		{
			//多余的高度
			offset = max_content_h - textSize.height;
			
		}

		t_frame = CGRectMake(origin_x + 135, origin_y + 10, 50, 50);
		logoImageView =[[UIImageView alloc] initWithFrame:t_frame];
		[logoImageView setImage:[UIImage imageNamed:@"icon.png"]];
//		[self addSubview:logoImageView];
//		[logoImageView release];
		
		t_frame = CGRectMake(origin_x + 85 , origin_y + 60, 150, 30);
		title = [[UILabel alloc] initWithFrame:t_frame];
		[title setTextColor:[UIColor blackColor]];
		[title setFont:[UIFont systemFontOfSize:titleSize]];
		[title setTextAlignment:NSTextAlignmentCenter];
		[title setBackgroundColor:[UIColor clearColor]];
//		[self addSubview:title];
//		[title release];
		
		t_frame = CGRectMake(origin_x + 10, origin_y + 10, 300, self.frame.size.height);
		content = [[UITextView alloc]initWithFrame:t_frame];
		content.backgroundColor = [UIColor clearColor];
		[content setTextColor:[UIColor blackColor]];
		content.font = font;
		content.editable = NO;
		content.scrollEnabled = YES;
		content.text = text;
		[self addSubview:content];
//		[content release];
		
        
		t_frame = CGRectMake(origin_x +110, self.frame.size.height-50, 100, 35);
		my_button = [[UIButton alloc] initWithFrame:t_frame];		
		my_button.backgroundColor =[UIColor clearColor];
		[my_button setTitleColor:[UIColor whiteColor] forState:0];
		[my_button setBackgroundImage:[UIImage imageNamed:@"mzsmaniu_03.png"] forState:0];
        [my_button setBackgroundImage:[UIImage imageNamed:@"mzsm点击_03.png"] forState:UIControlStateHighlighted];
		[my_button setTitle:@"知道了" forState:0];
//		my_button.layer.masksToBounds =YES;
//		my_button.layer.cornerRadius = 5.0;
//		my_button.layer.borderWidth = 1.0;
//		my_button.layer.borderColor = [[UIColor clearColor] CGColor];
		[my_button addTarget:self action:@selector(removeFromView) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:my_button];
//		[my_button release];
	}
	
	return self;
}

-(id)initWithView:(NSString *)my_title setMessage:(NSString *)messageText setRect:(CGRect)rect{
	
	text = [[NSString alloc] initWithString:messageText];
    if([self initWithFrame:rect])
    {
        [title setText:my_title];
    }
//	[self initWithFrame:rect];
	
	return self;
}


//-(void)dealloc{
// [text release];
// 
// [super dealloc];
// }

@end