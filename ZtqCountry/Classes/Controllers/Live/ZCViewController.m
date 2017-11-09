//
//  ZCViewController.m
//  ztqFj
//
//  Created by Admin on 15-1-15.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "ZCViewController.h"
#import "GRZXViewController.h"
@interface ZCViewController ()

@end

@implementation ZCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.barHiden=NO;
    self.titleLab.text=@"注册";
    self.view.backgroundColor=[UIColor colorHelpWithRed:239 green:239 blue:239 alpha:1];
    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, 110)];
    bgimg.image=[UIImage imageNamed:@"dl输入框"];
    bgimg.userInteractionEnabled=YES;
    [self.view addSubview:bgimg];
    UIImageView *bgimg1=[[UIImageView alloc]initWithFrame:CGRectMake(15, 55, 290, 1)];
    bgimg1.image=[UIImage imageNamed:@"热门城市隔条"];
    bgimg1.userInteractionEnabled=YES;
    [bgimg addSubview:bgimg1];
    
    UILabel *log=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 45, 30)];
    log.text=@"邮  箱:";
    log.textColor=[UIColor blackColor];
    log.font=[UIFont systemFontOfSize:14];
    [bgimg addSubview:log];
    UILabel *nick=[[UILabel alloc]initWithFrame:CGRectMake(10,70, 45, 30)];
    nick.text=@"昵  称:";
    nick.textColor=[UIColor blackColor];
    nick.font=[UIFont systemFontOfSize:14];
    [bgimg addSubview:nick];

  
    
    self.mailtf=[[UITextField alloc]initWithFrame:CGRectMake(80, 20, 200, 30)];
    self.mailtf.placeholder=@"请输入邮箱";
    self.mailtf.clearButtonMode = UITextFieldViewModeAlways;//清除键
    self.mailtf.tag=0;
    self.mailtf.delegate=self;
   
    [bgimg addSubview:self.mailtf];
    
    self.nicktf=[[UITextField alloc]initWithFrame:CGRectMake(80, 70, 200, 30)];
    self.nicktf.placeholder=@"请输入昵称";
     self.nicktf.clearButtonMode = UITextFieldViewModeAlways;//清除键
    self.nicktf.tag=1;
    self.nicktf.delegate=self;
    [bgimg addSubview:self.nicktf];
    UIButton *logbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logbtn.frame= CGRectMake(10, 120+self.barHeight,300,35);
    [logbtn.layer setMasksToBounds:YES];
    [logbtn.layer setCornerRadius:2];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"dl登录.png"] forState:UIControlStateNormal];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"dl登录点击.png"] forState:UIControlStateHighlighted];
    [logbtn setTitle:@"提交" forState:UIControlStateNormal];
    [logbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logbtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [logbtn addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logbtn];
}
-(void)loginButtonClick{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sj_user_res = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [sj_user_res setObject:self.nicktf.text forKey:@"nickname"];
    [sj_user_res setObject:self.mailtf.text forKey:@"email"];
    [t_b setObject:sj_user_res forKey:@"sj_user_res"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *res=[t_b objectForKey:@"sj_user_res"];
        NSDictionary *data=[res objectForKey:@"data"];
        NSString *type=[data objectForKey:@"type"];
        NSString *msg=[data objectForKey:@"msg"];
        if (![type isEqualToString:@"1"]) {
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [al show];
            return ;
        }else{
            [self login];
//            SinglePhotoViewController *sig=[[SinglePhotoViewController alloc]init];
//            [self.navigationController pushViewController:sig animated:YES];
        }
       
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
-(void)login{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sj_user_login = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [sj_user_login setObject:self.nicktf.text forKey:@"nickname"];
    [t_b setObject:sj_user_login forKey:@"sj_user_login"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *res=[t_b objectForKey:@"sj_user_login"];
        NSDictionary *data=[res objectForKey:@"data"];
        NSString *type=[data objectForKey:@"type"];
        NSString *msg=[data objectForKey:@"msg"];
        if (![type isEqualToString:@"1"]) {
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [al show];
            return ;
        }else{
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [al show];
            NSString *user_id=[data objectForKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults]setObject:user_id forKey:@"sjuserid"];
            [[NSUserDefaults standardUserDefaults]setObject:self.nicktf.text forKey:@"sjusername"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            GRZXViewController *sig=[[GRZXViewController alloc]init];
            sig.type=@"1";
            [self.navigationController pushViewController:sig animated:YES];
        }
        
    } withFailure:^(NSError *error) {
       [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } withCache:YES];
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
