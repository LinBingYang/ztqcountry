//
//  forgetView.h
//  ZtqCountry
//
//  Created by Admin on 14-11-15.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forgetView : UIView<UITextFieldDelegate>
- (id)initWithTitle:(NSString *)title imageView:(UIImage *)image
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle;
- (void)show;
@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UITextField *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property(nonatomic,retain)UIImageView *imageview;
@property (nonatomic, strong) UIView *backImageView;
@property(nonatomic,retain)UIImageView *backimag,*closeimage;

@end
