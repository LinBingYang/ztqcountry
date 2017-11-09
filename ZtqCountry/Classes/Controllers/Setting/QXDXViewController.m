//
//  QXDXViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-29.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "QXDXViewController.h"
#import "SMSTableViewCell.h"
#import "UILabel+utils.h"

@interface QXDXViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView * table;
@property (strong, nonatomic) NSMutableArray * datas;


@end

@implementation QXDXViewController

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
    [self configData];
    // Do any additional setup after loading the view.
    self.barHiden = NO;
    self.titleLab.text = @"气象短信";
    self.titleLab.textColor = [UIColor whiteColor];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight) style:UITableViewStylePlain];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
}


-(void)configData
{
//    @property (strong, nonatomic) UILabel * titleLab;
//    @property (strong, nonatomic) UILabel * consumptionLab;
//    @property (strong, nonatomic) UILabel * openWayLab;
//    @property (strong, nonatomic) UILabel * closeWayLab;
    _datas = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *qxsms = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [qxsms setObject:@"1" forKey:@"type"];
    [t_b setObject:qxsms forKey:@"qxsms"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *dic=[t_b objectForKey:@"qxsms"];
        _datas=[dic objectForKey:@"idex"];
        [self.table reloadData];
        
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
    
    
//    NSDictionary * yidongDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"【移动气象站】",@"Title",@"资费说明：3元/月",@"Consumption",@"开通方式：中国移动福建公司客户编辑短信30250发送至10086.",@"OpenWay",@"退订方式：编辑短信30251发送至10086",@"CloseWay", nil];
//    [_datas addObject:yidongDic];
//    NSDictionary * liantongDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"【联通新气象】",@"Title",@"资费说明：3元/月",@"Consumption",@"开通方式：中国联通福建公司客户编辑短信05发送至10010.",@"OpenWay",@"退订方式：编辑短信00000发送至10010",@"CloseWay", nil];
//    [_datas addObject:liantongDic];
//    NSDictionary * tianqiDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"【天气时报】",@"Title",@"资费说明：3元/月",@"Consumption",@"开通方式：中国电信福建公司客户编辑短信05发送至10010.",@"OpenWay",@"退订方式：编辑短信00000发送至10000",@"CloseWay", nil];
//    [_datas addObject:tianqiDic];
    
}

#pragma mark -TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [self.datas objectAtIndex:indexPath.row];
    NSString * openWay = [dic objectForKey:@"open_msg"];
    NSString * closeWay = [dic objectForKey:@"close_msg"];
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, kScreenWidth-30, 20)];
    float openHeight = [lab labelheight:openWay withFont:[UIFont fontWithName:kBaseFont size:13]];
    float closeHeight = [lab labelheight:closeWay withFont:[UIFont fontWithName:kBaseFont size:13]];
    return openHeight+closeHeight+90+10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//        NSDictionary * yidongDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"【移动气象站】",@"Title",@"3元/月",@"Consumption",@"开通方式:中国移动福建公司客户编辑短信30250发送至10086.",@"OpenWay",@"退订方式:编辑短信30251发送至10086",@"CloseWay", nil];
    NSDictionary * dic = [self.datas objectAtIndex:indexPath.row];
    NSString * titleStr = [dic objectForKey:@"title"];
    NSString * consumptionStr = [dic objectForKey:@"money"];
    NSString * openWayStr = [dic objectForKey:@"open_msg"];
    NSString * closeWayStr = [dic objectForKey:@"close_msg"];
    SMSTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[SMSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTitle:titleStr withConsumption:consumptionStr withOpenWay:openWayStr withCloseWay:closeWayStr];
    return cell;
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
