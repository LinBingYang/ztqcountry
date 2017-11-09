//
//  ChangeMimaView.m
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/5.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "ChangeMimaView.h"
#import "useInfoModel.h"
@interface ChangeMimaView()<UITextFieldDelegate>
@property(strong,nonatomic)UITextField *oldTextField,*NewTextField,*makeTextField;
@property(strong,nonatomic)NSString *oldtext,*newtext,*maketext;
@end
@implementation ChangeMimaView
-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self=[super initWithFrame:frame]) {
        self.frame=CGRectMake(0, 130, kScreenWidth, 300);
        
        UILabel *OldMima=[[UILabel alloc] initWithFrame:CGRectMake(20, 20, 60, 30)];
        OldMima.text=@"旧密码:";
        OldMima.textColor=[UIColor grayColor];
        OldMima.textAlignment=NSTextAlignmentLeft;
        [self addSubview:OldMima];
        
        UILabel *newMima=[[UILabel alloc] initWithFrame:CGRectMake(20, 70, 60, 30)];
        newMima.text=@"新密码:";
           newMima.textColor=[UIColor grayColor];
        newMima.textAlignment=NSTextAlignmentLeft;
        [self addSubview:newMima];
      
        UILabel *MakeSurenewMima=[[UILabel alloc] initWithFrame:CGRectMake(20, 120, 85, 30)];
        MakeSurenewMima.text=@"确认密码:";
           MakeSurenewMima.textColor=[UIColor grayColor];
        MakeSurenewMima.textAlignment=NSTextAlignmentLeft;
        [self addSubview:MakeSurenewMima];
        
        CGFloat margin=100;
        self.oldTextField=[[UITextField alloc]initWithFrame:CGRectMake(margin, 20, kScreenWidth-margin-15, 30)];
        self.oldTextField.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"请输入当前密码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        self.oldTextField.layer.borderWidth=1;
        self.oldTextField.layer.borderColor=[UIColor grayColor].CGColor;
        self.oldTextField.layer.cornerRadius=3;
        self.oldTextField.clipsToBounds=YES;
        self.oldTextField.clearButtonMode = UITextFieldViewModeAlways;//清除键
         [self.oldTextField setSecureTextEntry:YES];
        self.oldTextField.tag=0;
        self.oldTextField.delegate=self;
        self.oldtext=self.oldTextField.text;
        [self addSubview:self.oldTextField];
        
        self.NewTextField=[[UITextField alloc]initWithFrame:CGRectMake(margin, 70, kScreenWidth-margin-15, 30)];
        NSAttributedString *attrStr=[[NSAttributedString alloc] initWithString:@"请输入6-16字母或数字新密码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        self.NewTextField.attributedPlaceholder=attrStr;
//        self.NewTextField.placeholder=;
        self.NewTextField.layer.borderWidth=1;
        self.NewTextField.layer.borderColor=[UIColor grayColor].CGColor;
        self.NewTextField.layer.cornerRadius=3;
        self.NewTextField.clearButtonMode = UITextFieldViewModeAlways;
         [self.NewTextField setSecureTextEntry:YES];
        self.NewTextField.delegate=self;
        self.NewTextField.tag=3;
        self.newtext=self.NewTextField.text;
        [self addSubview:self.NewTextField];
        
        self.makeTextField=[[UITextField alloc]initWithFrame:CGRectMake(margin, 120, kScreenWidth-margin-15, 30)];
        self.makeTextField.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"请再次输入您的新密码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];;
        self.makeTextField.layer.borderWidth=1;
        self.makeTextField.layer.borderColor=[UIColor grayColor].CGColor;
        self.makeTextField.layer.cornerRadius=3;
        self.makeTextField.clearButtonMode = UITextFieldViewModeAlways;
        [self.makeTextField setSecureTextEntry:YES];
        self.makeTextField.tag=1;
        self.makeTextField.delegate=self;
        self.maketext=self.makeTextField.text;
        [self addSubview:self.makeTextField];

        
        
        UIButton *logbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.makeTextField.frame)+10,300,35)];
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
    }
    return self;
    
}
-(void)ButtonClick:(id)sender{
    [self.oldTextField resignFirstResponder];
    [self.NewTextField resignFirstResponder];
    [self.makeTextField resignFirstResponder];
    if([self.oldTextField.text isEqualToString:@""])
    {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"请输入当前密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alre show];
        return;
    }
  
    if (![useInfoModel pwCheck:self.NewTextField.text])
    {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"请输入6-16字母或数字新密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alre show];
        return;
    }
    if([self.makeTextField.text isEqualToString:@""])
    {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"请输入确认密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alre show];
        return;
    }
    if (![self.NewTextField.text isEqualToString:self.makeTextField.text]) {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"新密码与确认密码输入不一致，请重新输入！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alre show];
        return;
    }

    [self performSelector:@selector(changeAction) withObject:nil afterDelay:0.5];
    

}
-(void)changeAction
{

    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    NSString *platform_user_id=self.user_info[@"platform_user_id"];
    [userCenterImage setObject:platform_user_id forKey:@"phone"];
    NSString *oldText=[ShareFun getMd5_32Bit_String:self.oldTextField.text];
    NSString *newText=[ShareFun getMd5_32Bit_String:self.NewTextField.text];
    NSString *reText=[ShareFun getMd5_32Bit_String:self.makeTextField.text];
    [userCenterImage setObject:oldText forKey:@"old_pwd"];
    [userCenterImage setObject:newText forKey:@"new_pwd"];
    [userCenterImage setObject:reText forKey:@"re_pwd"];
    [t_b setObject:userCenterImage forKey:@"gz_user_upd_pwd"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    self.oldTextField.text=@"";
    self.NewTextField.text=@"";
    self.makeTextField.text=@"";
    
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            
            NSDictionary *dict=[t_b objectForKey:@"gz_user_upd_pwd"];
            NSString *result=dict[@"result"];
            if ([result isEqualToString:@"1"]) {
                //成功
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                alert.delegate=self;
                alert.tag=111;
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==111)
    {
        if ([self.delegate respondsToSelector:@selector(changeMimaViewSuccess:)]) {
            [self.delegate changeMimaViewSuccess:self];
        }
      
       
        
    }

}

@end
