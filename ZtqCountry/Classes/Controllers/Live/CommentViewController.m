//
//  CommentViewController.m
//  ztqFj
//
//  Created by Admin on 15-1-16.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "CommentViewController.h"
#import "LiveHeadNoTableViewCell.h"
#import "LiveFriendTableViewCell.h"
#import "EGOImageView.h"
#import "GRZXViewController.h"
#import "UILabel+utils.h"
@interface CommentViewController ()<UITextViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,LiveFriendButtonClickDelegate,zanDelegte>
@property (strong, nonatomic) NSMutableArray * friends;
@property (strong, nonatomic) NSMutableString * shareStr;
@property (strong, nonatomic) UITextView * commentTF;
@property (strong, nonatomic) UITapGestureRecognizer * tapGesture;
@property (assign, nonatomic) float originOffsetY;
@property(nonatomic,strong)UILabel *bglabel;
@property (strong, nonatomic) NSString * str;
@property (strong, nonatomic) UILabel * wordNumLab;
@property(strong,nonatomic)EGOImageView *myego;
@end


@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.barHiden=NO;
    self.titleLab.text=@"浏览照片";
    self.isdianzan=NO;
    self.isguanzhu=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-self.barHeight)];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.backgroundColor = [UIColor clearColor];
    self.originOffsetY = _table.contentOffset.y;
    [self.view addSubview:_table];

    //-----------------键盘-----------------------
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    if (![self.grtype isEqualToString:@"个人中心"]) {
        self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        
        self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
        [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    }
   
    
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
   
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.page=self.page+1;
        if (self.page>self.imagedatas.count-1) {
            self.page=self.imagedatas.count-1;
        }
        
           }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        
        self.page=self.page-1;
        if (self.page<0) {
            self.page=0;
        }
    }
    ImageInfo *data=self.imagedatas[self.page];
    self.imageData = data;
    self.commentslist=[[NSMutableArray alloc]init];
    self.t_count=5;
    [self sjkpcommentslist];
    [self sjkpaddbrowse];
}
-(void)pageAction:(UIButton *)sender{
    NSInteger tag=sender.tag;
    if (tag==222) {
        self.page=self.page+1;
        if (self.page>self.imagedatas.count-1) {
            self.page=self.imagedatas.count-1;
        }
    }else{
        self.page=self.page-1;
        if (self.page<0) {
            self.page=0;
        }
    }
    ImageInfo *data=self.imagedatas[self.page];
    self.imageData = data;
    self.commentslist=[[NSMutableArray alloc]init];
    self.t_count=5;
    [self sjkpcommentslist];
    [self sjkpaddbrowse];
}
-(void)getdatasindex:(ImageInfo *)data{
    for (int i=0; i<self.imagedatas.count; i++) {
//        NSLog(@"%@",self.imagedatas[i]);
//        NSLog(@"%@",data);
        ImageInfo *d=self.imagedatas[i];
        NSString *itemid=data.itemid;
        NSString *newitemid=d.itemid;
//        if (self.imagedatas[i] ==data) {
//            self.page=i;
//        }
        if ([newitemid isEqualToString:itemid]) {
            self.page=i;
           
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self sjkpaddbrowse];
    [self getdatasindex:self.imageData];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//进入页面增加浏览量
-(void)sjkpaddbrowse{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sjkpaddbrowse = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [sjkpaddbrowse setObject:self.imageData.itemid forKey:@"item_id"];
    if ([setting getSysUid].length>0) {
         [sjkpaddbrowse setObject:[setting getSysUid] forKey:@"imei"];
    }
   
    [t_b setObject:sjkpaddbrowse forKey:@"gz_scenery_add_browse"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *sjkp=[t_b objectForKey:@"gz_scenery_add_browse"];
        NSString *result=[sjkp objectForKey:@"result"];
        if ([result isEqualToString:@"1"]) {
            self.isguanzhu=YES;
             [self.table reloadData];
        }
       
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(id)initWithImageData:(ImageInfo *)imageData
{
    self = [super init];
    if(self)
    {
        self.imageData = imageData;
        self.commentslist=[[NSMutableArray alloc]init];
        self.t_count=5;
        [self sjkpcommentslist];
    }
    return self;
}
-(id)initWithImageData:(ImageInfo *)imageData with:(NSString *)type{
    self = [super init];
    if(self)
    { 
        self.imageData = imageData;
        self.commentslist=[[NSMutableArray alloc]init];
        self.t_count=5;
        self.grtype=type;
        [self sjkpcommentslist];
    }
    return self;
}
-(void)sjkpcommentslist{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sjkpcommentslist = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [sjkpcommentslist setObject:[NSString stringWithFormat:@"%d",self.t_count] forKey:@"count"];
    [sjkpcommentslist setObject:@"1"forKey:@"page"];
    [sjkpcommentslist setObject:self.imageData.itemid forKey:@"item_id"];
    [t_b setObject:sjkpcommentslist forKey:@"gz_scenery_comments_list"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo :self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *sjkp=[t_b objectForKey:@"gz_scenery_comments_list"];
        self.commentslist=[sjkp objectForKey:@"comments"];
        self.commentslist=[[self.commentslist reverseObjectEnumerator]allObjects];
//        NSArray *comments=[sjkp objectForKey:@"idx"];
//        for (int i=comments.count-1; i<comments.count; i--) {
// 
//            [self.commentslist addObject:comments[i]];
//        }
        [self.table reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
       [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } withCache:YES];
}
#pragma mark -tableView

//1(+35)、2(30)
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float width = self.imageData.width;
    float height = self.imageData.height;
////    NSString *thumbURL = self.imageData.thumbURL;
//    float newHeight = height/width*320+50;
    if(indexPath.section == 0)
    {
        CGFloat newHeight=120;
        EGOImageView *ego=[[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth, 120)];
        [ego setImageURL:[ShareFun makeImageUrl:self.imageData.thumbURL]];
        
        newHeight=ego.image.size.height*[UIScreen mainScreen].bounds.size.width/ego.image.size.width;
//        NSLog(@"%f",newHeight);
        if (isnan(newHeight)) {
            newHeight=height/width*kScreenWidth+120;
        }
        return newHeight+50;
    }else if (indexPath.section==1){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else if (indexPath.section==3){
        if (self.commentslist.count==indexPath.row) {
            return 35;
        }
        return 70;
    }else if (indexPath.section==2){
        return 100;
    }
    
    else
    {
        return 60;
    }
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
    if (section==0) {
//        LiveHeadNoTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"HeadNoCell"];
//        cell1.delegate=self;
//        if (cell1 != nil)
//            [cell1 removeFromSuperview];
//        if(cell1 == nil)
//        {
//            cell1 = [[LiveHeadNoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeadNoCell" withImageInfo:self.imageData withtype:self.single];
//        }
//        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell1;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        float width = self.imageData.width;
        float height = self.imageData.height;
        NSString *thumbURL = self.imageData.thumbURL;
        //        float newHeight = 240;
        float newHeight = height/width*CGRectGetWidth(cell.frame)+120;
        EGOImageView *ego=[[EGOImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.frame), newHeight)];
        [ego setImageURL:[ShareFun makeImageUrl:thumbURL]];
        self.myego=ego;
        ego.userInteractionEnabled=YES;
//        ego.contentMode = UIViewContentModeScaleAspectFill;
//       ego.clipsToBounds = YES;
        [cell.contentView addSubview:ego];
        newHeight=ego.image.size.height*[UIScreen mainScreen].bounds.size.width/ego.image.size.width;
        if (isnan(newHeight)) {
            newHeight=height/width*kScreenWidth+120;
        }
        self.myheight=newHeight;
         ego.frame=CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, newHeight);
        
        UIButton *bigbtn=[[UIButton alloc]initWithFrame:ego.frame];
        [bigbtn addTarget:self action:@selector(bigAction) forControlEvents:UIControlEventTouchUpInside];
        [ego addSubview:bigbtn];
        
         if (![self.grtype isEqualToString:@"个人中心"]) {
        UIButton *leftbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, newHeight/2, 25, 44)];
        leftbtn.tag=111;
        [leftbtn setBackgroundImage:[UIImage imageNamed:@"上图常态"] forState:UIControlStateNormal];
        [leftbtn setBackgroundImage:[UIImage imageNamed:@"上图二态"] forState:UIControlStateHighlighted];
        [leftbtn addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
        [ego addSubview:leftbtn];
        UIButton *rightbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-25, newHeight/2, 25, 44)];
        rightbtn.tag=222;
        [rightbtn setBackgroundImage:[UIImage imageNamed:@"下图常态"] forState:UIControlStateNormal];
        [rightbtn setBackgroundImage:[UIImage imageNamed:@"下图二态"] forState:UIControlStateHighlighted];
        [rightbtn addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
        [ego addSubview:rightbtn];
             
            
             
         }
        
        UIImageView * butBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, newHeight, kScreenWidth, 50)];
        butBg.image = [UIImage imageNamed:@"grzx1浏览回复线框.png"];
        butBg.userInteractionEnabled = YES;
        [cell.contentView addSubview:butBg];
       
//        UIImage * userImg = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"]];
        EGOImageView *tximg=[[EGOImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
         tximg.image=[UIImage imageNamed:@"个人图标"];
//        if(userImg) self.userImg=userImg;
        if(self.imageData.userImg&&![self.imageData.userImg isEqualToString:@""]){
           NSURL *url=[NSURL URLWithString:self.imageData.userImg];
                [tximg setImageURL:url];
        }else{
            tximg.image=[UIImage imageNamed:@"个人图标"];
        }
        tximg.contentMode=UIViewContentModeScaleAspectFill;
        tximg.layer.cornerRadius=tximg.width*0.5;
        if (self.head_url) {
                tximg.imageURL=[NSURL URLWithString:self.head_url];
            }
        
        tximg.layer.masksToBounds=YES;
        [butBg addSubview:tximg];
        
//        EGOImageView *tximg=[[EGOImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
////        tximg.image=[UIImage imageNamed:@"个人图标"];
//        tximg.placeholderImage=[UIImage imageNamed:@"个人图标"];
//        NSURL *url=[NSURL URLWithString:self.imageData.userImg];
//        [tximg setImageURL:url];
//        tximg.layer.cornerRadius = 20;
//        tximg.layer.masksToBounds = YES;
//        [butBg addSubv                                                                                                 iew:tximg];
//        if (self.userImg) {
//            tximg.image=self.userImg;
//        }
        UILabel *nicklab=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 150, 30)];
        nicklab.text=self.imageData.userName;
        if (self.nickname) {
            nicklab.text=self.nickname;
        }
        nicklab.textColor=[UIColor grayColor];
        nicklab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:nicklab];
        UIButton *grbtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 180, 30)];
        grbtn.tag=11;
        [grbtn addTarget:self action:@selector(grzxAction) forControlEvents:UIControlEventTouchUpInside];
        [butBg addSubview:grbtn];
        
        UIImageView *browseimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-140, 10, 25, 25)];
        browseimg.image=[UIImage imageNamed:@"浏览量"];
        [butBg addSubview:browseimg];
        UILabel *browselab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-105, 10, 55, 30)];
        
        if (self.isguanzhu==YES) {
            self.imageData.commentNum=self.imageData.commentNum+1;
            self.isguanzhu=NO;
            
        }
        browselab.text=[NSString stringWithFormat:@"%d",self.imageData.commentNum];
        browselab.textColor=[UIColor grayColor];
        browselab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:browselab];
        NSString *isclick=[[NSUserDefaults standardUserDefaults]objectForKey:self.imageData.itemid];
        if (![isclick isEqualToString:@"1"]) {
            UIImageView *xinimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-70,10, 25, 25)];
            xinimg.image=[UIImage imageNamed:@"喜欢.png"];
            xinimg.userInteractionEnabled=YES;
            [butBg addSubview:xinimg];
            
            UIButton * zanBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-70,10, 60, 35)];
//            self.guanyuBut = zanBut;
            zanBut.tag=22;
//            [zanBut setBackgroundImage:[UIImage imageNamed:@"点赞.png"] forState:UIControlStateNormal];
//            [zanBut setBackgroundImage:[UIImage imageNamed:@"点赞 点击.png"] forState:UIControlStateHighlighted];
            [zanBut addTarget:self action:@selector(zanActionWithTag) forControlEvents:UIControlEventTouchUpInside];
            [butBg addSubview:zanBut];

        }else{
            UIImageView *xinimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-70,10, 25, 25)];
//            xinimg.image=[UIImage imageNamed:@"点赞.png"];
            [butBg addSubview:xinimg];
            xinimg.layer.contents = (id)[UIImage imageNamed:@"点赞"].CGImage;
            CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            k.values = @[@(0.1),@(1.0),@(1.5)];
            k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
            k.calculationMode = kCAAnimationLinear;
            [xinimg.layer addAnimation:k forKey:@"SHOW"];
        }
        
        UILabel *zanlab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-40, 10, 50, 30)];
                if ([self.imageData.click_type isEqualToString:@"0"]) {
                    if (self.isdianzan==YES) {
                        self.imageData.zanNum=self.imageData.zanNum+1;
                        self.isdianzan=NO;
                        
                    }
                    
                }
        zanlab.text=[NSString stringWithFormat:@"%d",self.imageData.zanNum];
        zanlab.textColor=[UIColor grayColor];
        zanlab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:zanlab];

    }
    if (section==1) {
        CGRect cellFrame = [cell frame];
        cellFrame.size.height = 180;
        UIImageView * butBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
        butBg.backgroundColor=[UIColor whiteColor];
        butBg.userInteractionEnabled = YES;
        [cell addSubview:butBg];
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(5, 44, kScreenWidth-10, 1)];
        line.backgroundColor=[UIColor grayColor];
        [butBg addSubview:line];
        UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(5, 88, kScreenWidth-10, 1)];
        line1.backgroundColor=[UIColor grayColor];
        [butBg addSubview:line1];
        UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(5, 132, kScreenWidth-10, 1)];
        line2.backgroundColor=[UIColor grayColor];
        [butBg addSubview:line2];
        UILabel *wzlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 50, 30)];
        wzlab.text=@"位置:";
        wzlab.textColor=[UIColor grayColor];
        wzlab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:wzlab];
        UILabel *timelab=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, 50, 30)];
        timelab.text=@"时间:";
        timelab.textColor=[UIColor grayColor];
        timelab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:timelab];
        UILabel *tqlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 95, 80, 30)];
        tqlab.text=@"天气状况:";
        tqlab.textColor=[UIColor grayColor];
        tqlab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:tqlab];
        UILabel *deslab=[[UILabel alloc]initWithFrame:CGRectMake(10, 140, 80, 30)];
        deslab.text=@"图片描述:";
        deslab.textColor=[UIColor grayColor];
        deslab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:deslab];
        UILabel *addresslab=[[UILabel alloc]initWithFrame:CGRectMake(50, 5, kScreenWidth-60, 30)];
        addresslab.text=self.imageData.address;
        addresslab.textColor=[UIColor grayColor];
        addresslab.numberOfLines=0;
        addresslab.font=[UIFont systemFontOfSize:12];
        [butBg addSubview:addresslab];
        UILabel *tlab=[[UILabel alloc]initWithFrame:CGRectMake(50, 50, kScreenWidth-60, 30)];
        tlab.text=self.imageData.shareTime;
        tlab.textColor=[UIColor grayColor];
        tlab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:tlab];
        UILabel *wealab=[[UILabel alloc]initWithFrame:CGRectMake(80, 95, kScreenWidth-60, 30)];
        wealab.text=self.imageData.weather;
        wealab.textColor=[UIColor grayColor];
        wealab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:wealab];
        UILabel *mslab=[[UILabel alloc]initWithFrame:CGRectMake(80, 140, kScreenWidth-60, 30)];
        mslab.text=self.imageData.des;
        mslab.textColor=[UIColor grayColor];
        mslab.numberOfLines=0;
        mslab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:mslab];
        float h=[mslab labelheight:self.imageData.des withFont:[UIFont systemFontOfSize:14]];
        if (h>30) {
            mslab.frame=CGRectMake(80, 140, kScreenWidth-80, h+10);
            butBg.frame=CGRectMake(0, 0, kScreenWidth, 140+mslab.frame.size.height);
            cellFrame.size.height=140+mslab.frame.size.height;
        }else{
            cellFrame.size.height=180;
        }
        
        [cell setFrame:cellFrame];
    }
    if (section==3) {
       
        if (indexPath.row!=self.commentslist.count) {
            NSDictionary * userInfoDic = [self.commentslist objectAtIndex:indexPath.row];
            //        NSString * imageType = [userInfoDic objectForKey:@"imageType"];
            NSString * comment = [userInfoDic objectForKey:@"des"];
            NSString * time = [userInfoDic objectForKey:@"time"];
            NSString * userName = [userInfoDic objectForKey:@"nick_name"];
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
            EGOImageView *ego=[[EGOImageView alloc]init];
            NSURL *url=[NSURL URLWithString:image];
            [ego setImageURL:url];
            if (ego.image) {
                friendCell.userImg.image=ego.image;
            }else{
                friendCell.userImg.image=[UIImage imageNamed:@"个人图标"];
            }
            
            
            friendCell.userName.text = userName;
            friendCell.commentLab.text = comment;
            friendCell.timeLab.text = time;
            //        NSLog(@"##################%@#######",comment);
            return friendCell;
        }else{
            
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 30)];
            lab.text=@"点击加载更多";
            lab.textAlignment=NSTextAlignmentCenter;
            lab.textColor=[UIColor grayColor];
            [cell addSubview:lab];
//            return friendCell;
        }
    }
    if (section==2) {
        UIImageView * butBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        butBg.backgroundColor=[UIColor whiteColor];
        butBg.userInteractionEnabled = YES;
        [cell addSubview:butBg];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
        lab.text=@"输入评论:";
        lab.textColor=[UIColor grayColor];
        lab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:lab];
        UIImageView *textimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 30, kScreenWidth-80, 60)];
        textimg.image=[UIImage imageNamed:@"输入框.png"];
        textimg.userInteractionEnabled=YES;
        [butBg addSubview:textimg];
        self.commentTF=[[UITextView alloc]initWithFrame:CGRectMake(5, 5, kScreenWidth-95, 50)];
        self.commentTF.delegate=self;
//        self.commentTF.text=self.tvtext;
        self.commentTF.hidden=NO;
        self.commentTF.returnKeyType=UIReturnKeyDone;
        [textimg addSubview:self.commentTF];
       
        
        
        self.bglabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 300, 30)];
        [self.bglabel setBackgroundColor:[UIColor clearColor]];
//        if (self.tvtext.length>0) {
//            self.bglabel.text=nil;
//        }else{
            self.bglabel.text=@"请输入您的描述";
//        }
        self.str=self.bglabel.text;
        [self.bglabel setTextColor:[UIColor blackColor]];
        self.bglabel.enabled=NO;
        [self.bglabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [self.commentTF addSubview:self.bglabel];
        
        _wordNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(textimg.frame)-30, 20)];
        _wordNumLab.backgroundColor = [UIColor clearColor];
        _wordNumLab.textAlignment = NSTextAlignmentRight;
        _wordNumLab.font = [UIFont fontWithName:kBaseFont size:12];
        _wordNumLab.textColor = [UIColor grayColor];
        _wordNumLab.text = @"0";
        [textimg addSubview:_wordNumLab];
        
        UILabel * wordAcountLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(textimg.frame)-30, 40, 30, 20)];
        wordAcountLab.backgroundColor = [UIColor clearColor];
        wordAcountLab.textAlignment = NSTextAlignmentLeft;
        wordAcountLab.font = [UIFont fontWithName:kBaseFont size:12];
        wordAcountLab.textColor = [UIColor grayColor];
        wordAcountLab.text = @"/100";
        [textimg addSubview:wordAcountLab];
        
        UIButton *tjbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-20-40, 35, 50, 30)];
        [tjbtn setTitle:@"提交" forState:UIControlStateNormal];
        [tjbtn setBackgroundImage:[UIImage imageNamed:@"实景提交按钮常态"] forState:UIControlStateNormal];
        [tjbtn setBackgroundImage:[UIImage imageNamed:@"实景提交按钮二态"] forState:UIControlStateHighlighted];
        [tjbtn addTarget:self action:@selector(tjAction) forControlEvents:UIControlEventTouchUpInside];
        [butBg addSubview:tjbtn];
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
    if (userid.length>0) {
        return 4;
    }else
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSString * userName =[[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
    if(userName.length)
    {
        return 10;
    }
    else
    {
        return 10;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
        
    }else if (section==1){
        return 1;
    }else if (section==3){
        if (self.commentslist.count>0) {
            return self.commentslist.count+1;
        }else
            return 0;
        
    }
    else
    {
        return 1;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==3) {
        if (indexPath.row==self.commentslist.count) {
            NSLog(@"加载更多");
            self.t_count=self.t_count+5;
            [self.commentslist removeAllObjects];
            [self sjkpcommentslist];
        }
    }
//    if(self.single == 1)
//    {
//        if(indexPath.section == 0)
//        {
//            if(indexPath.row == 1)
//            {
//                //            PersonalCenterVC * personalCenter = [[PersonalCenterVC alloc] init];
//                //            if([self.imageData.imageType isEqualToString:@"1"])
//                //            {
//                //                UIImage * image = [UIImage imageNamed:self.imageData.userImg];
//                //                personalCenter.userImage = UIImagePNGRepresentation(image);
//                //            }
//                //            else
//                //            {
//                //                personalCenter.userImage = self.imageData.imageData;
//                //            }
//                //            personalCenter.userName = self.imageData.userName;
//                //            [self.navigationController pushViewController:personalCenter animated:YES];
//                return;
//            }
//        }
//        if(indexPath.section!= 0)
//        {
//            NSDictionary * userInfoDic = [self.friends objectAtIndex:indexPath.row];
//            //            initWithObjectsAndKeys:imageData,@"image",comment,@"comment",time,@"time",userName,@"userName",@"2",@"imageType", nil];
//            NSData * imageData = [[NSData alloc] init];
//            NSString * imageType = [userInfoDic objectForKey:@"imageType"];
//            if([imageType isEqualToString:@"2"])
//            {
//                imageData = [userInfoDic objectForKey:@"image"];
//            }
//            else
//            {
//                NSString * image = [userInfoDic objectForKey:@"image"];
//                UIImage * img = [UIImage imageNamed:image];
//                imageData = UIImagePNGRepresentation(img);
//            }
//            
//            //        NSString * comment = [userInfoDic objectForKey:@"comment"];
//            //        NSString * time = [userInfoDic objectForKey:@"time"];
//            NSString * userName = [userInfoDic objectForKey:@"userName"];
//            PersonalCenterVC * personalCenter = [[PersonalCenterVC alloc] init];
//            personalCenter.type = 1;
//            personalCenter.backtype=@"1";
//            personalCenter.userImage = imageData;
//            personalCenter.userName = userName;
//            [self.navigationController pushViewController:personalCenter animated:YES];
//        }
//        
//    }
    
}
-(void)bigAction{
    [self showImage:self.myego];
}
-(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
   
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:[avatarImageView convertRect:avatarImageView.bounds toView:window]];
    self.imageView=imageView;
    imageView.userInteractionEnabled=YES;
    imageView.image=image;
    imageView.tag=1;
//    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _scroll.minimumZoomScale = .5;
    _scroll.maximumZoomScale = 5;
    _scroll.delegate = self;
    _scroll.directionalLockEnabled = YES;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleAction)];
    doubleTap.numberOfTapsRequired = 2;
    [_scroll addGestureRecognizer:doubleTap];
    [_scroll addSubview:imageView];
    [backgroundView addSubview:_scroll];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    if (image) {
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
            backgroundView.alpha=1;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=[self.myego convertRect:self.myego.bounds toView:window];
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}
- (void)doubleAction{
    if(_scroll.zoomScale != 1){
        _scroll.zoomScale = 1;
    }else{
        _scroll.zoomScale = 5;
    }
    [self contentScroller];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    [self contentScroller];
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.imageView;
}
- (void)contentScroller{
    CGRect f = self.imageView.frame;
    CGSize size = _scroll.frame.size;
    
    if(f.size.width < size.width){
        f.origin.x = (kScreenWidth - f.size.width)/2;
    }else{
        f.origin.x = 0.0f;
    }
    if(f.size.height < size.height){
        f.origin.y = (kScreenHeitht - f.size.height)/2;
    }else{
        f.origin.y = 0.0f;
    }
    self.imageView.frame = f;
}

//点击头像跳转个人中心
-(void)grzxAction{
//    GRZXViewController *per=[[GRZXViewController alloc]init];
//    [self.navigationController pushViewController:per animated:YES];
}
//用户点赞
-(void)zanActionWithTag{
     NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *clickgood = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    if (userid.length>0) {
         [clickgood setObject:userid forKey:@"user_id"];
    }else{
        [clickgood setObject:[setting getSysUid] forKey:@"imei"];
    }
    [clickgood setObject:self.imageData.itemid forKey:@"item_id"];
    
    [t_b setObject:clickgood forKey:@"gz_scenery_user_agree"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *sjkp=[t_b objectForKey:@"gz_scenery_user_agree"];
        NSString *result=[sjkp objectForKey:@"result"];
        if ([result isEqualToString:@"1"]) {
            self.isdianzan=YES;
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:self.imageData.itemid];
            [[NSUserDefaults standardUserDefaults]synchronize];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"updatesjkp" object:nil];
            [self.table reloadData];
            
            
        }
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
-(void)tjAction{
    [self sjkpcomments];
}
//提交评论
-(void)sjkpcomments{
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sjkpcomments = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [sjkpcomments setObject:self.commentTF.text forKey:@"desc"];
    if (userid.length>0) {
        [sjkpcomments setObject:userid forKey:@"user_id"];
    }
    [sjkpcomments setObject:self.imageData.itemid forKey:@"item_id"];
    
    [t_b setObject:sjkpcomments forKey:@"gz_scenery_comments"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *sjkp=[t_b objectForKey:@"gz_scenery_comments"];
        NSString *result=[sjkp objectForKey:@"result"];
        if ([result isEqualToString:@"1"]) {
            [self.commentslist removeAllObjects];
            [self sjkpcommentslist];
            
        }
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.commentTF resignFirstResponder];
}

#pragma mark - UITextView
-(void)textViewDidBeginEditing:(UITextView *)textView{
     self.bglabel.hidden = YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([text isEqualToString:@"\n"]) {
//        [self tjAction];
//        self.commentTF.text=textView.text;
        self.tvtext=textView.text;
        [self.commentTF resignFirstResponder];
//        return NO;
    }
    if (![text isEqualToString:@""]) {
        self.bglabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.bglabel.hidden = NO;
    }
    
    
    self.wordNumLab.text = [NSString stringWithFormat:@"%d",new.length];
    NSInteger res = 100-[new length];
    if(res > 0)
    {
        return YES;
    }
    else
    {
        NSRange rg = {0,[text length]+res};
        if(rg.length>0)
        {
            NSString * s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"您的评论超出了指定范围请重写" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alre show];
        return NO;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{

    self.wordNumLab.text =  [NSString stringWithFormat:@"%d", [textView.text length]];
    NSInteger res = 100-[textView.text length];
    if(res<=0)
    {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"您的评论超出了指定范围请重写" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alre show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        self.commentTF.text=nil;
        self.wordNumLab.text=[NSString stringWithFormat:@"%d", 0];
    }
}
#pragma mark keyboardWillhe
- (void)changeShareContentHeight:(float)t_height withDuration:(float)t_dration
{
//    float width = self.imageData.width;
//    float height = self.imageData.height;
//    float newHeight = height/width*320+50;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:t_dration];
    [UIView setAnimationDelegate:self];
//    [self.table setFrame:CGRectMake(0, self.barHeight, kScreenWidth, CGRectGetHeight(self.view.frame)-300)];
    [self.table setContentOffset:CGPointMake(0, self.myheight+90)];
    NSLog(@"%f",self.table.contentOffset.y);
    [UIView commitAnimations];
}
-(void)changeNewview
{
    float width = self.imageData.width;
    float height = self.imageData.height;
    float newHeight = height/width*320+50;
    [self.table setContentOffset:CGPointMake(0, newHeight)];

}
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self changeShareContentHeight:keyboardRect.size.height withDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGRect keyboardRect = [animationDurationValue CGRectValue];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
//    [self changeShareContentHeight:keyboardRect.size.height withDuration:animationDuration];
    [self changeNewview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
