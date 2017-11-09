//
//  AirDialog.m
//  ZtqNew
//
//  Created by linxg on 13-8-7.
//
//

#import "CityRankDialog.h"
#import "ShareFun.h"
#import "CityRankTVCell.h"
@interface CityRankDialog ()
@property(nonatomic,strong) NSMutableArray *PinYinarray;
@property(nonatomic, strong) NSMutableArray *provinceArray;//存储省份的数组

@end
@implementation CityRankDialog
@synthesize delegate,m_tableData,m_value,m_provinceAndcity;

- (NSMutableArray *)provinceArray {
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

-(NSMutableArray *)PinYinarray
{
    if (_PinYinarray==nil) {
        _PinYinarray=[[NSMutableArray alloc] init];
    }
    return _PinYinarray;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        float place = 0;
        if(kSystemVersionMore7)
        {
            place = 20;
        }
        self.barhight=place+44;
        
        
        m_pmcityNode=nil;
        isSearch=NO;
        
        //消除键盘透明按钮
        UIImageView *mybutton = [[UIImageView alloc] initWithFrame:self.bounds];
        [mybutton setBackgroundColor:[UIColor clearColor]];
//        [mybutton addTarget:self action:@selector(searchDone:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:mybutton];
        mybutton.backgroundColor = [UIColor grayColor];
        mybutton.alpha = 0.3;
        UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(45, 0, 245, 350)];
        [bgImageView setImage:[UIImage imageNamed:@"城市搜索底座（新）.png"]];
        
        
        [self addSubview:bgImageView];
        m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(61, 50, 215, 40)];
        m_searchBar.placeholder = @"选择省份或者城市";
        [m_searchBar setContentMode:UIViewContentModeLeft];
        [ShareFun cleanBackground:m_searchBar];
        
        m_searchBar.delegate = self;
        [self addSubview:m_searchBar];
        m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(68, 96, 200, 235) style:UITableViewStylePlain];
        m_tableView.backgroundColor = [UIColor clearColor];
        m_tableView.backgroundView=nil;
        m_tableView.autoresizesSubviews = YES;
        
        m_tableView.delegate = self;
        m_tableView.dataSource = self;
        [m_tableView registerClass:[CityRankTVCell class] forCellReuseIdentifier:@"CityRankTVCell"];
        m_tableData = [[NSMutableArray alloc] initWithCapacity:4];
        m_value = [[NSMutableArray alloc] initWithCapacity:4];
        m_provinceAndcity=[[NSMutableArray alloc] initWithCapacity:4];
        
        [self addSubview:m_tableView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 235, 35)];
        self.titleLabel.text = @"省份 / 城市";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor colorWithRed:27 /255.0 green:153 /255.0 blue:221 /255.0 alpha:1.0];
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        self.titleLabel.layer.cornerRadius = 4;
        self.titleLabel.layer.masksToBounds = YES;
    
        self.titleLabel.backgroundColor = [UIColor  clearColor];
        [bgImageView addSubview:self.titleLabel];
        
    }
    return self;
}
-(void)setData:(NSArray *)t_array1 Value:(NSArray *)t_array2{
    
    m_tableData=nil;
    m_provinceAndcity=nil;
    m_value=nil;
    m_provinceAndcity=[[NSMutableArray alloc]initWithArray:t_array1];
    m_value=[NSMutableArray arrayWithArray:t_array2];
    m_tableData=[[NSMutableArray alloc]initWithArray:m_provinceAndcity];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //获取省份的拼音
        [self.provinceArray removeAllObjects];
        for (NSString *obj in m_provinceAndcity) {
            NSString *pri = [obj componentsSeparatedByString:@","].firstObject;
            if (![self.provinceArray containsObject:pri]) {
                [self.provinceArray addObject:pri];
            }
        }
        
        for (NSString *provi in self.provinceArray) {
            NSMutableString *ms = [[NSMutableString alloc] initWithString:provi];
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                //                NSLog(@"Pingying: %@", ms); // wǒ shì zhōng guó rén
            }
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                //                NSLog(@"Pingying: %@", ms); // wo shi zhong guo ren
            }
            if(ms){
                NSString *NOspaceStr=[NSString stringWithFormat:@" %@ ", ms];
                [self.PinYinarray addObject:NOspaceStr];
            }
            
        }
        for (NSString *value in m_value) {
            NSMutableString *ms = [[NSMutableString alloc] initWithString:value];
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                //                NSLog(@"Pingying: %@", ms); // wǒ shì zhōng guó rén
            }
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                //                NSLog(@"Pingying: %@", ms); // wo shi zhong guo ren
            }
            if(ms){
                NSString *NOspaceStr=[NSString stringWithFormat:@" %@ ", ms];
                [self.PinYinarray addObject:NOspaceStr];
            }
        }
    });
    
}
-(void)buttonClick:(id)sender{
    
    [self removeFromSuperview];
    
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
#pragma mark tableView delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return m_tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityRankTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityRankTVCell" forIndexPath:indexPath];
    //cell的内容
    NSString *value=[m_tableData objectAtIndex:indexPath.row];
    {
        if (isSearch==NO) {
            NSArray *array=[value componentsSeparatedByString:@","];
            NSString *pro=[array objectAtIndex:0];
            NSString *city=[array objectAtIndex:1];
           [cell updataWithProvince:pro city:city];
        }
        else{
            [cell updataWithOnlyValue:value];
        }
    }
    cell.backgroundColor=[UIColor clearColor];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (isSearch==YES) {
        NSString *string=[m_tableData objectAtIndex:row];
        if (delegate!=nil) {
            //判断是否是省份
            BOOL isProvince = [self.provinceArray containsObject:string];
            [delegate selectTable:string isProvince:isProvince];
            [self removeFromSuperview];
        }
    }
    else{
        NSString *string=[m_value objectAtIndex:row];
        if (delegate!=nil) {
            //判断是否是省份
            BOOL isProvince = [self.provinceArray containsObject:string];
            [delegate selectTable:string isProvince:isProvince];
            [self removeFromSuperview];
        }
    }
    
}

#pragma mark m_searchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if([searchText isEqualToString:@""] || searchText==nil){
		m_tableData=[[NSMutableArray alloc]initWithArray:m_provinceAndcity];
		isSearch = NO;
		[m_tableView reloadData];
		return;
	}
	
	isSearch = YES;
    //读取xml
//    if (m_pmcityNode) {
//        [m_tableData removeAllObjects];
//        
//        for (int i=0; i<[m_pmcityNode.children count]; i++)
//        {
//            TreeNode *t_node = [m_pmcityNode.children objectAtIndex:i];
//            TreeNode *t_node_child = [t_node.children objectAtIndex:1];
//            NSString *t_city = t_node_child.leafvalue;
//            
//            if ([t_city rangeOfString:searchText].length > 0)
//            {
//                [m_tableData addObject:t_city];
//                continue;
//            }
//            
//            t_node_child = [t_node.children objectAtIndex:2];
//            NSString *t_py = t_node_child.leafvalue;
//            if ([[t_py uppercaseString] rangeOfString:[searchText uppercaseString]].length > 0)
//            {
//                [m_tableData addObject:t_city];
//                continue;
//            }
//            
//        }
//    }
    [m_tableData removeAllObjects];
    NSMutableString *ms = [[NSMutableString alloc] initWithString:searchText];
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
        //                NSLog(@"Pingying: %@", ms); // wǒ shì zhōng guó rén
    }
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        //                NSLog(@"Pingying: %@", ms); // wo shi zhong guo ren
    }
    BOOL ischinese = [self isChinese:searchText];
    NSString *new;
    new = ms;
    if (ischinese) {
        new = [NSString stringWithFormat:@" %@ ", ms];
    }
    
    if (self.PinYinarray) {
        for (int i=0; i<self.PinYinarray.count; i++) {
            
            if ([[self.PinYinarray[i] uppercaseString] rangeOfString:[new uppercaseString]].length>0) {
                if (i <= self.provinceArray.count -1) {
                    if (ischinese) {
                        NSString *str = self.provinceArray[i];
                        if ( [str rangeOfString:searchText].length > 0) {
                            
                            [m_tableData addObject:self.provinceArray[i]];
                        }
                    }else {
                        [m_tableData addObject:self.provinceArray[i]];
                    }
                }else {
                    if (ischinese) {
                        NSString *str = self.m_value[i - self.provinceArray.count];
                        if ( [str rangeOfString:searchText].length > 0) {
                            
                            [m_tableData addObject:str];
                        }
                    }else {
                        [m_tableData addObject:self.m_value[i - self.provinceArray.count]];
                    }
                    
                }
            }
        }
    }
    [m_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[m_searchBar resignFirstResponder];
}

- (void)searchDone:(id)sender
{   [self endEditing:YES];
	[m_searchBar resignFirstResponder];
}

#pragma mark xml delegate

-(void)readFinish:(TreeNode *)p_treeNode withFlag:(int)p_flag
{
	if(p_flag == 1)
	{
		m_pmcityNode = p_treeNode;
		NSLog(@"pm25city list load finish!");
	}
}

#pragma mark - 判断是搜索汉字还在字母

- (BOOL)isChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    } return NO;
}

@end
