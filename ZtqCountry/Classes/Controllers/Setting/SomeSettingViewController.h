//
//  SomeSettingViewController.h
//  ZtqCountry
//
//  Created by linxg on 14-8-28.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"

@interface SomeSettingViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *pickerTitle;
    UIPickerView *m_pickerView;
    UIView *pickbgview;
    NSInteger m_components;
    NSMutableArray *m_array;
    TreeNode *m_allCity;
}
@property (strong, nonatomic) UIButton * leftBut,*rightBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
@property(strong,nonatomic)UIButton *formbtn,*tobtn;
@property(strong,nonatomic)NSString *formtime,*totime;
@property(strong,nonatomic)NSString *tsid;
@property(strong,nonatomic)UISwitch *mswitch;
@property(strong,nonatomic)NSString *hum_l,*temp_h,*temp_l,*vis_l,*o_yjxx,*b_yjxx,*y_yjxx,*r_yjxx,*p_yjxx,*jieri,*jieqi,*chanpin,*zt;
@end
