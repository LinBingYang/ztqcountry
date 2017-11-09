//
//  updatePassWordView.m
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/4.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "updatePassWordView.h"
#import "useInfoModel.h"
@interface updatePassWordView ()
@property(strong,nonatomic)UITextField *mobile,*password,*secpassword,*nick;
@end

@implementation updatePassWordView

-(instancetype)initWithFrame:(CGRect)frame
{

    if (self=[super initWithFrame:frame]) {
        self.frame=CGRectMake(0, 130, kScreenWidth, 300);
        UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, kScreenWidth-40, 210)];
        bgimg.image=[UIImage imageNamed:@"注册输入框"];
        bgimg.userInteractionEnabled=YES;
        [self addSubview:bgimg];
        UIImageView *bgimg1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 55, kScreenWidth-60, 1)];
        bgimg1.image=[UIImage imageNamed:@"注册输入框分割线"];
        bgimg1.userInteractionEnabled=YES;
        [bgimg addSubview:bgimg1];
        UIImageView *bgimg2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 105, kScreenWidth-60, 1)];
        bgimg2.image=[UIImage imageNamed:@"注册输入框分割线"];
        bgimg2.userInteractionEnabled=YES;
        [bgimg addSubview:bgimg2];
        UIImageView *bgimg3=[[UIImageView alloc]initWithFrame:CGRectMake(10, 155, kScreenWidth-60, 1)];
        bgimg3.image=[UIImage imageNamed:@"注册输入框分割线"];
        bgimg3.userInteractionEnabled=YES;
        [bgimg addSubview:bgimg3];
        
        UIImageView *log=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 20, 20)];
        //    log.text=@"账号:";
        log.image=[UIImage imageNamed:@"个人中心注册手机.png"];
        [bgimg addSubview:log];
        UIImageView *passward=[[UIImageView alloc]initWithFrame:CGRectMake(10, 70, 20, 25)];
        //    passward.text=@"密码:";
        passward.image=[UIImage imageNamed:@"当前密码图标.png"];
        [bgimg addSubview:passward];
        UIImageView *secpass=[[UIImageView alloc]initWithFrame:CGRectMake(10, 120, 20, 25)];
        //    secpass.text=@"确认密码:";
        secpass.image=[UIImage imageNamed:@"个人中心登录密码.png"];
        [bgimg addSubview:secpass];
        
        UIImageView *nicklab=[[UIImageView alloc]initWithFrame:CGRectMake(10, 170, 20, 25)];
        //    nicklab.text=@"昵称:";
        nicklab.image=[UIImage imageNamed:@"个人中心登录密码2.png"];
        [bgimg addSubview:nicklab];
        
        self.mobile=[[UITextField alloc]initWithFrame:CGRectMake(40, 20, 240, 30)];
        self.mobile.placeholder=@"请输入已注册的手机号码";
        self.mobile.clearButtonMode = UITextFieldViewModeAlways;//清除键
        self.mobile.tag=0;
        self.mobile.delegate=self;
        self.mobile.returnKeyType=UIReturnKeyDone;
        self.mobile.keyboardType = UIKeyboardTypeNumberPad;
        [bgimg addSubview:self.mobile];
        
        self.nick=[[UITextField alloc]initWithFrame:CGRectMake(40, 70, 240, 30)];
        self.nick.placeholder=@"请输入当前密码";
        self.nick.clearButtonMode = UITextFieldViewModeAlways;
        self.nick.delegate=self;
        [self.nick setSecureTextEntry:YES];
        self.nick.returnKeyType=UIReturnKeyDone;
        self.nick.clearButtonMode = UITextFieldViewModeAlways;
        self.nick.tag=3;
        [bgimg addSubview:self.nick];
        
        self.password=[[UITextField alloc]initWithFrame:CGRectMake(40, 120, 240, 30)];
        self.password.placeholder=@"请输入6-16字母或数字新密码";
        self.password.clearButtonMode = UITextFieldViewModeAlways;
        [self.password setSecureTextEntry:YES];
        self.password.tag=1;
        self.password.delegate=self;
        self.password.returnKeyType=UIReturnKeyDone;
        
        [bgimg addSubview:self.password];
        self.secpassword=[[UITextField alloc]initWithFrame:CGRectMake(40, 170, 240, 30)];
        self.secpassword.placeholder=@"请再次输入新密码";
        self.secpassword.clearButtonMode = UITextFieldViewModeAlways;
        self.secpassword.delegate=self;
        self.secpassword.tag=2;
        self.secpassword.returnKeyType=UIReturnKeyDone;
        [self.secpassword setSecureTextEntry:YES];
        [bgimg addSubview:self.secpassword];
        
  

        UIButton *logbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(bgimg.frame)+10,300,35)];
        //	[logbtn setBackgroundColor:[UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1]];
        [logbtn.layer setMasksToBounds:YES];
        [logbtn.layer setCornerRadius:2];
        [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮常态.png"] forState:UIControlStateNormal];
        [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮点击态.png"] forState:UIControlStateHighlighted];
        [logbtn setTitle:@"提交" forState:UIControlStateNormal];
        [logbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        logbtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [logbtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:logbtn];
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(logbtn.frame)+10, 20, 20)];
        img.image=[UIImage imageNamed:@"气象服务1密码提示.png"];
        [self addSubview:img];
        
        UILabel *initMima=[[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(logbtn.frame)+15, kScreenWidth-30, 20)];
        initMima.text=@"请妥善保存您的新密码，以防泄漏个人信息";
        initMima.font=[UIFont systemFontOfSize:14];
        initMima.textColor=[UIColor grayColor];
        initMima.numberOfLines=0;
        [initMima sizeToFit];
        CGFloat height2=initMima.frame.size.height;
        initMima.height=height2;
        [self addSubview:initMima];

    }
    return self;

}
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder];//关闭键盘
    return YES;
}
-(void)ButtonClick:(id)sender{
    [self.mobile resignFirstResponder];
    [self.password resignFirstResponder];
    [self.secpassword resignFirstResponder];
    [self.nick resignFirstResponder];
    if([self.mobile.text isEqualToString:@""])
    {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"请输入注册手机号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alre show];
        return;
    }
    if([self.nick.text isEqualToString:@""])
    {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"请输入当前密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alre show];
        return;
    }
  
    if (![useInfoModel pwCheck:self.password.text])
    {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"请输入6-16字母或数字新密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alre show];
        return;
    }
    if([self.secpassword.text isEqualToString:@""])
    {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"请输入确认密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alre show];
        return;
    }
    if (![self.password.text isEqualToString:self.secpassword.text]) {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"新密码与确认密码输入不一致，请重新输入！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alre show];
        return;
    }
    
     [self performSelector:@selector(changeAction) withObject:nil afterDelay:0.5];

}
-(void)changeAction
{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app  forKey:@"p"];
    NSString *oldText=[ShareFun getMd5_32Bit_String:self.nick.text];
    NSString *newText=[ShareFun getMd5_32Bit_String:self.password.text];
    NSString *secText=[ShareFun getMd5_32Bit_String:self.secpassword.text];
    [userCenterImage setObject:oldText forKey:@"old_pwd"];
    [userCenterImage setObject:newText forKey:@"new_pwd"];
    [userCenterImage setObject:secText forKey:@"re_pwd"];
    [userCenterImage setObject:self.mobile.text forKey:@"phone"];
    
    [t_b setObject:userCenterImage forKey:@"gz_user_upd_pwd"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
   
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            
            NSDictionary *dict=[t_b objectForKey:@"gz_user_upd_pwd"];
            NSString *result=dict[@"result"];
            if ([result isEqualToString:@"1"]) {
                //成功
                
                self.mobile.text=@"";
                self.password.text=@"";
                self.secpassword.text=@"";
                self.nick.text=@"";
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"密码修改成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                alert.tag=111;
                alert.delegate=self;
                [alert show];
            }else
            {
                //失败
                NSString *result_msg=dict[@"result_msg"];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:result_msg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alert show];
            }
        }
        
        [MBProgressHUD hideHUDForView:self animated:NO];
    } withFailure:^(NSError *error) {
        //失败
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"提交失败,请查看网络状况" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        
        [MBProgressHUD hideHUDForView:self animated:NO];
        
    } withCache:YES];

}
-(void)setDefaultMobile:(NSString *)mobile andPassWord:(NSString *)password
{
    self.mobile.text=mobile;
    self.nick.text=password;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==111) {
        if ([self.delegate respondsToSelector:@selector(updatePassWordSuccess:)]) {
            [self.delegate updatePassWordSuccess:self];
        }
    }
   
}
@end
