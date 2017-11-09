//
//  PersonalCenterVC.m
//  ZtqCountry
//
//  Created by linxg on 14-8-13.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "PersonalCenterVC.h"
#import "PersonImageCell.h"
#import "PerosonShareCell.h"
#import "ZanViewController.h"
#import "PersonalShareImagesCell.h"
#import "SinglePhotoViewController.h"
#import "ImageInfo.h"


@interface PersonalCenterVC ()<PersonImageCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,PersonalShareImagesCellDelegate>

@property (strong, nonatomic) NSMutableArray * shareContents;
@property (strong, nonatomic) NSMutableArray * guanzhuDatas,*fansDatas;//关注和粉丝数
@property(strong,nonatomic)NSString *praiseCount,*imageCount,*name,*userId,*image,*focusCount,*fansCount;//个人中心登录下的信息
@property(strong,nonatomic)NSString *peraddress;
@end


@implementation PersonalCenterVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)configGuanZhuData
{
    self.guanzhuDatas = [[NSMutableArray alloc] init];
//    NSDictionary * dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"我是你的眼",@"Name",@"13-081009_488.jpg",@"Image", nil];
//    NSDictionary * dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"小葵",@"Name",@"136677708511.jpg",@"Image", nil];
//    NSDictionary * dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"柳擎",@"Name",@"14-032325_55.jpg",@"Image", nil];
//    NSDictionary * dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"小孩",@"Name",@"14-032331_273.jpg",@"Image", nil];
//    NSDictionary * dic5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"小东",@"Name",@"16-031648_49.jpg",@"Image", nil];
//    NSDictionary * dic6 = [[NSDictionary alloc] initWithObjectsAndKeys:@"流汐",@"Name",@"17-010538_310.jpg",@"Image", nil];
//    NSDictionary * dic7 = [[NSDictionary alloc] initWithObjectsAndKeys:@"木杨",@"Name",@"1f3112516d4d59e2b7ff81bc0b6a9b41.jpg",@"Image", nil];
//    NSDictionary * dic8 = [[NSDictionary alloc] initWithObjectsAndKeys:@"林风",@"Name",@"20-012805_855.jpg",@"Image", nil];
//    NSDictionary * dic9 = [[NSDictionary alloc] initWithObjectsAndKeys:@"独钓",@"Name",@"2013021612393028670.jpg",@"Image", nil];
//    [self.guanzhuDatas addObject:dic1];
//    [self.guanzhuDatas addObject:dic2];
//    [self.guanzhuDatas addObject:dic3];
//    [self.guanzhuDatas addObject:dic4];
//    [self.guanzhuDatas addObject:dic5];
//    [self.guanzhuDatas addObject:dic6];
//    [self.guanzhuDatas addObject:dic7];
//    [self.guanzhuDatas addObject:dic8];
//    [self.guanzhuDatas addObject:dic9];
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *getFocusList = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    if (self.userId.length>0) {
        [getFocusList setObject:self.userId forKey:@"usrId"];
    }
    
    [t_b setObject:getFocusList forKey:@"getFocusList"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *getFocusList=[t_b objectForKey:@"getFocusList"];
            
            self.guanzhuDatas=[getFocusList objectForKey:@"idex"];
        }
//        [self.table reloadData];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
    
}
-(void)configfans{
    self.fansDatas = [[NSMutableArray alloc] init];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *getFocusList = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [getFocusList setObject:self.userId forKey:@"friendId"];
    [t_b setObject:getFocusList forKey:@"getFansList"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *getFocusList=[t_b objectForKey:@"getFansList"];
            self.fansDatas=[getFocusList objectForKey:@"idex"];
        }
//        [self.table reloadData];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
-(void)getuserinfos{
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [userInfo setObject:userName forKey:@"name"];
    [t_b setObject:userInfo forKey:@"userInfo"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *userinfo=[t_b objectForKey:@"userInfo"];
            self.praiseCount=[userinfo objectForKey:@"praiseCount"];
            self.imageCount=[userinfo objectForKey:@"imageCount"];
            self.name=[userinfo objectForKey:@"name"];
            self.userId=[userinfo objectForKey:@"userId"];
            self.fansCount=[userinfo objectForKey:@"fansCount"];
            self.focusCount=[userinfo objectForKey:@"focusCount"];
            self.image=[userinfo objectForKey:@"image"];
            //存储用户id
            if (self.userId.length>0) {
                [[NSUserDefaults standardUserDefaults]setObject:self.userId forKey:@"currendUserID"];
            }else{
                self.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"currendUserID"];
            }
            
            
        }
        [self configGuanZhuData];
        [self configfans];
        [self.table reloadData];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
-(void)configData
{
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [userCenterImage setObject:userName forKey:@"name"];
    [t_b setObject:userCenterImage forKey:@"userCenterImage"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *userCenterImage=[t_b objectForKey:@"userCenterImage"];
           
            _shareContents = [[NSMutableArray alloc] init];
            _shareContents=[userCenterImage objectForKey:@"idx"];
            for (int i=0; i<_shareContents.count; i++) {
                 PersonCenterModel *pcmd=[[PersonCenterModel alloc]init];
                pcmd.des=[[_shareContents objectAtIndex:i]objectForKey:@"des"];
                pcmd.address=[[_shareContents objectAtIndex:i]objectForKey:@"address"];
                pcmd.weather=[[_shareContents objectAtIndex:i]objectForKey:@"weather"];
                pcmd.praise=[[_shareContents objectAtIndex:i]objectForKey:@"praise"];
                pcmd.datetime=[[_shareContents objectAtIndex:i]objectForKey:@"datetime"];
                pcmd.images=[[_shareContents objectAtIndex:i]objectForKey:@"images"];
                [_shareContents addObject:pcmd];
            }
        }
        [self.table reloadData];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
//    if(self.type == 1)
//    {
//        _shareContents = [[NSMutableArray alloc] init];
//        NSMutableDictionary * shareDic1 = [[NSMutableDictionary alloc] init];
//        [shareDic1 setObject:@"7/6" forKey:@"time"];
//        [shareDic1 setObject:@"1.jpg" forKey:@"shareImg"];
//        [shareDic1 setObject:@"天气不错" forKey:@"shareContent"];
//        [shareDic1 setObject:@"福州-晴-30°-东南风3级" forKey:@"weather"];
//        [shareDic1 setObject:@"福州市鼓楼区" forKey:@"address"];
//        [shareDic1 setObject:@"33" forKey:@"zanNum"];
//        [shareDic1 setObject:@"1" forKey:@"imageType"];//1代表名字，2代表data
//        NSMutableArray * images1 = [[NSMutableArray alloc] init];
//        [images1 addObject:[UIImage imageNamed:@"1.jpg"]];
//        [images1 addObject:[UIImage imageNamed:@"1736669_222248056_2.jpg"]];
//        [images1 addObject:[UIImage imageNamed:@"7204816_174933648126_2.jpg"]];
//        [shareDic1 setObject:images1 forKey:@"images"];
//        [_shareContents addObject:shareDic1];
//        
//        NSMutableDictionary * shareDic2 = [[NSMutableDictionary alloc] init];
//        [shareDic2 setObject:@"7/6" forKey:@"time"];
//        [shareDic2 setObject:@"1736669_222248056_2.jpg" forKey:@"shareImg"];
//        [shareDic2 setObject:@"风景如画" forKey:@"shareContent"];
//        [shareDic2 setObject:@"福州-晴-30°-东南风3级" forKey:@"weather"];
//        [shareDic2 setObject:@"福州市鼓楼区" forKey:@"address"];
//        [shareDic2 setObject:@"33" forKey:@"zanNum"];
//        [shareDic2 setObject:@"1" forKey:@"imageType"];//1代表名字，2代表data
//        NSMutableArray * images2 = [[NSMutableArray alloc] init];
//        [images2 addObject:[UIImage imageNamed:@"200811114359443_2.jpg"]];
//        [images2 addObject:[UIImage imageNamed:@"2.jpg"]];
//        [images2 addObject:[UIImage imageNamed:@"2007122517474611_2.jpg"]];
//        [images2 addObject:[UIImage imageNamed:@"4501407_135850994695_2.jpg"]];
//        [images2 addObject:[UIImage imageNamed:@"5063545_023429219000_2.jpg"]];
//        [shareDic2 setObject:images2 forKey:@"images"];
//        [_shareContents addObject:shareDic2];
//        
//        NSMutableDictionary * shareDic3 = [[NSMutableDictionary alloc] init];
//        [shareDic3 setObject:@"7/6" forKey:@"time"];
//        [shareDic3 setObject:@"7204816_174933648126_2.jpg" forKey:@"shareImg"];
//        [shareDic3 setObject:@"好风景，好心情" forKey:@"shareContent"];
//        [shareDic3 setObject:@"福州-晴-30°-东南风3级" forKey:@"weather"];
//        [shareDic3 setObject:@"福州市鼓楼区" forKey:@"address"];
//        [shareDic3 setObject:@"33" forKey:@"zanNum"];
//        [shareDic3 setObject:@"1" forKey:@"imageType"];//1代表名字，2代表data
//        
//        NSMutableArray * images3 = [[NSMutableArray alloc] init];
//        [images3 addObject:[UIImage imageNamed:@"5063545_135353548917_2.jpg"]];
//        [images3 addObject:[UIImage imageNamed:@"8694a4c27d1ed21bd73ce200ac6eddc450da3f5a.jpg"]];
//        [images3 addObject:[UIImage imageNamed:@"9345d688d43f87949110e7ffd31b0ef41ad53a77.jpg"]];
//        [images3 addObject:[UIImage imageNamed:@"a08b87d6277f9e2feb5402e41e30e924b999f3fd.jpg"]];
//        [images3 addObject:[UIImage imageNamed:@"2007122517474611_2.jpg"]];
//        [shareDic3 setObject:images3 forKey:@"images"];
//        
//        
//        
//        [_shareContents addObject:shareDic3];
//        
//        NSMutableDictionary * shareDic4 = [[NSMutableDictionary alloc] init];
//        [shareDic4 setObject:@"7/6" forKey:@"time"];
//        [shareDic4 setObject:@"200811114359443_2.jpg" forKey:@"shareImg"];
//        [shareDic4 setObject:@"心静自然凉" forKey:@"shareContent"];
//        [shareDic4 setObject:@"福州-晴-30°-东南风3级" forKey:@"weather"];
//        [shareDic4 setObject:@"福州市鼓楼区" forKey:@"address"];
//        [shareDic4 setObject:@"33" forKey:@"zanNum"];
//        [shareDic4 setObject:@"1" forKey:@"imageType"];//1代表名字，2代表data
//        [shareDic4 setObject:images2 forKey:@"images"];
//        [_shareContents addObject:shareDic4];
//        
//        NSMutableDictionary * shareDic5 = [[NSMutableDictionary alloc] init];
//        [shareDic5 setObject:@"7/6" forKey:@"time"];
//        [shareDic5 setObject:@"2.jpg" forKey:@"shareImg"];
//        [shareDic5 setObject:@"阳光明媚啊，发表下心情" forKey:@"shareContent"];
//        [shareDic5 setObject:@"福州-晴-30°-东南风3级" forKey:@"weather"];
//        [shareDic5 setObject:@"福州市鼓楼区" forKey:@"address"];
//        [shareDic5 setObject:@"33" forKey:@"zanNum"];
//        [shareDic5 setObject:@"1" forKey:@"imageType"];//1代表名字，2代表data
//        [shareDic5 setObject:images1 forKey:@"images"];
//        [_shareContents addObject:shareDic5];
//        
//        NSMutableDictionary * shareDic6 = [[NSMutableDictionary alloc] init];
//        [shareDic6 setObject:@"7/6" forKey:@"time"];
//        [shareDic6 setObject:@"2007122517474611_2.jpg" forKey:@"shareImg"];
//        [shareDic6 setObject:@"蓝蓝的海，很美。" forKey:@"shareContent"];
//        [shareDic6 setObject:@"福州-晴-30°-东南风3级" forKey:@"weather"];
//        [shareDic6 setObject:@"福州市鼓楼区" forKey:@"address"];
//        [shareDic6 setObject:@"33" forKey:@"zanNum"];
//        [shareDic6 setObject:@"1" forKey:@"imageType"];//1代表名字，2代表data
//        [shareDic6 setObject:images3 forKey:@"images"];
//        [_shareContents addObject:shareDic6];
    
//    }
//    else if (self.type == 0)
//    {
//        //自己
//        NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
//        NSDictionary * shareInfos = [ShareFun readUserShareInfo];
//        if(shareInfos)
//        {
//            NSArray * userShares = [shareInfos objectForKey:userName];
//            _shareContents = [NSMutableArray arrayWithArray:userShares];
//        }
//    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configData];
    [self getuserinfos];
//    [self configGuanZhuData];
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
    _navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    _navigationBarBg.userInteractionEnabled = YES;
    _navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1];
    [self.view addSubview:_navigationBarBg];
    
    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(15, 7+place, 30, 30)];
    [_leftBut setBackgroundImage:[UIImage imageNamed:@"cssz返回.png"] forState:UIControlStateNormal];
    [_leftBut setBackgroundImage:[UIImage imageNamed:@"cssz返回点击.png"] forState:UIControlStateHighlighted];
    //    [_leftBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    [_leftBut setTitle:@"back" forState:UIControlStateNormal];
      [self.leftBut addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 12+place, 200, 20)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:18];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor whiteColor];
    [_navigationBarBg addSubview:_titleLab];
    self.barHiden = NO;
    self.titleLab.text = @"个人中心";
 
    //    self.rightBut.frame = CGRectMake(kScreenWidth-20-20, self.leftBut.frame.origin.y, 20, 20);
    //    self.rightBut.backgroundColor = [UIColor whiteColor];
    //    [self.rightBut addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatatablview) name:@"updata" object:nil];
    
    UITableView * table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight) style:UITableViewStylePlain];
    self.table = table;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}
-(void)leftAction{
    if ([self.backtype isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
}
-(void)updatatablview{
    [self getuserinfos];
    [self.table reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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




-(void)cameraAction:(UIButton *)sender
{
    
}


#pragma mark -TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shareContents.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 250;
    }
    else
    {
        NSDictionary * shareInfo = [self.shareContents objectAtIndex:indexPath.row-1];
        NSArray * images = [shareInfo objectForKey:@"images"];
        int line = images.count/3;
        int column = images.count%3;
        if(column!=0)
        {
            return 55+(line+1)*(((kScreenWidth-50-30)-2*20)/3.0+20);
        }
        else
        {
            return 55+line*(((kScreenWidth-50-30)-2*20)/3.0+20);
        }
        
        //        return 90;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        PersonImageCell * imageCell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
        self.guanzhubut=imageCell.guanzhubtn;
        NSMutableArray *marr=[[NSUserDefaults standardUserDefaults]objectForKey:@"Guanzhu"];
        if (marr.count>0) {
            for (int i=0; i<marr.count; i++) {
                
                NSString *itemid=[[marr objectAtIndex:i]objectForKey:@"name"];
                if ([self.facusid isEqualToString:itemid]) {
                    self.isguanzhu=[[[marr objectAtIndex:i] objectForKey:@"state"]boolValue ];
                }
                
            }
        }
        if(imageCell == nil)
        {
            imageCell = [[PersonImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ImageCell"];
        }
        if(self.type == 0)
        {
            imageCell.userImgButton.userInteractionEnabled = YES;
            [imageCell.guanzhubtn setHidden:YES];
            
                   }
        else
        {
            [imageCell.guanzhubtn setHidden:NO];
            imageCell.userImgButton.userInteractionEnabled = NO;
            if (self.isguanzhu==YES) {
                [imageCell.guanzhubtn setTitle:@"已关注" forState:UIControlStateNormal];
            }else{
                [imageCell.guanzhubtn setTitle:@"+关注" forState:UIControlStateNormal];
                [imageCell.guanzhubtn addTarget:self action:@selector(guanzhuAction) forControlEvents:UIControlEventTouchUpInside];
            }

        }
        imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        imageCell.delegate = self;
        NSString *imgstr=[ShareFun makeImageUrlStr:self.image];
        NSURL *imgurl=[NSURL URLWithString:imgstr];
        self.userImage=[NSData dataWithContentsOfURL:imgurl];
        [imageCell setImageforUserImg_MaxWithImage:[UIImage imageWithData:self.userImage]];
        imageCell.userImg_Min.image = [UIImage imageWithData:self.userImage];
        imageCell.userName.text = self.name;
        imageCell.browseNum.text = self.focusCount;
        imageCell.friendNum.text = self.fansCount;
        imageCell.zanNum.text = self.praiseCount;
        imageCell.shareNum.text = self.imageCount;
        return imageCell;
    }
    else
    {
        //        PerosonShareCell * shareCell = [tableView dequeueReusableCellWithIdentifier:@"shareCell"];
        //        if(shareCell == nil)
        //        {
        //            shareCell = [[PerosonShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shareCell"];
        //        }
        //        NSDictionary * shareInfo = [self.shareContents objectAtIndex:indexPath.row-1];
        //        NSString * time = [shareInfo objectForKey:@"time"];
        //
        //        NSString * shareContent = [shareInfo objectForKey:@"shareContent"];
        //        NSString * weather = [shareInfo objectForKey:@"weather"];
        //        NSString * address = [shareInfo objectForKey:@"address"];
        //        NSString * zanNum = [shareInfo objectForKey:@"zanNum"];
        //        NSString * imageType = [shareInfo objectForKey:@"imageType"];
        //        shareCell.timeLab.text = time;
        //        if([imageType isEqualToString:@"1"])
        //        {
        //            NSString * shareImg = [shareInfo objectForKey:@"shareImg"];
        //            shareCell.shareImgV.image = [UIImage imageNamed:shareImg];
        //        }
        //        else
        //        {
        //            if([imageType isEqualToString:@"2"])
        //            {
        //                NSData * shareImg = [shareInfo objectForKey:@"shareImg"];
        //                shareCell.shareImgV.image = [UIImage imageWithData:shareImg];
        //            }
        //        }
        //        shareCell.shareContentLab.text = shareContent;
        //        shareCell.weatherLab.text = weather;
        //        shareCell.addressLab.text = address;
        //        shareCell.zanNumLab.text = zanNum;
        //        return shareCell;
        
        
        PersonalShareImagesCell * shareCell = [tableView dequeueReusableCellWithIdentifier:@"shareCell"];
        PersonCenterModel *percent=[self.shareContents objectAtIndex:indexPath.row-1];
        NSString * time =percent.datetime;
        
        NSString * shareContent = percent.des;
        NSString * weather =percent.weather;
        NSString * address =percent.address;
        self.peraddress=address;
        NSString * zanNum = percent.praise;
//        NSString * imageType = [shareInfo objectForKey:@"imageType"];
        NSArray * images = percent.images;
//        NSDictionary * shareInfo = [self.shareContents objectAtIndex:indexPath.row-1];
//        NSString * time = [shareInfo objectForKey:@"time"];
//        
//        NSString * shareContent = [shareInfo objectForKey:@"shareContent"];
//        NSString * weather = [shareInfo objectForKey:@"weather"];
//        NSString * address = [shareInfo objectForKey:@"address"];
//        NSString * zanNum = [shareInfo objectForKey:@"zanNum"];
//        NSString * imageType = [shareInfo objectForKey:@"imageType"];
//        NSArray * images = [shareInfo objectForKey:@"images"];
        if(shareCell == nil)
        {
            shareCell =[[PersonalShareImagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shareCell" withMonth:time withDay:@"4" withComment:shareContent withAddress:address withZanNum:zanNum withImages:images];
        }
        shareCell.delegate = self;
        shareCell.row=indexPath.row;//判断点赞的哪一行
        return shareCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(BOOL)tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.shareContents removeObjectAtIndex:indexPath.row-1];  //删除数组里的数据
        [self.table deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
//        NSString *ietm=[NSString stringWithFormat:@"%d",indexPath.row-1];
        [self delItemWiteh:self.itemid];//删除服务器对应的条目
    }

}
-(void)delItemWiteh:(NSString *)item{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *getFocusList = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [getFocusList setObject:self.userId forKey:@"usrId"];
    [getFocusList setObject:item forKey:@"itemId"];
    [t_b setObject:getFocusList forKey:@"delItem"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *getFocusList=[t_b objectForKey:@"delItem"];
            NSString *result=[getFocusList objectForKey:@"result"];
            NSLog(@"%@",result);
        }
        //        [self.table reloadData];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
#pragma mark -PersonImageCellDelegate

-(void)guanzhuAction{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *getFocusList = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [getFocusList setObject:self.userId forKey:@"usrId"];
    [getFocusList setObject:self.facusid forKey:@"focusId"];
    [t_b setObject:getFocusList forKey:@"openFocus"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *getFocusList=[t_b objectForKey:@"openFocus"];
            NSString *result=[getFocusList objectForKey:@"result"];
            NSLog(@"%@",result);
            [self.guanzhubut setTitle:@"已关注" forState:UIControlStateNormal];
        }
        //        [self.table reloadData];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}

-(void)personImageClick
{
//    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
//        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        picker.delegate = self;
//        picker.allowsEditing = YES;//设置可编辑
//        picker.sourceType = sourceType;
//        //    [self presentModalViewController:picker animated:YES];//进入照相界面
//        [self presentViewController:picker animated:YES completion:nil];//进入照相界面
//    }
//    else
//    {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"此设备不支持拍照功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    actionSheet.tag = 100;
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];

    
}

#pragma mark -UIImagePickerControllerDelegate
//点击相册中的图片 货照相机照完后点击use  后触发的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.userImage = UIImagePNGRepresentation(image);
    // Save the image to the album
    [[NSUserDefaults standardUserDefaults] setObject:self.userImage forKey:@"currendIco"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.table reloadData];
    
 
    
    const char *str = [URL_SERVER UTF8String];
    NSString *url = [NSString stringWithUTF8String:str];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *nowurl=[NSURL URLWithString:url];
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:nowurl];
////    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"avatar.jpg"], 0.5);
//    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:url parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//        [formData appendPartWithFileData:self.userImage name:nil fileName:nil mimeType:@"image/png"];
//    }];
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//         [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                 NSLog(@"上传完成");
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    NSLog(@"上传失败->%@", error);
//                }];
//    
//         //执行
//         [httpClient.operationQueue addOperation:op];
    
    //
    
//    NSString *t_string=[ShareFun stringFromdata:self.userImage];
//    [[GetQxfwData alloc] synchronous:self.userImage withObject:self withflag:10000];//上传图片
    
    [self updateuserimage];
    
    
}
//更改用户头像
-(void)updateuserimage{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sjkpupdateuserimage = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [sjkpupdateuserimage setObject:self.userId forKey:@"usrId"];
    
    [t_b setObject:sjkpupdateuserimage forKey:@"sjkpupdateuserimage"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *getFocusList=[t_b objectForKey:@"sjkpupdateuserimage"];
            NSString *result=[getFocusList objectForKey:@"result"];
            NSLog(@"%@",result);
        }
  
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
-(void)userInteractionWithTag:(int)tag
{
    ZanViewController * zanVC = [[ZanViewController alloc] init];
    if(tag == 1)
    {
        //关注
        zanVC.titleStr = @"关注";
        zanVC.datas = self.guanzhuDatas;
        zanVC.userid=self.userId;
        [self.navigationController pushViewController:zanVC animated:YES];
    }
    if(tag == 2)
    {
        //好友
        zanVC.titleStr = @"粉丝";
        zanVC.datas = self.fansDatas;
        zanVC.userid=self.userId;
        [self.navigationController pushViewController:zanVC animated:YES];
    }
    if(tag == 3)
    {
//        //赞
//        zanVC.titleStr = @"点赞";
//        zanVC.datas = self.guanzhuDatas;
//        [self.navigationController pushViewController:zanVC animated:YES];
    }
    if(tag == 4)
    {
        
    }
    
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

#pragma mark -PersonalShareImagesCellDelegate

-(void)PersonalSahreImagesCellImageClickWithImage:(UIImage *)image
{
//    imageCell.delegate = self;
//    [imageCell setImageforUserImg_MaxWithImage:[UIImage imageWithData:self.userImage]];
//    imageCell.userImg_Min.image = [UIImage imageWithData:self.userImage];
//    imageCell.userName.text = self.userName;
//    imageCell.browseNum.text = @"652";
//    imageCell.friendNum.text = @"862";
//    imageCell.zanNum.text = @"1537";
//    imageCell.shareNum.text = @"237";

    
    ImageInfo * data = [[ImageInfo alloc] init];
    data.width = image.size.width;
    data.height = image.size.height;
    data.zanNum = self.praiseCount.intValue;
    data.commentNum = 237;//回复
    data.forwardNum = 862;//浏览量
    data.address = self.peraddress;
    data.userName = self.userName;
    data.shareTime = @"";
    data.imageType = @"2";
    data.imageData = UIImagePNGRepresentation(image);
    data.userImageData = self.userImage;
    
    SinglePhotoViewController * singlePhotoVC = [[SinglePhotoViewController alloc] initWithImageData:data];
    singlePhotoVC.single = 2;
    [self.navigationController pushViewController:singlePhotoVC animated:YES];
}
//点赞
-(void)zanActionWithIndexPath:(int)row{
//    NSString *item=[NSString stringWithFormat:@"%d",row];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *getFocusList = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [getFocusList setObject:self.userId forKey:@"usrId"];
    [getFocusList setObject:self.itemid forKey:@"itemId"];
    [t_b setObject:getFocusList forKey:@"clickGood"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *getFocusList=[t_b objectForKey:@"clickGood"];
            NSString *result=[getFocusList objectForKey:@"result"];
            NSLog(@"%@",result);
        }
        //        [self.table reloadData];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];

}
@end
