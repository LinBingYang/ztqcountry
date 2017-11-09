//
//  AddServerViewController.m
//  ZtqCountry
//
//  Created by Admin on 15/8/20.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "AddServerViewController.h"
#import "UILabel+utils.h"
#import "GRZXViewController.h"
#import "LGViewController.h"
@interface AddServerViewController ()

@end

@implementation AddServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.barHiden=NO;
    self.titleLab.text=@"亲情服务定制";
    self.view.backgroundColor=[UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateview) name:@"myname" object:nil];
    self.bgscro=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight)];
    self.bgscro.showsHorizontalScrollIndicator=NO;
    self.bgscro.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.bgscro];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getcity:) name:@"qqservice" object:nil];
    
    //-----------------键盘-----------------------
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    
    self.tcarrs=[[NSMutableArray alloc]init];
    self.t_btnarr=[[NSMutableArray alloc]init];
    [self creatView];
    [self getgz_family_product];
}
-(void)updateview{
    [self.bgscro removeFromSuperview];
    self.bgscro=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight)];
    self.bgscro.showsHorizontalScrollIndicator=NO;
    self.bgscro.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.bgscro];

    [self creatView];
    [self getgz_family_product];

}
-(void)creatView{

    UIButton *bgbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    [bgbtn addTarget:self action:@selector(hiddkey) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:bgbtn];
    
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    NSString * userNameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"sjusername"];
    UILabel *grlab=[[UILabel alloc]initWithFrame:CGRectMake(20, 15, 150, 20)];
    grlab.text=@"我的个人中心:";
    grlab.font=[UIFont systemFontOfSize:15];
    [self.bgscro addSubview:grlab];
    UIButton *tjbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-135, 10, 120, 30)];
    [tjbtn setTitle:@"登录" forState:UIControlStateNormal];
    self.lgbtn=tjbtn;
    [tjbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮常态"] forState:UIControlStateNormal];
    [tjbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮点击态"] forState:UIControlStateHighlighted];
    [tjbtn addTarget:self action:@selector(lgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:tjbtn];
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(20, 60, 60, 1)];
    line.backgroundColor=[UIColor grayColor];
    [self.bgscro addSubview:line];
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-80, 60, 60, 1)];
    line1.backgroundColor=[UIColor grayColor];
    [self.bgscro addSubview:line1];
    UILabel *tslab=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, 20)];
    tslab.text=@"请先登录再定制亲情服务";
    tslab.font=[UIFont systemFontOfSize:15];
    tslab.textAlignment=NSTextAlignmentCenter;
    tslab.textColor=[UIColor grayColor];
    self.tslab=tslab;
    [self.bgscro addSubview:tslab];
 
//    self.grayimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 80+self.barHeight, kScreenWidth, kScreenHeitht)];
//    self.grayimg.backgroundColor=[UIColor grayColor];
//    self.grayimg.userInteractionEnabled=NO;
//    self.grayimg.alpha=0.3;
//    [self.bgscro addSubview:self.grayimg];
    if (userid.length>0) {
        [tjbtn setTitle:userNameStr forState:UIControlStateNormal];
        tslab.text=@"开始定制亲情服务吧";
//        [self.grayimg removeFromSuperview];
    }
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 80, 150, 30)];
    lab.text=@"对方手机号码:";
    lab.font=[UIFont systemFontOfSize:15];
    [self.bgscro addSubview:lab];
    UIImageView *userimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 110, 200, 25)];
    userimg.image=[UIImage imageNamed:@"亲情服务定制输入框"];
    userimg.userInteractionEnabled=YES;
    [self.bgscro addSubview:userimg];
    self.phonetf=[[UITextField alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-55, 25)];
    self.phonetf.placeholder=@"请输入对方手机号";
    if (self.phone.length>0) {
        self.phonetf.text=self.phone;
    }
    self.phonetf.clearButtonMode = UITextFieldViewModeAlways;
    self.phonetf.delegate=self;
    self.phonetf.keyboardType = UIKeyboardTypeNumberPad;
    self.phonetf.returnKeyType=UIReturnKeyDone;
    [userimg addSubview:self.phonetf];
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(20, 135, 250, 30)];
    lab1.text=@"注:我们将向该手机发送气象服务短信";
    lab1.textColor=[UIColor grayColor];
    lab1.font=[UIFont systemFontOfSize:13];
    [self.bgscro addSubview:lab1];
    UIButton *address=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-70, 110, 55, 30)];
    [address setBackgroundImage:[UIImage imageNamed:@"通讯录 城市选择按钮常态"] forState:UIControlStateNormal];
    [address setBackgroundImage:[UIImage imageNamed:@"通讯录 城市选择按钮点击态"] forState:UIControlStateHighlighted];
    [address setTitle:@"通讯录" forState:UIControlStateNormal];
    address.titleLabel.font=[UIFont systemFontOfSize:12];
    [address addTarget:self action:@selector(addressAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:address];
    UILabel *citylab=[[UILabel alloc]initWithFrame:CGRectMake(20, 165, 150, 30)];
    citylab.text=@"对方所在的城市:";
    citylab.font=[UIFont systemFontOfSize:15];
    [self.bgscro addSubview:citylab];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(20, 195, 200, 25)];
    img.image=[UIImage imageNamed:@"亲情服务定制输入框"];
    img.userInteractionEnabled=YES;
    [self.bgscro addSubview:img];
    self.citytf=[[UITextField alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-55, 25)];
    self.citytf.placeholder=@"请选择";
    
    if (self.areaid.length>0) {
        self.cityid=self.areaid;
        NSString *cityname=[self readXMLwithcityid:self.areaid];
        self.citytf.text=cityname;
    }
    self.citytf.clearButtonMode = UITextFieldViewModeAlways;
    self.citytf.delegate=self;
    self.citytf.returnKeyType=UIReturnKeyDone;
    [img addSubview:self.citytf];
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(20, 225, 250, 25)];
    lab2.text=@"注:我们将发送这个城市的天气信息";
    lab2.textColor=[UIColor grayColor];
    lab2.font=[UIFont systemFontOfSize:13];
    [self.bgscro addSubview:lab2];
    UIButton *citybtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-70, 195, 55, 30)];
    [citybtn setBackgroundImage:[UIImage imageNamed:@"通讯录 城市选择按钮常态"] forState:UIControlStateNormal];
    [citybtn setBackgroundImage:[UIImage imageNamed:@"通讯录 城市选择按钮点击态"] forState:UIControlStateHighlighted];
    [citybtn setTitle:@"城市选择" forState:UIControlStateNormal];
    citybtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [citybtn addTarget:self action:@selector(cityAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:citybtn];
    
    UILabel *nicklab=[[UILabel alloc]initWithFrame:CGRectMake(20, 250, 150, 30)];
    nicklab.text=@"昵称设置:";
    nicklab.font=[UIFont systemFontOfSize:15];
    [self.bgscro addSubview:nicklab];
    UILabel *sjrlab=[[UILabel alloc]initWithFrame:CGRectMake(20, 280, 60, 30)];
    sjrlab.text=@"收信人:";
    sjrlab.font=[UIFont systemFontOfSize:15];
    [self.bgscro addSubview:sjrlab];
    UIImageView *nickimg=[[UIImageView alloc]initWithFrame:CGRectMake(90, 285, 200, 25)];
    nickimg.image=[UIImage imageNamed:@"亲情服务定制输入框"];
    nickimg.userInteractionEnabled=YES;
    [self.bgscro addSubview:nickimg];
    self.sjrtf=[[UITextField alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-55, 25)];
    self.sjrtf.placeholder=@"请输入收信人昵称";
    if (self.name.length>0) {
        self.sjrtf.text=self.name;
    }
    self.sjrtf.returnKeyType=UIReturnKeyDone;
    self.sjrtf.clearButtonMode = UITextFieldViewModeAlways;
    self.sjrtf.delegate=self;
    [nickimg addSubview:self.sjrtf];
    
    self.contentlab=[[UILabel alloc]initWithFrame:CGRectMake(20, 315, kScreenWidth-40, 60)];
    self.contentlab.text=@"";
    self.contentlab.font=[UIFont systemFontOfSize:15];
    self.contentlab.numberOfLines=0;
//    [self.bgscro addSubview:self.contentlab];
    
    UILabel *fjrlab=[[UILabel alloc]initWithFrame:CGRectMake(20, 315, 60, 30)];
    fjrlab.text=@"发信人:";
    fjrlab.font=[UIFont systemFontOfSize:15];
    [self.bgscro addSubview:fjrlab];
    UIImageView *fjnickimg=[[UIImageView alloc]initWithFrame:CGRectMake(90, 315, 200, 25)];
    fjnickimg.image=[UIImage imageNamed:@"亲情服务定制输入框"];
    fjnickimg.userInteractionEnabled=YES;
    [self.bgscro addSubview:fjnickimg];
    self.fjrtf=[[UITextField alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-55, 25)];
    self.fjrtf.placeholder=@"请输入发信人昵称";
    if (self.send_name.length>0) {
        self.fjrtf.text=self.send_name;
    }
    self.fjrtf.returnKeyType=UIReturnKeyDone;
    self.fjrtf.clearButtonMode = UITextFieldViewModeAlways;
    self.fjrtf.delegate=self;
    [fjnickimg addSubview:self.fjrtf];
    UILabel *zhulab=[[UILabel alloc]initWithFrame:CGRectMake(20, 345, 200, 20)];
    zhulab.text=@"注:昵称字符长度为1-6个字符";
    zhulab.font=[UIFont systemFontOfSize:13];
    zhulab.textColor=[UIColor grayColor];
    [self.bgscro addSubview:zhulab];
    
    UILabel *tclab=[[UILabel alloc]initWithFrame:CGRectMake(20, 380, 100, 30)];
    tclab.text=@"套餐设置:";
    tclab.font=[UIFont systemFontOfSize:15];
    [self.bgscro addSubview:tclab];
    UILabel *zflab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-100, 380, 100, 30)];
    zflab.text=@"资费:3元/月";
    self.zflab=zflab;
    zflab.font=[UIFont systemFontOfSize:13];
    zflab.textColor=[UIColor grayColor];
    [self.bgscro addSubview:zflab];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==self.citytf) {
        [self cityAction];
        return NO;
    }
    return YES;
}
-(void)getgz_family_product{
   
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [b setObject:gz_todaywt_inde forKey:@"gz_family_product"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *gz_family_private=[b objectForKey:@"gz_family_product"];
        self.tcarrs=[gz_family_private objectForKey:@"product_list"];
        float h;
        double allheight;
        for (int i=0; i<self.tcarrs.count; i++) {
            UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 410+70*i, kScreenWidth-40, 60)];
            bgimg.image=[UIImage imageNamed:@"套餐设置框"];
            bgimg.userInteractionEnabled=YES;
            [self.bgscro addSubview:bgimg];
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(40, 2, 200, 20)];
            lab.text=[self.tcarrs[i] objectForKey:@"name"];
            lab.font=[UIFont systemFontOfSize:13];
            [bgimg addSubview:lab];
            UILabel *contlab=[[UILabel alloc]initWithFrame:CGRectMake(40, 20, kScreenWidth-90, 40)];
            contlab.text=[self.tcarrs[i] objectForKey:@"des"];
            contlab.numberOfLines=0;
            contlab.font=[UIFont systemFontOfSize:13];
            [bgimg addSubview:contlab];
            h=[contlab labelheight:[self.tcarrs[i] objectForKey:@"des"] withFont:[UIFont systemFontOfSize:13]]+10;
            contlab.frame=CGRectMake(40, 20, kScreenWidth-90, h);
            bgimg.frame=CGRectMake(20, 410+(h+30)*i, kScreenWidth-40, h+20);
            UIButton *xzbtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 15, 15)];
            [xzbtn setBackgroundImage:[UIImage imageNamed:@"套餐设置未选中态"] forState:UIControlStateNormal];
            [xzbtn addTarget:self action:@selector(xzAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgimg addSubview:xzbtn];
            if (i==0) {
                [xzbtn setBackgroundImage:[UIImage imageNamed:@"套餐设置选中态"] forState:UIControlStateNormal];
            }
            xzbtn.tag=i;
            [self.t_btnarr addObject:xzbtn];
            allheight=allheight+(h+30)*i;
        }
        if (self.t_btnarr.count>0) {
            [self xzAction:self.t_btnarr[0]];
        }
        
        UILabel *zlab=[[UILabel alloc]initWithFrame:CGRectMake(20, allheight+410, kScreenWidth-40, 40)];
        zlab.text=@"注:套餐只可选择一项，若您想为同一亲友定制两份套餐，请在完成支付后再次选择。";
        zlab.font=[UIFont systemFontOfSize:13];
        zlab.numberOfLines=0;
        zlab.textColor=[UIColor grayColor];
        [self.bgscro addSubview:zlab];
        UIButton *tjbtn=[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-220)/2, allheight+50+410, 220, 30)];
        [tjbtn setTitle:@"保存并提交" forState:UIControlStateNormal];
        [tjbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮常态"] forState:UIControlStateNormal];
        [tjbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮点击态"] forState:UIControlStateHighlighted];
        [tjbtn addTarget:self action:@selector(tjAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bgscro addSubview:tjbtn];
        self.bgscro.contentSize=CGSizeMake(kScreenWidth, allheight+100+410);
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)xzAction:(UIButton *)sender{

    UIButton *t_btn = sender;
    [t_btn setBackgroundImage:[UIImage imageNamed:@"选套餐设置选中态"] forState:UIControlStateNormal];
    for (int i=0; i<self.t_btnarr.count; i++) {
        UIButton *btn=self.t_btnarr[i];
        if (btn.tag!=t_btn.tag) {
            [btn setBackgroundImage:[UIImage imageNamed:@"套餐设置未选中态"] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"套餐设置选中态"] forState:UIControlStateNormal];
        }
        
    }
    NSString *zf=[self.tcarrs[t_btn.tag] objectForKey:@"amount"];
    self.zf=zf;
    self.zflab.text=[NSString stringWithFormat:@"资费: %@元/月",zf];
    self.tcid=[self.tcarrs[t_btn.tag] objectForKey:@"id"];
}
-(void)tjAction{
//    PayViewController *payvc=[[PayViewController alloc]init];
//    payvc.pirce=self.zf;
//    [self.navigationController pushViewController:payvc animated:YES];
    if (self.phonetf.text.length<10&&self.phonetf.placeholder.length<10) {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }else if (!self.sjrtf.text.length>0||self.sjrtf.text.length>6) {
       
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"请输入正确的收件人昵称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
        
    }else
        if (!self.fjrtf.text.length>0||self.fjrtf.text.length>6) {
       
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"请输入正确的发件人昵称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
        
    }else{
        [self getaddORxgwithtype:self.type];
    }
}
-(void)lgAction{
     NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    if (userid.length>0) {
//        GRZXViewController *grvc=[[GRZXViewController alloc]init];
//        [self.navigationController pushViewController:grvc animated:YES];
    }else{
        LGViewController *lgvc=[[LGViewController alloc]init];
        lgvc.type=@"亲情";
        [self.navigationController pushViewController:lgvc animated:YES];
    }
}
-(void)cityAction{
    SelectCityViewController *city=[[SelectCityViewController alloc]init];
    city.type=@"亲情";
    [city setDataSource: m_treeNodeProvince withCitys:m_treeNodeAllCity];
    [city setDelegate:self];
    [self.navigationController pushViewController:city animated:YES];
}
-(void)getcity:(NSNotification *)object{
    NSDictionary *dic=object.object;
    NSString *cityid=[dic objectForKey:@"ID"];
    NSString *city=[dic objectForKey:@"city"];
    self.citytf.text=city;
    self.cityid=cityid;
}
-(void)getaddORxgwithtype:(NSString *)type{
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if (userid.length>0) {
        [gz_todaywt_inde setObject:userid forKey:@"user_id"];
    }else{
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"请先登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }
    [gz_todaywt_inde setObject:self.phonetf.text forKey:@"other_phone"];
    [gz_todaywt_inde setObject:self.cityid forKey:@"other_cityid"];
    [gz_todaywt_inde setObject:self.fjrtf.text forKey:@"my_name"];
    [gz_todaywt_inde setObject:self.sjrtf.text forKey:@"other_name"];
    [gz_todaywt_inde setObject:self.tcid forKey:@"product_id"];
    [gz_todaywt_inde setObject:type forKey:@"act_type"];
    if ([type isEqualToString:@"1"]) {
         [gz_todaywt_inde setObject:self.orderid forKey:@"order_id"];
    }
    [b setObject:gz_todaywt_inde forKey:@"gz_family_order_act"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *gz_family_private=[b objectForKey:@"gz_family_order_act"];
        NSString *result=[gz_family_private objectForKey:@"result"];
        NSString *amount=[gz_family_private objectForKey:@"amount"];
        NSString *order_id=[gz_family_private objectForKey:@"order_id"];
        NSString *other_phone=[gz_family_private objectForKey:@"other_phone"];
        NSString *other_cityid=[gz_family_private objectForKey:@"other_cityid"];
        NSString *other_name=[gz_family_private objectForKey:@"other_name"];
        NSString *my_name=[gz_family_private objectForKey:@"my_name"];
        NSString *product_id=[gz_family_private objectForKey:@"product_id"];
        NSString *user_id=[gz_family_private objectForKey:@"user_id"];
        NSString *sign=[NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@",other_phone,other_cityid,my_name,other_name,product_id,user_id];
        
        if ([result isEqualToString:@"1"]) {
            PayViewController *payvc=[[PayViewController alloc]init];
            payvc.pirce=amount;
            payvc.sign=[self getMd5_32Bit_String:sign];
            payvc.orderid=order_id;
            payvc.userid=user_id;
            [self.navigationController pushViewController:payvc animated:YES];
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.phonetf resignFirstResponder];
    [self.citytf resignFirstResponder];
    [self.fjrtf resignFirstResponder];
    [self.sjrtf resignFirstResponder];
    return YES;
}
-(void)hiddkey{
    [self.phonetf resignFirstResponder];
    [self.citytf resignFirstResponder];
    [self.fjrtf resignFirstResponder];
    [self.sjrtf resignFirstResponder];
}
-(void)addressAction{
    if ([[UIDevice currentDevice].systemVersion doubleValue]<=8.0) {
        picker = [[ABPeoplePickerNavigationController alloc]init];
        picker.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeitht-48);
        picker.peoplePickerDelegate = self;
        picker.delegate=self;
        [self.view addSubview:picker.view];
        
    }else{
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:nil];
    }

}
#pragma mark -- ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *num = (__bridge NSString*)value;
        NSString *num1=[num stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self.phonetf.text=num1;
    }];
}
//#pragma mark UINavigationControllerDelegate methods
////隐藏“取消”按钮
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    UIView *custom = [[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0f,0.0f,0.0f)];
//    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:custom];
//    [viewController.navigationItem setRightBarButtonItem:btn animated:NO];
//   
//}

#pragma mark - peoplePickerDelegate Methods
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
   
        //获取該Label下的电话值
        NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone,0);
    NSString *num = personPhone;
    NSString *num1=[num stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.phonetf.text=num1;
     [peoplePicker.view removeFromSuperview];
    
    return NO;
}


//“取消”按钮的委托响应方法
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    //assigning control back to the main controller
    
    if ([[UIDevice currentDevice].systemVersion doubleValue]<=8.0) {
       [peoplePicker.view removeFromSuperview];
        
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}
-(NSString *)readXMLwithcityid:(NSString *)areaid{
    m_allCity=m_treeNodeAllCity;
    NSString *cityname=nil;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        t_node_child = [t_node.children objectAtIndex:0];
        NSString *t_name = t_node_child.leafvalue;
        if ([areaid isEqualToString:t_name])
        {
            //----------------------------------------------------
            t_node_child = [t_node.children objectAtIndex:5];
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:2];
            NSString *name = t_node_child1.leafvalue;
            cityname=name;
        }
    }
    
    return cityname;
}
#pragma mark keyboardWillhe
- (void)changeShareContentHeight:(float)t_height withDuration:(float)t_dration
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:t_dration];
    [UIView setAnimationDelegate:self];
    self.bgscro.contentOffset=CGPointMake(0, 200);
    [UIView commitAnimations];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self changeShareContentHeight:keyboardRect.size.height withDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    self.bgscro.contentOffset=CGPointMake(0, self.barHeight);
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
