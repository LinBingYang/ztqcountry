//
//  MgrPersonController.h
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/5.
//  Copyright © 2016年 yyf. All rights reserved.
//
typedef enum{
    ViewTypeChangePassWord,
    ViewTypeSettingTip
}ViewType;
#import <UIKit/UIKit.h>

@interface MgrPersonController : UIViewController
@property (strong, nonatomic) UIButton * leftBut,*rightBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
@property(nonatomic,assign) ViewType viewType;
@property(nonatomic,strong) NSDictionary *user_info;
@end
