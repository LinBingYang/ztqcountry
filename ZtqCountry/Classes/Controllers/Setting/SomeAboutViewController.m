//
//  SomeAboutViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-28.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "SomeAboutViewController.h"
#import "MoreCell.h"
#import "AskQViewController.h"
#import "aboutZTQ.h"
#import "MianzeViewController.h"
#import "QXDXViewController.h"

@interface SomeAboutViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView * aboutList;
@property (strong, nonatomic) NSMutableArray * datas;


@end

@implementation SomeAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)configDatas
{
    _datas = [[NSMutableArray alloc] init];
    NSMutableArray * firstArr = [[NSMutableArray alloc] init];
    NSMutableArray * secondArr = [[NSMutableArray alloc] init];
    [_datas addObject:firstArr];
    [_datas addObject:secondArr];
    NSDictionary * dic1_1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"气象短信",@"Title",@"关于_03.png",@"Icon", nil];
    [firstArr addObject:dic1_1];
    NSDictionary * dic2_1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"常见问题",@"Title",@"关于_07.png",@"Icon", nil];
    NSDictionary * dic2_2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"免责声明",@"Title",@"关于_11.png",@"Icon", nil];
    NSDictionary * dic2_3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"关于知天气",@"Title",@"关于_15.png",@"Icon", nil];
    [secondArr addObject:dic2_1];
    [secondArr addObject:dic2_2];
    [secondArr addObject:dic2_3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configDatas];
    self.barHiden = NO;
    self.titleLab.text = @"关于";
    self.titleLab.textColor = [UIColor whiteColor];
    _aboutList = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight) style:UITableViewStylePlain];
    _aboutList.separatorStyle=UITableViewCellSeparatorStyleNone;
    _aboutList.dataSource = self;
    _aboutList.delegate = self;
    [self.view addSubview:_aboutList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"#%d#",section);
    NSLog(@"$%@$",[self.datas objectAtIndex:section]);
    NSArray * sectionArr = [self.datas objectAtIndex:section];
    return sectionArr.count;
    if(section == 0)
        return 1;
    else
        return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"#%d#",self.datas.count);
    return self.datas.count;
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * sectionArr = [self.datas objectAtIndex:indexPath.section];
    NSDictionary * rowInfo = [sectionArr objectAtIndex:indexPath.row];
    MoreCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[MoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.logoImagV.image = [UIImage imageNamed:[rowInfo objectForKey:@"Icon"]];
    CGRect orignFram = cell.logoImagV.frame;
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            //18,18
            cell.logoImagV.frame = CGRectMake(orignFram.origin.x, orignFram.origin.y, 16, 12);
        }
    }
    else
    {
        if(indexPath.row == 0)
        {
            //18,18
            cell.logoImagV.frame = CGRectMake(orignFram.origin.x, orignFram.origin.y, 16, 16);
        }
        if(indexPath.row == 1)
        {
            //18,18
            cell.logoImagV.frame = CGRectMake(orignFram.origin.x, orignFram.origin.y, 16, 15);
        }
        if(indexPath.row == 2)
        {
            //18,18
            cell.logoImagV.frame = CGRectMake(orignFram.origin.x, orignFram.origin.y, 16, 15);
        }

    }
       cell.titleLab.text = [rowInfo objectForKey:@"Title"];
    cell.horizontalLine.hidden = YES;
    cell.verticalLine.hidden = YES;
    UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"灰色隔条.png"]];
    [m_image setFrame:CGRectMake(0, 44, kScreenWidth, 1)];
    [cell addSubview:m_image];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            [self qixiangduanxin];
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                [self quest];
                return;
            }
            case 1:
            {
                [self mianze];
                return;
            }
            case 2:
            {
                [self abt];
                return;
            }
        }

    }
}


//常见问题
-(void)quest{
    AskQViewController *ask=[[AskQViewController alloc]init];
    [self.navigationController pushViewController:ask animated:YES];
}

//关于
-(void)abt{
    aboutZTQ *aboutztq=[[aboutZTQ alloc]init];
    aboutztq.content = [NSString stringWithFormat:@"%@", @"       “知天气”是国内首款汇聚了各省特色气象信息资源的气象客户端，由各省气象局联合打造，为全国用户提供最及时、最丰富、最实用、最专业的气象服务。"];
    [self.navigationController pushViewController:aboutztq animated:YES];
}
//免责
-(void)mianze{
    //    CGRect t_frame = CGRectMake(0, 0, 320,kScreenHeitht);
    //
    //    NSString *k_title = @"免责声明";
    //    NSString *c_title = [NSString stringWithFormat:@"       1、 “知天气”提供的天气预报信息产品服务仅供用户作为生活、生产等活动的参考信息，用户据此作出的行为及所产生的后果与“知天气”及其关联的单位无关。\n       2、 由于不可抗力或互联网传输原因等造成信息传播的延迟、中断和缺失，“知天气”不承担任何责任。因不可预测或无法控制的系统故障、设备故障、通讯故障等原因给用户造成损失的，“知天气”不承担任何的赔偿责任。\n       3、 “知天气”努力给用户提供及时、准确的天气信息产品服务，但不承担因预报准确率原因引起的任何损失、损害。您在使用“知天气”时可能产生的GPRS流量资费各地不同，由当地运营商收取。\n       4、 “知天气”掌上气象提供的所有数据仅供参考，不具备法律效力，不得挪为他用。\n       5、 本声明的最终解释权归“知天气”所有。\n       以上风险提示，您已阅读并理解，如果继续使用，即表明您同意承担使用“知天气”所有服务可能存在的风险。"];
    //    about = [[AboutView alloc] initWithView:k_title setMessage:c_title setRect:t_frame];
    //    [about show];
    MianzeViewController * mianzeVC = [[MianzeViewController alloc] init];
    [self.navigationController pushViewController:mianzeVC animated:YES];
}
//气象短信
-(void)qixiangduanxin
{
    QXDXViewController * qxdxVC = [[QXDXViewController alloc] init];
    [self.navigationController pushViewController:qxdxVC animated:YES];
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
