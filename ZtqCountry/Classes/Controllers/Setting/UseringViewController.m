//
//  UseringViewController.m
//  ztqFj
//
//  Created by Admin on 15/5/7.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "UseringViewController.h"
#import "WebViewController.h"
@interface UseringViewController ()

@end

@implementation UseringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLab.text=@"使用指南";
    self.barHiden=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    self.m_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight-100) style:UITableViewStylePlain];
    self.m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_tableview.backgroundColor=[UIColor clearColor];
    self.m_tableview.backgroundView=nil;
    self.m_tableview.autoresizesSubviews = YES;
    self.m_tableview.showsHorizontalScrollIndicator = YES;
    self.m_tableview.showsVerticalScrollIndicator = YES;
    self.m_tableview.delegate = self;
    self.m_tableview.dataSource = self;
    [self.view addSubview:self.m_tableview];
    [self getuseing];
    
    UILabel *ques=[[UILabel alloc]initWithFrame:CGRectMake(15, kScreenHeitht-120, kScreenWidth, 30)];
    ques.text=@"以上未尽问题,请联系我们:";
    ques.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:ques];
    UIButton *t_weiboLink = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-111)/4, kScreenHeitht-70, 37, 37)];
    [t_weiboLink setBackgroundImage:[UIImage imageNamed:@"微博.png"] forState:UIControlStateNormal];
    t_weiboLink.tag = 100;
    [t_weiboLink addTarget:self action:@selector(gotoWeibo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:t_weiboLink];
    

    
    UIButton *t_weiboLink2 = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-111)/4*2+37, kScreenHeitht-70, 37, 37)];
    
    [t_weiboLink2 setBackgroundImage:[UIImage imageNamed:@"短信.png"] forState:UIControlStateNormal];
    t_weiboLink2.tag = 101;
    [t_weiboLink2 addTarget:self action:@selector(gotoWeibo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:t_weiboLink2];
    
  
    
    UIButton *meail = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-111)/4*3+74, kScreenHeitht-70, 37, 37)];
    
    [meail setBackgroundImage:[UIImage imageNamed:@"电话.png"] forState:UIControlStateNormal];
    meail.tag = 102;
    [meail addTarget:self action:@selector(gotoWeibo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:meail];
}
-(void)getuseing{
   
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *qxfw_product = [NSMutableDictionary dictionaryWithCapacity:4];
    
   
    [t_b setObject:qxfw_product forKey:@"gz_help_question"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:0 withSuccess:^(NSDictionary *returnData) {
//        NSLog(@"%@",returnData);
        NSDictionary *b=[returnData objectForKey:@"b"];
        NSDictionary *qxfw_sel=[b objectForKey:@"gz_help_question"];
        self.datas=[qxfw_sel objectForKey:@"quest_list"];
        
        [self.m_tableview reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        
    } withCache:YES];
}
#pragma mark -
#pragma mark -UITableDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.datas.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
//    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 2, kScreenWidth-10, 46)];
//    bgimg.backgroundColor=[UIColor colorHelpWithRed:231 green:231 blue:231 alpha:1];
//    bgimg.userInteractionEnabled=YES;
//    [cell addSubview:bgimg];
    
    UILabel *titlelab=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, kScreenWidth-20, 30)];
    titlelab.text=[self.datas[row] objectForKey:@"title"];
    titlelab.font=[UIFont systemFontOfSize:15];
    [cell addSubview:titlelab];
    UIImageView *l_line=[[UIImageView alloc]initWithFrame:CGRectMake(15, 49, kScreenWidth-30, 1)];
//    l_line.image=[UIImage imageNamed:@"灰色隔条"];
    l_line.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
    [cell addSubview:l_line];
    return cell;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *con=[[WebViewController alloc]init];
//    con.titstr=[self.datas[indexPath.row] objectForKey:@"title"];
    con.titleString=@"使用指南";
    con.url=[self.datas[indexPath.row] objectForKey:@"html_url"];
    [self.navigationController pushViewController:con animated:YES];
}
- (void) gotoWeibo:(id)sender
{
    UIButton *t_button = (UIButton *)sender;
    if (t_button.tag == 100){
        [ShareFun openUrl:ZTQ_SINA_WEIBO];}
    else if (t_button.tag == 101){
        //        [ShareFun openUrl:ZTQ_SINA_WEIBO];
        [self sendMail];
    }
    else if (t_button.tag==102){
        //        [self sendMail];
//        int nunber=059183339985;
        NSString *num=@"059183339985";
        NSString *num1 = [[NSString alloc]initWithFormat:@"tel://%@",num];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num1]]; //拨号
    }
}
-(void)sendMail{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self toMail];
        }
        else
        {
            UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"启动邮件失败，请至“设置——邮件、通讯录、日历”里设置邮箱" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [t_alertView show];
            //            [t_alertView release];
        }
    }
    
}
-(void)toMail{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];     //创建邮件controller
    
    mailPicker.mailComposeDelegate = self;;  //设置邮件代理
    
    [mailPicker setSubject:@""]; //邮件主题
    
    [mailPicker setToRecipients:[NSArray arrayWithObjects:@"2415252943@qq.com", nil]]; //设置发送给谁，参数是NSarray
    
    [mailPicker setMessageBody:@"" isHTML:NO];     //邮件内容
    
    [self presentModalViewController:mailPicker animated:YES];
}
#pragma mark mail
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result

                        error:(NSError*)error

{
    UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"邮件发送失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    
    switch (result){
            
        case MFMailComposeResultCancelled:
            
            break;
            
        case MFMailComposeResultSaved:
            t_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"邮件保持成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [t_alertView show];
            //            [t_alertView release];
            break;
            
        case MFMailComposeResultSent:
            
            break;
            
        case MFMailComposeResultFailed:
            
            [t_alertView show];
            //            [t_alertView release];
            break;
            
        default:
            break;
            
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
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
