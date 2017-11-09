//
//  SettingMimaTipView.h
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/5.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingMimaTipView;
@protocol SettingMimaTipViewDelegate<NSObject>
@optional
-(void)SettingMimaTipViewSuccess:(SettingMimaTipView *)view;
@end
@interface SettingMimaTipView : UIView<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,weak)   id<SettingMimaTipViewDelegate> delegate;
@property(nonatomic,strong) NSDictionary *user_info;
@property(nonatomic,strong)NSArray *questlist;
@end
