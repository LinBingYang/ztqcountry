//
//  TSMoreVC.m
//  ZtqCountry
//
//  Created by Admin on 15/7/10.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "TSMoreVC.h"
#import "UILabel+utils.h"
#import "weiboVC.h"
//#import "UMSocial.h"
#import "ShareSheet.h"
#import "UILabel+utils.h"
@implementation TSMoreVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    self.barHeight=place+44;
    
    self.navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    self.navigationBarBg.userInteractionEnabled = YES;
    self.navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:self.navigationBarBg];
    
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [self.navigationBarBg addSubview:leftimg];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:leftBut];
    
    UIButton * rightbut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, 7+place, 30, 30)];
    [rightbut setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    //    [rightbut setImage:[UIImage imageNamed:@"cssz返回点击.png"] forState:UIControlStateHighlighted];
    [rightbut setBackgroundColor:[UIColor clearColor]];
    
    [rightbut addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
//    if ([self.titlestr isEqualToString:@"气象预警"]) {
        [self.navigationBarBg addSubview:rightbut];
//    }

    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, kScreenWidth-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text =self.titlestr;
    [self.navigationBarBg addSubview:titleLab];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    m_scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht)];
    m_scroll.contentSize=CGSizeMake(kScreenWidth,kScreenHeitht+80);
    m_scroll.showsVerticalScrollIndicator=NO;
    [self.view addSubview:m_scroll];
    
    
    
    UIImageView *ico=[[UIImageView alloc]initWithFrame:CGRectMake(16, 8, 60, 55)];
    ico.image=[UIImage imageNamed:self.ico];
    [m_scroll addSubview:ico];
    
    UILabel *titleLa=[[UILabel alloc]initWithFrame:CGRectMake(85, 8, 180, 40)];
    titleLa.text=self.titlestr;
    titleLa.textColor=[UIColor blackColor];
    titleLa.numberOfLines=0;
    titleLa.font=[UIFont systemFontOfSize:18];
    titleLa.backgroundColor=[UIColor clearColor];
    [m_scroll addSubview:titleLa];
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(75, 42, self.view.width, 1)];
    line1.image=[UIImage imageNamed:@"气象预警分隔线 "];
    [m_scroll addSubview:line1];
    
    UILabel *desLa=[[UILabel alloc]initWithFrame:CGRectMake(85, 45, 200, 20)];
    desLa.text=self.putstring;
    desLa.numberOfLines=0;
    desLa.textColor=[UIColor colorHelpWithRed:84 green:83 blue:83 alpha:1];
    desLa.font=[UIFont systemFontOfSize:12.0];
    [m_scroll addSubview:desLa];
    
    
    
    
    
    UILabel *contentLa=[[UILabel alloc]initWithFrame:CGRectMake(16, 60, kScreenWidth-32, 150)];
    if (self.warninfo.length>0) {
        contentLa.text=[NSString stringWithFormat:@"    %@",self.warninfo];
    }
    //         contentLa.text=[NSString stringWithFormat:@"  %@发布大风黄色预警，8月06日20时至8月07日20时，个别地区将会刮起6-7级大风，局部有沙尘暴。请当地具名做好防范，特别是沿海地区，注意房屋的加固。" ,self.putstring];
    contentLa.numberOfLines=0;
    contentLa.textAlignment=NSTextAlignmentLeft;
    contentLa.textColor=[UIColor colorHelpWithRed:84 green:83 blue:83 alpha:1];
    contentLa.font=[UIFont systemFontOfSize:15.0];
    contentLa.backgroundColor=[UIColor clearColor];
    [m_scroll addSubview:contentLa];
    float h=[contentLa labelheight:self.warninfo withFont:[UIFont systemFontOfSize:15.0]];
    contentLa.frame=CGRectMake(16, 60, kScreenWidth-32, h+30);
    
    //分享内容
    self.guidestr=[NSString stringWithFormat:@"%@ %@ %@ @知天气。下载“知天气”客户端：http://218.85.78.125:8099/ztq_wap/",self.titlestr,self.warninfo,self.putstring];
    
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 60+h+40, self.view.width, 1)];
            line.image=[UIImage imageNamed:@"气象预警分隔线 "];
//    line.backgroundColor=[UIColor blackColor];
    [m_scroll addSubview:line];
    
    
    
    UILabel * gtitleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 60+h+50, 300, 20)];
    gtitleLab.backgroundColor = [UIColor clearColor];
    gtitleLab.text = @"防御指南:";
    gtitleLab.textAlignment = NSTextAlignmentLeft;
    gtitleLab.font = [UIFont systemFontOfSize:16];
    gtitleLab.textColor = [UIColor colorHelpWithRed:84 green:83 blue:83 alpha:1];
    //    [m_scroll addSubview:gtitleLab];
    UILabel * contentView = [[UILabel alloc] initWithFrame:CGRectMake(16, 110+h, 300, 20)];
    contentView.numberOfLines = 0;
    contentView.backgroundColor = [UIColor clearColor];
    contentView.text = self.fyzninfo;
    contentView.textAlignment = NSTextAlignmentLeft;
    contentView.font = [UIFont systemFontOfSize:15];
    contentView.textColor =[UIColor colorHelpWithRed:84 green:83 blue:83 alpha:1];
    CGFloat labHeight = [contentView labelheight:self.fyzninfo withFont:[UIFont systemFontOfSize:15]];
    contentView.frame = CGRectMake(16, 110+h, 300, labHeight+50);
    [m_scroll addSubview:contentView];
    
    [m_scroll setContentSize:CGSizeMake(kScreenWidth, labHeight+h+220)];
    if ([self.type isEqualToString:@"风险"]) {
        UIWebView * webV = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-44)];
        self.web = webV;
        webV.scalesPageToFit=YES;//允许缩放
        
        [self.view addSubview:webV];
        [self loadWeb:self.url];
    }
    
}
-(void)leftBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtn:(UIButton *)sender{
    UIImage *t_shareImage = [ShareFun captureScreen];
    self.shareimg=t_shareImage;
    NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
    [UIImagePNGRepresentation(t_shareImage) writeToFile:shareImagePath atomically:YES];
    ShareSheet * sheet = [[ShareSheet alloc] initDefaultWithTitle:@"分享天气" withDelegate:self];
    [sheet show];
}
-(void)loadWeb:(NSString *)urlS
{
    NSURL * url = [NSURL URLWithString:urlS];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:request];
}


//-(void)shareBtn{
//    UIImage *t_shareImage = [ShareFun captureScreen];
//    self.shareimg=t_shareImage;
//	NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
//	[UIImagePNGRepresentation(t_shareImage) writeToFile:shareImagePath atomically:YES];
//    ShareSheet * sheet = [[ShareSheet alloc] initDefaultWithTitle:@"分享天气" withDelegate:self];
//    [sheet show];
//
//}
-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath
{
    NSString *shareContent = self.guidestr;
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
//短信取消
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    //       [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
