//
//  ROWebNavigationViewController.h
//  RenrenSDKDemo
//
//  Created by xiawh on 11-11-14.
//  Copyright (c) 2011年 renren－inc. All rights reserved.
//

#import "ROBaseNavigationViewController.h"

@interface ROWebNavigationViewController : ROBaseNavigationViewController<UIWebViewDelegate>{
    UIWebView *_webView;
    NSString *_serverURL;
    ROResponse* _response;
    NSMutableDictionary *_params;
//    id<RODialogDelegate> _delegate;
    __weak id<RODialogDelegate> _delegate;
    UIActivityIndicatorView *_indicatorView;
}
@property(nonatomic, weak)id<RODialogDelegate> delegate;
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSString *serverURL;
@property (nonatomic,strong)ROResponse *response;
@property (nonatomic,strong)NSMutableDictionary *params;
@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;

@end