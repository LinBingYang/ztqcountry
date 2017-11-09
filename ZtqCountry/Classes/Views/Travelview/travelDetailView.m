//
//  travelDetailView.m
//  ZtqNew
//
//  Created by lihj on 12-6-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "travelDetailView.h"


@implementation travelDetailView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
//        float place = 0;
//        if(kSystemVersionMore7)
//        {
//            place = 20;
//        }
//        self.barhight=place+44;
        
		UIImageView *t_cellBg = [[UIImageView alloc] init];
		[t_cellBg setFrame:CGRectMake(0, 0, self.width, kScreenHeitht-60)];
		[t_cellBg setBackgroundColor:[UIColor whiteColor]];
		[t_cellBg setAlpha:0.5];
		[self addSubview:t_cellBg];
//		[t_cellBg release];
		
		m_des = [[UITextView alloc] initWithFrame:CGRectMake(0, 200, self.width-20, 10)];
		m_img = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, self.width-40, 190)];
		
		m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 5, self.width-20, [UIScreen mainScreen].bounds.size.height-115) style:UITableViewStylePlain];
		m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		m_tableView.backgroundColor=[UIColor clearColor];
        m_tableView.backgroundView=nil;
		m_tableView.autoresizesSubviews = YES;
		m_tableView.showsHorizontalScrollIndicator = YES;
		m_tableView.showsVerticalScrollIndicator = YES;
		[self addSubview:m_tableView];

		
		m_tableView.delegate = self;
		m_tableView.dataSource = self;
    }
    return self;
}

- (void) updateView:(NSString *)t_des withImage:(NSString *)t_img
{
	m_str = t_des;
	m_strImg = t_img;
	[m_img setImageURL:[ShareFun makeImageUrl:t_img]];
	[m_tableView reloadData];
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (m_str == nil) {
		return 10;
	}
	
	[m_des setBackgroundColor:[UIColor clearColor]];
	[m_des setUserInteractionEnabled:NO];
	[m_des setFont:[UIFont systemFontOfSize:15]];
	[m_des setTextColor:[UIColor blackColor]];
    [m_des setTextAlignment:NSTextAlignmentLeft];
	
	float t_height = [ShareFun heightForTextView:m_des WithText:m_str];
	CGRect frame = m_des.frame;
	frame.size.height = t_height + 40;
	m_des.frame = frame;
	[m_des setText:m_str];
	
	return ([ShareFun heightForTextView:m_des WithText:m_str]+200);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = indexPath.row;
	NSInteger section = indexPath.section;
	NSString *t_str = [NSString stringWithFormat:@"%d_%d", section, row];
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:t_str];
	if (cell != nil)
		[cell removeFromSuperview];
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	if (m_str != nil) {
		[cell addSubview:m_des];
		[cell addSubview:m_img];
	}
    cell.backgroundColor=[UIColor clearColor];
	return cell;
}

@end
