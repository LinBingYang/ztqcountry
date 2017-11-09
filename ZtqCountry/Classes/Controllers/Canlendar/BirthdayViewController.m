//
//  BirthdayViewController.m
//  ZtqCountry
//
//  Created by Admin on 15/12/7.
//  Copyright © 2015年 yyf. All rights reserved.
//

#import "BirthdayViewController.h"
#import "payRequsestHandler.h"
#import "UILabel+utils.h"
#import "EGOImageView.h"
#import "weiboVC.h"
@interface BirthdayViewController ()
@property(strong,nonatomic)UIImageView *bgimg;
@end

@implementation BirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"pay" object:nil];
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    self.barHeight=place+44;
    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    self.bgimg=bgimg;
    bgimg.image=[UIImage imageNamed:@"趋势背景图"];
    bgimg.userInteractionEnabled=YES;
    [self.view addSubview:bgimg];
    self.navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    self.navigationBarBg.userInteractionEnabled = YES;
    //    self.navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    self.navigationBarBg.backgroundColor = [UIColor clearColor];
    [bgimg addSubview:self.navigationBarBg];
    
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 30, 30)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [_navigationBarBg addSubview:leftimg];
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:leftBut];
    
    UIButton * rightbut = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-40, 7+place, 30, 30)];
    [rightbut setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    [rightbut setBackgroundColor:[UIColor clearColor]];
    [rightbut addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:rightbut];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, self.view.width-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"出生日天气查询";
    [self.navigationBarBg addSubview:titleLab];
    
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    self.userid=userid;
    NSString * username = [[NSUserDefaults standardUserDefaults]objectForKey:@"sjusername"];
    self.username=username;
}
-(void)viewWillAppear:(BOOL)animated{
    if (self.ispay==YES) {
        if (self.bgscr) {
            [self.bgscr removeFromSuperview];
            self.bgscr=nil;
        }
        [self creatpayview];
        [self getgz_cal_birth_product];
    }
    
//    [self gz_cal_birth_info];
}
-(void)creatpayview{
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    self.userid=userid;
    NSString * username = [[NSUserDefaults standardUserDefaults]objectForKey:@"sjusername"];
    self.username=username;
    NSString *ico=[self.data objectForKey:@"ico"];
//    NSString *birthday=[self.data objectForKey:@"birthday"];
//    NSString *birth_cal=[self.data objectForKey:@"birth_cal"];
    NSString *birthday=self.time;
    NSString *birth_cal=self.chineseday;
     NSString *birth_intro=[self.data objectForKey:@"birth_intro"];
     NSString *birth_login=[self.data objectForKey:@"birth_login"];
    
    self.bgscr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht)];
    self.bgscr.showsHorizontalScrollIndicator=NO;
    self.bgscr.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.bgscr];
    UIImageView *icoimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 60, 60)];
    icoimg.image=[UIImage imageNamed:[NSString stringWithFormat:@"ww%@",ico]];
    [self.bgscr addSubview:icoimg];
    UILabel *des=[[UILabel alloc]initWithFrame:CGRectMake(80, 5, 200, 30)];
    des.text=[self.data objectForKey:@"weather_desc"];
    des.textColor=[UIColor whiteColor];
    des.font=[UIFont systemFontOfSize:15];
    [self.bgscr addSubview:des];
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(75, 35, kScreenWidth-95, 1)];
    line.backgroundColor=[UIColor grayColor];
    [self.bgscr addSubview:line];
    UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(80, 35, kScreenWidth-80, 30)];
    time.text=[NSString stringWithFormat:@"%@  %@",birthday,birth_cal];
    time.textColor=[UIColor whiteColor];
    time.font=[UIFont systemFontOfSize:15];
    [self.bgscr addSubview:time];
    UILabel *infolab=[[UILabel alloc]initWithFrame:CGRectMake(15, 65, kScreenWidth-30, 60)];
    infolab.text=[NSString stringWithFormat:@"       %@",birth_intro];
    infolab.numberOfLines=0;
    infolab.textColor=[UIColor whiteColor];
    infolab.font=[UIFont systemFontOfSize:15];
    [self.bgscr addSubview:infolab];
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(15, 130, kScreenWidth-30, 1)];
    line1.backgroundColor=[UIColor grayColor];
    [self.bgscr addSubview:line1];
    
    UILabel *loglab=[[UILabel alloc]initWithFrame:CGRectMake(15, 140, kScreenWidth-80, 30)];
    loglab.textColor=[UIColor whiteColor];
    loglab.font=[UIFont systemFontOfSize:15];
    [self.bgscr addSubview:loglab];
    
    self.deslab=[[UILabel alloc]initWithFrame:CGRectMake(15, 180, kScreenWidth-30, 60)];
    self.deslab.textColor=[UIColor orangeColor];
    self.deslab.numberOfLines=0;
    self.deslab.font=[UIFont systemFontOfSize:15];
    [self.bgscr addSubview:self.deslab];
    
    self.zflab=[[UILabel alloc]initWithFrame:CGRectMake(15, 240, kScreenWidth-30, 30)];
    self.zflab.textColor=[UIColor whiteColor];
    self.zflab.font=[UIFont systemFontOfSize:15];
    [self.bgscr addSubview:self.zflab];
    
    UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(15, 275, kScreenWidth-30, 0.5)];
    line2.backgroundColor=[UIColor grayColor];
    [self.bgscr addSubview:line2];
    
    UIView *zfview=[[UIView alloc]initWithFrame:CGRectMake(0, 280, kScreenWidth, 150)];
    zfview.userInteractionEnabled=YES;
    [self.bgscr addSubview:zfview];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 30)];
    lab.text=@"选择支付方式：";
    lab.textColor=[UIColor whiteColor];
    lab.font=[UIFont systemFontOfSize:15];
    [zfview addSubview:lab];
    
    
    
    UIImageView *xzimg=[[UIImageView alloc]initWithFrame:CGRectMake(30,40, 17, 17)];
    xzimg.image=[UIImage imageNamed:@"支付方式选择选中态"];
    self.wximg=xzimg;
    self.paytype=@"1";
    xzimg.userInteractionEnabled=YES;
    [zfview addSubview:xzimg];
    UIImageView *wximg=[[UIImageView alloc]initWithFrame:CGRectMake(55, 35, 100, 30)];
    wximg.image=[UIImage imageNamed:@"微信支付"];
    self.wechaimg=wximg;
    wximg.userInteractionEnabled=YES;
    [zfview addSubview:wximg];
    
    UIButton *wxzf=[[UIButton alloc]initWithFrame:CGRectMake(30, 35, 100, 40)];
    [wxzf addTarget:self action:@selector(wxzfAction) forControlEvents:UIControlEventTouchUpInside];
    [zfview addSubview:wxzf];
    UIImageView *xzimg1=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-155, 40, 17, 17)];
    xzimg1.image=[UIImage imageNamed:@"支付方式选择未选中态"];
    self.zfbimg=xzimg1;
    xzimg1.userInteractionEnabled=YES;
    [zfview addSubview:xzimg1];
    UIImageView *zfbimg=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-130, 35, 100, 30)];
    zfbimg.image=[UIImage imageNamed:@"支付宝支付未选中"];
    self.aliimg=zfbimg;
    zfbimg.userInteractionEnabled=YES;
    [zfview addSubview:zfbimg];
    
    UIButton *zfbzf=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-130, 35, 100, 40)];
    [zfbzf addTarget:self action:@selector(zfbzfAction) forControlEvents:UIControlEventTouchUpInside];
    [zfview addSubview:zfbzf];
    
    UIButton *tjbtn=[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-220)/2, 90, 220, 30)];
    [tjbtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [tjbtn setBackgroundImage:[UIImage imageNamed:@"确认支付常态"] forState:UIControlStateNormal];
//    [tjbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮点击态"] forState:UIControlStateHighlighted];
    [tjbtn addTarget:self action:@selector(tjAction) forControlEvents:UIControlEventTouchUpInside];
    [zfview addSubview:tjbtn];
    
    if (!self.userid.length>0) {
        loglab.text=[NSString stringWithFormat:@"%@",birth_login];
        
        UIButton *lgbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-75, 140, 60, 30)];
        [lgbtn setBackgroundImage:[UIImage imageNamed:@"查询"] forState:UIControlStateNormal];
        [lgbtn setTitle:@"登录" forState:UIControlStateNormal];
        lgbtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [lgbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [lgbtn addTarget:self action:@selector(lgAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bgscr addSubview:lgbtn];
        
        
        
    }else{
        loglab.text=[NSString stringWithFormat:@"您好，亲爱的%@",self.username];
        UIButton * userBut = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-60)/2, 170, 60, 60)];
        userBut.layer.cornerRadius = 30;
        userBut.layer.masksToBounds = YES;
        UIImage * userImg = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"]];
        if(userImg == nil)
        {
            userImg = [UIImage imageNamed:@"个人图标"];
        }
        [userBut setBackgroundImage:userImg forState:UIControlStateNormal];
        [userBut addTarget:self action:@selector(userButAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bgscr addSubview:userBut];
        self.deslab.frame=CGRectMake(15, 230, kScreenWidth-30, 60);
        self.zflab.frame=CGRectMake(15, 290, kScreenWidth-30, 30);
        line2.frame=CGRectMake(15, 320, kScreenWidth-30, 0.5);
        zfview.frame=CGRectMake(0, 320, kScreenWidth, 150);
    }
    
    
    
}
-(void)getgz_cal_birth_product{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    
    [b setObject:gz_todaywt_inde forKey:@"gz_cal_birth_product"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary * b = [returnData objectForKey:@"b"];
        ;
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_cal_birth_product"];
            NSArray *product_list=[gz_air_qua_index objectForKey:@"product_list"];
            if (product_list.count>0) {
                NSString *des=[product_list[0] objectForKey:@"des"];
                NSString *amount=[product_list[0] objectForKey:@"amount"];
                self.productid=[product_list[0] objectForKey:@"id"];
                self.deslab.text=des;
                self.zflab.text=[NSString stringWithFormat:@"资费：%@元/次",amount];
            }
            
        }
       
        
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withCache:YES];
}
-(void)gz_cal_birth_info{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:self.birthday forKey:@"birthday"];
    if (self.username.length>0) {
        [gz_todaywt_inde setObject:self.username forKey:@"user_name"];
    }
    
    [gz_todaywt_inde setObject:self.cityid forKey:@"station_id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_cal_birth_info"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            if (self.bgscr) {
                [self.bgscr removeFromSuperview];
                self.bgscr=nil;
            }
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_cal_birth_info"];
            self.birthdaydic=gz_air_qua_index;
            [self creatpayedview];//已支付
            
        }
        
        
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withCache:YES];
}
-(void)creatpayedview{
    if (self.m_tableview) {
        [self.m_tableview removeFromSuperview];
        self.m_tableview=nil;
    }
    self.m_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight) style:UITableViewStylePlain];
    self.m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_tableview.backgroundColor=[UIColor clearColor];
    self.m_tableview.backgroundView=nil;
    self.m_tableview.autoresizesSubviews = YES;
    self.m_tableview.showsHorizontalScrollIndicator = YES;
    self.m_tableview.showsVerticalScrollIndicator = YES;
    self.m_tableview.delegate = self;
    self.m_tableview.dataSource = self;
    [self.view addSubview:self.m_tableview];
}
#pragma mark -UITableDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return 6;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row==0) {
        return 120;
    }
    return cell.frame.size.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSString *t_str = [NSString stringWithFormat:@"%d_%d", section, row];
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:t_str];
    if (cell != nil)
        [cell removeFromSuperview];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    if (row==0) {
        UIImageView *icoimg=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-60)/2, 5, 60, 60)];
        icoimg.layer.cornerRadius = 30;
        icoimg.layer.masksToBounds = YES;
        UIImage * userImg = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"]];
        if(userImg == nil)
        {
            userImg = [UIImage imageNamed:@"个人图标"];
        }
        icoimg.image=userImg;
        [cell addSubview:icoimg];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 70, kScreenWidth-20, 50)];
        lab.text=[self.birthdaydic objectForKey:@"user_tip"];
        lab.textColor=[UIColor whiteColor];
        lab.numberOfLines=0;
        lab.font=[UIFont systemFontOfSize:14];
        lab.textAlignment=NSTextAlignmentCenter;
        [cell addSubview:lab];
    }
    if (row==1) {
        UIImageView *cellimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
        cellimg.image=[UIImage imageNamed:@"模糊背景"];
        cellimg.userInteractionEnabled=YES;
        [cell addSubview:cellimg];
        
        UIImageView *icoimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
        icoimg.image=[UIImage imageNamed:@"当天天气"];
        [cellimg addSubview:icoimg];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(35, 0, kScreenWidth-20, 30)];
//        lab.text=[self.birthdaydic objectForKey:@"city_name"];
        lab.text=[NSString stringWithFormat:@"%@%@天气情况：",self.time,self.cityname];
        lab.textColor=[UIColor orangeColor];
        lab.font=[UIFont systemFontOfSize:14];
        [cellimg addSubview:lab];
        
        NSString *birstr=[self.birthdaydic objectForKey:@"weather_desc"];
        NSString *rainstr=[self.birthdaydic objectForKey:@"rain"];
        NSString *des=[self.birthdaydic objectForKey:@"wt_tip"];
//        if (birstr.length>0) {
            UIImageView *bimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 20, 20)];
            bimg.image=[UIImage imageNamed:@"生日天气"];
            [cellimg addSubview:bimg];
            UILabel *blab=[[UILabel alloc]initWithFrame:CGRectMake(35, 25, kScreenWidth-20, 30)];
            blab.text=[NSString stringWithFormat:@"天气:  %@",birstr];
            blab.textColor=[UIColor whiteColor];
            blab.font=[UIFont systemFontOfSize:14];
            [cellimg addSubview:blab];
//        }
        
        UIImageView *rimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 60, 20, 20)];
        rimg.image=[UIImage imageNamed:@"生日雨量"];
        [cellimg addSubview:rimg];
        UILabel *rlab=[[UILabel alloc]initWithFrame:CGRectMake(35, 55, kScreenWidth-20, 30)];
        rlab.text=[NSString stringWithFormat:@"雨量:  %@ mm",rainstr];
        rlab.textColor=[UIColor whiteColor];
        rlab.font=[UIFont systemFontOfSize:14];
        [cellimg addSubview:rlab];
        
        
        if (des.length>0) {
            UILabel *deslab=[[UILabel alloc]initWithFrame:CGRectMake(10, 85, kScreenWidth-20, 30)];
            deslab.text=des;
            self.celldeslab=deslab;
            deslab.textColor=[UIColor whiteColor];
            deslab.numberOfLines=0;
            deslab.font=[UIFont systemFontOfSize:14];
            [cellimg addSubview:deslab];
            if (des.length>0) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:des];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                [paragraphStyle setLineSpacing:2];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, des.length)];
                deslab.attributedText = attributedString;
                
            }
            
            float des_h=[deslab labelheight:des withFont:[UIFont systemFontOfSize:14]];
            deslab.frame=CGRectMake(10, 85, kScreenWidth-20, des_h+10);
        }
        CGRect cellFrame = [cell frame];
        cellFrame.size.height = lab.frame.size.height+blab.frame.size.height+rlab.frame.size.height+self.celldeslab.frame.size.height;
        cellimg.frame=CGRectMake(0, 0, kScreenWidth, cellFrame.size.height);
        [cell setFrame:cellFrame];
        
    }
    if (row==2) {
        UIImageView *cellimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 120)];
        cellimg.image=[UIImage imageNamed:@"模糊背景"];
        cellimg.userInteractionEnabled=YES;
        [cell addSubview:cellimg];
        
        UIImageView *birthdayimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        birthdayimg.image=[UIImage imageNamed:@"生日书banner"];
        birthdayimg.userInteractionEnabled=YES;
        [cellimg addSubview:birthdayimg];
        
        NSString *time=[self.time substringFromIndex:5];
        UILabel *timelab=[[UILabel alloc]initWithFrame:CGRectMake(10, 85, 120, 20)];
        timelab.text=time;
        timelab.font=[UIFont systemFontOfSize:14];
        timelab.textColor=[UIColor orangeColor];
        [cell addSubview:timelab];
        
        NSString *str=nil;
         str = [NSString stringWithFormat:@"%@",[[self.birthdaydic objectForKey:@"birth_book"] stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ]];
        UILabel *deslab=[[UILabel alloc]initWithFrame:CGRectMake(10, 105, kScreenWidth-20, 30)];
        deslab.text=[NSString stringWithFormat:@"%@",str];
        deslab.textColor=[UIColor whiteColor];
        deslab.numberOfLines=0;
        deslab.font=[UIFont systemFontOfSize:14];
        [cellimg addSubview:deslab];
        
        if (str.length>0) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:str];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:2];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
            deslab.attributedText = attributedString;
            
        }
        
        float des_h=[deslab labelheight:str withFont:[UIFont systemFontOfSize:14]];
        deslab.frame=CGRectMake(10, 105, kScreenWidth-20, des_h+20);
        CGRect cellFrame = [cell frame];
        cellFrame.size.height = deslab.frame.size.height+105;
        cellimg.frame=CGRectMake(0, 5, kScreenWidth, cellFrame.size.height);
        [cell setFrame:cellFrame];
    }
    if (row==3) {
        UIImageView *cellimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 120)];
        cellimg.image=[UIImage imageNamed:@"模糊背景"];
        cellimg.userInteractionEnabled=YES;
        [cell addSubview:cellimg];
        UIImageView *mrimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        mrimg.image=[UIImage imageNamed:@"历史名人banner"];
        mrimg.userInteractionEnabled=YES;
        [cellimg addSubview:mrimg];
        
        UIImageView *tximg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 90, 50, 59)];
        tximg.image=[UIImage imageNamed:@"名人"];
        [cellimg addSubview:tximg];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(60, 80, kScreenWidth-70, 30)];
        lab.text=@"今日出生的历史名人";
        lab.textColor=[UIColor orangeColor];
        lab.font=[UIFont systemFontOfSize:14];
//        [cellimg addSubview:lab];
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(60, 85, kScreenWidth-70, 60)];
        lab1.text=@"历史星空中，每个人都如流星滑过。但只要仰望，总能发现些许耀眼的星星。";
        lab1.textColor=[UIColor orangeColor];
        lab1.numberOfLines=0;
        lab1.font=[UIFont systemFontOfSize:14];
        [cellimg addSubview:lab1];
        
        NSString *str=nil;
        str = [NSString stringWithFormat:@"%@",[[self.birthdaydic objectForKey:@"birth_cellelibrity"] stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ]];
        UILabel *deslab=[[UILabel alloc]initWithFrame:CGRectMake(10, 140, kScreenWidth-20, 30)];
        deslab.text=[NSString stringWithFormat:@"%@",str];
        deslab.textColor=[UIColor whiteColor];
        deslab.numberOfLines=0;
        deslab.font=[UIFont systemFontOfSize:14];
        [cellimg addSubview:deslab];
        if (str.length>0) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:str];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:2];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
            deslab.attributedText = attributedString;
            
        }
        float des_h=[deslab labelheight:str withFont:[UIFont systemFontOfSize:14]];
        deslab.frame=CGRectMake(10, 140, kScreenWidth-20, des_h+20);
        CGRect cellFrame = [cell frame];
        cellFrame.size.height = deslab.frame.size.height+140;
        cellimg.frame=CGRectMake(0, 5, kScreenWidth, cellFrame.size.height);
        [cell setFrame:cellFrame];
        
    }
    if (row==4) {
        NSDictionary *constellation=[self.birthdaydic objectForKey:@"constellation"];
        NSString *img_url=nil;
        NSString *content=nil;
        NSString *pair=nil;
        NSString *symbolize=nil;
        NSString *name=nil;
        if (constellation) {
            img_url=[constellation objectForKey:@"img_url"];
            content=[constellation objectForKey:@"content"];
            pair=[constellation objectForKey:@"pair"];
            symbolize=[constellation objectForKey:@"symbolize"];
            name=[constellation objectForKey:@"name"];
        }
        
        UIImageView *cellimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 120)];
        cellimg.image=[UIImage imageNamed:@"模糊背景"];
        cellimg.userInteractionEnabled=YES;
        [cell addSubview:cellimg];
        UIImageView *mrimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        mrimg.image=[UIImage imageNamed:@"星座banner"];
        mrimg.userInteractionEnabled=YES;
        [cellimg addSubview:mrimg];
        EGOImageView *tximg=[[EGOImageView alloc]initWithFrame:CGRectMake(5, 90, 50, 59)];
        [tximg setImageURL:[ShareFun makeImageUrl:img_url]];
        [cellimg addSubview:tximg];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(60, 80, 50, 25)];
        lab.text=@"星座:";
        lab.textColor=[UIColor orangeColor];
        lab.font=[UIFont systemFontOfSize:14];
        [cellimg addSubview:lab];
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(60, 105, 50, 25)];
        lab1.text=@"象征:";
        lab1.textColor=[UIColor orangeColor];
        lab1.font=[UIFont systemFontOfSize:14];
        [cellimg addSubview:lab1];
        UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(60, 130, 80, 25)];
        lab2.text=@"最佳配对:";
        lab2.textColor=[UIColor orangeColor];
        lab2.font=[UIFont systemFontOfSize:14];
        [cellimg addSubview:lab2];
        
        UILabel *xzlab=[[UILabel alloc]initWithFrame:CGRectMake(100, 80, kScreenWidth-110, 25)];
        xzlab.text=name;
        xzlab.textColor=[UIColor whiteColor];
        xzlab.font=[UIFont systemFontOfSize:14];
        [cellimg addSubview:xzlab];
        UILabel *xzlab1=[[UILabel alloc]initWithFrame:CGRectMake(100, 105, kScreenWidth-110, 25)];
        xzlab1.text=symbolize;
        xzlab1.textColor=[UIColor whiteColor];
        xzlab1.font=[UIFont systemFontOfSize:14];
        [cellimg addSubview:xzlab1];
        UILabel *xzlab2=[[UILabel alloc]initWithFrame:CGRectMake(125, 130, kScreenWidth-110, 25)];
        xzlab2.text=pair;
        xzlab2.textColor=[UIColor whiteColor];
        xzlab2.font=[UIFont systemFontOfSize:14];
        [cellimg addSubview:xzlab2];
        
        NSString *str=nil;
        str = [NSString stringWithFormat:@"%@",[content stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ]];
        UILabel *deslab=[[UILabel alloc]initWithFrame:CGRectMake(10, 160, kScreenWidth-20, 30)];
        deslab.text=[NSString stringWithFormat:@"%@",str];
        deslab.textColor=[UIColor whiteColor];
        deslab.numberOfLines=0;
        deslab.font=[UIFont systemFontOfSize:14];
        [cellimg addSubview:deslab];
        if (str.length>0) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:str];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:2];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
            deslab.attributedText = attributedString;
            
        }
        float des_h=[deslab labelheight:str withFont:[UIFont systemFontOfSize:14]];
        deslab.frame=CGRectMake(10, 160, kScreenWidth-20, des_h+20);
        CGRect cellFrame = [cell frame];
        cellFrame.size.height = deslab.frame.size.height+160;
        cellimg.frame=CGRectMake(0, 5, kScreenWidth, cellFrame.size.height);
        [cell setFrame:cellFrame];
    }
    if (row==5) {
        NSString *thip=[self.birthdaydic objectForKey:@"service_tip"];
        UIImageView *cellimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 120)];
        cellimg.image=[UIImage imageNamed:@"模糊背景"];
        cellimg.userInteractionEnabled=YES;
        [cell addSubview:cellimg];
        CGRect cellFrame = [cell frame];

        NSString *str=nil;
        if (thip.length>0) {
             str = [NSString stringWithFormat:@"%@",[thip stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ]];
        }
       
        UILabel *deslab=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, kScreenWidth-10, 30)];
        deslab.text=str;
        deslab.textColor=[UIColor orangeColor];
        deslab.numberOfLines=0;
        deslab.font=[UIFont systemFontOfSize:18];
        [cellimg addSubview:deslab];
        float des_h=[deslab labelheight:str withFont:[UIFont systemFontOfSize:18]];
        deslab.frame=CGRectMake(10, 10, kScreenWidth-20, des_h+20);
        
        UIButton *gobtn=[[UIButton alloc]initWithFrame:CGRectMake(50, deslab.frame.size.height+25, 80, 30)];
        [gobtn setTitle:@"分享" forState:UIControlStateNormal];
        [gobtn setBackgroundImage:[UIImage imageNamed:@"分享常态"] forState:UIControlStateNormal];
        [gobtn setBackgroundImage:[UIImage imageNamed:@"分享点击态"] forState:UIControlStateHighlighted];
        [gobtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [cellimg addSubview:gobtn];
        gobtn.titleLabel.font=[UIFont systemFontOfSize:15];
        
        UIButton *finbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-130, deslab.frame.size.height+25, 80, 30)];
        [finbtn setTitle:@"继续查询" forState:UIControlStateNormal];
        [finbtn setBackgroundImage:[UIImage imageNamed:@"分享常态"] forState:UIControlStateNormal];
        [finbtn setBackgroundImage:[UIImage imageNamed:@"分享点击态"] forState:UIControlStateHighlighted];
        [finbtn addTarget:self action:@selector(find) forControlEvents:UIControlEventTouchUpInside];
        finbtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [cellimg addSubview:finbtn];
        
        cellFrame.size.height =deslab.frame.size.height+70;
        cellimg.frame=CGRectMake(0, 10, kScreenWidth, cellFrame.size.height);
        [cell setFrame:cellFrame];
    }
    return cell;
}
-(void)find{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)wxzfAction{
    self.wximg.image=[UIImage imageNamed:@"支付方式选择选中态"];
    self.zfbimg.image=[UIImage imageNamed:@"支付方式选择未选中态"];
    self.aliimg.image=[UIImage imageNamed:@"支付宝支付未选中"];
    self.wechaimg.image=[UIImage imageNamed:@"微信支付"];
    self.paytype=@"1";
}
-(void)zfbzfAction{
    self.paytype=@"3";
    self.wximg.image=[UIImage imageNamed:@"支付方式选择未选中态"];
    self.zfbimg.image=[UIImage imageNamed:@"支付方式选择选中态"];
     self.wechaimg.image=[UIImage imageNamed:@"微信支付未选中"];
    self.aliimg.image=[UIImage imageNamed:@"支付宝支付选中"];
}
-(void)tjAction{
    if (!self.userid.length>0) {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"您还未登录，请先登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        al.tag=555;
        [al show];
        return;
    }
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [b setObject:gz_todaywt_inde forKey:@"gz_cal_birth_order_pay"];
    [gz_todaywt_inde setObject:self.birthday forKey:@"birthday"];
    if (self.userid.length>0) {
         [gz_todaywt_inde setObject:self.userid forKey:@"user_id"];
    }
    if (!self.paytype.length>0) {
        self.paytype=@"1";
    }
   [gz_todaywt_inde setObject:self.paytype forKey:@"pay_type"];
    [gz_todaywt_inde setObject:self.cityid forKey:@"station_id"];
    if (self.productid.length>0) {
        [gz_todaywt_inde setObject:self.productid forKey:@"product_id"];
    }
    NSString *sign=[self getMd5_32Bit_String:[NSString stringWithFormat:@"%@-%@-%@-%@-%@",self.birthday,self.userid,self.cityid,self.paytype,self.productid]];
    [gz_todaywt_inde setObject:sign forKey:@"sign"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *gz_family_private=[b objectForKey:@"gz_cal_birth_order_pay"];
        NSString *result=[gz_family_private objectForKey:@"result"];
        NSString *total_amount=[gz_family_private objectForKey:@"total_amount"];
        //        NSString *re_sign=[gz_family_private objectForKey:@"re_sign"];
        NSString *order_detail_id=[gz_family_private objectForKey:@"order_detail_id"];
        NSString *product_name=[gz_family_private objectForKey:@"product_detail"];
        NSString *pay_type=[gz_family_private objectForKey:@"pay_type"];
        
        if ([result isEqualToString:@"1"]) {
            if ([pay_type isEqualToString:@"1"]) {
                NSDictionary *weixin_pay_info=[gz_family_private objectForKey:@"weixin_pay_info"];
                NSString *appID=[weixin_pay_info objectForKey:@"appid"];
                NSString *key=[weixin_pay_info objectForKey:@"key"];

                NSString *mch_id=[weixin_pay_info objectForKey:@"mch_id"];
                NSString *notify_url=[weixin_pay_info objectForKey:@"notify_url"];
                NSString *parterid=[ShareFun decryptWithText:key withkey:@"pcs**key"];
                
                int price=total_amount.floatValue*100;
                NSString *pricestr=[NSString stringWithFormat:@"%d",price];
                
                if ([WXApi isWXAppInstalled]) {
                    payRequsestHandler *req = [payRequsestHandler alloc] ;
                    //初始化支付签名对象
                    [req init:appID mch_id:mch_id ordername:product_name orderprice:pricestr notifyurl:notify_url order_detail_id:order_detail_id];
                    //设置密钥
                    [req setKey:parterid];
                    
                    
                    
                    //获取到实际调起微信支付的参数后，在app端调起支付
                    NSMutableDictionary *dict = [req sendPay_demo];
                    
                    if(dict == nil){
                        //错误提示
                        NSString *debug = [req getDebugifo];
                        NSLog(@"%@\n\n",debug);
                        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"下单失败，请重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        al.tag=333;
                        [al show];
                    }else{
                        NSLog(@"%@\n\n",[req getDebugifo]);
                        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
                        
                        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                        
                        //调起微信支付
                        PayReq* req             = [[PayReq alloc] init];
                        req.openID              = [dict objectForKey:@"appid"];
                        req.partnerId           = [dict objectForKey:@"partnerid"];
                        req.prepayId            = [dict objectForKey:@"prepayid"];
                        req.nonceStr            = [dict objectForKey:@"noncestr"];
                        req.timeStamp           = stamp.intValue;
                        req.package             = [dict objectForKey:@"package"];
                        req.sign                = [dict objectForKey:@"sign"];
                        
                        [WXApi sendReq:req];
                    }
                }else{
                    UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"您的设备未安装微信" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    al.tag=222;
                    [al show];
                }
            }
            if ([pay_type isEqualToString:@"3"]) {
                NSDictionary *weixin_pay_info=[gz_family_private objectForKey:@"ali_pay_info"];
                NSString *appID=[weixin_pay_info objectForKey:@"appid"];
                NSString *key=[weixin_pay_info objectForKey:@"key"];
                
                NSString *mch_id=[weixin_pay_info objectForKey:@"mch_id"];
                NSString *notify_url=[weixin_pay_info objectForKey:@"notify_url"];
                NSString *parterid=[ShareFun decryptWithText:key withkey:@"pcs**key"];
                 NSString *it_b_pay=[weixin_pay_info objectForKey:@"it_b_pay"];
                NSString *partner = appID;
                NSString *seller =mch_id;
                NSString *privateKey =parterid;
                
                if ([partner length] == 0 ||
                    [seller length] == 0 ||
                    [privateKey length] == 0)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"知天气提示"
                                                                    message:@"下单失败，请重试"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                /*
                 *生成订单信息及签名
                 */
                //将商品信息赋予AlixPayOrder的成员变量
                Order *order = [[Order alloc] init];
                order.partner = partner;
                order.seller = seller;
                order.tradeNO = order_detail_id; //订单ID（由商家自行制定）
                order.productName = product_name; //商品标题
                order.productDescription =product_name; //商品描述
                order.amount =total_amount; //商品价格
                order.notifyURL = notify_url; //回调URL
                
                order.service = @"mobile.securitypay.pay";
                order.paymentType = @"1";
                order.inputCharset = @"utf-8";
                order.itBPay = it_b_pay;
                order.showUrl = @"m.alipay.com";
                
                //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
                NSString *appScheme = @"ztqNew";
                
                //将商品信息拼接成字符串
                NSString *orderSpec = [order description];
                NSLog(@"orderSpec = %@",orderSpec);
                
                //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
                id<DataSigner> signer = CreateRSADataSigner(privateKey);
                NSString *signedString = [signer signString:orderSpec];
                
                //将签名成功字符串格式化为订单字符串,请严格按照该格式
                NSString *orderString = nil;
                if (signedString != nil) {
                    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                   orderSpec, signedString, @"RSA"];
                    
                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                        
                            NSString *resultStatus=[resultDic objectForKey:@"resultStatus"];
                            if ([resultStatus isEqualToString:@"9000"]) {
                                NSLog(@"支付成功");
                                NSNotification *notification = [NSNotification notificationWithName:@"pay" object:@"success"];
                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                            }else{
                                NSNotification *notification = [NSNotification notificationWithName:@"pay" object:@"fail"];
                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                            }
                            
                        
                    }];
                    
                    
                }
            }
            
                 }
        
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withCache:YES];
}

#pragma mark - 发起支付请求
- (void)WXPayRequest:(NSString *)appId nonceStr:(NSString *)nonceStr package:(NSString *)package partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId timeStamp:(NSString *)timeStamp sign:(NSString *)sign{
    //调起微信支付
    
    PayReq* wxreq             = [[PayReq alloc] init];
    wxreq.openID              = appId;
    wxreq.partnerId           = partnerId;
    wxreq.prepayId            = prepayId;
    wxreq.nonceStr            = nonceStr;
    wxreq.timeStamp           = [timeStamp intValue];
    wxreq.package             = package;
    wxreq.sign                = sign;
    [WXApi sendReq:wxreq];
}

#pragma mark - 通知信息
- (void)getOrderPayResult:(NSNotification *)notification{
    if ([notification.object isEqualToString:@"success"])
    {
//        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        al.tag=111;
//        [al show];
        self.ispay=YES;
        [self gz_cal_birth_info];
    }
    else
    {
//        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"支付失败，请重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        al.tag=444;
//        [al show];
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==111) {
        if (buttonIndex==0) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"birthday" object:nil];
            self.ispay=YES;
            [self gz_cal_birth_info];
            
        }
    }
}
-(void)lgAction{
    LGViewController *lgvc=[[LGViewController alloc]init];
    lgvc.type=@"生日";
    [self.navigationController pushViewController:lgvc animated:YES];
}
-(void)userButAction{
    
}
-(void)leftBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    self.ispay=NO;
    [self getShareContent];
    UIImage *t_shareImage = [self captureScreen];
    if (self.ispay==NO&&self.userid.length<=0) {
        t_shareImage=[ShareFun captureScreen];
    }
    self.shareimg=t_shareImage;
    NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
    [UIImagePNGRepresentation(t_shareImage) writeToFile:shareImagePath atomically:YES];
    ShareSheet * sheet = [[ShareSheet alloc] initDefaultWithTitle:@"分享天气" withDelegate:self];
    [sheet show];

}
-(UIImage *) captureScreen
{
    
    NSMutableArray *images=[[NSMutableArray alloc]init];
//    UIGraphicsBeginImageContext(CGSizeMake(kScreenWidth, 64));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 64), NO, 0.0);
    [self.navigationBarBg.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images addObject:tempImage];
    
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.m_tableview.contentSize, NO, 0.0);
//    UIGraphicsBeginImageContext(self.m_tableview.contentSize);
    {
        CGPoint savedContentOffset =self.m_tableview.contentOffset;
        CGRect savedFrame = self.m_tableview.frame;
        
        self.m_tableview.contentOffset = CGPointZero;
        self.m_tableview.frame = CGRectMake(0, 0, kScreenWidth,self.m_tableview.contentSize.height);
        [self.m_tableview.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.m_tableview.contentOffset = savedContentOffset;
        self.m_tableview.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    if (image) {
        [images addObject:image];
    }
    
    //添加二维码
    UIImage *ewmimg=[UIImage imageNamed:@"指纹二维码.jpg"];
    UIImageView *ewm=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 177)];
    ewm.image=ewmimg;
//    UIGraphicsBeginImageContext(CGSizeMake(kScreenWidth, 177));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 177), NO, 0.0);
    [ewm.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImage1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images addObject:tempImage1];
    
    [self verticalImageFromArray:images];
    UIImage *newimg=[self verticalImageFromArray:images];
    UIImage *img=self.bgimg.image;
//    UIGraphicsBeginImageContext(newimg.size);
    UIGraphicsBeginImageContextWithOptions(newimg.size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, kScreenWidth, newimg.size.height)];
    
    [newimg drawInRect:CGRectMake(0,
                                  0,
                                  kScreenWidth,
                                  newimg.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

-(UIImage *)verticalImageFromArray:(NSArray *)imagesArray
{
    UIImage *unifiedImage = nil;
    CGSize totalImageSize = [self verticalAppendedTotalImageSizeFromImagesArray:imagesArray];
    UIGraphicsBeginImageContextWithOptions(totalImageSize, NO, 0.f);
    
    int imageOffsetFactor = 0;
    for (UIImage *img in imagesArray) {
        [img drawAtPoint:CGPointMake(0, imageOffsetFactor)];
        imageOffsetFactor += img.size.height;
    }
    
    unifiedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return unifiedImage;
}

-(CGSize)verticalAppendedTotalImageSizeFromImagesArray:(NSArray *)imagesArray
{
    CGSize totalSize = CGSizeZero;
    for (UIImage *im in imagesArray) {
        CGSize imSize = [im size];
        totalSize.height += imSize.height;
        // The total width is gonna be always the wider found on the array
        totalSize.width = kScreenWidth;
    }
    return totalSize;
}
//32位MD5加密方式
- (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}
-(void)getShareContent{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:@"BIRTH" forKey:@"keyword"];
    [b setObject:gz_todaywt_inde forKey:@"gz_wt_share"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_wt_share"];
            NSString *sharecontent=[gz_air_qua_index objectForKey:@"share_content"];
            self.sharecontent=sharecontent;
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath
{
    NSString *shareContent = self.sharecontent;
    switch (indexPath)
    {
            
        case 0: {
            weiboVC *t_weibo = [[weiboVC alloc] initWithNibName:@"weiboVC" bundle:nil];
            [t_weibo setShareText:shareContent];
            [t_weibo setShareImage:@"weiboShare.png"];
            [t_weibo setShareType:1];
            [self presentViewController:t_weibo animated:YES completion:nil];
            
            break;
        }
        case 1:{
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //如果有缩略图，则设置缩略图
            [shareObject setShareImage:self.shareimg];
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }];
            
            break;
        }
        case 2: {
            
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //如果有缩略图，则设置缩略图
            [shareObject setShareImage:self.shareimg];
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }];
            break;
        }
        case 3: {
            Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
            
            
            if([messageClass canSendText])
                
            {
                
                MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
                controller.body = shareContent;
                controller.messageComposeDelegate = self;
                
                [self presentViewController:controller animated:YES completion:nil];
                
            }else
            {
                UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"不能发送，该设备不支持短信功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [t_alertView show];
                
            }
            break;
        }
            
            
    }
}
//短信取消
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    //       [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
