//
//  ROPublishPhotoInternal.h
//  SimpleDemo
//
//  Created by Winston on 11-8-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import <UIKit/UIKit.h>
#import "ROConnect.h"

@class ROImageView;
@class ROPublishPhotoDialogModel;

@interface ROPublishPhotoInternal : UIView <UITextViewDelegate>{
   __unsafe_unretained ROPublishPhotoDialogModel * _dialogModel;
    UILabel *_userNameLabel;
    ROImageView *_headImageView;
    UIImageView *_photoImageView;
    UITextView *_captionTextView;
    UILabel *_captionLimitLabel;
    UIButton *_uploadButton;
    UIButton *_cancelButton;
    
    UIImageView *_headBackgroundView;
    UIImageView *_captionBackgroundView;
    UIImageView *_photoBackgroundView;
    UIImageView *_optionBackgroundView;
    BOOL _isKeywordHidden;
}
@property (nonatomic ,assign)ROPublishPhotoDialogModel *dialogModel;
@property (nonatomic ,strong)UILabel *userNameLabel;
@property (nonatomic ,strong)ROImageView *headImageView;
@property (nonatomic ,strong)UIImageView *photoImageView;
@property (nonatomic ,strong)UITextView *captionTextView;
@property (nonatomic ,strong)UILabel *captionLimitLabel;
@property (nonatomic ,strong) UIButton * uploadButton;
@property (nonatomic ,strong) UIButton * cancelButton;

- (void)setCaptionLimitTips;
- (void)setVerticalFrame;
- (void)setHorizontalFrame;
@end
