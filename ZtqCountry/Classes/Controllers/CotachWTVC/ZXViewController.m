//
//  ZXViewController.m
//  ZtqCountry
//
//  Created by Admin on 16/10/21.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "ZXViewController.h"
#import "EGORefreshTableFooterView.h"
#import "ZXTableViewCell.h"
#import "ZXModel.h"
@interface ZXViewController ()<EGORefreshTableFooterDelegate>
@property (strong, nonatomic) EGORefreshTableFooterView * refreshFooterView;

@end

@implementation ZXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barHiden=NO;
    self.titleLab.text=self.titlestr;
    self.view.backgroundColor=[UIColor whiteColor];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight) style:UITableViewStylePlain];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_tableView.backgroundColor=[UIColor clearColor];
    m_tableView.backgroundView=nil;
    m_tableView.autoresizesSubviews = YES;
    m_tableView.showsHorizontalScrollIndicator = YES;
    m_tableView.showsVerticalScrollIndicator = YES;
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [m_tableView registerClass:[ZXTableViewCell class] forCellReuseIdentifier:@"zxViewCell"];
    [self.view addSubview:m_tableView];
    self.dataSource = [NSMutableArray array];
    EGORefreshTableFooterView *view = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectZero];
    view.delegate = self;
    [m_tableView addSubview:view];
    _refreshFooterView = view;
    self.page = 1;
    self.count = @"15";
    [self loadDataSource];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated {
    [self setRefreshViewFrame];
    [super viewDidAppear:animated];
   
}

- (void)loadDataSource {
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_mltq_zx = [[NSMutableDictionary alloc] init];
    [gz_mltq_zx setObject:self.channel_id forKey:@"channel_id"];
    [gz_mltq_zx setObject:self.count forKey:@"count"];
    [gz_mltq_zx setObject:[NSString stringWithFormat:@"%d", self.page] forKey:@"page"];
    [b setObject:gz_mltq_zx forKey:@"gz_mltq_zx"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary *mltq_zx = b[@"gz_mltq_zx"];
            NSArray *info_list = mltq_zx[@"info_list"];
            for (NSDictionary *obj in info_list) {
                ZXModel *model  = [[ZXModel alloc]init];
                [model setValuesForKeysWithDictionary:obj];
                [self.dataSource addObject:model];
            }
            [self finishReloadingData];
            [m_tableView reloadData];
            [self setRefreshViewFrame];


                  }
        
    } withFailure:^(NSError *error) {
    } withCache:YES];

}


-(void)setRefreshViewFrame{
    
//    double contsize=self.marr.count*58;
    int height = MAX(m_tableView.bounds.size.height, m_tableView.contentSize.height);
    
    _refreshFooterView.frame=CGRectMake(0, height , kScreenWidth, m_tableView.frame.size.height);
}
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXModel *model = self.dataSource[indexPath.row];
    
    ZXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zxViewCell" forIndexPath:indexPath];
    [cell updataWithModel:model];
    
  
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXModel *model = self.dataSource[indexPath.row];
    ZXContentViewController *zxvc=[[ZXContentViewController alloc]init];
    zxvc.wzid=model.IId;
    zxvc.titlestr=self.titlestr;
    [self.navigationController pushViewController:zxvc animated:YES];
}

#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshTableFooterView *)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    self.page++;
    [self loadDataSource];
    
    //    [self getInformation:m_ID withCount:[NSString stringWithFormat:@"%d", [m_titleModelArr count]+10]];
    
    // overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;

//    self.page=self.page+1;
//    if ([self.type isEqualToString:@"0"]) {
//        [self getmyser];
//    }else if([self.type isEqualToString:@"2"]){
//        [self getpromore];
//    }else{
//        [self getproduct];
//    }

    
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:m_tableView];
    
}


#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

-(void)egoRefreshTableDidTriggerRefresh:(EGORefreshTableFooterView *)view{
    
    
    [self beginToReloadData:view];
    
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
    
    return _reloading; // should return if data source model is reloading
    
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
