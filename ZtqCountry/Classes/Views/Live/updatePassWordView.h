//
//  updatePassWordView.h
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/4.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class updatePassWordView;
@protocol updatePassWordViewDelegate<NSObject>

@optional
-(void)updatePassWordSuccess:(updatePassWordView *)updatePassWordView;

@end
@interface updatePassWordView : UIView<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
-(void)setDefaultMobile:(NSString *)mobile andPassWord:(NSString *)password;
@property(nonatomic,weak) id<updatePassWordViewDelegate> delegate;
@end
