//
//  tf_detailViewController.h
//  ZtqNew
//
//  Created by lihj on 12-8-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "typhoonYearModel.h"
#import "typhoonDetailModel.h"

@interface tf_detailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{

	NSInteger m_num;
	NSInteger m_type;	//台风路径 预报类型
	NSString *m_str;
	typhoonYearModel *m_tfModel;
	UITableView *m_tableView;
}
@property (nonatomic, strong) typhoonYearModel * m_tfModel;

- (void)setMapData:(typhoonYearModel *)t_model withNum:(NSInteger)t_num withType:(NSInteger)t_type;

@end
