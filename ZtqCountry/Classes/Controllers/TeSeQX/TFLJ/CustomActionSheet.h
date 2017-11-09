//
//  CustomActionSheet.h
//  ZtqNew
//
//  Created by lihj on 12-11-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomActionSheetDelegate <NSObject>
@required

- (void)doneBtnClicked;
- (void)cancelBtnClicked;

@end


@interface CustomActionSheet : UIActionSheet {
	__weak id <CustomActionSheetDelegate> delegate;
	UIToolbar* toolBar;
	UIView* view;
}

@property (nonatomic, weak)id delegate;
@property(nonatomic,strong)UIView* view;
@property(nonatomic,strong)UIToolbar* toolBar;

-(id)initWithHeight:(float)height WithSheetTitle:(NSString*)title withLeftBtn:(NSString *)leftTitle withRightBtn:(NSString *)rightTitle;

@end