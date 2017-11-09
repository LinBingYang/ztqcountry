//
//  WRPayViewController.m
//  ZtqCountry
//
//  Created by Admin on 16/1/14.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "WRPayViewController.h"
#import "payRequsestHandler.h"
@interface WRPayViewController ()
@property(strong,nonatomic)NSString *productid;
@end

@implementation WRPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"pay" object:nil];
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
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 12+place, 220, 20)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor whiteColor];
    [_navigationBarBg addSubview:_titleLab];
    _titleLab.text=@"开通服务";
    self.names=[[NSMutableArray alloc]init];
    self.values=[[NSMutableArray alloc]init];
    self.totals=[[NSMutableArray alloc]init];
    
    
    [self getmonthlist];
    
}
-(void)getmonthlist{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:@"4" forKey:@"product_type"];
    [b setObject:gz_todaywt_inde forKey:@"gz_product"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *gz=[b objectForKey:@"gz_product"];
        NSArray *product_list=[gz objectForKey:@"product_list"];
        if (product_list.count>0) {
            NSString *amount=[product_list[0] objectForKey:@"amount"];
            self.pirce=amount;
            self.productid=[product_list[0] objectForKey:@"id"];
            self.months=[product_list[0] objectForKey:@"set_meal"];
            for (int i=0; i<self.months.count; i++) {
                NSString *month_name=[self.months[i] objectForKey:@"month_name"];
                NSString *month_key=[self.months[i] objectForKey:@"month_key"];
                NSString *total_amount=[self.months[i] objectForKey:@"total_amount"];
                [self.names addObject:month_name];
                [self.values addObject:month_key];
                [self.totals addObject:total_amount];
            }
        }
       
        [self creatview];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)creatview{
    UIButton *bgbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht)];
    [bgbtn addTarget:self action:@selector(bgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgbtn];
   
    
    UILabel *datelab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10+self.barHeight, 200, 30)];
    datelab.text=@"服务期限设置 :";
    datelab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:datelab];
    self.monlist=[[PayMonthList alloc]initWithFrame:CGRectMake(20, 50+self.barHeight, 150, 30)];
    self.monlist.delegate=self;
    //    self.monlist.button.titleLabel.font=[UIFont systemFontOfSize:14];
    self.monlist.button.contentMode=UIViewContentModeLeft;
    [self.view addSubview:self.monlist];
    if (self.names.count>0) {
        [self.monlist.button setTitle:self.names[0] forState:UIControlStateNormal];
    }
    
    [self.monlist setList:self.names];

    UILabel *alllab=[[UILabel alloc]initWithFrame:CGRectMake(20, 90+self.barHeight, 200, 30)];
    
    if (self.totals.count>0) {
        alllab.text=[NSString stringWithFormat:@"资费:  %@元",self.totals[0]];
    }else
    alllab.text=[NSString stringWithFormat:@"资费:  %@元",self.pirce];
    self.alllab=alllab;
    alllab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:alllab];
//    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(20, 110+self.barHeight, kScreenWidth-40, 1)];
//    line.backgroundColor=[UIColor blackColor];
//    [self.view addSubview:line];
    
    UILabel *zflab=[[UILabel alloc]initWithFrame:CGRectMake(20, 125+self.barHeight, 200, 30)];
    zflab.text=@"选择支付方式 :";
    zflab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:zflab];
    
    
    UIImageView *xzimg=[[UIImageView alloc]initWithFrame:CGRectMake(30, 170+self.barHeight, 17, 17)];
    xzimg.image=[UIImage imageNamed:@"支付方式选择选中态"];
    self.wximg=xzimg;
    xzimg.userInteractionEnabled=YES;
    [self.view addSubview:xzimg];
    UIImageView *wximg=[[UIImageView alloc]initWithFrame:CGRectMake(55, 165+self.barHeight, 100, 30)];
    wximg.image=[UIImage imageNamed:@"微信支付"];
    self.wechaimg=wximg;
    wximg.userInteractionEnabled=YES;
    [self.view addSubview:wximg];
    
    UIButton *wxzf=[[UIButton alloc]initWithFrame:CGRectMake(30, 165+self.barHeight, 100, 40)];
    [wxzf addTarget:self action:@selector(wxzfAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wxzf];
    self.paytype=@"1";
    UIImageView *xzimg1=[[UIImageView alloc]initWithFrame:CGRectMake(175, 170+self.barHeight, 17, 17)];
    xzimg1.image=[UIImage imageNamed:@"支付方式选择未选中态"];
    self.zfbimg=xzimg1;
    xzimg1.userInteractionEnabled=YES;
    [self.view addSubview:xzimg1];
    UIImageView *zfbimg=[[UIImageView alloc]initWithFrame:CGRectMake(200, 165+self.barHeight, 100, 30)];
    zfbimg.image=[UIImage imageNamed:@"支付宝支付未选中"];
    self.aliimg=zfbimg;
    zfbimg.userInteractionEnabled=YES;
    [self.view addSubview:zfbimg];
    
    UIButton *zfbzf=[[UIButton alloc]initWithFrame:CGRectMake(165, 165+self.barHeight, 100, 40)];
    [zfbzf addTarget:self action:@selector(zfbzfAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zfbzf];
    
    UIButton *tjbtn=[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-220)/2, 225+self.barHeight, 220, 30)];
    [tjbtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [tjbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮常态"] forState:UIControlStateNormal];
    [tjbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮点击态"] forState:UIControlStateHighlighted];
    [tjbtn addTarget:self action:@selector(tjAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tjbtn];
//    [self sumAction];
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
   
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [b setObject:gz_todaywt_inde forKey:@"gz_wr_order_pay"];
    if (self.orderid.length>0) {
        [gz_todaywt_inde setObject:self.orderid forKey:@"order_id"];
    }
    
    [gz_todaywt_inde setObject:self.userid forKey:@"user_id"];
    if (!self.month.length>0) {
        self.month=self.values[0];
    }
    NSString *sign=[NSString stringWithFormat:@"%@-%@-%@-%@",self.userid,self.month,self.paytype,self.productid];
    NSString *md5sign=[self getMd5_32Bit_String:sign];
    [gz_todaywt_inde setObject:self.productid forKey:@"product_id"];
    [gz_todaywt_inde setObject:self.month forKey:@"month_key"];
    [gz_todaywt_inde setObject:self.type forKey:@"type"];
    [gz_todaywt_inde setObject:self.paytype forKey:@"pay_type"];
    [gz_todaywt_inde setObject:md5sign forKey:@"sign"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *gz_family_private=[b objectForKey:@"gz_wr_order_pay"];
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
                order.amount =self.pirce; //商品价格
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
        NSLog(@"failure");
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wrrefresh" object:nil];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:NO];
    }
    else
    {
//        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"支付失败，请重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [al show];
        
    }
}

-(void)monthlistdidSelect:(PayMonthList *)list withIndex:(NSInteger)index{
    [self.monlist.button setTitle:self.names[index] forState:UIControlStateNormal];
    NSString *m=self.values[index];
    self.month=m;
    NSString *total_amount=self.totals[index];
     self.alllab.text=[NSString stringWithFormat:@"资费:  %@元",total_amount];
}

-(void)bgAction{
    if (self.monlist) {
        [self.monlist setShowList:NO];
    }
}
-(void)leftBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==111) {
        if (buttonIndex==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wrrefresh" object:nil];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:NO];
        }
    }
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
