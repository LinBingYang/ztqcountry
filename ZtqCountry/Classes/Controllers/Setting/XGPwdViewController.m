//
//  XGPwdViewController.m
//  ZtqCountry
//
//  Created by Admin on 15/8/25.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "XGPwdViewController.h"

@interface XGPwdViewController ()

@end

@implementation XGPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.barHiden=NO;
    self.titleLab.text=@"修改密码";
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIImageView *userimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15+self.barHeight, kScreenWidth-40, 40)];
    userimg.image=[UIImage imageNamed:@"登录输入框"];
    userimg.userInteractionEnabled=YES;
    [self.view addSubview:userimg];
    UIImageView *passward=[[UIImageView alloc]initWithFrame:CGRectMake(5, 7.5, 20, 25)];
    passward.image=[UIImage imageNamed:@"请输入手机号"];
    [userimg addSubview:passward];
    self.namephone=[[UITextField alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth-68, 40)];
    self.namephone.placeholder=@"请输入11位的手机号";
    self.namephone.clearButtonMode = UITextFieldViewModeAlways;
    self.namephone.delegate=self;
    self.namephone.returnKeyType=UIReturnKeyDone;
    self.namephone.keyboardType = UIKeyboardTypeNumberPad;
    self.namephone.tag=3;
    [userimg addSubview:self.namephone];
    UIImageView *oldpassimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 70+self.barHeight, kScreenWidth-40, 40)];
    oldpassimg.image=[UIImage imageNamed:@"登录输入框"];
    oldpassimg.userInteractionEnabled=YES;
    [self.view addSubview:oldpassimg];
    UIImageView *nickimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 7.5, 20, 25)];
    nickimg.image=[UIImage imageNamed:@"输入密码"];
    [oldpassimg addSubview:nickimg];
    self.password=[[UITextField alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth-68, 40)];
    self.password.placeholder=@"请输入当前密码";
    self.password.clearButtonMode = UITextFieldViewModeAlways;
    self.password.delegate=self;
    self.password.returnKeyType=UIReturnKeyDone;
    [self.password setSecureTextEntry:YES];
    [oldpassimg addSubview:self.password];
    UIImageView *passimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 125+self.barHeight, kScreenWidth-40, 40)];
    passimg.image=[UIImage imageNamed:@"登录输入框"];
    passimg.userInteractionEnabled=YES;
    [self.view addSubview:passimg];
    UIImageView *nimaimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 7.5, 20, 25)];
    nimaimg.image=[UIImage imageNamed:@"输入密码"];
    [passimg addSubview:nimaimg];
    self.newpassword=[[UITextField alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth-68, 40)];
    self.newpassword.placeholder=@"请输入新密码";
    self.newpassword.delegate=self;
    self.newpassword.returnKeyType=UIReturnKeyDone;
    self.newpassword.clearButtonMode = UITextFieldViewModeAlways;
    [self.newpassword setSecureTextEntry:YES];
    [passimg addSubview:self.newpassword];
    UIImageView *secpassimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 180+self.barHeight, kScreenWidth-40, 40)];
    secpassimg.image=[UIImage imageNamed:@"登录输入框"];
    secpassimg.userInteractionEnabled=YES;
    [self.view addSubview:secpassimg];
    UIImageView *newimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 7.5, 20, 25)];
    newimg.image=[UIImage imageNamed:@"输入密码"];
    [secpassimg addSubview:newimg];
    self.secnewpassword=[[UITextField alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth-68, 40)];
    self.secnewpassword.placeholder=@"请再次输入新密码";
    self.secnewpassword.delegate=self;
    self.secnewpassword.returnKeyType=UIReturnKeyDone;
    self.secnewpassword.clearButtonMode = UITextFieldViewModeAlways;
    [self.secnewpassword setSecureTextEntry:YES];
    [secpassimg addSubview:self.secnewpassword];
    
    UIButton *logbtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 250+self.barHeight,kScreenWidth-40,35)];
    [logbtn.layer setMasksToBounds:YES];
    [logbtn.layer setCornerRadius:2];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮常态.png"] forState:UIControlStateNormal];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮点击态.png"] forState:UIControlStateHighlighted];
    [logbtn setTitle:@"提交" forState:UIControlStateNormal];
    [logbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logbtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [logbtn addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logbtn];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.newpassword resignFirstResponder];
    [self.password resignFirstResponder];
    [self.secnewpassword resignFirstResponder];
    [self.namephone resignFirstResponder];
    return YES;
}
-(void)ButtonClick{
    if (self.namephone.text.length<11||!self.namephone.text.length>0) {
        UIAlertView *alreat=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"手机号码有误，请重输" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alreat show];
        return;
    }
        if (![self.newpassword.text isEqualToString:self.secnewpassword.text]) {
            UIAlertView *alreat=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"两次密码有误，请重输！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alreat show];
            return;
        }
        if (self.newpassword.text.length<6||self.newpassword.text.length>16||self.secnewpassword.text.length<6||self.secnewpassword.text.length>16) {
            UIAlertView *alreat=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"密码格式错误，请重输" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alreat show];
            return;
        }
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *registerUser = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    
    if (self.namephone.text.length>0) {
        [registerUser setObject:self.namephone.text forKey:@"phone"];
    }
    if (self.password.text.length>0) {
        NSString *str=[ShareFun getMd5_32Bit_String:self.password.text];
        [registerUser setObject:str forKey:@"old_pwd"];
    }
    if (self.newpassword.text.length>0) {
        NSString *str=[ShareFun getMd5_32Bit_String:self.newpassword.text];
        [registerUser setObject:str forKey:@"new_pwd"];
    }
    if (self.secnewpassword.text.length>0) {
        NSString *str=[ShareFun getMd5_32Bit_String:self.secnewpassword.text];
        [registerUser setObject:str forKey:@"re_pwd"];
    }
    [t_b setObject:registerUser forKey:@"gz_user_upd_pwd"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *gz_user_upd_pwd=[t_b objectForKey:@"gz_user_upd_pwd"];
        NSString *result=[gz_user_upd_pwd objectForKey:@"result"];
        NSString *result_msg=[gz_user_upd_pwd objectForKey:@"result_msg"];
        if ([result isEqualToString:@"1"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"修改成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.tag=111;
            [alert show];
            
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:result_msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.tag=222;
            [alert show];
        }
      
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==111) {
        if (buttonIndex==1) {
             [self.navigationController popViewControllerAnimated:YES];
        }
       
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
