//
//  CalendarViewController.h
//  ZtqNew
//
//  Created by wang zw on 12-7-2.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calendar.h"
#import "PCSDialog.h"

@interface CalendarViewController : UIViewController <CalendarDelegate>{
	Calendar *m_calendar;
	
	PCSDialog *t_dialog;
}

@end
