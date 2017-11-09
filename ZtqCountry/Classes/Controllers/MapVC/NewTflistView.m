//
//  NewTflistView.m
//  ZtqCountry
//
//  Created by Admin on 16/2/16.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "NewTflistView.h"

@implementation NewTflistView
-(id)initWithFrame:(CGRect)frame WithTFdatas:(NSArray *)tflist{
    self = [super initWithFrame:CGRectMake(0, 140, kScreenWidth, kScreenHeitht)];
    if (self) {
        UIImageView * fuzzyImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
        fuzzyImgV.backgroundColor = [UIColor clearColor];
//        fuzzyImgV.alpha = 0.3;
        [self addSubview:fuzzyImgV];
        
        self.tflists=tflist;
        
        _backgroundImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 300)];
        _backgroundImgV.backgroundColor=[UIColor whiteColor];
        _backgroundImgV.userInteractionEnabled = YES;
        [self addSubview:_backgroundImgV];
        _backgroundImgV.layer.cornerRadius=5;
        
        
        m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth-40,260) style:UITableViewStylePlain];
        m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        m_tableView.backgroundColor=[UIColor clearColor];
        m_tableView.backgroundView=nil;
        m_tableView.delegate = self;
        m_tableView.dataSource = self;
        [_backgroundImgV addSubview:m_tableView];
        UIButton *closebtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 265, kScreenWidth-40, 30)];
        [closebtn setTitle:@"确认" forState:UIControlStateNormal];
        closebtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [closebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [closebtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImgV addSubview:closebtn];
        
        NSUserDefaults *loveCity = [NSUserDefaults standardUserDefaults];
        NSArray *favCity = [loveCity objectForKey:@"mytf"];
        
        self.mytflist = [[NSMutableArray alloc] initWithArray:favCity];
        //        typhoonYearModel *tf_year = (typhoonYearModel *)[self.tflists objectAtIndex:0];
        //        NSString *code=tf_year.code;
        //        NSString *name=tf_year.name;
        //        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:code, @"code", name, @"name", nil];
        //        if (![self.mytflist containsObject:dic]) {
        //            [self.mytflist insertObject:dic atIndex:0];
        //        }
    }
    return self;
}
-(void)backAction{
    [self removeFromSuperview];
}

-(void)show
{
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    //    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.1, 0.1);
    //    _backgroundImgV.transform = scaleTransform;
    //    [UIView ani]
    
    [UIView animateWithDuration:0.2 animations:^{
        //        _backgroundImgV.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            //            _backgroundImgV.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                //                _backgroundImgV.transform = CGAffineTransformMakeScale(1.05, 1.05);
            } completion:^(BOOL finished) {
                //                _bgImgV.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
        _backgroundImgV.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tflists.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 37;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    int section = indexPath.section;
    
    NSString *t_str = [NSString stringWithFormat:@"cell %d_%d", section, row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:t_str];
    
    if(cell != nil)
        [cell removeFromSuperview];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
    cell.accessoryType = UITableViewCellAccessoryNone;
    typhoonYearModel *tf_year = (typhoonYearModel *)[self.tflists objectAtIndex:row];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:tf_year.code, @"code", tf_year.name, @"name", nil];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(25, 5, 200, 30)];
    lab.text=tf_year.name;
    lab.textColor=[UIColor blackColor];
    lab.font=[UIFont systemFontOfSize:16];
    [cell addSubview:lab];
    UIImageView *cellimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 36, kScreenWidth-80, 0.5)];
    cellimg.backgroundColor=[UIColor grayColor];
    [cell addSubview:cellimg];
    cellimg.alpha=0.8;
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
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [m_tableView
                             cellForRowAtIndexPath: indexPath ];
    UIImageView *xzimg =(UIImageView *)[cell.contentView viewWithTag:20];
    typhoonYearModel *tf_year = (typhoonYearModel *)[self.tflists objectAtIndex:indexPath.row];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:tf_year.code, @"code", tf_year.name, @"name", nil];
    
    if (cell.accessoryType ==UITableViewCellAccessoryNone){
        //        cell.accessoryType =UITableViewCellAccessoryCheckmark;
        if (![self.mytflist containsObject:dic])
        {
            [self.mytflist addObject:dic];
            xzimg.image=[UIImage imageNamed:@"选中框"];
        }else{
            [self.mytflist removeObject:dic];
            xzimg.image=[UIImage imageNamed:@"未选中框"];
        }
        
        
    }
    else{
        [self.mytflist removeObject:dic];
        xzimg.image=[UIImage imageNamed:@"未选中框"];
        
    }
    if (self.mytflist.count>3) {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"最多只能同时选3个台风" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [al show];
        [self.mytflist removeObject:dic];
        xzimg.image=[UIImage imageNamed:@"未选中框"];
        
        return;
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:self.mytflist forKey:@"mytf"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (self.mytflist.count==3) {
            [self okAction];
        }
        
    }
}
-(void)okAction{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(tfActionwith:)]) {
        [self.delegate tfActionwith:self.mytflist];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
