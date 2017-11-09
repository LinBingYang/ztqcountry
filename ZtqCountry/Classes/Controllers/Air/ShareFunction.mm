//
//  ShareFunction.m
//  NetWorking
//
//  Created by il ea on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShareFunction.h"


NSString *URL_HEAD;
NSString *QXFWURL_HEAD;
@implementation ShareFunction

+(UIButton *)Button:(NSString *)t_name Target:(id)t_target Sel:(SEL)t_sel
{
	return [self Button:t_name Target:t_target Sel:t_sel Img1:@"btn_black1_0.png" Img2:@"btn_black1_1.png"];
}

+(UIButton *)Button:(NSString *)t_name Target:(id)t_target Sel:(SEL)t_sel Img1:(NSString *)t_img1 Img2:(NSString *)t_img2
{
	//UIImage *btn1=[[UIImage imageNamed:t_img1] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	//UIImage *btn2=[[UIImage imageNamed:t_img2] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	
	UIImage *btn1=[UIImage imageNamed:t_img1];
	UIImage *btn2=[UIImage imageNamed:t_img2];
	
//	UIButton *button=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
	button.frame=CGRectMake(0,0,btn1.size.width, btn1.size.height);
	[button setTitle:t_name forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
	[button setBackgroundImage:btn1 forState:UIControlStateNormal];
	[button setBackgroundImage:btn2 forState:UIControlStateHighlighted];
	[button addTarget:t_target action:t_sel forControlEvents:UIControlEventTouchUpInside];
	return button;
}

+(UITextField *)TextFieldWithDelegate:(id)t_delegate withFrame:(CGRect)t_frame
{
	UIImage *t_image=[[UIImage imageNamed:@"chat_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	UITextField *textField = [[UITextField alloc] initWithFrame:t_frame];
	[textField setBackground:t_image];
	//textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
	//[textField setAutocorrectionType:UITextAutocorrectionTypeDefault];
	//[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	//textField.clearsOnBeginEditing = NO;
	textField.font=[UIFont fontWithName:@"Helvetica" size:15];
	//[textField setKeyboardType:UIKeyboardTypeDefault];
	[textField setDelegate:t_delegate];
	return textField;
}

+(UILabel *)LabelWithText:(NSString *)t_text withFrame:(CGRect)t_frame
{
	UILabel *label = [[UILabel alloc] initWithFrame:t_frame];
	[label setText:t_text];
	label.textColor=[UIColor whiteColor];
	[label setBackgroundColor:[UIColor clearColor]];
	label.font=[UIFont fontWithName:@"Helveticax" size:14];
	return label;
}
+(UILabel *)LabelWithText:(NSString *)t_text withFrame:(CGRect)t_frame withFontSize:(NSUInteger) size
{
	UILabel *label = [[UILabel alloc] initWithFrame:t_frame];
	[label setText:t_text];
	label.textColor=[UIColor whiteColor];
	[label setBackgroundColor:[UIColor clearColor]];
	label.font=[UIFont fontWithName:@"Helvetica" size:size];
	return label;
}


@end
