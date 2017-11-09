//
//  SinaWeiboAuthorizeView.h
//  sinaweibo_ios_sdk
//
//  Created by Wade Cheng on 4/19/12.
//  Copyright (c) 2012 SINA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RenRenAuthorizeView : UIView <UIWebViewDelegate>
{
    UIWebView *webView;
    UIButton *closeButton;
    UIView *modalBackgroundView;
    UIActivityIndicatorView *indicatorView;
    UIInterfaceOrientation previousOrientation;
    
    __weak id<RODialogDelegate> delegate;
	
    NSMutableDictionary *_params;
	ROResponse* _response;
	NSString *_serverURL;
}

@property (nonatomic, weak) id<RODialogDelegate> delegate;
@property (nonatomic,strong)ROResponse *response;
@property (nonatomic,strong)NSString *serverURL;
@property (nonatomic,strong)NSMutableDictionary *params;

- (id)initWithAuthParams;

- (void)show;
- (void)hide;

@end