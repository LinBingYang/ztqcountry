//
//  NewsViewController.m
//  ztqFj
//
//  Created by Admin on 14-12-17.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "NewsViewController.h"
//#import "ZXContViewController.h"
#import "EGOImageView.h"
#import "WebViewController.h"
#import "ZXContViewController.h"
@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.barHiden=NO;
    self.titleLab.text=@"气象美图";
    self.view.backgroundColor=[UIColor whiteColor];
//    UIImageView *BG=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht)];
//    BG.image=[UIImage imageNamed:@"背景.png"];
//    BG.userInteractionEnabled=YES;
//    [self.view addSubview:BG];
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-60) style:UITableViewStylePlain];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_tableView.backgroundColor=[UIColor clearColor];
    m_tableView.showsHorizontalScrollIndicator = YES;
    m_tableView.showsVerticalScrollIndicator = YES;
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self.view addSubview:m_tableView];
        [self getdatas:10];
    
}
-(void)getdatas:(int)count{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary * art_title = [[NSMutableDictionary alloc] init];
//    [art_title setObject:[setting sharedSetting].currentCityID forKey:@"area"];
    [art_title setObject:@"100008" forKey:@"channel"];
    [art_title setObject:@"1" forKey:@"page"];
    [art_title setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
    [t_b setObject:art_title forKey:@"gz_art_title"];
    
    
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    
    
    
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
     [MBProgressHUD showHUDAddedTo :self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *art_channel = [t_b objectForKey:@"gz_art_title"];
            NSArray *t_array = [art_channel objectForKey:@"titles"];
            if (!t_array.count>0) {
                UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"暂无数据" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [al show];
                return;
            }
            [m_titleModelArr removeAllObjects];
            //			[m_titleModelArr release];
            m_titleModelArr = [[NSMutableArray alloc] initWithCapacity:4];
            
            for (int i=0; i<[t_array count]; i++) {
                artTitleModel *t_titleModel = [[artTitleModel alloc] init];
                t_titleModel.title = [[t_array objectAtIndex:i] objectForKey:@"title"];
                t_titleModel.pubt = [[t_array objectAtIndex:i] objectForKey:@"pubt"];
                t_titleModel.tid = [[t_array objectAtIndex:i] objectForKey:@"tid"];
                t_titleModel.ico=[[t_array objectAtIndex:i]objectForKey:@"ico"];
                t_titleModel.desc=[[t_array objectAtIndex:i]objectForKey:@"desc"];
                t_titleModel.small_ico=[[t_array objectAtIndex:i]objectForKey:@"small_ico"];
                t_titleModel.big_ico=[[t_array objectAtIndex:i]objectForKey:@"big_ico"];
                t_titleModel.url=[[t_array objectAtIndex:i]objectForKey:@"url"];
                [m_titleModelArr addObject:t_titleModel];
                //				[t_titleModel release];
            }
        }
        
        [m_tableView reloadData];
     
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
    if ([m_titleModelArr count] == 0)
        return 0;
    return [m_titleModelArr count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 75;
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
   
    if (row!=m_titleModelArr.count) {
        artTitleModel *t_title = [m_titleModelArr objectAtIndex:row];
        UIImageView *t_cellBg = [[UIImageView alloc] init];
        [t_cellBg setFrame:CGRectMake(0, 2, self.view.width, 74)];
        [t_cellBg setBackgroundColor:[UIColor whiteColor]];
        [t_cellBg setAlpha:0.8];
        [cell addSubview:t_cellBg];
        
       
        
//        NSString *tImageUrl = [ShareFun makeImageUrlStr:t_title.small_ico];
        
        EGOImageView *ego=[[EGOImageView alloc]initWithFrame:CGRectMake(2, 5, 80, 65)];
        [ego setImageURL:[ShareFun makeImageUrl:t_title.small_ico]];
        [cell addSubview:ego];
        
//        NSLog(@"%@",tImageUrl);
        
        if (t_title.small_ico.length>0) {
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 235, 20)];
            myLabel.text = t_title.title;
            myLabel.textColor = [UIColor blackColor];
            myLabel.backgroundColor = [UIColor clearColor];
            [myLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
            [cell addSubview:myLabel];
            
            
            myLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 35, 225, 40)];
            myLabel.text = t_title.desc;
            myLabel.numberOfLines=0;
            myLabel.textColor = [UIColor blackColor];
            myLabel.backgroundColor = [UIColor clearColor];
            [myLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
            [cell addSubview:myLabel];
            
            myLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 55, 225, 10)];
            myLabel.text = t_title.pubt;
            myLabel.numberOfLines=0;
            myLabel.textColor = [UIColor blackColor];
            myLabel.backgroundColor = [UIColor clearColor];
            [myLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            //            [cell addSubview:myLabel];
            UIImageView*line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 74, kScreenWidth, 1)];
            line.backgroundColor=[UIColor blackColor];
            [cell addSubview:line];
        }else{
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 20)];
            myLabel.text = t_title.title;
            myLabel.numberOfLines=0;
            myLabel.textColor = [UIColor blackColor];
            myLabel.backgroundColor = [UIColor clearColor];
            [myLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
            [cell addSubview:myLabel];
            
            
            myLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 300, 50)];
            myLabel.text = t_title.desc;
            myLabel.numberOfLines=0;
            myLabel.textColor = [UIColor blackColor];
            myLabel.backgroundColor = [UIColor clearColor];
            [myLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            [cell addSubview:myLabel];
            
            myLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 225, 10)];
            myLabel.text = t_title.pubt;
            myLabel.numberOfLines=0;
            myLabel.textColor = [UIColor blackColor];
            myLabel.backgroundColor = [UIColor clearColor];
            [myLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            UIImageView*line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 74, kScreenWidth, 1)];
            line.backgroundColor=[UIColor blackColor];
            [cell addSubview:line];
    }
    }
    if (m_titleModelArr.count+1 == row+1) {
        UIImageView *t_cellBg = [[UIImageView alloc] init];
        [t_cellBg setFrame:CGRectMake(0, 2, self.view.width, 40)];
        [t_cellBg setBackgroundColor:[UIColor whiteColor]];
        [t_cellBg setAlpha:0.8];
        [cell addSubview:t_cellBg];
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
        myLabel.text = @"点击加载更多";
        myLabel.textColor = [UIColor blackColor];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.adjustsFontSizeToFitWidth = YES;
        [myLabel setTextAlignment:NSTextAlignmentCenter];
        [myLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        [t_cellBg addSubview:myLabel];
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 45, self.view.width, 1)];
        line.backgroundColor=[UIColor blackColor];
        [t_cellBg addSubview:line];
        //		[myLabel release];
    }
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%d",indexPath.row);
    if (indexPath.row == m_titleModelArr.count){
        [self getdatas:m_titleModelArr.count+10];
    }else{
        artTitleModel *t_title = [m_titleModelArr objectAtIndex:indexPath.row];
//        WebViewController *webvc=[[WebViewController alloc]init];
//        webvc.titleString=t_title.title;
//        webvc.url=t_title.url;
//        [self.navigationController pushViewController:webvc animated:YES];
        
        ZXContViewController *zx=[[ZXContViewController alloc]init];
        zx.titlestr=@"气象美图";
        zx.Contitle=t_title.title;
        zx.putstr=t_title.pubt;
        zx.contentstr=t_title.desc;
        zx.imagename=t_title.big_ico;
        [self.navigationController pushViewController:zx animated:YES];
    }

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
