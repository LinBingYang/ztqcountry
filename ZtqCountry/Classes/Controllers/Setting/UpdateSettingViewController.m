//
//  UpdateSettingViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-9-3.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "UpdateSettingViewController.h"

@interface UpdateSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView * tableView;

@end

@implementation UpdateSettingViewController

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
    self.titleLab.text = @"更新设置";
    self.titleLab.textColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10,self.barHeight,kScreenWidth-10*2,kScreenHeitht-77)  style:UITableViewStyleGrouped];
	//m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.backgroundView=nil;
//	_tableView.backgroundColor=[UIColor clearColor];
	_tableView.autoresizesSubviews = YES;
	_tableView.showsVerticalScrollIndicator = NO;
	_tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
	[self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	int row = indexPath.row;
	NSString *t_str = [NSString stringWithFormat:@"%d_%d",section,row];
	UITableViewCell *cell =nil;
	if (cell == nil)
	{
		NSString *t_title;
		if(row == 0)
			t_title = @"启动时更新";
		if(row == 1)
			t_title = @"实时更新";
		else if(row == 2)
            t_title = @"半小时更新";
		else if(row == 3)
			t_title = @"2小时更新";
		else if(row == 4)
			t_title = @"6小时更新";
		else if(row == 5)
			t_title = @"12小时更新";
		else if(row == 6)
			t_title = @"24小时更新";
		else if(row == 7)
			t_title = @"不更新";
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str] ;
		UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
        t_label.text = t_title;
        t_label.backgroundColor = [UIColor clearColor];
        t_label.textColor = [UIColor blackColor];
        t_label.font = [UIFont fontWithName:kBaseFont size:15];
        t_label.textAlignment = NSTextAlignmentLeft;
		[cell addSubview:t_label];
		
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
	if(row == m_selectId)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
	
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *t_headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 45)];
	
	NSString *t_title = @"更新频次";
	
	UILabel *t_label =[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 250, 25)];
    t_label.text = t_title;
    t_label.backgroundColor = [UIColor clearColor];
    t_label.textAlignment = NSTextAlignmentLeft;
	t_label.font=[UIFont fontWithName:@"Helvetica" size:16];
	t_label.textColor = [UIColor grayColor];
	[t_headView addSubview:t_label];
    
	return t_headView ;
}

- (void)deselect
{
	[_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = indexPath.row;
	
	[self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
	if(m_selectId == row)
		return;
	m_selectId = row;
	
//	[m_array replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",m_selectId]];
//	[m_array writeToFile:appFile atomically:NO];
	
	[_tableView reloadData];
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
