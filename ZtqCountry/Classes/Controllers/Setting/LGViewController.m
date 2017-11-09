//
//  LGViewController.m
//  ZtqCountry
//
//  Created by Admin on 14-8-18.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "LGViewController.h"
#import "ZhuceViewController.h"
#import "EGOImageView.h"
#import "PersonalCenterVC.h"
#import "forgetView.h"
#import "GRZXViewController.h"
#import "ZhuceViewController.h"
#import "WebViewController.h"
#import "ManagePassWordController.h"

//#import "UMSocial.h"

@interface LGViewController ()

@end

@implementation LGViewController

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
    
        self.titleLab.text=@"登录";
        self.barHiden=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.bgscro=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht)];
    self.bgscro.showsHorizontalScrollIndicator=NO;
    self.bgscro.showsVerticalScrollIndicator=NO;
    self.bgscro.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht+100);
    [self.view addSubview:self.bgscro];
    
    UIButton *bgbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    [bgbtn addTarget:self action:@selector(hiddkey) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:bgbtn];
    
    UIImageView *userimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, kScreenWidth-40, 40)];
    userimg.image=[UIImage imageNamed:@"登录输入框"];
    userimg.userInteractionEnabled=YES;
    [self.bgscro addSubview:userimg];
    UIImageView *nickimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
    nickimg.image=[UIImage imageNamed:@"昵称图标"];
    [userimg addSubview:nickimg];
    self.name=[[UITextField alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth-68, 40)];
    self.name.placeholder=@"请输入注册手机号";
    self.name.clearButtonMode = UITextFieldViewModeAlways;
    self.name.delegate=self;
    self.name.returnKeyType=UIReturnKeyDone;
    self.name.keyboardType = UIKeyboardTypeNumberPad;
    [userimg addSubview:self.name];
    UIImageView *passimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 70, kScreenWidth-40, 40)];
    passimg.image=[UIImage imageNamed:@"登录输入框"];
    passimg.userInteractionEnabled=YES;
    [self.bgscro addSubview:passimg];
    UIImageView *nimaimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
    nimaimg.image=[UIImage imageNamed:@"输入密码"];
    [passimg addSubview:nimaimg];
    self.password=[[UITextField alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth-68, 40)];
    self.password.placeholder=@"请输入您的密码";
    self.password.delegate=self;
    self.password.clearButtonMode = UITextFieldViewModeAlways;
    self.password.returnKeyType=UIReturnKeyDone;
    [self.password setSecureTextEntry:YES];
    [passimg addSubview:self.password];
    
    UIButton *findpassbtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 125,100, 30)];
    [findpassbtn setTitle:@"找回密码>>" forState:UIControlStateNormal];
    findpassbtn.tag=112;
    findpassbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [findpassbtn setTitleColor:[UIColor colorHelpWithRed:28 green:132 blue:213 alpha:1] forState:UIControlStateNormal];
    [findpassbtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:findpassbtn];
    
    UIButton *uppassbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-110, 125,100, 30)];
    [uppassbtn setTitle:@"修改密码>>" forState:UIControlStateNormal];
    uppassbtn.tag=111;
    uppassbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [uppassbtn setTitleColor:[UIColor colorHelpWithRed:28 green:132 blue:213 alpha:1] forState:UIControlStateNormal];
    [uppassbtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:uppassbtn];
    
    UIButton *logbtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 170,kScreenWidth-40,35)];
    [logbtn.layer setMasksToBounds:YES];
    logbtn.tag=222;
    [logbtn.layer setCornerRadius:2];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮常态.png"] forState:UIControlStateNormal];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮点击态.png"] forState:UIControlStateHighlighted];
    [logbtn setTitle:@"登录" forState:UIControlStateNormal];
    [logbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logbtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [logbtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:logbtn];

   
    
    UIButton *zcbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-110, 215, 100, 30)];
    [zcbtn setTitle:@"立即注册>>" forState:UIControlStateNormal];
    zcbtn.tag=333;
    zcbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [zcbtn setTitleColor:[UIColor colorHelpWithRed:28 green:132 blue:213 alpha:1] forState:UIControlStateNormal];
    [zcbtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:zcbtn];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 255, 200, 30)];
    lab.text=@"选择第三方账号登录:";
    lab.textColor=[UIColor colorHelpWithRed:28 green:132 blue:213 alpha:1];
    lab.font=[UIFont systemFontOfSize:14];
    [self.bgscro addSubview:lab];
    
   self.datas=[[NSArray alloc]initWithObjects:@"微信登录",@"QQ登录",@"微博登录", nil];
    NSArray *tarrs=[[NSArray alloc]initWithObjects:@"微信",@"QQ",@"新浪微博", nil];
    for (int i=0; i<self.datas.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(43+90*i, 300, 50, 50)];
        btn.tag=i;
        [btn setBackgroundImage:[UIImage imageNamed:self.datas[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(lonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgscro addSubview:btn];
        UILabel *tlab=[[UILabel alloc]initWithFrame:CGRectMake(40+90*i, 350, 60+5, 30)];
        tlab.text=[tarrs objectAtIndex:i];
        tlab.centerX=btn.centerX;
        tlab.textAlignment=NSTextAlignmentCenter;
        tlab.font=[UIFont systemFontOfSize:15];
        [self.bgscro addSubview:tlab];
    }
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 380, kScreenWidth, 30)];
    lab1.text=@"知天气提示";
    lab1.textAlignment=NSTextAlignmentCenter;
    lab1.textColor=[UIColor blackColor];
    lab1.font=[UIFont systemFontOfSize:14];
    [self.bgscro addSubview:lab1];
    UIImageView *lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 395, 100, 1)];
    lineimg.image=[UIImage imageNamed:@"协议下划线"];
    [self.bgscro addSubview:lineimg];
    UIImageView *lineimg1=[[UIImageView alloc]initWithFrame:CGRectMake(200, 395, 100, 1)];
    lineimg1.image=[UIImage imageNamed:@"协议下划线"];
    [self.bgscro addSubview:lineimg1];
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(30, 410, kScreenWidth-60, 50)];
    lab2.text=@"注册或者授权知天气使用您的第三方账号登录，即表示您阅读并同意";
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.textColor=[UIColor blackColor];
    lab2.numberOfLines=0;
    lab2.font=[UIFont systemFontOfSize:14];
    [self.bgscro addSubview:lab2];
    
    UIButton *xybtn=[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-200)/2, 460, 200, 50)];
    [xybtn setTitle:@"《知天气软件许可及服务协议》" forState:UIControlStateNormal];
    xybtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [xybtn setTitleColor:[UIColor colorHelpWithRed:253 green:139 blue:41 alpha:1] forState:UIControlStateNormal];
    [xybtn addTarget:self action:@selector(xyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:xybtn];
//    self.lgtableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight) style:UITableViewStylePlain];
//    self.lgtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
//    self.lgtableview.backgroundColor=[UIColor clearColor];
//    self.lgtableview.dataSource = self;
//    self.lgtableview.delegate = self;
//    [self.view addSubview:self.lgtableview];
//    self.datas=[[NSArray alloc]initWithObjects:@"微信登录",@"微博登录", nil];
//     self.icons=[[NSArray alloc]initWithObjects:@"微信",@"登录微博",nil];
    
    
    
    
  
}
-(void)hiddkey{
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
}
-(void)ButtonClick:(UIButton *)sender{
     NSInteger tag=sender.tag;
    if (tag==111) {
//        XGPwdViewController *xgvc=[[XGPwdViewController alloc]init];
//        [self.navigationController pushViewController:xgvc animated:YES];
        ManagePassWordController *mange=[[ManagePassWordController alloc] init];
        mange.viewType=ViewTypeChangePassWord;
        [self.navigationController pushViewController:mange animated:YES];
    }
    if (tag==112) { //找回密码
        ManagePassWordController *mange=[[ManagePassWordController alloc] init];
        mange.viewType=ViewTypeFindPassWord;
        [self.navigationController pushViewController:mange animated:YES];
        
    }
    if (tag==222) {
         [self gz_scenery_user_loginwithplateType:@"4" Withuserid:self.name.text Withnickname:nil WithIcourl:nil withpwd:self.password.text];//用户登录
    }
    if (tag==333) {
        ZhuceViewController *zcvc=[[ZhuceViewController alloc]init];
        zcvc.lgtype=self.type;
        [self.navigationController pushViewController:zcvc animated:YES];
    }
}
-(void)lonAction:(UIButton *)sender{
    NSInteger tag=sender.tag;
    if (tag==0) {
        [self WXButtonClick];
    }
    if (tag==1) {
        [self QQButtonClick];
    }
    if (tag==2) {
        [self sinaButtonClick];
    }
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
-(void)userLoginAction{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    
    NSString *t_str = [NSString stringWithFormat:@"cell %d_%d", section, row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:t_str];
    
    if(cell != nil)
        [cell removeFromSuperview];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UIImageView *cellimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-20, 40)];
    cellimg.image=[UIImage imageNamed:@"登录底座.png"];
    cellimg.userInteractionEnabled=YES;
    [cell addSubview:cellimg];
    UIImageView *icoimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    icoimg.image=[UIImage imageNamed:self.icons[row]];
    [cellimg addSubview:icoimg];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth-20, 40)];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.text=self.datas[row];
    lab.font=[UIFont systemFontOfSize:15];
    lab.textColor=[UIColor blackColor];
    [cellimg addSubview:lab];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        [self WXButtonClick];
    }
//    if (indexPath.row==1) {
//        [self QQButtonClick];
//    }
    if (indexPath.row==1) {
        [self sinaButtonClick];
    }
}
-(void)sinaButtonClick{
    [[UMSocialManager defaultManager]  authWithPlatform:UMSocialPlatformType_Sina currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            
        }else{
            if ([result isKindOfClass:[UMSocialAuthResponse class]]) {
                UMSocialAuthResponse *resp = result;
                // 第三方平台SDK源数据,具体内容视平台而定
                [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:self completion:^(id result, NSError *error) {
                    UMSocialUserInfoResponse *userinfo =result;
                    [self gz_scenery_user_loginwithplateType:@"1" Withuserid:resp.uid Withnickname:userinfo.name WithIcourl:userinfo.iconurl withpwd:nil];
                }];
            }else{
                
                
            }
        }
    }];
}
-(void)QQButtonClick{

    [[UMSocialManager defaultManager]  authWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
        
        }else{
            if ([result isKindOfClass:[UMSocialAuthResponse class]]) {
                UMSocialAuthResponse *resp = result;
                // 第三方平台SDK源数据,具体内容视平台而定
                [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
                    UMSocialUserInfoResponse *userinfo =result;
                [self gz_scenery_user_loginwithplateType:@"2" Withuserid:resp.uid Withnickname:userinfo.name WithIcourl:userinfo.iconurl withpwd:nil];
                }];
            }else{
             
                
            }
        }
    }];
}

-(void)WXButtonClick{
    [[UMSocialManager defaultManager]  authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            
        }else{
            if ([result isKindOfClass:[UMSocialAuthResponse class]]) {
                UMSocialAuthResponse *resp = result;
                // 第三方平台SDK源数据,具体内容视平台而定
                [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
                    UMSocialUserInfoResponse *userinfo =result;
                    [self gz_scenery_user_loginwithplateType:@"3" Withuserid:resp.uid Withnickname:userinfo.name WithIcourl:userinfo.iconurl withpwd:nil];
                }];
            }else{
                
                
            }
        }
    }];
}

-(void)gz_scenery_user_loginwithplateType:(NSString *)type Withuserid:(NSString *)userid Withnickname:(NSString *)nickname WithIcourl:(NSString *)icourl withpwd:(NSString *)pwd{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *registerUser = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [registerUser setObject:type forKey:@"platform_type"];
    [registerUser setObject:userid forKey:@"platform_user_id"];
    if (nickname.length>0) {
        [registerUser setObject:nickname forKey:@"nick_name"];
    }
    if (icourl.length>0) {
        [registerUser setObject:icourl forKey:@"head_url"];
    }
    if (pwd.length>0) {
        NSString *str=[ShareFun getMd5_32Bit_String:pwd];
        [registerUser setObject:str forKey:@"pwd"];
    }
    if ([setting getSysUid].length>0) {
         [registerUser setObject:[setting getSysUid] forKey:@"imei"];
    }
   
    [t_b setObject:registerUser forKey:@"gz_scenery_user_login"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *registerUser=[t_b objectForKey:@"gz_scenery_user_login"];
            NSString *result=[registerUser objectForKey:@"result"];
            NSString *result_msg=[registerUser objectForKey:@"result_msg"];
//            NSLog(@"%@",result);
            if ([result isEqualToString:@"1"]) {
                NSString *use_id=[registerUser objectForKey:@"user_id"];
                NSString *nick_name=[registerUser objectForKey:@"nick_name"];
                NSString *head_url=[registerUser objectForKey:@"head_url"];
                NSString *platform_type=[registerUser objectForKey:@"platform_type"];
                 NSString *mobile=[registerUser objectForKey:@"mobile"];
                if (head_url) {
                    [[NSUserDefaults standardUserDefaults]setObject:head_url forKey:@"currendIcoUrl"];
                }
                NSURL *url=[NSURL URLWithString:head_url];
                NSData *mydata = [NSData dataWithContentsOfURL:url];
                if (mydata) {
                    [[NSUserDefaults standardUserDefaults]setObject:mydata forKey:@"currendIco"];
                }
                if (mobile!=nil && ![mobile isEqualToString:@""]) {
                    [[NSUserDefaults standardUserDefaults]setObject:mobile forKey:@"sjuserphone"];
                }
                [[NSUserDefaults standardUserDefaults]setObject:nick_name forKey:@"sjusername"];
//                [[NSUserDefaults standardUserDefaults]setObject:nick_name forKey:@"sjusername"];
                [[NSUserDefaults standardUserDefaults]setObject:use_id forKey:@"sjuserid"];
                NSLog(@"当前昵称%@",nick_name);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"myname" object:nick_name];
                if ([self.type isEqualToString:@"亲情"]) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }if ([self.type isEqualToString:@"生日"]) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                if ([self.type isEqualToString:@"风雨"]) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                if ([self.type isEqualToString:@"web"]) {
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"webLoginFinished" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"lgsuccess" object:nil];
                }if ([self.type isEqualToString:@"观察"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"sjlogin" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                        [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:result_msg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [al show];
            }
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
