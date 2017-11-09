//
//  mapDetailViewController.m
//  ZtqNew
//
//  Created by lihj on 12-8-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "tf_detailViewController.h"
#import "ShareFun.h"
#import "typhoonDetailModel.h"
#import "tfDetailView.h"

@implementation tf_detailViewController

@synthesize m_tfModel = m_tfModel;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.hidesBackButton = YES;
	[self.navigationController setToolbarHidden:YES animated:YES];
	if (kSystemVersionMore7) {
        self.edgesForExtendedLayout=UIEventSubtypeNone;
    }
	//[self setLBtn:@"" image:@"返回.png" imageSel:@"" target:self action:@selector(backAction)];
	[self setTitle:@"详细信息"];
	m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kScreenHeitht) style:UITableViewStyleGrouped];
	m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.backgroundView=nil;
	m_tableView.autoresizesSubviews = YES;
	m_tableView.showsHorizontalScrollIndicator = YES;
	m_tableView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:m_tableView];
//	[m_tableView release];
	
	m_tableView.delegate = self;
	m_tableView.dataSource = self;
}

- (void)backAction
{
	[[tfDetailView shareTfDetailView] setIfHidden:YES];
	[self.navigationController setToolbarHidden:NO animated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)setMapData:(typhoonYearModel *)t_model withNum:(NSInteger)t_num withType:(NSInteger)t_type
{
	if (t_model == nil)
	{
		return;
	}
	else {
//		m_tfModel = [t_model retain];
        self.m_tfModel = t_model;
		m_num = t_num;
		m_type = t_type;
		
		switch (m_type) {
			case 1:
				m_str = @"北京预报";
				break;
			case 2:
				m_str = @"东京预报";
				break;
			case 3:
				m_str = @"福州预报";
				break;
			case 4:
			{
				if ([m_tfModel.ful_points count] - 1 == t_num) {
					m_str = @"当前位置信息";
				}else {
					m_str = @"历史路径信息";
				}
			}
				break;
			default:
				break;
		}
	}
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (m_type == 4)
		return 8;
	else
		return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = indexPath.row;
	NSInteger section = indexPath.section;
	NSString *t_str = [NSString stringWithFormat:@"%d_%d", section, row];
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:t_str];
	if (cell != nil)
		[cell removeFromSuperview];
//	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str] autorelease];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell setBackgroundColor:[UIColor lightTextColor]];

	typhoonDetailModel *t_detail;
	if (m_type == 1) {
		t_detail = (typhoonDetailModel *)[m_tfModel.dotted_points objectAtIndex:m_num];
	}
	if (m_type == 2) {
		t_detail = (typhoonDetailModel *)[m_tfModel.dotted_1_points objectAtIndex:m_num];
	}
	if (m_type == 3) {
		t_detail = (typhoonDetailModel *)[m_tfModel.dotted_2_points objectAtIndex:m_num];
	}
	if (m_type == 4) {
		t_detail = (typhoonDetailModel *)[m_tfModel.ful_points objectAtIndex:m_num];
	}
	
	switch (row) {
		case 0:
		{
			UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentCenter];
			[t_label setText:[NSString stringWithFormat:@"%@ (%@)", m_tfModel.name, m_str]];
			[t_label setFont:[UIFont fontWithName:@"Helvetica" size:16]];
			[cell addSubview:t_label];
//			[t_label release];
		}
			break;
		case 1:
		{
			NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
			[dateformat setDateFormat:@"MMddHH"];
			NSDate *s_date = [dateformat dateFromString:t_detail.time];
			[dateformat setDateFormat:@"MM月dd日 HH时"];
			NSString *d_date = [dateformat stringFromDate:s_date];
//			[dateformat release];
			
			UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentRight];
			if (m_type != 4) {
				[t_label setText:@"预报时长："];
			}else {
				[t_label setText:@"过去时间："];
			}
			[t_label setTextColor:[UIColor darkGrayColor]];
			[t_label setFont:[UIFont boldSystemFontOfSize:15]];
			[cell addSubview:t_label];
//			[t_label release];
			
			t_label = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 200, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentLeft];
			if (m_type != 4) {
				[t_label setText:t_detail.tip];
			}else {
				[t_label setText:d_date];
			}
			[t_label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
			[cell addSubview:t_label];
//			[t_label release];
		}
			break;
		case 2:
		{
			UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentRight];
			[t_label setText:@"中心位置："];
			[t_label setTextColor:[UIColor darkGrayColor]];
			[t_label setFont:[UIFont boldSystemFontOfSize:15]];
			[cell addSubview:t_label];
//			[t_label release];
			
			t_label = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 200, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentLeft];
			[t_label setText:[NSString stringWithFormat:@"%@°，%@°", t_detail.jd, t_detail.wd]];
			[t_label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
			[cell addSubview:t_label];
//			[t_label release];
		}
			break;
		case 3:
		{
			UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentRight];
			[t_label setText:@"最大风力："];
			[t_label setTextColor:[UIColor darkGrayColor]];
			[t_label setFont:[UIFont boldSystemFontOfSize:15]];
			[cell addSubview:t_label];
//			[t_label release];
			
			t_label = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 200, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentLeft];
			[t_label setText:[NSString stringWithFormat:@"%@(级)", t_detail.fl]];
			[t_label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
			[cell addSubview:t_label];
//			[t_label release];
		}
			break;
		case 4:
		{
			UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentRight];
			[t_label setText:@"最大风速："];
			[t_label setTextColor:[UIColor darkGrayColor]];
			[t_label setFont:[UIFont boldSystemFontOfSize:15]];
			[cell addSubview:t_label];
//			[t_label release];
			
			t_label = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 200, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentLeft];
			[t_label setText:[NSString stringWithFormat:@"%@(米/秒)", t_detail.fs_max]];
			[t_label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
			[cell addSubview:t_label];
//			[t_label release];
		}
			break;
		case 5:
		{
			UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentRight];
			[t_label setText:@"中心气压："];
			[t_label setTextColor:[UIColor darkGrayColor]];
			[t_label setFont:[UIFont boldSystemFontOfSize:15]];
			[cell addSubview:t_label];
//			[t_label release];
			
			t_label = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 200, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentLeft];
			[t_label setText:[NSString stringWithFormat:@"%@(百帕)", t_detail.qy]];
			[t_label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
			[cell addSubview:t_label];
//			[t_label release];
		}
			break;
		case 6:
		{
			UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentRight];
			[t_label setText:@"七级风圈半径："];
			[t_label setTextColor:[UIColor darkGrayColor]];
			[t_label setFont:[UIFont boldSystemFontOfSize:15]];
			[cell addSubview:t_label];
//			[t_label release];
			
			t_label = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 200, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentLeft];
			[t_label setText:[NSString stringWithFormat:@"%@(公里)", t_detail.fl_7]];
			[t_label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
			[cell addSubview:t_label];
//			[t_label release];
		}
			break;
		case 7:
		{
			UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentRight];
			[t_label setText:@"十级风圈半径："];
			[t_label setTextColor:[UIColor darkGrayColor]];
			[t_label setFont:[UIFont boldSystemFontOfSize:15]];
			[cell addSubview:t_label];
//			[t_label release];
			
			t_label = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 200, 35)];
			[t_label setBackgroundColor:[UIColor clearColor]];
			[t_label setTextAlignment:UITextAlignmentLeft];
			[t_label setText:[NSString stringWithFormat:@"%@(公里)", t_detail.fl_10]];
			[t_label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
			[cell addSubview:t_label];
//			[t_label release];
		}
			break;
		default:
			break;
	}
    cell.backgroundColor=[UIColor clearColor];
	return cell;
}


@end
