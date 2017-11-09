//
//  PushSettingViewController.h
//  ZtqCountry
//
//  Created by linxg on 14-7-21.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"

@interface PushSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    TreeNode *m_allCity;
    
}
@property(strong,nonatomic)NSMutableArray *marr;
@property (strong, nonatomic) UIButton * leftBut,*rightBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
@property(strong,nonatomic)NSString *jieri,*jieqi,*chanpin,*zt;
@property(assign)BOOL isedit;
@end
