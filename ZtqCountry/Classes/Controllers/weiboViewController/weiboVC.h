//
//  weiboVC.h
//  ztq_heilj
//
//  Created by lihj on 12-10-30.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBShareKey.h"
#import "ShareFun.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "Renren.h"
#import "TCWBEngine.h"
//#import "CHStatusBar.h"

@interface weiboVC : UIViewController <UITextViewDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate, RenrenDelegate>{

	UIButton		*backBut;
	UITextView      *_textView;
    UILabel         *_stateLabel;
    UILabel         *_countLabel;
	SinaWeibo		*_sinaweibo;
	Renren			*_renren;
	TCWBEngine      *_TCWeibo;
	
//	CHStatusBar		*m_statusBar;
	UIButton *shareBtn;
}

@property WBShareType shareType;
@property (nonatomic, copy)NSString *shareText;
@property (nonatomic, copy)NSString *shareImage;
@property (retain,nonatomic)Renren *renren;
@property(nonatomic,assign) BOOL isCallBack;
- (SinaWeibo *)sinaweibo;
- (TCWBEngine *)tcweibo;
- (int)wordCount:(NSString*)s;
- (void)dealWithError:(ROError *)error;

@end
