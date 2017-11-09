//
//  XiaozhiTuijianViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-29.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "XiaozhiTuijianViewController.h"
#import "XiaozhiCell.h"
#import "UILabel+utils.h"
#import "EGOImageView.h"
@interface XiaozhiTuijianViewController ()<UITableViewDataSource,UITableViewDelegate,XiaozhiDelegate>

@property (strong, nonatomic) UITableView * table;
@property (strong, nonatomic) NSMutableArray * datas;

@end

@implementation XiaozhiTuijianViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self configDatas];
    self.barHiden = NO;
    self.titleLab.text = @"小知推荐";
    self.titleLab.textColor = [UIColor whiteColor];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenHeitht- self.barHeight, kScreenWidth+50) style:UITableViewStylePlain];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
}

-(void)configDatas
{
    _datas = [[NSMutableArray alloc] init];
    
    
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *getrecommendsoft = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [getrecommendsoft setObject:@"1" forKey:@"type"];
    [t_b setObject:getrecommendsoft forKey:@"getrecommendsoft"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *dic=[t_b objectForKey:@"getrecommendsoft"];
        _datas=[dic objectForKey:@"idx"];
        [self.table reloadData];
     
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
    
    
    
//    NSDictionary * SNCdic = [[NSDictionary alloc] initWithObjectsAndKeys:@"谁脑残图标_03.png",@"Logo",@"谁脑残",@"Title",@"脑力潜能开发平台",@"Platform",@"脑力测试/四维训练/潜能开发",@"Content",@"",@"URL", nil];
//    [_datas addObject:SNCdic];
//    NSDictionary * FJdic = [[NSDictionary alloc] initWithObjectsAndKeys:@"小知推荐_07.png",@"Logo",@"知天气-福建",@"Title",@"福建省气象局推出",@"Platform",@"专业服务/决策服务",@"Content",@"https://itunes.apple.com/cn/app/zhi-tian-qi-zhang-shang-qi/id451961462?mt=8",@"URL", nil];
//    [_datas addObject:FJdic];
}


#pragma mark -TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [self.datas objectAtIndex:indexPath.row];
    NSString * platform = [dic objectForKey:@"developers"];
    NSString * content = [dic objectForKey:@"desc"];
    
    UILabel * platformLab =[[UILabel alloc] initWithFrame:CGRectMake(80, 30, 100, 20)];
    UILabel * contentLab =  [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 310-85, 20)];
    float platformHeight = [platformLab labelheight:platform withFont:[UIFont fontWithName:kBaseFont size:13]];
    float contentHeight = [contentLab labelheight:content withFont:[UIFont fontWithName:kBaseFont size:13]];

    
    return 30+contentHeight+platformHeight+10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * infoDic = [self.datas objectAtIndex:indexPath.row];
    NSString * logo = [infoDic objectForKey:@"logourl"];
    NSString * title = [infoDic objectForKey:@"title"];
    NSString * platform = [infoDic objectForKey:@"developers"];
    NSString * content = [infoDic objectForKey:@"desc"];
    NSString * url = [infoDic objectForKey:@"fileurl"];
    EGOImageView *ego=[[EGOImageView alloc]init];
//    NSString *str=[NSString stringWithFormat:@"http://images.ikan365.cn%@",logo];
//    NSString *str=[NSString stringWithFormat:@"http://112.5.138.42:9091/zsfj/%@",logo];
//    NSURL *imgurl=[NSURL URLWithString:str];
    [ego setImageURL:[ShareFun makeImageUrl:logo]];
    
    XiaozhiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[XiaozhiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
//    cell.delegate = self;
//    cell.indexPath = indexPath;
//    cell.logoImgV.image = [UIImage imageNamed:logo];
//    cell.titleLab.text = title;
//    cell.platformLab.text = platform;
//    cell.contentLab.text = content;
    [cell setLogo:ego.image withTitle:title withPlatform:platform withContent:content withIndexPath:indexPath withDelegate:self];
    if(indexPath.row == 0)
        cell.titleLab.textColor = [UIColor orangeColor];
    else
        cell.titleLab.textColor = [UIColor blueColor];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadWithIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary * infoDic = [self.datas objectAtIndex:indexPath.row];
     NSString * urlStr = [infoDic objectForKey:@"fileurl"];
    if(urlStr.length)
    {
        NSURL *url = [NSURL URLWithString:urlStr];
        
        [[UIApplication sharedApplication]openURL:url];

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

@end
