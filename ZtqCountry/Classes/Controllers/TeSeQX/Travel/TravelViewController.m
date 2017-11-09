//
//  TravelViewController.m
//  ZtqNew
//
//  Created by linxg on 12-6-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TravelViewController.h"
#import "MFSideMenuContainerViewController.h"
@implementation TravelViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.view.backgroundColor = [UIColor whiteColor];

	
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    self.barhight=place+44;
    
    UIImageView * navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    navigationBarBg.userInteractionEnabled = YES;
//    navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1];
    navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:navigationBarBg];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 7+place, 30, 30)];
    [leftBut setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [leftBut setImage:[UIImage imageNamed:@"返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBg addSubview:leftBut];

    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, kScreenWidth-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"旅游气象";
    [navigationBarBg addSubview:titleLab];

//    self.barhight=0;
	UIView *t_titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0+self.barhight, self.view.width, 40)];
	//消除键盘透明按钮
	UIButton *mybutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0+self.barhight, 220, 44)];
	[mybutton setBackgroundColor:[UIColor clearColor]];
	[mybutton setTitle:@"旅游气象" forState:UIControlStateNormal];
	mybutton.titleLabel.font = [UIFont fontWithName:kBaseFont size:20];
	[mybutton addTarget:self action:@selector(searchDone:) forControlEvents:UIControlEventTouchDown];
	[t_titleView addSubview:mybutton];
    //	[mybutton release];
	self.navigationItem.titleView = t_titleView;
    //	[t_titleView release];
	
	m_provinceId = -1;
	sec = -1;
	isShow = NO;
	isSearch = NO;
    isprovice=NO;
	[m_provinceData removeAllObjects];
	[m_cityData removeAllObjects];
    secarrs=[[NSMutableArray alloc]init];
    self.citys=[[NSMutableArray alloc]init];
    self.cityids=[[NSMutableArray alloc]init];
    
	m_provinceData = [[NSMutableArray alloc]initWithCapacity:10];
	m_cityData = [[NSMutableArray alloc]initWithCapacity:10];
	cityid=[[NSMutableArray alloc]initWithCapacity:10];
    searcharr=[[NSMutableArray alloc]init];
    searcharrid=[[NSMutableArray alloc]init];
	//消除键盘透明按钮
	mybutton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.barhight, self.view.width, [UIScreen mainScreen].bounds.size.height-45)];
	[mybutton setBackgroundColor:[UIColor clearColor]];
	mybutton.adjustsImageWhenHighlighted = NO;
	mybutton.userInteractionEnabled = YES;
	[mybutton addTarget:self action:@selector(searchDone:) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:mybutton];
    
	m_gdBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.barhight, kScreenWidth, [UIScreen mainScreen].bounds.size.height)];
    m_gdBg.image=[UIImage imageNamed:@"chengshibg.jpg"];
    m_gdBg.userInteractionEnabled=YES;
    [self.view addSubview:m_gdBg];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0,self.barhight, kScreenWidth, 55)];
    img.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
    img.userInteractionEnabled=YES;
    [self.view addSubview:img];
	m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 10, self.view.width-20, 45)];
	m_searchBar.placeholder = @"请输入旅游景点名称或拼音";
	m_searchBar.backgroundColor = [UIColor clearColor];
	m_searchBar.delegate = self;
    [m_searchBar setContentMode:UIViewContentModeLeft];
//    if (kSystemVersionMore7) {
//        m_searchBar.layer.borderColor=[[UIColor grayColor]CGColor];
//        m_searchBar.layer.borderWidth=1;
//    }
    //*
    [ShareFun cleanBackground:m_searchBar];
	[img addSubview:m_searchBar];
    //	[m_searchBar release];
	
	m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 55, self.view.width-20, [UIScreen mainScreen].bounds.size.height-115) style:UITableViewStylePlain];
	m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	m_tableView.backgroundColor=[UIColor clearColor];
	m_tableView.autoresizesSubviews = YES;
	m_tableView.showsHorizontalScrollIndicator = NO;
	m_tableView.showsVerticalScrollIndicator = YES;
	[m_gdBg addSubview:m_tableView];
    //	[m_tableView release];
	
	m_tableView.delegate = self;
	m_tableView.dataSource = self;
	
	if ([m_provinceData count] == 0) {
		[self loadProvinceList];
		[self loadCityList];
		isSearch = NO;
		[m_tableView reloadData];
	}
	
	//-----------------键盘-----------------------
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
#ifdef __IPHONE_5_0
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 5.0) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
	}
#endif
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) backAction
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) setDataSource:(TreeNode *)t_province withCitys:(TreeNode *)t_citys
{
	if (t_province == nil || t_citys == nil)
		return;
	
	
	m_province = t_province;
	[self loadProvinceList];
	
	m_allCity = t_citys;
	[self loadCityList];
	
	[m_tableView reloadData];
}

- (void)loadProvinceList
{
	[m_provinceData removeAllObjects];
	for (int i=0; i<[m_province.children count]; i++)
	{
		TreeNode *t_node = [m_province.children objectAtIndex:i];
		TreeNode *t_node_child = [t_node.children objectAtIndex:2];
		NSString *t_name = t_node_child.leafvalue;
		
		if ([t_name isEqualToString:@"国际城市"])
			continue;
		if ([t_name isEqualToString:@"自动定位"])
			continue;
		if ([t_name isEqualToString:@"钓鱼岛"])
			continue;
		[m_provinceData addObject:t_name];
	}
    
    
}
- (void)loadCityList
{
	[m_cityData removeAllObjects];
	for (int i=0; i<[m_allCity.children count]; i++)
	{
		TreeNode *t_node = [m_allCity.children objectAtIndex:i];
		TreeNode *t_node_child = [t_node.children objectAtIndex:1];
		int t_parentId = [t_node_child.leafvalue intValue];
		t_node_child = [t_node.children objectAtIndex:2];
		NSString *t_name = t_node_child.leafvalue;
		
		if (t_parentId == m_provinceId)
		{
			[m_cityData addObject:t_name];
		}
	}
}

#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isSearch == YES) {
        if (isprovice==YES) {
            return [m_provinceData count];
        }
        return 1;
    }
	return [m_provinceData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isprovice==YES) {
        if (m_provinceData.count>1&&secarrs.count>0) {
            NSString *a=secarrs[section];
            if (sec==a.intValue) {
                return [m_cityData count];
            }else{
                return 0;
            }
            
        }
    }
	if (isSearch == YES) {
		return [m_cityData count];
	}
	
	if (isShow == YES && sec == section) {
		return [m_cityData count];
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (isSearch==YES) {
        if (isprovice==YES) {
            return 40;
        }
        return 0;
    }else
        return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = indexPath.row;
	int section = indexPath.section;
	
	NSString *t_str = [NSString stringWithFormat:@"cell %d_%d", section, row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:t_str];
	
	if(cell != nil)
		[cell removeFromSuperview];
	
    //	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str] autorelease];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
	cell.accessoryType = UITableViewCellAccessoryNone;
	NSString *t_name = [m_cityData objectAtIndex:row];
	
	UILabel *m_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.width-20, 38)];
	m_label.text = [NSString stringWithFormat:@"       %@", t_name];
	m_label.textColor = [UIColor blackColor];
	m_label.backgroundColor = [UIColor clearColor];
	m_label.font = [UIFont fontWithName:@"Helvetica" size:15];
	[cell addSubview:m_label];
    //	[m_label release];
	
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10, 37, kScreenWidth-40, 1)];
    line.backgroundColor=[UIColor grayColor];
    line.alpha=0.3;
    [cell addSubview:line];
	cell.backgroundColor=[UIColor clearColor];
	return cell;
}

- (void)deselect
{
	[m_tableView deselectRowAtIndexPath:[m_tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
	[m_searchBar resignFirstResponder];
	
	if (indexPath.row >= [m_cityData count])
		return;
	
	NSString *t_city = [m_cityData objectAtIndex:indexPath.row];
    NSArray *seperate=[t_city componentsSeparatedByString:@"-"];
    NSString *buffercity=[seperate objectAtIndex:0];
    NSString *ID=[cityid objectAtIndex:indexPath.row];
    //  NSLog(@"%@,%@",buffercity,t_city);
    self.provicename=[self getproviceWithid:ID];
	moreTravelController *collectVC = [[moreTravelController alloc] init];
	[collectVC setTravelCity:ID];
    collectVC.mycity=buffercity;
    
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:buffercity,@"city",ID,@"ID",self.provicename,@"Provice", nil];
    //    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"Travel"];
    NSUserDefaults *travelCity = [NSUserDefaults standardUserDefaults];
    NSMutableArray *fav_city1 = [travelCity objectForKey:@"Travel"];
    NSMutableArray *fav_city2 = [[NSMutableArray alloc] initWithArray:fav_city1];
    if ([fav_city2 containsObject:dic]) {
//        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"该景点已添加" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [al show];
        
        [self.navigationController pushViewController:collectVC animated:YES];
        return;
    }else{
        if (fav_city2.count>=8) {
            [fav_city2 removeObjectAtIndex:0];
            [fav_city2 addObject:dic];
        }else{
            [fav_city2 addObject:dic];
        }
    }
    [travelCity setObject:fav_city2 forKey:@"Travel"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
	[self.navigationController pushViewController:collectVC animated:YES];
    
	[collectVC setIsFromCollect:NO];
	
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if ([m_provinceData count] != 0) {
		
		UIView *tview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width-20, 40)];
		
		UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectMake(0, 0, self.view.width-20, 40);
		btn.tag = section;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchDown];
		[btn addTarget:self action:@selector(resetColor:) forControlEvents:UIControlEventTouchDragOutside];
        btn.backgroundColor=[UIColor whiteColor];
		[tview addSubview:btn];
		
		NSString *t_name = [m_provinceData objectAtIndex:section];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width-20, 40)];
		[label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
		[label setTextColor:[UIColor blackColor]];
		[label setBackgroundColor:[UIColor clearColor]];
		label.text = [NSString stringWithFormat:@"    %@", t_name];
		[tview addSubview:label];
		
		UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"城市列表分隔线.png"]];
		[m_image setFrame:CGRectMake(0, 37, self.view.width-20, 1)];
		[tview addSubview:m_image];
        //		[m_image release];
		
		UIButton *m_Button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-50, 15, 10, 10)];
		UIImage *image;
        if (section!=1) {
            if (isShow == YES && sec == section)
            {
                image = [UIImage imageNamed:@"城市列表上拉.png"];
            }
            else {
                image = [UIImage imageNamed:@"城市列表下拉.png"];
            }
            [m_Button setImage:image forState:UIControlStateNormal];
        }
        if (isprovice==YES) {
            if (secarrs.count>0) {
                NSString *a=secarrs[section];
                int newsec=a.intValue;
                if (isShow==YES && sec == newsec) {
                    image = [UIImage imageNamed:@"城市列表上拉.png"];
                }else{
                    image = [UIImage imageNamed:@"城市列表下拉.png"];
                }
            }

            [m_Button setImage:image forState:UIControlStateNormal];
        }
		m_Button.userInteractionEnabled = NO;
		[tview addSubview:m_Button];
        
        return tview;
	}
	return nil;
}

#pragma mark m_searchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if([searchText isEqualToString:@""] || searchText==nil){
		[self loadProvinceList];
		[self loadCityList];
		isSearch = NO;
        isprovice=NO;
		[m_tableView reloadData];
		return;
	}
	
	isSearch = YES;
	[m_provinceData removeAllObjects];
    [cityid removeAllObjects];
	[m_cityData removeAllObjects];
    [self.citys removeAllObjects];
    [self.cityids removeAllObjects];
    [secarrs removeAllObjects];
    
    for (int i=0; i<m_province.children.count; i++) {
        TreeNode *t_node = [m_province.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:2];
        NSString *t_city = t_node_child.leafvalue;
         NSString *section;
        
        
        if ([t_city rangeOfString:searchText].length > 0)
        {
            [m_provinceData addObject:t_city];
            sec=i;
            section=[NSString stringWithFormat:@"%d",sec];
            [secarrs addObject:section];
            continue;
        }
        t_node_child = [t_node.children objectAtIndex:4];
        NSString *t_py = t_node_child.leafvalue;
        if ([[t_py uppercaseString] rangeOfString:[searchText uppercaseString]].length > 0)
        {
            [m_provinceData addObject:t_city];
            sec=i;
            section=[NSString stringWithFormat:@"%d",sec];
            [secarrs addObject:section];
            continue;
        }
        
        t_node_child = [t_node.children objectAtIndex:5];
        NSString *t_py2 = t_node_child.leafvalue;
        if ([[t_py2 uppercaseString] rangeOfString:[searchText uppercaseString]].length > 0)
        {
            [m_provinceData addObject:t_city];
            sec=i;
            section=[NSString stringWithFormat:@"%d",sec];
            [secarrs addObject:section];
            continue;
        }
    }
    [m_provinceData addObject:@"城市"];
    NSString * section=[NSString stringWithFormat:@"%d",[secarrs count]];
    sec=secarrs.count;
    [secarrs addObject:section];
    isShow=YES;
    if (m_provinceData.count>1) {
        isprovice=YES;
    }else{
        isprovice=NO;
    }
    
	for (int i=0; i<[m_allCity.children count]; i++)
	{
		TreeNode *t_node = [m_allCity.children objectAtIndex:i];
		TreeNode *t_node_child = [t_node.children objectAtIndex:2];
		NSString *t_city = t_node_child.leafvalue;
		
        TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
        NSString *Id = t_node_child1.leafvalue;
       
		if ([t_city rangeOfString:searchText].length > 0)
		{
            [cityid addObject:Id];
			[m_cityData addObject:t_city];
            [self.citys addObject:t_city];
            [self.cityids addObject:Id];
			continue;
		}
		t_node_child = [t_node.children objectAtIndex:3];
		NSString *t_py = t_node_child.leafvalue;
        
       
		if ([[t_py uppercaseString] rangeOfString:[searchText uppercaseString]].length > 0)
		{   [cityid addObject:Id];
			[m_cityData addObject:t_city];
            [self.citys addObject:t_city];
            [self.cityids addObject:Id];
			continue;
		}
		
		t_node_child = [t_node.children objectAtIndex:4];
		NSString *t_py2 = t_node_child.leafvalue;
		if ([[t_py2 uppercaseString] rangeOfString:[searchText uppercaseString]].length > 0)
		{   [cityid addObject:Id];
			[m_cityData addObject:t_city];
            [self.citys addObject:t_city];
            [self.cityids addObject:Id];
			continue;
		}
	}
	[m_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[m_searchBar resignFirstResponder];
}

#pragma mark UIButton action

- (void)btnAction:(UIButton *)sender {
    [m_searchBar resignFirstResponder];
    isShow = !isShow;
    int tag=sender.tag;
    if (isprovice==NO) {
        if ([sender tag] != sec) {
            isShow = YES;
            sec = [sender tag];
        }
    }
    TreeNode *t_node;
    
    if (sec<5)
    {
        t_node = [m_province.children objectAtIndex:sec];
    }
    else{
        t_node = [m_province.children objectAtIndex:sec+1];
    }
    if (isprovice==YES) {
        t_node = [m_province.children objectAtIndex:sec];
        //        isprovice=NO;
    }
//    if (isprovice==YES) {
//        if (isShow==NO) {
//            NSRange range = NSMakeRange(0, [searcharr count]);
//            [m_cityData removeObjectsInRange:range];
//            [cityid removeObjectsInRange:range];
//        }else{
//            [searcharr removeAllObjects];
//            [searcharrid removeAllObjects];
//        }
//    }else{
//        [m_cityData removeAllObjects];
//        [cityid removeAllObjects];
//    }
    if (isprovice==YES) {
        if (isShow==YES) {
            //            if (m_provinceData.count>1) {
            if (secarrs.count>0) {
                NSString *a=secarrs[tag];
                sec=a.intValue;
                //                }
            }
        }else{
            sec=1;
        }
        t_node = [m_province.children objectAtIndex:sec];
    }
    NSString *a=nil;
    if (tag<secarrs.count) {
        a=secarrs[tag];
    }
    if (a.intValue==[secarrs count]-1) {
        [m_cityData removeAllObjects];
        [cityid removeAllObjects];
        if (isShow==YES) {
            NSMutableArray *marr=[[NSMutableArray alloc]init];
            for (NSString *value in self.citys) {
                [marr addObject:value];
            }
            
            m_cityData=marr;
            NSMutableArray *marrid=[[NSMutableArray alloc]init];
            for (NSString *value in self.cityids) {
                [marrid addObject:value];
            }
            
            cityid=marrid;
        }
        
    }else{
    TreeNode *t_node_child = [t_node.children objectAtIndex:0];
    m_provinceId = [t_node_child.leafvalue intValue];
    TreeNode *t_node_child1 = [t_node.children objectAtIndex:2];
    self.provicename=t_node_child1.leafvalue;//获取省
    //     NSLog(@"%d,%d",sec+2,m_provinceId);
    [m_cityData removeAllObjects];
    [cityid removeAllObjects];
    for (int i=0; i<[m_allCity.children count]; i++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        int t_parentId = [t_node_child.leafvalue intValue];
        
        if (t_parentId == m_provinceId)
        {
            t_node_child = [t_node.children objectAtIndex:2];
            NSString *t_name = t_node_child.leafvalue;
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
            NSString *Id = t_node_child1.leafvalue;
           // NSLog(@"^^^%@",Id);
//            if (isprovice==YES) {
//                if (isShow==YES) {
//                    [searcharr addObject:t_name];
//                    [searcharrid addObject:Id];
//                }
//                
//            }else{
            [cityid addObject:Id];
            [m_cityData addObject:t_name];
//            }
        }
    }
    }
//    if (isprovice==YES) {
//        if (isShow==YES) {
//            NSRange range = NSMakeRange(0, [searcharr count]);
//            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
//            [m_cityData insertObjects:searcharr atIndexes:indexSet];
//            [cityid insertObjects:searcharrid atIndexes:indexSet];
//        }
//        
//    }
    //每点击段标题让标题置顶显示.
    //if ([sender tag] == [m_provinceData count] - 1)
    [m_tableView setContentOffset:CGPointMake(0, [sender tag]*33) animated:NO];
    
    [m_tableView reloadData];
    
	
}

- (void)resetColor:(id)sender
{
	UIButton *btn = (UIButton *)sender;
	btn.backgroundColor = [UIColor clearColor];
}

- (void)changeColor:(id)sender
{
	UIButton *btn = (UIButton *)sender;
	btn.backgroundColor = [UIColor clearColor];
}

- (void)searchDone:(id)sender
{
	[m_searchBar resignFirstResponder];
}

- (void)rightBtn
{
	[m_searchBar resignFirstResponder];
//	collectTravelController *collectVC = [[collectTravelController alloc] init];
//	[self.navigationController pushViewController:collectVC animated:!kSystemVersionMore7];
    //	[collectVC release];
}
-(NSString *)getproviceWithid:(NSString *)cid{
    NSString *provice,*proid;
    m_travelcity=m_treeNodelLandscape;
    for (int i=0; i<[m_travelcity.children count]; i++)
    {
        TreeNode *t_node = [m_travelcity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:0];
        
        NSString *newid = t_node_child.leafvalue;
        
        if ([newid isEqualToString:cid])
        {
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:1];
            
            NSString *name = t_node_child1.leafvalue;
            proid=name;
            break;
        }
    }
    m_province=m_treeNodeProvince;
    for (int i=0; i<[m_province.children count]; i++)
    {
        TreeNode *t_node = [m_province.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:0];
        
        NSString *pid = t_node_child.leafvalue;
        
        if ([pid isEqualToString:proid])
        {
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:2];
            
            NSString *name = t_node_child1.leafvalue;
            provice=name;
            break;
        }
    }
    
    
    return provice;
}
#pragma mark keyboardWillhe
- (void)changeShareContentHeight:(float)t_height withDuration:(float)t_dration
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:t_dration];
	[UIView setAnimationDelegate:self];
	[m_tableView setFrame:CGRectMake(10, 55, self.view.width-20, [UIScreen mainScreen].bounds.size.height-115 - t_height)];
	[UIView commitAnimations];
}
- (void)keyboardWillShow:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [aValue CGRectValue];
	NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSTimeInterval animationDuration;
	[animationDurationValue getValue:&animationDuration];
	[self changeShareContentHeight:keyboardRect.size.height withDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	NSDictionary* userInfo = [notification userInfo];
	NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSTimeInterval animationDuration;
	[animationDurationValue getValue:&animationDuration];
	[self changeShareContentHeight:0.0 withDuration:animationDuration];
}

@end
