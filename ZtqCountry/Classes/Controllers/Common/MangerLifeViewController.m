//
//  MangerLifeViewController.m
//  ZtqCountry
//
//  Created by Admin on 14-10-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "MangerLifeViewController.h"
#import "QualityOfLifeView.h"
#import "EGOImageView.h"
@interface MangerLifeViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) UITableView * tableView;


@end

@implementation MangerLifeViewController

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
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    self.navigationController.navigationBarHidden = YES;
    //    self.title = @"推送设置";
    float place = 0;
    if(kSystemVersionMore7)
    {
        place = 20;
    }
    self.barHeight = 44+ place;
    _navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    _navigationBarBg.userInteractionEnabled = YES;
    //    _navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:27 green:92 blue:189 alpha:1];
    _navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:_navigationBarBg];
    
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [_navigationBarBg addSubview:leftimg];
    
    
    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    //    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(15, 7+place, 30, 30)];
    //    [_leftBut setBackgroundImage:[UIImage imageNamed:@"jc返回.png"] forState:UIControlStateNormal];
    //    [_leftBut setBackgroundImage:[UIImage imageNamed:@"jc返回点击.png"] forState:UIControlStateHighlighted];
    //    [_leftBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    [_leftBut setTitle:@"back" forState:UIControlStateNormal];
    [_leftBut addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 12+place, kScreenWidth-120, 20)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.text=@"更多";
    _titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor whiteColor];
    [_navigationBarBg addSubview:_titleLab];
//        self.barHiden=NO;
//        self.titleLab.text=@"更多";
//        [self.leftBut addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.barHeight,kScreenWidth,kScreenHeitht-self.barHeight)  style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.autoresizesSubviews = YES;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //    for (int i=0; i<[self.arr count]; i++) {
    //        self.xzimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-50, 5+i*50, 25, 25)];
    //        self.xzimg.image=[UIImage imageNamed:@"xuanz_06"];
    //        self.xzimg.tag=i;
    //
    //        [_tableView addSubview:self.xzimg];
    //    }
    
}
-(void)leftClick{
    NSMutableDictionary * allLifeDic =[[NSMutableDictionary alloc] initWithDictionary:[setting sharedSetting].lifedic];
    NSMutableArray * lifeArr = [[NSMutableArray alloc] init];
    if (self.arr.count<4) {
        for(int i=0;i<self.arr.count;i++)
        {
            NSDictionary * lifeInfo = [self.arr objectAtIndex:i];
            BOOL state = [[lifeInfo objectForKey:@"state"] intValue];
            NSString * lifeName = [lifeInfo objectForKey:@"name"];
            
            [lifeArr addObject:lifeName];
            
        }
        [allLifeDic setValue:lifeArr forKey:@"life"];
        [setting sharedSetting].lifedic = allLifeDic;
        [[setting sharedSetting] saveSetting];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addlife" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        for(int i=0;i<self.arr.count;i++)
        {
            NSDictionary * lifeInfo = [self.arr objectAtIndex:i];
            BOOL state = [[lifeInfo objectForKey:@"state"] intValue];
            NSString * lifeName = [lifeInfo objectForKey:@"name"];
            if(state)
            {
                [lifeArr addObject:lifeName];
            }
        }
//        if (lifeArr.count<4) {
//            UIAlertView *alret=[[UIAlertView alloc]initWithTitle:@"知天气" message:@"亲~至少要选择四项哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
//            //        return;
//            [alret show];
////            return;
//            
//        }else{
            [allLifeDic setValue:lifeArr forKey:@"life"];
            [setting sharedSetting].lifedic = allLifeDic;
            [[setting sharedSetting] saveSetting];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addlife" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCity" object:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    NSString *t_str = [NSString stringWithFormat:@"%d_%d",section,row];
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:t_str];
    NSDictionary * info = self.arr[indexPath.row];
    NSString *name=[info objectForKey:@"name"];
    NSString *lifeimg=[info objectForKey:@"img"];
    //    NSString *imgname=[info objectForKey:@""];
    self.name=name;
    if (cell == nil)
    {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str] ;
        UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 200, 40)];
        t_label.text = [NSString stringWithFormat:@"%@指数",name];
        t_label.backgroundColor = [UIColor clearColor];
        t_label.textColor = [UIColor blackColor];
        t_label.font = [UIFont systemFontOfSize:16];
        t_label.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:t_label];
        
        
        //网络图片
        EGOImageView *cellimg1=[[EGOImageView alloc]initWithFrame:CGRectMake(15, 10, 30, 30)];
        [cellimg1 setImageURL:[ShareFun makeImageUrl:lifeimg]];
        [cell.contentView addSubview:cellimg1];
        //本地图片
        //        UIImageView *cellimg1=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        //        cellimg1.image=[UIImage imageNamed:[NSString stringWithFormat:@"b%@",lifeimg]];
        //        [cell.contentView addSubview:cellimg1];
        
        UIImageView * xzimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-50, 12.5, 25, 25)];
        xzimg.image=[UIImage imageNamed:@"非勾选状态"];
        xzimg.tag=20;
        [cell.contentView addSubview:xzimg];
        
        
        
    }
    UIImageView *xzimg =(UIImageView *)[cell.contentView viewWithTag:20];
    if (self.arr.count<4) {
        xzimg.image = [UIImage imageNamed:@"勾选状态"];
    }else{
        
        BOOL num=[[info objectForKey:@"state"]boolValue];
        if(num)
        {
            xzimg.image = [UIImage imageNamed:@"勾选状态"];
        }else{
            xzimg.image = [UIImage imageNamed:@"非勾选状态"];
        }
        
    }
    UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"城市列表分隔线.png"]];
    [m_image setFrame:CGRectMake(10, 49, kScreenWidth-20, 1)];
    [cell addSubview:m_image];
    return cell;
}
//-(void)btnClick:(id)sender{
//    NSUInteger tag = [sender tag];
//
//}

- (void)deselect
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
    
    //    for (int i=0; i<=[self.arr count]; i++) {
    //        if (i==row&&self.xzimg.tag==row) {
    //            if (self.click==NO) {
    //                self.xzimg.image=[UIImage imageNamed:@"xuanz_03"];
    //                self.click=YES;
    //            }else{
    //                self.xzimg.image=[UIImage imageNamed:@"xuanz_06"];
    //                self.click=NO;
    //            }
    //        }
    //    }
    if (self.arr.count>=4) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *xzimg =(UIImageView *)[cell.contentView viewWithTag:20];
        //
        NSDictionary * info = [self.arr objectAtIndex:indexPath.row];
        BOOL isChoose = [info[@"state"] boolValue];
        if(isChoose)
        {
            xzimg.image = [UIImage imageNamed:@"非勾选状态"];
            isChoose = NO;
            
        }
        else
        {
            xzimg.image = [UIImage imageNamed:@"勾选状态"];
            isChoose = YES;
        }
        NSDictionary * infos = self.arr[indexPath.row];
        NSString *name=[infos objectForKey:@"name"];
        NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:isChoose],@"state",name,@"name", nil];
        [self.arr replaceObjectAtIndex:indexPath.row withObject:dic];
    }
    
    
    
    
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
