//
//  ZhuceViewController.h
//  ZtqCountry
//
//  Created by Admin on 14-8-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LoginAlertView.h"

@interface ZhuceViewController : BaseViewController<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(strong,nonatomic)UITextField *name,*password,*secpassword,*nick;
@property(strong,nonatomic)NSString *strname,*strpassword;
@property(strong,nonatomic)NSString *userid;
@property(strong,nonatomic)UIButton *imgbtn;
@property(strong,nonatomic)UIImage *photo;
@property(assign,nonatomic)BOOL isperson;
@property(strong,nonatomic)NSString *lgtype;
@end
