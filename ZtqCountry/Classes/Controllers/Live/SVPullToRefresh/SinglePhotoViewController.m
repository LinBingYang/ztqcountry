//
//  SinglePhotoViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-8.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "SinglePhotoViewController.h"
#import "LiveImageTableViewCell.h"
#import "LiveCityTableViewCell.h"
#import "LiveFriendTableViewCell.h"
#import "ShareSheet.h"
#import "weiboVC.h"
#import "PersonalCenterVC.h"
#import "LoginAlertView.h"
#import "ZhuceViewController.h"
#import "LiveUserInfoCell.h"
#import "SingleToPersonCenterTransitonAnimation.h"
#import "LiveHeadNoTableViewCell.h"
#import "LiveHeadYesTableViewCell.h"
#import "UIColor+ColorWithHexColor.h"
#import "ShareSheet.h"
#import "weiboVC.h"
#import "LGViewController.h"
#import "FaceToolBar.h"

#import "EGOImageView.h"
@interface SinglePhotoViewController ()<LiveFriendButtonClickDelegate,LiveImageDelegate,ShareSheetDelegate,UITextFieldDelegate,UIScrollViewDelegate,LoginAlertViewDelegate,LiveUserInfoCellDelegate,ShareSheetDelegate,LiveHeadYesTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,FaceToolBarDelegate>

@property (strong, nonatomic) UIScrollView * backgroundScrollView;

@property (strong, nonatomic) NSMutableArray * friends;
@property (strong, nonatomic) NSMutableString * shareStr;
@property (strong, nonatomic) FaceToolBar * commentBar;
@property (strong, nonatomic) UITextField * commentTF;
@property (strong, nonatomic) UITapGestureRecognizer * tapGesture;
@property (assign, nonatomic) float originOffsetY;
@property (assign, nonatomic) BOOL commentBarShow;

@end

@implementation SinglePhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.commentBarShow = NO;
//        [self configFriend];
        [self getCacheWeekTQ];
        
        [self sjkpcommentslist];
    }
    return self;
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    //键盘信息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//
//}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    self.navigationController.delegate = self;
    //键盘信息
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.table reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //    if(self.navigationController.delegate == self)
    //    {
    //        self.navigationController.delegate = nil;
    //    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.barHiden = NO;
    self.rightBut.frame = CGRectMake(kScreenWidth-30-15,self.leftBut.frame.origin.y,30,30);
    self.titleLab.text = self.imageData.userName;
    self.titleLab.textColor = [UIColor whiteColor];
    [self.rightBut setImage:[UIImage imageNamed:@"grzx1分享.png"] forState:UIControlStateNormal];
    [self.rightBut setImage:[UIImage imageNamed:@"grzx1分享点击.png"] forState:UIControlStateHighlighted];
    [self.rightBut addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentslist=[[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatatablview) name:@"updata" object:nil];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-self.barHeight)];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.backgroundColor = [UIColor colorHelpWithRed:248 green:243 blue:209 alpha:1];
    self.originOffsetY = _table.contentOffset.y;
    [self.view addSubview:_table];
    
    //    UIView * commentBar = [[UIView alloc] initWithFrame:CGRectMake(1, kScreenHeitht, kScreenWidth-2, 50)];
    //    commentBar.layer.cornerRadius = 2;
    //    self.commentBar = commentBar;
    //    commentBar.backgroundColor = [UIColor colorHelpWithRed:236 green:236 blue:236 alpha:1];
    //    [self.view addSubview:commentBar];
    
    FaceToolBar* bar=[[FaceToolBar alloc]initWithFrame:CGRectMake(0.0f,kScreenHeitht-51,kScreenWidth-2,toolBarHeight) superView:self.view withController:self];
    //    bar.backgroundColor = [UIColor blackColor];
    bar.controller = self;
    bar.delegate=self;
    self.commentBar = bar;
    [self.view addSubview:bar];
    
    [self sjkpaddbrowse];
    //    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    //    icon.image = [UIImage imageNamed:@"表情.png"];
    //    //    icon.image = [UIImage imageNamed:@""];
    //    icon.layer.cornerRadius = 5;
    //    icon.layer.masksToBounds = YES;
    //    icon.backgroundColor = [UIColor whiteColor];
    //    [commentBar addSubview:icon];
    //
    //    _commentTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 218, 40)];
    //    _commentTF.backgroundColor = [UIColor whiteColor];
    //    _commentTF.delegate = self;
    //    _commentTF.clearButtonMode = UITextFieldViewModeAlways;
    //    _commentTF.placeholder = @"请输入评论";
    //    _commentTF.layer.cornerRadius = 5;
    //    _commentTF.layer.masksToBounds = YES;
    //    [commentBar addSubview:_commentTF];
    //
    //    UIImageView * tfLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 20, 32)];
    //    tfLeftView.image = [UIImage imageNamed:@"比_11.png"];
    //    _commentTF.leftView = tfLeftView;
    //    _commentTF.leftViewMode = UITextFieldViewModeAlways;
    //
    //    UIView * senderBg = [[UIView alloc] initWithFrame:CGRectMake(273, 5, 40, 40)];
    //    senderBg.backgroundColor = [UIColor whiteColor];
    //    senderBg.layer.cornerRadius = 5;
    //    [commentBar addSubview:senderBg];
    //
    //    UIImageView * senderLogo = [[UIImageView alloc] initWithFrame:CGRectMake(11, 2, 18, 18)];
    //    senderLogo.image = [UIImage imageNamed:@"发送.png"];
    //    [senderBg addSubview:senderLogo];
    //
    //    UILabel * senderLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 40, 20)];
    //    senderLab.backgroundColor = [UIColor clearColor];
    //    senderLab.textColor = [UIColor grayColor];
    //    senderLab.textAlignment = NSTextAlignmentCenter;
    //    senderLab.font = [UIFont fontWithName:kBaseFont size:13];
    //    senderLab.text = @"发送";
    //    [senderBg addSubview:senderLab];
    //
    //    UIButton * sender = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ////    [sender setImage:[UIImage imageNamed:@"发送.png"] forState:UIControlStateNormal];
    ////    [sender setImage:[UIImage imageNamed:@"发送点击_06"] forState:UIControlStateHighlighted];
    ////    [sender setTitle:@"发送" forState:UIControlStateNormal];
    ////    [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    ////    [sender setImageEdgeInsets:UIEdgeInsetsMake(2, 11, 20, 11)];
    ////    [sender setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
    ////    [sender setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
    //    [sender addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [senderBg addSubview:sender];
    
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    
    
    if(!self.commentBarShow)
    {
        //开启
        [self commentShowYesOrNo:YES];
    }
    
}
-(void)updatatablview{
    BOOL ischoose=NO;
    NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:ischoose],@"state",self.imageData.userID,@"name", nil];
    NSMutableArray *marr=[[NSMutableArray alloc]init];
    [marr addObject:dic];
    [[NSUserDefaults standardUserDefaults]setObject:marr forKey:@"Guanzhu"];
    [self.table reloadData];
}
//进入页面增加浏览量
-(void)sjkpaddbrowse{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sjkpaddbrowse = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [sjkpaddbrowse setObject:self.imageData.itemid forKey:@"count"];
   
    [t_b setObject:sjkpaddbrowse forKey:@"sjkpaddbrowse"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *sjkp=[t_b objectForKey:@"sjkpaddbrowse"];
        NSString *result=[sjkp objectForKey:@"result"];
        
        [self.table reloadData];
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
-(void)getCacheWeekTQ
{
//    NSString * currentID = [setting sharedSetting].currentCityID;
//    NSDictionary * returnData = [[setting sharedSetting].DEMO_AllCityWeekTq objectForKey:currentID];
//    if(returnData)
//    {
//        NSMutableDictionary * info = [[NSMutableDictionary alloc] init];
//        [info setObject:@0 forKey:@"moduId"];
//        [info setObject:returnData forKey:@"moduInfo"];
//        //        [self.currentMainControllerContentView updateDataWithData:info];
//        [self configShareMessageWithInfo:returnData];
//        
//    }
}
-(void)configShareMessageWithInfo:(NSDictionary *)infoDic
{
    NSDictionary * b = [infoDic objectForKey:@"b"];
    NSDictionary * weekTq = [b objectForKey:@"weekTq"];
    NSArray * week = [weekTq objectForKey:@"week"];
    self.shareStr = [[NSMutableString alloc] init];
    [self.shareStr appendString:[NSString stringWithFormat:@"%@,",[setting sharedSetting].currentCity]];
    for(int i=0;i<week.count;i++)
    {
        NSDictionary * weekInfo = [week objectAtIndex:i];
        NSString * gdt = [weekInfo objectForKey:@"gdt"];
        NSString * higt = [weekInfo objectForKey:@"higt"];
        NSString * wd_night = [weekInfo objectForKey:@"wd_night"];
        NSString * wd_daytime = [weekInfo objectForKey:@"wd_daytime"];
        NSString * wd = [weekInfo objectForKey:@"wd"];
        NSString * lowt = [weekInfo objectForKey:@"lowt"];
        NSString * wk = [weekInfo objectForKey:@"week"];
        [self.shareStr appendString:[NSString stringWithFormat:@"%@,",gdt]];
        
        if([ShareFun timeRules]==Evening)
        {
            if(wd_night.length)
            {
                [self.shareStr appendString:[NSString stringWithFormat:@"%@,",wd_night]];
            }
        }
        else
        {
            if(wd_daytime.length)
            {
                [self.shareStr appendString:[NSString stringWithFormat:@"%@,",wd_daytime]];
            }
        }
        if([ShareFun timeRules]==Morning)
        {
            if(lowt.length&&higt.length)
            {
                [self.shareStr appendString:[NSString stringWithFormat:@"%@℃~%@℃",lowt,higt]];
            }
        }
        else if([ShareFun timeRules] == Noon)
        {
            if(higt.length&&lowt.length)
            {
                [self.shareStr appendString:[NSString stringWithFormat:@"%@℃~%@℃",higt,lowt]];
            }
        }
        else if([ShareFun timeRules] == Evening)
        {
            if(lowt.length)
            {
                [self.shareStr appendString:[NSString stringWithFormat:@"最低温度%@",lowt]];
            }
        }
    }
}


//-(void)configFriend
//{
//    _friends = [[NSMutableArray alloc] init];
//    NSDictionary * dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"13-081009_488.jpg",@"image",@"照片很漂亮",@"comment",@"08:20",@"time",@"我是你的眼",@"userName",@"1",@"imageType", nil];
//    [_friends addObject:dic1];
//    NSDictionary * dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"136677708511.jpg",@"image",@"很赞",@"comment",@"08:20",@"time",@"小葵",@"userName", @"1",@"imageType",nil];
//    [_friends addObject:dic2];
//    NSDictionary * dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"14-032325_55.jpg",@"image",@"赞+1",@"comment",@"08:20",@"time",@"柳擎",@"userName",@"1",@"imageType", nil];
//    [_friends addObject:dic3];
//    NSDictionary * dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"14-032331_273.jpg",@"image",@"美丽的风景美丽的心情",@"comment",@"08:20",@"time",@"小孩",@"userName", @"1",@"imageType",nil];
//    [_friends addObject:dic4];
//    NSDictionary * dic5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"16-031648_49.jpg",@"image",@"好漂亮",@"comment",@"08:20",@"time",@"小东",@"userName", @"1",@"imageType",nil];
//    [_friends addObject:dic5];
//    NSDictionary * dic6 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1f3112516d4d59e2b7ff81bc0b6a9b41.jpg",@"image",@"漂亮的地方",@"comment",@"08:20",@"time",@"木杨",@"userName", @"1",@"imageType",nil];
//    [_friends addObject:dic6];
//    NSDictionary * dic7 = [[NSDictionary alloc] initWithObjectsAndKeys:@"20-012805_855.jpg",@"image",@"哪里的风景，很漂亮。",@"comment",@"08:20",@"time",@"林风",@"userName", @"1",@"imageType",nil];
//    [_friends addObject:dic7];
//    NSDictionary * dic8 = [[NSDictionary alloc] initWithObjectsAndKeys:@"2013021612393028670.jpg",@"image",@"不错",@"comment",@"08:20",@"time",@"独钓",@"userName", @"1",@"imageType",nil];
//    [_friends addObject:dic8];
//    NSDictionary * dic9 = [[NSDictionary alloc] initWithObjectsAndKeys:@"24-010519_230.jpg",@"image",@"大赞",@"comment",@"08:20",@"time",@"咕咕咕咕叫",@"userName", @"1",@"imageType",nil];
//    [_friends addObject:dic9];
//    NSDictionary * dic10 = [[NSDictionary alloc] initWithObjectsAndKeys:@"24-060423_895.jpg",@"image",@"照片很漂亮",@"comment",@"08:20",@"time",@"不知了",@"userName", @"1",@"imageType",nil];
//    [_friends addObject:dic10];
//}
-(void)sjkpcommentslist{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sjkpcommentslist = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [sjkpcommentslist setObject:@"2" forKey:@"count"];
    [sjkpcommentslist setObject:@"1" forKey:@"page"];
    [t_b setObject:sjkpcommentslist forKey:@"sjkpcommentslist"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *sjkp=[t_b objectForKey:@"sjkpcommentslist"];
        self.commentslist=[sjkp objectForKey:@"idx"];
        [self.table reloadData];
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithImageData:(ImageInfo *)imageData
{
    self = [super init];
    if(self)
    {
        self.imageData = imageData;
    }
    return self;
}


#pragma mark -tableView

//1(+35)、2(30)
-(float )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float width = self.imageData.width;
    float height = self.imageData.height;
    NSString *thumbURL = self.imageData.thumbURL;
    float newHeight = height/width*self.view.width;
    if(indexPath.section == 0)
    {
        NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
        if(userName.length)
        {
            return newHeight+50+90;
        }
        else
        {
            return newHeight+50;
        }
    }
    else
    {
        return 60;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
        NSMutableArray *marr=[[NSUserDefaults standardUserDefaults]objectForKey:@"Guanzhu"];
        if (marr.count>0) {
            for (int i=0; i<marr.count; i++) {
                NSDictionary *dic=[marr objectAtIndex:i];
                NSString *itemid=[dic objectForKey:@"name"];
                if ([self.imageData.userID isEqualToString:itemid]) {
                    self.isguanzhu=[[dic objectForKey:@"state"]boolValue ];
                }
                
            }
        }
        
        
        if(userName.length)
        {
            LiveHeadYesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HeadYesCell"];
            if(cell == nil)
            {
                cell = [[LiveHeadYesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeadYesCell" withImageInfo:self.imageData];
            }
            if (self.isguanzhu==YES) {
                [cell.guanzhubut setTitle:@"已关注" forState:UIControlStateNormal];
            }else{
                [cell.guanzhubut setTitle:@"+关注" forState:UIControlStateNormal];
            }
            //            cell.delegate = self;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            LiveHeadNoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HeadNoCell"];
            if(cell == nil)
            {
               
                cell=[[LiveHeadNoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeadNoCell" withImageInfo:self.imageData withtype:self.single];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else
    {
        //          NSDictionary * dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"13-081009_488.jpg",@"image",@"照片很漂亮",@"comment",@"08:20",@"time",@"我是你的眼",@"userName", nil];
        NSDictionary * userInfoDic = [self.commentslist objectAtIndex:indexPath.row];
//        NSString * imageType = [userInfoDic objectForKey:@"imageType"];
        NSString * comment = [userInfoDic objectForKey:@"des"];
        NSString * time = [userInfoDic objectForKey:@"time"];
        NSString * userName = [userInfoDic objectForKey:@"nickName"];
        NSString *image=[userInfoDic objectForKey:@"image"];
        LiveFriendTableViewCell * friendCell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
        if(friendCell == nil)
        {
            friendCell = [[LiveFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
        }
        if (self.single ==2)
        {
            friendCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        if([imageType isEqualToString:@"1"])
//        {
//            //imageType == 1 图片名字  2图片数据
//            NSString * image = [userInfoDic objectForKey:@"image"];
//            friendCell.userImg.image = [UIImage imageNamed:image];
//        }
//        else if ([imageType isEqualToString:@"2"])
//        {
//            NSData * image = [userInfoDic objectForKey:@"image"];
//            friendCell.userImg.image = [UIImage imageWithData:image];
//        }
        EGOImageView *ego=[[EGOImageView alloc]init];
        [ego setImageURL:[ShareFun makeImageUrl:image]];
        friendCell.userImg.image=ego.image;
        
        friendCell.userName.text = userName;
        friendCell.commentLab.text = comment;
        friendCell.timeLab.text = time;
        NSLog(@"##################%@#######",comment);
        return friendCell;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSString * userName =[[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
    if(userName.length)
    {
        return 0;
    }
    else
    {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
        
    }
    else
    {
        return self.friends.count;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.single == 1)
    {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 1)
            {
                //            PersonalCenterVC * personalCenter = [[PersonalCenterVC alloc] init];
                //            if([self.imageData.imageType isEqualToString:@"1"])
                //            {
                //                UIImage * image = [UIImage imageNamed:self.imageData.userImg];
                //                personalCenter.userImage = UIImagePNGRepresentation(image);
                //            }
                //            else
                //            {
                //                personalCenter.userImage = self.imageData.imageData;
                //            }
                //            personalCenter.userName = self.imageData.userName;
                //            [self.navigationController pushViewController:personalCenter animated:YES];
                return;
            }
        }
        if(indexPath.section!= 0)
        {
            NSDictionary * userInfoDic = [self.friends objectAtIndex:indexPath.row];
//            initWithObjectsAndKeys:imageData,@"image",comment,@"comment",time,@"time",userName,@"userName",@"2",@"imageType", nil];
            NSData * imageData = [[NSData alloc] init];
            NSString * imageType = [userInfoDic objectForKey:@"imageType"];
            if([imageType isEqualToString:@"2"])
            {
                imageData = [userInfoDic objectForKey:@"image"];
            }
            else
            {
                NSString * image = [userInfoDic objectForKey:@"image"];
                UIImage * img = [UIImage imageNamed:image];
                imageData = UIImagePNGRepresentation(img);
            }
            
            //        NSString * comment = [userInfoDic objectForKey:@"comment"];
            //        NSString * time = [userInfoDic objectForKey:@"time"];
            NSString * userName = [userInfoDic objectForKey:@"userName"];
            PersonalCenterVC * personalCenter = [[PersonalCenterVC alloc] init];
            personalCenter.type = 1;
            personalCenter.backtype=@"1";
            personalCenter.userImage = imageData;
            personalCenter.userName = userName;
            [self.navigationController pushViewController:personalCenter animated:YES];
        }
        
    }
    
}
#pragma mark -LiveFriendButtonClickDelegate

-(void)friendButtonClickWithImage:(NSString *)img
{
    
}

-(void)LiveImageUserButClick:(NSString *)imageName
{
    
   }

-(void)shareAction:(UIButton *)sender
{
    
    UIImage *t_shareImage = nil;
    if([self.imageData.imageType isEqualToString:@"1"])
    {
        t_shareImage = [UIImage imageNamed:self.imageData.thumbURL];
    }
    else
    {
        if([self.imageData.imageType isEqualToString:@"2"])
        {
            t_shareImage = [UIImage imageWithData:self.imageData.imageData];
        }
    }
	
	NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
	if ([UIImagePNGRepresentation(t_shareImage) writeToFile:shareImagePath atomically:YES])
		NSLog(@">>write ok");
    ShareSheet * sheet = [[ShareSheet alloc] initDefaultWithTitle:@"分享天气" withDelegate:self];
    [sheet show];
}



#pragma mark -scrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.commentBarShow)
    {
        //关闭
        [self commentShowYesOrNo:NO];
    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(!self.commentBarShow)
    {
        //开启
        [self commentShowYesOrNo:YES];
    }
}
-(void)commentShowYesOrNo:(BOOL)show
{
    self.commentBarShow = show;
    if(show)
    {
        //         UIView * commentBar = [[UIView alloc] initWithFrame:CGRectMake(1, kScreenHeitht, kScreenWidth-2, 50)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        self.commentBar.frame = CGRectMake(1, kScreenHeitht-51, kScreenWidth-2, 50);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        self.commentBar.frame = CGRectMake(1, kScreenHeitht, kScreenWidth-2, 50);
        [UIView commitAnimations];
    }
}


#pragma mark-
#pragma mark-UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString * userName =[[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
    if(userName.length)
    {
        [self.table addGestureRecognizer:_tapGesture];
    }
    else
    {
        [textField resignFirstResponder];
        //        LoginAlertView * loginAlert = [[LoginAlertView alloc] initWithDelegate:self];
        //        [loginAlert show];
        LGViewController * loginVC = [[LGViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.table removeGestureRecognizer:_tapGesture];
}


-(void)tapAction
{
    //    [self.commentBar.textView resignFirstResponder];
    NSLog(@"%@",self.commentBar.commentTF);
    //    [self.commentBar.textView resignFirstResponder];
    //    [self.commentTF resignFirstResponder];
    [self.commentBar dismissKeyBoard];
}

#pragma mark -keyboardNotification
-(void)keyBoardWillHide:(NSNotification *)aNotification
{
    NSDictionary * userInfo = [aNotification userInfo];
    NSValue * aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoardRect = [aValue CGRectValue];
    //    int height = keyBoardRect.size.height;
    
    NSValue * animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = 0.0;
    [animationDurationValue getValue:&animationDurationValue];
    
    CGRect originFrame = self.commentBar.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:animationDuration];
    self.commentBar.frame = CGRectOffset(originFrame, 0, keyBoardRect.size.height);
    //    self.commentBar.frame = CGRectMake(0, originFrame.origin.y+height, originFrame.size.width, originFrame.size.height);
    [UIView commitAnimations];
    
    
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    
    NSDictionary * userInfo = [aNotification userInfo];
    NSValue * aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoardRect = [aValue CGRectValue];
    //    float height = keyBoardRect.size.height;
    NSValue * animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = 0.0;
    [animationDurationValue getValue:&animationDurationValue];
    CGRect originFrame = self.commentBar.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:animationDuration];
    self.commentBar.frame = CGRectOffset(originFrame, 0, -keyBoardRect.size.height);
    //    NSLog(@"#%f#",self.commentBar.frame.origin.y);
    //    NSLog(@"#$%f#$",height);
    //    self.commentBar.frame = CGRectMake(0, originFrame.origin.y-height, originFrame.size.width, originFrame.size.height);
    //     NSLog(@"$%f$",self.commentBar.frame.origin.y);
    [UIView commitAnimations];
    NSLog(@"$$");
}

#pragma mark -LoginAlertViewDelegate

//-(void)LoginAlertThirdLoginWithTag:(int)tag
//{
//    if (tag==1) {
//        
//        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//        
//        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
//                                      {
//                                          NSLog(@"response is %@",response);
//                                          [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
//                                              NSLog(@"SinaWeibo's user name is %@",[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"username"]);
//                                              
//                                              NSString *name=[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"username"];
//                                              if (name) {
//                                                  [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"currendUserName"];
//                                                  NSString *ico=[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"icon"];
//                                                  NSURL *url=[NSURL URLWithString:ico];
//                                                  
//                                                  NSData *mydata = [NSData dataWithContentsOfURL:url];
//                                                  if (mydata) {
//                                                      [[NSUserDefaults standardUserDefaults]setObject:mydata forKey:@"currendIco"];
//                                                  }
//                                                  //                                                  NSDictionary *icodic=[NSDictionary dictionaryWithObject:mydata forKey:name];
//                                                  //                                                  NSUserDefaults *iconame = [NSUserDefaults standardUserDefaults];
//                                                  //                                                  NSArray *arr = [iconame objectForKey:@"passico"];
//                                                  //                                                  NSMutableArray *iconame1 = [[NSMutableArray alloc] initWithArray:arr];
//                                                  //                                                  [iconame1 addObject:icodic];
//                                                  //                                                  [iconame setObject:iconame1 forKey:@"passico"];//简单存用户名储头像相关联
//                                                  //                                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"Ico" object:mydata];
//                                                  
//                                              }
//                                              
//                                          }];
//                                          
//                                      });
//        
//    }
//    if (tag==2) {
//        
//        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
//        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
//                                      {
//                                          NSLog(@"response is %@",response);
//                                          [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
//                                              NSLog(@"QQ's user name is %@",[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQQ] objectForKey:@"username"]);
//                                              
//                                              NSString *name=[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQQ] objectForKey:@"username"];
//                                              if (name) {
//                                                  [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"currendUserName"];
//                                                  NSString *ico=[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQQ] objectForKey:@"icon"];
//                                                  NSURL *url=[NSURL URLWithString:ico];
//                                                  
//                                                  
//                                                  NSData *mydata = [NSData dataWithContentsOfURL:url];
//                                                  if (mydata) {
//                                                      [[NSUserDefaults standardUserDefaults]setObject:mydata forKey:@"currendIco"];
//                                                  }
//                                                  //                                                  NSDictionary *icodic=[NSDictionary dictionaryWithObject:mydata forKey:name];
//                                                  //                                                  NSUserDefaults *iconame = [NSUserDefaults standardUserDefaults];
//                                                  //                                                  NSArray *arr = [iconame objectForKey:@"passico"];
//                                                  //                                                  NSMutableArray *iconame1 = [[NSMutableArray alloc] initWithArray:arr];
//                                                  //                                                  [iconame1 addObject:icodic];
//                                                  //                                                  [iconame setObject:iconame1 forKey:@"passico"];//简单存用户名储头像相关联
//                                                  //                                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"Ico" object:mydata];
//                                                  
//                                              }
//                                              
//                                          }];
//                                          
//                                      });
//        
//        
//    }
//    if(tag == 3)
//    {
//        ZhuceViewController *zc=[[ZhuceViewController alloc]init];
//        zc.isperson=YES;
//        [self.navigationController pushViewController:zc animated:YES];
//    }
//    
//}

#pragma mark -LiveUserInfoCellDelegate
-(void)guanzhuClick{
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"currendUserID"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *getFocusList = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [getFocusList setObject:userid forKey:@"usrId"];
    [getFocusList setObject:self.imageData.userID forKey:@"focusId"];
    [t_b setObject:getFocusList forKey:@"openFocus"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
     
            NSDictionary *getFocusList=[t_b objectForKey:@"openFocus"];
            NSString *result=[getFocusList objectForKey:@"result"];
            NSLog(@"%@",result);
   
            BOOL ischoose=YES;
       
//            [self.guanzhubut setTitle:@"已关注" forState:UIControlStateNormal];
      
        //        [self.table reloadData];
          NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:ischoose],@"state",self.imageData.userID,@"name", nil];
        NSMutableArray *marr=[[NSMutableArray alloc]init];
        [marr addObject:dic];
        [[NSUserDefaults standardUserDefaults]setObject:marr forKey:@"Guanzhu"];
        [self.table reloadData];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}

-(void)liveUserImageClick
{
    
    //    NSString * userName =[[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
    //    NSData * imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"];
    //    PersonalCenterVC * personalCenter = [[PersonalCenterVC alloc] init];
    //    personalCenter.userImage = imageData;
    //    personalCenter.userName = userName;
    //    personalCenter.type = 0;
    //    [self.navigationController pushViewController:personalCenter animated:YES];
    
}

-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath
{
    NSString *shareContent = @"";
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
		
            //		case 2: {
            //			weiboVC *t_weibo = [[weiboVC alloc] initWithNibName:@"weiboVC" bundle:nil];
            //			[t_weibo setShareText:shareContent];
            //			[t_weibo setShareImage:@"weiboShare.png"];
            //			[t_weibo setShareType:3];
            //			[rootViewController presentModalViewController:t_weibo animated:YES];
            //			[t_weibo release];
            //			break;
            //		}
//        case 1:{
//            //创建分享消息对象
//            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//            messageObject.text=@"知天气客户端是整合各省气象资源，面向大众用户开发的智能终端气象应用，提供全国3000多个城市天气预报、重点城市空气质量和深度气象信息的查询需求服务。";
//            //创建图片内容对象
//            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//            //如果有缩略图，则设置缩略图
//            [shareObject setShareImage:@"Icon.png"];
//    
//            //分享消息对象设置分享内容对象
//            messageObject.shareObject = shareObject;
//            
//            //调用分享接口
//            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//                if (error) {
//                    NSLog(@"************Share fail with error %@*********",error);
//                }else{
//                    NSLog(@"response data is %@",data);
//                }
//            }];
//            
//            break;

//            [UMSocialData defaultData].extConfig.wxMessageType =UMSocialWXMessageTypeWeb;
//			[[UMSocialControllerService defaultControllerService] setShareText:@"知天气客户端是整合各省气象资源，面向大众用户开发的智能终端气象应用，提供全国3000多个城市天气预报、重点城市空气质量和深度气象信息的查询需求服务。" shareImage:[UIImage imageNamed:@"Icon.png"] socialUIDelegate:nil];     //设置分享内容和回调对象
//            [UMSocialData defaultData].extConfig.title = shareContent;
//            //            [UMSocialData defaultData].extConfig.wechatSessionData.shareImage=[UIImage imageNamed:@"Icon"];
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//            
//            break;
//        }
//        case 2: {
//            
//            [UMSocialData defaultData].extConfig.wxMessageType =UMSocialWXMessageTypeText;
//            [[UMSocialControllerService defaultControllerService] setShareText:shareContent shareImage:nil socialUIDelegate:nil];     //设置分享内容和回调对象
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//            
//            break;
//		}
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
-(void)LiveHeadYesTableViewCellUserImageClick
{
    PersonalCenterVC * personalCenter = [[PersonalCenterVC alloc] init];
    personalCenter.type = 0;
    personalCenter.backtype=@"1";
    personalCenter.itemid=self.imageData.itemid;
    personalCenter.facusid=self.imageData.userID;
    personalCenter.userImage = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"];
    personalCenter.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
    [self.navigationController pushViewController:personalCenter animated:YES];
}

#pragma mark -UIAcitonSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
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
            //            AnnounceViewController * announceVC = [[AnnounceViewController alloc] init];
            //            announceVC.delegate = self;
            //            [self.navigationController pushViewController:announceVC animated:YES];
            //            announceVC.address = [setting sharedSetting].currentCity;
            //            announceVC.weather = [NSString stringWithFormat:@"%@ 晴 30℃",[setting sharedSetting].currentCity];
            //            announceVC.shareImg = [UIImage imageNamed:@"头像.png"];
            
        }
        
    }
    
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
        NSData * imageData = UIImagePNGRepresentation(image);
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"currendIco"];
        [self.table reloadData];
    }
    //    [picker release];
}


#pragma mark- FaceToolBarDelegate

-(void)sendTextAction:(NSString *)inputText
{
    if(inputText.length)
    {
        NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"currendUserID"];
        NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *sjkpcomments = [NSMutableDictionary dictionaryWithCapacity:4];
        [t_h setObject:[setting sharedSetting].app forKey:@"p"];
        [sjkpcomments setObject:inputText forKey:@"desc"];
        [sjkpcomments setObject:userid forKey:@"commentsUserId"];
        [sjkpcomments setObject:self.imageData.itemid forKey:@"itemId"];
        [t_b setObject:sjkpcomments forKey:@"sjkpcomments"];
        [t_dic setObject:t_h forKey:@"h"];
        [t_dic setObject:t_b forKey:@"b"];
        [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
            // NSLog(@"%@",returnData);
            
            
            NSDictionary *t_b = [returnData objectForKey:@"b"];
            NSDictionary *sjkp=[t_b objectForKey:@"sjkpcomments"];
            NSString *result=[sjkp objectForKey:@"result"];
            NSLog(@"%@",result);
            [self sjkpcommentslist];
            [self.table reloadData];
            
        } withFailure:^(NSError *error) {
            NSLog(@"failure");
            
        } withCache:YES];
        
//        NSData * imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"];
//        UIImage * image = [UIImage imageNamed:@"头像.png"];
//        if(imageData == nil)
//        {
//             imageData = UIImagePNGRepresentation(image);
//        }
//       
//        NSString * comment = inputText;
//        NSString * time = [ShareFun stringWithDate:[NSDate date]];
//        NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
//        
//        NSDictionary * dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:imageData,@"image",comment,@"comment",time,@"time",userName,@"userName",@"2",@"imageType", nil];
//        [self.commentslist addObject:dic1];
//        [self.table reloadData];
//        //        [self.commentTF resignFirstResponder];
////        self.commentTF.text = nil;
//        NSLog(@"###");
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

//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

@end
