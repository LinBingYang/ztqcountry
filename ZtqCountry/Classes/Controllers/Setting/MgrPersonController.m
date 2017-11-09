//
//  MgrPersonController.m
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/5.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "MgrPersonController.h"
#import "ChangeMimaView.h"
#import "SettingMimaTipView.h"
@interface MgrPersonController ()<ChangeMimaViewDelegate,SettingMimaTipViewDelegate>
@property(nonatomic,strong) UIButton *selectoldBtn;
@property(nonatomic,strong) UIView *xianshiView;
@property(nonatomic,strong) UIView *selectView;
@end

@implementation MgrPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    self.navigationController.navigationBarHidden = YES;
    //    self.title = @"推送设置";
    float place = 0;
    if(kSystemVersionMore7)
    {
        place = 20;
    }
    self.barHeight = 44+ place;
    self.navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    self.navigationBarBg.userInteractionEnabled = YES;
    //    _navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:27 green:92 blue:189 alpha:1];
    self.navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:self.navigationBarBg];
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [_navigationBarBg addSubview:leftimg];
    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    [_leftBut addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    _rightBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-70,24, 60, 30)];
    UILabel *titleb= [[UILabel alloc] initWithFrame:CGRectMake(60, 12+place, 200, 20)];
    titleb.textAlignment = NSTextAlignmentCenter;
    self.titleLab=titleb;
    titleb.font = [UIFont fontWithName:kBaseFont size:20];
    titleb.backgroundColor = [UIColor clearColor];
    titleb.textColor = [UIColor whiteColor];
    titleb.text=@"管理密码";
    [self.navigationBarBg addSubview:titleb];
    self.view.backgroundColor=[UIColor whiteColor];
    //修改密码按钮
    UIButton *updatebtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.barHeight+20,(kScreenWidth)*0.5,35)];
    
    updatebtn.tag=111;
      [updatebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    updatebtn.adjustsImageWhenDisabled=NO;
    //    [updatebtn.layer setCornerRadius:2];
//    [updatebtn setBackgroundImage:[UIImage imageNamed:@"管理密码按钮常态.png"] forState:UIControlStateNormal];
//    [updatebtn setBackgroundImage:[UIImage imageNamed:@"管理密码按钮点击.png"] forState:UIControlStateDisabled];
    [updatebtn setTitle:@"修改密码" forState:UIControlStateNormal];
//    [updatebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    updatebtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [updatebtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updatebtn];
    //找回密码按钮
    UIButton *findbtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(updatebtn.frame), self.barHeight+20,(kScreenWidth)*0.5,35)];
    
    findbtn.tag=222;
    //    [findbtn.layer setCornerRadius:2];
    findbtn.adjustsImageWhenDisabled=NO;
    [findbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [findbtn setBackgroundImage:[UIImage imageNamed:@"管理密码按钮常态.png"] forState:UIControlStateNormal];
//    [findbtn setBackgroundImage:[UIImage imageNamed:@"管理密码按钮点击.png"] forState:UIControlStateDisabled];
    [findbtn setTitle:@"设置密码提示" forState:UIControlStateNormal];
//    [findbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    findbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [findbtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findbtn];
    
    UIView *selectView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(updatebtn.frame)-3,kScreenWidth*0.5,3)];
    self.selectView=selectView;
    selectView.backgroundColor=[UIColor colorWithRed:9/255.0 green:150/255.0 blue:213/255.0 alpha:1];
    [self.view addSubview:selectView];
    if (self.viewType==ViewTypeChangePassWord) {
        [self ButtonClick:updatebtn];
    }else{
        [self ButtonClick:findbtn];
    }

}
-(void)ButtonClick:(UIButton *)btn
{
    if (self.xianshiView) {
        [self.xianshiView removeFromSuperview];
    }
    btn.enabled=NO;
    if (self.selectoldBtn) {
            self.selectoldBtn.enabled=YES;
    }

    self.selectoldBtn=btn;
    switch (btn.tag) {
        case 222:
        {
            self.selectView.x=kScreenWidth*0.5;
            SettingMimaTipView *Sett=[[SettingMimaTipView alloc] init];
            Sett.user_info=self.user_info;
            [self.view addSubview:Sett];
            Sett.delegate=self;
            self.xianshiView=Sett;
         
        }
            break;
            
        default:
        {
                 self.selectView.x=0;
            ChangeMimaView *change=[[ChangeMimaView alloc] init];
            change.delegate=self;
            change.user_info=self.user_info;
            [self.view addSubview:change];
            self.xianshiView=change;
      
        }
            break;
    }
    
    
}

-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)changeMimaViewSuccess:(ChangeMimaView *)view
{
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)SettingMimaTipViewSuccess:(SettingMimaTipView *)view
{
    [self.navigationController popViewControllerAnimated:YES];

}
@end
