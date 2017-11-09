//
//  Alrert.h
//  Label
//
//  Created by 林炳阳	 on 14-4-23.
//  Copyright (c) 2014年 林炳阳	. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Alrert : UIView<UITextViewDelegate>
- (id)initWithTitle:(NSString *)title imageView:(UIImage *)image
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle;
- (void)show;
@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UITextView *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property(nonatomic,retain)UIImageView *imageview;
@property (nonatomic, strong) UIView *backImageView;
@property(nonatomic,retain)UIImageView *backimag,*closeimage;

@end
