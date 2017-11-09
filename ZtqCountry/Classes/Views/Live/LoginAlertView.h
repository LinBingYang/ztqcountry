//
//  LoginAlertView.h
//  ZtqCountry
//
//  Created by linxg on 14-8-14.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinglePhotoViewController.h"

@protocol LoginAlertViewDelegate <NSObject>

-(void)LoginAlertThirdLoginWithTag:(int)tag;

@end


@interface LoginAlertView : UIView

@property (strong, nonatomic) UITextField * accountTF;
@property (strong, nonatomic) UITextField * passwordTF;
@property (weak, nonatomic) id<LoginAlertViewDelegate> delegate;


-(id)initWithDelegate:(id)delegate;


-(void)show;

@end
