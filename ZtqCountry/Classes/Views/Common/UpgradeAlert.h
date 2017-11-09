//
//  UpgradeAlert.h
//  ZtqCountry
//
//  Created by linxg on 14-8-1.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpgradeAlertDelegate <NSObject>

-(void)clickButtonWithTag:(int)tag;

@end

//3.0升级弹窗

@interface UpgradeAlert : UIView

@property (strong, nonatomic) UIImageView * logoImg;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UILabel * contentLab;
@property (strong, nonatomic) UIButton * firstBut;
@property (strong, nonatomic) UIButton * secondBut;
@property (weak, nonatomic) id<UpgradeAlertDelegate>delegate;


-(id)initWithLogo:(NSString *)logoName withTitle:(NSString *)title withContent:(NSString *)content withFirstButton:(NSString *)first withSecondButton:(NSString *)second withDelegate:(id)delegate;


-(void)show;

@end
