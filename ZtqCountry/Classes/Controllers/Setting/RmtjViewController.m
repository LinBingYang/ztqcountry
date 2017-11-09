
//
//  RmtjViewController.m
//  ZtqCountry
//
//  Created by 派克斯科技 on 16/12/21.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "RmtjViewController.h"
#import "rmtjCell.h"
#import "WebViewController.h"
#import "QXXZBViewController.h"
@interface RmtjViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

//@property (nonatomic, strong)NSMutableArray *info_list;


@end

@implementation RmtjViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatNagBar];
    [self.tableView reloadData];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void) creatNagBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    UIImageView * navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    navigationBarBg.userInteractionEnabled = YES;
    navigationBarBg.image=[UIImage imageNamed:@"导航栏"];
    [self.view addSubview:navigationBarBg];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 7+place, 30, 30)];
    [leftBut setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [leftBut setImage:[UIImage imageNamed:@"返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    [leftBut addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBg addSubview:leftBut];
    

    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, self.view.width-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"热门推荐";
    [navigationBarBg addSubview:titleLab];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, place + 44, kScreenWidth, kScreenHeitht - place - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"rmtjCell" bundle:nil] forCellReuseIdentifier:@"rmtjcell"];
//    [self NetFromHttpithType:@"1"];
}


- (void) backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 165;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    rmtjCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rmtjcell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataSource[indexPath.row];
    [cell rmtjCellUpdataWithDic:dic];
    cell.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245/ 255.0 alpha:1.0];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.row];
    QXXZBViewController *webvc=[[QXXZBViewController alloc]init];
    webvc.url=dic[@"url"];
    webvc.titleString=dic[@"title"];
    webvc.shareContent=dic[@"fx_content"];
    [self.navigationController pushViewController:webvc animated:YES];
    
    
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
