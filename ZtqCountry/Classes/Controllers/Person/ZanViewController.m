//
//  ZanViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-31.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "ZanViewController.h"
#import "ZanTableViewCell.h"
#import "EGOImageView.h"
@interface ZanViewController ()<UITableViewDataSource,UITableViewDelegate,ZanTableViewCellDelegate>

@property (strong, nonatomic) UITableView * table;
@property (strong, nonatomic) NSMutableArray * stateArr;
@property(strong,nonatomic)NSString *focusId;//被关注id
@end

@implementation ZanViewController

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
    self.barHiden = NO;
    self.titleLab.text = self.titleStr;
    self.titleLab.textColor = [UIColor whiteColor];
    [self configStateArr];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight)];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
}

-(void)configStateArr
{
    _stateArr = [[NSMutableArray alloc] init];
    for(int i=0;i<self.datas.count;i++)
    {
        [_stateArr addObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * personInfo = [self.datas objectAtIndex:indexPath.row];
    NSString * name = [personInfo objectForKey:@"nickname"];
    NSString * image = [personInfo objectForKey:@"image"];
    NSString *userID=[personInfo objectForKey:@"userId"];
    self.focusId=userID;//被关注id
    NSString *imgstr=[ShareFun makeImageUrlStr:image];
    NSURL *imgurl=[NSURL URLWithString:imgstr];
    ZanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[ZanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    EGOImageView *egoimg=[[EGOImageView alloc]init];
    [egoimg setImageURL:imgurl];
    cell.personImgV.image = egoimg.image;
    cell.nameLab.text = name;
    cell.attentionBut.selected = [[[self stateArr] objectAtIndex:indexPath.row] boolValue];
   
    return cell;
}


-(void)zanTableViewCellAttentionClickWithIndexPath:(NSIndexPath *)indexPath withState:(BOOL)state
{
    [_stateArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:state]];
    if (state==YES) {
        [self closeFocus];
        
    }else{
        
        [self openFocus];
    }
}
-(void)openFocus{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *getFocusList = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [getFocusList setObject:self.userid forKey:@"usrId"];
    [getFocusList setObject:self.focusId forKey:@"focusId"];
    [t_b setObject:getFocusList forKey:@"openFocus"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *getFocusList=[t_b objectForKey:@"openFocus"];
            NSString *result=[getFocusList objectForKey:@"result"];
            NSLog(@"%@",result);
        }
        
    [self.table reloadData];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];

}
-(void)closeFocus{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *getFocusList = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [getFocusList setObject:self.userid forKey:@"usrId"];
    [getFocusList setObject:self.focusId forKey:@"focusId"];
    [t_b setObject:getFocusList forKey:@"closeFocus"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *getFocusList=[t_b objectForKey:@"closeFocus"];
            NSString *result=[getFocusList objectForKey:@"result"];
            NSLog(@"%@",result);
            BOOL ischoose=NO;
            
            //            [self.guanzhubut setTitle:@"已关注" forState:UIControlStateNormal];
            
            //        [self.table reloadData];
            NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:ischoose],@"state",self.focusId,@"name", nil];
            NSMutableArray *marr=[[NSMutableArray alloc]init];
            [marr addObject:dic];
            [[NSUserDefaults standardUserDefaults]setObject:marr forKey:@"Guanzhu"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updata" object:nil];
        }
        //        [self.table reloadData];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
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
