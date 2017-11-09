//
//  datePickView.h
//  Ztq_public
//
//  Created by linxg on 12-3-22.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCSDialog.h"

@class datePickView;

@protocol datePickViewDelegate 

- (void) didSelectDate:(datePickView *)dpView withDate:(NSDate *)dt;

@end


@interface datePickView : UIView {
	PCSDialog *_dlg;
	UIDatePicker *_datePicker;
	UIButton *_buttonPress;
	
//	id<datePickViewDelegate> delegate;
    __weak id<datePickViewDelegate> delegate;
}

@property (nonatomic, weak)id delegate;

- (void) showDatePickDlg;
- (void) closeDatePickDlg;
- (void) setDate:(NSDate *)t_date;
- (void) setMinDate:(NSDate *)t_minDate andMaxDate:(NSDate *)t_maxDate;
@end
