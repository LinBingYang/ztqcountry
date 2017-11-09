//
//  AddServerViewController.h
//  ZtqCountry
//
//  Created by Admin on 15/8/20.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SelectCityViewController.h"
#import "PayViewController.h"
#import <CommonCrypto/CommonDigest.h>
@interface AddServerViewController : BaseViewController<UITextFieldDelegate,ABPersonViewControllerDelegate,ABNewPersonViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate,UINavigationControllerDelegate>{
    ABPeoplePickerNavigationController *picker;
    ABNewPersonViewController *personViewController;
    TreeNode *m_allCity;
}
@property(strong,nonatomic)UIScrollView *bgscro;
@property(strong,nonatomic)UITextField *phonetf,*citytf,*sjrtf,*fjrtf;
@property(strong,nonatomic)UILabel *contentlab,*zflab;
@property(assign)float contheight;
@property(strong,nonatomic)NSString *type;//新增0 修改1
@property(strong,nonatomic)NSString *phone,*send_name,*name,*areaid,*productid;
@property(strong,nonatomic)NSMutableArray *tcarrs,*t_btnarr;
@property(strong,nonatomic)NSString *cityid,*orderid,*tcid,*zf;

@property(strong,nonatomic)UILabel *tslab;
@property(strong,nonatomic)UIButton *lgbtn;
@property(strong,nonatomic)UIImageView *grayimg;

@end
