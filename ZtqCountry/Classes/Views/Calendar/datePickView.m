//
//  datePickView.m
//  Ztq_public
//
//  Created by linxg on 12-3-22.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "datePickView.h"
#import <QuartzCore/QuartzCore.h>
#import "ShareFun.h"

@implementation datePickView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) 
	{
		_dlg = [[PCSDialog alloc] initWithFrame:CGRectMake(0, 0, self.width, 200)];
		[_dlg setDialogView:self];
				
		UIImageView *bg = [[UIImageView alloc] initWithFrame:self.frame];
		[bg setImage:[UIImage imageNamed:@"对话框背景.png"]];
		[self addSubview:bg];
//		[bg release];
		
		_datePicker = [[UIDatePicker alloc] initWithFrame:self.frame];
        _datePicker.backgroundColor=[UIColor whiteColor];
		[self addSubview:_datePicker];
//		[_datePicker release];
		[_datePicker setDatePickerMode:UIDatePickerModeDate];
		
		_buttonPress = [UIButton buttonWithType:UIButtonTypeCustom];
		[self addSubview:_buttonPress];
		[_buttonPress setFrame:CGRectMake(20, _datePicker.frame.size.height + 10, frame.size.width - 40, 30)];
		[_buttonPress setBackgroundImage:[UIImage imageNamed:@"aboutButton.png"] forState:UIControlStateNormal];
		[_buttonPress addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
		[_buttonPress setTitle:@"确定" forState:UIControlStateNormal];
		[_buttonPress setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_buttonPress.layer.masksToBounds =YES;
		_buttonPress.layer.cornerRadius = 5.0;
		_buttonPress.layer.borderWidth = 1.0;
		_buttonPress.layer.borderColor = [[UIColor clearColor] CGColor];

    }
    return self;
}

//- (void)dealloc {
//	[_dlg release];
//    [super dealloc];
//}

- (void) showDatePickDlg
{
	[_dlg show];
}

- (void) closeDatePickDlg
{
	[_dlg close];
}

- (void) setDate:(NSDate *)t_date
{
	[_datePicker setDate:t_date];
}

- (void) setMinDate:(NSDate *)t_minDate andMaxDate:(NSDate *)t_maxDate
{
	_datePicker.minimumDate = t_minDate;
	_datePicker.maximumDate = t_maxDate;
}

- (void)buttonPressed
{
	if (delegate)
		[delegate didSelectDate:self withDate:[_datePicker date]];
	
	[_dlg close];
}
@end
