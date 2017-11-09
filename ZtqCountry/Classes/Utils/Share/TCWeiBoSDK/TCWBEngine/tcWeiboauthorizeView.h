//
//  SinaWeiboAuthorizeView.h
//  sinaweibo_ios_sdk
//
//  Created by Wade Cheng on 4/19/12.
//  Copyright (c) 2012 SINA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol tcWeiboauthorizeViewDelegate;

@interface tcWeiboauthorizeView : UIView <UIWebViewDelegate>
{
    UIWebView *webView;
    UIButton *closeButton;
    UIView *modalBackgroundView;
    UIActivityIndicatorView *indicatorView;
    UIInterfaceOrientation previousOrientation;
    
    __weak id<tcWeiboauthorizeViewDelegate> delegate;
    
    NSString *appRedirectURI;
    NSString *URLString;
	NSError *err;                   // 假如授权失败，错误描述信息
}

@property (nonatomic, weak) id<tcWeiboauthorizeViewDelegate> delegate;
@property (nonatomic, strong) NSString * URLString;

- (id)initWithURLString:(NSString *)string
                delegate:(id<tcWeiboauthorizeViewDelegate>)delegate;

- (void)show;
- (void)hide;

@end

@protocol tcWeiboauthorizeViewDelegate <NSObject>

//授权成功回调
- (void)authorize:(tcWeiboauthorizeView *)authorize didSucceedWithAccessToken:(NSString *)code;
//授权失败回调
- (void)authorize:(tcWeiboauthorizeView *)authorize didFailuredWithError:(NSError *)error;

@end

extern BOOL tcWeiboIsDeviceIPad();