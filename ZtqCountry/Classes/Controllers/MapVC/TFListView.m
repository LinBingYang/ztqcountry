//
//  TFListView.m
//  ZtqCountry
//
//  Created by Admin on 15/6/30.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "TFListView.h"
#import <QuartzCore/QuartzCore.h>
@implementation TFListView

@synthesize delegate,list,button,listView,lineColor,listBgColor;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        oldFrame = frame; //未下拉时控件初始大小
        newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height * 4.5);
        
        //默认的下拉列表中的数据
        list = [[NSArray alloc] initWithObjects:nil];
        showList = NO; //默认不显示下拉框
        lineColor = [UIColor colorHelpWithRed:221 green:221 blue:221 alpha:1];//默认列表边框线为灰色
        lineWidth = 1;     //默认列表边框粗细为1
        listBgColor = [UIColor whiteColor];//默认列表框背景色为白色
        //把背景色设置为透明色，否则会有一个黑色的边
        self.backgroundColor = [UIColor clearColor];
        [self drawView];//调用方法，绘制控件
        
    }
    return self;
}
- (void) drawView{
    //按钮
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [button addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    //    [button setBackgroundColor:[UIColor redColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"台风列表选择框.png"] forState:UIControlStateNormal];
    //    	[button setBackgroundImage:[UIImage imageNamed:@"气象产品新_03点击.png"] forState:UIControlStateHighlighted];
    UIImageView *xiaimg=[[UIImageView alloc]initWithFrame:CGRectMake(button.frame.size.width-28, 5, 20, 20)];
    xiaimg.image=[UIImage imageNamed:@"台风路径下拉指示.png"];
    [button addSubview:xiaimg];
    //下拉列表
    listView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                             oldFrame.size.height,
                                                             160,
                                                             260)];
    [self addSubview:listView];
    //	[listView release];
    
    listView.dataSource = self;
    listView.delegate = self;
    listView.backgroundColor = listBgColor;
    listView.alpha = 0.0;
    //    listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    listView.showsVerticalScrollIndicator = YES;
    listView.alwaysBounceVertical = YES;
    listView.layer.borderWidth = 1;
    listView.userInteractionEnabled=YES;
    [listView.layer setCornerRadius:8.0];
    listView.layer.borderColor = [UIColor colorHelpWithRed:221 green:221 blue:221 alpha:1].CGColor;
    listView.separatorColor = lineColor;
    
    UIButton *closebtn=[[UIButton alloc]initWithFrame:CGRectMake(0, oldFrame.size.height+260, kScreenWidth-40, 30)];
    [closebtn setTitle:@"确认" forState:UIControlStateNormal];
    closebtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [closebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closebtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closebtn];
    
    NSUserDefaults *loveCity = [NSUserDefaults standardUserDefaults];
    NSArray *favCity = [loveCity objectForKey:@"mytf"];
    
    self.mytflist = [[NSMutableArray alloc] initWithArray:favCity];
}

- (void) setList:(NSArray *)t_array
{
    //	[list release];
    //	list = [t_array retain];
    list = t_array;
    
    CGRect frame = oldFrame;
    
    float count = [list count];
    if (count > 10)
        count = 9.5;
    
    newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 30 * (count + 1));
    listView.frame = CGRectMake(20,
                                oldFrame.size.height,
                                oldFrame.size.width - 20 * 2,
                                260);
    [listView reloadData];
}

-(void) dropdown{
    
    
    float count = [list count];
    if (count > 10)
        count = 9.5;
    
    listView.frame = CGRectMake(20,
                                oldFrame.size.height,
                                oldFrame.size.width - 20 * 2,
                                260);
    
    
    
    if (showList) {//如果下拉框已显示，隐藏起来
        [self setShowList:NO];
        return;
    }else {//如果下拉框尚未显示，则进行显示
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        [self.superview bringSubviewToFront:self];
        [self setShowList:YES];//显示下拉框
    }
    [listView reloadData];
}

#pragma mark listViewdataSource method and delegate method
- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return [list count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"listviewid";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell != nil){
        [cell removeFromSuperview];
    }
    //	cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
    //								  reuseIdentifier:cellid]autorelease];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:cellid];
    NSString *name=nil;
    
        typhoonYearModel *ty=[list objectAtIndex:indexPath.row];
       name=ty.name;
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:ty.code, @"code", ty.name, @"name", nil];
    //文本标签
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, oldFrame.size.width-40, 30)];
    lab.text=name;
    lab.numberOfLines=0;
    lab.font=[UIFont systemFontOfSize:15];
    lab.textAlignment=NSTextAlignmentCenter;
    [cell addSubview:lab];
    //    cell.textLabel.text = (NSString*)[list objectAtIndex:indexPath.row];
    //    cell.textLabel.numberOfLines=0;
    //    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    
    UIImageView * xzimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-85, 5, 25, 25)];
    
    xzimg.tag=20;
    [cell.contentView addSubview:xzimg];
    if ([self.mytflist containsObject:dic])
    {
        
        xzimg.image=[UIImage imageNamed:@"选中框"];
        
    }else
    {
        
        xzimg.image=[UIImage imageNamed:@"未选中框"];
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, oldFrame.size.height-1, oldFrame.size.width, 1)];
    line.backgroundColor=[UIColor colorHelpWithRed:221 green:221 blue:221 alpha:1];
    [cell addSubview:line];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return oldFrame.size.height;
}

- (void)deselect
{
    [listView deselectRowAtIndexPath:[listView indexPathForSelectedRow] animated:YES];
    [self setShowList:NO];
}

//当选择下拉列表中的一行时，设置文本框中的值，隐藏下拉列表
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setShowList:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tflistdidSelect:withIndex:)]){
        [self.delegate tflistdidSelect:self withIndex:indexPath.row];
    }
}

- (BOOL) getShowList{//setShowList:No为隐藏，setShowList:Yes为显示
    return showList;
}

- (void) setShowList:(BOOL)b{
    
    
    if (showList == b)
        return;
    
    showList = b;
    NSLog(@"showlist is set ");
    [listView reloadData];
    if(showList){
        listView.alpha = 0.0;
        self.frame = newFrame;
        [UIView animateWithDuration:0.1
                         animations:^{
                             listView.alpha = 1.0;
                             
                         }
                         completion:^(BOOL finished){
                             
                             if (finished)
                             {
                                 
                             }
                             
                         }];
        
        
    }else {
        listView.alpha = 1.0;
        self.frame = oldFrame;
        [UIView animateWithDuration:0.1
                         animations:^{
                             listView.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             if (finished)
                             {
                             }
                             
                         }];
    }
}
-(void)okAction{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(tfActionwith:)]) {
        [self.delegate tfActionwith:self.mytflist];
    }
}
@end
