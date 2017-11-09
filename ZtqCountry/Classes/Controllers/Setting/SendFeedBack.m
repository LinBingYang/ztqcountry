//
//  SendFeedBack.m
//  ModelTest1.0
//
//  Created by 星群 吴 on 12-3-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SendFeedBack.h"
//#import "NetWorkCenter.h"
#import "Alert.h"
#import "UILabel+utils.h"
#import "LGViewController.h"
//#import "QXXZBViewController.h"
@interface SendFeedBack (PrivateMethods)<UITableViewDelegate,UITableViewDataSource>

- (void) createHeaderBar:(UIView *) view;
- (void) inputContent:(UIView *) view;

@end

@implementation SendFeedBack
@synthesize contentTV,contactTF;
@synthesize topIV,backBut,sendBut,topTitle;
@synthesize contentLabel;
@synthesize feedBackNULLStr;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
	feedBackNULLStr = @"请输入反馈内容";
    self.view.backgroundColor = [UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    self.barHeight = 44+ place;
    UIImageView * navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    navigationBarBg.userInteractionEnabled = YES;
//    navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1];
    navigationBarBg.image=[UIImage imageNamed:@"导航栏"];
    [self.view addSubview:navigationBarBg];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(15, 7+place, 30, 30)];
    [leftBut setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [leftBut setImage:[UIImage imageNamed:@"返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(cancelbtn:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBg addSubview:leftBut];
    
//    _rightBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-55, 7+place, 50, 30)];
//    [_rightBut addTarget:self action:@selector(sendbtn) forControlEvents:UIControlEventTouchUpInside];
//    [_rightBut setTitle:@"提交" forState:UIControlStateNormal];
//    _rightBut.titleLabel.font=[UIFont systemFontOfSize:15];
//    [_rightBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_rightBut setBackgroundImage:[UIImage imageNamed:@"提交框常态"] forState:UIControlStateNormal];
//    [_rightBut setBackgroundImage:[UIImage imageNamed:@"提交框二态"] forState:UIControlStateHighlighted];
//    [navigationBarBg addSubview:_rightBut];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, self.view.width-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"意见反馈";
    [navigationBarBg addSubview:titleLab];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//#ifdef __IPHONE_5_0
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (version >= 5.0) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    }
//#endif
    
    self.bgscrol=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight)];
    self.bgscrol.showsHorizontalScrollIndicator=NO;
    self.bgscrol.showsVerticalScrollIndicator=NO;
    self.bgscrol.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht);
    [self.view addSubview:self.bgscrol];
    
    //	[t_btn release];
//	[self inputContent:self.bgscrol];
	
}


////返回按钮事件
//- (void)backButtonEvent:(id) sender{
//	[self.navigationController popViewControllerAnimated:YES];
//}
-(NSArray *)datas
{
    if (_datas==nil) {
        _datas=[NSArray array];
    }
    return _datas;
}
//发送反馈事件
- (void)sendbtn{
	
	NSString *contactStr = [[contactTF text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *contentStr = [[contentTV text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *phone=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserphone"];
    if (phone&&![phone isEqualToString:@""]) {
        contactStr=phone;
    }else
    {
        if (self.mobileStr) {
            contactStr=self.mobileStr;
        }
    }
   	NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
    if (userid.length<=0) {
        [ShareFun alertNotice:@"知天气提示" withMSG:@"尊敬的用户，先请登录客户端。" cancleButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }
    if (contactStr.length<=0) {
        [ShareFun alertNotice:@"知天气提示" withMSG:@"尊敬的用户，请输入手机号码再发表建议" cancleButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }
    if ([ShareFun isMobile:contactStr]==NO) {
        [ShareFun alertNotice:@"知天气提示" withMSG:@"尊敬的用户，请输入正确的手机号码再发表建议" cancleButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }
    if (contentStr == nil || [contentStr length] <= 0)
    {
        [ShareFun alertNotice:@"知天气提示" withMSG:feedBackNULLStr cancleButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }

    
    //	if (contactStr == nil || [contactStr length] == 0)
    //	{
    //		[ShareFun alertNotice:@"知天气" withMSG:inputNULLStr cancleButtonTitle:@"确定" otherButtonTitle:nil];
    //		return;
    //	}
    
	[MBProgressHUD showHUDAddedTo:self.view animated:NO];

	NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *sugg = [NSMutableDictionary dictionaryWithCapacity:4];
     self.type=@"好评";
	[t_h setObject:[setting sharedSetting].app forKey:@"p"];
	
	[sugg setObject:contentStr forKey:@"msg"];
//	if (contactStr != nil && [contactStr length] != 0) {
//		if ([contactStr rangeOfString:@"@"].length == 0)
//			[sugg setObject:contactStr forKey:@"phone"];
//		else
//			[sugg setObject:contactStr forKey:@"email"];
//	}
    if (userid.length>0) {
         [sugg setObject:userid forKey:@"user_id"];
    }
    if (contactStr.length>0) {
         [sugg setObject:contactStr forKey:@"mobile"];
        [sugg setObject:self.is_bd forKey:@"is_bd"];
    }
    /*if (self.type.length>0) {
          [sugg setObject:self.type forKey:@"type"];
    }*/
  
    [t_b setObject:sugg forKey:@"gz_suggest"];
	[t_dic setObject:t_h forKey:@"h"];
	[t_dic setObject:t_b forKey:@"b"];
	
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        NSDictionary *t_b = [returnData objectForKey:@"b"];
		if (t_b != nil)
		{
            
            NSDictionary *t_b = [returnData objectForKey:@"b"];
            if (t_b != nil)
            {
                NSDictionary *dic = [t_b objectForKey:@"gz_suggest"];
                NSString *result=[dic objectForKey:@"result"];
                if ([result isEqualToString:@"1"])
                {
                     [self getyjdatas];
                    [ShareFun alertNotice:@"知天气" withMSG:@"感谢您的宝贵意见，我们将继续努力为您提供更专业的产品" cancleButtonTitle:@"确定" otherButtonTitle:nil];
                    //                        Alert *alert=[[Alert alloc]initWithcontetnt:@"已收入，感谢您的宝贵意见~"];
                    //                        [alert show];
//                    [self.navigationController popViewControllerAnimated:NO];
                    contentTV.text=@"";
                    self.bglabel.hidden=NO;
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                    
                }
            }
        }
        else
        {
            [ShareFun alertNotice:@"知天气" withMSG:@"反馈失败，请重新尝试" cancleButtonTitle:@"确定" otherButtonTitle:nil];
            //                Alert *alert=[[Alert alloc]initWithcontetnt:@"反馈失败，请重新尝试"];
            //                [alert show];
            [self.navigationController popViewControllerAnimated:NO];
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
        
        
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } withCache:YES];
    [self closeKeyBoard];
    //	[[ZYNetworkHelper shareZYNetworkHelper] requestDataFromURL:URL_SERVER withParams:t_dic withHelperDelegate:self withFlag:1];
}

-(void)cancelbtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) inputContent:(UIView *) view{
    if (self.bgscrol) {
        for (UIView *subview in self.bgscrol.subviews) {
            [subview removeFromSuperview];
        }
    }
   
    UIButton *t_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0+20+44, self.view.width, kScreenHeitht)];
    [t_btn addTarget:self action:@selector(closeKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscrol addSubview:t_btn];
    
	//提示输入的内容
    int y=0;
    if (kSystemVersionMore7) {
        y=20;
    }
//    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 100, kScreenWidth-10, 120)];
//    bgimg.image=[UIImage imageNamed:@"意见反馈白框"];
//    bgimg.userInteractionEnabled=YES;
//    [self.bgscrol addSubview:bgimg];
//    self.marr=[[NSMutableArray alloc]init];
//    self.type=@"好评";
//    NSArray *arr=[[NSArray alloc]initWithObjects:@"好评",@"中评默认",@"差评默认", nil];
//    NSArray *namearr=[[NSArray alloc]initWithObjects:@"好",@"不错",@"差", nil];
//    for (int i=0; i<arr.count; i++) {
//        UIButton *tbtn=[[UIButton alloc]initWithFrame:CGRectMake(45+90*i, 15, 45, 45)];
//        tbtn.tag=i;
//        [tbtn setBackgroundImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
//        [bgimg addSubview:tbtn];
//        [tbtn addTarget:self action:@selector(tbtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(50+90*i, 70, 40, 30)];
//        lab.text=namearr[i];
//        lab.textAlignment=NSTextAlignmentCenter;
//        lab.font=[UIFont systemFontOfSize:15];
//        [bgimg addSubview:lab];
//        [self.marr addObject:tbtn];
//        
//    }
    
    UIImageView *textimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 100, kScreenWidth-10, 130)];
    textimg.image=[UIImage imageNamed:@"意见反馈白框"];
    textimg.userInteractionEnabled=YES;
    [self.bgscrol addSubview:textimg];
	//内容框
	contentTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, textimg.frame.size.width - 20, 110)];
	[contentTV setBackgroundColor:[UIColor whiteColor]];
	[contentTV setFont:[UIFont fontWithName:@"Helvetica" size:15]];
//	contentTV.layer.cornerRadius = 6;
//    contentTV.layer.borderWidth=1.0;
//    contentTV.layer.borderColor=[[UIColor grayColor]CGColor];
//	contentTV.layer.masksToBounds = YES;
    contentTV.returnKeyType=UIReturnKeyDone;
    contentTV.delegate=self;
    contentTV.hidden=NO;
	//[contentTV becomeFirstResponder];
	[textimg addSubview:contentTV];

	
    self.bglabel=[[UILabel alloc]initWithFrame:CGRectMake(1, 1, 300, 30)];
    [self.bglabel setBackgroundColor:[UIColor clearColor]];
    self.bglabel.text=@"有话对小知说:";
    self.str=self.bglabel.text;
    [self.bglabel setTextColor:[UIColor blackColor]];
    self.bglabel.enabled=NO;
    [self.bglabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [contentTV addSubview:self.bglabel];
    
    UIImageView *lximg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 55, kScreenWidth-10, 35)];
    lximg.image=[UIImage imageNamed:@"邮箱手机号框"];
    lximg.userInteractionEnabled=YES;
    [self.bgscrol addSubview:lximg];

	//联系方式
	contactTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, lximg.frame.size.width - 20, 35)];
	//[contactTF setBackgroundColor:[UIColor clearColor]];
	[contactTF setFont:[UIFont fontWithName:@"Helvetica" size:15]];
//	contactTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    contactTF.textAlignment=NSTextAlignmentCenter;
    contactTF.textColor=[UIColor blackColor];
	contactTF.placeholder = @"请绑定手机号码";
    contactTF.delegate=self;
    contactTF.returnKeyType=UIReturnKeyDone;
    [contactTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
	[lximg addSubview:contactTF];
    
//    UIImageView *ncimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kScreenWidth-90, 35)];
//    ncimg.image=[UIImage imageNamed:@"意见昵称框"];
//    ncimg.userInteractionEnabled=YES;
//    [self.bgscrol addSubview:ncimg];
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
    NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjusername"];
    nickTF = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-90- 20, 35)];
    [nickTF setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    nickTF.textAlignment=NSTextAlignmentCenter;
    nickTF.textColor=[UIColor blackColor];
    [nickTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    if (username.length>0) {
        nickTF.placeholder=username;
    }else
    nickTF.placeholder = @"你还没有登录";
    nickTF.returnKeyType=UIReturnKeyDone;
    nickTF.delegate=self;
    nickTF.enabled=NO;
    [self.bgscrol addSubview:nickTF];
    if (!userid.length>0) {
      
        UIButton *lgbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-70, 7.5, 50, 30)];
        [lgbtn setTitle:@"登录" forState:UIControlStateNormal];
        lgbtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [lgbtn setBackgroundImage:[UIImage imageNamed:@"下载按钮"] forState:UIControlStateNormal];
        [lgbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [lgbtn addTarget:self action:@selector(lgAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bgscrol addSubview:lgbtn];
    }else{
        [nickTF removeFromSuperview];
        UILabel *nickLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 35)];
        self.nickLabel=nickLabel;
        nickLabel.text=[NSString stringWithFormat:@"亲爱的%@，欢迎发表建议！",username];
        [self.bgscrol addSubview:nickLabel];
      
        NSString *mobileStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserphone"];
        if(mobileStr){
                    self.mobileStr=mobileStr;
                if (mobileStr.length>0) {
                    NSString *mobileSecret=[mobileStr stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
                    contactTF.text=mobileSecret;
                    contactTF.enabled=NO;
                     self.is_bd=@"否";
                }else
                {
                    contactTF.enabled=YES;
                    contactTF.text=@"";
                    contactTF.placeholder=@"您的手机号码";
                     self.is_bd=@"是";
                }
        }else
        {
             [self loaddatas];
        }
    }
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-55, CGRectGetMaxY(textimg.frame)+5, 50, 30)];
    [submitBtn addTarget:self action:@selector(sendbtn) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"下载按钮"] forState:UIControlStateNormal];
    [self.bgscrol addSubview:submitBtn];
    
    UILabel *recentJYLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(submitBtn.frame)+5, 100, 35)];
    recentJYLabel.text=@"最近建议";
       [recentJYLabel setTextColor:[UIColor colorHelpWithRed:216 green:155 blue:76 alpha:1]];
    [self.bgscrol addSubview:recentJYLabel];
    
    self.m_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(recentJYLabel.frame), kScreenWidth, kScreenHeitht-CGRectGetMaxY(recentJYLabel.frame)) style:UITableViewStylePlain];
    self.m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_tableview.backgroundColor=[UIColor clearColor];
    self.m_tableview.backgroundView=nil;
    self.m_tableview.autoresizesSubviews = YES;
    self.m_tableview.showsHorizontalScrollIndicator = YES;
    self.m_tableview.showsVerticalScrollIndicator = YES;
    self.m_tableview.delegate = self;
    self.m_tableview.scrollEnabled=NO;
    self.m_tableview.dataSource = self;
    [self.bgscrol addSubview:self.m_tableview];
    
    [self getyjdatas];
    
}
-(void)getyjdatas{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *qxfw_product = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [qxfw_product setObject:@"15" forKey:@"count"];
    [t_b setObject:qxfw_product forKey:@"gz_suggest_list"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:0 withSuccess:^(NSDictionary *returnData) {
        NSDictionary *b=[returnData objectForKey:@"b"];
        NSDictionary *qxfw_sel=[b objectForKey:@"gz_suggest_list"];
        self.datas=[qxfw_sel objectForKey:@"suggest_list"];
        CGFloat totalHeight=0;
        for (int i=0;i<self.datas.count ;i++) {
            CGFloat labsize = [[self.datas[i] objectForKey:@"msg"] boundingRectWithSize:CGSizeMake(kScreenWidth-10,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            totalHeight+=(labsize+40);
        }
        self.m_tableview.height=totalHeight;
        self.bgscrol.contentSize=CGSizeMake(kScreenWidth, totalHeight+self.m_tableview.y);
        [self.m_tableview reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        
    } withCache:YES];
}
#pragma mark -UITableDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.datas.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
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
    CGRect cellFrame = [cell frame];
    cellFrame.origin = CGPointMake(0, 0);
    
    cellFrame.size.height = 60;
    
    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-10, 60)];
    bgimg.backgroundColor=[UIColor colorHelpWithRed:231 green:231 blue:231 alpha:1];
    bgimg.userInteractionEnabled=YES;
    [cell addSubview:bgimg];
    
    UILabel *titlelab=[[UILabel alloc]initWithFrame:CGRectMake(10, 2, kScreenWidth, 20)];
    titlelab.text=[self.datas[row] objectForKey:@"nick_name"];
    titlelab.font=[UIFont systemFontOfSize:14];
    [cell addSubview:titlelab];
    UILabel *contentlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, kScreenWidth-10, 40)];
    contentlab.text=[self.datas[row] objectForKey:@"msg"];
    contentlab.font=[UIFont systemFontOfSize:14];
    contentlab.numberOfLines=0;
    [cell addSubview:contentlab];
    UILabel *timelab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-120, 2, kScreenWidth, 20)];
    timelab.text=[self.datas[row] objectForKey:@"create_time"];
    timelab.font=[UIFont systemFontOfSize:12];
    [cell addSubview:timelab];
    float height=[contentlab labelheight:[self.datas[row] objectForKey:@"msg"] withFont:[UIFont systemFontOfSize:14]];
    contentlab.frame=CGRectMake(10, 20, kScreenWidth-20, height+10);
    cellFrame.size.height=height+40;
    [cell setFrame:cellFrame];
    bgimg.frame=CGRectMake(5, 0, kScreenWidth-10,  cell.frame.size.height);
    UIImageView *l_line=[[UIImageView alloc]initWithFrame:CGRectMake(5, cell.frame.size.height-1, kScreenWidth-10, 1)];
    l_line.image=[UIImage imageNamed:@"灰色隔条"];
    [cell addSubview:l_line];
    return cell;
}
-(void)loaddatas
{
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
            NSString *mobileStr=[syn_user_info objectForKey:@"mobile"];
         
            if (mobileStr.length>0) {
                
                   self.mobileStr=mobileStr;
                NSString *mobileSecret=[mobileStr stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
                contactTF.text=mobileSecret;
                contactTF.enabled=NO;
                self.is_bd=@"否";
            }else
            {
                contactTF.enabled=YES;
                contactTF.text=@"";
                contactTF.placeholder=@"您的手机号码";
                self.is_bd=@"是";
            }
         
        }

        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } withCache:YES];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self inputContent:self.bgscrol];
}
-(void)tbtnAction:(UIButton *)sender{
    NSInteger tag=sender.tag;


        if (tag==0) {
            [sender setBackgroundImage:[UIImage imageNamed:@"好评"] forState:UIControlStateNormal];
            [self.marr[1] setBackgroundImage:[UIImage imageNamed:@"中评默认"] forState:UIControlStateNormal];
            [self.marr[2] setBackgroundImage:[UIImage imageNamed:@"差评默认"] forState:UIControlStateNormal];
            self.type=@"好评";
        }
        if (tag==1) {
            [sender setBackgroundImage:[UIImage imageNamed:@"中评"] forState:UIControlStateNormal];
            [self.marr[0] setBackgroundImage:[UIImage imageNamed:@"好评默认"] forState:UIControlStateNormal];
            [self.marr[2] setBackgroundImage:[UIImage imageNamed:@"差评默认"] forState:UIControlStateNormal];
            self.type=@"中评";
            
        }
        if (tag==2) {
            [sender setBackgroundImage:[UIImage imageNamed:@"差评"] forState:UIControlStateNormal];
            [self.marr[0] setBackgroundImage:[UIImage imageNamed:@"好评默认"] forState:UIControlStateNormal];
            [self.marr[1] setBackgroundImage:[UIImage imageNamed:@"中评默认"] forState:UIControlStateNormal];
            self.type=@"差评";
        }
    
}
-(void)lgAction{

    LGViewController *lg=[[LGViewController alloc]init];
    [self.navigationController pushViewController:lg animated:YES];
//    QXXZBViewController *qx=[[QXXZBViewController alloc] init];
//    [self.navigationController pushViewController:qx animated:YES];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.bglabel.hidden = YES;
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.bglabel.hidden=NO;
    }

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSLog(@"%@----%@",contentTV.text,text);
//    if (![text isEqualToString:@""]&&![text isEqualToString:@"\n"]) {
//        self.bglabel.hidden = YES;
//    }
    
//    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
////        self.bglabel.hidden = NO;
//        
//    }
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
    
        //在这里做你响应return键的代码
        [contentTV resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==nickTF) {
        self.keytype=@"昵称";
    }else if (textField==contactTF){
        self.keytype=@"联系";
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [nickTF resignFirstResponder];
    [contactTF resignFirstResponder];
    return YES;
}

- (void) Response:(NSDictionary *)responseData err:(NSInteger)err tag:(NSString *)tag
{
	if (responseData != nil)
	{
		NSDictionary *t_h = [responseData objectForKey:@"h"];
		if (t_h != nil)
		{
			NSString *pt = [t_h objectForKey:@"pt"];
			if (pt != nil && [pt isEqualToString:@"sugg"])
			{
				[ShareFun alertNotice:@"知天气" withMSG:@"发送成功" cancleButtonTitle:@"确定" otherButtonTitle:nil];
				[self dismissModalViewControllerAnimated:YES];
                
			}
		}
	}
	else
	{
		[ShareFun alertNotice:@"知天气" withMSG:@"发送失败" cancleButtonTitle:@"确定" otherButtonTitle:nil];
		[self dismissModalViewControllerAnimated:YES];
	}
}			

- (void)closeKeyBoard
{
	[contentTV resignFirstResponder];
	[contactTF resignFirstResponder];
    [nickTF resignFirstResponder];
}
//- (void)keyboardWillShow:(NSNotification *)notification {
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    if ([self.keytype isEqualToString:@"昵称"]) {
//        [self changeShareContentHeight:keyboardRect.size.height+50 withDuration:animationDuration];
//    }else{
//    [self changeShareContentHeight:keyboardRect.size.height withDuration:animationDuration];
//    }
//    
//    //	[self changeShareContentHeight:keyboardRect.size.height withDuration:animationDuration];
//}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGRect keyboardRect = [animationDurationValue CGRectValue];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    //	[self changeShareContentHeight:keyboardRect.size.height withDuration:animationDuration];
    [self changeNewview];
    
}
#pragma mark keyboardWillhe
- (void)changeShareContentHeight:(float)t_height withDuration:(float)t_dration
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:t_dration];
    [UIView setAnimationDelegate:self];
    //    [self.table setFrame:CGRectMake(0, self.barHeight, kScreenWidth, CGRectGetHeight(self.view.frame)-300)];
    
    if (iPhone4) {
        [self.bgscrol setContentOffset:CGPointMake(0,t_height-120)];
    }else{
      [self.bgscrol setContentOffset:CGPointMake(0,t_height-self.barHeight-40)];
    }

    [UIView commitAnimations];
}
-(void)changeNewview
{
    [self.bgscrol setContentOffset:CGPointMake(0, 0)];
    
}
@end
