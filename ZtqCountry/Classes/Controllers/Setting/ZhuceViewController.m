//
//  ZhuceViewController.m
//  ZtqCountry
//
//  Created by Admin on 14-8-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "ZhuceViewController.h"
#import "WebViewController.h"
#import "DropDownList.h"
@interface ZhuceViewController ()<UIGestureRecognizerDelegate,DropDownListDelegate>
@property(nonatomic,copy) NSString *zhuceSuccess;
@property(nonatomic,strong) UIView *backgroundView;

@property(nonatomic,strong) DropDownList *dList1,*dList2;
@property(nonatomic,strong) NSMutableArray *question1,*question2;
@property(nonatomic,strong) NSMutableArray *question_title1,*question_title2;
@property(nonatomic,copy) NSString *anwerID1,*anwerID2;

@property(nonatomic,assign) BOOL isShow;
@property(nonatomic,strong) UIView *menban;

@end

@implementation ZhuceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"photoname"];
    //    UIImage *aimage = [UIImage imageWithData: data];
    self.titleLab.text=@"注册";
    self.titleLab.textColor = [UIColor whiteColor];
    self.barHiden=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    [self.leftBut addTarget:self action:@selector(leftButAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *backgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    backgroundView.backgroundColor=[UIColor whiteColor];
    self.backgroundView=backgroundView;
    [self.view insertSubview:backgroundView atIndex:0];
    UIButton *bgbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, 300)];
    [bgbtn addTarget:self action:@selector(hiddkey) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:bgbtn];
  
    
    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, self.barHeight+15, kScreenWidth-40, 210)];
    bgimg.image=[UIImage imageNamed:@"注册输入框"];
    bgimg.userInteractionEnabled=YES;
    [self.backgroundView addSubview:bgimg];
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
    log.image=[UIImage imageNamed:@"昵称图标"];
    [bgimg addSubview:log];
    UIImageView *passward=[[UIImageView alloc]initWithFrame:CGRectMake(10, 70, 20, 25)];
    //    passward.text=@"密码:";
    passward.image=[UIImage imageNamed:@"请输入手机号"];
    [bgimg addSubview:passward];
    UIImageView *secpass=[[UIImageView alloc]initWithFrame:CGRectMake(10, 120, 20, 25)];
    //    secpass.text=@"确认密码:";
    secpass.image=[UIImage imageNamed:@"输入密码"];
    [bgimg addSubview:secpass];
    
    UIImageView *nicklab=[[UIImageView alloc]initWithFrame:CGRectMake(10, 170, 20, 25)];
    //    nicklab.text=@"昵称:";
    nicklab.image=[UIImage imageNamed:@"输入密码"];
    [bgimg addSubview:nicklab];
    
    self.name=[[UITextField alloc]initWithFrame:CGRectMake(40, 20, 240, 30)];
    self.name.placeholder=@"请输入6字以内的昵称";
    self.name.clearButtonMode = UITextFieldViewModeAlways;//清除键
    self.name.tag=0;
    self.name.delegate=self;
    self.name.returnKeyType=UIReturnKeyDone;
    self.strname=self.name.text;
    [bgimg addSubview:self.name];
    
    self.password=[[UITextField alloc]initWithFrame:CGRectMake(40, 120, 240, 30)];
    self.password.placeholder=@"请输入6-16字母或数字密码";
    self.password.clearButtonMode = UITextFieldViewModeAlways;
    [self.password setSecureTextEntry:YES];
    self.password.tag=1;
    self.password.delegate=self;
    self.password.returnKeyType=UIReturnKeyDone;
    self.strpassword=self.password.text;
    [bgimg addSubview:self.password];
    self.secpassword=[[UITextField alloc]initWithFrame:CGRectMake(40, 170, 240, 30)];
    self.secpassword.placeholder=@"请再输入密码";
    self.secpassword.clearButtonMode = UITextFieldViewModeAlways;
    self.secpassword.delegate=self;
    self.secpassword.tag=2;
    self.secpassword.returnKeyType=UIReturnKeyDone;
    [self.secpassword setSecureTextEntry:YES];
    [bgimg addSubview:self.secpassword];
    
    self.nick=[[UITextField alloc]initWithFrame:CGRectMake(40, 70, 240, 30)];
    self.nick.placeholder=@"请输入11位的手机号";
    self.nick.clearButtonMode = UITextFieldViewModeAlways;
    self.nick.delegate=self;
    self.nick.returnKeyType=UIReturnKeyDone;
    self.nick.keyboardType = UIKeyboardTypeNumberPad;
    self.nick.tag=3;
    [bgimg addSubview:self.nick];
    
    UIButton *logbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 250+self.barHeight,300,35)];
    //	[logbtn setBackgroundColor:[UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1]];
    [logbtn.layer setMasksToBounds:YES];
    [logbtn.layer setCornerRadius:2];
	[logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮常态.png"] forState:UIControlStateNormal];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮点击态.png"] forState:UIControlStateHighlighted];
	[logbtn setTitle:@"下一步" forState:UIControlStateNormal];
	[logbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	logbtn.titleLabel.font = [UIFont systemFontOfSize:18];
	[logbtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.backgroundView addSubview:logbtn];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(10, 290+self.barHeight, 20, 20)];
    img.image=[UIImage imageNamed:@"气象服务1密码提示.png"];
    [self.backgroundView addSubview:img];
    UILabel *initMima=[[UILabel alloc]initWithFrame:CGRectMake(30, 290+self.barHeight, kScreenWidth-30, 20)];
    initMima.text=@"请妥善保管好您的密码,以防泄露个人信息。";
    initMima.font=[UIFont systemFontOfSize:14];
    initMima.textColor=[UIColor grayColor];
    initMima.numberOfLines=0;
    //    [initMima sizeToFit];
    ////    CGFloat height2=initMima.frame.size.height;
    ////    initMima.height=height2;
    [self.backgroundView addSubview:initMima];
    
    //    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 290+self.barHeight, kScreenWidth, 30)];
    //    label.text=@"请妥善保管好您的密码,以防泄露个人信息。";
    //    label.font=[UIFont systemFontOfSize:12];
    //    label.textAlignment=NSTextAlignmentCenter;
    //    label.textColor=[UIColor blackColor];
    //    [self.view addSubview:label];
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeitht-150, kScreenWidth, 30)];
    lab1.text=@"知天气提示";
    lab1.textAlignment=NSTextAlignmentCenter;
    lab1.textColor=[UIColor blackColor];
    lab1.font=[UIFont systemFontOfSize:14];
    [self.backgroundView addSubview:lab1];
    UIImageView *lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(lab1.frame)-15, 100, 1)];
    lineimg.image=[UIImage imageNamed:@"协议下划线"];
    [self.backgroundView addSubview:lineimg];
    UIImageView *lineimg1=[[UIImageView alloc]initWithFrame:CGRectMake(200, CGRectGetMaxY(lab1.frame)-15, 100, 1)];
    lineimg1.image=[UIImage imageNamed:@"协议下划线"];
    [self.backgroundView addSubview:lineimg1];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab1.frame)+5, kScreenWidth, 30)];
    label.text=@"提交即表示您阅读并同意";
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor blackColor];
    [self.backgroundView addSubview:label];
    
    UIButton *xybtn=[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-200)/2, CGRectGetMaxY(label.frame), 200, 50)];
    [xybtn setTitle:@"《知天气软件许可及服务协议》" forState:UIControlStateNormal];
    xybtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [xybtn setTitleColor:[UIColor colorHelpWithRed:253 green:139 blue:41 alpha:1] forState:UIControlStateNormal];
    [xybtn addTarget:self action:@selector(xyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:xybtn];
    
    self.zhuceSuccess=@"0";
    
    
}
-(void)hiddkey{
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
    [self.nick resignFirstResponder];
    [self.secpassword resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger tag=[textField tag];
    if (tag==0) {
        NSMutableArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"ifname"];
        if ([arr containsObject:self.name.text]) {
            UIAlertView *alreat=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"用户名已被注册，请重新输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alreat show];
            
        }
    }
    //    if (tag==3) {
    //         NSMutableArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"ifnick"];
    //        if ([arr containsObject:self.nick.text]) {
    //            UIAlertView *alreat=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"该昵称已被注册，请重新输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //            [alreat show];
    //        }
    //    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
    [self.nick resignFirstResponder];
    [self.secpassword resignFirstResponder];
    return YES;
}
-(void)ButtonClick:(id)sender{
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
    [self.secpassword resignFirstResponder];
    [self.nick resignFirstResponder];
    if (self.name.text.length==0||self.password.text.length==0||self.secpassword.text.length==0||self.nick.text.length==0) {
        
        UIAlertView *alreat=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"您还没注册，请先注册！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alreat show];
        return;
    }else{
        if (![self.password.text isEqualToString:self.secpassword.text]) {
            UIAlertView *alreat=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"两次密码有误，请重输！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alreat show];
            return;
        }
        if (self.password.text.length<6||self.password.text.length>16||self.secpassword.text.length<6||self.secpassword.text.length>16) {
            UIAlertView *alreat=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"密码格式错误，请重输" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alreat show];
            return;
        }
        if (self.name.text.length>6) {
            UIAlertView *alreat=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"昵称格式错误，请重输" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alreat show];
            return;
        }
        if (self.nick.text.length>11) {
            UIAlertView *alreat=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"手机格式错误，请重输" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alreat show];
            return;
        }
        
        NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *registerUser = [NSMutableDictionary dictionaryWithCapacity:4];
        [t_h setObject:[setting sharedSetting].app forKey:@"p"];
        if (self.name.text.length>0) {
            [registerUser setObject:self.name.text forKey:@"nick_name"];
        }
        if (self.nick.text.length>0) {
            [registerUser setObject:self.nick.text forKey:@"phone"];
        }
        if (self.password.text.length>0) {
            NSString *str=[ShareFun getMd5_32Bit_String:self.password.text];
            [registerUser setObject:str forKey:@"pwd"];
        }
        if (self.secpassword.text.length>0) {
             NSString *str=[ShareFun getMd5_32Bit_String:self.secpassword.text];
            [registerUser setObject:str forKey:@"repwd"];
        }
        
        [t_b setObject:registerUser forKey:@"gz_user_regist"];
        [t_dic setObject:t_h forKey:@"h"];
        [t_dic setObject:t_b forKey:@"b"];
        [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
            // NSLog(@"%@",returnData);
            
            
            NSDictionary *t_b = [returnData objectForKey:@"b"];
            
          
                NSDictionary *registerUser=[t_b objectForKey:@"gz_user_regist"];
                NSString *result=[registerUser objectForKey:@"result"];
            NSString *result_msg=[registerUser objectForKey:@"result_msg"];
             NSString *user_id=[registerUser objectForKey:@"user_id"];
             NSString *head_url=[registerUser objectForKey:@"head_url"];
             NSString *nick_name=[registerUser objectForKey:@"nick_name"];
                NSLog(@"%@",result_msg);
                
            if ([result isEqualToString:@"1"]) {
//                NSURL *url=[NSURL URLWithString:head_url];
                NSData *mydata = [NSData dataWithContentsOfURL:[NSURL URLWithString:head_url]];
                if (head_url) {
                    [[NSUserDefaults standardUserDefaults]setObject:head_url forKey:@"currendIcoUrl"];
                }
                if (mydata) {
                    [[NSUserDefaults standardUserDefaults]setObject:mydata forKey:@"currendIco"];
                }
                [[NSUserDefaults standardUserDefaults]setObject:nick_name forKey:@"sjusername"];
                [[NSUserDefaults standardUserDefaults] setObject:self.nick.text forKey:@"sjuserphone"];
                [[NSUserDefaults standardUserDefaults]setObject:user_id forKey:@"sjuserid"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"myname" object:nick_name];
//                [self getuserinfos];//获取用户信息id
                
//                if (self.isperson==YES) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }else{
//                    if ([self.lgtype isEqualToString:@"亲情"]) {
//                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
//                    }if ([self.lgtype isEqualToString:@"生日"]) {
//                        
//                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
//                    }
//                    if ([self.lgtype isEqualToString:@"风雨"]) {
//                        
//                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
//                    }
//                    else{
//                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//                    }
//                }
                //注册密保页面加载
                [self makeMibaoView];
                self.zhuceSuccess=@"1";
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUserName" object:nil];
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:result_msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [alert show];
            
            }
//            if ([result isEqualToString:@"-2"]) {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"两次密码不同" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//                [alert show];
//            }
//            if ([result isEqualToString:@"-3"]) {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"该昵称已经被使用请重新输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//                [alert show];
//            }
//            if ([result isEqualToString:@"-4"]) {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"用户名重复请重新输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//                [alert show];
//            }
//            if ([result isEqualToString:@"-5"]) {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"两次密码不一致" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//                [alert show];
//            }
//            if ([result isEqualToString:@"-7"]) {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"密码输入有误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//                [alert show];
//            }
//            if ([result isEqualToString:@"-6"]) {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"确认密码输入有误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//                [alert show];
//            }
//            if ([result isEqualToString:@"-8"]) {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"用户名有误请重新输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//                [alert show];
//            }
            
        } withFailure:^(NSError *error) {
            NSLog(@"failure");
           
        } withCache:YES];

    }
}
-(void)backAction:(UIButton *)sender
{
     if ([self.zhuceSuccess isEqualToString:@"1"]) {
         
    if (self.isperson==YES) {
            [self.navigationController popViewControllerAnimated:YES];
        
        }else{
            if ([self.lgtype isEqualToString:@"亲情"]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
            }if ([self.lgtype isEqualToString:@"生日"]) {
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            }
            if ([self.lgtype isEqualToString:@"风雨"]) {
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            }
            else{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }
     }else{
         [self.navigationController popViewControllerAnimated:YES];
     }
}
-(void)makeMibaoView
{
    if (self.backgroundView) {
        [self.backgroundView removeFromSuperview];
        self.backgroundView=nil;
    }
    UIView *backgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    backgroundView.backgroundColor=[UIColor whiteColor];
    self.backgroundView=backgroundView;
    [self.view insertSubview:backgroundView atIndex:0];
    
    self.anwerID1=@"";
    self.anwerID2=@"";
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.barHeight+5, 20, 20)];
    img.image=[UIImage imageNamed:@"气象服务1密码提示.png"];
    [self.backgroundView addSubview:img];
    UILabel *initMima=[[UILabel alloc]initWithFrame:CGRectMake(30, self.barHeight+7, kScreenWidth-30, 60)];
    initMima.text=@"以下信息可以帮助您快速找回遗忘的密码，请谨慎填写。";
    initMima.font=[UIFont systemFontOfSize:15];
    initMima.textColor=[UIColor grayColor];
    initMima.numberOfLines=0;
    [initMima sizeToFit];
    CGFloat height2=initMima.frame.size.height;
    initMima.height=height2;
    [self.backgroundView addSubview:initMima];
    
    UIImageView *bgimg0=[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(initMima.frame)+3, kScreenWidth-20, 1)];
    bgimg0.image=[UIImage imageNamed:@"注册输入框分割线"];
    bgimg0.userInteractionEnabled=YES;
    [self.backgroundView addSubview:bgimg0];
    
    CGFloat top=64+50;
    UILabel *question1=[[UILabel alloc] initWithFrame:CGRectMake(20, 20+top, 50, 30)];
    question1.text=@"问题1:";
    question1.textAlignment=NSTextAlignmentLeft;
    [self.backgroundView addSubview:question1];
    
    DropDownList *dlist1 = [[DropDownList alloc] initWithFrame:CGRectMake(70, 20+top, kScreenWidth-80, 30)];
    self.dList1=dlist1;
    self.dList1.delegate = self;
    self.dList1.tag = 10001;
    //    [self.dList1.button setTitle:@"你的宠物名叫什么" forState:UIControlStateNormal];
    [self.backgroundView addSubview:dlist1];
    
    DropDownList *dlist2 = [[DropDownList alloc] initWithFrame:CGRectMake(70, 100+top, kScreenWidth-80, 30)];
    self.dList2=dlist2;
    self.dList2.delegate = self;
    self.dList2.tag = 10002;
    //    [self.dList2.button setTitle:@"你的故乡在哪里" forState:UIControlStateNormal];
    [self.backgroundView addSubview:dlist2];
    
    UILabel *answer1=[[UILabel alloc] initWithFrame:CGRectMake(20, 60+top, 50, 30)];
    answer1.text=@"答案:";
    answer1.textAlignment=NSTextAlignmentLeft;
    [self.backgroundView addSubview:answer1];
    
    UILabel *question2=[[UILabel alloc] initWithFrame:CGRectMake(20, 100+top, 50, 30)];
    question2.text=@"问题2:";
    question2.textAlignment=NSTextAlignmentLeft;
    [self.backgroundView addSubview:question2];
    
    UILabel *answer2=[[UILabel alloc] initWithFrame:CGRectMake(20, 140+top, 50, 30)];
    answer2.text=@"答案:";
    answer2.textAlignment=NSTextAlignmentLeft;
    [self.backgroundView addSubview:answer2];
    
    UIImageView *bgimg1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 91+top, kScreenWidth-20, 1)];
    bgimg1.image=[UIImage imageNamed:@"注册输入框分割线"];
    bgimg1.userInteractionEnabled=YES;
    [self.backgroundView addSubview:bgimg1];
    UIImageView *bgimg2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 171+top, kScreenWidth-20, 1)];
    bgimg2.image=[UIImage imageNamed:@"注册输入框分割线"];
    bgimg2.userInteractionEnabled=YES;
    [self.backgroundView addSubview:bgimg2];
    
    self.nick=[[UITextField alloc]initWithFrame:CGRectMake(70, 60+top, kScreenWidth-70, 30)];
    self.nick.placeholder=@"请填写5个字以内的答案";
    self.nick.clearButtonMode = UITextFieldViewModeAlways;
    self.nick.delegate=self;
    self.nick.returnKeyType=UIReturnKeyDone;
    self.nick.keyboardType = UIKeyboardTypeNumberPad;
    self.nick.tag=3;
    [self.backgroundView addSubview:self.nick];
    
    self.password=[[UITextField alloc]initWithFrame:CGRectMake(70, 140+top, kScreenWidth-70, 30)];
    self.password.placeholder=@"请填写5个字以内的答案";
    self.password.clearButtonMode = UITextFieldViewModeAlways;
    self.password.tag=1;
    self.password.delegate=self;
    self.password.returnKeyType=UIReturnKeyDone;
    self.strpassword=self.password.text;
    [self.backgroundView addSubview:self.password];
    
    
    UIButton *logbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.password.frame)+20,300,35)];
    [logbtn.layer setMasksToBounds:YES];
    [logbtn.layer setCornerRadius:2];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮常态.png"] forState:UIControlStateNormal];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮点击态.png"] forState:UIControlStateHighlighted];
    [logbtn setTitle:@"提交" forState:UIControlStateNormal];
    [logbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logbtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [logbtn addTarget:self action:@selector(SetMibaoBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:logbtn];
    
    [self loadDListDatas];
    
}
-(void)SetMibaoBtn
{
    [self.password resignFirstResponder];
    [self.nick resignFirstResponder];
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
    NSString * sjuserphone = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserphone"];
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [userCenterImage setObject:userid forKey:@"user_id"];
    [userCenterImage setObject:sjuserphone forKey:@"platform_user_id"];
    NSArray *req_list=@[@{@"que_id":self.anwerID1,@"ans_info":self.nick.text},@{@"que_id":self.anwerID2,@"ans_info":self.password.text}];
    [userCenterImage setObject:req_list forKey:@"req_list"];
    [t_b setObject:userCenterImage forKey:@"gz_syn_user_que_set"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    //
    self.password.text=@"";
    self.nick.text=@"";
    [MBProgressHUD showHUDAddedTo:self.backgroundView animated:YES];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            
            NSDictionary *dict=[t_b objectForKey:@"gz_syn_user_que_set"];
            NSString *result=dict[@"result"];
            if ([result isEqualToString:@"1"]) {
                //成功
                if ([self.lgtype isEqualToString:@"建议"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else if ([self.lgtype isEqualToString:@"定位"]){
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:5] animated:YES];
                }
                else if ([self.lgtype isEqualToString:@"设置"]){
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"myname" object:nil];
                    //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }
                else{
                      [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//                    GRZXViewController *grzx=[[GRZXViewController alloc]init];
//                    grzx.type=@"1";
//                    [self.navigationController pushViewController:grzx animated:YES];
                }
            }else{
                //失败
                NSString *result_msg=dict[@"result_msg"];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:result_msg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alert show];
            }
        }
        
        [MBProgressHUD hideHUDForView:self.backgroundView animated:NO];
    } withFailure:^(NSError *error) {
        //失败
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"提交失败,请查看网络状况" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        
        [MBProgressHUD hideHUDForView:self.backgroundView animated:NO];
        
    } withCache:YES];
    
    
    
}
-(void)loadDListDatas
{
    
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [t_b setObject:userCenterImage forKey:@"gz_syn_user_que"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.backgroundView animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            
            NSDictionary *syn_user_que=[t_b objectForKey:@"gz_syn_user_que"];
            NSArray *info_list=syn_user_que[@"info_list"];
            self.question1=[NSMutableArray array];
            self.question2=[NSMutableArray array];
            self.question_title1=[NSMutableArray array];
            self.question_title2=[NSMutableArray array];
            for (int i=0; i<info_list.count; i++) {
                NSDictionary *question=info_list[i];
                NSString *type=question[@"type"];
                NSString *que_title=question[@"que_title"];
                if ([type isEqualToString:@"1"]) {
                    [self.question1 addObject:question];
                    [self.question_title1 addObject:que_title];
                }else{
                    [self.question2 addObject:question];
                    [self.question_title2 addObject:que_title];
                }
            }
            [self.dList1 setList:self.question_title1];
            [self.dList2 setList:self.question_title2];
            [self.dList1.button setTitle:self.question1[0][@"que_title"] forState:UIControlStateNormal];
            self.anwerID1=self.question1[0][@"id"];
            [self.dList2.button setTitle:self.question2[0][@"que_title"] forState:UIControlStateNormal];
            self.anwerID2=self.question2[0][@"id"];
        }
        
        [MBProgressHUD hideHUDForView:self.backgroundView animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.backgroundView animated:NO];
        
    } withCache:YES];
    
    
}
- (void) didSelectDropListItem:(DropDownList *)dropDownList withIndex:(NSInteger)index
{   self.isShow=NO;
    if (self.menban) {
        [self.menban removeFromSuperview];
    }
    if(dropDownList==self.dList1)
    {   [self.dList2 setShowList:NO];
        NSDictionary *anwer1=self.question1[index];
        NSString *answerID1=anwer1[@"id"];
        NSString *question1=anwer1[@"que_title"];
        self.anwerID1=answerID1;
        [self.dList1.button setTitle:question1 forState:UIControlStateNormal];
    }
    if (dropDownList==self.dList2) {
        [self.dList1 setShowList:NO];
        NSDictionary *anwer2=self.question2[index];
        NSString *answerID2=anwer2[@"id"];
        NSString *question2=anwer2[@"que_title"];
        self.anwerID2=answerID2;
        [self.dList2.button setTitle:question2 forState:UIControlStateNormal];
    }
}
-(void)dlist:(DropDownList *)dropDownList{
    [self.password resignFirstResponder];
    [self.nick resignFirstResponder];
    
    self.isShow=!self.isShow;
    if (self.menban) {
        [self.menban removeFromSuperview];
    }
    if (self.isShow) {
        UIView *menban=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
        //            menban.backgroundColor=[UIColor redColor];
        //        menban.backgroundColor=[UIColor blackColor];
        //        menban.alpha=0.1;
        UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc]init];
        [longPress setNumberOfTapsRequired:1];
        longPress.delegate=self;
        [menban addGestureRecognizer:longPress];
        self.menban=menban;
        [self.backgroundView insertSubview:menban belowSubview:dropDownList.listView];
    }
    
    if (dropDownList==self.dList1) {
        [self.dList2 setShowList:NO];
    }else{
        [self.dList1 setShowList:NO];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    [self.dList1 setShowList:NO];
    [self.dList2 setShowList:NO];
    self.isShow=NO;
    if (self.menban) {
        [self.menban removeFromSuperview];
    }
    return NO;
    
}
-(void)xyAction{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *registerUser = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [registerUser setObject:@"gz_regist_agreement" forKey:@"key"];
    [t_b setObject:registerUser forKey:@"gz_queryconfig"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *gz_queryconfig=[t_b objectForKey:@"gz_queryconfig"];
        NSString *value=[gz_queryconfig objectForKey:@"value"];
        WebViewController *web=[[WebViewController alloc]init];
        web.url=value;
        web.titleString=@"软件许可及服务协议";
        [self.navigationController pushViewController:web animated:YES];
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
-(void)getuserinfos{
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [userInfo setObject:userName forKey:@"name"];
    [t_b setObject:userInfo forKey:@"userInfo"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *userinfo=[t_b objectForKey:@"userInfo"];
            
//            self.name=[userinfo objectForKey:@"name"];
            self.userid=[userinfo objectForKey:@"userId"];
         
            //存储用户id
            [[NSUserDefaults standardUserDefaults]setObject:self.userid forKey:@"currendUserID"];
            
        }
       
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
-(void)imgBtn{
    UIActionSheet *choosePhotoActionSheet;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose_photo", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"take_photo_from_camera", @""), NSLocalizedString(@"take_photo_from_library", @""), nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose_photo", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"take_photo_from_library", @""), nil];
    }
    
    [choosePhotoActionSheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:nil];
	self.photo = [info objectForKey:UIImagePickerControllerEditedImage];//获取图片
    
    // [[NSNotificationCenter defaultCenter]postNotificationName:@"photo" object:self.photo];
    
    //    NSString *imgurl=[info objectForKey:UIImagePickerControllerReferenceURL];
    
    
	[self.imgbtn setBackgroundImage:self.photo forState:UIControlStateNormal];
    
    NSData *mydata=UIImageJPEGRepresentation(self.photo , 0.4);
    
    
    //    NSString *pictureDataString=[mydata base64Encoding];
    
    [[NSUserDefaults standardUserDefaults]setObject:mydata forKey:@"photoname"];
    //
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:pictureDataString];   // 保存文件的名称
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
    [self.secpassword resignFirstResponder];
    [self.nick resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftButAction:(UIButton *)sender
{
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
    [self.secpassword resignFirstResponder];
    [self.nick resignFirstResponder];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
