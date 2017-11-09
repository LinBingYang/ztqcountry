//
//  AirDialog.m
//  ZtqNew
//
//  Created by linxg on 13-8-7.
//
//

#import "AirDialog.h"

@implementation AirDialog
@synthesize delegate,m_label,m_tableData,m_value,m_type;
//-(void)dealloc{
//    [super dealloc];
//    [m_tableView release];
//    [m_tableData release];
//    [m_value release];
//    [delegate release];
//    [bgscrollview release];
//
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *bgview=[[UIImageView alloc]initWithFrame:self.bounds];
        bgview.backgroundColor=[UIColor grayColor];
        bgview.alpha = 0.3;
        [self addSubview:bgview];
        //        [bgview release];
        
        float place = 0;
        if(kSystemVersionMore7)
        {
            place = 20;
        }
        self.barhight=place+44;
        
        UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(50, 0, 245, 300)];
                [bgImageView setImage:[UIImage imageNamed:@"指数底框.png"]];

        [self addSubview:bgImageView];
        
//        UIImageView * barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 245, 55)];
//        barImageView.image = [UIImage imageNamed:@"空气弹窗顶部1.png"];
//        [bgImageView addSubview:barImageView];
//        
//        UIImageView * bodyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, 245, 300)];
//        bodyImageView.image = [UIImage imageNamed:@"空气弹窗背景背景1.png"];
//        [bgImageView addSubview:bodyImageView];
        
        
        //        [bgImageView release];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 220, 30)];
        self.titleLabel.text = @"指数类型";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor colorWithRed:27 /255.0 green:153 /255.0 blue:221 /255.0 alpha:1.0];
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        
        m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(60, 40, 220, 245) style:UITableViewStylePlain];
        
        m_tableView.backgroundColor = [UIColor clearColor];
        m_tableView.backgroundView=nil;
        m_tableView.autoresizesSubviews = YES;
        //      m_tableView.showsHorizontalScrollIndicator = NO;
        //     m_tableView.showsVerticalScrollIndicator = NO;
        
        m_tableView.delegate = self;
        m_tableView.dataSource = self;
        
        m_tableData = [[NSMutableArray alloc] initWithCapacity:4];
        m_value = [[NSMutableArray alloc] initWithCapacity:4];
        
        bgscrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(60, 30, 220, 270)];
        
        
        
        m_label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220,350)];
        [m_label setTextAlignment:NSTextAlignmentJustified];
        [m_label setBackgroundColor:[UIColor clearColor]];
        [m_label setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [m_label setTextColor:[UIColor blackColor]];
        //    m_label.shadowColor = [UIColor blackColor];
        m_label.lineBreakMode = NSLineBreakByWordWrapping;
        m_label.numberOfLines = 0;
        [bgscrollview addSubview:m_label];
        
        
        
        
    }
    return self;
}
-(void)initWithArray:(NSArray*)t_array1 Value:(NSArray*)t_array2 labelString:(NSString*)t_string
                flag:(dialogType)t_type{
    
    [m_tableData removeAllObjects];
    [m_value removeAllObjects];
    m_tableData=nil;
    m_value=nil;
    m_tableData=[[NSMutableArray alloc]initWithArray:t_array1];
    m_value=[[NSMutableArray alloc]initWithArray:t_array2];
    if (bgscrollview) {
        [bgscrollview removeFromSuperview];
    }
    if (m_tableView) {
        [m_tableView removeFromSuperview];
    }
    if (self.titleLabel) {
        [self.titleLabel removeFromSuperview];
    }
    if (t_type==dialog_label) {
        [self addSubview:bgscrollview];
        //    [bgscrollview addSubview:m_label];
        CGSize size=[t_string sizeWithFont:m_label.font constrainedToSize:CGSizeMake(m_label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        [m_label setFrame:CGRectMake(0, 0, 220, size.height+5)];
        bgscrollview.contentSize=CGSizeMake(220, size.height+5);
        m_label.text=t_string;
        
    }else{
        [self addSubview:self.titleLabel];
        [self addSubview:m_tableView];
        
    }
    self.m_type=t_type;
    
//    UIButton *close=[UIButton buttonWithType:UIButtonTypeCustom];
//    close.frame=CGRectMake(62, 30+self.barhight, 30, 30);
//    [close setBackgroundImage:[UIImage imageNamed:@"cssz返回.png"] forState:UIControlStateNormal];
//    [close setBackgroundImage:[UIImage imageNamed:@"cssz返回点击.png"] forState:UIControlStateHighlighted];
//    [close addTarget:self  action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    close.tag=100;
//    [self addSubview:close];
    
    //*/
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
	NSInteger row = indexPath.row;
	NSInteger section = indexPath.section;
	NSString *t_str = [NSString stringWithFormat:@"%ld_%ld", (long)section, (long)row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:t_str];
    if (cell) {
        [cell removeFromSuperview];
    }
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
    //cell的内容
    {
        if (self.m_type==dialog_city) {
            NSString *value=[m_tableData objectAtIndex:row];
            NSArray *array=[value componentsSeparatedByString:@","];
            NSString *pro=[array objectAtIndex:0];
            NSString *city=[array objectAtIndex:1];
            UILabel *cell_label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50,30)];
            [cell_label1 setTextAlignment:NSTextAlignmentLeft];
            [cell_label1 setBackgroundColor:[UIColor clearColor]];
            [cell_label1 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            cell_label1.text=pro;
            [cell_label1 setTextColor:[UIColor blackColor]];
            
            UILabel *cell_label2=[[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100,30)];
            [cell_label2 setTextAlignment:NSTextAlignmentLeft];
            [cell_label2 setBackgroundColor:[UIColor clearColor]];
            [cell_label2 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            cell_label2.text=city;
            [cell_label2 setTextColor:[UIColor blackColor]];
            [cell.contentView addSubview:cell_label1];
            [cell.contentView addSubview:cell_label2];
            //            [cell_label1 release];
            //            [cell_label2 release];
        }
        else{
            NSString *value=[m_tableData objectAtIndex:row];
            UILabel *cell_label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200,30)];
            [cell_label setTextAlignment:NSTextAlignmentCenter];
            [cell_label setBackgroundColor:[UIColor clearColor]];
            [cell_label setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            cell_label.text=value;
            [cell_label setTextColor:[UIColor blackColor]];
            [cell.contentView addSubview:cell_label];
            //            [cell_label release];
            
            
        }
    }
    cell.backgroundColor=[UIColor clearColor];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (delegate!=nil) {
        [delegate selectTable:row type:self.m_type];
        [self removeFromSuperview];
        
    }
    
}
@end
