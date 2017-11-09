//
//  XGPwdViewController.h
//  ZtqCountry
//
//  Created by Admin on 15/8/25.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGPwdViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property(strong,nonatomic)UITextField* newpassword,*secnewpassword,*password,*namephone;
@end
