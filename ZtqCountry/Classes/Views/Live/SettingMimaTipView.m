//
//  SettingMimaTipView.m
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/5.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "SettingMimaTipView.h"
#import "DropDownList.h"
@interface SettingMimaTipView()<UIGestureRecognizerDelegate>
@property(strong,nonatomic)UITextField *password,*nick;
@property(strong,nonatomic)NSString *strname,*strpassword;
@property(nonatomic,strong) DropDownList *dList1,*dList2;
@property(nonatomic,strong) NSMutableArray *question1,*question2;
@property(nonatomic,strong) NSMutableArray *question_title1,*question_title2;
@property(nonatomic,copy) NSString *anwerID1,*anwerID2;
@property(nonatomic,strong) UIView *menban;
@property(nonatomic,assign) BOOL isShow;
@property(nonatomic,strong) UIButton *logbtn;
@end
@implementation SettingMimaTipView
-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self=[super initWithFrame:frame]) {
        self.frame=CGRectMake(0, 130, kScreenWidth, 300);
        self.anwerID1=@"";
        self.anwerID2=@"";
        
        UILabel *question1=[[UILabel alloc] initWithFrame:CGRectMake(20, 20, 50, 30)];
        question1.text=@"问题1:";
        question1.textAlignment=NSTextAlignmentLeft;
        [self addSubview:question1];
        
        DropDownList *dlist1 = [[DropDownList alloc] initWithFrame:CGRectMake(70, 20, kScreenWidth-80, 30)];
        self.dList1=dlist1;
        self.dList1.delegate = self;
        self.dList1.tag = 10001;
//        [self.dList1.button setTitle:@"你的宠物名叫什么" forState:UIControlStateNormal];
        [self addSubview:dlist1];
        
        DropDownList *dlist2 = [[DropDownList alloc] initWithFrame:CGRectMake(70, 100, kScreenWidth-80, 30)];
        self.dList2=dlist2;
        self.dList2.delegate = self;
        self.dList2.tag = 10002;
//        [self.dList2.button setTitle:@"你的故乡在哪里" forState:UIControlStateNormal];
        [self addSubview:dlist2];
        
        UILabel *answer1=[[UILabel alloc] initWithFrame:CGRectMake(20, 60, 50, 30)];
        answer1.text=@"答案:";
        answer1.textAlignment=NSTextAlignmentLeft;
        [self addSubview:answer1];
        
        UILabel *question2=[[UILabel alloc] initWithFrame:CGRectMake(20, 100, 50, 30)];
        question2.text=@"问题2:";
        question2.textAlignment=NSTextAlignmentLeft;
        [self addSubview:question2];
        
        UILabel *answer2=[[UILabel alloc] initWithFrame:CGRectMake(20, 140, 50, 30)];
        answer2.text=@"答案:";
        answer2.textAlignment=NSTextAlignmentLeft;
        [self addSubview:answer2];
        
        UIImageView *bgimg1=[[UIImageView alloc]initWithFrame:CGRectMake(60, 91, kScreenWidth-70, 1)];
        bgimg1.image=[UIImage imageNamed:@"注册输入框分割线"];
        bgimg1.userInteractionEnabled=YES;
        [self addSubview:bgimg1];
        UIImageView *bgimg2=[[UIImageView alloc]initWithFrame:CGRectMake(60, 171, kScreenWidth-70, 1)];
        bgimg2.image=[UIImage imageNamed:@"注册输入框分割线"];
        bgimg2.userInteractionEnabled=YES;
        [self addSubview:bgimg2];
        
        self.nick=[[UITextField alloc]initWithFrame:CGRectMake(70, 60, kScreenWidth-70, 30)];
        self.nick.placeholder=@"请填写5个字以内的答案";
        self.nick.clearButtonMode = UITextFieldViewModeAlways;
        self.nick.delegate=self;
        self.nick.returnKeyType=UIReturnKeyDone;
        self.nick.tag=3;
        [self addSubview:self.nick];
        
        self.password=[[UITextField alloc]initWithFrame:CGRectMake(70, 140, kScreenWidth-70, 30)];
        self.password.placeholder=@"请填写5个字以内的答案";
        self.password.clearButtonMode = UITextFieldViewModeAlways;
        self.password.tag=1;
        self.password.delegate=self;
        self.password.returnKeyType=UIReturnKeyDone;
        self.strpassword=self.password.text;
        [self addSubview:self.password];

        
        UIButton *logbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.password.frame)+20,300,35)];
        [logbtn.layer setMasksToBounds:YES];
        [logbtn.layer setCornerRadius:2];
        [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮常态.png"] forState:UIControlStateNormal];
        [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮点击态.png"] forState:UIControlStateHighlighted];
        [logbtn setTitle:@"提交" forState:UIControlStateNormal];
        [logbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        logbtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [logbtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:logbtn];
        self.logbtn=logbtn;
        [self loadDListDatas];
    }
    return self;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder];//关闭键盘
 
    return YES;
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
            self.questlist=info_list;
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
            [self getuesrquery];
}
        
        [MBProgressHUD hideHUDForView:self animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:NO];
        
    } withCache:YES];
    
    
}
-(void)getuesrquery
{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    NSString *platid=[self.user_info objectForKey:@"platform_user_id"];
    if (platid.length>0) {
       [userCenterImage setObject:platid forKey:@"platform_user_id"];
    }
    [t_b setObject:userCenterImage forKey:@"gz_syn_user_que_query"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *syn_user_que=[t_b objectForKey:@"gz_syn_user_que_query"];
            NSArray *list=[syn_user_que objectForKey:@"info_list"];
            if (list.count>1) {
                for (int i=0; i<self.questlist.count; i++) {
                    NSString *queid=[self.questlist[i] objectForKey:@"id"];
                    if ([queid isEqualToString:[list[0] objectForKey:@"que_id"]]) {
                        [self.dList1.button setTitle:self.questlist[i][@"que_title"] forState:UIControlStateNormal];
                        self.nick.text=[list[0]objectForKey:@"ans_info"];
                          self.anwerID1=queid;
                    }
                    if ([queid isEqualToString:[list[1] objectForKey:@"que_id"]]) {
                        [self.dList2.button setTitle:self.questlist[i][@"que_title"] forState:UIControlStateNormal];
                        self.password.text=[list[1]objectForKey:@"ans_info"];
                          self.anwerID2=queid;
                    }
                }
            }
        }
        [MBProgressHUD hideHUDForView:self animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:NO];
        
    } withCache:YES];
    
    
}
-(void)dlist:(DropDownList *)dropDownList{
    [self.nick resignFirstResponder];
    [self.password resignFirstResponder];
   
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
        self.nick.placeholder=@"请填写5个字以内的答案";
    }
    if (dropDownList==self.dList2) {
        [self.dList1 setShowList:NO];
        NSDictionary *anwer2=self.question2[index];
        NSString *answerID2=anwer2[@"id"];
         NSString *question2=anwer2[@"que_title"];
        self.anwerID2=answerID2;
      [self.dList2.button setTitle:question2 forState:UIControlStateNormal];
        self.password.placeholder=@"请填写5个字以内的答案";
    }
}

-(void)ButtonClick:(id)sender{
    self.logbtn.enabled=NO;
    [self.password resignFirstResponder];
    [self.nick resignFirstResponder];
    if([self.nick.text isEqualToString:@""] || [self.password.text isEqualToString:@""])
    {
        self.logbtn.enabled=YES;
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"请输入答案" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alre show];
        return;
    }
     [self performSelector:@selector(changeAction) withObject:nil afterDelay:0.5];
  
    

}
-(void)changeAction
{

    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
//    NSString * sjuserphone = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserphone"];
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [userCenterImage setObject:userid forKey:@"user_id"];
    NSString *platform_user_id=self.user_info[@"platform_user_id"];
    if (platform_user_id.length>0) {
        [userCenterImage setObject:platform_user_id forKey:@"platform_user_id"];
    }
    NSArray *req_list=@[@{@"que_id":self.anwerID1,@"ans_info":self.nick.text},@{@"que_id":self.anwerID2,@"ans_info":self.password.text}];
    [userCenterImage setObject:req_list forKey:@"req_list"];
    [t_b setObject:userCenterImage forKey:@"gz_syn_user_que_set"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    //
//    self.password.text=@"";
//    self.nick.text=@"";
    
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        self.logbtn.enabled=YES;
        if (t_b != nil)
        {
            
            NSDictionary *dict=[t_b objectForKey:@"gz_syn_user_que_set"];
            NSString *result=dict[@"result"];
            if ([result isEqualToString:@"1"]) {
                //成功
                    self.password.text=@"";
                    self.nick.text=@"";
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
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
        self.logbtn.enabled=YES;
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
            [self.delegate SettingMimaTipViewSuccess:self];
        }
        
    }
    
}
@end
