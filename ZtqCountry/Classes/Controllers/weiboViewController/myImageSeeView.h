//
//  SinaWeiboAuthorizeView.h
//  sinaweibo_ios_sdk
//
//  Created by Wade Cheng on 4/19/12.
//  Copyright (c) 2012 SINA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myImageSeeView : UIView <UIScrollViewDelegate>
{
    UIButton *closeButton;
    UIView *modalBackgroundView;
    UIInterfaceOrientation previousOrientation;

	UIScrollView *_scrollView;
	UIImageView *m_imageView;
}

- (id)initWithImageName:(NSString *)imageName;
- (void)show;
- (void)hide;

@end
