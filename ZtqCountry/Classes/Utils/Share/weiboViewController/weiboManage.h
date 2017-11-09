//
//  weiboManage.h
//  ZtqNew
//
//  Created by wang zw on 12-8-3.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "WBShareKey.h"
#import "TCWBEngine.h"
#import "Renren.h"

@interface weiboManage : UIViewController <UITableViewDelegate, UITableViewDataSource, SinaWeiboDelegate, SinaWeiboRequestDelegate, RenrenDelegate>{
	UITableView		*m_tableView;
	SinaWeibo		*_sinaweibo;
	TCWBEngine      *_TCWeibo;
	Renren			*_renren;
}

@property (retain,nonatomic)Renren *renren;

- (SinaWeibo *)sinaweibo;
- (TCWBEngine *)tcweibo;
- (void)storeAuthData;
@end
