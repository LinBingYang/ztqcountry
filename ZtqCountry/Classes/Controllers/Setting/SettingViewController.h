//
//  SettingViewController.h
//  ZtqCountry
//
//  Created by linxg on 14-6-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import "AboutView.h"
#import <MessageUI/MessageUI.h>
#import "CleanCanche.h"
@interface SettingViewController : BaseViewController<MFMessageComposeViewControllerDelegate>{
    AboutView *about;
    NSString *trackViewURL;
}
@property(strong,nonatomic)CleanCanche *cleanview,*cleanview1;
@property (strong, nonatomic) UIImageView * logoImagV;
@property (strong, nonatomic) UILabel * nameLab;
@property(strong,nonatomic)UIImage *icoimg;
@property(strong,nonatomic)NSString *duanxinstr,*username;
@property(strong,nonatomic)NSMutableArray *appurls;
@property (strong, nonatomic) UITableView * settingTable;
-(void)updateUserName;
@end
