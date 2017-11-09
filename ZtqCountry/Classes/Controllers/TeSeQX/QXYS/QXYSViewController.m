//
//  QXYSViewController.m
//  ZtqCountry
//
//  Created by Admin on 14-8-13.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "QXYSViewController.h"
#import "VideoViewController.h"
#import "MedaiModel.h"
#import "EGORefreshTableFooterView.h"
#import "YSDetailViewController.h"
#import "UILabel+utils.h"
#import "WebViewController.h"
#import "QXXZBViewController.h"
//#import "EGOImageView.h"
@interface QXYSViewController ()<EGORefreshTableFooterDelegate>
@property (strong, nonatomic) EGORefreshTableFooterView * refreshFooterView;

@end

@implementation QXYSViewController

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
    // Do any additional setup after loading the view.
    self.barHiden=NO;
    self.titleLab.text=@"气象影视";
    self.view.backgroundColor=[UIColor whiteColor];
    

    
//    self.viedoarrname=[[NSArray alloc]initWithObjects:@"0119东南快讯",@"0119东南快讯",@"0119东南快讯",@"0119东南快讯",@"0119东南快讯",@"0119东南快讯",@"0119东南快讯",@"0119东南快讯", nil];
//    self.viedoico=[[NSArray alloc]initWithObjects:@"qxys",@"qxys1",@"qxys2",@"qxys3",@"qxys2",@"qxys3",@"qxys2",@"qxys3", nil];

      self.adfx_contents=[[NSMutableArray alloc]init];
    self.adimgurls=[[NSMutableArray alloc]init];
    self.adtitles=[[NSMutableArray alloc]init];
    self.adurls=[[NSMutableArray alloc]init];
    self.isad=NO;
    self.viedoarr = [[NSMutableArray alloc] initWithCapacity:4];
    
    
    self.m_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight) style:UITableViewStylePlain];
    self.m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_tableview.backgroundColor=[UIColor clearColor];
    self.m_tableview.backgroundView=nil;
    self.m_tableview.autoresizesSubviews = YES;
    self.m_tableview.showsHorizontalScrollIndicator = YES;
    self.m_tableview.showsVerticalScrollIndicator = YES;
    self.m_tableview.delegate = self;
    self.m_tableview.dataSource = self;
    [self.view addSubview:self.m_tableview];
    
    
    [self loadMainAD:@"30"];
    [self getqxys];
    
    
    
    
    
}
//加载首页大广告
-(void)loadMainAD:(NSString *)type{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:type forKey:@"position_id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_ad"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            [self.adimgurls removeAllObjects];
            [self.adtitles removeAllObjects];
            [self.adurls removeAllObjects];
                [self.adfx_contents removeAllObjects];
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];
            for (int i=0; i<adlist.count; i++) {
                NSString *url=[adlist[i] objectForKey:@"url"];
                NSString *title=[adlist[i] objectForKey:@"title"];
                NSString *imgurl=[adlist[i] objectForKey:@"img_path"];
                NSString *fx_content=[adlist[i] objectForKey:@"fx_content"];
                if (fx_content.length>0) {
                    [self.adfx_contents addObject:fx_content];
                }
                [self.adurls addObject:url];
                [self.adtitles addObject:title];
                [self.adimgurls addObject:imgurl];
            }
            if (adlist.count>0) {
                self.isad=YES;
            }else{
                self.isad=NO;
            }
            [self.m_tableview reloadData];
            
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        self.isad=NO;
        [self.m_tableview reloadData];
    } withCache:YES];
}
-(void)getqxys{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary * t_qxys = [[NSMutableDictionary alloc] init];
    
    //    [t_qxys setObject:@"10" forKey:@"qxmedia"];
    [t_b setObject:t_qxys forKey:@"gz_wt_video"];

    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        //        NSLog(@"%@",returnData);
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        if (t_b != nil)
        {
            NSDictionary *art_channel = [t_b objectForKey:@"gz_wt_video"];
            NSArray *t_array = [art_channel objectForKey:@"media"];
            
            [self.viedoarr removeAllObjects];
            //			[m_titleModelArr release];
            
            
            for (int i=0; i<[t_array count]; i++) {
                MedaiModel *medaimd=[[MedaiModel alloc]init];
                medaimd.title=[[t_array objectAtIndex:i]objectForKey:@"title"];
                medaimd.medaiurl=[[t_array objectAtIndex:i]objectForKey:@"mediaurl"];
                medaimd.imgurl=[[t_array objectAtIndex:i]objectForKey:@"imageurl"];
                medaimd.desc=[[t_array objectAtIndex:i]objectForKey:@"desc"];
                medaimd.time=[[t_array objectAtIndex:i]objectForKey:@"time"];
                medaimd.fxurl=[[t_array objectAtIndex:i]objectForKey:@"fxurl"];
                [self.viedoarr addObject:medaimd];
                
            }
        }
//        [self creatviedo];
        [self.m_tableview reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } withCache:YES];
}
-(BOOL)shouldAutorotate
{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)yszbbuttonClick:(int)vid
{
//    NSLog(@"Click--OK%d",vid);
    NSString *url=self.adurls[vid-1];
    if (url.length>0) {
        QXXZBViewController *adVC = [[QXXZBViewController alloc]init];
        adVC.url = self.adurls[vid-1];
        adVC.titleString =self.adtitles[vid-1];
        if (self.adfx_contents.count>0) {
            adVC.shareContent=self.adfx_contents[vid-1];
        }
        [self.navigationController pushViewController:adVC animated:YES];
    }
    
}

#pragma mark -UITableDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.isad==YES) {
        return self.viedoarr.count+1;
    }
    return self.viedoarr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    if (indexPath.row==0) {
//        return 150;
//    }
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
    if (self.isad==YES) {
        if (row==0) {
            self.bmadscro = [[YSZBBanerScrollview alloc] initWithNameArr:self.adimgurls  titleArr:self.adtitles height:160 offsetY:0 offsetx:10];
            self.bmadscro.vDelegate = self;
            [cell addSubview:self.bmadscro];
            CGRect cellFrame = [cell frame];
            cellFrame.size.height =160;
            [cell setFrame:cellFrame];
        }else{
            EGOImageView *ego = [[EGOImageView alloc] initWithFrame:CGRectMake(10,5,kScreenWidth-20,150)];
            ego.placeholderImage=[UIImage imageNamed:@"影视背景.jpg"];
            [cell addSubview:ego];
            ego.userInteractionEnabled=YES;
            MedaiModel *medai=[self.viedoarr objectAtIndex:row-1];
            [ego setImageURL:[ShareFun makeImageUrl:medai.imgurl]];
            
            
            UIImageView *bofa=[[UIImageView alloc]initWithFrame:CGRectMake(145, 60, 30, 30)];
            bofa.image=[UIImage imageNamed:@"气象影视_06"];
            [ego addSubview:bofa];
            
            UILabel *delila=[[UILabel alloc]initWithFrame:CGRectMake(5, 160,140, 30)];
            NSString *desc=[NSString stringWithFormat:@"%@",medai.title];
            delila.text=desc;
            delila.adjustsFontSizeToFitWidth=YES;
            delila.textColor=[UIColor blackColor];
            delila.font=[UIFont systemFontOfSize:14];
            delila.textAlignment=NSTextAlignmentLeft;
            delila.numberOfLines=0;
            [cell addSubview:delila];
            
            UILabel *timelab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-180, 160, 175, 30)];
            NSString *time=[NSString stringWithFormat:@"首播:%@",medai.time];
            timelab.text=time;
            timelab.textAlignment=NSTextAlignmentRight;
            timelab.textColor=[UIColor blackColor];
            timelab.font=[UIFont systemFontOfSize:14];
            timelab.numberOfLines=0;
            [cell addSubview:timelab];
            
            UILabel *contentlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 190, kScreenWidth-20, 30)];
            NSString *content=[NSString stringWithFormat:@"%@",medai.desc];
            contentlab.text=content;
            contentlab.textColor=[UIColor grayColor];
            contentlab.font=[UIFont systemFontOfSize:14];
            contentlab.numberOfLines=0;
            [cell addSubview:contentlab];
            float h=[contentlab labelheight:content withFont:[UIFont systemFontOfSize:14]];
            contentlab.frame=CGRectMake(10, 190, kScreenWidth-20, h+20);
            
            CGRect cellFrame = [cell frame];
            cellFrame.size.height =150+delila.frame.size.height+contentlab.frame.size.height+10;
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10, cellFrame.size.height-5, kScreenWidth-20, 0.7)];
            line.backgroundColor=[UIColor grayColor];
            [cell addSubview:line];
            [cell setFrame:cellFrame];
        }
    }else{
        EGOImageView *ego = [[EGOImageView alloc] initWithFrame:CGRectMake(10,5,kScreenWidth-20,150)];
        ego.placeholderImage=[UIImage imageNamed:@"影视背景.jpg"];
        [cell addSubview:ego];
        ego.userInteractionEnabled=YES;
        MedaiModel *medai=[self.viedoarr objectAtIndex:row];
        [ego setImageURL:[ShareFun makeImageUrl:medai.imgurl]];
        

        UIImageView *bofa=[[UIImageView alloc]initWithFrame:CGRectMake(145, 60, 30, 30)];
        bofa.image=[UIImage imageNamed:@"气象影视_06"];
        [ego addSubview:bofa];

        UILabel *delila=[[UILabel alloc]initWithFrame:CGRectMake(0, 160, kScreenWidth-20, 30)];
        NSString *desc=[NSString stringWithFormat:@"%@",medai.title];
        delila.text=desc;
        delila.textColor=[UIColor blackColor];
        delila.font=[UIFont systemFontOfSize:15];
        delila.textAlignment=NSTextAlignmentLeft;
        delila.numberOfLines=0;
        [cell addSubview:delila];
        
        UILabel *timelab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-175, 160, 172, 30)];
        NSString *time=[NSString stringWithFormat:@"首播:%@",medai.time];
        timelab.text=time;
        timelab.textAlignment=NSTextAlignmentRight;
        timelab.textColor=[UIColor blackColor];
        timelab.font=[UIFont systemFontOfSize:14];
        timelab.numberOfLines=0;
        [cell addSubview:timelab];
        
        UILabel *contentlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 190, kScreenWidth-20, 30)];
        NSString *content=[NSString stringWithFormat:@"%@",medai.desc];
        contentlab.text=content;
        contentlab.textColor=[UIColor grayColor];
        contentlab.font=[UIFont systemFontOfSize:14];
        contentlab.numberOfLines=0;
        [cell addSubview:contentlab];
        float h=[contentlab labelheight:content withFont:[UIFont systemFontOfSize:14]];
        contentlab.frame=CGRectMake(10, 190, kScreenWidth-20, h+20);
    
        CGRect cellFrame = [cell frame];
        cellFrame.size.height =150+delila.frame.size.height+contentlab.frame.size.height+10;
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10, cellFrame.size.height-5, kScreenWidth-20, 0.7)];
        line.backgroundColor=[UIColor grayColor];
        [cell addSubview:line];
        [cell setFrame:cellFrame];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (self.isad==YES) {
        row=indexPath.row-1;
        if (row==0) {
            return;
        }
    }else{
        row=indexPath.row;
    }
    YSDetailViewController *ysd=[[YSDetailViewController alloc]init];
    MedaiModel *medai=[self.viedoarr objectAtIndex:row];
    ysd.viedourl=medai.medaiurl;
    ysd.imgurl=medai.imgurl;
    ysd.des=medai.desc;
    ysd.titlstr=medai.title;
    ysd.time=medai.time;
    ysd.fxurl=medai.fxurl;
    [self.navigationController pushViewController:ysd animated:YES];
}

-(void)creatviedo{
    
    //    self.bgScrollView.contentSize=CGSizeMake(320,self.nowhight);
    //    _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.bgScrollView.contentSize.height-150, self.bgScrollView.frame.size.width,self.bgScrollView.frame.size.height)];
    //
    //
    //    _refreshFooterView.delegate = self;
    //    [self.bgScrollView addSubview:_refreshFooterView];
    
    
    
    self.bgScrollView.contentSize=CGSizeMake(self.view.width,self.viedoarr.count/2*125+250);
    int cellNum =self.viedoarr.count;
    float width = 155;
    float height = 120;
    for(int i=0;i<cellNum;i++)
    {
        
        if (i==0) {
            EGOImageView *ego = [[EGOImageView alloc] initWithFrame:CGRectMake(0,200*i,kScreenWidth,150)];
            ego.placeholderImage=[UIImage imageNamed:@"影视背景.jpg"];
            [self.bgScrollView addSubview:ego];
            ego.userInteractionEnabled=YES;
            MedaiModel *medai=[self.viedoarr objectAtIndex:i];
            [ego setImageURL:[ShareFun makeImageUrl:medai.imgurl]];
            
            //            self.bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0,200*i,kScreenWidth,150)];
            //            NSString *str=[self.viedoico objectAtIndex:i];
            //            self.viedoimg=[UIImage imageNamed:[NSString stringWithFormat:@"%@",str]];
            //            self.bgImgV.image = self.viedoimg;
            //            self.bgImgV.userInteractionEnabled = YES;
            //            [self.bgScrollView addSubview:self.bgImgV];
            UIImageView *bofa=[[UIImageView alloc]initWithFrame:CGRectMake(145, 60, 30, 30)];
            bofa.image=[UIImage imageNamed:@"气象影视_06"];
            [ego addSubview:bofa];
            UIImageView *diimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 120, kScreenWidth, 30)];
            diimg.image=[UIImage imageNamed:@"气象影视_03"];
            diimg.userInteractionEnabled=YES;
            [ego addSubview:diimg];
            UILabel *delila=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
            //            delila.text=[self.viedoarr objectAtIndex:i];
            NSString *desc=[NSString stringWithFormat:@"%@",medai.title];
            delila.text=desc;
            delila.textColor=[UIColor whiteColor];
            delila.font=[UIFont systemFontOfSize:15];
            delila.textAlignment=NSTextAlignmentCenter;
            delila.numberOfLines=0;
            [diimg addSubview:delila];
            UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(ego.frame), CGRectGetHeight(ego.frame))];
            but.tag = i;
            [but addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
            [ego addSubview:but];
        }else{
            int line = (i+1)/2;//行
            int column = (i+1)%2;//列
            MedaiModel *medai=[self.viedoarr objectAtIndex:i];
            self.bgImgV= [[EGOImageView alloc] initWithFrame:CGRectMake(3*(column+1)+column*width,(height+10)*line+280-50-200, width, height)];
            self.bgImgV.placeholderImage=[UIImage imageNamed:@"影视背景.jpg"];
            //        NSString *name=[self.viedoarrname objectAtIndex:i];
            //        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"mp4"];
            //        self.viedoimg=[ShareFun fFirstVideoFrame:path];//获取视频搜略图
            //
            //            NSString *str=[self.viedoico objectAtIndex:i];
            //        self.viedoimg=[UIImage imageNamed:[NSString stringWithFormat:@"%@",str]];
            //        self.bgImgV.image = self.viedoimg;
            [self.bgImgV setImageURL:[ShareFun makeImageUrl:medai.imgurl]];
            self.bgImgV.userInteractionEnabled = YES;
            [self.bgScrollView addSubview:self.bgImgV];
            UIImageView *bofa=[[UIImageView alloc]initWithFrame:CGRectMake(62, 30, 30, 30)];
            bofa.image=[UIImage imageNamed:@"气象影视_06"];
            [self.bgImgV addSubview:bofa];
            UIImageView *diimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, height-30, width, 30)];
            diimg.image=[UIImage imageNamed:@"气象影视_03"];
            diimg.userInteractionEnabled=YES;
            [self.bgImgV addSubview:diimg];
            UILabel *delila=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
            //            delila.text=[self.viedoarr objectAtIndex:i];
            NSString *desc=[NSString stringWithFormat:@"%@",medai.title];
            delila.text=desc;
            delila.textColor=[UIColor whiteColor];
            delila.font=[UIFont systemFontOfSize:15];
            delila.textAlignment=NSTextAlignmentCenter;
            delila.numberOfLines=0;
            [diimg addSubview:delila];
            //            UILabel*noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(3*(column+1)+column*width, (height+50)*line+280+70, 145, 40)];
            ////            [noteTitle setText:[self.viedoarr objectAtIndex:i]];
            //            NSString *desc=[NSString stringWithFormat:@"%@ %@",medai.title,medai.desc];
            //            [noteTitle setText:desc];
            //            noteTitle.textAlignment=NSTextAlignmentLeft;
            //            noteTitle.numberOfLines=0;
            //            [noteTitle setBackgroundColor:[UIColor clearColor]];
            //            [noteTitle setTextColor:[UIColor grayColor]];
            //            [noteTitle setFont:[UIFont systemFontOfSize:10]];
            //            [self.bgScrollView addSubview:noteTitle];
        }
        UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bgImgV.frame), CGRectGetHeight(self.bgImgV.frame))];
        but.tag = i;
        [but addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgImgV addSubview:but];
        
        
    }
    
    
}
//-(void)buttonclick:(id)sender{
//    NSUInteger tag = [sender tag];
//    YSDetailViewController *ysd=[[YSDetailViewController alloc]init];
//    MedaiModel *medai=[self.viedoarr objectAtIndex:tag];
//    ysd.viedourl=medai.medaiurl;
//    ysd.imgurl=medai.imgurl;
//    ysd.des=medai.desc;
//    ysd.titlstr=medai.title;
//    ysd.time=medai.time;
//    [self.navigationController pushViewController:ysd animated:YES];
//}
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshTableFooterView *)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    NSArray *arr=[[NSArray alloc]initWithObjects:@"a",@"a",@"a",@"a", nil];
    [self.viedoarr addObjectsFromArray:arr];
    self.nowhight=self.viedoarr.count/2*125+200+125-150;
    [_refreshFooterView removeFromSuperview];
    [self creatviedo];
    //    [self.view removeFromSuperview];
    //    [self viewDidLoad];
    [self finishReloadingData];
    // overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.bgScrollView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

-(void)egoRefreshTableDidTriggerRefresh:(EGORefreshTableFooterView *)view{
    
    
    [self beginToReloadData:view];
    
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
    
    return _reloading; // should return if data source model is reloading
    
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

@end
