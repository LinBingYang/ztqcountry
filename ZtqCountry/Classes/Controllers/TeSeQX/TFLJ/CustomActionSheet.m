//
//  CustomActionSheet.m
//  ZtqNew
//
//  Created by lihj on 12-11-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomActionSheet.h"

@implementation CustomActionSheet

@synthesize delegate;
@synthesize view;
@synthesize toolBar;

-(id)initWithHeight:(float)height WithSheetTitle:(NSString*)title withLeftBtn:(NSString *)leftTitle withRightBtn:(NSString *)rightTitle
{
	self = [super init];
    if (self) {
		int theight = height - 40;
		int btnnum = theight/50;
		for(int i=0; i<btnnum; i++){
			[self addButtonWithTitle:@" "];
		}
		toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
		toolBar.barStyle = UIBarStyleBlackOpaque;
//		UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:title 
//                                                                        style:UIBarButtonItemStylePlain 
//                                                                       target:nil 
//                                                                       action:nil];
		
//		UILabel *t_label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)] autorelease];
        UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
		[t_label setText:title];
		[t_label setTextColor:[UIColor whiteColor]];
		[t_label setBackgroundColor:[UIColor clearColor]];
		[t_label setTextAlignment:UITextAlignmentCenter];
		UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithCustomView:t_label];
		
		__strong UIBarButtonItem *rightButton;
		UIBarButtonItem *leftButton;
		if (rightTitle) {
			rightButton = [[UIBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStyleDone 
																		   target:self
																		   action:@selector(done)];
		}
		
		if (leftTitle) {
		leftButton  = [[UIBarButtonItem alloc] initWithTitle:leftTitle style:UIBarButtonItemStyleBordered 
                                                                       target:self 
                                                                       action:@selector(docancel)];
		}
		
		UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                                      target:nil 
                                                                                      action:nil];
		
		if (!rightTitle)
        {
//			rightButton = [fixedButton retain];
            rightButton = fixedButton;
        }

		if (!leftTitle)
        {
//           rightButton = [fixedButton retain];
            rightButton = fixedButton;
        }
			

		NSArray *array = [[NSArray alloc] initWithObjects:leftButton,fixedButton,titleButton,fixedButton,rightButton,nil];
		[toolBar setItems: array];
//		[titleButton release];
		if (leftTitle)
        {
//            [leftButton  release];
            leftButton = nil;
        }
			
		if (rightTitle)
        {
            rightButton = nil;
//            [rightButton release];
        }
			
//		[fixedButton release];
//		[array       release];
		[self addSubview:toolBar];
		view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, height-44)];
		view.backgroundColor = [UIColor groupTableViewBackgroundColor];
		[self addSubview:view];
    }
    return self;
}

-(void)done{
	if (delegate && [delegate respondsToSelector:@selector(doneBtnClicked)]) {
		[delegate doneBtnClicked];
	}
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)docancel{
	if (delegate && [delegate respondsToSelector:@selector(cancelBtnClicked)]) {
		[delegate cancelBtnClicked];
	}
	[self dismissWithClickedButtonIndex:0 animated:YES];
}
//
//-(void)dealloc{
//	[view release];
//	[super dealloc];
//}

@end
