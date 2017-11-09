//
//  ZtqFjVC.m
//  ZtqCountry
//
//  Created by Admin on 15/7/7.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "ZtqFjVC.h"

@implementation ZtqFjVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLab.text=@"知天气-福建";
    self.barHiden=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    self.bgscro=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht)];
    self.bgscro.showsHorizontalScrollIndicator=NO;
    self.bgscro.showsVerticalScrollIndicator=NO;
    self.bgscro.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht+100);
    [self.view addSubview:self.bgscro];
    
    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(20,15, 55, 55)];
    icon.image=[UIImage imageNamed:@"知天气 福建icon.png"];
    [self.bgscro addSubview:icon];
    UILabel *fjlab=[[UILabel alloc]initWithFrame:CGRectMake(100, 25, 100, 30)];
    fjlab.text=@"知天气-福建";
    fjlab.font=[UIFont systemFontOfSize:16];
    [self.bgscro addSubview:fjlab];
    UIButton *downbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-75,20, 50, 30)];
    [downbtn setTitle:@"下载" forState:UIControlStateNormal];
    [downbtn setBackgroundImage:[UIImage imageNamed:@"下载按钮"] forState:UIControlStateNormal];
    [downbtn setBackgroundImage:[UIImage imageNamed:@"下载按钮点击"] forState:UIControlStateHighlighted];
    [downbtn addTarget:self action:@selector(downAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:downbtn];
    
    UILabel *gnlab=[[UILabel alloc]initWithFrame:CGRectMake(20, 85, 100, 30)];
    gnlab.text=@"功能简介:";
    gnlab.font=[UIFont fontWithName:kBaseFont size:15];
    [self.bgscro addSubview:gnlab];
    
    UILabel *contentlab=[[UILabel alloc]initWithFrame:CGRectMake(20,120, kScreenWidth-40, 80)];
    contentlab.text=@"知天气-福建手机气象客户端由福建省气象局官方打造，为决策、专业、行业用户提供天气实况与预报、气象预警信息，以及风雨查询、台风路径、气象雷达、气象服务等功能。";
    contentlab.numberOfLines=0;
    contentlab.font=[UIFont systemFontOfSize:14];
    [self.bgscro addSubview:contentlab];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 200, 100, 30)];
    lab.text=@"快扫:";
    lab.font=[UIFont fontWithName:kBaseFont size:15];
    [self.bgscro addSubview:lab];
    
    UIImageView *ewm=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-120)/2, 230, 120, 120)];
    ewm.image=[UIImage imageNamed:@"福建二维码.png"];
    [self.bgscro addSubview:ewm];
    UILabel *bqlab=[[UILabel alloc]initWithFrame:CGRectMake(20, 390, kScreenWidth, 30)];
    bqlab.text=@"版权所有: 福建省气象局";
    bqlab.font=[UIFont systemFontOfSize:14];
    [self.bgscro addSubview:bqlab];
    UILabel *jslab=[[UILabel alloc]initWithFrame:CGRectMake(20, 420, kScreenWidth, 30)];
    jslab.text=@"技术开发: 福州派克斯网络科技有限公司";
    jslab.font=[UIFont systemFontOfSize:14];
    [self.bgscro addSubview:jslab];
    NSURL *appUrl = [NSURL URLWithString:@"com.app.ztq://ztq"];
    BOOL isExist = [[UIApplication sharedApplication]canOpenURL:appUrl];
    if (isExist==YES) {
         [downbtn setTitle:@"打开" forState:UIControlStateNormal];
    }
}
-(void)downAction{
    NSURL *appUrl = [NSURL URLWithString:@"com.app.ztq://ztq"];
    BOOL isExist = [[UIApplication sharedApplication]canOpenURL:appUrl];
    if (isExist==YES) {
        NSURL *Url = [NSURL URLWithString:@"com.app.ztq://ztq"];
       [[UIApplication sharedApplication]openURL:Url];
    }else{

    trackViewURL=@"https://itunes.apple.com/cn/app/zhi-tian-qi-zhang-shang-qi/id451961462?mt=8";
    NSURL *url = [NSURL URLWithString:trackViewURL];
    
        [[UIApplication sharedApplication]openURL:url];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
