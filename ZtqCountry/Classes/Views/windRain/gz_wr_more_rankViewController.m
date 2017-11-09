//
//  gz_wr_more_rankViewController.m
//  ZtqCountry
//
//  Created by hpf on 16/1/16.
//  Copyright © 2016年 yyf. All rights reserved.
//
#import "rank_list.h"
#import "gz_wr_more_rankViewController.h"
#define cellSeparColor [UIColor colorHelpWithRed:209 green:209 blue:209 alpha:1];
@interface gz_wr_more_rankViewController()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,weak) UILabel *firstlabel;
@property(nonatomic,weak) UILabel *secondlabel;
@property(nonatomic,weak) UILabel *thirdlabel;
@end

@implementation gz_wr_more_rankViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.barHiden=NO;
    self.titleLab.text=@"风雨查询";
    CGFloat margin=10;
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(margin, self.barHeight+2*margin, kScreenWidth-2*margin,(self.rank_lists.count+2)*30+1) style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.scrollEnabled=NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UILabel *headerView=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-2*margin, 30)];
    headerView.text=@"全省雨量排行";
   rank_list *rank=self.rank_lists[0];
    if ([rank.type isEqualToString:@"2"]) {
    headerView.text=@"全省实况温度排名";
        if ([rank.TempType isEqualToString:@"1"]) {
              headerView.text=@"全省高温排名";
        }else if([rank.TempType isEqualToString:@"2"]){
              headerView.text=@"全省低温排名";
        }
    }
    if([rank.type isEqualToString:@"3"])
    {
     headerView.text=@"全省实况风速排名";
    }
          headerView.font=[UIFont systemFontOfSize:17];
    headerView.textAlignment=NSTextAlignmentCenter;
    
    UIView *hengxian1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    hengxian1.backgroundColor=cellSeparColor;
    [headerView addSubview:hengxian1];
        UIView *shuxian1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 30)];
        shuxian1.backgroundColor=cellSeparColor;
        [headerView addSubview:shuxian1];
        UIView *shuxian2=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerView.frame)-1, 0, 1, 30)];
        shuxian2.backgroundColor=cellSeparColor;
        [headerView addSubview:shuxian2];
    self.tableView.tableHeaderView=headerView;
    [self.view addSubview:self.tableView];
    
    UILabel *tjsj=[[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.tableView.frame)+10, 200, 30)];
     tjsj.font=[UIFont systemFontOfSize:13];
    tjsj.text=[NSString stringWithFormat:@"统计时间:%@",self.rank_list_time];
    [tjsj sizeToFit];
    tjsj.frame=CGRectMake(kScreenWidth-tjsj.frame.size.width-10, CGRectGetMaxY(self.tableView.frame)+10, 200, 30);
     [tjsj sizeToFit];
    [self.view addSubview:tjsj];

    
}
#pragma mark tableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rank_lists.count+1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rank=@"rank";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rank];
    if (cell==nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rank];
        UILabel *firstlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width/3, 30)];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        self.firstlabel=firstlabel;
        firstlabel.font=[UIFont systemFontOfSize:13];
        firstlabel.textAlignment=NSTextAlignmentCenter;
        [cell addSubview:firstlabel];
        UILabel *secondlabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(firstlabel.frame), 0, self.tableView.frame.size.width/3, 30)];
        secondlabel.textAlignment=NSTextAlignmentCenter;
         secondlabel.font=[UIFont systemFontOfSize:13];
        self.secondlabel=secondlabel;
        [cell addSubview:secondlabel];
        UILabel *thirdlabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(secondlabel.frame), 0, self.tableView.frame.size.width/3,30)];
         thirdlabel.font=[UIFont systemFontOfSize:13];
        thirdlabel.textAlignment=NSTextAlignmentCenter;
        self.thirdlabel=thirdlabel;
        [cell addSubview:thirdlabel];
        UIView *hengxian1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
        hengxian1.backgroundColor=cellSeparColor;
        [cell addSubview:hengxian1];
        
        UIView *hengxian2=[[UIView alloc] initWithFrame:CGRectMake(0, 30, self.tableView.frame.size.width, 1)];
        hengxian2.backgroundColor=cellSeparColor;
        [cell addSubview:hengxian2];
        
        UIView *shuxian1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 30)];
        shuxian1.backgroundColor=cellSeparColor;
        [cell addSubview:shuxian1];
        UIView *shuxian2=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstlabel.frame), 0, 1, 30)];
        shuxian2.backgroundColor=cellSeparColor;
        [cell addSubview:shuxian2];
        UIView *shuxian3=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secondlabel.frame), 0, 1, 30)];
        shuxian3.backgroundColor=cellSeparColor;
        [cell addSubview:shuxian3];
        UIView *shuxian4=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(thirdlabel.frame)-1, 0, 1, 30)];
        shuxian4.backgroundColor=cellSeparColor;
        [cell addSubview:shuxian4];
        
    }
    if (indexPath.row==0) {
        self.firstlabel.text=@"序号";
        self.secondlabel.text=@"城市";
       rank_list *rank=self.rank_lists[0];
        self.thirdlabel.text=@"雨量mm";
        if ([rank.type isEqualToString:@"2"]) {
        self.thirdlabel.text=@"温度℃";
        }
        if([rank.type isEqualToString:@"3"])
        {
        self.thirdlabel.text=@"风速m/s";
        }
    }else
    {
        rank_list *rank=self.rank_lists[indexPath.row-1];
        self.firstlabel.text=rank.num;
        self.secondlabel.text=rank.city_name;
        self.thirdlabel.text=rank.val;
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
@end
