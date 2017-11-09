//
//  travelDetailView.h
//  ZtqNew
//
//  Created by lihj on 12-6-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareFun.h"
#import "EGOImageView.h"

@interface travelDetailView : UIView <UITableViewDelegate,UITableViewDataSource>{
	UITableView *m_tableView;
	EGOImageView *m_img;
	UITextView *m_des;
	NSString *m_str;
	NSString *m_strImg;
}
@property(assign)float barhight;
- (void) updateView:(NSString *)t_des withImage:(NSString *)t_img;
@end
