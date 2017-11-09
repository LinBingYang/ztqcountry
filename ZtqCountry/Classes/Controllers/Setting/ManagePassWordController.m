//
//  ManagePassWordController.m
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/4.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "ManagePassWordController.h"
#import "updatePassWordView.h"
#import "FindPassWordView.h"
@interface ManagePassWordController ()<FindPassWordViewDelegate,updatePassWordViewDelegate>
@property(nonatomic,strong) UIButton *selectoldBtn,*updatebtn,*findbtn;
@property(nonatomic,strong) UIView *xianshiView,*selectView;
@property(nonatomic,strong) UIScrollView *backView;
@end

@implementation ManagePassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.titleLab.text=@"管理密码";
    self.barHiden=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.backView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    self.backView.contentSize=CGSizeMake(0, kScreenHeitht+60);
    self.backView.backgroundColor=[UIColor whiteColor];
    [self.view insertSubview:self.backView atIndex:0];

    //修改密码按钮
    UIButton *updatebtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.barHeight+20,(kScreenWidth)*0.5,35)];
    self.updatebtn=updatebtn;
    updatebtn.tag=111;
    updatebtn.adjustsImageWhenDisabled=NO;
//    [updatebtn.layer setCornerRadius:2];
//    [updatebtn setBackgroundImage:[UIImage imageNamed:@"管理密码按钮常态.png"] forState:UIControlStateNormal];
//    [updatebtn setBackgroundImage:[UIImage imageNamed:@"管理密码按钮点击.png"] forState:UIControlStateDisabled];
    [updatebtn setTitle:@"修改密码" forState:UIControlStateNormal];
    [updatebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    updatebtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [updatebtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:updatebtn];
    //找回密码按钮
    UIButton *findbtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(updatebtn.frame), self.barHeight+20,(kScreenWidth)*0.5,35)];
    self.findbtn=findbtn;
    findbtn.tag=222;
//    [findbtn.layer setCornerRadius:2];
//    [findbtn setBackgroundImage:[UIImage imageNamed:@"管理密码按钮常态.png"] forState:UIControlStateNormal];
    findbtn.adjustsImageWhenDisabled=NO;
//    [findbtn setBackgroundImage:[UIImage imageNamed:@"管理密码按钮点击.png"] forState:UIControlStateDisabled];
    [findbtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [findbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    findbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [findbtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:findbtn];
    UIView *selectView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(updatebtn.frame)-3,kScreenWidth*0.5,3)];
    self.selectView=selectView;
    selectView.backgroundColor=[UIColor colorWithRed:9/255.0 green:150/255.0 blue:213/255.0 alpha:1];
    [self.backView addSubview:selectView];
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
            FindPassWordView *findview=[[FindPassWordView alloc] init];
            findview.delegate=self;
            [self.backView addSubview:findview];
            self.xianshiView=findview;
        }
            break;
            
        default:
        {
                     self.selectView.x=0;
            updatePassWordView *upda=[[updatePassWordView alloc] init];
            [self.backView addSubview:upda];
            upda.delegate=self;
            self.xianshiView=upda;
        }
            break;
    }


}
-(void)leftAction{
        [self.navigationController popViewControllerAnimated:YES];
}
-(void)findPassWordSuccess:(FindPassWordView *)findView randomPassword:(NSString *)password andMobile:(NSString *)mobile
{
    [self ButtonClick:self.updatebtn];
    updatePassWordView *upda=(updatePassWordView *)self.xianshiView;
    [upda setDefaultMobile:mobile andPassWord:password];
}
-(void)updatePassWordSuccess:(updatePassWordView *)updatePassWordView
{
    [self.navigationController popViewControllerAnimated:YES];

}
@end
