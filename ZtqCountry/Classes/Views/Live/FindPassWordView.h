//
//  FindPassWordView.h
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/4.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FindPassWordView;
@protocol FindPassWordViewDelegate<NSObject>

@optional
-(void)findPassWordSuccess:(FindPassWordView *)findView randomPassword:(NSString *)password andMobile:(NSString *)mobile;

@end

@interface FindPassWordView : UIView<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,weak) id<FindPassWordViewDelegate> delegate;

@end
