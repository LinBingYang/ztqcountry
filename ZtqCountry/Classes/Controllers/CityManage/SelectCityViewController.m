//
//  SelectCityViewController.m
//  ZtqCountry
//
//  Created by 林炳阳	 on 14-6-30.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "SelectCityViewController.h"
#import "ShareFun.h"
#import "MFSideMenuContainerViewController.h"
#import "YujingPushViewController.h"
#import "TQYBViewController.h"
#import "SKGJViewController.h"
#import "SomeSettingViewController.h"
@interface SelectCityViewController (private)
- (NSString *)getProvinceWithID:(NSString *)provinceID;
@end

@implementation SelectCityViewController
@synthesize delegate;
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
    self.view.backgroundColor=[UIColor whiteColor];
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
    [_leftBut addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 12+place, self.view.width-100, 20)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor whiteColor];
    [_navigationBarBg addSubview:_titleLab];
    _titleLab.text=@"选择城市";
	m_provinceId = -1;
	sec = -1;
	isShow = NO;
	isSearch = NO;
    isprovice=NO;
	
	[m_provinceData removeAllObjects];
	[m_cityData removeAllObjects];
	m_provinceData = [[NSMutableArray alloc]initWithCapacity:10];
	m_cityData = [[NSMutableArray alloc]initWithCapacity:10];
    searcharr=[[NSMutableArray alloc]init];
    secarrs=[[NSMutableArray alloc]init];
    self.citys=[[NSMutableArray alloc]init];
    //消除键盘透明按钮
	UIButton *mybutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0+self.barHeight, self.view.width, kScreenHeitht-65)];
	[mybutton setBackgroundColor:[UIColor clearColor]];
	[mybutton addTarget:self action:@selector(searchDone:) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:mybutton];
    
    mybutton = [[UIButton alloc] initWithFrame:CGRectMake(-60, 0+self.barHeight, self.view.width, 40)];
	mybutton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	[mybutton addTarget:self action:@selector(searchDone:) forControlEvents:UIControlEventTouchDown];
    [self.navigationItem.titleView addSubview:mybutton];
    //self.title=@"选择城市";
    
    //    UIImageView *search=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 300, 45)];
    //    search.image=[UIImage imageNamed:@"lyqx3搜索框"];
    //    search.userInteractionEnabled=YES;
    //    [self.view addSubview:search];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0,self.barHeight, kScreenWidth, 55)];
    img.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
   img.userInteractionEnabled=YES;
    [self.view addSubview:img];
    UIImageView *searchimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5+self.barHeight, kScreenWidth-20, 40)];
    searchimg.image=[UIImage imageNamed:@"搜索框"];
    searchimg.userInteractionEnabled=YES;
    [self.view addSubview:searchimg];
	m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 40)];
	m_searchBar.placeholder = [NSString stringWithFormat:@"当前城市:%@",[self readXMLwith:[setting sharedSetting].currentCityID]];
    
    m_searchBar.delegate=self;
    
    [ShareFun cleanBackground:m_searchBar];
//    if (kSystemVersionMore7) {
//        m_searchBar.layer.borderWidth=1;
//        m_searchBar.layer.borderColor=[[UIColor grayColor]CGColor];
//    }
    
	[searchimg addSubview:m_searchBar];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 55+self.barHeight, kScreenWidth-20, kScreenHeitht-115) style:UITableViewStylePlain];
	m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	m_tableView.backgroundColor=[UIColor whiteColor];
    m_tableView.backgroundView=nil;
	m_tableView.autoresizesSubviews = YES;
	m_tableView.showsHorizontalScrollIndicator = NO;
	m_tableView.showsVerticalScrollIndicator = YES;
   
	[self.view addSubview:m_tableView];
	
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
    [self ishavecitylist];//判断是否有加载出列表
    
}
-(void)ishavecitylist{
    if (!m_treeNodeAllCity) {
        [[GetXMLData alloc] startRead:@"provinceList" withObject:self withFlag:0];
    }
}
#pragma mark xml delegate

-(void)readFinish:(TreeNode *)p_treeNode withFlag:(int)p_flag
{
    if(p_flag == 0)
    {
        m_treeNodeProvince = p_treeNode;
        NSLog(@"privince list load finish!");
        
        [[GetXMLData alloc] startRead:@"cityList" withObject:self withFlag:1];
    }
    else if (p_flag == 1)
    {
        m_treeNodeAllCity = p_treeNode;
        m_province = m_treeNodeProvince;
        [self loadProvinceList];
        
        m_allCity = m_treeNodeAllCity;
        [self loadCityList];
        
        [m_tableView reloadData];
        
        [[GetXMLData alloc] startRead:@"landscapeList" withObject:self withFlag:2];
    }
    else if (p_flag == 2)
    {
        m_treeNodelLandscape = p_treeNode;
        NSLog(@"landscape list load finish!");
     
    }
    
    
}
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
//-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//}
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
		[m_provinceData addObject:t_name];
	}
}
- (void)loadCityList
{
	[m_cityData removeAllObjects];
	for (int i = 0; i < [m_allCity.children count]; i ++)
	{
		TreeNode *t_node = [m_allCity.children objectAtIndex:i];
		TreeNode *t_node_child = [t_node.children objectAtIndex:1];
		NSString *t_parentId = t_node_child.leafvalue;
		t_node_child = [t_node.children objectAtIndex:2];
		NSString *t_name = t_node_child.leafvalue;
		
		if ([t_parentId intValue] == m_provinceId)
		{
			//----------------------------------------------------
			t_node_child = [t_node.children objectAtIndex:3];
			NSString *t_pCity = t_node_child.leafvalue;
			NSString *t_province = [self getProvinceWithID:t_parentId];
			//----------------------------------------------------
			NSDictionary *t_cityData = [NSDictionary dictionaryWithObjectsAndKeys:t_name, @"city", t_province, @"province", t_pCity, @"pCity", nil];
			
			[m_cityData addObject:t_cityData];
		}
	}
}

- (NSString *)getProvinceWithID:(NSString *)provinceID
{
	for (int i=0; i<[m_province.children count]; i++)
	{
		TreeNode *t_node = [m_province.children objectAtIndex:i];
		TreeNode *t_node_child = [t_node.children objectAtIndex:0];
		NSString *t_provinceID = t_node_child.leafvalue;
        
		if ([t_provinceID isEqualToString:provinceID]) {
			TreeNode *t_node_child_name = [t_node.children objectAtIndex:2];
			NSString *t_name = t_node_child_name.leafvalue;
			
			return t_name;
		}
	}
	
	return @"";
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
//*
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
//*/
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
	
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
	cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSString *t_name = [[m_cityData objectAtIndex:row] objectForKey:@"pCity"];
	
	UILabel *m_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.width, 38)];
	m_label.text = [NSString stringWithFormat:@"       %@", t_name];
	m_label.textColor = [UIColor blackColor];
	m_label.backgroundColor = [UIColor clearColor];
	m_label.font = [UIFont systemFontOfSize:16.5];
	[cell addSubview:m_label];
    cell.backgroundColor=[UIColor clearColor];
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10, 37, kScreenWidth-40, 1)];
    line.backgroundColor=[UIColor grayColor];
    line.alpha=0.3;
    [cell addSubview:line];
	return cell;
}

- (void)deselect
{
	[m_tableView deselectRowAtIndexPath:[m_tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
	[m_searchBar resignFirstResponder];
	
	if (indexPath.row >= [m_cityData count])
		return;
	
    
    
	NSDictionary *t_cityData = [m_cityData objectAtIndex:indexPath.row];
    NSString *cityid=[t_cityData objectForKey:@"ID"];
    NSString *city=[t_cityData objectForKey:@"city"];
     NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:city, @"city",cityid,@"ID", nil];
    if ([self.type isEqualToString:@"tuisong"]) {
        SomeSettingViewController *yjpush=[[SomeSettingViewController alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:t_cityData forKey:@"tsdic"];
        [self.navigationController pushViewController:yjpush animated:YES];
    }else if ([self.type isEqualToString:@"tianqi"]){
        TQYBViewController *tq=[[TQYBViewController alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:t_cityData forKey:@"tqcitydic"];
//        tq.tqdic=t_cityData;
        [self.navigationController pushViewController:tq animated:YES];
    }else if ([self.type isEqualToString:@"shikuang"]){
        SKGJViewController *sk=[[SKGJViewController alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:t_cityData forKey:@"shikuangdic"];
        [self.navigationController pushViewController: sk animated:YES];
    }else if ([self.type isEqualToString:@"亲情"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"qqservice" object:t_cityData];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([self.type isEqualToString:@"风雨"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fycx" object:t_cityData];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
//        if([[t_cityData objectForKey:@"city" ]isEqualToString:[setting sharedSetting].dingweicity])
//        {
//            
//        }else{
            if (![[setting sharedSetting].citys containsObject:dic]) {
                
                [[setting sharedSetting].citys addObject:dic];
//                NSLog(@"lalalala:%d",[setting sharedSetting].citys.count);
                [[setting sharedSetting] saveSetting];
            }
//        }
    [setting sharedSetting].currentCity=[t_cityData objectForKey:@"city"];
    [setting sharedSetting].currentCityID = [t_cityData objectForKey:@"ID"];
    [setting sharedSetting].morencity=[t_cityData objectForKey:@"city"];
    [setting sharedSetting].morencityID = [t_cityData objectForKey:@"ID"];
//        if(![[t_cityData objectForKey:@"ID" ]isEqualToString:[setting sharedSetting].dingweicity])
//        {
//            [setting sharedSetting].dingweicity=nil;
//        }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCity" object:nil];
    
    MFSideMenuContainerViewController * container =[self.navigationController.viewControllers objectAtIndex:1];
    [container togleCenterViewController];
        [self.navigationController popToViewController:container animated:NO];
    }
//    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[setting sharedSetting].morencity, @"city",[setting sharedSetting].morencityID,@"ID", nil];
//    if (![[setting sharedSetting].citys containsObject:dic]) {
//        
//        [[setting sharedSetting].citys addObject:dic];
//        NSLog(@"lalalala:%d",[setting sharedSetting].citys.count);
//        [[setting sharedSetting] saveSetting];
//    }
    
    //    [[setting sharedSetting].citys addObject:t_cityData];
    //    [[setting sharedSetting] saveSetting];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if ([m_provinceData count] != 0) {
		
		UIView *tview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
		
		UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectMake(0, 0, self.view.width, 40);
		btn.tag = section;
        btn.backgroundColor=[UIColor whiteColor];
		[btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
		[btn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchDown];
		[btn addTarget:self action:@selector(resetColor:) forControlEvents:UIControlEventTouchDragOutside];
		[tview addSubview:btn];
		
		NSString *t_name = [m_provinceData objectAtIndex:section];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
		[label setFont:[UIFont systemFontOfSize:16.5]];
		[label setTextColor:[UIColor blackColor]];
		[label setBackgroundColor:[UIColor clearColor]];
		label.text = [NSString stringWithFormat:@"    %@", t_name];
		[tview addSubview:label];
		
		UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"城市列表分隔线.png"]];
		[m_image setFrame:CGRectMake(0, 37, self.view.width, 1)];
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
        //		[m_Button release];
        return tview;
        //		return [tview autorelease];
	}
	return nil;
}

#pragma mark m_searchBarsearch

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	NSLog(@"searchText:%@", searchText);
    [secarrs removeAllObjects];
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
	[m_cityData removeAllObjects];
    [self.citys removeAllObjects];
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
		TreeNode *t_node_child = [t_node.children objectAtIndex:6];
		NSString *t_city = t_node_child.leafvalue;
        
		//-----------------------------------------------------------
		t_node_child = [t_node.children objectAtIndex:1];
		NSString *t_provinceID = t_node_child.leafvalue;
		NSString *t_province = [self getProvinceWithID:t_provinceID];
		t_node_child = [t_node.children objectAtIndex:3];
		NSString *t_pCity = t_node_child.leafvalue;
		//------------------------------------------------------------
        TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
        NSString *Id = t_node_child1.leafvalue;
        NSDictionary *t_cityData = [NSDictionary dictionaryWithObjectsAndKeys:t_city, @"city", t_province, @"province", t_pCity, @"pCity",Id,@"ID", nil];
		
		if ([t_city rangeOfString:searchText].length > 0)
		{
			[m_cityData addObject:t_cityData];
            [self.citys addObject:t_cityData];
			continue;
		}
		t_node_child = [t_node.children objectAtIndex:4];
		NSString *t_py = t_node_child.leafvalue;
		if ([[t_py uppercaseString] rangeOfString:[searchText uppercaseString]].length > 0)
		{
			[m_cityData addObject:t_cityData];
            [self.citys addObject:t_cityData];
			continue;
		}
		
		t_node_child = [t_node.children objectAtIndex:5];
		NSString *t_py2 = t_node_child.leafvalue;
		if ([[t_py2 uppercaseString] rangeOfString:[searchText uppercaseString]].length > 0)
		{
			[m_cityData addObject:t_cityData];
            [self.citys addObject:t_cityData];
			continue;
		}
	}
	[m_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[m_searchBar resignFirstResponder];
}
- (void)btnAction:(UIButton *)sender {
    //    [self performSelector:@selector(resetColor:) withObject:sender afterDelay:0.2];
    [m_searchBar resignFirstResponder];
    int tag=sender.tag;
    isShow = !isShow;
    if (isprovice==NO) {
        if ([sender tag] != sec) {
            isShow = YES;
            sec = [sender tag];
        }
    }
    
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
        
    }
    NSString *a=nil;
    if (secarrs.count>0) {
        a=secarrs[tag];
    }
    if (a.intValue==[secarrs count]-1) {
        [m_cityData removeAllObjects];
        if (isShow==YES) {
            NSMutableArray *marr=[[NSMutableArray alloc]init];
            for (NSString *value in self.citys) {
                [marr addObject:value];
            }
            
           m_cityData=marr;
        }
        
    }else{
    TreeNode *t_node = [m_province.children objectAtIndex:sec];
    TreeNode *t_node_child = [t_node.children objectAtIndex:0];
    m_provinceId = [t_node_child.leafvalue intValue];
    
    [m_cityData removeAllObjects];
    for (int i=0; i<[m_allCity.children count]; i++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        NSString *t_parentId = t_node_child.leafvalue;
        
        
        if ([t_parentId intValue] == m_provinceId)
        {
            t_node_child = [t_node.children objectAtIndex:2];
            NSString *t_name = t_node_child.leafvalue;
            
            //----------------------------------------------------
            t_node_child = [t_node.children objectAtIndex:3];
            NSString *t_pCity = t_node_child.leafvalue;
            NSString *t_province = [self getProvinceWithID:t_parentId];
            
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
            NSString *Id = t_node_child1.leafvalue;
            //----------------------------------------------------
            NSDictionary *t_cityData = [NSDictionary dictionaryWithObjectsAndKeys:t_name, @"city", t_province, @"province", t_pCity, @"pCity",Id,@"ID", nil];
            
            [m_cityData addObject:t_cityData];
        }
    }
    }
    //每点击段标题让标题置顶显示.
    //if ([sender tag] == [m_provinceData count] - 1)
    //NSIndexPath *index1 =[NSIndexPath indexPathFowRow:0 inSection:0];
    //[m_tableView scrollToRowAtIndexPath:index1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self performSelector:@selector(reloadData:) withObject:sender afterDelay:0.2];
	
    //	else if ([sender tag] == 0)
    //	{//定位当前城市
    //		NSString *t_str = [m_provinceData objectAtIndex:0];
    //		NSArray *t_array = [t_str componentsSeparatedByString:@" "];
    //		if ([t_array count] >= 2)
    //		{
    //			NSString *t_city = [t_array objectAtIndex:0];
    //
    //			//-------------------------遍历找出城市数据-----------------------------------------
    //			NSDictionary *t_cityData = nil;
    //
    //			for (int i = 0; i < [m_allCity.children count]; i ++)
    //			{
    //				TreeNode *t_node = [m_allCity.children objectAtIndex:i];
    //				TreeNode *t_node_child = [t_node.children objectAtIndex:1];
    //				NSString *t_parentId = t_node_child.leafvalue;
    //				t_node_child = [t_node.children objectAtIndex:2];
    //				NSString *t_name = t_node_child.leafvalue;
    //
    //				if ([t_city isEqualToString:t_name])
    //				{
    //					//----------------------------------------------------
    //					t_node_child = [t_node.children objectAtIndex:5];
    //					NSString *t_pCity = t_node_child.leafvalue;
    //					NSString *t_province = [self getProvinceWithID:t_parentId];
    //					//----------------------------------------------------
    //					t_cityData = [NSDictionary dictionaryWithObjectsAndKeys:t_name, @"city", t_province, @"province", t_pCity, @"pCity", nil];
    //					break;
    //				}
    //			}
    //
    //			if (t_cityData == nil)
    //				t_cityData = [NSDictionary dictionaryWithObjectsAndKeys:t_city, @"city", @"", @"province", @"", @"pCity", nil];
    //			//-------------------------------------------------------------------------------
    //
    //			[delegate didSelectedCity:t_cityData];
    //			[self.navigationController popViewControllerAnimated:YES];
    //		}
    ////		else
    ////		{
    ////			[self performSelector:@selector(startLocation)];
    ////		}
    //	}
    /*
     else if ([sender tag] == 1)
     {//钓鱼岛
     NSDictionary *t_cityData = [NSDictionary dictionaryWithObjectsAndKeys:@"钓鱼岛", @"city", @"钓鱼岛", @"province", @"", @"pCity", nil];
     
     [delegate didSelectedCity:t_cityData];
     [self.navigationController popViewControllerAnimated:YES];
     }
     //*/
}

- (void)resetColor:(id)sender
{
	UIButton *btn = (UIButton *)sender;
	btn.backgroundColor = nil;
}

- (void)changeColor:(id)sender
{
	UIButton *btn = (UIButton *)sender;
	btn.backgroundColor = [UIColor clearColor];
}

- (void) reloadData:(id)sender
{
	[m_tableView setContentOffset:CGPointMake(0, [sender tag]*33) animated:NO];
	[m_tableView reloadData];
}

- (void)searchDone:(id)sender
{
	[m_searchBar resignFirstResponder];
}

- (void)leftBtn:(id)sender
{
    if ([self.type isEqualToString:@"风雨"]) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    if (![setting sharedSetting].citys.count>0&&![setting sharedSetting].dingweicity.length>0) {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"请选择一个城市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        return;
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }

}


#pragma mark keyboardWillhe
- (void)changeShareContentHeight:(float)t_height withDuration:(float)t_dration
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:t_dration];
	[UIView setAnimationDelegate:self];
	[m_tableView setFrame:CGRectMake(10, 55+self.barHeight, self.view.width, kScreenHeitht-360)];
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
//	[self changeShareContentHeight:0.0 withDuration:animationDuration];
    [m_tableView setFrame:CGRectMake(10, 55+self.barHeight, self.view.width-20, kScreenHeitht)];
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
