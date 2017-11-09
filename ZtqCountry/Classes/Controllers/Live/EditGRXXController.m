//
//  EditGRXXController.m
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/5.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "EditGRXXController.h"
#import "EGOImageView.h"
#import "MgrPersonController.h"
#import "CustomSheet.h"
@interface EditGRXXController ()<UITextFieldDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong) NSDictionary *GRXXdatas;
@property(nonatomic,strong) UITextField *nickname,*bandingTextfield,*addressTextfield;
@property(nonatomic,strong) EGOImageView *tximg;
@property(nonatomic,copy) NSString *sex;
@property(nonatomic,strong) UIScrollView *backView;
@property(nonatomic,strong) UIButton *selectSexBtn;
@property(nonatomic,strong) UIImage *SelectImage;
@property(nonatomic,strong) CustomSheet *acsheetview;
@end

@implementation EditGRXXController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    self.navigationBarBg.userInteractionEnabled = YES;
    //    _navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:27 green:92 blue:189 alpha:1];
    self.navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:self.navigationBarBg];
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [_navigationBarBg addSubview:leftimg];
    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    [_leftBut addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    _rightBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-70,24, 60, 30)];
    UILabel *titleb= [[UILabel alloc] initWithFrame:CGRectMake(60, 12+place, 200, 20)];
    titleb.textAlignment = NSTextAlignmentCenter;
    self.titleLab=titleb;
    titleb.font = [UIFont fontWithName:kBaseFont size:20];
    titleb.backgroundColor = [UIColor clearColor];
    titleb.textColor = [UIColor whiteColor];
    titleb.text=@"个人信息";
    [self.navigationBarBg addSubview:titleb];
    self.view.backgroundColor=[UIColor whiteColor];
    self.sex=@"1";
    [self loaddatas];
  
}
-(void)loaddatas
{
    if (self.backView) {
        [self.backView removeFromSuperview];
    }
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [userCenterImage setObject:userid forKey:@"user_id"];
    [t_b setObject:userCenterImage forKey:@"gz_syn_user_info"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            
         NSDictionary *syn_user_info=[t_b objectForKey:@"gz_syn_user_info"];
          NSString *platform_type=[syn_user_info objectForKey:@"platform_type"];
            NSString *head_url=[syn_user_info objectForKey:@"head_url"];
              NSString *nick_name1=[syn_user_info objectForKey:@"nick_name"];
            self.GRXXdatas=syn_user_info;
            self.backView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
            self.backView.contentSize=CGSizeMake(0, kScreenHeitht+60);
            self.backView.backgroundColor=[UIColor whiteColor];
//            [self.view addSubview:self.backView];
            [self.view insertSubview:self.backView atIndex:0];
           
            
            if ([platform_type isEqual:@"4"]) {//本地登录
                if(head_url)
                {
//                    NSURL *url=[NSURL URLWithString:head_url];
//                    NSData *mydata = [NSData dataWithContentsOfURL:url];
//                    if (mydata) {
//                        [[NSUserDefaults standardUserDefaults]setObject:mydata forKey:@"currendIco"];
//                    }
                    [[NSUserDefaults standardUserDefaults] setObject:head_url forKey:@"currendIcoUrl"];
                }
                if (nick_name1) {
                    [[NSUserDefaults standardUserDefaults] setObject:nick_name1 forKey:@"sjusername"];
                }
                [self makeViewLocal];
            }else{      //第三方登录
//                 [self makeViewLocal];
                
                [self makeViewThird];
            }
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"myname" object:nil];

        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } withCache:YES];
    

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)makeViewThird
{
    NSString *nick_name=[[NSUserDefaults standardUserDefaults] objectForKey:@"sjusername"];
    NSString *head_url=self.GRXXdatas[@"head_url"];
//        NSString *nick_name1=self.GRXXdatas[@"nick_name"];
    NSString *sexdata=self.GRXXdatas[@"sex"];
      NSString *mobileStr=self.GRXXdatas[@"mobile"];
      NSString *addressStr=self.GRXXdatas[@"address"];
//    NSString *platform_user_id=self.GRXXdatas[@"platform_user_id"];
    CGFloat marginY=10;
    UIButton *txBtn=[[UIButton alloc] init];
    txBtn.size=CGSizeMake(80, 80);
    txBtn.centerX=kScreenWidth*0.5;
    txBtn.y=80;
    txBtn.enabled=NO;
    txBtn.adjustsImageWhenDisabled=NO;
    txBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.backView addSubview:txBtn];
    
    EGOImageView *tximg=[[EGOImageView alloc]initWithFrame:txBtn.bounds];
    if(![head_url isEqualToString:@""]&&head_url!=nil){
        tximg.imageURL=[NSURL URLWithString:head_url];
        
//        NSData *headData= [[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"];
//        tximg.image=[UIImage imageWithData:headData];
    }else{
        tximg.image=[UIImage imageNamed:@"知天气头像.png"];
    }
    //tximg.contentMode=UIViewContentModeScaleAspectFill;
//    tximg.image=[UIImage imageNamed:@"知天气头像.png"];
    tximg.layer.cornerRadius=tximg.width*0.5;
    tximg.layer.masksToBounds=YES;
    //    UIImage *imageCircle=[self drawCirleImage:[UIImage imageNamed:@"知天气头像.png"]];
    //    tximg.image=imageCircle;
    tximg.userInteractionEnabled=NO;
    [txBtn addSubview:tximg];
    
    UITextField *nickname=[[UITextField alloc] init];
    nickname.size=CGSizeMake(200, 30);
    nickname.y=CGRectGetMaxY(txBtn.frame)+10;
    nickname.centerX=kScreenWidth*0.5;
    nickname.text=nick_name;
    nickname.textAlignment=NSTextAlignmentCenter;
    nickname.enabled=NO;
    [self.backView addSubview:nickname];
    
    UIView *hengxian1=[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(txBtn.frame)+50, kScreenWidth-20, 1)];
    hengxian1.backgroundColor=[UIColor colorHelpWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.3];
    [self.backView addSubview:hengxian1];
    
    UILabel *banding=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(hengxian1.frame)+marginY, 100, 30)];
    banding.text=@"绑定手机号";
    banding.textAlignment=NSTextAlignmentLeft;
    [self.backView addSubview:banding];
    
    UITextField *bandingTextfield=[[UITextField alloc] initWithFrame:CGRectMake(kScreenWidth-180, CGRectGetMaxY(hengxian1.frame)+marginY, 150, 30)];
    bandingTextfield.delegate=self;
    bandingTextfield.returnKeyType=UIReturnKeyDone;
    self.bandingTextfield=bandingTextfield;
    [bandingTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if(![mobileStr isEqualToString:@""]&&mobileStr!=nil)
    {
        bandingTextfield.text=mobileStr;
    }
    bandingTextfield.placeholder=@"填写有效手机号";
    bandingTextfield.textAlignment=NSTextAlignmentRight;
    [self.backView addSubview:bandingTextfield];
    
    UIView *hengxian2=[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(banding.frame)+marginY, kScreenWidth-20, 1)];
    hengxian2.backgroundColor=[UIColor colorHelpWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.3];
    [self.backView addSubview:hengxian2];
    
    UILabel *sex=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(hengxian2.frame)+marginY, 50, 30)];
    sex.text=@"性别";
    sex.textAlignment=NSTextAlignmentLeft;
    [self.backView addSubview:sex];
    
    UIButton *manBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-120, CGRectGetMaxY(hengxian2.frame)+marginY,50,30)];
    [manBtn setTitle:@"男" forState:UIControlStateNormal];
    [manBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [manBtn setImage:[UIImage imageNamed:@"性别选择常态.png"] forState:UIControlStateNormal];
    [manBtn setImage:[UIImage imageNamed:@"性别选择点击.png"] forState:UIControlStateDisabled];
    
    manBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    manBtn.adjustsImageWhenDisabled=NO;
    manBtn.tag=1;
    [self.backView addSubview:manBtn];
    
    UIButton *womanBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-70, CGRectGetMaxY(hengxian2.frame)+marginY,50,30)];
    [womanBtn setTitle:@"女" forState:UIControlStateNormal];
    [womanBtn setImage:[UIImage imageNamed:@"性别选择常态.png"] forState:UIControlStateNormal];
    [womanBtn setImage:[UIImage imageNamed:@"性别选择点击.png"] forState:UIControlStateDisabled];
    [womanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    womanBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.backView addSubview:womanBtn];
    womanBtn.tag=2;
    womanBtn.adjustsImageWhenDisabled=NO;
    if ([sexdata isEqualToString:@"1"]||[sexdata isEqualToString:@""]) {
        manBtn.enabled=NO;
        self.selectSexBtn=manBtn;
        self.sex=@"1";
    }else
    {
    
        womanBtn.enabled=NO;
        self.selectSexBtn=womanBtn;
        self.sex=@"2";
    }
    
    [womanBtn addTarget:self action:@selector(sexClick:) forControlEvents:UIControlEventTouchUpInside];
    [manBtn addTarget:self action:@selector(sexClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *hengxian3=[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(sex.frame)+marginY, kScreenWidth-20, 1)];
    hengxian3.backgroundColor=[UIColor colorHelpWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.3];
    [self.backView addSubview:hengxian3];
    
    UILabel *address=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(hengxian3.frame)+marginY, 50, 30)];
    address.text=@"地址";
    address.textAlignment=NSTextAlignmentLeft;
    [self.backView addSubview:address];
    UITextField *addressTextfield=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(address.frame)+10, CGRectGetMaxY(hengxian3.frame)+marginY, kScreenWidth-CGRectGetMaxX(address.frame)-40, 30)];
    if ([addressStr isEqualToString:@""]||addressStr==nil) {
//        addressTextfield.text=[setting sharedSetting].currentCity;
        NSNumber *dwswitch=[[NSUserDefaults standardUserDefaults] objectForKey:@"dwswitch"];
        BOOL switchBool=dwswitch.boolValue;
        if (switchBool==YES) { //定位是关的
            addressTextfield.text=[setting sharedSetting].currentCity;
            
        }else{  //定位是开的
            NSDictionary * cityInfo = [[setting sharedSetting].citys objectAtIndex:0];
            NSString * cityID = [cityInfo objectForKey:@"ID"];
            addressTextfield.text=[self readXMLwith:cityID];
            
        }
        
    }else{
        addressTextfield.text=addressStr;
    }
    [addressTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    addressTextfield.delegate=self;
    addressTextfield.returnKeyType=UIReturnKeyDone;
    addressTextfield.tag=111;
    self.addressTextfield=addressTextfield;
    addressTextfield.textAlignment=NSTextAlignmentRight;
    
    [self.backView addSubview:addressTextfield];
    UIView *hengxian4=[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(address.frame)+marginY, kScreenWidth-20, 1)];
    hengxian4.backgroundColor=[UIColor colorHelpWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.3];
    [self.backView addSubview:hengxian4];
    
    UIButton *logbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(hengxian4.frame)+20,300,35)];
    //	[logbtn setBackgroundColor:[UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1]];
    [logbtn.layer setMasksToBounds:YES];
    [logbtn.layer setCornerRadius:2];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮常态.png"] forState:UIControlStateNormal];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮点击态.png"] forState:UIControlStateHighlighted];
    [logbtn setTitle:@"提交" forState:UIControlStateNormal];
    [logbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logbtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [logbtn addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:logbtn];

}
-(void)sexClick:(UIButton *)btn
{
    btn.enabled=NO;
    self.selectSexBtn.enabled=YES;
    self.selectSexBtn=btn;
    if (btn.tag==1) {
            self.sex=@"1";
    }else if(btn.tag==2){
            self.sex=@"2";
    }
}
-(void)makeViewLocal
{
    NSString *head_url=self.GRXXdatas[@"head_url"];
    NSString *nick_name=self.GRXXdatas[@"nick_name"];
     NSString *sexdata=self.GRXXdatas[@"sex"];
    NSString *mobileStr=self.GRXXdatas[@"platform_user_id"];
      NSString *addressStr=self.GRXXdatas[@"address"];
    CGFloat marginY=10;
    
    UIButton *txBtn=[[UIButton alloc] init];
    txBtn.size=CGSizeMake(80, 80);
    txBtn.centerX=kScreenWidth*0.5;
    txBtn.y=80;
    txBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [txBtn addTarget:self action:@selector(txbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:txBtn];
    
    UIButton *txEditBtn=[[UIButton alloc] init];
    txEditBtn.size=CGSizeMake(25, 25);
    txEditBtn.centerX=CGRectGetMaxX(txBtn.frame)-10;
    txEditBtn.centerY=CGRectGetMinY(txBtn.frame)+10;
    txEditBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [txEditBtn setBackgroundImage:[UIImage imageNamed:@"个人中心编辑.png"] forState:UIControlStateNormal];
    [txEditBtn addTarget:self action:@selector(txbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:txEditBtn];
    
    EGOImageView *tximg=[[EGOImageView alloc]initWithFrame:txBtn.bounds];
       tximg.contentMode = UIViewContentModeScaleAspectFill;
     if(![head_url isEqualToString:@""]&&head_url!=nil){
        tximg.imageURL=[NSURL URLWithString:head_url];
    }else{
        tximg.image=[UIImage imageNamed:@"知天气头像.png"];
    }
    //tximg.contentMode=UIViewContentModeScaleAspectFill;
    tximg.layer.cornerRadius=tximg.width*0.5;
    tximg.layer.masksToBounds=YES;
//    UIImage *imageCircle=[self drawCirleImage:[UIImage imageNamed:@"知天气头像.png"]];
//    tximg.image=imageCircle;
    tximg.userInteractionEnabled=NO;
    self.tximg=tximg;
    [txBtn addSubview:tximg];
    
    UITextField *nickname=[[UITextField alloc] init];
    nickname.size=CGSizeMake(130, 30);
    nickname.tag=102;
    nickname.returnKeyType=UIReturnKeyDone;
    nickname.delegate=self;
    nickname.text=nick_name;
    [nickname addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

//    nickname.backgroundColor=[UIColor redColor];
//     [nickname sizeToFit];
    nickname.y=CGRectGetMaxY(txBtn.frame)+10;
    nickname.centerX=kScreenWidth*0.5;
    nickname.textAlignment=NSTextAlignmentCenter;
    self.nickname=nickname;
    [self.backView addSubview:nickname];

    UIButton *nickEditBtn=[[UIButton alloc] init];
    nickEditBtn.size=CGSizeMake(25, 25);
    nickEditBtn.x=CGRectGetMaxX(nickname.frame);
    nickEditBtn.y=nickname.y;
    [nickEditBtn setBackgroundImage:[UIImage imageNamed:@"个人中心编辑.png"] forState:UIControlStateNormal];
    [nickEditBtn addTarget:self action:@selector(nickEditBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:nickEditBtn];
    
    UIView *hengxian1=[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(txBtn.frame)+50, kScreenWidth-20, 1)];
    hengxian1.backgroundColor=[UIColor colorHelpWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.3];
    [self.backView addSubview:hengxian1];

    UILabel *banding=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(hengxian1.frame)+marginY, 100, 30)];
    banding.text=@"绑定手机号";
    banding.textAlignment=NSTextAlignmentLeft;
    [self.backView addSubview:banding];
    
    UITextField *bandingTextfield=[[UITextField alloc] initWithFrame:CGRectMake(kScreenWidth-180, CGRectGetMaxY(hengxian1.frame)+marginY, 150, 30)];
    self.bandingTextfield=bandingTextfield;
    bandingTextfield.tag=101;
        bandingTextfield.returnKeyType=UIReturnKeyDone;
    bandingTextfield.delegate=self;
    [bandingTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    bandingTextfield.text=mobileStr;
    bandingTextfield.textAlignment=NSTextAlignmentRight;
    [self.backView addSubview:bandingTextfield];
    
    UIView *hengxian2=[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(banding.frame)+marginY, kScreenWidth-20, 1)];
    hengxian2.backgroundColor=[UIColor colorHelpWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.3];
    [self.backView addSubview:hengxian2];
    
    UILabel *sex=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(hengxian2.frame)+marginY, 50, 30)];
    sex.text=@"性别";
    sex.textAlignment=NSTextAlignmentLeft;
    [self.backView addSubview:sex];
    
    
    UIButton *manBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-150, CGRectGetMaxY(hengxian2.frame)+marginY,60,30)];
    [manBtn setTitle:@"男" forState:UIControlStateNormal];
    [manBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [manBtn setImage:[UIImage imageNamed:@"性别选择常态.png"] forState:UIControlStateNormal];
    [manBtn setImage:[UIImage imageNamed:@"性别选择点击.png"] forState:UIControlStateDisabled];
    manBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    manBtn.adjustsImageWhenDisabled=NO;
    manBtn.tag=1;
    [self.backView addSubview:manBtn];
    
    UIButton *womanBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-90, CGRectGetMaxY(hengxian2.frame)+marginY,60,30)];
    [womanBtn setTitle:@"女" forState:UIControlStateNormal];
    [womanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    womanBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [womanBtn setImage:[UIImage imageNamed:@"性别选择常态.png"] forState:UIControlStateNormal];
    [womanBtn setImage:[UIImage imageNamed:@"性别选择点击.png"] forState:UIControlStateDisabled];
    [self.backView addSubview:womanBtn];
    womanBtn.tag=2;
    womanBtn.adjustsImageWhenDisabled=NO;
    if ([sexdata isEqualToString:@"1"]||[sexdata isEqualToString:@""]) {
        manBtn.enabled=NO;
        self.selectSexBtn=manBtn;
        self.sex=@"1";
    }else
    {
        
        womanBtn.enabled=NO;
        self.selectSexBtn=womanBtn;
        self.sex=@"2";
    }
    [womanBtn addTarget:self action:@selector(sexClick:) forControlEvents:UIControlEventTouchUpInside];
    [manBtn addTarget:self action:@selector(sexClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *hengxian3=[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(sex.frame)+marginY, kScreenWidth-20, 1)];
    hengxian3.backgroundColor=[UIColor colorHelpWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.3];
    [self.backView addSubview:hengxian3];
    
    UILabel *address=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(hengxian3.frame)+marginY, 50, 30)];
    address.text=@"地址";
    address.textAlignment=NSTextAlignmentLeft;
  
    [self.backView addSubview:address];
    UITextField *addressTextfield=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(address.frame)+10, CGRectGetMaxY(hengxian3.frame)+marginY, kScreenWidth-CGRectGetMaxX(address.frame)-40, 30)];
    if ([addressStr isEqualToString:@""]||addressStr==nil) {
            NSNumber *dwswitch=[[NSUserDefaults standardUserDefaults] objectForKey:@"dwswitch"];
            BOOL switchBool=dwswitch.boolValue;
        if (switchBool==YES) { //定位是关的
            addressTextfield.text=[setting sharedSetting].currentCity;
            
        }else{  //定位是开的
            NSDictionary * cityInfo = [[setting sharedSetting].citys objectAtIndex:0];
            NSString * cityID = [cityInfo objectForKey:@"ID"];
           addressTextfield.text=[self readXMLwith:cityID];
            
        }
       
    }else{
        addressTextfield.text=addressStr;
    }
      [addressTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    addressTextfield.textAlignment=NSTextAlignmentRight;
    addressTextfield.delegate=self;
    addressTextfield.tag=111;
    addressTextfield.returnKeyType=UIReturnKeyDone;
      self.addressTextfield=addressTextfield;
    [self.backView addSubview:addressTextfield];
    UIView *hengxian4=[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(address.frame)+marginY, kScreenWidth-20, 1)];
    hengxian4.backgroundColor=[UIColor colorHelpWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.3];
    [self.backView addSubview:hengxian4];
    
    UIButton *logbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(hengxian4.frame)+20,300,35)];
    //	[logbtn setBackgroundColor:[UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1]];
    [logbtn.layer setMasksToBounds:YES];
    [logbtn.layer setCornerRadius:2];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮常态.png"] forState:UIControlStateNormal];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"提交登录按钮点击态.png"] forState:UIControlStateHighlighted];
    [logbtn setTitle:@"提交" forState:UIControlStateNormal];
    [logbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logbtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [logbtn addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:logbtn];
    
    UIButton *uppassbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-110, CGRectGetMaxY(logbtn.frame)+20,100, 30)];
    [uppassbtn setTitle:@"管理密码>>" forState:UIControlStateNormal];
    uppassbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [uppassbtn setTitleColor:[UIColor colorHelpWithRed:28 green:132 blue:213 alpha:1] forState:UIControlStateNormal];
    [uppassbtn addTarget:self action:@selector(ButtonClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:uppassbtn];
    
}
-(NSString *)readXMLwith:(NSString *)cityid{
    m_allCity=m_treeNodeAllCity;
    NSString *city=[setting sharedSetting].currentCity;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:0];
        t_node_child = [t_node.children objectAtIndex:0];
        NSString *cityID = t_node_child.leafvalue;
        if ([cityID isEqualToString:cityid])
        {
            
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:6];
            NSString *cityname = t_node_child1.leafvalue;
            city=cityname;
        }
    }
    
    return city;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==111) {  //编辑地址的时候  滑动界面
        [UIView animateWithDuration:0.4 animations:^{
            self.backView.contentOffset=CGPointMake(0, 60);
        }];
    }

}
-(void)nickEditBtn
{
    [self.nickname becomeFirstResponder];

}
- (void)textFieldDidChange:(UITextField *)textField
{
  
    if (textField.tag==101) {
        if (textField.text.length >= 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
//    if (textField.tag==102) {
//        if (textField.text.length >= 6) {
//            textField.text = [textField.text substringToIndex:6];
//        }
//    }
        if (textField.tag==102) {
            NSString *tobeString=textField.text;
            NSString *lang =self.textInputMode.primaryLanguage;
            if ([lang isEqualToString:@"zh-Hans"]) {
                UITextRange *selectrange=[textField markedTextRange];
                if (!selectrange) {
                    if (tobeString.length>=6) {
                        textField.text=[tobeString substringToIndex:6];
                    }
                }
            }else
            {
                if (tobeString.length >=6) {
                    textField.text =[tobeString substringToIndex:6];
                }
            
            }
        }
    if (textField.tag==111) {
        NSString *tobeString=textField.text;
        NSString *lang =self.textInputMode.primaryLanguage;
        if ([lang isEqualToString:@"zh-Hans"]) {
            UITextRange *selectrange=[textField markedTextRange];
            if (!selectrange) {
                if (tobeString.length>=20) {
                    textField.text=[tobeString substringToIndex:20];
                }
            }
        }else
        {
            if (tobeString.length >=20) {
                textField.text =[tobeString substringToIndex:20];
            }
            
        }
    }

}

#pragma mark 昵称编辑结束
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==self.nickname){
        NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
        NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
        [t_h setObject:[setting sharedSetting].app forKey:@"p"];
        [userCenterImage setObject:userid forKey:@"user_id"];
        [userCenterImage setObject:self.nickname.text forKey:@"nick_name"];
        [t_b setObject:userCenterImage forKey:@"gz_syn_user_nick"];
        [t_dic setObject:t_h forKey:@"h"];
        [t_dic setObject:t_b forKey:@"b"];
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
            // NSLog(@"%@",returnData);
            NSDictionary *t_b = [returnData objectForKey:@"b"];
            
            if (t_b != nil)
            {
                
                NSDictionary *nick_name=[t_b objectForKey:@"gz_syn_user_nick"];
                NSString *result=[nick_name objectForKey:@"result"];
                if ([result isEqualToString:@"1"]) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"昵称已经存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        } withFailure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            
        } withCache:YES];
        
    }
  

    
}
-(void)ButtonClick1{
    
    MgrPersonController *man=[[MgrPersonController alloc] init];
    man.user_info=self.GRXXdatas;
    [self.navigationController pushViewController:man animated:YES];
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)txbtnClick  //头像编辑
{
    [self.nickname resignFirstResponder];
    [self.bandingTextfield resignFirstResponder];
    [self.addressTextfield resignFirstResponder];
    self.acsheetview=[[CustomSheet alloc]initWithupbtn:@"拍照" Withdownbtn:@"相册" WithCancelbtn:@"取消" withDelegate:self];
    [self.acsheetview show];
  
}
-(void)SheetClickWithIndexPath:(NSInteger)indexPath{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    if (indexPath==1) {
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"此设备不支持拍照功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
    }
    if (indexPath==2) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    if (indexPath!=3) {
        if([UIImagePickerController isSourceTypeAvailable:picker.sourceType])
        {
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
    
}
#pragma mark -UIImagePickerControllerDelegate
//点击相册中的图片 货照相机照完后点击use  后触发的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
    [self dismissViewControllerAnimated:YES completion:nil];
    if(image)
    {
        self.tximg.image=image;
        self.SelectImage=image;
    }
    
}


-(void)ButtonClick //提交
{
    //手机号绑定
    if ([self.bandingTextfield.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"绑定手机号不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    if (self.bandingTextfield.text.length<11) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入11位的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    if ([self.addressTextfield.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"地址不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
        NSString *platform_type=self.GRXXdatas[@"platform_type"];
      [userCenterImage setObject:userid forKey:@"user_id"];
    if ([platform_type isEqualToString:@"4"]) {
            //本地
        if ([self.nickname.text isEqualToString:@""]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"昵称不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        [userCenterImage setObject:self.nickname.text forKey:@"nick_name"];
        [userCenterImage setObject:self.sex forKey:@"sex"];
        [userCenterImage setObject:self.addressTextfield.text forKey:@"address"];
        [userCenterImage setObject:self.bandingTextfield.text forKey:@"mobile"];
        [t_b setObject:userCenterImage forKey:@"gz_syn_user_info_upd"];
        [t_dic setObject:t_h forKey:@"h"];
        [t_dic setObject:t_b forKey:@"b"];
        NSData *jsonData=[NSJSONSerialization dataWithJSONObject:t_dic options:0 error:nil];
        NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *p=[NSMutableDictionary dictionary];
        [p setObject:jsonStr forKey:@"p"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] init];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.responseSerializer.acceptableContentTypes  =[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript" ,@"text/plain" , nil];
        [manager POST:URL_SERVER parameters:p constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (self.SelectImage) {
                 UIImage *img = [self imageCompressForWidth:self.SelectImage targetWidth:kScreenWidth];//压缩图片
                NSData *imageData =UIImageJPEGRepresentation(img,1.0);
                [formData appendPartWithFileData:imageData name:@"file" fileName:@"temp.jpg" mimeType:@"application/octet-stream"];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *t_b = [responseObject objectForKey:@"b"];
            
            if (t_b != nil)
            {
                NSDictionary *syn_user_info_upd=[t_b objectForKey:@"gz_syn_user_info_upd"];
                NSString *result=syn_user_info_upd[@"result"];
                if ([result isEqualToString:@"1"]) {
                    //修改成功
                    [self loaddatas];
     
                    
                }else{
                    //失败
                    NSString *result_msg=syn_user_info_upd[@"result_msg"];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:result_msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    
                }
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];

    }else
    {   //第三方
    
        [userCenterImage setObject:self.sex forKey:@"sex"];
        [userCenterImage setObject:self.addressTextfield.text forKey:@"address"];
        [userCenterImage setObject:self.bandingTextfield.text forKey:@"mobile"];
        [t_b setObject:userCenterImage forKey:@"gz_syn_user_info_upd"];
        [t_dic setObject:t_h forKey:@"h"];
        [t_dic setObject:t_b forKey:@"b"];
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
            // NSLog(@"%@",returnData);
            NSDictionary *t_b = [returnData objectForKey:@"b"];
           
            if (t_b != nil)
            {
                NSDictionary *syn_user_info_upd=[t_b objectForKey:@"gz_syn_user_info_upd"];
                NSString *result=syn_user_info_upd[@"result"];
                if ([result isEqualToString:@"1"]) {
                        //修改成功
                   [self loaddatas];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"myname" object:nil];
                    
                }else{
                    //失败
                    NSString *result_msg=syn_user_info_upd[@"result_msg"];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:result_msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                
                }
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        } withFailure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            
        } withCache:YES];

    }
    

    
}
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder];//关闭键盘
    [UIView animateWithDuration:0.4 animations:^{
        self.backView.contentOffset=CGPointMake(0, 0);
    }];
    return YES;
}
@end
