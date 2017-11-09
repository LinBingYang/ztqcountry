//
//  LivePhotoViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-7.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "LivePhotoViewController.h"
#import "JSONKit.h"
#import "SinglePhotoViewController.h"
#import "LGViewController.h"
#import "PersonalCenterVC.h"

#import "SJKPmodel.h"
#import "EGOImageView.h"
#import "XGPush.h"
#import "EGORefreshTableHeaderView.h"
#import "CommentViewController.h"
#import "GRZXViewController.h"
#import "FBViewController.h"
#import "QXXZBViewController.h"
@interface LivePhotoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,EGORefreshTableHeaderDelegate>

@property (strong, nonatomic) EGORefreshTableHeaderView * refreshHeaderView;
@property (strong, nonatomic) NSMutableArray *datas;
@property (strong, nonatomic) UIImage *chooseImage  ;

@property(strong,nonatomic)NSMutableArray *sjkparr;
@end

@implementation LivePhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataview) name:@"updatesjkp" object:nil];
    self.barHiden = NO;
    self.titleLab.text = @"实景开拍";
    self.titleLab.textColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.marr=[[NSMutableArray alloc]init];
    self.xialaarr=[[NSMutableArray alloc]init];
    self.page=1;
    self.userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
//    [self.leftBut addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * camera = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-15-30-15-35, self.leftBut.frame.origin.y-3, 35, 35)];
    [camera addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [camera setBackgroundImage:[UIImage imageNamed:@"实景开拍常态.png"] forState:UIControlStateNormal];
    [camera setBackgroundImage:[UIImage imageNamed:@"实景开拍二态.png"] forState:UIControlStateHighlighted];
    [self.navigationBarBg addSubview:camera];
    
    UIButton * login = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-15-35, self.leftBut.frame.origin.y-3, 35, 35)];
    [login addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [login setBackgroundImage:[UIImage imageNamed:@"个人中心常态.png"] forState:UIControlStateNormal];
    [login setBackgroundImage:[UIImage imageNamed:@"个人中心二态.png"] forState:UIControlStateHighlighted];
    [self.navigationBarBg addSubview:login];
    
    self.sjkparr=[[NSMutableArray alloc]init];
    self.alldatas=[[NSMutableArray alloc]init];
    
    self.acsheetview=[[CustomSheet alloc]initWithupbtn:@"拍照" Withdownbtn:@"相册" WithCancelbtn:@"取消" withDelegate:self];
    [self.acsheetview show];
    
    //创建banners
    self.bmadscro = [[BannerSCRView alloc] initWithNameArr:nil titleArr:nil height:150
                                                   offsetY:self.barHeight offsetx:0];
    self.bmadscro.backgroundColor=[UIColor clearColor];
    self.bmadscro.vDelegate = self;
    [self.view addSubview:self.bmadscro];
//    [self readxml];
    [self getBaner];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self getBaner];
    [self updateMainView];
}


-(void)getBaner{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sjkpindex = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    
    [t_b setObject:sjkpindex forKey:@"gz_scenery_banner"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];

    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
       
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *sjkpindex=[t_b objectForKey:@"gz_scenery_banner"];
        NSArray *adlist=[sjkpindex objectForKey:@"banner_list"];
        self.baners=adlist;
        self.banseimgurls=[[NSMutableArray alloc]init];
        self.banersurl=[[NSMutableArray alloc]init];
        self.banerstitls=[[NSMutableArray alloc]init];
        self.bannershares=[[NSMutableArray alloc]init];
        
        if (adlist.count>0) {
            for (int i=0;i<adlist.count; i++) {
                NSString *link_url=[adlist[i] objectForKey:@"link_url"];
                NSString *title=[adlist[i] objectForKey:@"title"];
                NSString *imgpath=[adlist[i] objectForKey:@"img_path"];
                NSString *fx_content=[adlist[i] objectForKey:@"fx_content"];
                [self.banseimgurls addObject:imgpath];
                [self.banersurl addObject:link_url];
                [self.banerstitls addObject:title];
                [self.bannershares addObject:fx_content];
            }
            self.bmadscro.frame=CGRectMake(0, self.barHeight, kScreenWidth, 150);
            [self.bmadscro getNameArr:self.banseimgurls  titleArr:self.banerstitls height:150
                              offsetY:0 offsetx:0];
        }else{
            self.bmadscro.frame=CGRectMake(0, self.barHeight, kScreenWidth, 0);
        }
        
        //获取实景数据
        [self getSJKPdata];
        [self getalldata];
        
    } withFailure:^(NSError *error) {
        self.bmadscro.frame=CGRectMake(0, self.barHeight, kScreenWidth, 0);
        //获取实景数据
        [self getSJKPdata];
        [self getalldata];
    } withCache:YES];
}
-(void)updataview{
    if (self.waterView) {
        [self.waterView removeFromSuperview];
    }
    [self getSJKPdata];
}
-(void)getSJKPdata{
  
    
    NSString *pagestr=[NSString stringWithFormat:@"%d",self.page];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sjkpindex = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [sjkpindex setObject:@"16" forKey:@"count"];
    [sjkpindex setObject:pagestr forKey:@"page"];
   
         [sjkpindex setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    
   
    if (self.userid.length>0) {
         [sjkpindex setObject:self.userid forKey:@"user_id"];
    }else{
        [sjkpindex setObject:[setting getSysUid]forKey:@"imei"];
    }
    [t_b setObject:sjkpindex forKey:@"gz_scenery_index"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
     [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *sjkpindex=[t_b objectForKey:@"gz_scenery_index"];
        NSMutableArray *idx=[sjkpindex objectForKey:@"scenery_list"];
        if (!idx.count>0) {
            UIView *allview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bmadscro.frame)+50, kScreenWidth, kScreenHeitht)];
            [self.view addSubview:allview];
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
            lab.text=@"暂无图片，赶快发图吧!";
            lab.textAlignment=NSTextAlignmentCenter;
            lab.font=[UIFont systemFontOfSize:15];
            [allview addSubview:lab];
        }
        
        NSMutableArray *arrayImage = [[NSMutableArray alloc]init];
        for (int j=0; j<[idx count]; j++) {
           NSDictionary *dataD = [idx objectAtIndex:j];
         
            if (dataD) {
    
                ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD];
                [arrayImage addObject:imageInfo];
                [self.xialaarr addObject:imageInfo];
//                imageInfo.address = [setting sharedSetting].currentCity;
            }
        }
        self.marr=arrayImage;
//        NSLog(@"%@^^^%d",arrayImage,arrayImage.count);
        self.waterView = [[ImageWaterView alloc]initWithDataArray:self.marr withFrame:CGRectMake(0, CGRectGetMaxY(self.bmadscro.frame)+5, kScreenWidth, kScreenHeitht-CGRectGetMaxY(self.bmadscro.frame)-5)];
        self.waterView.delegate = self;
        [self.view addSubview:self.waterView];
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.waterView.bounds.size.height, self.waterView.frame.size.width, self.waterView.frame.size.height)];
        view.delegate = self;
        [self.waterView addSubview:view];
        _refreshHeaderView = view;
        
//        [self refreshview];
        
//        [self getBaner];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } withCache:YES];

}
-(void)updateMainView{
    [self getdata];
}
-(void)getdata{
    
    self.page=1;
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sjkpindex = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [sjkpindex setObject:@"16" forKey:@"count"];//原来6个元素，
    [sjkpindex setObject:@"1" forKey:@"page"];
    [sjkpindex setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    if (self.userid.length>0) {
        [sjkpindex setObject:self.userid forKey:@"user_id"];
    }else{
        if ([setting getSysUid].length>0) {
            [sjkpindex setObject:[setting getSysUid]forKey:@"imei"];
        }
        
    }

    [t_b setObject:sjkpindex forKey:@"gz_scenery_index"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *sjkpindex=[t_b objectForKey:@"gz_scenery_index"];
        NSMutableArray *idx=[sjkpindex objectForKey:@"scenery_list"];
        
        
        NSMutableArray *arrayImage = [[NSMutableArray alloc]init];
        for (int j=0; j<[idx count]; j++) {
            NSDictionary *dataD = [idx objectAtIndex:j];
            
            if (dataD) {
                
                ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD];
                [arrayImage addObject:imageInfo];
                [self.xialaarr addObject:imageInfo];
                //                imageInfo.address = [setting sharedSetting].currentCity;
            }
        }
        self.marr=arrayImage;
        [self.waterView refreshView:self.marr];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } withCache:YES];
    
}
-(void)getnextdata{
    NSString *pagestr=[NSString stringWithFormat:@"%d",self.page];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sjkpindex = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [sjkpindex setObject:@"16" forKey:@"count"];
    [sjkpindex setObject:pagestr forKey:@"page"];
    [sjkpindex setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    if (self.userid.length>0) {
        [sjkpindex setObject:self.userid forKey:@"user_id"];
    }else{
        [sjkpindex setObject:[setting getSysUid]forKey:@"imei"];
    }

    [t_b setObject:sjkpindex forKey:@"gz_scenery_index"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *sjkpindex=[t_b objectForKey:@"gz_scenery_index"];
        NSMutableArray *idx=[sjkpindex objectForKey:@"scenery_list"];
        
        
        NSMutableArray *arrayImage = [[NSMutableArray alloc]init];
        for (int j=0; j<[idx count]; j++) {
            NSDictionary *dataD = [idx objectAtIndex:j];
            
            if (dataD) {
                
                ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD];
                [arrayImage addObject:imageInfo];
            }
        }
        self.marr=arrayImage;
        [self.waterView loadNextPage:self.marr];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } withCache:YES];
}

-(void)getalldata{
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sjkpindex = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [sjkpindex setObject:@"50" forKey:@"count"];
    [sjkpindex setObject:@"1" forKey:@"page"];
    [sjkpindex setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    if (self.userid.length>0) {
        [sjkpindex setObject:self.userid forKey:@"user_id"];
    }else{
        [sjkpindex setObject:[setting getSysUid]forKey:@"imei"];
    }
    
    [t_b setObject:sjkpindex forKey:@"gz_scenery_index"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
//    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *sjkpindex=[t_b objectForKey:@"gz_scenery_index"];
        NSMutableArray *idx=[sjkpindex objectForKey:@"scenery_list"];
        
        
        NSMutableArray *arrayImage = [[NSMutableArray alloc]init];
        for (int j=0; j<[idx count]; j++) {
            NSDictionary *dataD = [idx objectAtIndex:j];
            
            if (dataD) {
                
                ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD];
             
                [arrayImage addObject:imageInfo];
               
            }
        }
        self.alldatas=arrayImage;

//        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } withCache:YES];
    
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.waterView];
    [self updateMainView];
}
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    
    //停止加载，弹回下拉
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    //    self.isPull = YES;
    return _reloading; // should return if data source model is reloading
    
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* inputDate = [NSDate date];
    return inputDate; // should return date data source was last changed
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
        if(scrollView.contentOffset.y <=0){
            
            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }else{
//            CGPoint offset = scrollView.contentOffset;
//            CGRect bounds = scrollView.bounds;
            CGSize size = scrollView.contentSize;
            UIEdgeInsets inset = scrollView.contentInset;
            CGFloat currentOffset = scrollView.contentOffset.y + scrollView.bounds.size.height - inset.bottom;
            CGFloat maximumOffset = size.height;
//            NSLog(@"%f,%f",currentOffset,maximumOffset);
            if (currentOffset-maximumOffset>60) {
                NSLog(@"1");
                self.page++;
                [self getnextdata];
            }
//             NSLog(@"%f,,%f",scrollView.contentOffset.y,scrollView.frame.size.height);
//            if (scrollView.contentOffset.y>(self.waterView.hi-scrollView.contentOffset.y)) {
//                NSLog(@"%f,,%f",scrollView.contentOffset.y,self.waterView.hi);
//                self.page++;
//                [self getnextdata];
//
//            }
            
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (kSystemVersionMore7) {
        
        if ([self.waterView window] == nil)// 是否是正在使用的视图
        {
            self.waterView = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }

    }
       // Dispose of any resources that can be recreated.
}


#pragma mark -ImageWaterViewDelegate
-(void)imageWaterViewCellClickWithInfo:(ImageInfo *)data
{
//    SinglePhotoViewController * singlePhotoVC = [[SinglePhotoViewController alloc] initWithImageData:data];
//    singlePhotoVC.single = 1;
//    [self.navigationController pushViewController:singlePhotoVC animated:YES];
    CommentViewController *comment=[[CommentViewController alloc]initWithImageData:data];
    comment.single=1;
    comment.imagedatas=self.alldatas;
    [self.navigationController pushViewController:comment animated:YES];
}
-(void)BanerbuttonClick:(int)vid{
    if (self.baners.count>0) {
        NSString *urlstr=[self.baners[vid-1] objectForKey:@"link_url"];
        NSString *target=[self.baners[vid-1] objectForKey:@"title"];
        NSString *fxc=[self.baners[vid-1] objectForKey:@"fx_content"];
        if (urlstr.length>0) {
            QXXZBViewController *webvc=[[QXXZBViewController alloc]init];
            webvc.url=urlstr;
            webvc.titleString=target;
            webvc.shareContent=fxc;
            [self.navigationController pushViewController:webvc animated:YES];
        }
        
    }
   
//    if ([target isEqualToString:@"qxmt"]) {
//        NewsViewController *news=[[NewsViewController alloc]init];
//        [self.navigationController pushViewController:news animated:YES];
//    }else{
//
//   
//       if (urlstr.length>0) {
//            WebViewController *webvc=[[WebViewController alloc]init];
//           webvc.titleString=@"专题";
//            webvc.url=urlstr;
//           [self.navigationController pushViewController:webvc animated:YES];
//    }
//        
//    }
}
-(void)cameraAction:(UIButton *)sender
{
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    actionSheet.tag = 100;
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
    
    
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
//    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
//        picker.delegate = self;
//        picker.allowsEditing = YES;//设置可编辑
//        picker.sourceType = sourceType;
//        //    [self presentModalViewController:picker animated:YES];//进入照相界面
//        [self presentViewController:picker animated:YES completion:nil];//进入照相界面
//    }
//    else
//    {
//        //        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"此设备不支持拍照功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        //        [alert show];
//        AnnounceViewController * announceVC = [[AnnounceViewController alloc] init];
//        announceVC.delegate = self;
//        [self.navigationController pushViewController:announceVC animated:YES];
//        announceVC.address = [setting sharedSetting].currentCity;
//        announceVC.weather = [NSString stringWithFormat:@"%@ 晴 30℃",[setting sharedSetting].currentCity];
//        announceVC.shareImg = [UIImage imageNamed:@"头像.png"];
//        
//    }
    
}


-(void)loginAction:(UIButton *)sender
{
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
    if(userName.length)
    {
//        PersonalCenterVC * personalCenter = [[PersonalCenterVC alloc] init];
//        personalCenter.type = 0;
//        personalCenter.backtype=@"1";
//        personalCenter.userImage = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"];
//        personalCenter.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
//        [self.navigationController pushViewController:personalCenter animated:YES];
        GRZXViewController *grzx=[[GRZXViewController alloc]init];
        [self.navigationController pushViewController:grzx animated:YES];
    }
    else
    {
        LGViewController * LGVC = [[LGViewController alloc] init];
        [self.navigationController pushViewController:LGVC animated:YES];
    }
}

#pragma mark -UIImagePickerControllerDelegate
//点击相册中的图片 货照相机照完后点击use  后触发的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    // Save the image to the album
//    UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
    [self dismissViewControllerAnimated:YES completion:nil];
    if(image)
    {
//        AnnounceViewController * announceVC = [[AnnounceViewController alloc] init];
//        announceVC.delegate = self;
//        announceVC.address = [setting sharedSetting].currentCity;
//        announceVC.weather = [NSString stringWithFormat:@"%@ 晴 30℃",[setting sharedSetting].currentCity];
//        announceVC.shareImg = image;
//        [self.navigationController pushViewController:announceVC animated:YES];
        
        FBViewController *fbvc=[[FBViewController alloc]init];
        fbvc.fbimage=image;
        fbvc.parentid=self.parentid;
        [self.navigationController pushViewController:fbvc animated:NO];
    }
//    //    [picker release];
//    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"放弃" destructiveButtonTitle:@"存储" otherButtonTitles:nil, nil];
//    actionSheet.tag = 200;
//    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//    [actionSheet showInView:self.view];

}

//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    
//}
- (void)imagedidFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    // Handle the end of the image write process
    if (!error)
        NSLog(@"成功");
    else
        NSLog(@"%@",[error localizedDescription]);
}


-(void)AnnounceClickWithInfo:(NSDictionary *)info_dic
{
//    NSLog(@"%@",info_dic);
    ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:info_dic];
    imageInfo.userImageData = [info_dic objectForKey:@"userImageData"];
    imageInfo.imageData = [info_dic objectForKey:@"imageData"];
    [self.datas insertObject:imageInfo atIndex:0];
    [self.waterView refreshView:self.datas];
}


#pragma mark -UIAcitonSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 100)
    {
        if(buttonIndex == 2)
        {
            
        }
        else
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = YES;//设置可编辑
            if(buttonIndex == 0)
            {
                //            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
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
            else if (buttonIndex == 1)
            {
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            if([UIImagePickerController isSourceTypeAvailable:picker.sourceType])
            {
                [self presentViewController:picker animated:YES completion:nil];
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"此设备不支持拍照功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }

    }
//    else if(actionSheet.tag == 200)
//    {
//        if(buttonIndex == 1)
//        {
//            
//        }
//        else
//        {
//            UIImage *image = [self.imageInfo objectForKey:@"UIImagePickerControllerOriginalImage"];
//            // Save the image to the album
//            UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
//            [self dismissViewControllerAnimated:YES completion:nil];
//            if(image)
//            {
//                AnnounceViewController * announceVC = [[AnnounceViewController alloc] init];
//                announceVC.delegate = self;
//                announceVC.address = [setting sharedSetting].currentCity;
//                announceVC.weather = [NSString stringWithFormat:@"%@ 晴 30℃",[setting sharedSetting].currentCity];
//                announceVC.shareImg = image;
//
//                [self.navigationController pushViewController:announceVC animated:YES];
//            }
//            //    [picker release];
//            
//        }
//    }
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

/*
 
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
