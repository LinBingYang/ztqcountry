//
//  PCSDialog.h
//  Ztq_public
//
//  Created by linxg on 12-3-22.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PCSDialog : UIView {
	UIView *_dlgView;
}

- (void) setDialogView:(UIView *)dlgView;
- (void) show;
- (void) close;
@end
