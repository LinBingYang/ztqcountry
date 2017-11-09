//
//  aboutZTQ.h
//  ZtqNew
//
//  Created by wang zw on 12-8-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ShareSheet.h"
@interface aboutZTQ : UIViewController <UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,ShareSheetDelegate>{
	NSString *content;
	UIImageView *m_gdBg;
}
@property (nonatomic, retain)NSString *content;
@property(strong,nonatomic)NSString *duanxinstr;
@property(strong,nonatomic)UIImage *shareimg;
@property(strong,nonatomic)NSString *sharecontent;//分享内容
@end
