//
//  WindowAndRainVC.m
//  ZtqCountry
//
//  Created by Admin on 16/1/13.
//  Copyright © 2016年 yyf. All rights reserved.
//
#import "gz_wr_rain.h"
#import "WindowAndRainVC.h"
#import "SelectCityViewController.h"
#import "MJExtension.h"
#import "MyWRserverViewController.h"
#import "LGViewController.h"
#import "WRPayViewController.h"
#import "UILabel+utils.h"
#import "WebViewController.h"
#import "wr_list.h"
#import "gz_wr_six_tendView.h"
#import "gz_wr_rain_sectionView.h"
#import "gz_wr_pro_rankView.h"
#import "rank_list.h"
#import "gz_wr_more_rankViewController.h"
#import "gz_wr_temp.h"
#import "gz_wr_wind.h"
@interface WindowAndRainVC ()<gz_wr_pro_rankViewDelegate>

@property(strong,nonatomic)UIImageView *btnlineimg;
@property(strong,nonatomic)UIScrollView *bgscr;
@property(strong,nonatomic)NSString *userid,*username,*city,*cityid,*proid;
@property(strong,nonatomic)UILabel *citylab;
@property(strong,nonatomic)gz_wr_rain *gz_wr;
@property(nonatomic,strong) NSArray *wr_lists;
@property(nonatomic,assign) int BtnTag;
@property(assign)NSInteger btntag,ranktag;
@property(nonatomic,strong) UISegmentedControl *segment;
@property(nonatomic,strong) UISegmentedControl *segmentPaihang; //天气排行选择Top20
@property(nonatomic,assign) int selectIndex;
@property(nonatomic,assign) int selectIndex1;//天气排行选择Top20选择index
//降雨3个View
@property(nonatomic,strong)gz_wr_six_tendView *SixtendView;
@property(nonatomic,strong)gz_wr_rain_sectionView *rain_sectionView;
@property(nonatomic,strong) gz_wr_pro_rankView *pro_rankView;
//全省雨量排行数据
@property(nonatomic,strong)NSArray *rank_lists;
@property(nonatomic,copy) NSString *rank_list_time;
@property(nonatomic,copy) NSString *rank_list_time1;
@property(nonatomic,copy) NSString *rank_list_time2;
@property(nonatomic,strong) gz_wr_temp *wr_temp;
//全省高低温排行数据
@property(nonatomic,strong)NSArray *Hrank_lists;
@property(nonatomic,strong)NSArray *Lrank_lists;
//全省实况高低温数据
@property(nonatomic,strong)NSArray *Hrank_lists1;
@property(nonatomic,strong)NSArray *Lrank_lists1;
@property(nonatomic,copy) NSString *rank_list_time3;
@property(nonatomic,copy) NSString *rank_list_time4;
//全省风况排行数据
@property(strong,nonatomic)gz_wr_wind *gz_wind;
@property(nonatomic,strong)NSArray *gz_wr_pro_rank_lists;
@property(nonatomic,strong)NSArray *gz_wr_pro_tru_lists;
@end

@implementation WindowAndRainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.barHiden=NO;
    self.titleLab.text=@"风雨查询";
    self.isothertype=NO;
    self.ispaysuccess=NO;
    self.ranknames=[[NSArray alloc]initWithObjects:@"高温TOP20",@"低温TOP20",@"雨量TOP20", nil];
    self.proid=[self getProviceIDWithcityID:[setting sharedSetting].currentCityID];
    self.view.backgroundColor=[UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateview:) name:@"fycx" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payedview) name:@"wrrefresh" object:nil];
    self.selectIndex1=0;
    [self creatview];
    [self getAdBanenerScro];
}
-(void)updateview:(NSNotification *)object{
    NSDictionary *dic=object.object;
    NSString *city=[dic objectForKey:@"city"];
    NSString *cityid=[dic objectForKey:@"ID"];
    if (city.length>0) {
        self.city=[self readXMLwith:cityid];
        self.cityid=cityid;
        self.proid=[self getProviceIDWithcityID:self.cityid];
        if (!self.proid) {
            self.proid=[self getProviceIDWithcityID:[setting sharedSetting].currentCityID];
        }
    }
    if (self.btntag==1) {
        [self btnclick1];
    }
    if (self.btntag==2) {
        [self btnclick2];
    }
    if (self.btntag==3) {
      [self btnclick3];
    }
//    [self.tableView reloadData];
}
//获取省份id
-(NSString *)getProviceIDWithcityID:(NSString *)cityid{
    NSString *proid=nil;
        m_allCity=m_treeNodeAllCity;
        for (int i = 0; i < [m_allCity.children count]; i ++)
        {
            TreeNode *t_node = [m_allCity.children objectAtIndex:i];
            TreeNode *t_node_child = [t_node.children objectAtIndex:0];
            NSString *t_name = t_node_child.leafvalue;
            if ([cityid isEqualToString:t_name])
            {
                
                TreeNode *t_node_child1 = [t_node.children objectAtIndex:1];
                NSString *Id = t_node_child1.leafvalue;
                proid=Id;
                break;
            }
          
        }
        
    return proid;
    
}
//获取showname
-(NSString *)readXMLwith:(NSString *)cityid{
    m_allCity=m_treeNodeAllCity;
    NSString *city=[setting sharedSetting].currentCity;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:0];
        t_node_child = [t_node.children objectAtIndex:0];
        NSString *cityID = t_node_child.leafvalue;
        if ([cityID isEqualToString:cityid])
        {
            
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:6];
            NSString *cityname = t_node_child1.leafvalue;
            city=cityname;
        }
    }
    
    return city;
}
-(void)payedview{
    self.ispaysuccess=YES;
}
-(void)viewWillAppear:(BOOL)animated{
    self.userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    self.username=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjusername"];
    if (self.isothertype==YES||self.ispaysuccess==YES) {
        if (self.btntag==1) {
            [self btnclick1];
        }
        if (self.btntag==2) {
            [self btnclick2];
        }
        if (self.btntag==3) {
            [self btnclick3];
        }
    }
    
}
-(void)creatview{
    NSArray *titles=[[NSArray alloc]initWithObjects:@"天气排行",@"降雨",@"气温",@"风况", nil];
    for (int i=0; i<titles.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(i*(kScreenWidth/4), self.barHeight, kScreenWidth/4, 35)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag=i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
     
        
    }
    self.btnlineimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 35+self.barHeight, kScreenWidth/4, 2)];
    self.btnlineimg.image=[UIImage imageNamed:@"一周 24小时切换条"];
    [self.view addSubview:self.btnlineimg];
   
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight+37, kScreenWidth, kScreenHeitht-self.barHeight-40) style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
     [self btnAction:0];
}
#pragma mark -UITableDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.btntag==0) {
        return self.ranks.count+2;
    }
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (self.btntag==0) {
        return 35;
    }
    if (indexPath.row==0) {
        return 40;
    }
    return cell.frame.size.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.btntag==0) {
        return 75;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-10, 30)];
    if (!self.ranktime.length>0) {
        self.ranktime=@"";
    }
    lab.text=[NSString stringWithFormat:@"统计时间：%@",self.ranktime];
    lab.font=[UIFont systemFontOfSize:14];
    [headerView addSubview:lab];
//    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(20, 40, kScreenWidth-40, 30)];
//    [btn setBackgroundImage:[UIImage imageNamed:@"天气排行 高低温 切换"] forState:UIControlStateNormal];
//    [btn setTitle:self.rankname forState:UIControlStateNormal];
//    btn.titleLabel.font=[UIFont systemFontOfSize:15];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(rankAction) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:btn];
    _segmentPaihang=[[UISegmentedControl alloc] initWithItems:@[@"高温TOP20",@"低温TOP20",@"雨量TOP20"]];
    _segmentPaihang.frame=CGRectMake(15, 40, kScreenWidth-30, 25);
    _segmentPaihang.tintColor=[UIColor colorHelpWithRed:88 green:160 blue:220 alpha:1];
    NSDictionary *dict=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]};
    [_segmentPaihang setTitleTextAttributes:dict forState:UIControlStateNormal];
    NSDictionary *dict1=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [_segmentPaihang setTitleTextAttributes:dict1 forState:UIControlStateSelected];
    [_segmentPaihang addTarget:self action:@selector(segementPaihangClick:) forControlEvents:UIControlEventValueChanged];
    _segmentPaihang.selectedSegmentIndex=self.selectIndex1;
//    UIImageView *jt=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-65, 5, 20, 20)];
//    jt.image=[UIImage imageNamed:@"天气排行下拉"];
//    [btn addSubview:jt];
    [headerView addSubview:_segmentPaihang];
    return headerView;
}
-(void)segementPaihangClick:(UISegmentedControl *)segement
{
    switch (segement.selectedSegmentIndex) {
        case 1:
            self.selectIndex1=1;
            self.ranktag=2;
            break;
        case 2:
            self.selectIndex1=2;
            self.ranktag=3;
            break;
        default:
            self.selectIndex1=0;
            self.ranktag=1;
            break;
    }
    NSString *type=[NSString stringWithFormat:@"%d",self.ranktag];
    [self getgz_wr_rankwithtype:type];
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
    if (self.btntag==0) {
        if (row==0) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth, 35)];
            lab.text=@"数据说明：当日预报数值";
            lab.textColor=[UIColor blackColor];
            lab.font=[UIFont systemFontOfSize:15];
            [cell addSubview:lab];
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 1)];
            line.backgroundColor=[UIColor grayColor];
            [cell addSubview:line];
            UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 1, 35)];
            line1.backgroundColor=[UIColor grayColor];
            [cell addSubview:line1];
            UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-10, 0,1, 35)];
            line2.backgroundColor=[UIColor grayColor];
            [cell addSubview:line2];
            UIImageView *line4=[[UIImageView alloc]initWithFrame:CGRectMake(10, 34, kScreenWidth-20, 1)];
            line4.backgroundColor=[UIColor grayColor];
            [cell addSubview:line4];
        }else if (row==1) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, (kScreenWidth-20)/3, 35)];
            lab.text=@"序号";
            lab.textAlignment=NSTextAlignmentCenter;
            lab.textColor=[UIColor blackColor];
            lab.font=[UIFont systemFontOfSize:15];
            [cell addSubview:lab];
            UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-20)/3+5, 0, (kScreenWidth-20)/3, 35)];
            lab1.text=@"城市";
            lab1.textAlignment=NSTextAlignmentCenter;
            lab1.textColor=[UIColor blackColor];
            lab1.font=[UIFont systemFontOfSize:15];
            [cell addSubview:lab1];
            UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-20)/3*2+15, 0, (kScreenWidth-20)/3, 35)];
            if (self.ranktag!=3) {
                lab2.text=@"气温（℃）";
            }else
                lab2.text=@"雨量（mm）";
            lab2.textAlignment=NSTextAlignmentCenter;
            lab2.textColor=[UIColor blackColor];
            lab2.font=[UIFont systemFontOfSize:15];
            [cell addSubview:lab2];
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10, 34, kScreenWidth-20, 1)];
            line.backgroundColor=[UIColor grayColor];
            [cell addSubview:line];
            UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 1, 35)];
            line1.backgroundColor=[UIColor grayColor];
            [cell addSubview:line1];
            UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-10)/3, 0,1, 35)];
            line2.backgroundColor=[UIColor grayColor];
            [cell addSubview:line2];
            UIImageView *line3=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-10)/3*2, 0, 1, 35)];
            line3.backgroundColor=[UIColor grayColor];
            [cell addSubview:line3];
            UIImageView *line4=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-10), 0,1, 35)];
            line4.backgroundColor=[UIColor grayColor];
            [cell addSubview:line4];
        }else{
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, (kScreenWidth-20)/3, 35)];
            lab.text=[self.ranks[row-2] objectForKey:@"num"];
            lab.textAlignment=NSTextAlignmentCenter;
            lab.textColor=[UIColor blackColor];
            lab.font=[UIFont systemFontOfSize:15];
            [cell addSubview:lab];
            UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-20)/3+5, 0, (kScreenWidth-20)/3, 35)];
            lab1.text=[self.ranks[row-2] objectForKey:@"name"];
            lab1.textAlignment=NSTextAlignmentCenter;
            lab1.numberOfLines=0;
            lab1.textColor=[UIColor blackColor];
            lab1.font=[UIFont systemFontOfSize:15];
            [cell addSubview:lab1];
            UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-20)/3*2+15, 0, (kScreenWidth-20)/3, 35)];
            lab2.text=[self.ranks[row-2] objectForKey:@"wt_rank"];
            lab2.textAlignment=NSTextAlignmentCenter;
            lab2.textColor=[UIColor blackColor];
            lab2.font=[UIFont systemFontOfSize:15];
            [cell addSubview:lab2];
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10, 34, kScreenWidth-20, 1)];
            line.backgroundColor=[UIColor grayColor];
            [cell addSubview:line];
            UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 1, 35)];
            line1.backgroundColor=[UIColor grayColor];
            [cell addSubview:line1];
            UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-10)/3, 0,1, 35)];
            line2.backgroundColor=[UIColor grayColor];
            [cell addSubview:line2];
            UIImageView *line3=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-10)/3*2, 0, 1, 35)];
            line3.backgroundColor=[UIColor grayColor];
            [cell addSubview:line3];
            UIImageView *line4=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-10), 0,1, 35)];
            line4.backgroundColor=[UIColor grayColor];
            [cell addSubview:line4];
        }
    }else{
    
        if (row==0) {
        UIButton *addbtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
        [addbtn setBackgroundImage:[UIImage imageNamed:@"添加常态"] forState:UIControlStateNormal];
        [addbtn setBackgroundImage:[UIImage imageNamed:@"添加点击态"] forState:UIControlStateHighlighted];
        [addbtn addTarget:self action:@selector(addcity) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:addbtn];
        UIButton *citybtn=[[UIButton alloc]initWithFrame:CGRectMake(50, 5, 165, 30)];
        if (self.city.length>0) {
            [citybtn setTitle:self.city forState:UIControlStateNormal];
        }else{
            [citybtn setTitle:[self readXMLwith:[setting sharedSetting].currentCityID] forState:UIControlStateNormal];
        }
        citybtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [citybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        citybtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [citybtn addTarget:self action:@selector(addcity) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:citybtn];
//        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(55, 5, 200, 30)];
//        if (self.city.length>0) {
//            lab.text=self.city;
//        }else{
//            lab.text=[self readXMLwith:[setting sharedSetting].currentCityID];
//        }
//        lab.font=[UIFont systemFontOfSize:15];
//        [cell addSubview:lab];
            NSString *isouth=self.gz_wr.is_auth;
            if (self.btntag==2) {
                isouth=self.wr_temp.is_auth;
            }
            if (self.btntag==3) {
                isouth=self.gz_wind.is_auth;
            }
        if (self.userid.length>0&&[isouth isEqualToString:@"1"]) {
            UIButton *serbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-100, 5, 65, 30)];
            [serbtn setTitle:@"我的服务" forState:UIControlStateNormal];
            serbtn.titleLabel.font=[UIFont systemFontOfSize:15];
            [serbtn setTitleColor:[UIColor colorHelpWithRed:60 green:151 blue:220 alpha:1] forState:UIControlStateNormal];
            [serbtn addTarget:self action:@selector(myserverAction) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:serbtn];
            UIButton *jtbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-35, 13, 15, 15)];
            [jtbtn setBackgroundImage:[UIImage imageNamed:@"文字又拉"] forState:UIControlStateNormal];
            [jtbtn addTarget:self action:@selector(myserverAction) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:jtbtn];
        }
    }
    if (row==1) {
//        CGFloat BgimgH=60;
        UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 60)];
        bgimg.layer.borderWidth=0.5;
        bgimg.layer.borderColor=[UIColor colorHelpWithRed:171 green:171 blue:171 alpha:1].CGColor;
        bgimg.layer.cornerRadius=5;
        bgimg.backgroundColor=[UIColor colorHelpWithRed:242 green:242 blue:242 alpha:1];
        bgimg.userInteractionEnabled=YES;
        [cell addSubview:bgimg];
        CGRect cellFrame = [cell frame];
        cellFrame.size.height = 60;
        bgimg.frame=CGRectMake(10, 0, kScreenWidth-20, cellFrame.size.height);
        [cell setFrame:cellFrame];
        [self setRow_1_WithImageView:bgimg andCell:cell];//设置Row1

    }
    if (row==2) {
        CGRect cellFrame = [cell frame];
        cellFrame.size.height = 90;
        UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-20, cellFrame.size.height-10)];
        bgimg.layer.borderWidth=0.5;
        bgimg.layer.borderColor=[UIColor colorHelpWithRed:171 green:171 blue:171 alpha:1].CGColor;
        bgimg.layer.cornerRadius=5;
        bgimg.backgroundColor=[UIColor colorHelpWithRed:242 green:242 blue:242 alpha:1];
        bgimg.userInteractionEnabled=YES;
        [cell addSubview:bgimg];
        
        NSString *isouth=self.gz_wr.is_auth;
        if (self.btntag==2) {
            isouth=self.wr_temp.is_auth;
        }
        if (self.btntag==3) {
            isouth=self.gz_wind.is_auth;
        }
        //鉴权判断
        if ([isouth isEqualToString:@"0"]) {
            
                UIButton * userBut = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
                userBut.layer.cornerRadius = 25;
                userBut.layer.masksToBounds = YES;
                UIImage * userImg = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"]];
                if(userImg == nil)
                {
                    userImg = [UIImage imageNamed:@"个人图标"];
                }
                [userBut setBackgroundImage:userImg forState:UIControlStateNormal];
                [userBut addTarget:self action:@selector(userButAction) forControlEvents:UIControlEventTouchUpInside];
                [bgimg addSubview:userBut];
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(65, 10,180, 30)];
            
                lab.textColor=[UIColor blackColor];
                lab.font=[UIFont systemFontOfSize:14];
                [bgimg addSubview:lab];
                UIButton *lgbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-90, 10, 60, 30)];
                [lgbtn setBackgroundImage:[UIImage imageNamed:@"查询"] forState:UIControlStateNormal];
            
                lgbtn.titleLabel.font=[UIFont systemFontOfSize:15];
                [lgbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
                [bgimg addSubview:lgbtn];
                UILabel *loglab=[[UILabel alloc]initWithFrame:CGRectMake(65, 40, 260, 30)];
            
                loglab.numberOfLines=0;
                loglab.textColor=[UIColor blackColor];
                loglab.font=[UIFont systemFontOfSize:14];
                [bgimg addSubview:loglab];
            if (!self.userid.length>0) {
                lab.text=@"我的个人中心";
                [lgbtn setTitle:@"登录" forState:UIControlStateNormal];
                [lgbtn addTarget:self action:@selector(lgAction) forControlEvents:UIControlEventTouchUpInside];
                loglab.text=self.gz_wr.login_tip;
                if (self.btntag==2) {
                    loglab.text=self.wr_temp.login_tip;
                }
                if (self.btntag==3) {
                    loglab.text=self.gz_wind.login_tip;
                }
                
            }else{
                [lgbtn setTitle:@"开通" forState:UIControlStateNormal];
                [lgbtn addTarget:self action:@selector(openAction) forControlEvents:UIControlEventTouchUpInside];
                lab.text=[NSString stringWithFormat:@"欢迎你，%@！",self.username];
                loglab.text=self.gz_wr.use_tip;
                if (self.btntag==2) {
                    loglab.text=self.wr_temp.use_tip;
                }
                if (self.btntag==3) {
                    loglab.text=self.gz_wind.use_tip;
                }
            }
            float lab_h=[loglab labelheight:self.gz_wr.use_tip withFont:[UIFont systemFontOfSize:14]];
            if (self.btntag==2) {
                lab_h=[loglab labelheight:self.wr_temp.use_tip withFont:[UIFont systemFontOfSize:14]];
            }
            if (self.btntag==3) {
                lab_h=[loglab labelheight:self.gz_wind.use_tip withFont:[UIFont systemFontOfSize:14]];
            }
        
            self.mywrscrollview=[[WRScrollView alloc]initWithNameArr:self.adimgurls titleArr:self.adtitles height:300 offsetY:(lab_h+50) offsetx:0];
            self.mywrscrollview.Delegate=self;
            [bgimg addSubview:self.mywrscrollview];
            bgimg.frame=CGRectMake(10, 5, kScreenWidth-20, lab_h+340);
            cellFrame.size.height=bgimg.frame.size.height;
             [cell setFrame:cellFrame];
        }
        else if ([isouth isEqualToString:@"1"]){
        
        cellFrame.size.height = CGRectGetHeight(bgimg.frame)+20+kScreenHeitht*0.42;
        UIImageView *bgimg2=[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(bgimg.frame)+5, kScreenWidth-20,  cellFrame.size.height-CGRectGetHeight(bgimg.frame))];
        bgimg2.layer.borderWidth=0.5;
        bgimg2.layer.borderColor=[UIColor colorHelpWithRed:171 green:171 blue:171 alpha:1].CGColor;
        bgimg2.layer.cornerRadius=5;
        bgimg2.backgroundColor=[UIColor colorHelpWithRed:242 green:242 blue:242 alpha:1];
        bgimg2.userInteractionEnabled=YES;
        [cell addSubview:bgimg2];
        [self setRow_2_WithImageView:bgimg andImageView:bgimg2 andCell:cell];
            cellFrame.size.height=self.cellheight+20;
            [cell setFrame:cellFrame];
        }
    }
    }
    return cell;
}
-(void)setRow_2_WithImageView:(UIImageView *)bgimg andImageView:(UIImageView *)bgimg2 andCell:(UITableViewCell *)cell
{
    UILabel *lianxuRain=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 250, CGRectGetHeight(bgimg.frame)*0.33)];
    lianxuRain.textColor=[UIColor blackColor];
    //                lianxuRain.backgroundColor=[UIColor redColor];
    lianxuRain.font=[UIFont systemFontOfSize:15];
    [bgimg addSubview:lianxuRain];
    UILabel *lianxuRain1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgimg.frame)*0.5, 5, 250, CGRectGetHeight(bgimg.frame)*0.33)];
    lianxuRain1.textColor=[UIColor blackColor];
    //                lianxuRain.backgroundColor=[UIColor redColor];
    lianxuRain1.font=[UIFont systemFontOfSize:15];
    [bgimg addSubview:lianxuRain1];
    //最近下雨时间
    UILabel *zuijinRainTime=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lianxuRain.frame), 300, CGRectGetHeight(bgimg.frame)*0.33)];
    zuijinRainTime.textColor=[UIColor blackColor];
    //                zuijinRainTime.backgroundColor=[UIColor redColor];
    zuijinRainTime.font=[UIFont systemFontOfSize:15];
    [bgimg addSubview:zuijinRainTime];
    //拓展提示
    UILabel *kuozhantip=[[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(zuijinRainTime.frame)+5, CGRectGetWidth(bgimg.frame)-40, CGRectGetHeight(bgimg.frame)*0.33)];
    kuozhantip.textColor=[UIColor blackColor];
    //                kuozhantip.backgroundColor=[UIColor redColor];
    kuozhantip.font=[UIFont systemFontOfSize:15];
    kuozhantip.numberOfLines=0;
    [bgimg addSubview:kuozhantip];
    
    //        UISegmentedControl *segment=[[UISegmentedControl alloc] initWithFrame:CGRectMake(30, 10, kScreenWidth-60, 20)];
    
    //        [segment initWithItems:];
       if (self.BtnTag==1) {
        _segment=[[UISegmentedControl alloc] initWithItems:@[@"过去6天走势",@"降雨区间查询",@"全省雨量排行"]];
       }else if(self.BtnTag==2)
       {
        _segment=[[UISegmentedControl alloc] initWithItems:@[@"过去6天走势",@"全省实况排名",@"全省高低温排名"]];
       }else if(self.BtnTag==3)
       {
        _segment=[[UISegmentedControl alloc] initWithItems:@[@"过去6天走势",@"全省实况排名",@"全省最大风速排名"]];
       }
        _segment.frame=CGRectMake(5, 10, kScreenWidth-30, 25);
        //         segment.tintColor=[UIColor clearColor];
        //        segment.layer.borderWidth=1;
        //        segment.layer.cornerRadius=1;
        //        segment.layer.masksToBounds=YES;
        //        segment.layer.borderColor=[UIColor colorHelpWithRed:229 green:229 blue:229 alpha:1].CGColor;
                _segment.tintColor=[UIColor colorHelpWithRed:88 green:160 blue:220 alpha:1];
        NSDictionary *dict=@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor blackColor]};
        [_segment setTitleTextAttributes:dict forState:UIControlStateNormal];
        NSDictionary *dict1=@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor whiteColor]};
        [_segment setTitleTextAttributes:dict1 forState:UIControlStateSelected];
        
        [_segment addTarget:self action:@selector(segementClick:) forControlEvents:UIControlEventValueChanged];
        _segment.selectedSegmentIndex=self.selectIndex;
    [bgimg2 addSubview:_segment];
    if (self.BtnTag==1) {
    
        if([self.gz_wr.is_auth isEqualToString:@"1"])
        {
            if (self.gz_wr.r_days) {
                  lianxuRain.text=[NSString stringWithFormat:@"%@",self.gz_wr.r_days];
            }
            if (self.gz_wr.near_r_time) {
                
                zuijinRainTime.text=[NSString stringWithFormat:@"最近下雨时间:%@",self.gz_wr.near_r_time];
            }
            if (self.gz_wr.extend_tip) {
                  kuozhantip.text=[NSString stringWithFormat:@"%@",self.gz_wr.extend_tip];
            }
    
          
        }
        [kuozhantip sizeToFit];
        CGRect bgimgF=bgimg.frame;
        bgimgF.size.height=CGRectGetMaxY(kuozhantip.frame)+5;
        bgimg.frame=bgimgF;
        
        CGRect bgimg2F=bgimg2.frame;
        bgimg2F.origin.y=CGRectGetMaxY(bgimg.frame)+5;
        bgimg2.frame=bgimg2F;
        CGRect  cellF=cell.frame;
        cellF.size.height=CGRectGetMaxY(bgimg2.frame)+5;
        cell.frame=cellF;
        if([self.gz_wr.is_auth isEqualToString:@"1"]){
        if (self.selectIndex==0) {
            gz_wr_six_tendView *SixtendView=[[gz_wr_six_tendView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame)+5, CGRectGetWidth(bgimg2.frame), CGRectGetHeight(bgimg2.frame)-CGRectGetMaxY(self.segment.frame))];
            SixtendView.YzhouType=YzhouTypeRain;
            SixtendView.backgroundColor=[UIColor clearColor];
            if (self.wr_lists.count) {
            SixtendView.wr_lists=self.wr_lists;
            }
            self.SixtendView=SixtendView;
            [bgimg2 addSubview:SixtendView];
        }
        if (self.selectIndex==1) {
            gz_wr_rain_sectionView *rain_sectionView=[[gz_wr_rain_sectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame)+5, CGRectGetWidth(bgimg2.frame), CGRectGetHeight(bgimg2.frame)-CGRectGetMaxY(self.segment.frame)-5)];
            rain_sectionView.backgroundColor=[UIColor clearColor];
            self.rain_sectionView=rain_sectionView;
            rain_sectionView.cityid=self.cityid;
            [bgimg2 addSubview:rain_sectionView];
        }
        if (self.selectIndex==2) {
            gz_wr_pro_rankView *pro_rankView=[[gz_wr_pro_rankView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame)+5, CGRectGetWidth(bgimg2.frame), CGRectGetHeight(bgimg2.frame)-CGRectGetMaxY(self.segment.frame))];
            pro_rankView.backgroundColor=[UIColor clearColor];
            pro_rankView.YzhouType=YzhouTypeRain;
            self.pro_rankView=pro_rankView;
            if (self.rank_lists.count) {
                pro_rankView.rank_lists=self.rank_lists;
            }
            pro_rankView.delegate=self;
            pro_rankView.rank_list_time=self.rank_list_time;
            [bgimg2 addSubview:pro_rankView];
        }
        }
        
    }
    if (self.BtnTag==2) {
        if([self.wr_temp.is_auth isEqualToString:@"1"])
        {
            if (self.wr_temp.h_temp) {
                lianxuRain.text=[NSString stringWithFormat:@"高温:%@℃",self.wr_temp.h_temp];
            }
            if (self.wr_temp.l_temp) {
                lianxuRain1.text=[NSString stringWithFormat:@"低温:%@℃",self.wr_temp.l_temp];
            }
            if (self.wr_temp.d_temp) {
                zuijinRainTime.text=[NSString stringWithFormat:@"昼夜温差:%@℃",self.wr_temp.d_temp];
            }
            if (self.wr_temp.d_tip) {
                 kuozhantip.text=[NSString stringWithFormat:@"%@",self.wr_temp.d_tip];
            }
            
       
        
            [kuozhantip sizeToFit];
            CGRect bgimgF=bgimg.frame;
            bgimgF.size.height=CGRectGetMaxY(kuozhantip.frame)+5;
            bgimg.frame=bgimgF;
            
            CGRect bgimg2F=bgimg2.frame;
            bgimg2F.origin.y=CGRectGetMaxY(bgimg.frame)+5;
            bgimg2.frame=bgimg2F;
            
            CGRect  cellF=cell.frame;
            cellF.size.height=CGRectGetMaxY(bgimg2.frame)+5;
            cell.frame=cellF;
        if (self.selectIndex==0) {
            gz_wr_six_tendView *SixtendView=[[gz_wr_six_tendView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame)+5, CGRectGetWidth(bgimg2.frame), CGRectGetHeight(bgimg2.frame)-CGRectGetMaxY(self.segment.frame)+5)];
             SixtendView.YzhouType=YzhouTypeTemp;
            SixtendView.backgroundColor=[UIColor clearColor];
            if (self.wr_lists.count) {
                SixtendView.wr_lists=self.wr_lists;
            }
            self.SixtendView=SixtendView;
            [bgimg2 addSubview:SixtendView];
        }
        if (self.selectIndex==1) {//2016.12.27 新增高低温实况排行
            gz_wr_pro_rankView *pro_rankView=[[gz_wr_pro_rankView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame)+5, CGRectGetWidth(bgimg2.frame), CGRectGetHeight(bgimg2.frame)-CGRectGetMaxY(self.segment.frame)+5)];
            pro_rankView.YzhouType=YzhouTypeTemp;
            pro_rankView.tempType=tempTypeNormalHigt;
            pro_rankView.tempskType=YES; //判断为高低温实况More
            pro_rankView.backgroundColor=[UIColor clearColor];
            self.pro_rankView=pro_rankView;
            if (self.Hrank_lists.count) {
             pro_rankView.rank_lists=self.Hrank_lists1;
            }
            if (self.Hrank_lists.count) {
                pro_rankView.subrank_lists1=self.Hrank_lists1;
            }
            if (self.Lrank_lists.count) {
                pro_rankView.subrank_lists2=self.Lrank_lists1;
            }
            pro_rankView.HightTemperature=YES;//高低温实况排名View
            pro_rankView.delegate=self;
            pro_rankView.rank_list_time=self.rank_list_time3;
            pro_rankView.rank_list_time1=self.rank_list_time3;
            pro_rankView.rank_list_time2=self.rank_list_time4;
            [bgimg2 addSubview:pro_rankView];
        }
        if (self.selectIndex==2) {
            gz_wr_pro_rankView *pro_rankView=[[gz_wr_pro_rankView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame)+5, CGRectGetWidth(bgimg2.frame), CGRectGetHeight(bgimg2.frame)-CGRectGetMaxY(self.segment.frame)+5)];
            pro_rankView.backgroundColor=[UIColor clearColor];
            pro_rankView.YzhouType=YzhouTypeTemp;
            self.pro_rankView=pro_rankView;
            if (self.Hrank_lists.count) {
            pro_rankView.rank_lists=self.Hrank_lists;
            }
            if (self.Hrank_lists.count) {
                pro_rankView.subrank_lists1=self.Hrank_lists;
            }
            if (self.Lrank_lists.count) {
                pro_rankView.subrank_lists2=self.Lrank_lists;
            }
            pro_rankView.delegate=self;
            pro_rankView.HightTemperature=YES;//高低温排名View
            pro_rankView.rank_list_time=self.rank_list_time1;
            pro_rankView.rank_list_time1=self.rank_list_time1;
            pro_rankView.rank_list_time2=self.rank_list_time2;
            [bgimg2 addSubview:pro_rankView];
        }
        }
    }
    if (self.BtnTag==3) {
        if([self.gz_wind.is_auth isEqualToString:@"1"])
        {
            UIView *content1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bgimg.frame)*0.5, CGRectGetHeight(bgimg.frame)*0.5)];
            content1.backgroundColor=[UIColor clearColor];
            [bgimg addSubview:content1];
            [self setupWindViewWithContentView:content1 Image:@"旌旗.png" title:self.gz_wind.floor subtitle:@"地面物象"];
            
            UIView *content2=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(content1.frame), 0, CGRectGetWidth(bgimg.frame)*0.5, CGRectGetHeight(bgimg.frame)*0.5)];
            //            content2.backgroundColor=[UIColor redColor];
            [bgimg addSubview:content2];
            [self setupWindViewWithContentView:content2 Image:@"小波峰.png" title:self.gz_wind.water subtitle:@"水面物象"];
            
            UIView *content3=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(content1.frame), CGRectGetWidth(bgimg.frame)*0.5, CGRectGetHeight(bgimg.frame)*0.5)];
            //            content2.backgroundColor=[UIColor redColor];
            [bgimg addSubview:content3];
            [self setupWindViewWithContentView:content3 Image:@"平均浪高.png" title:self.gz_wind.avg_wave subtitle:@"平均浪高"];
          
            UIView *content4=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(content1.frame), CGRectGetMaxY(content2.frame), CGRectGetWidth(bgimg.frame)*0.5, CGRectGetHeight(bgimg.frame)*0.5)];
            //            content2.backgroundColor=[UIColor redColor];
            [bgimg addSubview:content4];
            [self setupWindViewWithContentView:content4 Image:@"最高浪高.png" title:self.gz_wind.h_wave subtitle:@"最高浪高"];
            UIView *hengxian=[[UIView alloc] initWithFrame:CGRectMake(0, bgimg.frame.size.height*0.5, bgimg.frame.size.width, 1)];
            hengxian.backgroundColor=[UIColor colorHelpWithRed:226 green:226 blue:226 alpha:1];
            [bgimg addSubview:hengxian];
            
            UIView *shuxian=[[UIView alloc] initWithFrame:CGRectMake(bgimg.frame.size.width*0.5, 0, 1, bgimg.frame.size.height)];
               shuxian.backgroundColor=[UIColor colorHelpWithRed:226 green:226 blue:226 alpha:1];
            [bgimg addSubview:shuxian];
            
        if (self.selectIndex==0) {
            gz_wr_six_tendView *SixtendView=[[gz_wr_six_tendView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame)+5, CGRectGetWidth(bgimg2.frame), CGRectGetHeight(bgimg2.frame)-CGRectGetMaxY(self.segment.frame)-5)];
            SixtendView.YzhouType=YzhouTypeWind;
            SixtendView.backgroundColor=[UIColor clearColor];
            if (self.wr_lists.count) {
            SixtendView.wr_lists=self.wr_lists;
            }
            self.SixtendView=SixtendView;
            [bgimg2 addSubview:SixtendView];
        }
        if (self.selectIndex==1) {
            gz_wr_pro_rankView *pro_rankView=[[gz_wr_pro_rankView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame)+5, CGRectGetWidth(bgimg2.frame), CGRectGetHeight(bgimg2.frame)-CGRectGetMaxY(self.segment.frame)-5)];
            pro_rankView.backgroundColor=[UIColor clearColor];
            pro_rankView.YzhouType=YzhouTypeWind;
            pro_rankView.WindType=WindTypeSK;
            self.pro_rankView=pro_rankView;
            if (self.gz_wr_pro_tru_lists.count) {
                pro_rankView.rank_lists=self.gz_wr_pro_tru_lists;
            }
            pro_rankView.delegate=self;
            pro_rankView.rank_list_time=self.rank_list_time;
            [bgimg2 addSubview:pro_rankView];
        }
        if (self.selectIndex==2) {
            gz_wr_pro_rankView *pro_rankView=[[gz_wr_pro_rankView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame)+5, CGRectGetWidth(bgimg2.frame), CGRectGetHeight(bgimg2.frame)-CGRectGetMaxY(self.segment.frame)-5)];
            pro_rankView.backgroundColor=[UIColor clearColor];
            pro_rankView.YzhouType=YzhouTypeWind;
            pro_rankView.WindType=WindTypeSKNormal;
            self.pro_rankView=pro_rankView;
            if (self.gz_wr_pro_rank_lists.count) {
                pro_rankView.rank_lists=self.gz_wr_pro_rank_lists;
            }
            pro_rankView.delegate=self;
            pro_rankView.rank_list_time=self.rank_list_time1;
            [bgimg2 addSubview:pro_rankView];
        }
        }
    }
    self.cellheight=bgimg.frame.size.height+bgimg2.frame.size.height;
}
//用来创建风况4个View
-(UIView *)setupWindViewWithContentView:(UIView *)content Image:(NSString *)imageName title:(NSString *)title subtitle:(NSString *)subtitle
{
    UIImageView *icon1=[[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
    icon1.image=[UIImage imageNamed:imageName];
    [content addSubview:icon1];
    UILabel *left1Label1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon1.frame)+5, 5, CGRectGetWidth(content.frame)-CGRectGetMaxX(icon1.frame)-8, (CGRectGetHeight(content.frame)-10)*0.5)];
    if (title) {
          left1Label1.text=title;
    }
  
//                left1Label1.backgroundColor=[UIColor redColor];
    left1Label1.font=[UIFont systemFontOfSize:14];
    left1Label1.textAlignment=NSTextAlignmentRight;
    [content addSubview:left1Label1];
    UILabel *left2Label1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon1.frame)+5, CGRectGetMaxY(left1Label1.frame), CGRectGetWidth(content.frame)-CGRectGetMaxX(icon1.frame)-8, (CGRectGetHeight(content.frame)-10)*0.5)];
    left2Label1.text=subtitle;
    left2Label1.textAlignment=NSTextAlignmentRight;
    //               left2Label.backgroundColor=[UIColor redColor];
    left2Label1.font=[UIFont systemFontOfSize:12];
    left2Label1.textColor=[UIColor colorHelpWithRed:116 green:174 blue:223 alpha:1];
    [content addSubview:left2Label1];
    return content;
}
-(void)setRow_1_WithImageView:(UIImageView *)bgimg andCell:(UITableViewCell *)cell
{
    UILabel *jiezhiTimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
    jiezhiTimeLabel.textColor=[UIColor blackColor];
    //        jiezhiTimeLabel.backgroundColor=[UIColor redColor];
    jiezhiTimeLabel.font=[UIFont systemFontOfSize:15];
    [bgimg addSubview:jiezhiTimeLabel];
    UILabel *youyumeiyu=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(jiezhiTimeLabel.frame), 200, CGRectGetHeight(bgimg.frame)-CGRectGetMaxY(jiezhiTimeLabel.frame))];
    youyumeiyu.textColor=[UIColor blackColor];
    //        youyumeiyu.backgroundColor=[UIColor redColor];
    youyumeiyu.font=[UIFont systemFontOfSize:25];
    [bgimg addSubview:youyumeiyu];
    
    UIImageView *xiayuImage=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgimg.frame)-75, 5, 50, 50)];
    [bgimg addSubview:xiayuImage];
    if (self.BtnTag==1) {
        if(self.gz_wr.ctime){
        jiezhiTimeLabel.text=self.gz_wr.ctime;
        }
        if (self.gz_wr.is_rain_des) {
        youyumeiyu.text=self.gz_wr.is_rain_des;
        }

        if(self.gz_wr.is_rain.intValue>0)
        {
            [xiayuImage setImage:[UIImage imageNamed:@"伞 张开.png"]];
        }else{
            [xiayuImage setImage:[UIImage imageNamed:@"伞 闭合.png"]];
        }
    }
    if (self.BtnTag==2) {
        if (self.wr_temp.upd_time) {
            jiezhiTimeLabel.text=[NSString stringWithFormat:@"更新时间:%@",self.wr_temp.upd_time];
        }
        if (self.wr_temp.temp) {
            youyumeiyu.text=[NSString stringWithFormat:@"  %@℃",self.wr_temp.temp];
        }
        
        [xiayuImage setImage:[UIImage imageNamed:@"温度计.png"]];
    }
    if (self.BtnTag==3) {
        if (self.gz_wind.w_speed) {
             jiezhiTimeLabel.text=[NSString stringWithFormat:@"风速:%@km/h",self.gz_wind.w_speed];
        }
        jiezhiTimeLabel.font=[UIFont systemFontOfSize:15];
        jiezhiTimeLabel.frame=CGRectMake(20, 5, 100, (CGRectGetHeight(bgimg.frame)-10)/3);
        UILabel *fengxiang=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(jiezhiTimeLabel.frame)+5, 200, (CGRectGetHeight(bgimg.frame)-10)/3)];
        fengxiang.textColor=[UIColor blackColor];
        //        youyumeiyu.backgroundColor=[UIColor redColor];
        fengxiang.font=[UIFont systemFontOfSize:15];
        if (self.gz_wind.w_direct) {
       fengxiang.text=[NSString stringWithFormat:@"风向:%@",self.gz_wind.w_direct];
        }
     
        [bgimg addSubview:fengxiang];
        UILabel *fengli=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(fengxiang.frame)+5, 200, (CGRectGetHeight(bgimg.frame)-10)/3)];
        fengli.textColor=[UIColor blackColor];
        //        youyumeiyu.backgroundColor=[UIColor redColor];
        fengli.font=[UIFont systemFontOfSize:15];
        if(self.gz_wind.w_lev)
        {
        fengli.text=[NSString stringWithFormat:@"风力等级:%@",self.gz_wind.w_lev];
        }
        [bgimg addSubview:fengli];
        [xiayuImage setImage:[UIImage imageNamed:@"风车.png"]];
        
        CGRect bgimgF=bgimg.frame;
        bgimgF.size.height=CGRectGetMaxY(fengli.frame)+5;
        bgimg.frame=bgimgF;
        CGRect  cellF=cell.frame;
        cellF.size.height=bgimg.frame.size.height;
        cell.frame=cellF;
        xiayuImage.frame=CGRectMake(CGRectGetWidth(bgimg.frame)-75, (CGRectGetHeight(bgimg.frame)-50)/2, 50, 50);
    }
}
//segment点击
-(void)segementClick:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 1:
            [self.SixtendView removeFromSuperview];
            [self.pro_rankView removeFromSuperview];
            self.selectIndex=1;
            [self.tableView reloadData];
            break;
        case 2:
           [self.SixtendView removeFromSuperview];
            [self.rain_sectionView removeFromSuperview];
            self.selectIndex=2;
            [self.tableView reloadData];
            break;
            
        default:
            [self.rain_sectionView removeFromSuperview];
            [self.pro_rankView removeFromSuperview];
            self.selectIndex=0;
            [self.tableView reloadData];
            break;
    }

}
-(void)btnAction:(UIButton*)sender{
    NSInteger tag=sender.tag;
    self.BtnTag=sender.tag;
    self.btntag=tag;
    self.btnlineimg.frame=CGRectMake(tag*(kScreenWidth/4), 35+self.barHeight, kScreenWidth/4, 2);
    
    if (tag==0) {
        self.rankname=self.ranknames[0];
        self.selectIndex1=0;
        self.ranktag=1;
        [self getgz_wr_rankwithtype:@"1"];
    }else{
        
    }
    if (tag==1) {
        [self btnclick1];
    }
    if(tag==2)
    {
        [self btnclick2];
    }
    if(tag==3)
    {
        [self btnclick3];
    }
}
-(void)btnclick3//风况
{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary *gz_wr_wind1 = [[NSMutableDictionary alloc] init];
    [b setObject:gz_wr_wind1 forKey:@"gz_wr_wind"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [gz_wr_wind1 setObject:self.cityid.length>0 ? self.cityid:[setting sharedSetting].currentCityID forKey:@"county_id"];
    if (self.userid.length>0) {
        [gz_wr_wind1 setObject:self.userid forKey:@"user_id"];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:0 withSuccess:^(NSDictionary *returnData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //                NSLog(@"%@",returnData);
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *gz_wr_wind1=[b objectForKey:@"gz_wr_wind"];
        gz_wr_wind *gz_wind=[gz_wr_wind mj_objectWithKeyValues:gz_wr_wind1];
        self.gz_wind=gz_wind;
        if ([gz_wind.is_auth isEqualToString:@"1"]) {
            
            NSMutableDictionary * param1 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * h1 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * b1 = [[NSMutableDictionary alloc] init];
            [h1 setObject:[setting sharedSetting].app forKey:@"p"];
            NSMutableDictionary *gz_wr_six_tend = [[NSMutableDictionary alloc] init];
            [b1 setObject:gz_wr_six_tend forKey:@"gz_wr_six_tend"];
            [param1 setObject:h1 forKey:@"h"];
            [param1 setObject:b1 forKey:@"b"];
            [gz_wr_six_tend setObject:@"2" forKey:@"type"];
            [gz_wr_six_tend setObject:self.cityid.length>0 ? self.cityid:[setting sharedSetting].currentCityID forKey:@"county_id"];
            
            [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param1 withFlag:0 withSuccess:^(NSDictionary *returnData) {
                
                
                NSDictionary * b = [returnData objectForKey:@"b"];
                NSDictionary *wr_list_Dict=[b objectForKey:@"gz_wr_six_tend"];
                NSArray *wr_list_array=[wr_list_Dict objectForKey:@"wr_list"];
                NSArray *wr_lists=[wr_list mj_objectArrayWithKeyValuesArray:wr_list_array];
                for (wr_list *wr_list1 in wr_lists) {
                    wr_list1.type=@"2";
                }
                self.wr_lists=wr_lists;
                
                [self.tableView reloadData];
            } withFailure:^(NSError *error) {
                
            } withCache:YES];
                //风雨查询-全省实况天气排行3.0.3(gz_wr_pro_tru_rank)
            NSMutableDictionary * param2 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * h2 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * b2 = [[NSMutableDictionary alloc] init];
            [h2 setObject:[setting sharedSetting].app forKey:@"p"];
            NSMutableDictionary *gz_wr_pro_tru_rank = [[NSMutableDictionary alloc] init];
            [b2 setObject:gz_wr_pro_tru_rank forKey:@"gz_wr_pro_tru_rank"];
            [param2 setObject:h2 forKey:@"h"];
            [param2 setObject:b2 forKey:@"b"];
            [gz_wr_pro_tru_rank setObject:@"2" forKey:@"type"];
            //            NSString *new1=[self getProviceIDWithcityID:[setting sharedSetting].currentCityID];
            [gz_wr_pro_tru_rank setObject:self.proid forKey:@"pro_id"];
            
            [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param2 withFlag:0 withSuccess:^(NSDictionary *returnData) {
                
                
                NSDictionary * b3 = [returnData objectForKey:@"b"];
                NSDictionary *gz_wr_pro_tru_rank=[b3 objectForKey:@"gz_wr_pro_tru_rank"];
                NSArray *rank_list1=[gz_wr_pro_tru_rank objectForKey:@"rank_list"];
                NSString *rank_list_time=[gz_wr_pro_tru_rank objectForKey:@"time"];
                self.rank_list_time=rank_list_time;
                NSArray *rank_lists=[rank_list mj_objectArrayWithKeyValuesArray:rank_list1];
                for (rank_list *rank in rank_lists) {
                    rank.type=@"3";
                    rank.sk_type=@"2";
                    rank.proid=self.proid;
                }
                self.gz_wr_pro_tru_lists=rank_lists;
                [self.tableView reloadData];
            } withFailure:^(NSError *error) {
                
            } withCache:YES];

            
            //风况   风雨查询-全省天气排行3.0.3(gz_wr_pro_rank)
            NSMutableDictionary * param3 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * h3 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * b3 = [[NSMutableDictionary alloc] init];
            [h3 setObject:[setting sharedSetting].app forKey:@"p"];
            NSMutableDictionary *gz_wr_pro_rank = [[NSMutableDictionary alloc] init];
            [b3 setObject:gz_wr_pro_rank forKey:@"gz_wr_pro_rank"];
            [param3 setObject:h3 forKey:@"h"];
            [param3 setObject:b3 forKey:@"b"];
            [gz_wr_pro_rank setObject:@"4" forKey:@"type"];
            //            NSString *new1=[self getProviceIDWithcityID:[setting sharedSetting].currentCityID];
            [gz_wr_pro_rank setObject:self.proid forKey:@"pro_id"];
            
            [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param3 withFlag:0 withSuccess:^(NSDictionary *returnData) {
                
                
                NSDictionary * b4 = [returnData objectForKey:@"b"];
                NSDictionary *gz_wr_pro_rank=[b4 objectForKey:@"gz_wr_pro_rank"];
                NSArray *rank_list1=[gz_wr_pro_rank objectForKey:@"rank_list"];
                NSString *rank_list_time=[gz_wr_pro_rank objectForKey:@"time"];
                self.rank_list_time1=rank_list_time;
                NSArray *rank_lists=[rank_list mj_objectArrayWithKeyValuesArray:rank_list1];
                for (rank_list *rank in rank_lists) {
                    rank.type=@"3";
                    rank.pro_type=@"4";
                    rank.proid=self.proid;
                }
                self.gz_wr_pro_rank_lists=rank_lists;
                [self.tableView reloadData];
            } withFailure:^(NSError *error) {
                
            } withCache:YES];

        }
        
        [self.tableView reloadData];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withCache:YES];
    

}
-(void)btnclick2  //气温
{
    
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary *gz_wr_temp1 = [[NSMutableDictionary alloc] init];
    [b setObject:gz_wr_temp1 forKey:@"gz_wr_temp"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [gz_wr_temp1 setObject:self.cityid.length>0 ? self.cityid:[setting sharedSetting].currentCityID forKey:@"county_id"];
    if (self.userid.length>0) {
        [gz_wr_temp1 setObject:self.userid forKey:@"user_id"];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:0 withSuccess:^(NSDictionary *returnData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //                NSLog(@"%@",returnData);
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *gzwrtemp=[b objectForKey:@"gz_wr_temp"];
        gz_wr_temp *wr_temp=[gz_wr_temp mj_objectWithKeyValues:gzwrtemp];
        self.wr_temp=wr_temp;
        if ([wr_temp.is_auth isEqualToString:@"1"]) {
              //气温  6天走势
            NSMutableDictionary * param1 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * h1 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * b1 = [[NSMutableDictionary alloc] init];
            [h1 setObject:[setting sharedSetting].app forKey:@"p"];
            NSMutableDictionary *gz_wr_six_temp_tend = [[NSMutableDictionary alloc] init];
            [b1 setObject:gz_wr_six_temp_tend forKey:@"gz_wr_six_temp_tend"];
            [param1 setObject:h1 forKey:@"h"];
            [param1 setObject:b1 forKey:@"b"];
            [gz_wr_six_temp_tend setObject:self.cityid.length>0 ? self.cityid:[setting sharedSetting].currentCityID forKey:@"county_id"];
            
            [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param1 withFlag:0 withSuccess:^(NSDictionary *returnData) {
                NSDictionary * b = [returnData objectForKey:@"b"];
                NSDictionary *gz_wr_six_temp_tend=[b objectForKey:@"gz_wr_six_temp_tend"];
                NSArray *wr_list_array=[gz_wr_six_temp_tend objectForKey:@"wr_list"];
                NSArray *wr_lists=[wr_list mj_objectArrayWithKeyValuesArray:wr_list_array];
                self.wr_lists=wr_lists;
                [self.tableView reloadData];
            } withFailure:^(NSError *error) {
                
            } withCache:YES];
            //气温  全省实况高温
            NSMutableDictionary * param2 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * h2 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * b2 = [[NSMutableDictionary alloc] init];
            [h2 setObject:[setting sharedSetting].app forKey:@"p"];
            NSMutableDictionary *gz_wr_pro_tru_rank = [[NSMutableDictionary alloc] init];
            [b2 setObject:gz_wr_pro_tru_rank forKey:@"gz_wr_pro_tru_rank"];
            [param2 setObject:h2 forKey:@"h"];
            [param2 setObject:b2 forKey:@"b"];
            [gz_wr_pro_tru_rank setObject:@"1" forKey:@"type"];
            //            NSString *new1=[self getProviceIDWithcityID:[setting sharedSetting].currentCityID];
            [gz_wr_pro_tru_rank setObject:self.proid forKey:@"pro_id"];
            
            [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param2 withFlag:0 withSuccess:^(NSDictionary *returnData) {
                
                
                NSDictionary * b3 = [returnData objectForKey:@"b"];
                NSDictionary *gz_wr_pro_tru_rank=[b3 objectForKey:@"gz_wr_pro_tru_rank"];
                NSArray *rank_list1=[gz_wr_pro_tru_rank objectForKey:@"rank_list"];
                NSString *rank_list_time=[gz_wr_pro_tru_rank objectForKey:@"time"];
                self.rank_list_time3=rank_list_time;
                NSArray *rank_lists=[rank_list mj_objectArrayWithKeyValuesArray:rank_list1];
                for (rank_list *rank in rank_lists) {
                    rank.type=@"2";
                    rank.sk_type=@"1";
                    rank.proid=self.proid;
                }
                self.Hrank_lists1=rank_lists;
                [self.tableView reloadData];
            } withFailure:^(NSError *error) {
                
            } withCache:YES];
            //气温  全省实况低温
            NSMutableDictionary * param5 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * h5 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * b5 = [[NSMutableDictionary alloc] init];
            [h5 setObject:[setting sharedSetting].app forKey:@"p"];
            NSMutableDictionary *gz_wr_pro_tru_rank5 = [[NSMutableDictionary alloc] init];
            [b5 setObject:gz_wr_pro_tru_rank5 forKey:@"gz_wr_pro_tru_rank"];
            [param5 setObject:h5 forKey:@"h"];
            [param5 setObject:b5 forKey:@"b"];
            [gz_wr_pro_tru_rank5 setObject:@"3" forKey:@"type"];
            //            NSString *new1=[self getProviceIDWithcityID:[setting sharedSetting].currentCityID];
            [gz_wr_pro_tru_rank5 setObject:self.proid forKey:@"pro_id"];
            
            [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param5 withFlag:0 withSuccess:^(NSDictionary *returnData) {
                
                
                NSDictionary * b6 = [returnData objectForKey:@"b"];
                NSDictionary *gz_wr_pro_tru_rank6=[b6 objectForKey:@"gz_wr_pro_tru_rank"];
                NSArray *rank_list2=[gz_wr_pro_tru_rank6 objectForKey:@"rank_list"];
                NSString *rank_list_time6=[gz_wr_pro_tru_rank6 objectForKey:@"time"];
                self.rank_list_time4=rank_list_time6;
                NSArray *rank_lists6=[rank_list mj_objectArrayWithKeyValuesArray:rank_list2];
                for (rank_list *rank in rank_lists6) {
                    rank.type=@"2";
                    rank.sk_type=@"3";
                    rank.proid=self.proid;
                }
                self.Lrank_lists1=rank_lists6;
                [self.tableView reloadData];
            } withFailure:^(NSError *error) {
                
            } withCache:YES];
            //气温  全省高低温排名 高温
            NSMutableDictionary * param3 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * h3 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * b3 = [[NSMutableDictionary alloc] init];
            [h3 setObject:[setting sharedSetting].app forKey:@"p"];
            NSMutableDictionary *gz_wr_pro_rank = [[NSMutableDictionary alloc] init];
            [b3 setObject:gz_wr_pro_rank forKey:@"gz_wr_pro_rank"];
            [param3 setObject:h3 forKey:@"h"];
            [param3 setObject:b3 forKey:@"b"];
            [gz_wr_pro_rank setObject:@"2" forKey:@"type"];
            //            NSString *new1=[self getProviceIDWithcityID:[setting sharedSetting].currentCityID];
            [gz_wr_pro_rank setObject:self.proid forKey:@"pro_id"];
            
            [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param3 withFlag:0 withSuccess:^(NSDictionary *returnData) {
                
                
                NSDictionary * b4 = [returnData objectForKey:@"b"];
                NSDictionary *gz_wr_pro_rank=[b4 objectForKey:@"gz_wr_pro_rank"];
                NSArray *rank_list1=[gz_wr_pro_rank objectForKey:@"rank_list"];
                NSString *rank_list_time=[gz_wr_pro_rank objectForKey:@"time"];
                self.rank_list_time1=rank_list_time;
                NSArray *rank_lists=[rank_list mj_objectArrayWithKeyValuesArray:rank_list1];
                for (rank_list *rank in rank_lists) {
                    rank.type=@"2";
                    rank.TempType=@"1";
                    rank.pro_type=@"2";
                    rank.proid=self.proid;
                }
                self.Hrank_lists=rank_lists;
                [self.tableView reloadData];
            } withFailure:^(NSError *error) {
                
            } withCache:YES];

               //气温  全省高低温排名 低温
            NSMutableDictionary * param4 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * h4 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * b4 = [[NSMutableDictionary alloc] init];
            [h4 setObject:[setting sharedSetting].app forKey:@"p"];
            NSMutableDictionary *gz_wr_pro_rank1 = [[NSMutableDictionary alloc] init];
            [b4 setObject:gz_wr_pro_rank1 forKey:@"gz_wr_pro_rank"];
            [param4 setObject:h4 forKey:@"h"];
            [param4 setObject:b4 forKey:@"b"];
            [gz_wr_pro_rank1 setObject:@"3" forKey:@"type"];
            //            NSString *new1=[self getProviceIDWithcityID:[setting sharedSetting].currentCityID];
            [gz_wr_pro_rank1 setObject:self.proid forKey:@"pro_id"];
            
            [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param4 withFlag:0 withSuccess:^(NSDictionary *returnData) {
                
                
                NSDictionary * b5 = [returnData objectForKey:@"b"];
                NSDictionary *gz_wr_pro_rank=[b5 objectForKey:@"gz_wr_pro_rank"];
                NSArray *rank_list1=[gz_wr_pro_rank objectForKey:@"rank_list"];
                NSString *rank_list_time=[gz_wr_pro_rank objectForKey:@"time"];
                self.rank_list_time2=rank_list_time;
                NSArray *rank_lists=[rank_list mj_objectArrayWithKeyValuesArray:rank_list1];
                for (rank_list *rank in rank_lists) {
                    rank.type=@"2";
                    rank.TempType=@"2";
                    rank.pro_type=@"3";
                    rank.proid=self.proid;
                }
                self.Lrank_lists=rank_lists;
                [self.tableView reloadData];
            } withFailure:^(NSError *error) {
                
            } withCache:YES];

            
        }
        [self.tableView reloadData];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withCache:YES];


}
-(void)btnclick1 //降雨
{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary *gz_wr_rain1 = [[NSMutableDictionary alloc] init];
    [b setObject:gz_wr_rain1 forKey:@"gz_wr_rain"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [gz_wr_rain1 setObject:self.cityid.length>0 ? self.cityid:[setting sharedSetting].currentCityID forKey:@"county_id"];
    if (self.userid.length>0) {
         [gz_wr_rain1 setObject:self.userid forKey:@"user_id"];
    }
  
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:0 withSuccess:^(NSDictionary *returnData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //                NSLog(@"%@",returnData);
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *gzwrrain=[b objectForKey:@"gz_wr_rain"];
        gz_wr_rain *gzwr=[gz_wr_rain mj_objectWithKeyValues:gzwrrain];
        self.gz_wr=gzwr;
        [self.tableView reloadData];
        if ([gzwr.is_auth isEqualToString:@"1"]) {
            
            NSMutableDictionary * param1 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * h1 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * b1 = [[NSMutableDictionary alloc] init];
            [h1 setObject:[setting sharedSetting].app forKey:@"p"];
            NSMutableDictionary *gz_wr_six_tend = [[NSMutableDictionary alloc] init];
            [b1 setObject:gz_wr_six_tend forKey:@"gz_wr_six_tend"];
            [param1 setObject:h1 forKey:@"h"];
            [param1 setObject:b1 forKey:@"b"];
            [gz_wr_six_tend setObject:@"1" forKey:@"type"];
            [gz_wr_six_tend setObject:self.cityid.length>0 ? self.cityid:[setting sharedSetting].currentCityID forKey:@"county_id"];
          
            [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param1 withFlag:0 withSuccess:^(NSDictionary *returnData) {
              
                
                NSDictionary * b = [returnData objectForKey:@"b"];
                NSDictionary *wr_list_Dict=[b objectForKey:@"gz_wr_six_tend"];
                NSArray *wr_list_array=[wr_list_Dict objectForKey:@"wr_list"];
                NSArray *wr_lists=[wr_list mj_objectArrayWithKeyValuesArray:wr_list_array];
                for (wr_list *wr_list1 in wr_lists) {
                    wr_list1.type=@"1";
                }
                self.wr_lists=wr_lists;
                [self.tableView reloadData];
            } withFailure:^(NSError *error) {
         
            } withCache:YES];
        
            NSMutableDictionary * param2 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * h2 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * b2 = [[NSMutableDictionary alloc] init];
            [h2 setObject:[setting sharedSetting].app forKey:@"p"];
            NSMutableDictionary *gz_wr_pro_rank = [[NSMutableDictionary alloc] init];
            [b2 setObject:gz_wr_pro_rank forKey:@"gz_wr_pro_rank"];
            [param2 setObject:h2 forKey:@"h"];
            [param2 setObject:b2 forKey:@"b"];
            [gz_wr_pro_rank setObject:@"1" forKey:@"type"];
//            NSString *new1=[self getProviceIDWithcityID:[setting sharedSetting].currentCityID];
            [gz_wr_pro_rank setObject:self.proid forKey:@"pro_id"];
            
            [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param2 withFlag:0 withSuccess:^(NSDictionary *returnData) {
                
                
                NSDictionary * b3 = [returnData objectForKey:@"b"];
                NSDictionary *gz_wr_pro_rank=[b3 objectForKey:@"gz_wr_pro_rank"];
                NSArray *rank_list1=[gz_wr_pro_rank objectForKey:@"rank_list"];
                  NSString *rank_list_time=[gz_wr_pro_rank objectForKey:@"time"];
                self.rank_list_time=rank_list_time;
                NSArray *rank_lists=[rank_list mj_objectArrayWithKeyValuesArray:rank_list1];
                for (rank_list *rank in rank_lists) {
                    rank.type=@"1";
                    rank.pro_type=@"1";
                    rank.proid=self.proid;
                }
                self.rank_lists=rank_lists;
                [self.tableView reloadData];
            } withFailure:^(NSError *error) {
                
            } withCache:YES];
        }
        
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withCache:YES];
    
}
-(void)addcity{
    SelectCityViewController *select=[[SelectCityViewController alloc]init];
    [select setDataSource: m_treeNodeProvince withCitys:m_treeNodeAllCity];
    select.type=@"风雨";
    [select setDelegate:self];
    [self.navigationController pushViewController:select animated:YES];
}
#pragma mark 登录
-(void)lgAction{
    self.isothertype=YES;
    LGViewController *lgvc=[[LGViewController alloc]init];
    lgvc.type=@"风雨";
    [self.navigationController pushViewController:lgvc animated:YES];
}
#pragma mark 开通
-(void)openAction{
    self.isothertype=YES;
    WRPayViewController *wrpayvc=[[WRPayViewController alloc]init];
    wrpayvc.userid=self.userid;
    wrpayvc.type=@"1";
    [self.navigationController pushViewController:wrpayvc animated:YES];
}
#pragma mark 获取排行
-(void)getgz_wr_rankwithtype:(NSString *)type{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:type forKey:@"type"];
    [b setObject:gz_todaywt_inde forKey:@"gz_wr_rank"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *gz_wr_rank=[b objectForKey:@"gz_wr_rank"];
            self.ranks=[gz_wr_rank objectForKey:@"wt_rank_list"];
            self.ranktime=[gz_wr_rank objectForKey:@"time"];
            [self.tableView reloadData];
            
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)rankAction{
    TFSheet *tfsheet=[[TFSheet alloc] initWithHeight:250 WithSheetTitle:@""
                                         withLeftBtn:@"返回" withRightBtn:@"确认"];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 216)];
    if (kSystemVersionMore7) {
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth, 155)];
    }
    pickerView.dataSource = self;
    pickerView.delegate=self;
    pickerView.showsSelectionIndicator=YES;
    mypickerview=pickerView;
    [tfsheet.sheetBgView addSubview:pickerView];
    [tfsheet setDelegate:self];
    [tfsheet show];
}
#pragma mark 我的服务
-(void)myserverAction{
    MyWRserverViewController *myser=[[MyWRserverViewController alloc]init];
    [self.navigationController pushViewController:myser animated:YES];
}
-(void)doneBtnClicked{
    NSInteger row=[mypickerview selectedRowInComponent:0];
    self.rankname=self.ranknames[row];
    self.ranktag=row+1;
    NSString *type=[NSString stringWithFormat:@"%d",row+1];
    [self getgz_wr_rankwithtype:type];
}
-(void)wrBanerbuttonClick:(int)vid{
    if (self.adurls.count>0) {
        NSString *ysurl=self.adurls[vid-1];
        if (ysurl.length>0) {
            WebViewController *webvc=[[WebViewController alloc]init];
            webvc.url=ysurl;
            webvc.titleString=self.adurls[vid-1];
            [self.navigationController pushViewController:webvc animated:YES];
        }
        
    }
}
#pragma mark Picker Date Source Methods
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return self.ranknames.count;
}

#pragma mark Picker Delegate Methods
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
        return [self.ranknames objectAtIndex:row];
    
}
-(void)userButAction{
    
}
-(void)getAdBanenerScro{
    self.adimgurls=[[NSMutableArray alloc]init];
    self.adtitles=[[NSMutableArray alloc]init];
    self.adurls=[[NSMutableArray alloc]init];
    
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:@"16" forKey:@"position_id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_ad"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            [self.adimgurls removeAllObjects];
            [self.adtitles removeAllObjects];
            [self.adurls removeAllObjects];
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];
            for (int i=0; i<adlist.count; i++) {
                NSString *url=[adlist[i] objectForKey:@"url"];
                NSString *title=[adlist[i] objectForKey:@"title"];
                NSString *imgurl=[adlist[i] objectForKey:@"img_path"];
                [self.adurls addObject:url];
                [self.adtitles addObject:title];
                [self.adimgurls addObject:imgurl];
            }
            
//            [self.tableView reloadData];
        }
        
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"failure");
    } withCache:YES];
}
#pragma mark gz_wr_pro_rankViewDelegate  更多点击
-(void)gz_wr_pro_rankView:(gz_wr_pro_rankView *)gz_wr_pro_rankView WithRank_lists:(NSArray *)rank_lists andrank_list_time:(NSString *)rank_list_time
{
   gz_wr_more_rankViewController *gz_wr_more_rankVC=[[gz_wr_more_rankViewController alloc] init];
    if (rank_lists.count) {
    gz_wr_more_rankVC.rank_lists=rank_lists;
    }
    gz_wr_more_rankVC.titleType=gz_wr_pro_rankView.YzhouType;
    if (gz_wr_pro_rankView.YzhouType==YzhouTypeTemp) {
        gz_wr_more_rankVC.tempType=gz_wr_pro_rankView.tempType;
    }
    if (gz_wr_pro_rankView.YzhouType==YzhouTypeWind) {
        gz_wr_more_rankVC.WindType=gz_wr_pro_rankView.WindType;
    }
    gz_wr_more_rankVC.rank_list_time=rank_list_time;
    [self.navigationController pushViewController:gz_wr_more_rankVC animated:YES];
}
-(void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
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
