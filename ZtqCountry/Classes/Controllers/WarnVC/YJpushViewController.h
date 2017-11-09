//
//  YJpushViewController.h
//  ZtqCountry
//
//  Created by 胡彭飞 on 16/7/28.
//  Copyright © 2016年 yyf. All rights reserved.
// 首页预警点击push进来的   只传warnid参数

#import <UIKit/UIKit.h>

@interface YJpushViewController : UIViewController<MFMessageComposeViewControllerDelegate>
{
        UIScrollView *m_scroll;
}
@property (strong, nonatomic) UIButton * leftBut,*rightBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
@property(strong,nonatomic)NSString *warnid;//发布
@property(strong,nonatomic)NSString *sharecontent;//分享内容
@property(strong,nonatomic)UIImage *shareimg;
@property(strong,nonatomic)NSString *guidestr;
@end
