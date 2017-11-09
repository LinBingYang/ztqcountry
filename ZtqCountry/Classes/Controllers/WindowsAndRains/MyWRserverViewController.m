//
//  MyWRserverViewController.m
//  ZtqCountry
//
//  Created by Admin on 16/1/13.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "MyWRserverViewController.h"
#import "UILabel+utils.h"
#import "WRPayViewController.h"
@interface MyWRserverViewController ()
@property(strong,nonatomic)NSString *username,*empty_tip,*userid;
@property(strong,nonatomic)NSArray *my_servicese_list;
@end

@implementation MyWRserverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.barHiden=NO;
    self.titleLab.text=@"我的服务";
    NSString * username = [[NSUserDefaults standardUserDefaults]objectForKey:@"sjusername"];
    self.username=username;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self getgz_wr_my_services];
}
-(void)getgz_wr_my_services{
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    self.userid=userid;
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if (userid.length>0) {
        [gz_todaywt_inde setObject:userid forKey:@"user_id"];
    }
    [b setObject:gz_todaywt_inde forKey:@"gz_wr_my_services"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *gz_wr_rank=[b objectForKey:@"gz_wr_my_services"];
            self.my_servicese_list=[gz_wr_rank objectForKey:@"my_servicese_list"];
            self.empty_tip=[gz_wr_rank objectForKey:@"empty_tip"];
            [self.tableView reloadData];
            
        }
    } withFailure:^(NSError *error) {
       [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withCache:YES];
}

#pragma mark -UITableDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.my_servicese_list.count>0) {
        return 2;
    }
    return self.my_servicese_list.count+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
  
    if (indexPath.row==0) {
        return 130;
    }
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
    if (row==0) {
        UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 120)];
        bgimg.image=[UIImage imageNamed:@"个人中心图片"];
        bgimg.userInteractionEnabled=YES;
        [cell addSubview:bgimg];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 15, kScreenWidth, 30)];
        lab.text=[NSString stringWithFormat:@"欢迎您，%@",self.username];
        lab.textColor=[UIColor whiteColor];
        lab.font=[UIFont systemFontOfSize:14];
        [bgimg addSubview:lab];
        UIButton * userBut = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-50)/2, 50, 50, 50)];
        userBut.layer.cornerRadius = 25;
        userBut.layer.masksToBounds = YES;
        UIImage * userImg = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"]];
        if(userImg == nil)
        {
            userImg = [UIImage imageNamed:@"个人图标"];
        }
        [userBut setBackgroundImage:userImg forState:UIControlStateNormal];
        [userBut addTarget:self action:@selector(userButAction) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:userBut];
    }else{
        if (!self.my_servicese_list.count>0) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
            lab.text=self.empty_tip;
            lab.numberOfLines=0;
            lab.textAlignment=NSTextAlignmentCenter;
            lab.textColor=[UIColor blackColor];
            lab.font=[UIFont systemFontOfSize:14];
            [cell addSubview:lab];
            float h=[lab labelheight:self.empty_tip withFont:[UIFont systemFontOfSize:14]];
            lab.frame=CGRectMake(0, 10, kScreenWidth, h+20);
            CGRect cellFrame = [cell frame];
            cellFrame.size.height = lab.frame.size.height;
            [cell setFrame:cellFrame];
        }else{
        UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 130)];
        bgimg.layer.borderWidth=0.5;
        bgimg.layer.borderColor=[UIColor colorHelpWithRed:171 green:171 blue:171 alpha:1].CGColor;
        bgimg.layer.cornerRadius=5;
        bgimg.backgroundColor=[UIColor colorHelpWithRed:242 green:242 blue:242 alpha:1];
        bgimg.userInteractionEnabled=YES;
        [cell addSubview:bgimg];
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth, 30)];
        lab.text=@"服务状态";
        lab.textColor=[UIColor blackColor];
        lab.font=[UIFont systemFontOfSize:14];
        [bgimg addSubview:lab];
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-78, 0, 50, 30)];
        lab1.text=@"服务中";
        lab1.textColor=[UIColor colorHelpWithRed:73 green:141 blue:200 alpha:1];
        lab1.font=[UIFont systemFontOfSize:14];
        [bgimg addSubview:lab1];
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth-20, 0.5)];
        line.backgroundColor=[UIColor colorHelpWithRed:171 green:171 blue:171 alpha:1];
        [bgimg addSubview:line];
            
            
        NSString *time=[self.my_servicese_list[row-1] objectForKey:@"months"];
        NSString *opentime=[self.my_servicese_list[row-1] objectForKey:@"eff_time"];
        NSString *datetime=[self.my_servicese_list[row-1] objectForKey:@"expire_time"];
        NSString *is_renew=[self.my_servicese_list[row-1] objectForKey:@"is_renew"];
            
        UILabel *timelab=[[UILabel alloc]initWithFrame:CGRectMake(15, 35, kScreenWidth, 30)];
        timelab.text=[NSString stringWithFormat:@"服务期限： %@",time];
        timelab.textColor=[UIColor blackColor];
        timelab.font=[UIFont systemFontOfSize:14];
        [bgimg addSubview:timelab];
        UILabel *opentimelab=[[UILabel alloc]initWithFrame:CGRectMake(15, 65, kScreenWidth, 30)];
        opentimelab.text=[NSString stringWithFormat:@"开通时间： %@",opentime];
        opentimelab.textColor=[UIColor blackColor];
        opentimelab.font=[UIFont systemFontOfSize:14];
        [bgimg addSubview:opentimelab];
        UILabel *expire_timelab=[[UILabel alloc]initWithFrame:CGRectMake(15, 95, kScreenWidth, 30)];
        expire_timelab.text=[NSString stringWithFormat:@"到期时间： %@",datetime];
        expire_timelab.textColor=[UIColor blackColor];
        expire_timelab.font=[UIFont systemFontOfSize:14];
        [bgimg addSubview:expire_timelab];
            if ([is_renew isEqualToString:@"1"]) {
                UIButton *xfbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-75, 100, 40, 25)];
                [xfbtn setTitle:@"续费" forState:UIControlStateNormal];
                xfbtn.tag=indexPath.row;
                xfbtn.titleLabel.font=[UIFont systemFontOfSize:13];
                [xfbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮常态"] forState:UIControlStateNormal];
                [xfbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮点击态"] forState:UIControlStateHighlighted];
                [xfbtn addTarget:self action:@selector(xfAction:) forControlEvents:UIControlEventTouchUpInside];
                [bgimg addSubview:xfbtn];
                
            }
            
            CGRect cellFrame = [cell frame];
            cellFrame.size.height = 150;
            bgimg.frame=CGRectMake(10, 20, kScreenWidth-20, cellFrame.size.height-20);
            [cell setFrame:cellFrame];
        }
        
    }
    return cell;
}
-(void)xfAction:(UIButton *)sender{
    NSInteger tag=sender.tag;
    NSString *orderid=[self.my_servicese_list[tag-1] objectForKey:@"order_id"];
    WRPayViewController *wrpayvc=[[WRPayViewController alloc]init];
    wrpayvc.type=@"2";
    wrpayvc.orderid=orderid;
    wrpayvc.userid=self.userid;
    [self.navigationController pushViewController:wrpayvc animated:YES];
}
-(void)userButAction{
    
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
