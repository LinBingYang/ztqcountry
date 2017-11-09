//
//  moreTravelController.m
//  ZtqNew
//
//  Created by lihj on 12-6-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "moreTravelController.h"
#import "travelWeaView.h"
#import "travelDetailView.h"
#import "travelAD.h"
#import "MBProgressHUD.h"
#import "ShareSheet.h"
#import "weiboVC.h"

//#import "NetWorkCenter.h"
@interface moreTravelController()
@property(nonatomic,strong)UIImageView *navigationBarBg;
@end
@implementation moreTravelController

@synthesize m_travelWea = m_travelWea;
@synthesize m_travelDetail = m_travelDetail;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
	m_mainVCmainVModel = [[mainVCmainVModel alloc] init];
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    self.barhight=place+44;
    
    UIImageView * navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    navigationBarBg.userInteractionEnabled = YES;
//    navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1];
    navigationBarBg.image=[UIImage imageNamed:@"导航栏"];
    [self.view addSubview:navigationBarBg];
    self.navigationBarBg=navigationBarBg;
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 7+place, 30, 30)];
    [leftBut setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [leftBut setImage:[UIImage imageNamed:@"返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBg addSubview:leftBut];
    UIButton * rightBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, 7+place, 30, 30)];
    [rightBut setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    [rightBut setBackgroundColor:[UIColor clearColor]];
    [rightBut addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBg addSubview:rightBut];
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, kScreenWidth-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"旅游气象";
    [navigationBarBg addSubview:titleLab];
    
	[self performSelector:@selector(createScrollView)];
	[self performSelector:@selector(getSstq)];
}

- (UIView *) createWeaView
{
	travelWeaView *t_weaView = [[travelWeaView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [UIScreen mainScreen].bounds.size.height-80)];
	t_weaView.m_target = self;
	[t_weaView setTravelCity:self.mycity];
    //t_weaView.mycity=self.mycity;
    self.m_travelWea = t_weaView;
    return t_weaView;
}

- (UIView *) createDetailView
{
	travelDetailView *t_detailView = [[travelDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [UIScreen mainScreen].bounds.size.height-80)];
    self.m_travelDetail = t_detailView;
    return t_detailView;
	
}
-(UIView *)createADView{
    travelAD *t_adview=[[travelAD alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, [UIScreen mainScreen].bounds.size.height-80)];
    self.m_traveAD=t_adview;
    return t_adview;
}
- (void)setTravelCity:(NSString *)detailCity
{
	city = detailCity;
//    [self readXML];//读取id
}
-(void)readXML{
    m_allCity=m_treeNodelLandscape;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        t_node_child = [t_node.children objectAtIndex:0];
        NSString *tid = t_node_child.leafvalue;
        if ([city isEqualToString:tid])
        {
            
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:2];
            NSString *name = t_node_child1.leafvalue;
            self.mycity=name;
        }
    }
    
    

    
}
#pragma mark UIButton action
- (void)leftBtn:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) createScrollView
{
	PCSScrollView *t_scrollView = [[PCSScrollView alloc] initWithFrame:CGRectMake(0, self.barhight, kScreenWidth, [UIScreen mainScreen].bounds.size.height-65)];
	[self.view addSubview:t_scrollView];
	[t_scrollView setDelegate:self];
	
	[t_scrollView addSlideView:[self createWeaView]];
	[t_scrollView addSlideView:[self createDetailView]];
//	[t_scrollView addSlideView:[self createADView]];//新增广告
	[t_scrollView setScroll:NO];
	[t_scrollView setCurrentPage:0];
}

#pragma mark download Data
- (void) getSstq
{
	[MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *lx = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *gz_tourwt = [NSMutableDictionary dictionaryWithCapacity:4];
   

	[t_h setObject:[setting sharedSetting].app forKey:@"p"];

	[lx setObject:city forKey:@"tour_id"];
    [t_b setObject:lx forKey:@"gz_tour_weekwt"];
    [gz_tourwt setObject:city forKey:@"tour_id"];
    [t_b setObject:gz_tourwt forKey:@"gz_tourwt"];
	[t_dic setObject:t_h forKey:@"h"];
	[t_dic setObject:t_b forKey:@"b"];
//	NSLog(@"%@",t_dic);
	[[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
//        NSLog(@"%@",returnData);
        if (returnData == nil)
		{
			[MBProgressHUD hideHUDForView:self.view animated:NO];
			return;
		}
        
		//[city_tq removeAllObjects];
		//首页天气数据
		NSDictionary *t_b = [returnData objectForKey:@"b"];
		
		if (t_b != nil)
		{
			NSArray *t_array = [[t_b objectForKey:@"gz_tour_weekwt"] objectForKey:@"tour_weekwt_list"];
			NSMutableArray *t_yztqModelArray = [[NSMutableArray alloc] initWithCapacity:4];
			if (t_array != nil) {
				for (int i = 0; i < [t_array count]; i ++) {
					FcModel *t_yztqmodel = [[FcModel alloc] init];
					t_yztqmodel.week = [[t_array objectAtIndex:i] objectForKey:@"week"];
					t_yztqmodel.wd_ico = [[t_array objectAtIndex:i] objectForKey:@"wd_ico"];
                    t_yztqmodel.wd_daytime_ico= [[t_array objectAtIndex:i] objectForKey:@"wt_day_ico"];
                    t_yztqmodel.wd_night_ico= [[t_array objectAtIndex:i] objectForKey:@"wt_night_ico"];
					t_yztqmodel.wd = [[t_array objectAtIndex:i] objectForKey:@"wt"];
                    t_yztqmodel.wd_daytime = [[t_array objectAtIndex:i] objectForKey:@"wt_day"];
                    t_yztqmodel.wd_night = [[t_array objectAtIndex:i] objectForKey:@"wt_night"];
					t_yztqmodel.higt = [[t_array objectAtIndex:i] objectForKey:@"higt"];
					t_yztqmodel.lowt = [[t_array objectAtIndex:i] objectForKey:@"lowt"];
					t_yztqmodel.gdt = [[t_array objectAtIndex:i] objectForKey:@"gdt"];
                    t_yztqmodel.isnight=[[t_array objectAtIndex:i]objectForKey:@"is_night"];
					[t_yztqModelArray addObject:t_yztqmodel];
                    //					[t_yztqmodel release];
				}
				m_mainVCmainVModel.fcModelArray = t_yztqModelArray;
			}
			
            NSDictionary *gz_tourwt=[t_b objectForKey:@"gz_tourwt"];
            NSDictionary *tourwt=[gz_tourwt objectForKey:@"tourwt"];
			NSString *tra_des = [tourwt objectForKey:@"des"];
			NSString *t_imgs1 = [tourwt objectForKey:@"img"];
//			NSLog(@"%@..%@",tra_des, t_imgs1);
			[m_travelDetail updateView:tra_des withImage:t_imgs1];
			[m_travelWea updateView:m_mainVCmainVModel withName:self.mycity Withimg:t_imgs1];
		}
		
		[MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
       [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withCache:YES];
}


//- (void) collect
//{
//	if (isFromCollect)
//	{
//		[self.navigationController popViewControllerAnimated:YES];
//	}
//	else
//	{
//		collectTravelController *collectVC = [[collectTravelController alloc] init];
//		[self.navigationController pushViewController:collectVC animated:!kSystemVersionMore7];
//
//	}
//}

- (void)setIsFromCollect:(BOOL)b
{
	isFromCollect = b;
    
}

#pragma mark travelWeaView.m_target
- (void) share
{
    [self getShareContent];
	//分享的图片
//	UIImage *t_shareImage = [ShareFun captureScreen];
    

//	NSString *t_temp = [NSString stringWithFormat:@"%@~%@℃",m_mainVCmainVModel.sstq.higt, m_mainVCmainVModel.sstq.lowt];
//	NSString *t_tq=@"";
//    //    if (m_mainVCmainVModel.sstq.isNight && [m_mainVCmainVModel.sstq.is_early intValue]==0) {
//    //        t_tq=m_mainVCmainVModel.sstq.wd_night;
//    //    }else{
//    //        t_tq=m_mainVCmainVModel.sstq.wd;
//    //    }
//    //*
//    if (m_mainVCmainVModel.sstq.isNight) {
//        //18：40-24：00
//        if ([m_mainVCmainVModel.sstq.is_early intValue]==0) {
//            t_tq=[NSString stringWithFormat:@"夜间 %@",m_mainVCmainVModel.sstq.wd_night] ;
//            t_temp = [NSString stringWithFormat:@"最低温度%@℃", m_mainVCmainVModel.sstq.lowt];
//            
//        }else if([m_mainVCmainVModel.sstq.is_early intValue]==1){//24：00-6：30
//            t_tq=m_mainVCmainVModel.sstq.wd;
//            t_temp = [NSString stringWithFormat:@"%@~%@℃",m_mainVCmainVModel.sstq.lowt,m_mainVCmainVModel.sstq.higt];
//        }
//        else if ([m_mainVCmainVModel.sstq.is_early intValue]==3){
//            t_tq=m_mainVCmainVModel.sstq.wd;
//            t_temp = [NSString stringWithFormat:@"%@~%@℃",m_mainVCmainVModel.sstq.lowt,m_mainVCmainVModel.sstq.higt];
//        }
//    }else{//6：30-18：40
//        t_tq=m_mainVCmainVModel.sstq.wd;
//        t_temp = [NSString stringWithFormat:@"%@~%@℃",m_mainVCmainVModel.sstq.higt, m_mainVCmainVModel.sstq.lowt];
//    }     //*/
//    
//	NSMutableString *strSMS = [NSMutableString stringWithCapacity:256];
//	[strSMS appendFormat:@"%@:", self.mycity];
////	[strSMS appendFormat:@"%@,", t_string];
////	[strSMS appendFormat:@"%@,", t_tq];
////	[strSMS appendFormat:@"%@;", t_temp];
//	
//	for (int i=0; i<m_mainVCmainVModel.fcModelArray.count; i++)
//	{
//		FcModel *t_model = (FcModel *)[m_mainVCmainVModel.fcModelArray objectAtIndex:i];
//		
//		[strSMS appendFormat:@"%@,", t_model.gdt];
//		[strSMS appendFormat:@"%@,", t_model.wd];
//        if (!m_mainVCmainVModel.sstq.isNight){
//            [strSMS appendFormat:@"%@~%@℃", t_model.higt, t_model.lowt];
//        }else{
//            [strSMS appendFormat:@"%@~%@℃", t_model.lowt, t_model.higt];
//        }
//        
//		
//		if (i == m_mainVCmainVModel.fcModelArray.count-1)
//			[strSMS appendString:@"。"];
//		else
//			[strSMS appendString:@";"];
//	}
//	
//    NSString *t_shareInfo = [setting sharedSetting].info_shareWeather;
//	NSString *strSMS2;
//	if (t_shareInfo != nil && [t_shareInfo length] != 0)
//	{
//		NSArray *t_array = [t_shareInfo componentsSeparatedByString:@"-weather-。"];
//		if ([t_array count] >= 2)
//			strSMS2 = [NSString stringWithFormat:@"%@%@%@", [t_array objectAtIndex:0], strSMS, [t_array objectAtIndex:1]];
//		else
//			strSMS2 = [NSString stringWithFormat:@"%@%@", strSMS, [t_array objectAtIndex:0]];
//	} else
//		strSMS2 = [strSMS stringByAppendingFormat:@"@知天气 "];
//    
//    [[NSUserDefaults standardUserDefaults]setObject:strSMS2 forKey:@"shareCont"];

	
}
-(UIImage *)makeImageMore
{
    NSMutableArray *images=[[NSMutableArray alloc]init];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 64), NO, 0.0);
    [self.navigationBarBg.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images addObject:tempImage];
    
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.m_travelWea->m_tableView.contentSize, NO, 0.0);
    //    UIGraphicsBeginImageContext(_glassScrollView.foregroundScrollView.contentSize);
    {
        CGPoint savedContentOffset = self.m_travelWea->m_tableView.contentOffset;
        CGRect savedFrame = self.m_travelWea->m_tableView.frame;
        
        self.m_travelWea->m_tableView.contentOffset = CGPointZero;
        self.m_travelWea->m_tableView.frame = CGRectMake(0, 0, kScreenWidth, self.m_travelWea->m_tableView.contentSize.height);
        self.m_travelWea->m_tableView.backgroundColor=[UIColor whiteColor];
        [self.m_travelWea->m_tableView.layer renderInContext: UIGraphicsGetCurrentContext()];
          self.m_travelWea->m_tableView.backgroundColor=[UIColor clearColor];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.m_travelWea->m_tableView.contentOffset = savedContentOffset;
        self.m_travelWea->m_tableView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    [images addObject:image];
    //添加二维码
    UIImage *ewmimg=[UIImage imageNamed:@"指纹二维码.jpg"];
    UIImageView *ewm=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 177)];
    ewm.image=ewmimg;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 177), NO, 0.0);
    [ewm.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImage1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images addObject:tempImage1];
    
    //    [self verticalImageFromArray:images];
    UIImage *newimg=[self verticalImageFromArray:images];
    return newimg;
    
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

-(void)getShareContent{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:city forKey:@"tour_id"];
    [gz_todaywt_inde setObject:@"TOUR_WT" forKey:@"keyword"];
    [b setObject:gz_todaywt_inde forKey:@"gz_wt_share"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_wt_share"];
            NSString *sharecontent=[gz_air_qua_index objectForKey:@"share_content"];
            self.sharecontent=sharecontent;
            UIImage *moreImage=[self makeImageMore];
            self.shareimg=moreImage;
            NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
            [UIImagePNGRepresentation(moreImage) writeToFile:shareImagePath atomically:YES];
            //分享的内容
            ShareSheet * sheet = [[ShareSheet alloc] initDefaultWithTitle:@"分享天气" withDelegate:self];
            [sheet show];
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
            NSString *url;
            if ([self.sharecontent rangeOfString:@"http"].location!=NSNotFound) {
                NSArray *arr=[self.sharecontent componentsSeparatedByString:@"http"];
                if (arr.count>0) {
                    url=[NSString stringWithFormat:@"http%@",arr[1]];
                }
            }
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            UMShareWebpageObject *shareweb=[[UMShareWebpageObject alloc]init];
            shareweb.webpageUrl=url;
            shareweb.title=@"知天气分享";
            shareweb.thumbImage=self.shareimg;
            shareweb.descr=self.sharecontent;
            messageObject.shareObject = shareweb;
            
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
            NSString *url;
            if ([self.sharecontent rangeOfString:@"http"].location!=NSNotFound) {
                url=[self.sharecontent substringToIndex:[self.sharecontent rangeOfString:@"http"].location];
            }else{
                url=self.sharecontent;
            }
            //要分享的内容，加在一个数组里边，初始化UIActivityViewController
            NSMutableArray *activityItems=[[NSMutableArray alloc] init];
            NSString *textToShare = url;
            UIImage *imageToShare = self.shareimg;
            // 本地沙盒目录
            NSURL *imageUrl=[NSURL URLWithString:@"http://www.fjqxfw.com:8099/gz_wap/"];
            [activityItems addObject:textToShare];
            if (imageToShare) {
                [activityItems addObject:imageToShare];
            }
            [activityItems addObject:imageUrl];
            
            
            UIActivityViewController *activity =[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            
            [self.navigationController presentViewController:activity animated:YES completion:nil];
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
@end
