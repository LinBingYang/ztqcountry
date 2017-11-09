    //
//  typhoonVC.m
//  ZtqNew
//
//  Created by lihj on 12-11-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "typhoonVC.h"
#import "ShareFun.h"
#import "CustomActionSheet.h"
#import "tfDetailView.h"
//#import "NetWorkCenter.h"
#import "TFSheet.h"
@implementation typhoonVC

@synthesize plugin = _plugin;
@synthesize currentCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cancj=YES;
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
    _navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1];
    [self.view addSubview:_navigationBarBg];
    
    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(15, 7+place, 30, 30)];
    [_leftBut setBackgroundImage:[UIImage imageNamed:@"cssz返回.png"] forState:UIControlStateNormal];
    [_leftBut setBackgroundImage:[UIImage imageNamed:@"cssz返回点击.png"] forState:UIControlStateHighlighted];
    [_leftBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 7+place, kScreenWidth-100, 30)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor whiteColor];
    [_navigationBarBg addSubview:_titleLab];
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    self.tfmodels=[[NSMutableArray alloc]init];
    
    m_btnPlay = [[UIBarButtonItem alloc] initWithTitle:@"播放" style:UIBarButtonItemStyleBordered target:self action:@selector(playMap)],
	self.toolbarItems = [NSArray arrayWithObjects:
						 [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
						 m_btnPlay,
						 [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
						 [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"whereMe.png"] style:UIBarButtonItemStylePlain target:self action:@selector(find)],
						 [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
						 [[UIBarButtonItem alloc] initWithTitle:@"图例" style:UIBarButtonItemStyleBordered target:self action:@selector(explain)],
						 [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
						 [[UIBarButtonItem alloc] initWithTitle:@"台风列表" style:UIBarButtonItemStyleBordered target:self action:@selector(history)],
						 [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
						 [[UIBarButtonItem alloc] initWithTitle:@"地图切换" style:UIBarButtonItemStyleBordered target:self action:@selector(change)],
						 [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
						 nil
						 ];
    
	selectedPickerRow = 0;
	m_mapMode = 1;
	tf_list = [[NSMutableArray alloc] initWithCapacity:3];
	
    
	[self performSelector:@selector(getTyphoonYearData) withObject:nil afterDelay:0.1];
}


- (void)backAction
{
    
	BOOL t_ifLegendDisplay = [m_typhoonView ifLegendDisplay];
	if (t_ifLegendDisplay) {
		return;
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"stopTyphoonTimer" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"stopPlayTimer" object:nil];
	//[mainEntry addMenuVC];
	[self.navigationController setToolbarHidden:YES animated:YES];
	[self.navigationController popViewControllerAnimated:!kSystemVersionMore7];
	//[super backAction];
}

#pragma mark download Data


- (void) getTyphoonYearData
{
	[MBProgressHUD showHUDAddedTo:self.view animated:NO];
	
	NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *ftlist = [[NSMutableDictionary alloc]init];

	[t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [ftlist setObject:@"2014" forKey:@"year"];
	[t_b setObject:ftlist forKey:@"tfList"];
	[t_dic setObject:t_h forKey:@"h"];
	[t_dic setObject:t_b forKey:@"b"];
	
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        NSLog(@"%@",returnData);
        //NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_dic == nil)
        {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            return;
        }
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        if (t_b != nil)
        {
            NSArray *t_array = [[t_b objectForKey:@"tfList"] objectForKey:@"typhoons"];
            if (t_array != nil)
            {
                NSInteger index = 0;
                [tf_list removeAllObjects];
                for (int i = 0; i < [t_array count]; i ++)
                {
                    typhoonYearModel *tf_Model = [[typhoonYearModel alloc] init];
                    tf_Model.name = [[t_array objectAtIndex:i] objectForKey:@"name"];
                    tf_Model.code = [[t_array objectAtIndex:i] objectForKey:@"code"];
                    tf_Model.date = [[t_array objectAtIndex:i] objectForKey:@"date"];
                    
                    if ([tf_Model.code isEqualToString:self.currentCode])
                        index = i;
                    
                    [tf_list addObject:tf_Model];
                    
                }
                
                selectedPickerRow = index;
                typhoonYearModel *tf_Model = (typhoonYearModel *)[tf_list objectAtIndex:index];
                m_title = tf_Model.name;
                
//                [self setTitle:m_title];
                self.titleLab.text=m_title;
                [self performSelector:@selector(getTyphoonDetailData:) withObject:tf_Model.code];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
    

}

- (void) getTyphoonDetailData:(NSString *)code
{
    

	[MBProgressHUD showHUDAddedTo:self.view animated:NO];
	
	NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *tfpath = [NSMutableDictionary dictionaryWithCapacity:4];

	[t_h setObject:[setting sharedSetting].app forKey:@"p"];

	
	
	[tfpath setObject:code forKey:@"code"];
	[t_b setObject:tfpath forKey:@"tfPath"];
	[t_dic setObject:t_h forKey:@"h"];
	[t_dic setObject:t_b forKey:@"b"];
    
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        NSLog(@"%@",returnData);
        if (t_dic == nil)
		{
			[MBProgressHUD hideHUDForView:self.view animated:NO];
			return;
		}
		NSDictionary *t_b = [returnData objectForKey:@"b"];
		if (t_b != nil)
		{
			NSDictionary *typhoon = [[t_b objectForKey:@"tfPath"] objectForKey:@"typhoon"];
			
			tf_yearModel = [[typhoonYearModel alloc] init];
			tf_yearModel.name = [typhoon objectForKey:@"name"];
			tf_yearModel.code = [typhoon objectForKey:@"code"];
			m_title = tf_yearModel.name;
//            [self setTitle:m_title];
            self.titleLab.text=m_title;
			NSArray *t_arr0 = [typhoon objectForKey:@"dotted_1_points"];
			NSMutableArray *t_tf0 = [NSMutableArray arrayWithCapacity:4];
			for (int i=0; i<[t_arr0 count]; i++) {
				typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
				
				detailModel.jd = [[t_arr0 objectAtIndex:i] objectForKey:@"jd"];
				detailModel.tip = [[t_arr0 objectAtIndex:i] objectForKey:@"tip"];
				detailModel.wd = [[t_arr0 objectAtIndex:i] objectForKey:@"wd"];
				
				[t_tf0 addObject:detailModel];
                //				[detailModel release];
			}
			tf_yearModel.dotted_1_points = t_tf0;
			
			NSArray *t_arr1 = [typhoon objectForKey:@"dotted_2_points"];
			NSMutableArray *t_tf1 = [NSMutableArray arrayWithCapacity:4];
			for (int i=0; i<[t_arr1 count]; i++) {
				typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
				
				detailModel.jd = [[t_arr1 objectAtIndex:i] objectForKey:@"jd"];
				detailModel.tip = [[t_arr1 objectAtIndex:i] objectForKey:@"tip"];
				detailModel.wd = [[t_arr1 objectAtIndex:i] objectForKey:@"wd"];
				
				[t_tf1 addObject:detailModel];
                //				[detailModel release];
			}
			tf_yearModel.dotted_2_points = t_tf1;
			
			NSArray *t_arr2 = [typhoon objectForKey:@"dotted_points"];
			NSMutableArray *t_tf2 = [NSMutableArray arrayWithCapacity:4];
			for (int i=0; i<[t_arr2 count]; i++) {
				typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
				
				detailModel.jd = [[t_arr2 objectAtIndex:i] objectForKey:@"jd"];
				detailModel.tip = [[t_arr2 objectAtIndex:i] objectForKey:@"tip"];
				detailModel.wd = [[t_arr2 objectAtIndex:i] objectForKey:@"wd"];
				
				[t_tf2 addObject:detailModel];
                //				[detailModel release];
			}
			tf_yearModel.dotted_points = t_tf2;
			
			NSArray *t_arr3 = [typhoon objectForKey:@"ful_points"];
			NSMutableArray *t_tf3 = [NSMutableArray arrayWithCapacity:4];
			for (int i=0; i<[t_arr3 count]; i++) {
				typhoonDetailModel *detailModel = [[typhoonDetailModel alloc] init];
				
				detailModel.fl = [[t_arr3 objectAtIndex:i] objectForKey:@"fl"];
				detailModel.fl_10 = [[t_arr3 objectAtIndex:i] objectForKey:@"fl_10"];
				detailModel.fl_7 = [[t_arr3 objectAtIndex:i] objectForKey:@"fl_7"];
				detailModel.fs = [[t_arr3 objectAtIndex:i] objectForKey:@"fs"];
				detailModel.fs_max = [[t_arr3 objectAtIndex:i] objectForKey:@"fs_max"];
				detailModel.jd = [[t_arr3 objectAtIndex:i] objectForKey:@"jd"];
				detailModel.qy = [[t_arr3 objectAtIndex:i] objectForKey:@"qy"];
				detailModel.time = [[t_arr3 objectAtIndex:i] objectForKey:@"time"];
				detailModel.tip = [[t_arr3 objectAtIndex:i] objectForKey:@"tip"];
				detailModel.wd = [[t_arr3 objectAtIndex:i] objectForKey:@"wd"];
				
				[t_tf3 addObject:detailModel];
                //				[detailModel release];
			}
			tf_yearModel.ful_points = t_tf3;
			[MBProgressHUD hideHUDForView:self.view animated:NO];
			[self performSelector:@selector(drawTyphoonMap)];
		}

    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
	

}


- (void)drawTyphoonMap
{
	if (m_typhoonView) {
		[m_typhoonView removeFromSuperview];
		m_typhoonView = nil;
	}
	m_typhoonView = [[typhoonView alloc] initWithFrame:CGRectMake(0, 0+self.barHeight, self.view.frame.size.width, kScreenHeitht)];
	[m_typhoonView setDelegate:self];
	[m_typhoonView setMapModel:tf_yearModel];
	[self.view addSubview:m_typhoonView];
	[m_typhoonView showMapRoute];
	[m_typhoonView changeMapMode:m_mapMode];
//	[m_typhoonView release];
}


#pragma mark delegate
-(void)didSelectedTf:(NSInteger)row
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"stopTyphoonTimer" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"stopPlayTimer" object:nil];
	
	typhoonYearModel *tf_Model = (typhoonYearModel *)[tf_list objectAtIndex:row];
	m_title = tf_Model.name;
	//[self setTitle:m_title withTitleFont:[UIFont boldSystemFontOfSize:20]];
//	[self setTitle:m_title];
//    self.titleLab.text=m_title;
    self.titleLab.text=m_title;
	[self performSelector:@selector(getTyphoonDetailData:) withObject:tf_Model.code];
	
	m_btnPlay.title = @"播放";
}

- (void) playMapOver
{
	m_btnPlay.title = @"播放";
}

- (void) choiceMapMode:(NSInteger)t_mode
{
	m_mapMode = t_mode;
}

-(void)showBottom
{
	[self.navigationController setToolbarHidden:NO animated:YES];
	//[self setTitle:m_title withTitleFont:[UIFont boldSystemFontOfSize:20]];
//	[self setTitle:m_title];
    self.titleLab.text=m_title;
}

#pragma mark the 5 bottom btn action
- (void) playMap
{
	if ([m_btnPlay.title isEqualToString:@"播放"]) 
	{
		[m_typhoonView didPlayMap];
		m_btnPlay.title = @"停止";
	}
	else if ([m_btnPlay.title isEqualToString:@"停止"]) 
	{
		[m_typhoonView didStopMap];
		m_btnPlay.title = @"播放";
	}
}

- (void) find
{
   
	[m_typhoonView didFindSelf];
}	

- (void) explain
{
    
	[m_typhoonView didImageExplain];
	//self.navigationController.navigationBarHidden = YES;
	[self.navigationController setToolbarHidden:YES animated:YES];
//	[self setTitle:@"图例"];
    self.titleLab.text=@"图例";
    if (kSystemVersionMore7) {
        self.edgesForExtendedLayout=UIEventSubtypeNone;
    }
}

- (void) history
{
   
   
//	CustomActionSheet* sheet = [[CustomActionSheet alloc] initWithHeight:284.0f WithSheetTitle:@"选择要查看的台风"
//															 withLeftBtn:@"返回" withRightBtn:@"确认"];
//	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
//    if (kSystemVersionMore7) {
//        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, -15, 320, 155)];
//    }
//	pickerView.dataSource = self;
//    pickerView.delegate=self;
//    pickerView.showsSelectionIndicator=YES;
//	[pickerView selectRow:selectedPickerRow inComponent:0 animated:YES];
//	
//    [sheet.view addSubview:pickerView];
//	[sheet setDelegate:self];
//	[sheet showInView:[UIApplication sharedApplication].keyWindow];
    TFSheet *tfsheet=[[TFSheet alloc] initWithHeight:250 WithSheetTitle:@"选择要查看的台风"
                                         withLeftBtn:@"返回" withRightBtn:@"确认"];
	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 216)];
    if (kSystemVersionMore7) {
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth, 155)];
    }
	pickerView.dataSource = self;
    pickerView.delegate=self;
    pickerView.showsSelectionIndicator=YES;
    //    pickerView.userInteractionEnabled=YES;
	[pickerView selectRow:selectedPickerRow inComponent:0 animated:YES];
	
    [tfsheet.sheetBgView addSubview:pickerView];
	[tfsheet setDelegate:self];
    //	[sheet showInView:[UIApplication sharedApplication].keyWindow];
    [tfsheet show];

}

- (void) change
{
	[m_typhoonView didChangeMap];
}

#pragma mark CustomActionSheetDelegate
- (void)doneBtnClicked
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"stopTyphoonTimer" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"stopPlayTimer" object:nil];
	
	typhoonYearModel *tf_Model = (typhoonYearModel *)[tf_list objectAtIndex:selectedPickerRow];
	m_title = tf_Model.name;
	//[self setTitle:m_title withTitleFont:[UIFont boldSystemFontOfSize:20]];
//	[self setTitle:m_title];
    self.titleLab.text=m_title;
	[self performSelector:@selector(getTyphoonDetailData:) withObject:tf_Model.code];
	self.currentCode = tf_Model.code;
	
	m_btnPlay.title = @"播放";
}

#pragma mark -
#pragma mark Picker Date Source Methods
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [tf_list count];
}

#pragma mark Picker Delegate Methods
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	typhoonYearModel *tf_year = (typhoonYearModel *)[tf_list objectAtIndex:row];
    return tf_year.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	selectedPickerRow = row;
}

@end
