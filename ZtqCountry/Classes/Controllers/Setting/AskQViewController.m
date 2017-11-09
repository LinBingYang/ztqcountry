//
//  AskQViewController.m
//  ZtqCountry
//
//  Created by Admin on 14-7-17.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "AskQViewController.h"
#import "AskQTableViewCell.h"
#import "UILabel+utils.h"
//#import "NetWorkCenter.h"
@interface AskQViewController ()

@property (strong, nonatomic) NSIndexPath * currentIp;
@property (strong, nonatomic) NSMutableArray * currentCellDatas;//这个数组保存要写入cell的数据
@property (assign, nonatomic) BOOL sectionIsOpen;
@property (assign, nonatomic) BOOL rowIsOpen;

@end

@implementation AskQViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.sectionIsOpen = NO;
        self.rowIsOpen = NO;
        self.currentIp = [NSIndexPath indexPathForRow:-1 inSection:-1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.titleLab.text = @"常见问题";
    self.titleLab.textColor = [UIColor whiteColor];
    self.barHiden = NO;
    self.view.backgroundColor = [UIColor colorHelpWithRed:248 green:243 blue:209 alpha:1];
    mtableview=[[UITableView alloc]initWithFrame:CGRectMake(5,self.barHeight+5, self.view.width-10, kScreenHeitht-self.barHeight-20) style:UITableViewStylePlain];
//    mtableview.backgroundColor = [UIColor clearColor];
	mtableview.autoresizesSubviews = YES;
	mtableview.showsHorizontalScrollIndicator = NO;
	mtableview.showsVerticalScrollIndicator = NO;
	mtableview.delegate = self;
	mtableview.dataSource = self;
    mtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    mtableview.layer.shadowColor = [UIColor blackColor].CGColor;
//    mtableview.layer.shadowRadius = 3;
//    mtableview.layer.shadowOffset = CGSizeMake(1, 1);
	[self.view addSubview:mtableview];

    [self getquestion];
    
    m_expandSection=-2;
}
-(void)getquestion{
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
     NSMutableDictionary * a = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    [a setObject:@""  forKey:@""];
    [b setObject:a forKey:@"ask_quest"];
    [a setObject:@"I" forKey:@"phone_type"];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:param withFlag:10 withSuccess:^(NSDictionary *returnData) {
        NSLog(@"%@",returnData);
        NSDictionary *t_b = [returnData objectForKey:@"b"];
		if (t_b != nil)
		{
            NSDictionary *ask_quest=[t_b objectForKey:@"ask_quest"];
            NSArray *dataList=[ask_quest objectForKey:@"dataList"];
            self.allClassAQ = [[NSMutableArray alloc] initWithArray:dataList];
            self.currentCellDatas = [[NSMutableArray alloc] init];
            for(int i=0;i<self.allClassAQ.count;i++)
            {
                NSDictionary * AQinfo = [self.allClassAQ objectAtIndex:i];
                NSString * title = [AQinfo objectForKey:@"title"];
                [self.currentCellDatas addObject:[[NSMutableArray alloc] initWithObjects:title, nil]];
            }
        }
         [mtableview reloadData];
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
   
}
- (void)leftBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.currentCellDatas.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.section==0&&indexPath.row==1) {
//        if (self.answerheigh.length>0) {
//            UILabel * platformLab =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 270, 50)];
//            
//            float platformHeight = [platformLab labelheight:self.answerheigh withFont:[UIFont fontWithName:kBaseFont size:14]];
//            return platformHeight;
//        }
//    }
  
        return 50;
  
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray * sectionAQs = [self.currentCellDatas objectAtIndex:section];
    return sectionAQs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"$section = %d$row = %d$$",indexPath.section,indexPath.row);
    static NSString *identify=@"cell";
    AskQTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell=[[AskQTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSMutableArray * infos = [self.currentCellDatas objectAtIndex:indexPath.section];
    NSString * str = [infos objectAtIndex:indexPath.row];
    
    cell.contentLab.text = str;
       //大分组
    NSLog(@"$row =%d$",indexPath.row);
    NSLog(@"$section = %d$",indexPath.section);
    if(indexPath.row == 0)
    {
        cell.contentLab.textColor = [UIColor blackColor];
        cell.arrow.frame = CGRectMake(280, 14, 21, 12);
        cell.arrow.image = [UIImage imageNamed:@"cjwt2箭头2_05.png"];//上
        cell.arrow.hidden = NO;
        if(self.sectionIsOpen && indexPath.section == self.currentIp.section)
        {
            cell.arrow.image = [UIImage imageNamed:@"cjwt箭头_03.png"];//下
        }
//        cell.separatorLine.hidden = NO;
    }
    //小分组
    else
    {
//        cell.separatorLine.hidden = YES;
//        if(self.currentIp.section == indexPath.section)
//        {
            //打开
            if(self.rowIsOpen)
            {
                if(indexPath.row == self.currentIp.row)
                {
                    cell.contentLab.textColor = [UIColor grayColor];
                    cell.arrow.frame = CGRectMake(280-3, 15, 16, 10);
                    cell.arrow.image = [UIImage imageNamed:@"lyqx3箭头.png"];//下小
                    cell.arrow.hidden = NO;
                }
                else
                {
                    if(indexPath.row == self.currentIp.row +1)
                    {
                        cell.contentLab.textColor = [UIColor grayColor];
                        cell.arrow.hidden = YES;
                    }
                    else
                    {
                        cell.contentLab.textColor = [UIColor grayColor];
                        cell.arrow.frame = CGRectMake(280, 12, 10, 16);
                        cell.arrow.image = [UIImage imageNamed:@"cjwt2箭头2_03.png"];//小右
                        cell.arrow.hidden = NO;
                    }
                }
            }
            else
            {
                cell.contentLab.textColor = [UIColor grayColor];
                cell.arrow.frame = CGRectMake(280, 12, 10, 16);
                cell.arrow.image = [UIImage imageNamed:@"cjwt2箭头2_03.png"];//小右
                cell.arrow.hidden = NO;

            }
//        }
//        else
//        {
//            NSLog(@"bukeneng");
//        }
//        
//        if(indexPath.row == 0)
//        {
//            cell.contentLab.textColor = [UIColor blackColor];
//            cell.arrow.frame = CGRectMake(280, 14, 21, 12);
//            cell.arrow.image = [UIImage imageNamed:@"cjwt2箭头2_05.png"];//上
//            cell.arrow.hidden = NO;
//        }
//        else
//        {
//            //
//            //        if(self.rowIsOpen && indexPath.section == self.currentIp.section&&indexPath.row == self.currentIp.row+1)
//            //        {
//            //            cell.contentLab.textColor = [UIColor grayColor];
//            //            cell.arrow.hidden = YES;
//            //        }
//            //        else
//            //        {
//            //            cell.contentLab.textColor = [UIColor grayColor];
//            //            cell.arrow.frame = CGRectMake(280, 12, 10, 16);
//            //            cell.arrow.image = [UIImage imageNamed:@"cjwt2箭头2_03.png"];
//            //            cell.arrow.hidden = NO;
//            //        }
//        }

    }
    UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"灰色隔条.png"]];
    [m_image setFrame:CGRectMake(0, 49, kScreenWidth, 1)];
    [cell addSubview:m_image];
    return cell;
}
- (void)deselect
{
	[mtableview deselectRowAtIndexPath:[mtableview indexPathForSelectedRow] animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
    //点击同一个分组
    if(self.currentIp.section == indexPath.section)
    {
        if(indexPath.row == 0)//进行整个分组的操作
        {
            if(self.sectionIsOpen == YES)//分组已经打开
            {
                //对分组进行关闭
                NSMutableArray * sectionAQs = [self.currentCellDatas objectAtIndex:indexPath.section];
                NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
                for(int i=1;i<sectionAQs.count;i++)
                {
                    NSLog(@"$%d$",indexPath.section);
                    NSIndexPath * IP = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                    [indexPaths addObject:IP];
                }
                self.currentIp = indexPath;
                self.sectionIsOpen = NO;
                self.rowIsOpen = NO;
                [sectionAQs removeObjectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(1, sectionAQs.count-1)]];
                [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
                
                [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
                //                [tableView reloadData];
                return;
            }
            else//分组还没打开
            {
                NSMutableArray * sectionAQs = [self.currentCellDatas objectAtIndex:indexPath.section];
                NSDictionary * sectionAQAllinfo = [self.allClassAQ objectAtIndex:indexPath.section];
                NSArray * infos = [sectionAQAllinfo objectForKey:@"info"];
                NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
                for(int i=0;i<infos.count;i++)
                {
                    NSIndexPath * IP = [NSIndexPath indexPathForRow:i+1 inSection:indexPath.section];
                    [indexPaths addObject:IP];
                    NSDictionary * info = [infos objectAtIndex:i];
                    NSString * question = [info objectForKey:@"question"];
                    [sectionAQs addObject:question];
                }
                self.currentIp = indexPath;
                self.sectionIsOpen = YES;
                self.rowIsOpen = NO;
                [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
                
                //                [tableView reloadData];
                [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
                return;
            }
        }
        else
        {
            if(indexPath.row == self.currentIp.row)//对同一个问题操作
            {
                if(self.rowIsOpen == YES)//问题已经打开
                {
                    //关闭问题
                    NSMutableArray * sectionAQs = [self.currentCellDatas objectAtIndex:indexPath.section];
                    [sectionAQs removeObjectAtIndex:indexPath.row +1];
                    NSIndexPath * IP = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:self.currentIp.section];
                    self.currentIp = indexPath;
                    self.sectionIsOpen = YES;
                    self.rowIsOpen = NO;
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:IP, nil] withRowAnimation:UITableViewRowAnimationRight];
                    
                    //                    [tableView reloadData];
                    [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
                    return;
                    
                }
                else//问题还没打开
                {
                    NSMutableArray * sectionAQs = [self.currentCellDatas objectAtIndex:indexPath.section];
                    NSDictionary * sectionAQAllinfo = [self.allClassAQ objectAtIndex:indexPath.section];
                    NSArray * infos = [sectionAQAllinfo objectForKey:@"info"];
                    NSDictionary * info = [infos objectAtIndex:indexPath.row -1];
                    NSString * answer = [info objectForKey:@"answer"];
                    self.answerheigh=answer;
                    [sectionAQs insertObject:answer atIndex:indexPath.row + 1];
                    NSIndexPath * IP = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:self.currentIp.section];
                    self.currentIp = indexPath;
                    self.sectionIsOpen = YES;
                    self.rowIsOpen = YES;
                    //                    [tableView reloadData];
                    [tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:IP, nil] withRowAnimation:UITableViewRowAnimationMiddle];
                    
                    [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
                    return;
                    
                }
            }
            else//点击不同的问题
            {
                NSIndexPath * oldCurrentIp = self.currentIp;
                if(indexPath.row == self.currentIp.row +1 && self.rowIsOpen == YES)
                {
                    //点击三级单元
                    return;
                }
                else
                {
                    //该分组已经有问题打开，关闭旧问题，打开新问题
                    if(self.rowIsOpen)
                    {
                        if(self.currentIp.row >indexPath.row)
                        {
                            NSLog(@"#curretn = %d#",self.currentIp.row);
                            NSLog(@"#indexpath = %d#",indexPath.row);
                            NSMutableArray * sectionAQs = [self.currentCellDatas objectAtIndex:indexPath.section];
                            [sectionAQs removeObjectAtIndex:self.currentIp.row +1];
                            NSIndexPath * DIP = [NSIndexPath indexPathForRow:self.currentIp.row +1 inSection:self.currentIp.section];//删除的cell
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:DIP, nil] withRowAnimation:UITableViewRowAnimationRight];
                            
                            NSDictionary * sectionAQAllinfo = [self.allClassAQ objectAtIndex:indexPath.section];
                            NSArray * infos = [sectionAQAllinfo objectForKey:@"info"];
                            NSDictionary * info = [infos objectAtIndex:indexPath.row-1];
                            NSString * answer = [info objectForKey:@"answer"];
                       
                            self.answerheigh=answer;
                            self.currentIp = indexPath;
                            self.sectionIsOpen = YES;
                            self.rowIsOpen = YES;
                            [sectionAQs insertObject:answer atIndex:indexPath.row+1];
                            NSIndexPath * IIP = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
                            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:IIP, nil] withRowAnimation:UITableViewRowAnimationMiddle];
                            
                            //                        [tableView reloadData];
                            [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
                            NSIndexPath * oldCurrendNewIP = [NSIndexPath indexPathForRow:oldCurrentIp.row+1 inSection:oldCurrentIp.section];
                            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:oldCurrendNewIP] withRowAnimation:UITableViewRowAnimationNone];
                            return;
                        }
                        else
                        {
                            NSMutableArray * sectionAQs = [self.currentCellDatas objectAtIndex:indexPath.section];
                            NSLog(@"#%d#",self.currentIp.row);
                            [sectionAQs removeObjectAtIndex:self.currentIp.row +1];
                            NSIndexPath * DIP = [NSIndexPath indexPathForRow:self.currentIp.row +1 inSection:self.currentIp.section];//删除的cell
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:DIP, nil] withRowAnimation:UITableViewRowAnimationRight];
                            
                            NSDictionary * sectionAQAllinfo = [self.allClassAQ objectAtIndex:indexPath.section];
                            NSArray * infos = [sectionAQAllinfo objectForKey:@"info"];
                            NSDictionary * info = [infos objectAtIndex:indexPath.row-2];
                            NSString * answer = [info objectForKey:@"answer"];
                            self.answerheigh=answer;
                            self.currentIp = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                            self.sectionIsOpen = YES;
                            self.rowIsOpen = YES;
                            [sectionAQs insertObject:answer atIndex:indexPath.row];
                            NSIndexPath * IIP = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:IIP, nil] withRowAnimation:UITableViewRowAnimationMiddle];
                            
                            //                        [tableView reloadData];
                            [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section], nil] withRowAnimation:UITableViewRowAnimationFade];
                            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:oldCurrentIp] withRowAnimation:UITableViewRowAnimationNone];
                            return;
                        }
                        
                    }
                    else//分组问题都没打开过，那么就打开一个问题
                    {
                        NSMutableArray * sectionAQs = [self.currentCellDatas objectAtIndex:indexPath.section];
                        //                        [sectionAQs removeObjectAtIndex:self.currentIp.row +1];
                        //                        NSIndexPath * DIP = [NSIndexPath indexPathForRow:self.currentIp.row +1 inSection:self.currentIp.section];//删除的cell
                        //                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:DIP, nil] withRowAnimation:UITableViewRowAnimationMiddle];
                        
                        NSDictionary * sectionAQAllinfo = [self.allClassAQ objectAtIndex:indexPath.section];
                        NSArray * infos = [sectionAQAllinfo objectForKey:@"info"];
                        NSDictionary * info = [infos objectAtIndex:indexPath.row-1];
                        NSString * answer = [info objectForKey:@"answer"];
                        self.answerheigh=answer;
                        [sectionAQs insertObject:answer atIndex:indexPath.row+1];
                        NSIndexPath * IIP = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
                        self.currentIp = indexPath;
                        self.sectionIsOpen = YES;
                        self.rowIsOpen = YES;
                        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:IIP, nil] withRowAnimation:UITableViewRowAnimationMiddle];
                        
                        //                        [tableView reloadData];
                        [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
                        return;
                        
                    }
                    
                }
                
            }
        }
    }
    else//点击不同分组
    {
        NSIndexPath * oldCurrentIp = self.currentIp;
        NSLog(@"$%d$",oldCurrentIp.section);
        NSLog(@"#%d#",oldCurrentIp.row);
        //        //打开相应的分组
        if(self.currentIp.section >=0)
        {
            NSMutableArray * sectionAQs = [self.currentCellDatas objectAtIndex:self.currentIp.section];
            NSMutableArray * DindexPaths = [[NSMutableArray alloc] init];
            for(int i=1;i<sectionAQs.count;i++)
            {
                NSIndexPath * DIP = [NSIndexPath indexPathForRow:i inSection:self.currentIp.section];
                [DindexPaths addObject:DIP];
            }
            [sectionAQs removeObjectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(1, sectionAQs.count-1)]];
            [tableView deleteRowsAtIndexPaths:DindexPaths withRowAnimation:UITableViewRowAnimationRight];
        }
        NSMutableArray * IsectionAQS = [self.currentCellDatas objectAtIndex:indexPath.section];
        NSDictionary * IsectionAQinfo = [self.allClassAQ objectAtIndex:indexPath.section];
        NSArray * infos = [IsectionAQinfo objectForKey:@"info"];
        for(int i=0;i<infos.count;i++)
        {
            NSDictionary * info = [infos objectAtIndex:i];
            NSString * question = [info objectForKey:@"question"];
            [IsectionAQS addObject:question];
        }
        NSMutableArray * IindexPaths = [[NSMutableArray alloc] init];
        for(int i=0;i<infos.count;i++)
        {
            NSIndexPath * IIP = [NSIndexPath indexPathForRow:i+1 inSection:indexPath.section];
            [IindexPaths addObject:IIP];
        }
        self.currentIp = indexPath;
        self.sectionIsOpen = YES;
        self.rowIsOpen = NO;
        [tableView insertRowsAtIndexPaths:IindexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        
        //            [tableView reloadData];
        [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        if(oldCurrentIp.section >=0)
        {
            NSIndexPath *IP = [NSIndexPath indexPathForRow:0 inSection:oldCurrentIp.section];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:IP] withRowAnimation:UITableViewRowAnimationNone];
        }
        return;
        
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
