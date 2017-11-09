//
//  FindPassWordView.m
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/4.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "FindPassWordView.h"
#import "DropDownList.h"
@interface FindPassWordView()<DropDownListDelegate,UIGestureRecognizerDelegate>
@property(strong,nonatomic)UITextField *mobile,*password,*nick;
@property(strong,nonatomic)NSString *mobileStr;
@property(nonatomic,strong) DropDownList *dList1,*dList2;
@property(nonatomic,strong) NSMutableArray *question1,*question2;
@property(nonatomic,strong) NSMutableArray *question_title1,*question_title2;
@property(nonatomic,copy) NSString *anwerID1,*anwerID2,*randomPassword;
@property(nonatomic,assign) BOOL isShow;
@property(nonatomic,strong) UIView *menban;
@end

@implementation FindPassWordView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self=[super initWithFrame:frame]) {
        self.frame=CGRectMake(0, 130, kScreenWidth, 400);
//        UIView *bgimg=[[UIView alloc]initWithFrame:CGRectMake(20, 15, kScreenWidth-40, 250)];
//        bgimg.backgroundColor=[UIColor redColor];
//        [self addSubview:bgimg];
//        self.backgroundColor=[UIColor redColor];
        self.anwerID1=@"";
        self.anwerID2=@"";
        UILabel *zhanghao=[[UILabel alloc] initWithFrame:CGRectMake(20, 20, 50, 30)];
        zhanghao.text=@"账号:";
        zhanghao.textAlignment=NSTextAlignmentLeft;
        [self addSubview:zhanghao];
        
        UILabel *question1=[[UILabel alloc] initWithFrame:CGRectMake(20, 60, 50, 30)];
        question1.text=@"问题1:";
        question1.textAlignment=NSTextAlignmentLeft;
        [self addSubview:question1];
        
        DropDownList *dlist1 = [[DropDownList alloc] initWithFrame:CGRectMake(70, 60, kScreenWidth-80, 30)];
        self.dList1=dlist1;
        self.dList1.delegate = self;
        self.dList1.tag = 10001;
        [self addSubview:dlist1];
        
        DropDownList *dlist2 = [[DropDownList alloc] initWithFrame:CGRectMake(70, 140, kScreenWidth-80, 30)];
        self.dList2=dlist2;
        self.dList2.delegate = self;
        self.dList2.tag = 10002;
        [self addSubview:dlist2];

        UILabel *answer1=[[UILabel alloc] initWithFrame:CGRectMake(20, 100, 50, 30)];
        answer1.text=@"答案:";
        answer1.textAlignment=NSTextAlignmentLeft;
        [self addSubview:answer1];
        
        UILabel *question2=[[UILabel alloc] initWithFrame:CGRectMake(20, 140, 50, 30)];
        question2.text=@"问题2:";
        question2.textAlignment=NSTextAlignmentLeft;
        [self addSubview:question2];
        
        UILabel *answer2=[[UILabel alloc] initWithFrame:CGRectMake(20, 180, 50, 30)];
        answer2.text=@"答案:";
        answer2.textAlignment=NSTextAlignmentLeft;
        [self addSubview:answer2];
        
        UIImageView *bgimg1=[[UIImageView alloc]initWithFrame:CGRectMake(60, 55, kScreenWidth-70, 1)];
        bgimg1.image=[UIImage imageNamed:@"注册输入框分割线"];
        bgimg1.userInteractionEnabled=YES;
        [self addSubview:bgimg1];
        UIImageView *bgimg2=[[UIImageView alloc]initWithFrame:CGRectMake(60, 135, kScreenWidth-70, 1)];
        bgimg2.image=[UIImage imageNamed:@"注册输入框分割线"];
        bgimg2.userInteractionEnabled=YES;
        [self addSubview:bgimg2];
        UIImageView *bgimg3=[[UIImageView alloc]initWithFrame:CGRectMake(60, 215, kScreenWidth-70, 1)];
        bgimg3.image=[UIImage imageNamed:@"注册输入框分割线"];
        bgimg3.userInteractionEnabled=YES;
        [self addSubview:bgimg3];
        
        self.mobile=[[UITextField alloc]initWithFrame:CGRectMake(70, 20, kScreenWidth-70, 30)];
        self.mobile.placeholder=@"请输入已注册的手机号码";
        self.mobile.clearButtonMode = UITextFieldViewModeAlways;//清除键
        self.mobile.tag=0;
        self.mobile.keyboardType=UIKeyboardTypeNumberPad;
        self.mobile.delegate=self;
        self.mobile.returnKeyType=UIReturnKeyDone;
        [self addSubview:self.mobile];
        
        self.nick=[[UITextField alloc]initWithFrame:CGRectMake(70, 100, kScreenWidth-70, 30)];
        self.nick.placeholder=@"请填写答案";
        self.nick.clearButtonMode = UITextFieldViewModeAlways;
        self.nick.delegate=self;
        self.nick.returnKeyType=UIReturnKeyDone;
        self.nick.tag=3;
        [self addSubview:self.nick];

        self.password=[[UITextField alloc]initWithFrame:CGRectMake(70, 180, kScreenWidth-70, 30)];
        self.password.placeholder=@"请填写答案";
        self.password.clearButtonMode = UITextFieldViewModeAlways;
        self.password.tag=1;
        self.password.delegate=self;
        self.password.returnKeyType=UIReturnKeyDone;
        [self addSubview:self.password];

        
        UIButton *logbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(bgimg3.frame)+10,300,35)];
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
        initMima.text=@"如您尚未登记找回密码提示信息，或者忘记找回密码提示信息，该账号将无法使用，请另行注册新账号。";
        initMima.font=[UIFont systemFontOfSize:14];
        initMima.textColor=[UIColor grayColor];
        initMima.numberOfLines=0;
        [initMima sizeToFit];
        CGFloat height2=initMima.frame.size.height;
        initMima.height=height2;
        [self addSubview:initMima];
        
        [self loadDListDatas];
    }
    return self;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
     [aTextfield resignFirstResponder];//关闭键盘
    return YES;
}
- (void) didSelectDropListItem:(DropDownList *)dropDownList withIndex:(NSInteger)index
{
    self.isShow=NO;
    if (self.menban) {
        [self.menban removeFromSuperview];
    }
    
    if(dropDownList==self.dList1)
    {
        NSDictionary *anwer1=self.question1[index];
        NSString *answerID1=anwer1[@"id"];
        self.anwerID1=answerID1;
        NSString *question1=anwer1[@"que_title"];
        [self.dList1.button setTitle:question1 forState:UIControlStateNormal];
    }
    if (dropDownList==self.dList2) {
        NSDictionary *anwer2=self.question2[index];
        NSString *answerID2=anwer2[@"id"];
        self.anwerID2=answerID2;
        NSString *question2=anwer2[@"que_title"];
        self.anwerID2=answerID2;
        [self.dList2.button setTitle:question2 forState:UIControlStateNormal];
    }
}
-(void)dlist:(DropDownList *)dropDownList{
    [self.password resignFirstResponder];
    [self.nick resignFirstResponder];
    [self.mobile resignFirstResponder];
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
        [self insertSubview:menban belowSubview:dropDownList.listView];
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
        
        [MBProgressHUD hideHUDForView:self animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:NO];
        
    } withCache:YES];
    
    
}
-(void)ButtonClick:(id)sender{
    [self.mobile resignFirstResponder];
    [self.password resignFirstResponder];
    [self.nick resignFirstResponder];
    
    if([self.mobile.text isEqualToString:@""])
    {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"请输入注册手机号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alre show];
        return;
    }
    if([self.nick.text isEqualToString:@""] || [self.password.text isEqualToString:@""])
    {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"请输入答案再提交" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
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
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [userCenterImage setObject:self.mobile.text forKey:@"mobile"];
    NSArray *req_list=@[@{@"que_id":self.anwerID1,@"ans_info":self.nick.text},@{@"que_id":self.anwerID2,@"ans_info":self.password.text}];
    [userCenterImage setObject:req_list forKey:@"req_list"];
    [t_b setObject:userCenterImage forKey:@"gz_syn_pwd_found"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    //
    self.mobileStr=self.mobile.text;
    
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            
            NSDictionary *dict=[t_b objectForKey:@"gz_syn_pwd_found"];
            NSString *result=dict[@"result"];
            if ([result isEqualToString:@"1"]) {
                NSString *pwd=dict[@"pwd"];
                //成功
                self.password.text=@"";
                self.nick.text=@"";
                self.mobile.text=@"";
                NSString *message=[NSString stringWithFormat:@"随机密码:%@。请尽快修改。",pwd];
                self.randomPassword=pwd;
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //密码找回成功跳转
    if (alertView.tag==111) {
        if ([self.delegate respondsToSelector:@selector(findPassWordSuccess:randomPassword:andMobile:)]) {
            [self.delegate findPassWordSuccess:self randomPassword:self.randomPassword andMobile:self.mobileStr];
        }
    }


}
@end
