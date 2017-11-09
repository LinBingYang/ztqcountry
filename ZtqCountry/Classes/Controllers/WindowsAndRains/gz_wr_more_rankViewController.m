//
//  gz_wr_more_rankViewController.m
//  ZtqCountry
//
//  Created by hpf on 16/1/16.
//  Copyright © 2016年 yyf. All rights reserved.
//
#import "rank_list.h"
#import "gz_wr_more_rankViewController.h"
#import "EGORefreshTableFooterView.h"
#define cellSeparColor [UIColor colorHelpWithRed:209 green:209 blue:209 alpha:1];
@interface gz_wr_more_rankViewController()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableFooterDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,weak) UILabel *firstlabel;
@property(nonatomic,weak) UILabel *secondlabel;
@property(nonatomic,weak) UILabel *thirdlabel;
@property(assign)int page;
@property (strong, nonatomic) EGORefreshTableFooterView * refreshFooterView;
@property(assign)BOOL issktype;
@end

@implementation gz_wr_more_rankViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.barHiden=NO;
    self.titleLab.text=@"风雨查询";
    self.dats=[[NSMutableArray alloc]init];
    CGFloat margin=0;
    self.view.backgroundColor=[UIColor whiteColor];
    self.issktype=NO;
    UILabel *tjsj=[[UILabel alloc] initWithFrame:CGRectMake(10, self.barHeight+10, kScreenWidth-10, 30)];
    tjsj.font=[UIFont systemFontOfSize:14];
    tjsj.text=[NSString stringWithFormat:@"统计时间:%@",self.rank_list_time];
    [tjsj sizeToFit];
//    tjsj.frame=CGRectMake(kScreenWidth-tjsj.frame.size.width-10,self.barHeight, 200, 30);
    [tjsj sizeToFit];
//    [self.view addSubview:tjsj];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(margin, self.barHeight+10, kScreenWidth-2*margin,kScreenHeitht-self.barHeight-15) style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor whiteColor];
//    self.tableView.scrollEnabled=NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UILabel *headerView=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-2*margin, 35)];
    headerView.text=@"全省雨量排行";
   rank_list *rank=self.rank_lists[0];
    if (self.titleType==YzhouTypeTemp) {
//              headerView.text=@"全省实况温度排名";
        if (self.tempType==tempTypeHigt) {
              headerView.text=@"全省高温排名";
        }else if(self.tempType==tempTypeLow){
              headerView.text=@"全省低温排名";
        }else if(self.tempType==tempTypeNormalHigt){
            headerView.text=@"全省实况高温排名";
        }else if(self.tempType==tempTypeNormalLow){
            headerView.text=@"全省实况低温排名";
        }
    }
    if (self.titleType==YzhouTypeWind) {
        if (self.WindType==WindTypeSK) {
            headerView.text=@"全省实况风速排名";
        }else if(self.WindType==WindTypeSKNormal){
        headerView.text=@"全省最大风速排名";
        }
    }
    headerView.font=[UIFont systemFontOfSize:17];
    headerView.textAlignment=NSTextAlignmentCenter;
    
    UIView *hengxian1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    hengxian1.backgroundColor=cellSeparColor;
    [headerView addSubview:hengxian1];
        UIView *shuxian1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 35)];
        shuxian1.backgroundColor=cellSeparColor;
        [headerView addSubview:shuxian1];
        UIView *shuxian2=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerView.frame)-1, 0, 1, 35)];
        shuxian2.backgroundColor=cellSeparColor;
        [headerView addSubview:shuxian2];
//    self.tableView.tableHeaderView=headerView;
    [self.view addSubview:self.tableView];
    

    EGORefreshTableFooterView *view = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f,self.tableView.bounds.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    view.delegate = self;
    [self.tableView addSubview:view];
    _refreshFooterView = view;
    //ces
    self.page=1;
    if (rank.pro_type.length>0) {
        self.issktype=NO;
        [self getLDdatas];
    }else{
        self.issktype=YES;
        [self getskdatas];
    }
    
}
-(void)setRefreshViewFrame{
    if (self.dats.count!=50) {
        _refreshFooterView.hidden=YES;
    }else{
    double contsize=(self.dats.count+1)*35+37;
    int height = MAX(self.tableView.bounds.size.height, contsize);
    
    _refreshFooterView.frame=CGRectMake(0, height, kScreenWidth, self.tableView.frame.size.height);
    }
}
-(void)getLDdatas{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *qxfw_product = [NSMutableDictionary dictionaryWithCapacity:4];
    
    NSString *page=[NSString stringWithFormat:@"%d",self.page];
    if (self.rank_lists.count==0) {
        return;
    }
    rank_list *rank=self.rank_lists[0];
    [qxfw_product setObject:page forKey:@"page"];
    [qxfw_product setObject:@"50" forKey:@"count"];
    [qxfw_product setObject:rank.pro_type forKey:@"type"];
    [qxfw_product setObject:rank.proid forKey:@"pro_id"];
    [t_b setObject:qxfw_product forKey:@"gz_wr_pro_rank"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:0 withSuccess:^(NSDictionary *returnData) {
        
        NSDictionary *b=[returnData objectForKey:@"b"];
        NSDictionary *gz_wr_pro_rank=[b objectForKey:@"gz_wr_pro_rank"];
        NSArray *rank_list1=[gz_wr_pro_rank objectForKey:@"rank_list"];
        NSArray *rank_lists=[rank_list mj_objectArrayWithKeyValuesArray:rank_list1];
        self.next_datas=rank_lists;
        [self.dats addObjectsFromArray:rank_lists];
        [self.tableView reloadData];
        [self setRefreshViewFrame];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        
    } withCache:YES];
}
-(void)getskdatas{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *qxfw_product = [NSMutableDictionary dictionaryWithCapacity:4];
    
    NSString *page=[NSString stringWithFormat:@"%d",self.page];
    if (self.rank_lists.count==0) {
        return;
    }
    rank_list *rank=self.rank_lists[0];
    [qxfw_product setObject:page forKey:@"page"];
    [qxfw_product setObject:@"50" forKey:@"count"];
    [qxfw_product setObject:rank.sk_type forKey:@"type"];
    [qxfw_product setObject:rank.proid forKey:@"pro_id"];
    [t_b setObject:qxfw_product forKey:@"gz_wr_pro_tru_rank"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:0 withSuccess:^(NSDictionary *returnData) {
        
        NSDictionary *b=[returnData objectForKey:@"b"];
        NSDictionary *gz_wr_pro_rank=[b objectForKey:@"gz_wr_pro_tru_rank"];
        NSArray *rank_list1=[gz_wr_pro_rank objectForKey:@"rank_list"];
        NSArray *rank_lists=[rank_list mj_objectArrayWithKeyValuesArray:rank_list1];
        self.next_datas=rank_lists;
        [self.dats addObjectsFromArray:rank_lists];
        [self.tableView reloadData];
        [self setRefreshViewFrame];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        
    } withCache:YES];
}
#pragma mark tableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dats.count;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    headview.backgroundColor=[UIColor whiteColor];
    [self.tableView addSubview:headview];
    
    UILabel *tlab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    tlab.text=@"全省雨量排行";
    if (self.titleType==YzhouTypeTemp) {
//        tlab.text=@"全省实况温度排名";
        if (self.tempType==tempTypeHigt) {
            tlab.text=@"全省高温排名";
        }else if(self.tempType==tempTypeLow){
            tlab.text=@"全省低温排名";
        }else if(self.tempType==tempTypeNormalHigt){
            tlab.text=@"全省实况高温排名";
        }else if(self.tempType==tempTypeNormalLow){
            tlab.text=@"全省实况低温排名";
        }
    }
    if (self.titleType==YzhouTypeWind) {
        if (self.WindType==WindTypeSK) {
            tlab.text=@"全省实况风速排名";
        }else if(self.WindType==WindTypeSKNormal){
            tlab.text=@"全省最大风速排名";
        }
    }
    tlab.font=[UIFont systemFontOfSize:17];
    tlab.textAlignment=NSTextAlignmentCenter;
    
    UIView *hengxian1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    hengxian1.backgroundColor=cellSeparColor;
    [headview addSubview:hengxian1];
    UIView *shuxian1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 35)];
    shuxian1.backgroundColor=cellSeparColor;
    [headview addSubview:shuxian1];
    UIView *shuxian2=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headview.frame)-1, 0, 1, 35)];
    shuxian2.backgroundColor=cellSeparColor;
    [headview addSubview:shuxian2];
    [headview addSubview:tlab];
    
    UILabel *firstlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 35, self.tableView.frame.size.width/3, 35)];

    firstlabel.font=[UIFont systemFontOfSize:13];
    firstlabel.textAlignment=NSTextAlignmentCenter;
    [headview addSubview:firstlabel];
    UILabel *secondlabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(firstlabel.frame), 35, self.tableView.frame.size.width/3, 35)];
    secondlabel.textAlignment=NSTextAlignmentCenter;
    secondlabel.font=[UIFont systemFontOfSize:13];
    [headview addSubview:secondlabel];
    UILabel *thirdlabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(secondlabel.frame), 35, self.tableView.frame.size.width/3,35)];
    thirdlabel.font=[UIFont systemFontOfSize:13];
    thirdlabel.textAlignment=NSTextAlignmentCenter;
    [headview addSubview:thirdlabel];
    firstlabel.text=@"序号";
    secondlabel.text=@"城市";
    
    thirdlabel.text=@"雨量mm";
    if (self.titleType==YzhouTypeTemp) {
        thirdlabel.text=@"气温℃";
    }
    if (self.titleType==YzhouTypeWind) {
        thirdlabel.text=@"风速m/s";
    }
    UIView *hengxian3=[[UIView alloc] initWithFrame:CGRectMake(0, 35, self.tableView.frame.size.width, 1)];
    hengxian3.backgroundColor=cellSeparColor;
    [headview addSubview:hengxian3];
    
    
    
    UIView *hengxian4=[[UIView alloc] initWithFrame:CGRectMake(0, 70, self.tableView.frame.size.width, 1)];
    hengxian4.backgroundColor=cellSeparColor;
    [headview addSubview:hengxian4];
    
    UIView *shuxian3=[[UIView alloc] initWithFrame:CGRectMake(0, 35, 1, 35)];
    shuxian3.backgroundColor=cellSeparColor;
    [headview addSubview:shuxian3];
    UIView *shuxian4=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstlabel.frame), 35, 1, 35)];
    shuxian4.backgroundColor=cellSeparColor;
    [headview addSubview:shuxian4];
    UIView *shuxian5=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secondlabel.frame), 35, 1, 35)];
    shuxian5.backgroundColor=cellSeparColor;
    [headview addSubview:shuxian5];
    UIView *shuxian6=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(thirdlabel.frame)-1, 35, 1, 35)];
    shuxian6.backgroundColor=cellSeparColor;
    [headview addSubview:shuxian6];
    return headview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
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
        UILabel *firstlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width/3, 35)];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        self.firstlabel=firstlabel;
        firstlabel.font=[UIFont systemFontOfSize:13];
        firstlabel.textAlignment=NSTextAlignmentCenter;
        [cell addSubview:firstlabel];
        UILabel *secondlabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(firstlabel.frame), 0, self.tableView.frame.size.width/3, 35)];
        secondlabel.textAlignment=NSTextAlignmentCenter;
         secondlabel.font=[UIFont systemFontOfSize:13];
        self.secondlabel=secondlabel;
        [cell addSubview:secondlabel];
        UILabel *thirdlabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(secondlabel.frame), 0, self.tableView.frame.size.width/3,35)];
         thirdlabel.font=[UIFont systemFontOfSize:13];
        thirdlabel.textAlignment=NSTextAlignmentCenter;
        self.thirdlabel=thirdlabel;
        [cell addSubview:thirdlabel];
        UIView *hengxian1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
        hengxian1.backgroundColor=cellSeparColor;
        [cell addSubview:hengxian1];
        
        UIView *hengxian2=[[UIView alloc] initWithFrame:CGRectMake(0, 35, self.tableView.frame.size.width, 1)];
        hengxian2.backgroundColor=cellSeparColor;
        [cell addSubview:hengxian2];
        
        UIView *shuxian1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 35)];
        shuxian1.backgroundColor=cellSeparColor;
        [cell addSubview:shuxian1];
        UIView *shuxian2=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstlabel.frame), 0, 1, 35)];
        shuxian2.backgroundColor=cellSeparColor;
        [cell addSubview:shuxian2];
        UIView *shuxian3=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secondlabel.frame), 0, 1, 35)];
        shuxian3.backgroundColor=cellSeparColor;
        [cell addSubview:shuxian3];
        UIView *shuxian4=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(thirdlabel.frame)-1, 0, 1, 35)];
        shuxian4.backgroundColor=cellSeparColor;
        [cell addSubview:shuxian4];
        
    
//    if (indexPath.row==0) {
//        self.firstlabel.text=@"序号";
//        self.secondlabel.text=@"城市";
//
//        self.thirdlabel.text=@"雨量mm";
//        if (self.titleType==YzhouTypeTemp) {
//        self.thirdlabel.text=@"温度℃";
//        }
//        if (self.titleType==YzhouTypeWind) {
//            self.thirdlabel.text=@"风速m/s";
//        }
//
//    }else
//    {
        rank_list *rank=self.dats[indexPath.row];
        self.firstlabel.text=rank.num;
        self.secondlabel.text=rank.city_name;
        self.thirdlabel.text=rank.val;
//    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshTableFooterView *)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    [self finishReloadingData];
    // overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    self.page=self.page+1;
    if (self.next_datas.count>=50) {
        if (self.issktype==YES) {
            [self getskdatas];
        }else
        [self getLDdatas];
        
    }else{
        _refreshFooterView.hidden=YES;
    }
    
    
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
//    if (self.next_datas.count!=50) {
//        _refreshFooterView.hidden=YES;
//    }else
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
@end
