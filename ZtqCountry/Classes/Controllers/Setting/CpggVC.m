//
//  CpggVC.m
//  ZtqCountry
//
//  Created by Admin on 15/7/7.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "CpggVC.h"
#import "UILabel+utils.h"
@implementation CpggVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLab.text=@"产品公告";
    self.barHiden=NO;
    self.view.backgroundColor=[UIColor whiteColor];
//    self.bgscrol=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht)];
//    self.bgscrol.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht);
//    self.bgscrol.showsHorizontalScrollIndicator=NO;
//    self.bgscrol.showsVerticalScrollIndicator=NO;
//    [self.view addSubview:self.bgscrol];
    self.m_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight-5) style:UITableViewStylePlain];
    self.m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_tableview.backgroundColor=[UIColor clearColor];
    self.m_tableview.backgroundView=nil;
    self.m_tableview.autoresizesSubviews = YES;
    self.m_tableview.showsHorizontalScrollIndicator = YES;
    self.m_tableview.showsVerticalScrollIndicator = YES;
    self.m_tableview.delegate = self;
    self.m_tableview.dataSource = self;
    [self.view addSubview:self.m_tableview];
    [self getdatas];
}
-(void)getdatas{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *qxfw_product = [NSMutableDictionary dictionaryWithCapacity:4];
    
    
    [t_b setObject:qxfw_product forKey:@"gz_notice"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:0 withSuccess:^(NSDictionary *returnData) {
//        NSLog(@"%@",returnData);
        NSDictionary *b=[returnData objectForKey:@"b"];
        NSDictionary *qxfw_sel=[b objectForKey:@"gz_notice"];
        self.notice_list=[qxfw_sel objectForKey:@"notice_list"];
        [_m_tableview reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
//        [self creatviews];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        
    } withCache:YES];
}
-(void)creatviews{
    float height=0;
    for (int i=0; i<self.notice_list.count; i++) {
        NSString *title=[self.notice_list[i] objectForKey:@"title"];
        NSString *push_time=[self.notice_list[i] objectForKey:@"push_time"];
        NSString *content=[self.notice_list[i] objectForKey:@"content"];
        UIView *cellview=[[UIView alloc]initWithFrame:CGRectMake(0, 100*i, kScreenWidth, 150)];
        [self.bgscrol addSubview:cellview];
        UILabel *titlab=[[UILabel alloc]initWithFrame:CGRectMake(10,10, kScreenWidth, 30)];
        titlab.text=title;
        titlab.font=[UIFont systemFontOfSize:14];
        [cellview addSubview:titlab];
        UILabel *timelab=[[UILabel alloc]initWithFrame:CGRectMake(10,40, kScreenWidth, 30)];
        timelab.text=push_time;
        timelab.font=[UIFont systemFontOfSize:14];
        [cellview addSubview:timelab];
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10, 70, kScreenWidth-20, 1)];
        line.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
        [cellview addSubview:line];
        UILabel *contentlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 75, kScreenWidth-20, 50)];
        contentlab.numberOfLines=0;
        contentlab.text=content;
        contentlab.font=[UIFont systemFontOfSize:14];
        [cellview addSubview:contentlab];
        height=[contentlab labelheight:content withFont:[UIFont systemFontOfSize:14]];
        cellview.frame=CGRectMake(0,(95+height)*i, kScreenWidth, 95+height);
        contentlab.frame=CGRectMake(10, 75, kScreenWidth-20, height+20);
    
    }
    self.bgscrol.contentSize=CGSizeMake(kScreenWidth, 300*self.notice_list.count);
}
#pragma mark -UITableDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.notice_list.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
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
    CGRect cellFrame = [cell frame];
    cellFrame.origin = CGPointMake(0, 0);
    
    cellFrame.size.height = 80;
    
    NSString *title=[self.notice_list[row] objectForKey:@"title"];
    NSString *push_time=[self.notice_list[row] objectForKey:@"push_time"];
    NSString *content=[self.notice_list[row] objectForKey:@"content"];
    
    UILabel *titlab=[[UILabel alloc]initWithFrame:CGRectMake(10,5, kScreenWidth, 30)];
    titlab.text=title;
    titlab.font=[UIFont systemFontOfSize:16];
    [cell addSubview:titlab];
    UILabel *timelab=[[UILabel alloc]initWithFrame:CGRectMake(10,35, kScreenWidth, 30)];
    timelab.text=push_time;
    timelab.font=[UIFont systemFontOfSize:14];
    [cell addSubview:timelab];
   
    UILabel *contentlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 65, kScreenWidth-20, 50)];
    contentlab.numberOfLines=0;
    contentlab.text=content;
    contentlab.font=[UIFont systemFontOfSize:14];
    [cell addSubview:contentlab];
   float height=[contentlab labelheight:content withFont:[UIFont systemFontOfSize:14]];
    contentlab.frame=CGRectMake(10, 65, kScreenWidth-20, height+50);
    cellFrame.size.height=height+100;
    [cell setFrame:cellFrame];
    UIImageView *l_line=[[UIImageView alloc]initWithFrame:CGRectMake(15, cell.frame.size.height-1, kScreenWidth-30, 1)];
    //    l_line.image=[UIImage imageNamed:@"灰色隔条"];
    l_line.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
    [cell addSubview:l_line];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
