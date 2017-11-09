//
//  ShareFunction.h
//  NetWorking
//
//  Created by il ea on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//



#import <UIKit/UIKit.h>
@interface ShareFunction : NSObject {
	
}

+(UIButton *)Button:(NSString *)t_name Target:(id)t_target Sel:(SEL)t_sel;

+(UIButton *)Button:(NSString *)t_name Target:(id)t_target Sel:(SEL)t_sel Img1:(NSString *)t_img1 Img2:(NSString *)t_img2;

+(UITextField *)TextFieldWithDelegate:(id)t_delegate withFrame:(CGRect)t_frame;

+(UILabel *)LabelWithText:(NSString *)t_text withFrame:(CGRect)t_frame;

+(UILabel *)LabelWithText:(NSString *)t_text withFrame:(CGRect)t_frame withFontSize:(NSUInteger) size;
@end