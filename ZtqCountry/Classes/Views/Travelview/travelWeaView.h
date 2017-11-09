//
//  travelWeaView.h
//  ZtqNew
//
//  Created by lihj on 12-6-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareFun.h"
#import "mainVCmainVModel.h"

@interface travelWeaView : UIView <UITableViewDelegate,UITableViewDataSource>{
@public	UITableView *m_tableView;
	NSString *city;
    
	mainVCmainVModel *m_mainVCmainVModel;
	UIButton *mybutton;
	
	__unsafe_unretained id m_target;
    
    TreeNode *m_province;
	TreeNode *m_allCity;
}

@property (nonatomic, assign)id m_target;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *mycity;
@property(nonatomic,strong)NSString *strcity;
@property(nonatomic,strong)NSString *imgurl;
@property(assign)float barhight;
- (void)setTravelCity:(NSString *)detailCity;
- (void) updateView:(mainVCmainVModel *)t_model withName:(NSString *)name Withimg:(NSString *)imgurl;

@end
