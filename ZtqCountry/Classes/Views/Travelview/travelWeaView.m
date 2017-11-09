//
//  travelWeaView.m
//  ZtqNew
//
//  Created by lihj on 12-6-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "travelWeaView.h"
#import "EGOImageView.h"
@implementation travelWeaView{
    EGOImageView *m_img;
}

@synthesize m_target,city;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        [self setBackgroundColor:[UIColor clearColor]];
        
        //		float place = 0;
        //        if(kSystemVersionMore7)
        //        {
        //            place = 20;
        //        }
        //        self.barhight=place+44;
        m_img=[[EGOImageView alloc]init];
        
        m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, kScreenHeitht-80) style:UITableViewStylePlain];
        m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        m_tableView.backgroundColor=[UIColor clearColor];
        m_tableView.backgroundView=nil;
        m_tableView.autoresizesSubviews = YES;
        m_tableView.showsHorizontalScrollIndicator = YES;
        m_tableView.showsVerticalScrollIndicator = NO;
        [self addSubview:m_tableView];
        //		[m_tableView release];
        
        m_tableView.delegate = self;
        m_tableView.dataSource = self;
        city=@"";
        
        
    }
    return self;
}

//- (void)dealloc {
//    [super dealloc];
//}

- (void) updateView:(mainVCmainVModel *)t_model withName:(NSString *)name Withimg:(NSString *)imgurl
{
    m_mainVCmainVModel = t_model;
    self.mycity=name;
    self.imgurl=imgurl;
    [m_img setImageURL:[ShareFun makeImageUrl:imgurl]];
    NSLog(@"%f",m_img.image.size.height);
    NSLog(@"%f",m_img.image.size.width);
    [m_tableView reloadData];
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 5;
    return [m_mainVCmainVModel.fcModelArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 155;
    }
    return 50;
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
    
    if (m_mainVCmainVModel) {
        
        if (row == 0) {
            
            if (m_mainVCmainVModel.fcModelArray.count>0) {
                UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 155)];
                bgimg.image=[UIImage imageNamed:@"实时天气底座"];
                bgimg.userInteractionEnabled=YES;
                [cell addSubview:bgimg];
                
                FcModel *t_model1 = (FcModel *)[m_mainVCmainVModel.fcModelArray objectAtIndex:0];
                UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, kScreenWidth, 30)];
                
                myLabel.text =self.mycity;
                //                myLabel.shadowColor=[UIColor blackColor];
                //			myLabel.shadowOffset = CGSizeMake(1, 1);
                //            myLabel.textAlignment=NSTextAlignmentCenter;
                myLabel.textColor = [UIColor blackColor];
                [myLabel setFont:[UIFont systemFontOfSize:20]];
                myLabel.adjustsFontSizeToFitWidth = YES;
                myLabel.backgroundColor = [UIColor clearColor];
                myLabel.highlighted = YES;
                [bgimg addSubview:myLabel];
                
                UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(30, 40, 80, 80)];
                img.image=[UIImage imageNamed:@"大天气图标底座"];
                [bgimg addSubview:img];
                UIImageView *tqico=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
                //                if ([ShareFun timeRules]==Evening) {
                //                    NSString *nightico=[NSString stringWithFormat:@"n%@",t_model1.wd_night_ico];
                //                tqico.image=[UIImage imageNamed:nightico];//当天天气图标
                //                }else{
                //                    tqico.image=[UIImage imageNamed:t_model1.wd_daytime_ico];//当天天气图标
                //                }
                
                [img addSubview:tqico];
                
                myLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 45, 150, 30)];
                if ([t_model1.isnight isEqualToString:@"1"]) {
                    tqico.image=[UIImage imageNamed:[NSString stringWithFormat:@"n%@",t_model1.wd_night_ico]];//当天天气图标
                    //                    myLabel.text =[NSString  stringWithFormat:@"夜间 %@",t_model1.wd_night];
                    if ([t_model1.wd_daytime isEqualToString:t_model1.wd_night]) {
                        myLabel.text =t_model1.wd_daytime;
                    }else{
                        if (t_model1.wd_night.length>0) {
                            myLabel.text =[NSString stringWithFormat:@"%@转%@",t_model1.wd_daytime,t_model1.wd_night];
                        }else{
                            myLabel.text =t_model1.wd_daytime;
                        }
                        
                    }
                    //暂时全天
                    //                    [tqico setImage:[UIImage imageNamed:[NSString stringWithFormat:@"n%@",t_model1.wd_daytime_ico]]];
                }else{
                    tqico.image=[UIImage imageNamed:t_model1.wd_daytime_ico];//当天天气图标
                    if ([t_model1.wd_daytime isEqualToString:t_model1.wd_night]) {
                        myLabel.text =t_model1.wd_daytime;
                    }else{
                        if (t_model1.wd_night.length>0) {
                            myLabel.text =[NSString stringWithFormat:@"%@转%@",t_model1.wd_daytime,t_model1.wd_night];
                        }else{
                            myLabel.text =t_model1.wd_daytime;
                        }
                        
                    }
                }
                //myLabel.shadowColor = [UIColor blackColor];
                myLabel.shadowOffset = CGSizeMake(1, 1);
                myLabel.textColor = [UIColor blackColor];
                [myLabel setFont:[UIFont systemFontOfSize:14]];
                myLabel.backgroundColor = [UIColor clearColor];
                myLabel.highlighted = YES;
                [bgimg addSubview:myLabel];
                
                NSString *t_temp=@"";
                
     
                t_temp = [NSString stringWithFormat:@"%@~%@℃",t_model1.higt,t_model1.lowt];
                               //            t_temp=m_mainVCmainVModel.sstq.week;
                myLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 65, 100, 30)];
                myLabel.text = t_temp;
                //myLabel.shadowColor = [UIColor blackColor];
//                myLabel.shadowOffset = CGSizeMake(1, 1);
                myLabel.textColor = [UIColor blackColor];
                [myLabel setFont:[UIFont systemFontOfSize:14]];
                //myLabel.textAlignment = UITextAlignmentCenter;
                myLabel.adjustsFontSizeToFitWidth = YES;
                myLabel.backgroundColor = [UIColor clearColor];
                myLabel.highlighted = YES;
                [bgimg addSubview:myLabel];
                
                NSDateFormatter *t_format = [[NSDateFormatter alloc] init];
                [t_format setDateFormat:@"MM/dd"];
                //			NSDate *t_date = [t_format dateFromString:m_mainVCmainVModel.sstq.gdt];
                NSDate *t_date = [t_format dateFromString:t_model1.gdt];
                [t_format setDateFormat:@"MM月dd日"];
                NSString *t_string = [t_format stringFromDate:t_date];
                //			[t_format release];
                
                myLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 85, 60, 30)];
                myLabel.text = t_model1.gdt;
                //myLabel.shadowColor = [UIColor blackColor];
//                myLabel.shadowOffset = CGSizeMake(1, 1);
                myLabel.textColor = [UIColor blackColor];
                [myLabel setFont:[UIFont systemFontOfSize:14]];
                myLabel.backgroundColor = [UIColor clearColor];
                myLabel.highlighted = YES;
                [bgimg addSubview:myLabel];
                //			[myLabel release];
                
                myLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 85, 40, 30)];
                myLabel.text = t_model1.week;
                //            myLabel.text=@"今天";
                //myLabel.shadowColor = [UIColor blackColor];
//                myLabel.shadowOffset = CGSizeMake(1, 1);
                myLabel.textColor = [UIColor blackColor];
                [myLabel setFont:[UIFont systemFontOfSize:14]];
                myLabel.backgroundColor = [UIColor clearColor];
                myLabel.highlighted = YES;
                [bgimg addSubview:myLabel];
                
                UIImageView *qinxin=[[UIImageView alloc]initWithFrame:CGRectMake(25, 125, 80, 22)];
                qinxin.image=[UIImage imageNamed:@"清新福建"];
                [bgimg addSubview:qinxin];
//                UILabel *qxlab=[[UILabel alloc]initWithFrame:CGRectMake(38, 0, 110, 30)];
//                qxlab.text=@"清新指数";
//                //                qxlab.textAlignment=NSTextAlignmentRight;
//                qxlab.textColor=[UIColor blackColor];
//                [qxlab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
//                [qinxin addSubview:qxlab];
                
                UILabel *pmlab=[[UILabel alloc]initWithFrame:CGRectMake(130, 120, 80, 30)];
                pmlab.text=@"PM2.5: 暂无";
                pmlab.textColor=[UIColor blackColor];
                [pmlab setFont:[UIFont systemFontOfSize:14]];
                [bgimg addSubview:pmlab];
                UILabel *fylab=[[UILabel alloc]initWithFrame:CGRectMake(220, 120, 110, 30)];
                fylab.text=@"负氧离子: 暂无";
                fylab.textColor=[UIColor blackColor];
                [fylab setFont:[UIFont systemFontOfSize:14]];
                [bgimg addSubview:fylab];
            }
            NSUserDefaults *travelCity = [NSUserDefaults standardUserDefaults];
            NSArray *tra_city = [travelCity objectForKey:@"travelCity"];
            for (NSString *city1 in tra_city)
            {
                if ([city isEqualToString:city1])
                {
                    [mybutton removeFromSuperview];
                }
            }
            cell.backgroundColor=[UIColor clearColor];
            return cell;
        }else{
            
            
            UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(70, 49, kScreenWidth-85, 1)];
            bgimg.backgroundColor=[UIColor colorHelpWithRed:226 green:226 blue:226 alpha:1];
//            bgimg.userInteractionEnabled=YES;
            [cell addSubview:bgimg];
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 1, 50)];
            line.backgroundColor=[UIColor colorHelpWithRed:21 green:98 blue:185 alpha:1];
            [cell addSubview:line];
            UIImageView *icobg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
            icobg.image=[UIImage imageNamed:@"小天气图标底座"];
            [cell addSubview:icobg];
            FcModel *t_model = (FcModel *)[m_mainVCmainVModel.fcModelArray objectAtIndex:row];
            
            
            
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 50, 40)];
            
            myLabel.text = t_model.week;
            
            myLabel.textColor = [UIColor blackColor];
            myLabel.textAlignment = NSTextAlignmentCenter;
            [myLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            myLabel.adjustsFontSizeToFitWidth = YES;
            myLabel.backgroundColor = [UIColor clearColor];
            myLabel.highlighted = YES;
            [cell addSubview:myLabel];
            //		[myLabel release];
            
            
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
            [icobg addSubview:icon];
            NSString *dayico=t_model.wd_daytime_ico;
//            if ([t_model.isnight isEqualToString:@"1"]) {
//                dayico=[NSString stringWithFormat:@"n%@",t_model.wd_night_ico];
//            }
//            NSString *nightico=[NSString stringWithFormat:@"n%@",t_model.wd_daytime_ico];
            
            //        if ([ShareFun isNight]) {
            //            icon.image=[UIImage imageNamed:nightico];
            //        }else{
            //            icon.image=[UIImage imageNamed:dayico];
            //
            //        }
            icon.image=[UIImage imageNamed:dayico];
            
            myLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 5, 80, 40)];
//            if ([t_model.isnight isEqualToString:@"1"]) {
//                if (row==1) {
//                    myLabel.text = [NSString stringWithFormat:@"%@",t_model.wd_night];
//                }else{
//                    myLabel.text = [NSString stringWithFormat:@"%@",t_model.wd_night];
//                }
//                
//            }else {
                if ([t_model.wd_daytime isEqualToString:t_model.wd_night]) {
                    myLabel.text = t_model.wd_daytime;
                }else{
                    if (t_model.wd_night.length>0) {
                        myLabel.text = [NSString stringWithFormat:@"%@转%@",t_model.wd_daytime,t_model.wd_night];
                    }else{
                        myLabel.text = t_model.wd_daytime;
                    }
                    
                }
//            }
            myLabel.numberOfLines = 0;
            myLabel.textColor = [UIColor blackColor];
            myLabel.textAlignment = NSTextAlignmentCenter;
            [myLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            //	myLabel.adjustsFontSizeToFitWidth = YES;
            myLabel.backgroundColor = [UIColor clearColor];
            myLabel.highlighted = YES;
            [cell addSubview:myLabel];
            //		[myLabel release];
            
            NSString *t_temp;
            t_temp = [NSString stringWithFormat:@"%@~%@℃",t_model.higt, t_model.lowt];
//            if([ShareFun timeRules]==Noon)
//            {
//                t_temp = [NSString stringWithFormat:@"%@~%@℃",t_model.higt, t_model.lowt];
//            }
//            else if([ShareFun timeRules]==Evening){
//                if (row==1) {
//                    t_temp = [NSString stringWithFormat:@"%@~%@℃",t_model.higt, t_model.lowt];
//                }else{
//                    t_temp = [NSString stringWithFormat:@"%@~%@℃",t_model.higt, t_model.lowt];}
//            }else if ([ShareFun timeRules]==Morning){
//                t_temp = [NSString stringWithFormat:@"%@~%@℃",t_model.higt, t_model.lowt];
//            }
            myLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 80, 40)];
            myLabel.text = t_temp;
            myLabel.textColor = [UIColor blackColor];
            myLabel.textAlignment = NSTextAlignmentCenter;
            [myLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            myLabel.adjustsFontSizeToFitWidth = YES;
            myLabel.backgroundColor = [UIColor clearColor];
            myLabel.highlighted = YES;
            [cell addSubview:myLabel];
            
            //
//            UIImageView *qinxinico=[[UIImageView alloc]initWithFrame:CGRectMake(250, 10, 30, 30)];
//            qinxinico.image=[UIImage imageNamed:@"清新1_03"];
//            [cell addSubview:qinxinico];
//            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(280, 5, 30, 40)];
//            lab.text=@"暂无";
//            [lab setFont:[UIFont fontWithName:@"Helvetica" size:14]];
//            lab.textColor=[UIColor blackColor];
//            [cell addSubview:lab];
        }
    }
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (void)setTravelCity:(NSString *)detailCity
{
    self.city = [NSString stringWithString:detailCity];
    //    [self readXML];
}
-(void)readXML{
    m_allCity=m_treeNodelLandscape;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        t_node_child = [t_node.children objectAtIndex:0];
        NSString *tid = t_node_child.leafvalue;
        if ([self.city isEqualToString:tid])
        {
            
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:2];
            NSString *name = t_node_child1.leafvalue;
            self.mycity=name;
        }
    }
    
    
}
- (void)collect
{
    NSUserDefaults *travelCity = [NSUserDefaults standardUserDefaults];
    NSArray *fav_city1 = [travelCity objectForKey:@"travelCity"];
    
    if ([fav_city1 count] >= 9) {
        [ShareFun alertNotice:@"知天气" withMSG:@"最多只能收藏9个景点!" cancleButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }
    
    NSMutableArray *fav_city2 = [[NSMutableArray alloc] initWithArray:fav_city1];
    [fav_city2 addObject:city];
    [travelCity setObject:fav_city2 forKey:@"travelCity"];
    
    [mybutton removeFromSuperview];
    
    [self performSelector:@selector(showAlert)];
    //[ShareFun alertNotice:@"知天气" withMSG:@"收藏景点成功" cancleButtonTitle:@"确定" otherButtonTitle:nil];
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    //    [promptAlert release];
    promptAlert = NULL;
}


- (void)showAlert

{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"添加收藏成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    
    [promptAlert show]; 
}

@end
