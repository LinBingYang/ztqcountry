//
//  aboutZTQ.m
//  ZtqNew
//
//  Created by wang zw on 12-8-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "aboutZTQ.h"
#import "ShareFun.h"
#import "MianzeViewController.h"
#import "CpggVC.h"
#import "weiboVC.h"
@implementation aboutZTQ
@synthesize content;



- (void)viewDidLoad {
    [super viewDidLoad];
	

	self.view.backgroundColor = [UIColor whiteColor];
	
	[self performSelector:@selector(creatNagBar)];
    
    float place = 0;
    if(kSystemVersionMore7)
    {
        place = 20;
    }

	
	UIScrollView *t_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+place, kScreenWidth, kScreenHeitht)];
	[t_scrollView setBackgroundColor:[UIColor clearColor]];
	[t_scrollView setContentSize:CGSizeMake(self.view.width, kScreenHeitht-44-place)];
	t_scrollView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:t_scrollView];
//	[t_scrollView release];
	
	//----------------------------------------------------------------------------------------------------------------------
	UIImageView *logoImageView =[[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 50, 50)];
//    logoImageView.backgroundColor = [UIColor blueColor];
	[logoImageView setImage:[UIImage imageNamed:@"icon80"]];
	[t_scrollView addSubview:logoImageView];
//	[logoImageView release];
	
	UILabel *t_title = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 120, 30)];
	[t_title setTextColor:[UIColor blackColor]];
	[t_title setFont:[UIFont fontWithName:kBaseFont size:20]];
	[t_title setTextAlignment:NSTextAlignmentLeft];
	[t_title setBackgroundColor:[UIColor clearColor]];
//	[t_title setShadowColor:[UIColor blackColor]];
//	[t_title setShadowOffset:CGSizeMake(2, 2)]; 
	[t_title setText:@"知 天 气"];
	[t_scrollView addSubview:t_title];
//	[t_title release];
	
	UILabel *t_version = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 120, 30)];
	[t_version setTextColor:[UIColor blackColor]];
	[t_version setFont:[UIFont systemFontOfSize:14]];
	[t_version setTextAlignment:NSTextAlignmentLeft];
	[t_version setBackgroundColor:[UIColor clearColor]];
//	[t_version setShadowColor:[UIColor blackColor]];
//	[t_version setShadowOffset:CGSizeMake(1, 1)];
	[t_version setText:[NSString stringWithFormat:@"Ver %@", [ShareFun localVersion]]];
//    [t_version setText:@"V3.0.0"];
	[t_scrollView addSubview:t_version];
//	[t_version release];
	
    UILabel *bqlab = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, kScreenWidth, 30)];
    [bqlab setTextColor:[UIColor blackColor]];
    [bqlab setFont:[UIFont systemFontOfSize:14]];
    [bqlab setTextAlignment:NSTextAlignmentLeft];
    [bqlab setBackgroundColor:[UIColor clearColor]];
    [bqlab setText:@"版权所有：福建省气象局"];
    [t_scrollView addSubview:bqlab];
    
    UILabel *techlab = [[UILabel alloc] initWithFrame:CGRectMake(30, 130, kScreenWidth, 30)];
    [techlab setTextColor:[UIColor blackColor]];
    [techlab setFont:[UIFont systemFontOfSize:14]];
    [techlab setTextAlignment:NSTextAlignmentLeft];
    [techlab setBackgroundColor:[UIColor clearColor]];
    [techlab setText:@"技术支持：福建省气象服务中心"];
    [t_scrollView addSubview:techlab];
    
    UIButton *cpbtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 170, kScreenWidth-60, 37)];
    [cpbtn setBackgroundImage:[UIImage imageNamed:@"导航栏.png"] forState:UIControlStateNormal];
    [cpbtn setBackgroundImage:[UIImage imageNamed:@"导航栏.png"] forState:UIControlStateHighlighted];
    [cpbtn setTitle:@"产品公告" forState:UIControlStateNormal];
    [cpbtn addTarget:self action:@selector(cpAction) forControlEvents:UIControlEventTouchUpInside];
    [t_scrollView addSubview:cpbtn];
    
    UIImageView *saoimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, 177)];
    saoimg.image=[UIImage imageNamed:@"指纹二维码.jpg"];
    [t_scrollView addSubview:saoimg];
    
	//------------------------------------------------------------------------	
	CGRect t_frame = CGRectMake(30, 300, 260, 1000);
	UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
	CGSize textSize =  [content sizeWithFont:font constrainedToSize:t_frame.size lineBreakMode:NSLineBreakByCharWrapping];
	
//	NSLog(@"%f", t_frame.size.height);
	t_frame.size.height = textSize.height;
//	NSLog(@"%f", t_frame.size.height);
	
	t_scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeitht+50);
	
	UILabel *t_content = [[UILabel alloc] initWithFrame:t_frame];
	[t_content setTextColor:[UIColor blackColor]];
	[t_content setFont:[UIFont fontWithName:@"Helvetica" size:15]];
	[t_content setNumberOfLines:0];
	[t_content setBackgroundColor:[UIColor clearColor]];
//	[t_content setShadowColor:[UIColor blackColor]];
//	[t_content setShadowOffset:CGSizeMake(1, 1)];
	[t_content setText:content];
	[t_scrollView addSubview:t_content];

	
	UIButton *t_weiboLink = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2-96, 400, 37, 37)];
    [t_weiboLink setBackgroundImage:[UIImage imageNamed:@"微博.png"] forState:UIControlStateNormal];
	t_weiboLink.tag = 100;
	[t_weiboLink addTarget:self action:@selector(gotoWeibo:) forControlEvents:UIControlEventTouchUpInside];
	[t_scrollView addSubview:t_weiboLink];
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(t_weiboLink.frame)+20, 400+8, 1, 20)];
    line.image=[UIImage imageNamed:@"gyztq中间隔条"];
	[t_scrollView addSubview:line];
    
	UIButton *t_weiboLink2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+20, 400, 37, 37)];

    [t_weiboLink2 setBackgroundImage:[UIImage imageNamed:@"短信.png"] forState:UIControlStateNormal];

//	[t_weiboLink2 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//	[t_weiboLink2 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	t_weiboLink2.tag = 101;
	[t_weiboLink2 addTarget:self action:@selector(gotoWeibo:) forControlEvents:UIControlEventTouchUpInside];
	[t_scrollView addSubview:t_weiboLink2];

    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(t_weiboLink2.frame)+20, 400+8, 1, 20)];
    line1.image=[UIImage imageNamed:@"gyztq中间隔条"];
	[t_scrollView addSubview:line1];
	
	UIButton *meail = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line1.frame)+20, 400, 37, 37)];

    [meail setBackgroundImage:[UIImage imageNamed:@"电话.png"] forState:UIControlStateNormal];
//	[meail setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//	[meail setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	meail.tag = 102;
	[meail addTarget:self action:@selector(gotoWeibo:) forControlEvents:UIControlEventTouchUpInside];
	[t_scrollView addSubview:meail];
    
    
    UIButton *mzbtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-200)/3, 450, 100, 37)];
    [mzbtn setBackgroundImage:[UIImage imageNamed:@"推荐好友常态.png"] forState:UIControlStateNormal];
    [mzbtn setBackgroundImage:[UIImage imageNamed:@"推荐好友二态.png"] forState:UIControlStateHighlighted];
    [mzbtn setTitle:@"免责申明" forState:UIControlStateNormal];
    [mzbtn addTarget:self action:@selector(mzAction) forControlEvents:UIControlEventTouchUpInside];
    [t_scrollView addSubview:mzbtn];
    UIButton *tjbtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-200)/3*2+100, 450, 100, 37)];
    [tjbtn setBackgroundImage:[UIImage imageNamed:@"推荐好友常态.png"] forState:UIControlStateNormal];
    [tjbtn setBackgroundImage:[UIImage imageNamed:@"推荐好友二态.png"] forState:UIControlStateHighlighted];
    [tjbtn setTitle:@"推荐好友" forState:UIControlStateNormal];
    [tjbtn addTarget:self action:@selector(tjAction) forControlEvents:UIControlEventTouchUpInside];
    [t_scrollView addSubview:tjbtn];
	
	UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addView:)];
	[longPress setNumberOfTapsRequired:5];
	[t_scrollView addGestureRecognizer:longPress];
	
//	[longPress release];

}

- (void) addView:(UILongPressGestureRecognizer*)press
{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"当前地址:\n%@", URL_SERVER] delegate:self  
                                              cancelButtonTitle:nil  
                                         destructiveButtonTitle:nil  
                                              otherButtonTitles:nil];  
    // 逐个添加按钮（比如可以是数组循环）  
    [sheet addButtonWithTitle:@"线上地址"];
	[sheet addButtonWithTitle:@"开发地址"];
	[sheet addButtonWithTitle:@"测试地址"];
	
    // 同时添加一个取消按钮  
    [sheet addButtonWithTitle:@"取消"];  
    // 将取消按钮的index设置成我们刚添加的那个按钮，这样在delegate中就可以知道是那个按钮  
    sheet.cancelButtonIndex = sheet.numberOfButtons-1;  
	sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheet showFromRect:self.view.bounds inView:self.view animated:YES];  
//    [sheet release];
}
-(void)cpAction{
    NSLog(@"产品");
    CpggVC *cpvc=[[CpggVC alloc]init];
    [self.navigationController pushViewController:cpvc animated:YES];
}
-(void)mzAction{
    MianzeViewController *mzvc=[[MianzeViewController alloc]init];
    [self.navigationController pushViewController:mzvc animated:YES];
}
-(void)tjAction{
    //推荐好友使用

        
//        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
//        
//        
//        if([messageClass canSendText])
//            
//        {
    
            
            NSString * urlStr = URL_SERVER;
            NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
            [h setObject:[setting sharedSetting].app forKey:@"p"];
            NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
            [gz_todaywt_inde setObject:@"RECOMMEND_FRI" forKey:@"keyword"];
            [b setObject:gz_todaywt_inde forKey:@"gz_wt_share"];
            [param setObject:h forKey:@"h"];
            [param setObject:b forKey:@"b"];
            [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
                NSDictionary * b = [returnData objectForKey:@"b"];
                if (b!=nil) {
                    NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_wt_share"];
                    NSString *sharecontent=[gz_air_qua_index objectForKey:@"share_content"];
                    self.duanxinstr=sharecontent;
                    self.sharecontent=sharecontent;
                    [self rightAction];
                    
//                    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
//                    controller.body = self.duanxinstr;
//                    //        controller.recipients = @[@"13627988632",@"13627988567",@"13627988980"];
//                    controller.messageComposeDelegate = self;
//                    
//                    [self presentViewController:controller animated:YES completion:nil];
                }
                
                
            } withFailure:^(NSError *error) {
                NSLog(@"failure");
            } withCache:YES];
            
            
            
           
            
//        }else
//        {
//            UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"不能发送，该设备不支持短信功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//            [t_alertView show];
//            
//        }
    
    
    

}
//短信取消
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    //       [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if (buttonIndex == actionSheet.cancelButtonIndex)  
	{
		return; 
	}
	switch (buttonIndex)
	{
		case 0:
		{
			URL_SERVER = ONLINE_URL;
		}
			break;
		case 1:
		{
			URL_SERVER = kDevelopment;
//			[ShareFun showError:@"开发地址，请注意！"];
		}
			break;
		case 2:
		{
			URL_SERVER = kTestAddress;
//			[ShareFun showError:@"测试地址，请注意！"];
		}
			break;
	}
	[[NSUserDefaults standardUserDefaults] setInteger:buttonIndex forKey:@"url_type"];
}



- (void) creatNagBar
{
    
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    UIImageView * navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    navigationBarBg.userInteractionEnabled = YES;
    navigationBarBg.image=[UIImage imageNamed:@"导航栏"];
    [self.view addSubview:navigationBarBg];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 7+place, 30, 30)];
    [leftBut setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [leftBut setImage:[UIImage imageNamed:@"返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    [leftBut addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBg addSubview:leftBut];
    
    UIButton * rightbut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-50, 7+place, 30, 30)];
    [rightbut setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    [rightbut setImage:[UIImage imageNamed:@"分享点击.png"] forState:UIControlStateHighlighted];
    [rightbut setBackgroundColor:[UIColor clearColor]];
    [rightbut addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
//    [navigationBarBg addSubview:rightbut];

    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, self.view.width-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"关于知天气";
    [navigationBarBg addSubview:titleLab];

}

- (void) backClick
{
	[self.navigationController popViewControllerAnimated:YES];
	
}
-(void)rightAction{
    UIImage *t_shareImage = [ShareFun captureScreen];
    self.shareimg=t_shareImage;
    NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
    [UIImagePNGRepresentation(t_shareImage) writeToFile:shareImagePath atomically:YES];
    ShareSheet * sheet = [[ShareSheet alloc] initDefaultWithTitle:@"分享天气" withDelegate:self];
    [sheet show];
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
            //			[t_weibo release];
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
            shareObject.title=shareContent;
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

- (void) gotoWeibo:(id)sender
{
	UIButton *t_button = (UIButton *)sender;
    if (t_button.tag == 100){
        [ShareFun openUrl:ZTQ_SINA_WEIBO];}
    else if (t_button.tag == 101){
//        [ShareFun openUrl:ZTQ_SINA_WEIBO];
        [self sendMail];
    }
    else if (t_button.tag==102){
//        [self sendMail];
//    long nunber=15715947437;
    NSString *num=@"059183339985";
    NSString *num1 = [[NSString alloc]initWithFormat:@"tel://%@",num];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num1]]; //拨号
    }
}
-(void)sendMail{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self toMail];
        }
        else
        {
            UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"启动邮件失败，请至“设置——邮件、通讯录、日历”里设置邮箱" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [t_alertView show];
            //            [t_alertView release];
        }
    }
    
}
-(void)toMail{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];     //创建邮件controller
    
    mailPicker.mailComposeDelegate = self;;  //设置邮件代理
    
    [mailPicker setSubject:@""]; //邮件主题
    
    [mailPicker setToRecipients:[NSArray arrayWithObjects:@"2415252943@qq.com", nil]]; //设置发送给谁，参数是NSarray
    
    [mailPicker setMessageBody:@"" isHTML:NO];     //邮件内容
    
    [self presentModalViewController:mailPicker animated:YES];
}
#pragma mark mail
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result

                        error:(NSError*)error

{
    UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"邮件发送失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    
    switch (result){
            
        case MFMailComposeResultCancelled:
            
            break;
            
        case MFMailComposeResultSaved:
            t_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"邮件保持成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [t_alertView show];
            //            [t_alertView release];
            break;
            
        case MFMailComposeResultSent:
            
            break;
            
        case MFMailComposeResultFailed:
            
            [t_alertView show];
            //            [t_alertView release];
            break;
            
        default:
            break;
            
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
}
@end
