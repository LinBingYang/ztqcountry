//
//  GRZXViewController.m
//  ztqFj
//
//  Created by Admin on 15-1-19.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "GRZXViewController.h"
#import "PersonCenterModel.h"
#import "EGOImageView.h"
#import "CommentViewController.h"
#import "FBViewController.h"
#import "UILabel+utils.h"
#import "EditGRXXController.h"
#import "MJRefreshFooterView.h"
@interface GRZXViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,MJRefreshBaseViewDelegate>
@property(strong,nonatomic)NSMutableArray *shareContents;
@property(nonatomic,strong) NSMutableArray *yearDatas;
@property(nonatomic,assign) int deleRow;
@property(nonatomic,assign) int pageNum;
@property(nonatomic,strong) MJRefreshFooterView *footer;
@end

@implementation GRZXViewController
-(void)setShareContents:(NSMutableArray *)shareContents
{
    _shareContents=shareContents;
    //判断年份并且显示
    NSMutableArray *array=[NSMutableArray array];
    
    NSString *oldyear=@"";
    for(int i=0;i<_shareContents.count;i++)
    {
        NSDictionary *data1=_shareContents[i];
        NSString *date_time=data1[@"date_time"];
        if (date_time.length>0) {
            NSString *year=[date_time substringToIndex:4];
            if (![oldyear isEqualToString:year]) {
                NSMutableDictionary *dicr=[NSMutableDictionary dictionary];
                [dicr setObject:year forKey:@"year"];
                [dicr setObject:@(i) forKey:@"idx"];
                [array addObject:dicr];
            }
            oldyear=year;
        }
        
        
        
    }
    if(array.count>0)
    {
        [array removeObjectAtIndex:0];
    }
    self.yearDatas=array;
    //    NSLog(@"%@",array);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    _shareContents = [[NSMutableArray alloc] init];
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [_navigationBarBg addSubview:leftimg];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserName) name:@"myname" object:nil];
    
    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    
//    [_leftBut setBackgroundImage:[UIImage imageNamed:@"jc返回.png"] forState:UIControlStateNormal];
//    [_leftBut setBackgroundImage:[UIImage imageNamed:@"jc返回点击.png"] forState:UIControlStateHighlighted];
    [_leftBut addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    UILabel *titleb= [[UILabel alloc] initWithFrame:CGRectMake(60, 12+place, kScreenWidth-120, 20)];
    titleb.textAlignment = NSTextAlignmentCenter;
    self.titleLab=titleb;
    titleb.font = [UIFont fontWithName:kBaseFont size:20];
    titleb.backgroundColor = [UIColor clearColor];
    titleb.textColor = [UIColor whiteColor];
    titleb.text=@"个人中心";
    [self.navigationBarBg addSubview:titleb];
    
    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    [_leftBut addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    _rightBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-70,24, 60, 30)];
    
    [_rightBut setBackgroundImage:[UIImage imageNamed:@"fkyj提交.png"] forState:UIControlStateNormal];
    [_rightBut setBackgroundImage:[UIImage imageNamed:@"fkyj提交点击.png"] forState:UIControlStateHighlighted];
    [_rightBut setTitle:@"退出" forState:UIControlStateNormal];
    [_rightBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBut addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_rightBut];
    _rightBut.titleLabel.font=[UIFont systemFontOfSize:15];
    
    self.view.backgroundColor=[UIColor whiteColor];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-self.barHeight)];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _table;
    footer.delegate=self;
    self.footer=footer;
    self.username=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjusername"];
    [self configData];
}
-(void)rightAction{
    NSString *name=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    if (name.length>0) {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"确认退出当前账号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alre show];
    }
}
-(void)updateUserName
{
    NSString *username=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjusername"];
    self.username=username;
    [self.table reloadData];
    
}

-(void)leftAction{
    if ([self.type isEqualToString:@"1"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//-(void)getuserinfos{
//    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
//    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
//    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
//    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:4];
//    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
//    [userInfo setObject:userName forKey:@"user_id"];
//    [t_b setObject:userInfo forKey:@"userinfo"];
//    [t_dic setObject:t_h forKey:@"h"];
//    [t_dic setObject:t_b forKey:@"b"];
//    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
//        // NSLog(@"%@",returnData);
//        
//        
//        NSDictionary *t_b = [returnData objectForKey:@"b"];
//        
//        if (t_b != nil)
//        {
//            NSDictionary *userinfo=[t_b objectForKey:@"userinfo"];
////            self.praiseCount=[userinfo objectForKey:@"praiseCount"];
////            self.imageCount=[userinfo objectForKey:@"imageCount"];
//            self.username=[userinfo objectForKey:@"name"];
////            self.userId=[userinfo objectForKey:@"userId"];
////            self.image=[userinfo objectForKey:@"image"];
//            
//            
//        }
//        [self.table reloadData];
//        
//    } withFailure:^(NSError *error) {
//        NSLog(@"failure");
//        
//    } withCache:YES];
//}
-(void)configData
{
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    if (userid.length>0) {
         [userCenterImage setObject:userid forKey:@"user_id"];
    }
    self.pageNum=1;
    [userCenterImage setObject:@(10) forKey:@"count"];
    [userCenterImage setObject:@(self.pageNum) forKey:@"page"];
    [t_b setObject:userCenterImage forKey:@"gz_user_center"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *userCenterImage=[t_b objectForKey:@"gz_user_center"];
              NSDictionary *userinfo=[userCenterImage objectForKey:@"userinfo"];
                NSString *head_url=[userinfo objectForKey:@"head_url"];
            if(head_url)
            {
                NSURL *url=[NSURL URLWithString:head_url];
                NSData *mydata = [NSData dataWithContentsOfURL:url];
                if (mydata) {
                    [[NSUserDefaults standardUserDefaults]setObject:mydata forKey:@"currendIco"];
                }
            }
            [_shareContents removeAllObjects];
            self.shareContents=[userCenterImage objectForKey:@"scenery_list"];
//            for (int i=0; i<_shareContents.count; i++) {
//                PersonCenterModel *pcmd=[[PersonCenterModel alloc]init];
//                pcmd.des=[[_shareContents objectAtIndex:i]objectForKey:@"des"];
//                pcmd.address=[[_shareContents objectAtIndex:i]objectForKey:@"address"];
//                pcmd.weather=[[_shareContents objectAtIndex:i]objectForKey:@"weather"];
//                pcmd.praise=[[_shareContents objectAtIndex:i]objectForKey:@"praise"];
//                pcmd.datetime=[[_shareContents objectAtIndex:i]objectForKey:@"datetime"];
//                pcmd.images=[[_shareContents objectAtIndex:i]objectForKey:@"images"];
//                [_shareContents addObject:pcmd];
//            }
        }
        [self.table reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } withCache:YES];
 
    
}
-(void)loadmoreCenterData
{
    self.pageNum++;
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    if (userid.length>0) {
        [userCenterImage setObject:userid forKey:@"user_id"];
    }
    [userCenterImage setObject:@(10) forKey:@"count"];
    [userCenterImage setObject:@(self.pageNum) forKey:@"page"];
    
    [t_b setObject:userCenterImage forKey:@"gz_user_center"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *userCenterImage=[t_b objectForKey:@"gz_user_center"];
            NSDictionary *userinfo=[userCenterImage objectForKey:@"userinfo"];
            NSString *head_url=[userinfo objectForKey:@"head_url"];
            if(head_url)
            {
                NSURL *url=[NSURL URLWithString:head_url];
                NSData *mydata = [NSData dataWithContentsOfURL:url];
                if (mydata) {
                    [[NSUserDefaults standardUserDefaults]setObject:mydata forKey:@"currendIco"];
                }
            }
                NSArray *newarray=[userCenterImage objectForKey:@"scenery_list"];
            NSMutableArray *muttempArray=[NSMutableArray array];
            muttempArray=self.shareContents;
            [muttempArray addObjectsFromArray:[userCenterImage objectForKey:@"scenery_list"]];
            self.shareContents=muttempArray;
            [self.footer endRefreshing];
            if(newarray.count < 10&&self.footer)
            {
            
                [self.footer removeFromSuperview];
                self.footer=nil;
                [self.table reloadData];
            }
        }
   
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } withCache:YES];
    
    
}
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.shareContents.count+2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 172;
    }else if (indexPath.row==1){
        return 95;
    }
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
      
        
        UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 172)];
        bgimg.image=[UIImage imageNamed:@"个人中心背景图720.jpg"];
        bgimg.userInteractionEnabled=YES;
        [cell addSubview:bgimg];
        
         UIImage * userImg = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"]];
        NSString *head_url=[[NSUserDefaults standardUserDefaults]  objectForKey:@"currendIcoUrl"];
        
    
        EGOImageView *tximg=[[EGOImageView alloc]initWithFrame:CGRectMake(kScreenWidth-120, 30, 70, 70)];
        tximg.center=CGPointMake(kScreenWidth/2, 80);
        if(head_url&&![@"" isEqualToString:head_url]){
            tximg.image=userImg;
        }else{
            tximg.image=[UIImage imageNamed:@"知天气头像.png"];
        }
        tximg.contentMode=UIViewContentModeScaleAspectFill;
        tximg.layer.cornerRadius=tximg.width*0.5;
        tximg.layer.masksToBounds=YES;
        tximg.userInteractionEnabled=YES;
        [bgimg addSubview:tximg];
        
//        UIImageView *icoimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-120, 30, 70, 70)];
//        icoimg.image=[UIImage imageNamed:@"次页头像框"];
//        icoimg.center=CGPointMake(kScreenWidth/2, 80);
//        icoimg.layer.masksToBounds = YES;
//        icoimg.userInteractionEnabled=YES;
//        icoimg.layer.cornerRadius=icoimg.width*0.5;
//        [bgimg addSubview:icoimg];
//         UIImage * userImg = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"]];
//        if (userImg) {
//            icoimg.image=userImg;
//        }
       
        UIButton *txBtn=[[UIButton alloc] initWithFrame:tximg.bounds];
        txBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [txBtn addTarget:self action:@selector(txbtnClick) forControlEvents:UIControlEventTouchUpInside];
        [tximg addSubview:txBtn];
        
//        UIImageView *nameimg=[[UIImageView alloc]initWithFrame:CGRectMake(150, 130, 110, 20)];
////        nameimg.image=[UIImage imageNamed:@"昵称框.png"];
//        nameimg.userInteractionEnabled=YES;
//        [bgimg addSubview:nameimg];
//        UIImageView *nameimg=[[UIImageView alloc]initWithFrame:CGRectMake(150, 130, 114, 27)];
//        nameimg.image=[UIImage imageNamed:@"昵称底色"];
//        nameimg.userInteractionEnabled=YES;
//        [bgimg addSubview:nameimg];
        
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(150, 130, 114, 27)];
        name.textAlignment=NSTextAlignmentCenter;
        name.text=self.username;
        name.font=[UIFont systemFontOfSize:14];
        name.textColor=[UIColor whiteColor];
        [cell addSubview:name];
//        float lablength=[name labelLength:self.username withFont:[UIFont systemFontOfSize:14]];
//        nameimg.frame=CGRectMake(150, 130, lablength+20, 20);
//        nameimg.center=CGPointMake(kScreenWidth/2, 140);
         name.centerX=kScreenWidth/2;
//        name.frame=CGRectMake(0, 0, lablength+20, 20);
    }else if(row==1){
        UIImageView *dataimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 35)];
        dataimg.image=[UIImage imageNamed:@"时间轴3"];
        [cell addSubview:dataimg];
        UILabel *data=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 40, 35)];
        data.text=@"今天";
//        data.textAlignment=NSTextAlignmentCenter;
        data.textColor=[UIColor whiteColor];
        data.font=[UIFont systemFontOfSize:12];
        [dataimg addSubview:data];
        UIImageView *lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(30, 35, 1, 80-35)];
        lineimg.image=[UIImage imageNamed:@"时间轴2"];
        [cell addSubview:lineimg];
        
        UIButton *carmaerbtn=[[UIButton alloc]initWithFrame:CGRectMake(80, 20, 70, 60)];
        [carmaerbtn setBackgroundImage:[UIImage imageNamed:@"开拍图标"] forState:UIControlStateNormal];
        [carmaerbtn addTarget:self action:@selector(carAction) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:carmaerbtn];
        carmaerbtn.center=CGPointMake(kScreenWidth/2, 45);
        
        UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(70, CGRectGetMaxY(carmaerbtn.frame)+15, kScreenWidth-100, 1)];
        bottomView.backgroundColor=[UIColor grayColor];
        [cell addSubview:bottomView];
        
    }else{
        NSDictionary *dic=[self.shareContents objectAtIndex:indexPath.row-2];
        UIImageView *dataimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 35)];
        dataimg.image=[UIImage imageNamed:@"时间轴3"];
        [cell addSubview:dataimg];
        UILabel *data=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50, 35)];
       NSString *date=[dic objectForKey:@"date_time"];
        
        NSString *address=[dic objectForKey:@"address"];
        UIImageView *locationImage=[[UIImageView alloc] initWithFrame:CGRectMake(60, 10, 15, 15)];
        locationImage.contentMode=UIViewContentModeScaleAspectFit;
        locationImage.image=[UIImage imageNamed:@"icon_address.png"];
        [cell.contentView addSubview:locationImage];
        UILabel *locationLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(locationImage.frame), 10, kScreenWidth-85, 30)];
        locationLabel.text=address;
         locationLabel.centerY=locationImage.centerY;
         locationLabel.numberOfLines=2;
        locationLabel.font=[UIFont systemFontOfSize:11];
        locationLabel.textColor=[UIColor grayColor];
        [cell.contentView addSubview:locationLabel];
        if (date.length>0) {
            NSString *time=[date substringFromIndex:5];
            NSString *datetime=[time substringToIndex:5];
            data.text=datetime;
            data.textColor=[UIColor whiteColor];
            data.numberOfLines=0;
            data.font=[UIFont systemFontOfSize:12];
            [dataimg addSubview:data];
        }
        
        UIImageView *lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(30, 35, 1, 100-35)];
        lineimg.image=[UIImage imageNamed:@"时间轴2"];
        [cell addSubview:lineimg];
//        NSArray *images=[dic objectForKey:@"images"];
//        if (images.count==1) {
            EGOImageView *egoimg=[[EGOImageView alloc]initWithFrame:CGRectMake((kScreenWidth-100)/2, 40, 100, 95)];
            NSString *imgurl=[dic objectForKey:@"thumbnail_path"];
           [egoimg setImageURL:[ShareFun makeImageUrl:imgurl]];
//            NSLog(@"%@",[ShareFun makeImageUrl:imgurl]);
//            UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(80, 20, 160, 80)];
//            photo.image=egoimg.image;
//        egoimg.center=CGPointMake(kScreenWidth/2, 70);
        egoimg.userInteractionEnabled=YES;
        egoimg.contentMode = UIViewContentModeScaleAspectFill;
        egoimg.clipsToBounds=YES;
        egoimg.userInteractionEnabled=YES;

        UIButton *egoimBtn=[[UIButton alloc] initWithFrame:egoimg.bounds];
        [egoimBtn addTarget:self action:@selector(cellImageClick:) forControlEvents:UIControlEventTouchUpInside];
        egoimBtn.tag=row;
        [egoimg addSubview:egoimBtn];
        for (int i=0; i<self.yearDatas.count; i++) {
            NSDictionary *yeardict=self.yearDatas[i];
            NSString *idx=yeardict[@"idx"];
            NSString *year=yeardict[@"year"];
            if (idx.intValue==row-1) {
                UILabel *yearLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(egoimg.frame), 70, 30)];
                yearLabel.text=[NSString stringWithFormat:@"%@年",year];
                yearLabel.font=[UIFont systemFontOfSize:14];
                yearLabel.textColor=[UIColor colorHelpWithRed:78 green:144 blue:212 alpha:1];
                yearLabel.textAlignment=NSTextAlignmentCenter;
                [cell addSubview:yearLabel];
            }
        }

        UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(70, CGRectGetMaxY(egoimg.frame)+15, kScreenWidth-100, 1)];
        bottomView.backgroundColor=[UIColor grayColor];
        [cell.contentView addSubview:bottomView];
        [cell.contentView addSubview:egoimg];
        
            [cell.contentView addSubview:egoimg];
//            [cell addSubview:egoimg];
//        }
//        else{
//            for (int i=0; i<images.count; i++) {
//                EGOImageView *egoimg=[[EGOImageView alloc]initWithFrame:CGRectMake(80+85*i, 20, 40, 40)];
//                NSString *imgurl=[images[i]objectForKey:@"url"];
//                [egoimg setImageURL:[ShareFun makeImageUrl:imgurl]];
//                [cell addSubview:egoimg];
//            }
//            
//        }
        UIButton *delePraiseBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(egoimg.frame)+5,  CGRectGetMaxY(egoimg.frame)-20, 25, 25)];
        [delePraiseBtn setTitle:@"删除" forState:UIControlStateNormal];
        delePraiseBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        delePraiseBtn.tag=row;
        [delePraiseBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [delePraiseBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:delePraiseBtn];

    }
        return cell;
}
-(void)cellImageClick:(UIButton *)btn
{
    if (btn.tag>=2) {
        NSDictionary *dic=[self.shareContents objectAtIndex:btn.tag-2];
        ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dic];
        CommentViewController *com=[[CommentViewController alloc]initWithImageData:imageInfo with:@"个人中心"];
        com.single=2;
//        UIImage * userImg = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"]];
//        if (userImg) {
//            com.userImg=userImg;
//        }
        NSString *head_url=[[NSUserDefaults standardUserDefaults]  objectForKey:@"currendIcoUrl"];
        if (head_url&&![@"" isEqualToString:head_url]) {
            com.head_url=head_url;
            
        }
        com.nickname=self.username;
        [self.navigationController pushViewController:com animated:NO];
    }
    
    
}
-(void)deleteClick:(UIButton *)btn
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"要删除这张照片吗？" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag=11;
    alert.delegate=self;
    [alert show];
    int row=btn.tag;
    self.deleRow=row;
}
-(void)txbtnClick  //个人中心
{
    
    EditGRXXController *editController=[[EditGRXXController alloc] init];
    [self.navigationController pushViewController:editController animated:YES];
    

}
-(void)carAction{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    actionSheet.tag = 100;
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row>=2) {
//        NSDictionary *dic=[self.shareContents objectAtIndex:indexPath.row-2];
//        ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dic];
//        CommentViewController *com=[[CommentViewController alloc]initWithImageData:imageInfo with:@"个人中心"];
//        com.single=2;
////        com.grtype=@"个人中心";
//        [self.navigationController pushViewController:com animated:NO];
//    }
}
#pragma mark -UIImagePickerControllerDelegate
//点击相册中的图片 货照相机照完后点击use  后触发的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    // Save the image to the album
    UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
    [self dismissViewControllerAnimated:YES completion:nil];
    if(image)
    {
        FBViewController *fbvc=[[FBViewController alloc]init];
        fbvc.fbimage=image;
        [self.navigationController pushViewController:fbvc animated:YES];
    }
    
}


- (void)imagedidFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    // Handle the end of the image write process
    if (!error)
        NSLog(@"成功");
    else
        NSLog(@"%@",[error localizedDescription]);
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

}
#pragma mark - alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==11) {
        if (buttonIndex==0) {
            NSDictionary *dic=[self.shareContents objectAtIndex:self.deleRow-2];
            NSString *itemId=dic[@"item_id"];
            
            NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
            NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
            NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
            NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
            [t_h setObject:[setting sharedSetting].app forKey:@"p"];
            [userCenterImage setObject:itemId forKey:@"itemId"];
            [t_b setObject:userCenterImage forKey:@"gz_syn_delitem"];
            [t_dic setObject:t_h forKey:@"h"];
            [t_dic setObject:t_b forKey:@"b"];
            [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
                NSDictionary *t_b = [returnData objectForKey:@"b"];
                
                if (t_b != nil)
                {
                    NSDictionary *syn_delitem=[t_b objectForKey:@"gz_syn_delitem"];
                    NSString *result1=syn_delitem[@"result"];
                    if ([result1 isEqualToString:@"1"]){
                        [self.shareContents removeObjectAtIndex:self.deleRow-2];
                        
                        [self.table reloadData];
                    }
                    
                    
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:NO];
            } withFailure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                
            } withCache:YES];
        }
        
    }else{
        if (buttonIndex==1) {
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"sjusername"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"sjuserid"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"currendIco"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"sjusername"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"sjuserphone"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"myname" object:nil];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        
    }
}
#pragma mark  上拉加载更多
// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadmoreCenterData];
    
}
// 刷新完毕就会调用
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
         [self.table reloadData];
}
-(void)dealloc
{
    if(self.footer){
    [self.footer endRefreshing];
    [self.footer free];
    }
}
@end
