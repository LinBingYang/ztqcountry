//
//  MapVC.m
//  ZtqCountry
//
//  Created by Admin on 15/6/23.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "MapVC.h"
#import "WarnBillViewController.h"
#import "ShareSheet.h"
#import "weiboVC.h"
@implementation MapVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    self.barHeight=place+44;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    self.navigationBarBg.userInteractionEnabled = YES;
    self.navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    //    self.navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1];
    [self.view addSubview:self.navigationBarBg];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(15, 7+place, 30, 30)];
    [leftBut setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    //    [leftBut setImage:[UIImage imageNamed:@"cssz返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:leftBut];
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, self.view.width-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"指点天气";
    [self.navigationBarBg addSubview:titleLab];
    
    self.view.backgroundColor=[UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getdwcity:) name:@"DWCITY" object:nil];
    UIButton *footbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth/3, 34)];
    [footbtn setTitle:@"出行天气" forState:UIControlStateNormal];
    [footbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footbtn addTarget:self action:@selector(footAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footbtn];
    UIButton *lybtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/3, self.barHeight, kScreenWidth/3, 34)];
    [lybtn setTitle:@"旅游气象" forState:UIControlStateNormal];
    [lybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lybtn addTarget:self action:@selector(lyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lybtn];
    UIButton *tybtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/3*2, self.barHeight, kScreenWidth/3, 34)];
    [tybtn setTitle:@"台风路径" forState:UIControlStateNormal];
    [tybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tybtn addTarget:self action:@selector(tyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tybtn];
    self.selectimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.barHeight+34, kScreenWidth/3, 2)];
    self.selectimg.image=[UIImage imageNamed:@"一周 24小时切换条"];
    [self.view addSubview:self.selectimg];
    
     _geocoder=[[CLGeocoder alloc]init];
    UIButton * rightbut = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-40, 7+20, 30, 30)];
    [rightbut setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    [rightbut setBackgroundColor:[UIColor clearColor]];
    [rightbut addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:rightbut];
    if ([self.mptype isEqualToString:@"出行"]) {
//        self.selectimg.frame=CGRectMake(0, self.barHeight+34, kScreenWidth/3, 2);
        [self footAction];
    }
    if ([self.mptype isEqualToString:@"旅游"]) {
//        self.selectimg.frame=CGRectMake(kScreenWidth/3, self.barHeight+34, kScreenWidth/3, 2);
        [self lyAction];
    }
    if ([self.mptype isEqualToString:@"台风"]) {
//        self.selectimg.frame=CGRectMake(kScreenWidth/3*2, self.barHeight+34, kScreenWidth/3, 2);
        [self tyAction];
    }
    
    m_mapMode = 1;
    tf_list = [[NSMutableArray alloc] initWithCapacity:3];
   
}
-(void)leftBtn:(UIButton *)sender{
    if (newtflistview) {
        [newtflistview removeFromSuperview];
        newtflistview=nil;
    }
    if (self.isexpent==YES) {
        [m_viewLegend removeFromSuperview];
        self.isexpent=NO;
    }else{
    [self.navigationController setToolbarHidden:YES animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)getdwcity:(NSNotification *)sender{
    self.locationcity=sender.object;
}
-(void)footAction{
     self.mptype=@"出行";
    if (newtflistview) {
        [newtflistview removeFromSuperview];
        newtflistview=nil;
    }
     [self.navigationController setToolbarHidden:YES animated:YES];
    self.selectimg.frame=CGRectMake(0, self.barHeight+34, kScreenWidth/3, 2);
    if (self.bgview) {
        [self.bgview removeFromSuperview];
        self.bgview=nil;
    }
    self.bgview=[[UIView alloc]initWithFrame:CGRectMake(0, self.barHeight+36, kScreenWidth, kScreenHeitht)];
    [self.view addSubview:self.bgview];
//    UILabel *startlab=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 40, 30)];
//    startlab.text=@"起点";
//    startlab.font=[UIFont systemFontOfSize:15];
//    [self.bgview addSubview:startlab];
//    UILabel *endlab=[[UILabel alloc]initWithFrame:CGRectMake(20, 45, 40, 30)];
//    endlab.text=@"终点";
//    endlab.font=[UIFont systemFontOfSize:15];
//    [self.bgview addSubview:endlab];
    
    UITextField *starttf=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, (self.view.width-60)/2, 28)];
    self.starttf=starttf;
    starttf.placeholder=@"-请输入起点-";
//    [starttf setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    starttf.textAlignment=NSTextAlignmentCenter;
    starttf.delegate=self;
    starttf.layer.cornerRadius=8;
    starttf.layer.masksToBounds=YES;
    starttf.layer.borderColor = [UIColor grayColor].CGColor;
    starttf.layer.borderWidth=0.5;
    starttf.returnKeyType=UIReturnKeyDone;
    [self.bgview addSubview:starttf];
    UITextField *endtf=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(starttf.frame)+10, 5, (self.view.width-60)/2, 28)];
    self.endtf=endtf;
    endtf.placeholder=@"-请输入终点-";
//    [endtf setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    endtf.textAlignment=NSTextAlignmentCenter;
    endtf.delegate=self;
    endtf.layer.cornerRadius=8;
    endtf.layer.masksToBounds=YES;
    endtf.layer.borderColor = [UIColor grayColor].CGColor;
    endtf.layer.borderWidth=0.5;
    endtf.returnKeyType=UIReturnKeyDone;
    [self.bgview addSubview:endtf];
    UIButton *searchbtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-40, 5, 32, 30)];
    [searchbtn setBackgroundImage:[UIImage imageNamed:@"地图搜索"] forState:UIControlStateNormal];
    [searchbtn setBackgroundImage:[UIImage imageNamed:@"地图搜索二态"] forState:UIControlStateHighlighted];
    [searchbtn addTarget:self action:@selector(SearchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgview addSubview:searchbtn];
    self.footview=[[FootMapView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeitht-40-self.barHeight)];
    [self.bgview addSubview:self.footview];
    
    
    _search = [[AMapSearchAPI alloc] initWithSearchKey:@"7dd7294f1eb47ff26db3ec800af22024" Delegate:self];
    
    //构造AMapInputTipsSearchRequest对象，keywords为必选项，city为可选项
    AMapInputTipsSearchRequest *tipsRequest= [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.searchType = AMapSearchType_InputTips;
    self.maprequest=tipsRequest;
  
    
    
    
}
-(void)rightBtn:(UIButton *)sender{
    self.sharecontent=nil;
    [self getShareContent];

}
-(void)getShareContent{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [gz_todaywt_inde setObject:@"ABOUT_GZ_DOWN" forKey:@"keyword"];
    [b setObject:gz_todaywt_inde forKey:@"gz_wt_share"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_wt_share"];
            NSString *sharecontent=[gz_air_qua_index objectForKey:@"share_content"];
            NSString *subStr1;
            if ([self.mptype isEqualToString:@"出行"]) {
                subStr1=@"出行天气";
            }
            if ([self.mptype isEqualToString:@"旅游"]) {
                subStr1=@"旅游气象";
            }
            if ([self.mptype isEqualToString:@"台风"]) {
                subStr1=@"台风路径";
            }
            self.sharecontent=[NSString stringWithFormat:@"%@%@",subStr1,sharecontent];
            UIImage *moreImage=[ShareFun captureScreen];
            self.shareimg=[self makeImageMore:moreImage];
            NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
            [UIImagePNGRepresentation(self.shareimg) writeToFile:shareImagePath atomically:YES];
            ShareSheet * sheet = [[ShareSheet alloc] initDefaultWithTitle:@"分享天气" withDelegate:self];
            [sheet show];
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(UIImage *)makeImageMore:(UIImage *)img
{
    NSMutableArray *images=[[NSMutableArray alloc]init];
    [images addObject:img];
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
            
            //创建图片内容对象
            //            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //            //如果有缩略图，则设置缩略图
            //            [shareObject setShareImage:self.shareimg];
            UMShareWebpageObject *shareweb=[[UMShareWebpageObject alloc]init];
            shareweb.webpageUrl=url;
            shareweb.title=@"知天气分享";
            shareweb.thumbImage=[ShareFun captureScreen];
            shareweb.descr=self.sharecontent;
            //分享消息对象设置分享内容对象
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
            //            Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
            //
            //
            //            if([messageClass canSendText])
            //
            //            {
            //
            //                MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
            //                controller.body = shareContent;
            //                controller.messageComposeDelegate = self;
            //
            //                [self presentViewController:controller animated:YES completion:nil];
            //
            //            }else
            //            {
            //                UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"不能发送，该设备不支持短信功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            //                [t_alertView show];
            //
            //            }
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

//地理搜索
- (void)searchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = key;
    
    if (adcode.length > 0)
    {
        geo.city = @[adcode];
    }
    
    [self.search AMapGeocodeSearch:geo];
    
}

/* 地理编码回调.*/
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"地点错误" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [al show];
        return;
    }
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        //        NSLog(@"%@",obj);
        self.geocode=obj;
        AMapGeoPoint *p =self.geocode.location;
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(p.latitude-0.00060,p.longitude+0.0011);
        if ([self.tftype isEqualToString:@"1"]) {
            startcoor=coords;
        }
        if ([self.tftype isEqualToString:@"2"]) {
            endcoor=coords;
        }
        
        
    }];
    
    
}
//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        return;
    }
    
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    //    NSString *strCount = [NSString stringWithFormat:@"count: %d", response.count];
    //    NSString *strtips = @"";
    self.searchcitys=response.tips;
    //    for (AMapTip *p in response.tips) {
    //        strtips = [NSString stringWithFormat:@"%@\nTip: %@", strtips, p.description];
    //    }
    //    NSString *result = [NSString stringWithFormat:@"%@ \n %@", strCount, strtips];
    //    NSLog(@"InputTips: %@", result);
    [searchDisplayController.searchResultsTableView reloadData];
}





-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *key = searchBar.text;
    [self searchTipsWithKey:key];
   
}
//隐藏
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    if (startsearchBar) {
        [startsearchBar removeFromSuperview];
        [searchDisplayController.searchResultsTableView removeFromSuperview];
    }
    
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    if (startsearchBar) {
        [startsearchBar removeFromSuperview];
        [searchDisplayController.searchResultsTableView removeFromSuperview];
    }
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView{
    [startsearchBar removeFromSuperview];
    [searchDisplayController.searchResultsTableView removeFromSuperview];
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchTipsWithKey:searchString];
    
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self searchTipsWithKey:searchText];
    
}


-(void)searchTipsWithKey:(NSString *)city{
    self.maprequest.keywords = city;
    self.maprequest.city=@[@"中国"];
    //发起输入提示搜索
    [_search AMapInputTipsSearch: self.maprequest];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchcitys.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    
    NSString *t_str = [NSString stringWithFormat:@"cell %d_%d", section, row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:t_str];
    
    if(cell != nil)
        [cell removeFromSuperview];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSString *str=self.searchcitys[indexPath.row];
    
    AMapTip *tip = self.searchcitys[indexPath.row];
    cell.textLabel.text=tip.name;
    cell.textLabel.textColor=[UIColor blackColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [searchDisplayController setActive:NO animated:NO];
    [startsearchBar resignFirstResponder];
    AMapTip *tip = self.searchcitys[indexPath.row];
    [self searchGeocodeWithKey:tip.name adcode:tip.adcode];//获取经纬度
    if ([self.tftype isEqualToString:@"1"]) {
        self.starttf.text=tip.name;
    }
    if ([self.tftype isEqualToString:@"2"]) {
        self.endtf.text=tip.name;
    }
    [startsearchBar removeFromSuperview];
    [searchDisplayController.searchResultsTableView removeFromSuperview];
}
#pragma mark the 旅游
-(void)lyAction{
    self.mptype=@"旅游";
    if (newtflistview) {
        [newtflistview removeFromSuperview];
        newtflistview=nil;
    }
     [self.navigationController setToolbarHidden:YES animated:YES];
    self.selectimg.frame=CGRectMake(kScreenWidth/3, self.barHeight+34, kScreenWidth/3, 2);
    if (self.bgview) {
        [self.bgview removeFromSuperview];
        self.bgview=nil;
    }
    self.bgview=[[UIView alloc]initWithFrame:CGRectMake(0, self.barHeight+36, kScreenWidth, kScreenHeitht)];
    self.bgview.userInteractionEnabled=YES;
    [self.view addSubview:self.bgview];
    UIButton *cloctbtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, (kScreenWidth-40)/2, 30)];
    [cloctbtn setBackgroundImage:[UIImage imageNamed:@"景点收藏  景点列表框"] forState:UIControlStateNormal];
    [cloctbtn setTitle:@"景点收藏" forState:UIControlStateNormal];
    [cloctbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cloctbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [cloctbtn addTarget:self action:@selector(cloctAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgview addSubview:cloctbtn];
    UIImageView *scimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 4, 22, 22)];
    scimg.image=[UIImage imageNamed:@"景点收藏"];
    [cloctbtn addSubview:scimg];
    UIButton *listbtn=[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-40)/2+30, 10, (kScreenWidth-40)/2, 30)];
    [listbtn setBackgroundImage:[UIImage imageNamed:@"景点收藏  景点列表框"] forState:UIControlStateNormal];
    [listbtn setTitle:@"景点列表" forState:UIControlStateNormal];
    [listbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    listbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [listbtn addTarget:self action:@selector(listAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgview addSubview:listbtn];
    UIImageView *lbimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 4, 22, 22)];
    lbimg.image=[UIImage imageNamed:@"景点列表"];
    [listbtn addSubview:lbimg];
    
    self.lymapview=[[LYMapView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeitht-50)];
    self.lymapview.delegate=self;
    [self.bgview addSubview:self.lymapview];
}
#pragma mark the 台风
-(void)tyAction{
     self.mptype=@"台风";
    self.cancj=YES;
    self.isbofang=NO;
    self.selectimg.frame=CGRectMake(kScreenWidth/3*2, self.barHeight+34, kScreenWidth/3, 2);
    if (self.bgview) {
        [self.bgview removeFromSuperview];
        self.bgview=nil;
    }
    self.bgview=[[UIView alloc]initWithFrame:CGRectMake(0, self.barHeight+36, kScreenWidth, kScreenHeitht)];
    [self.view addSubview:self.bgview];
//    self.tflistview=[[TFListView alloc]initWithFrame:CGRectMake(20, 5, kScreenWidth-40, 30)];
//    self.tflistview.delegate=self;
//    [self.bgview addSubview:self.tflistview];
    self.tflistbtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 5, kScreenWidth-40, 30)];
    [self.tflistbtn setBackgroundImage:[UIImage imageNamed:@"台风列表选择框.png"] forState:UIControlStateNormal];
    [self.tflistbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.tflistbtn addTarget:self action:@selector(tflistAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgview addSubview:self.tflistbtn];
    UIImageView *xiaimg=[[UIImageView alloc]initWithFrame:CGRectMake(self.tflistbtn.frame.size.width-28, 5, 20, 20)];
    xiaimg.image=[UIImage imageNamed:@"台风路径下拉指示.png"];
    [self.tflistbtn addSubview:xiaimg];
    
    self.tfmodels=[[NSMutableArray alloc]init];
    
    if (m_typhoonView) {
        [m_typhoonView removeFromSuperview];
        m_typhoonView = nil;
    }
    m_typhoonView = [[typhoonView alloc] initWithFrame:CGRectMake(0,40, self.view.frame.size.width, kScreenHeitht-40-self.barHeight)];
    [m_typhoonView setDelegate:self];

    
    [self getTyphoonYearData];
    
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController setToolbarHidden:NO animated:YES];
//    m_btnPlay = [[UIBarButtonItem alloc] initWithTitle:@"播放" style:UIBarButtonItemStyleBordered target:self action:@selector(playMap)];
    m_btnPlay=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"播放按钮.png"] style:UIBarButtonItemStylePlain target:self action:@selector(playMap)],
    
    self.toolbarItems = [NSArray arrayWithObjects:
                        
                         m_btnPlay,
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithTitle:@"测距" style:UIBarButtonItemStyleBordered target:self action:@selector(find)],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithTitle:@"警报单" style:UIBarButtonItemStyleBordered target:self action:@selector(warnaction)],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithTitle:@"图例" style:UIBarButtonItemStyleBordered target:self action:@selector(explain)],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithTitle:@"地图切换" style:UIBarButtonItemStyleBordered target:self action:@selector(change)],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         nil
                         ];

    
}

#pragma mark the foot
-(void)SearchAction{
    [self.starttf resignFirstResponder];
    [self.endtf resignFirstResponder];
//    if (!self.starttf.text.length>0&&self.endtf.text.length>0) {
//        if (self.locationcity.length>0) {
//             [self.footview startaddress:self.locationcity Withendaddress:self.endtf.text];
//        }
//       
//    }else {
//        [self.footview startaddress:self.starttf.text Withendaddress:self.endtf.text];
//    }
    [self.footview startaddress:self.starttf.text Withendaddress:self.endtf.text withstratcoor:startcoor withendcoor:endcoor];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.starttf resignFirstResponder];
    [self.endtf resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==self.starttf) {
        self.tftype=@"1";
    }else{
        self.tftype=@"2";
    }
   
    startsearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    startsearchBar.placeholder = @"-请输入搜索地址-";
    startsearchBar.delegate=self;
    [self.bgview addSubview:startsearchBar];
    [startsearchBar becomeFirstResponder];
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:startsearchBar contentsController:self];
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
//    searchDisplayController.searchBar.selectedScopeButtonIndex = 0;
    searchDisplayController.searchContentsController.view.backgroundColor=[UIColor whiteColor];
    searchDisplayController.delegate=self;
    [searchDisplayController setActive:YES animated:YES];
    return NO;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller

{
    
    searchDisplayController.searchBar.backgroundColor = [UIColor whiteColor];
    
    searchDisplayController.searchBar.showsCancelButton = YES;
    
  
        
        for (id searchbutton in searchDisplayController.searchBar.subviews)
            
        {
            
            UIView *view = (UIView *)searchbutton;
            
            UIButton *cancelButton = (UIButton *)[view.subviews objectAtIndex:2];
            
            cancelButton.enabled = YES;
            
            [cancelButton setTitle:@"取消"  forState:UIControlStateNormal];//文字
            
            break;
            
        }
        
    
    
}
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    if (textField==self.starttf) {
//        if (textField.text.length>0) {
//            [self startaddress:self.starttf.text];
//        }
//    }
//    if (textField==self.endtf) {
//        if (textField.text.length>0) {
//            [self endAddress:self.endtf.text];
//        }
//    }
//    return YES;
//}
//-(void)startaddress:(NSString *)startcity{
//    [_geocoder geocodeAddressString:startcity completionHandler:^(NSArray *placemarks, NSError *error) {
//        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
//       NSArray *arr=placemarks;
//        
//        
//    }];
//    
//    
//}
//-(void)endAddress:(NSString *)endcity{
//    [_geocoder geocodeAddressString:endcity completionHandler:^(NSArray *placemarks, NSError *error) {
//        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
//        NSArray *arr=placemarks;
//        
//        
//        
//    }];
//}
#pragma mark the travel
-(void)cloctAction{
    TravelCollectVC *tcvc=[[TravelCollectVC alloc]init];
    [self.navigationController pushViewController:tcvc animated:YES];
}
-(void)listAction{
    TravelViewController *travelVC = [[TravelViewController alloc] init];
    [travelVC setDataSource:m_treeNodeProvince withCitys:m_treeNodelLandscape];
    [self.navigationController pushViewController:travelVC animated:YES];
}
-(void)lyclick:(NSString *)cityid Withcityname:(NSString *)cityname{
    moreTravelController *collectVC = [[moreTravelController alloc] init];
    [collectVC setTravelCity:cityid];
    collectVC.mycity=cityname;
    [self.navigationController pushViewController:collectVC animated:YES];
}
#pragma mark the tf
- (void) getTyphoonYearData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year=[dateFormatter stringFromDate:date];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *ftlist = [[NSMutableDictionary alloc]init];
    
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [ftlist setObject:year forKey:@"year"];
    [t_b setObject:ftlist forKey:@"gz_typho_list"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
//        NSLog(@"%@",returnData);
        //NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_dic == nil)
        {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            return;
        }
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        if (t_b != nil)
        {
            NSArray *t_array = [[t_b objectForKey:@"gz_typho_list"] objectForKey:@"typhoons"];
            NSString *is_ty=[[t_b objectForKey:@"gz_typho_list"] objectForKey:@"is_ty"];
            if ([is_ty isEqualToString:@"0"]) {
                NSString *des=[[t_b objectForKey:@"gz_typho_list"] objectForKey:@"desc"];
                UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:des delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [al show];
            }
            if (t_array != nil)
            {
                NSInteger index = 0;
                [tf_list removeAllObjects];
                for (int i = 0; i < [t_array count]; i ++)
                {
                    typhoonYearModel *tf_Model = [[typhoonYearModel alloc] init];
                    tf_Model.name = [[t_array objectAtIndex:i] objectForKey:@"name"];
                    tf_Model.code = [[t_array objectAtIndex:i] objectForKey:@"code"];
                    tf_Model.date = [[t_array objectAtIndex:i] objectForKey:@"date"];
                    
                    if ([tf_Model.code isEqualToString:self.currentCode])
                        index = i;
                    
                    [tf_list addObject:tf_Model];
                    if (i==0) {
//                        [self.tflistview.button setTitle:tf_Model.name forState:UIControlStateNormal];
                         [self.tflistbtn setTitle:tf_Model.name forState:UIControlStateNormal];
                    }
                }
                
//                selectedPickerRow = index;
                typhoonYearModel *tf_Model = (typhoonYearModel *)[tf_list objectAtIndex:index];
//                m_title = tf_Model.name;
//                
//                //                [self setTitle:m_title];
//                self.titleLab.text=m_title;
                [self.tflistview setList:tf_list];
                self.tfcode=tf_Model.code;
                [self performSelector:@selector(getTyphoonDetailData:) withObject:tf_Model.code];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            NSMutableArray *marr = [[NSMutableArray alloc] init];
            typhoonYearModel *tf_year = (typhoonYearModel *)[tf_list objectAtIndex:0];
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:tf_year.code, @"code", tf_year.name, @"name", nil];
            if (![marr containsObject:dic]) {
                [marr insertObject:dic atIndex:0];
            }
            [[NSUserDefaults standardUserDefaults] setObject:marr forKey:@"mytf"];
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
    
    
}
- (void)drawTyphoonMap
{
    if (m_typhoonView) {
        [m_typhoonView removeFromSuperview];
        m_typhoonView = nil;
    }
    m_typhoonView = [[typhoonView alloc] initWithFrame:CGRectMake(0,40, self.view.frame.size.width, kScreenHeitht-40-self.barHeight)];
    m_typhoonView.tfmds=self.tfmodels;
    [m_typhoonView setDelegate:self];
    [m_typhoonView setMapModel:tf_yearModel];
    [self.bgview addSubview:m_typhoonView];
    [m_typhoonView showMapRoute];
    [m_typhoonView changeMapMode:m_mapMode];
   
}

- (void) getTyphoonDetailData:(NSString *)code
{
    
    [self.tfmodels removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *tfpath = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    
    
    
    [tfpath setObject:code forKey:@"code"];
    [t_b setObject:tfpath forKey:@"gz_typho_path"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
//        NSLog(@"%@",returnData);
        if (t_dic == nil)
        {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            return;
        }
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        if (t_b != nil)
        {
            NSDictionary *typhoon = [[t_b objectForKey:@"gz_typho_path"] objectForKey:@"typhoon"];
            
            tf_yearModel = [[typhoonYearModel alloc] init];
            tf_yearModel.name = [typhoon objectForKey:@"name"];
            tf_yearModel.code = [typhoon objectForKey:@"code"];
            m_title = tf_yearModel.name;
            NSString *warnbill=[typhoon objectForKey:@"warn_bill"];
            self.warnbill=warnbill;
            //            [self setTitle:m_title];
//            self.titleLab.text=m_title;
            NSArray *t_arr0 = [typhoon objectForKey:@"tokyo_path"];
            NSMutableArray *t_tf0 = [NSMutableArray arrayWithCapacity:4];
            for (int i=0; i<[t_arr0 count]; i++) {
                typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
                
                detailModel.jd = [[t_arr0 objectAtIndex:i] objectForKey:@"longitude"];
                detailModel.tip = [[t_arr0 objectAtIndex:i] objectForKey:@"tip"];
                detailModel.wd = [[t_arr0 objectAtIndex:i] objectForKey:@"latitude"];
                detailModel.time = [[t_arr0 objectAtIndex:i] objectForKey:@"time"];
                detailModel.fl = [[t_arr0 objectAtIndex:i] objectForKey:@"fl"];
                detailModel.fs = [[t_arr0 objectAtIndex:i] objectForKey:@"fs"];
                detailModel.qx = [[t_arr0 objectAtIndex:i] objectForKey:@"qx"];
                if (detailModel.jd.intValue>=180) {
                    detailModel.jd=@"179.99";
                }
                [t_tf0 addObject:detailModel];
                //				[detailModel release];
            }
            tf_yearModel.dotted_1_points = t_tf0;
            
            NSArray *t_arr1 = [typhoon objectForKey:@"fuzhou_path"];
            NSMutableArray *t_tf1 = [NSMutableArray arrayWithCapacity:4];
            for (int i=0; i<[t_arr1 count]; i++) {
                typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
                
                detailModel.jd = [[t_arr1 objectAtIndex:i] objectForKey:@"longitude"];
                detailModel.tip = [[t_arr1 objectAtIndex:i] objectForKey:@"tip"];
                detailModel.wd = [[t_arr1 objectAtIndex:i] objectForKey:@"latitude"];
                detailModel.time = [[t_arr1 objectAtIndex:i] objectForKey:@"time"];
                detailModel.fl = [[t_arr1 objectAtIndex:i] objectForKey:@"fl"];
                detailModel.fs = [[t_arr1 objectAtIndex:i] objectForKey:@"fs"];
                detailModel.qx = [[t_arr1 objectAtIndex:i] objectForKey:@"qx"];
                if (detailModel.jd.intValue>=180) {
                    detailModel.jd=@"179.99";
                }
                [t_tf1 addObject:detailModel];
                //				[detailModel release];
            }
            tf_yearModel.dotted_2_points = t_tf1;
            
            NSArray *t_arr2 = [typhoon objectForKey:@"beijing_path"];
            NSMutableArray *t_tf2 = [NSMutableArray arrayWithCapacity:4];
            for (int i=0; i<[t_arr2 count]; i++) {
                typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
                
                detailModel.jd = [[t_arr2 objectAtIndex:i] objectForKey:@"longitude"];
                detailModel.tip = [[t_arr2 objectAtIndex:i] objectForKey:@"tip"];
                detailModel.wd = [[t_arr2 objectAtIndex:i] objectForKey:@"latitude"];
                detailModel.time = [[t_arr2 objectAtIndex:i] objectForKey:@"time"];
                detailModel.fl = [[t_arr2 objectAtIndex:i] objectForKey:@"fl"];
                detailModel.fs = [[t_arr2 objectAtIndex:i] objectForKey:@"fs"];
                detailModel.qx = [[t_arr2 objectAtIndex:i] objectForKey:@"qx"];
                if (detailModel.jd.intValue>=180) {
                    detailModel.jd=@"179.99";
                }
                [t_tf2 addObject:detailModel];
                //				[detailModel release];
            } 
            tf_yearModel.dotted_points = t_tf2;
            //台湾预测
            NSArray *t_arr4 = [typhoon objectForKey:@"taiwan_path"];
            NSMutableArray *t_tf4 = [NSMutableArray arrayWithCapacity:4];
            for (int i=0; i<[t_arr4 count]; i++) {
                typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
                
                detailModel.jd = [[t_arr4 objectAtIndex:i] objectForKey:@"longitude"];
                detailModel.tip = [[t_arr4 objectAtIndex:i] objectForKey:@"tip"];
                detailModel.wd = [[t_arr4 objectAtIndex:i] objectForKey:@"latitude"];
                detailModel.time = [[t_arr4 objectAtIndex:i] objectForKey:@"time"];
                detailModel.fl = [[t_arr4 objectAtIndex:i] objectForKey:@"fl"];
                detailModel.fs = [[t_arr4 objectAtIndex:i] objectForKey:@"fs"];
                detailModel.qx = [[t_arr4 objectAtIndex:i] objectForKey:@"qx"];
                if (detailModel.jd.intValue>=180) {
                    detailModel.jd=@"179.99";
                }
                
                [t_tf4 addObject:detailModel];
            }
            tf_yearModel.dotted_3_points = t_tf4;
            
            NSArray *t_arr3 = [typhoon objectForKey:@"true_path"];
            NSMutableArray *t_tf3 = [NSMutableArray arrayWithCapacity:4];
            for (int i=0; i<[t_arr3 count]; i++) {
                typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
                
                detailModel.fl = [[t_arr3 objectAtIndex:i] objectForKey:@"wind_power_center"];
                detailModel.fl_10 = [[t_arr3 objectAtIndex:i] objectForKey:@"wind_power_10"];
                detailModel.fl_7 = [[t_arr3 objectAtIndex:i] objectForKey:@"wind_power_7"];
                detailModel.fs = [[t_arr3 objectAtIndex:i] objectForKey:@"fs"];
                detailModel.fs_max = [[t_arr3 objectAtIndex:i] objectForKey:@"wind_speed_max"];
                detailModel.jd = [[t_arr3 objectAtIndex:i] objectForKey:@"longitude"];
                detailModel.qy = [[t_arr3 objectAtIndex:i] objectForKey:@"air_pressure"];
                detailModel.time = [[t_arr3 objectAtIndex:i] objectForKey:@"time"];
                detailModel.tip = [[t_arr3 objectAtIndex:i] objectForKey:@"tip"];
                detailModel.wd = [[t_arr3 objectAtIndex:i] objectForKey:@"latitude"];
                detailModel.ydss=[[t_arr3 objectAtIndex:i] objectForKey:@"wind_speed"];//移动时速
                if (detailModel.jd.intValue>=180) {
                    detailModel.jd=@"179.99";
                }
                
                [t_tf3 addObject:detailModel];
                //				[detailModel release];
            }
            tf_yearModel.ful_points = t_tf3;
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self.tfmodels addObject:tf_yearModel];
            [self performSelector:@selector(tflistdrawTyphoonMap)];
        }
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
    
    
}
#pragma mark 台风列表
-(void)tfActionwith:(NSMutableArray *)mytflist{
    if (newtflistview) {
        [newtflistview removeFromSuperview];
        newtflistview=nil;
    }
    [self.tfmodels removeAllObjects];
    if (mytflist.count>0) {
        self.cancj=YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        //    NSArray *arr=[[NSArray alloc]initWithObjects:@"1518",@"1520",@"1521", nil];
        NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
        NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
        [h setObject:[setting sharedSetting].app forKey:@"p"];
        
        for(int i=0;i<mytflist.count;i++)
        {
            NSMutableDictionary * sstq = [[NSMutableDictionary alloc] init];
            NSString *code=[mytflist[i] objectForKey:@"code"];
            [sstq setObject:code forKey:@"code"];
            [b setObject:sstq forKey:[NSString stringWithFormat:@"gz_typho_path#%@",code]];
        }
        
        
        NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
        [param setObject:h forKey:@"h"];
        [param setObject:b forKey:@"b"];
        [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:param withFlag:10 withSuccess:^(NSDictionary *returnData) {
            if (returnData == nil)
            {
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                return;
            }
            NSDictionary *t_b = [returnData objectForKey:@"b"];
            if (t_b != nil)
            {
                for (int i=0; i<mytflist.count; i++) {
                    NSString *code=[mytflist[i] objectForKey:@"code"];
                    NSString *tf=[NSString stringWithFormat:@"gz_typho_path#%@",code];
                    NSDictionary *tfp=[t_b objectForKey:tf];
                    NSDictionary *typhoon = [tfp  objectForKey:@"typhoon"];
                    
                    tf_yearModel = [[typhoonYearModel alloc] init];
                    tf_yearModel.name = [typhoon objectForKey:@"name"];
                    tf_yearModel.code = [typhoon objectForKey:@"code"];
                    m_title = tf_yearModel.name;
                    NSString *warnbill=[typhoon objectForKey:@"warn_bill"];
                    self.warnbill=warnbill;
                    self.tfcode=tf_yearModel.code;
                    //            [self setTitle:m_title];
                    //            self.titleLab.text=m_title;
                    [self.tflistbtn setTitle:m_title forState:UIControlStateNormal];
                    NSArray *t_arr0 = [typhoon objectForKey:@"tokyo_path"];
                    NSMutableArray *t_tf0 = [NSMutableArray arrayWithCapacity:4];
                    for (int i=0; i<[t_arr0 count]; i++) {
                        typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
                        
                        detailModel.jd = [[t_arr0 objectAtIndex:i] objectForKey:@"longitude"];
                        detailModel.tip = [[t_arr0 objectAtIndex:i] objectForKey:@"tip"];
                        detailModel.wd = [[t_arr0 objectAtIndex:i] objectForKey:@"latitude"];
                        detailModel.time = [[t_arr0 objectAtIndex:i] objectForKey:@"time"];
                        detailModel.fl = [[t_arr0 objectAtIndex:i] objectForKey:@"fl"];
                        detailModel.fs = [[t_arr0 objectAtIndex:i] objectForKey:@"fs"];
                        detailModel.qx = [[t_arr0 objectAtIndex:i] objectForKey:@"qx"];
                        if (detailModel.jd.intValue>=180) {
                            detailModel.jd=@"179.99";
                        }
                        [t_tf0 addObject:detailModel];
                        //				[detailModel release];
                    }
                    tf_yearModel.dotted_1_points = t_tf0;
                    
                    NSArray *t_arr1 = [typhoon objectForKey:@"fuzhou_path"];
                    NSMutableArray *t_tf1 = [NSMutableArray arrayWithCapacity:4];
                    for (int i=0; i<[t_arr1 count]; i++) {
                        typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
                        
                        detailModel.jd = [[t_arr1 objectAtIndex:i] objectForKey:@"longitude"];
                        detailModel.tip = [[t_arr1 objectAtIndex:i] objectForKey:@"tip"];
                        detailModel.wd = [[t_arr1 objectAtIndex:i] objectForKey:@"latitude"];
                        detailModel.time = [[t_arr1 objectAtIndex:i] objectForKey:@"time"];
                        detailModel.fl = [[t_arr1 objectAtIndex:i] objectForKey:@"fl"];
                        detailModel.fs = [[t_arr1 objectAtIndex:i] objectForKey:@"fs"];
                        detailModel.qx = [[t_arr1 objectAtIndex:i] objectForKey:@"qx"];
                        if (detailModel.jd.intValue>=180) {
                            detailModel.jd=@"179.99";
                        }
                        [t_tf1 addObject:detailModel];
                        //				[detailModel release];
                    }
                    tf_yearModel.dotted_2_points = t_tf1;
                    
                    NSArray *t_arr2 = [typhoon objectForKey:@"beijing_path"];
                    NSMutableArray *t_tf2 = [NSMutableArray arrayWithCapacity:4];
                    for (int i=0; i<[t_arr2 count]; i++) {
                        typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
                        
                        detailModel.jd = [[t_arr2 objectAtIndex:i] objectForKey:@"longitude"];
                        detailModel.tip = [[t_arr2 objectAtIndex:i] objectForKey:@"tip"];
                        detailModel.wd = [[t_arr2 objectAtIndex:i] objectForKey:@"latitude"];
                        detailModel.time = [[t_arr2 objectAtIndex:i] objectForKey:@"time"];
                        detailModel.fl = [[t_arr2 objectAtIndex:i] objectForKey:@"fl"];
                        detailModel.fs = [[t_arr2 objectAtIndex:i] objectForKey:@"fs"];
                        detailModel.qx = [[t_arr2 objectAtIndex:i] objectForKey:@"qx"];
                        if (detailModel.jd.intValue>=180) {
                            detailModel.jd=@"179.99";
                        }
                        [t_tf2 addObject:detailModel];
                        //				[detailModel release];
                    }
                    tf_yearModel.dotted_points = t_tf2;
                    
                    //台湾预测
                    NSArray *t_arr4 = [typhoon objectForKey:@"taiwan_path"];
                    NSMutableArray *t_tf4 = [NSMutableArray arrayWithCapacity:4];
                    for (int i=0; i<[t_arr4 count]; i++) {
                        typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
                        
                        detailModel.jd = [[t_arr4 objectAtIndex:i] objectForKey:@"longitude"];
                        detailModel.tip = [[t_arr4 objectAtIndex:i] objectForKey:@"tip"];
                        detailModel.wd = [[t_arr4 objectAtIndex:i] objectForKey:@"latitude"];
                        detailModel.time = [[t_arr4 objectAtIndex:i] objectForKey:@"time"];
                        detailModel.fl = [[t_arr4 objectAtIndex:i] objectForKey:@"fl"];
                        detailModel.fs = [[t_arr4 objectAtIndex:i] objectForKey:@"fs"];
                        detailModel.qx = [[t_arr4 objectAtIndex:i] objectForKey:@"qx"];
                        if (detailModel.jd.intValue>=180) {
                            detailModel.jd=@"179.99";
                        }
                        
                        [t_tf4 addObject:detailModel];
                    }
                    tf_yearModel.dotted_3_points = t_tf4;
                    
                    NSArray *t_arr3 = [typhoon objectForKey:@"true_path"];
                    NSMutableArray *t_tf3 = [NSMutableArray arrayWithCapacity:4];
                    for (int i=0; i<[t_arr3 count]; i++) {
                        typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
                        
                        detailModel.fl = [[t_arr3 objectAtIndex:i] objectForKey:@"wind_power_center"];
                        detailModel.fl_10 = [[t_arr3 objectAtIndex:i] objectForKey:@"wind_power_10"];
                        detailModel.fl_7 = [[t_arr3 objectAtIndex:i] objectForKey:@"wind_power_7"];
                        detailModel.fs = [[t_arr3 objectAtIndex:i] objectForKey:@"fs"];
                        detailModel.fs_max = [[t_arr3 objectAtIndex:i] objectForKey:@"wind_speed_max"];
                        detailModel.jd = [[t_arr3 objectAtIndex:i] objectForKey:@"longitude"];
                        detailModel.qy = [[t_arr3 objectAtIndex:i] objectForKey:@"air_pressure"];
                        detailModel.time = [[t_arr3 objectAtIndex:i] objectForKey:@"time"];
                        detailModel.tip = [[t_arr3 objectAtIndex:i] objectForKey:@"tip"];
                        detailModel.wd = [[t_arr3 objectAtIndex:i] objectForKey:@"latitude"];
                        detailModel.ydss=[[t_arr3 objectAtIndex:i] objectForKey:@"wind_speed"];//移动时速
                        if (detailModel.jd.intValue>=180) {
                            detailModel.jd=@"179.99";
                        }
                        
                        [t_tf3 addObject:detailModel];
                        //				[detailModel release];
                    }
                    tf_yearModel.ful_points = t_tf3;
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                    [self.tfmodels addObject:tf_yearModel];
                    
                }
                [self performSelector:@selector(tflistdrawTyphoonMap)];
            }
            
            
            
        } withFailure:^(NSError *error) {
            NSLog(@"failure");
            
        } withCache:YES];
    }else{
        m_btnPlay.title = @"播放";
        self.cancj=NO;
        [self performSelector:@selector(tflistdrawTyphoonMap)];
    }
    
}


- (void)tflistdrawTyphoonMap
{
//    if (m_typhoonView) {
//        [m_typhoonView removeFromSuperview];
//        m_typhoonView = nil;
//    }
//    m_typhoonView = [[typhoonView alloc] initWithFrame:CGRectMake(0,40, self.view.frame.size.width, kScreenHeitht-40-self.barHeight)];
//    [m_typhoonView setDelegate:self];
    [m_typhoonView.mapView removeOverlays:m_typhoonView.mapView.overlays];
    [m_typhoonView.mapView removeAnnotations:m_typhoonView.mapView.annotations];
    m_typhoonView.tfmds=self.tfmodels;
    for (int i=0; i<self.tfmodels.count; i++) {
        [m_typhoonView setMapModel:self.tfmodels[i]];
        //        [m_typhoonView didStopMap];
        [m_typhoonView showMapRoute];
        [m_typhoonView changeMapMode:m_mapMode];
    }
    [self.bgview addSubview:m_typhoonView];
    
}

#pragma mark the 5 bottom btn action
- (void) playMap
{
    if (self.cancj==YES) {
    if (self.isbofang==NO)
    {
        [m_typhoonView didPlayMap];
        m_btnPlay.image=[UIImage imageNamed:@"暂停按钮.png"];
        self.isbofang=YES;
    }else if (self.isbofang==YES)
    {
        [m_typhoonView didStopMap];
        m_btnPlay.image=[UIImage imageNamed:@"播放按钮.png"];
        self.isbofang=NO;
//        [self tyAction];
    }
    }
    
//    if ([m_btnPlay.title isEqualToString:@"播放"])
//    {
//        [m_typhoonView didPlayMap];
//        m_btnPlay.title = @"停止";
//    }
//    else if ([m_btnPlay.title isEqualToString:@"停止"])
//    {
//        [m_typhoonView didStopMap];
//        m_btnPlay.title = @"播放";
//    }

}
- (void) playMapOver
{
//    [self.bfbtn setTitle:@"播放" forState:UIControlStateNormal];
//    m_btnPlay.title = @"播放";
     m_btnPlay.image=[UIImage imageNamed:@"播放按钮.png"];
    self.isbofang=NO;
   
}
- (void) find
{
    if (self.cancj==YES) {
        [m_typhoonView didFindSelf];}
}
-(void)warnaction{
     [self.navigationController setToolbarHidden:YES animated:YES];
    WarnBillViewController *web=[[WarnBillViewController alloc]init];
//    web.url=self.warnbill;
    web.code=self.tfcode;
    web.titleString=@"台风警报单";
    [self.navigationController pushViewController:web animated:YES];
}
- (void) explain
{
    [m_typhoonView didStopMap];
    m_btnPlay.title = @"播放";
    m_btnPlay.image=[UIImage imageNamed:@"播放按钮.png"];
    self.isbofang=NO;
//    [self.bfbtn setTitle:@"播放" forState:UIControlStateNormal];
//    if (self.isexpent==NO) {
//        m_viewLegend = [[UIView alloc] initWithFrame:CGRectMake(0,self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight)];
//        
//        [self.view addSubview:m_viewLegend];
//        
//        
//        UIImageView *t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht-self.barHeight)];
//        [t_imageView setBackgroundColor:[UIColor clearColor]];
//        [t_imageView setImage:[UIImage imageNamed:@"imageExplain.png"]];
//        [m_viewLegend addSubview:t_imageView];
//        [m_viewLegend bringSubviewToFront:t_imageView];
//        UIButton *t_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeitht)];
//        [t_btn addTarget:self action:@selector(hiddentlview) forControlEvents:UIControlEventTouchUpInside];
//        [m_viewLegend addSubview:t_btn];
//        self.isexpent=YES;
//    }
    [self.navigationController setToolbarHidden:YES animated:YES];
    TLViewController *tlvc=[[TLViewController alloc]init];
    [self.navigationController pushViewController:tlvc animated:YES];
}
-(void)hiddentlview{
    if (self.isexpent==YES) {
        [m_viewLegend removeFromSuperview];
        self.isexpent=NO;
    }
}
- (void) change
{
    [m_typhoonView didChangeMap];
}
-(void)tflistdidSelect:(TFListView *)list withIndex:(NSInteger)index{
    typhoonYearModel *ty=tf_list[index];
    NSString *name=ty.name;
    NSString *code=ty.code;
    self.tfcode=code;
    [self.tflistview.button setTitle:name forState:UIControlStateNormal];
    [self getTyphoonDetailData:code];
}
-(void)tflistAction{
    if (self.isbofang==YES)
    {
        [m_typhoonView didStopMap];
        m_btnPlay.image=[UIImage imageNamed:@"播放按钮.png"];
        self.isbofang=NO;
    }
    if (newtflistview) {
        [newtflistview removeFromSuperview];
        newtflistview=nil;
    }else{
    newtflistview =[[NewTflistView alloc]initWithFrame:CGRectMake(20, 140, kScreenWidth-40, 300) WithTFdatas:tf_list];
    newtflistview.delegate=self;
        [newtflistview show];
    }
}
- (void)keyboardWillHide:(NSNotification *)notification {
//    if (startsearchBar) {
//        [startsearchBar removeFromSuperview];
//        [searchDisplayController.searchResultsTableView removeFromSuperview];
//    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
