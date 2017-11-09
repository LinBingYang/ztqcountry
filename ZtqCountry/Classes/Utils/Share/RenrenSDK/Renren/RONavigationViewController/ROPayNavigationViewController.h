//
//  ROPayNavigationViewController.h
//  RenrenSDKDemo
//
//  Created by xiawh on 11-11-13.
//  Copyright (c) 2011年 renren－inc. All rights reserved.
//

#import "ROBaseNavigationViewController.h"
#import "ROPayDialogViewController.h"

@interface ROPayNavigationViewController : ROBaseNavigationViewController <UIWebViewDelegate>{
    UIWebView *_webView;
    NSString *_url;
    NSMutableDictionary *_params;
//    id<RenrenPayDialogDelegate> _delegate;
    __weak id<RenrenPayDialogDelegate> _delegate;
    UIActivityIndicatorView *_indicatorView;
}

@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSMutableDictionary *params;
@property (nonatomic,weak)id<RenrenPayDialogDelegate> delegate;
@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;

@end
