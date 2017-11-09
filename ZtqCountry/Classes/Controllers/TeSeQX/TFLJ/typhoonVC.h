//
//  typhoonVC.h
//  ZtqNew
//
//  Created by lihj on 12-11-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "typhoonYearModel.h"
#import "typhoonView.h"

@interface typhoonVC : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>{

	NSInteger _plugin;//插件索引
	
	typhoonView *m_typhoonView;
	typhoonYearModel *tf_yearModel;
	
	UIBarButtonItem *m_btnPlay;
	NSMutableArray *tf_list;
	NSInteger m_mapMode;
	NSString *m_title;
	
	NSInteger selectedPickerRow;
	NSString *currentCode;
}
@property(assign)BOOL cancj;//是否测距
@property (nonatomic, assign)NSInteger plugin;
@property (nonatomic, strong)NSString *currentCode;


@property (strong, nonatomic) UIButton * leftBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property(strong,nonatomic)NSMutableArray *tfmodels,*tfdatas;
@end
