//
//  WarnBillViewController.m
//  ZtqCountry
//
//  Created by Admin on 15/8/25.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "WarnBillViewController.h"

@interface WarnBillViewController ()

@end

@implementation WarnBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    self.navigationController.navigationBarHidden = YES;
    //    self.title = @"推送设置";
    float place = 0;
    if(kSystemVersionMore7)
    {
        place = 20;
    }
    self.barHeight = 44+ place;
    _navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    _navigationBarBg.userInteractionEnabled = YES;
    //    _navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:27 green:92 blue:189 alpha:1];
    _navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:_navigationBarBg];
    
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [_navigationBarBg addSubview:leftimg];
    
    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    [_leftBut addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 12+place, kScreenWidth-100, 20)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor whiteColor];
    [_navigationBarBg addSubview:_titleLab];
    _titleLab.text=self.titleString;
    
    
    UIWebView * webV = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-44)];
    webV.delegate = self;
    webV.scalesPageToFit=YES;//允许缩放
    self.web = webV;
    [self.view addSubview:webV];
//    [self loadWeb:self.url];
    [self getgz_typho_warn_bill];
    
    UIActivityIndicatorView * activityV = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityV setCenter:self.view.center];
    [activityV setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    self.activity = activityV;
    [self.view addSubview:activityV];
}
-(void)getgz_typho_warn_bill{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *ftlist = [[NSMutableDictionary alloc]init];
    
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    if (self.code.length>0) {
        [ftlist setObject:self.code forKey:@"code"];
    }
    [t_b setObject:ftlist forKey:@"gz_typho_warn_bill"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *gz_typho_warn_bill=[t_b objectForKey:@"gz_typho_warn_bill"];
        NSString *url=[gz_typho_warn_bill objectForKey:@"warn_bill"];
        if (url.length>0) {
            [self loadWeb:url];
        }else{
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
            lab.text=@"无台风警报单";
            lab.textAlignment=NSTextAlignmentCenter;
            lab.font=[UIFont systemFontOfSize:15];
            lab.textColor=[UIColor blackColor];
            [_web addSubview:lab];
        }

    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
-(void)leftBtn{
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadWeb:(NSString *)urlS
{
    //    NSLog(@"##%@##",urlS);
    NSURL * url = [NSURL URLWithString:urlS];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:request];
}
#pragma mark -
#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activity startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activity stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activity stopAnimating];
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
