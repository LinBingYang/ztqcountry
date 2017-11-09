//
//  ManagePassWordController.h
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/4.
//  Copyright © 2016年 yyf. All rights reserved.
//
typedef enum{
    ViewTypeChangePassWord,
    ViewTypeFindPassWord
}ViewType;
#import <UIKit/UIKit.h>

@interface ManagePassWordController : BaseViewController
//@property (strong, nonatomic) UIButton * leftBut,*rightBut;
//@property (strong, nonatomic) UILabel * titleLab;
//@property (strong, nonatomic) UIImageView * navigationBarBg;
//@property (assign, nonatomic) float barHeight;
//@property (assign, nonatomic) BOOL barHiden;
@property(nonatomic,assign) ViewType viewType;
@end
