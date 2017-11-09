//
//  LoginAlertView.m
//  ZtqCountry
//
//  Created by linxg on 14-8-14.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "LoginAlertView.h"
#import "ZhuceViewController.h"
//#import "UMSocial.h"

@interface LoginAlertView ()

@property (strong, nonatomic) UIImageView * bgImgV;
@end

@implementation LoginAlertView

- (id)initWithFrame:(CGRect)frame
{
    CGRect newFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeitht);
    self = [super initWithFrame:newFrame];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

-(id)initWithDelegate:(id)delegate
{
    CGRect newFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeitht);
    self = [super initWithFrame:newFrame];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        [self createView];
    }
    return self;
}


-(void)createView
{
    //    UIView * blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    //    blurView.backgroundColor = [UIColor blackColor];
    //    blurView.alpha = 0.5;
    //    [self addSubview:blurView];
    
    UIImageView * backgroundImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, kScreenWidth-40, 350)];
    self.bgImgV = backgroundImgV;
    backgroundImgV.userInteractionEnabled = YES;
    backgroundImgV.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgroundImgV];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
    titleLab.text = @"用户登录";
    titleLab.textColor = [UIColor blueColor];
    titleLab.font = [UIFont fontWithName:kBaseFont size:15];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.backgroundColor = [UIColor clearColor];
    [backgroundImgV addSubview:titleLab];
    
    UIButton * closeBut = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(backgroundImgV.frame)-5-20, 5, 20, 20)];
    [closeBut setBackgroundImage:[UIImage imageNamed:@"删除.png"] forState:UIControlStateNormal];
    [closeBut addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImgV addSubview:closeBut];
    
    UIImageView * lineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth-40, 2)];
    lineImgV.backgroundColor = [UIColor blueColor];
    [backgroundImgV addSubview:lineImgV];
    
    _accountTF = [[UITextField alloc] initWithFrame:CGRectMake(5, 35, CGRectGetWidth(backgroundImgV.frame)-10, 40)];
    _accountTF.font = [UIFont fontWithName:kBaseFont size:15];
    _accountTF.placeholder = @"请输入邮箱";
    _accountTF.clearButtonMode = UITextFieldViewModeAlways;
    //    _accountTF.borderStyle = UITextBorderStyleBezel;
    UILabel * accountLeftView = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
    accountLeftView.backgroundColor = [UIColor clearColor];
    accountLeftView.text = @"  帐号:";
    accountLeftView.textAlignment = NSTextAlignmentLeft;
    accountLeftView.font = _accountTF.font;
    accountLeftView.textColor = [UIColor blackColor];
    _accountTF.leftView = accountLeftView;
    _accountTF.leftViewMode = UITextFieldViewModeAlways;
    [backgroundImgV addSubview:_accountTF];
    
    _passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(5, 75, CGRectGetWidth(backgroundImgV.frame)-10, 40)];
    _passwordTF.font = [UIFont fontWithName:kBaseFont size:15];
    _passwordTF.placeholder = @"请输入密码";
    _passwordTF.clearButtonMode = UITextFieldViewModeAlways;
    //    _passwordTF.borderStyle = UITextBorderStyleBezel;
    UILabel * passwordLeftView = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
    passwordLeftView.backgroundColor = [UIColor clearColor];
    passwordLeftView.textAlignment = NSTextAlignmentLeft;
    passwordLeftView.font = _passwordTF.font;
    passwordLeftView.textColor = [UIColor blackColor];
    passwordLeftView.text = @"  密码:";
    _passwordTF.leftView = passwordLeftView;
    _passwordTF.leftViewMode = UITextFieldViewModeAlways;
    [backgroundImgV addSubview:_passwordTF];
    
    UIButton * loginBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 120, CGRectGetWidth(backgroundImgV.frame)-10, 35)];
    loginBut.layer.cornerRadius = 3;
    [loginBut addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginBut setBackgroundImage:[UIImage imageNamed:@"登录.png"] forState:UIControlStateNormal];
    [loginBut setBackgroundImage:[UIImage imageNamed:@"登录点击.png"] forState:UIControlStateHighlighted];
    [loginBut setTitle:@"登录" forState:UIControlStateNormal];
    [loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backgroundImgV addSubview:loginBut];
    
    UIButton * registerBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 160, CGRectGetWidth(backgroundImgV.frame)-10, 35)];
    registerBut.tag = 3;
    registerBut.layer.cornerRadius = 3;
    [registerBut addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [registerBut setBackgroundImage:[UIImage imageNamed:@"注册.png"] forState:UIControlStateNormal];
    [registerBut setBackgroundImage:[UIImage imageNamed:@"注册点击"] forState:UIControlStateHighlighted];
    [registerBut setTitle:@"注册" forState:UIControlStateNormal];
    [registerBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backgroundImgV addSubview:registerBut];
    
    
    UILabel * quickLoginLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 100, 20)];
    quickLoginLab.backgroundColor = [UIColor clearColor];
    quickLoginLab.textAlignment = NSTextAlignmentLeft;
    quickLoginLab.font = [UIFont fontWithName:kBaseFont size:13];
    quickLoginLab.textColor = [UIColor blueColor];
    quickLoginLab.text = @"一键登录";
    [backgroundImgV addSubview:quickLoginLab];
    
    UIButton * ForgotPasswordBut = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(backgroundImgV.frame)-10-100, 200, 100, 20)];
    ForgotPasswordBut.titleLabel.font = [UIFont fontWithName:kBaseFont size:13];
    [ForgotPasswordBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [ForgotPasswordBut setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [ForgotPasswordBut addTarget:self action:@selector(forgotPassWordAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImgV addSubview:ForgotPasswordBut];
    
    UIButton * xlwbBut = [[UIButton alloc] initWithFrame:CGRectMake(50, 240, 50, 50)];
    xlwbBut.tag = 1;
    [xlwbBut setBackgroundImage:[UIImage imageNamed:@"新浪.png"] forState:UIControlStateNormal];
    [xlwbBut addTarget:self action:@selector(thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImgV addSubview:xlwbBut];
    
    UILabel * xlwbLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 140, 20)];
    xlwbLab.backgroundColor = [UIColor clearColor];
    xlwbLab.text = @"微博登录";
    xlwbLab.textAlignment = NSTextAlignmentCenter;
    xlwbLab.font = [UIFont fontWithName:kBaseFont size:13];
    xlwbLab.textColor = [UIColor grayColor];
    [backgroundImgV addSubview:xlwbLab];
    
    
    UIButton * qqBut = [[UIButton alloc] initWithFrame:CGRectMake(180, 240, 50, 50)];
    [qqBut setBackgroundImage:[UIImage imageNamed:@"朋友圈.png"] forState:UIControlStateNormal];
    qqBut.tag=2;
    [qqBut addTarget:self action:@selector(thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImgV addSubview:qqBut];
    
    UILabel * qqLab = [[UILabel alloc] initWithFrame:CGRectMake(140, 300, 140, 20)];
    qqLab.backgroundColor = [UIColor clearColor];
    qqLab.text = @"QQ登录";
    qqLab.textAlignment = NSTextAlignmentCenter;
    qqLab.font = [UIFont fontWithName:kBaseFont size:13];
    qqLab.textColor = [UIColor grayColor];
    [backgroundImgV addSubview:qqLab];
    
}


-(void)show
{
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.1, 0.1);
    _bgImgV.transform = scaleTransform;
    //    [UIView ani]
    
    [UIView animateWithDuration:0.2 animations:^{
        _bgImgV.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            _bgImgV.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                _bgImgV.transform = CGAffineTransformMakeScale(1.05, 1.05);
            } completion:^(BOOL finished) {
                _bgImgV.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
        _bgImgV.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    
}

-(void)closeAction:(UIButton *)sender
{
    [self removeFromSuperview];
}

-(void)loginAction:(UIButton *)sender
{
    NSMutableArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"pass"];
    NSDictionary *dic=[NSDictionary dictionaryWithObject:_passwordTF.text forKey:_accountTF
                       .text];
    if ([arr containsObject:dic]) {
        NSLog(@"登录成功");
        [[NSUserDefaults standardUserDefaults]setObject:_accountTF.text forKey:@"currendUserName"];
        
    }else{
        UIAlertView *alreat=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"用户名或密码错误，请重输" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alreat show];
    }
    
    
}

-(void)registerAction:(UIButton *)sender
{
    
    if([self.delegate respondsToSelector:@selector(LoginAlertThirdLoginWithTag:)])
    {
        [self.delegate LoginAlertThirdLoginWithTag:sender.tag];
        [self removeFromSuperview];
    }
}

-(void)forgotPassWordAction:(UIButton *)sender
{
    
}

-(void)thirdLoginAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(LoginAlertThirdLoginWithTag:)])
    {
        [self.delegate LoginAlertThirdLoginWithTag:sender.tag];
        [self removeFromSuperview];
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
