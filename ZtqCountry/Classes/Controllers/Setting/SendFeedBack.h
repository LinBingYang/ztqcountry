//
//  SendFeedBack.h
//  ModelTest1.0
//
//  Created by 星群 吴 on 12-3-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "ShareFun.h"

@interface SendFeedBack : UIViewController <UITextViewDelegate,UITextFieldDelegate>{
	UITextView *contentTV;
	UITextField *contactTF;
	UITextField *nickTF;
	UIImageView *topIV;
	UIButton *backBut;
	UIButton *sendBut;
    UIButton *cancel;
	UILabel *topTitle;
	
	UILabel *contentLabel;
	
    // UILabel *bglabel;
    
	NSString *feedBackNULLStr;//建议为空，提示内容
}
@property(strong,nonatomic)UIScrollView *bgscrol;
@property (nonatomic,readonly) UITextView *contentTV;
@property (nonatomic,readonly) UITextField *contactTF;
@property(nonatomic,strong)UILabel *bglabel;
@property (nonatomic,readonly) UIImageView *topIV;
@property (nonatomic,readonly) UIButton *backBut;
@property (nonatomic,readonly) UIButton *sendBut;
@property(nonatomic,readonly)UIButton *cancel;
@property (nonatomic,readonly) UILabel *topTitle;
@property(nonatomic,copy) NSString *mobileStr;
@property (nonatomic,readonly) UILabel *contentLabel;
@property(nonatomic,copy) NSString *is_bd;
@property (nonatomic,strong) NSString *feedBackNULLStr;
@property(nonatomic,strong)NSString *str;
@property (assign, nonatomic) float barHeight;
@property (strong, nonatomic) UIButton * rightBut;
@property(strong,nonatomic)NSString *type;
@property(assign)BOOL isclick;
@property(strong,nonatomic)NSMutableArray *marr;
@property(strong,nonatomic)NSString *keytype;//键盘类型
@property(nonatomic,strong) UILabel *nickLabel;
@property(nonatomic,strong) UITableView *m_tableview;
@property(strong,nonatomic)NSArray *datas;
@end
