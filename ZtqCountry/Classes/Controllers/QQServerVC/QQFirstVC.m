//
//  QQFirstVC.m
//  ZtqCountry
//
//  Created by Admin on 15/8/19.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "QQFirstVC.h"
#import "WebViewController.h"
#import "UILabel+utils.h"
@interface QQFirstVC ()

@end

@implementation QQFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qqupdateview) name:@"qqrefresh" object:nil];
    self.barHiden=NO;
    self.titleLab.text=@"亲情服务";
    self.view.backgroundColor=[UIColor whiteColor];
    self.seringarr=[[NSMutableArray alloc]init];
    self.noserarr=[[NSMutableArray alloc]init];
    
    self.adimgurls=[[NSMutableArray alloc]init];
    self.adtitles=[[NSMutableArray alloc]init];
    self.adurls=[[NSMutableArray alloc]init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self loadMainAD];
    [self getTabDatas];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self qqupdateview];
}
-(void)qqupdateview{
    [self loadMainAD];
    [self getTabDatas];
}

//加载首页大广告
-(void)loadMainAD{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:@"11" forKey:@"position_id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_ad"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            [self.adimgurls removeAllObjects];
            [self.adtitles removeAllObjects];
            [self.adurls removeAllObjects];
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];
            for (int i=0; i<adlist.count; i++) {
                NSString *url=[adlist[i] objectForKey:@"url"];
                NSString *title=[adlist[i] objectForKey:@"title"];
                NSString *imgurl=[adlist[i] objectForKey:@"img_path"];
                [self.adurls addObject:url];
                [self.adtitles addObject:title];
                [self.adimgurls addObject:imgurl];
            }
            
            [self.bmadscro removeFromSuperview];
            [self.tableView reloadData];
            
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)getTabDatas{
     NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
//    userid=@"963647656";
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if (userid.length>0) {
       [gz_todaywt_inde setObject:userid forKey:@"user_id"];
    }
    
    [b setObject:gz_todaywt_inde forKey:@"gz_family_private"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *gz_family_private=[b objectForKey:@"gz_family_private"];
        self.empty_tip=[gz_family_private objectForKey:@"empty_tip"];
        self.seringarr=[gz_family_private objectForKey:@"pay_list"];
        self.noserarr=[gz_family_private objectForKey:@"no_pay_list"];
//        self.seringarr=[NSMutableArray arrayWithObjects:@"11",@"222",@"55",@"11",@"444",@"222", nil];
//        self.noserarr=[NSMutableArray arrayWithObjects:@"11",@"222",@"55",@"11",@"444",@"222", nil];
        [self.tableView reloadData];
//        if (!self.seringarr.count>0&&!self.noserarr.count>0) {
//            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 250+self.barHeight, kScreenWidth, 30)];
//            lab.textColor=[UIColor grayColor];
//            lab.text=@"你还未定制亲情服务，点击‘+’马上体验吧";
//            lab.font=[UIFont systemFontOfSize:12];
//            [self.view addSubview:lab];
//        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.seringarr.count>0&&!self.noserarr.count>0) {
        return 3;
    }
    if (!self.seringarr.count>0&&self.noserarr.count>0) {
        return 3;
    }
    if (!self.seringarr.count>0&&!self.noserarr.count>0) {
        return 2;
    }
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        if (self.seringarr.count>0) {
            return self.seringarr.count+1;
        }else{
            return self.noserarr.count+1;
        }
        
    }
    if (section == 3) {
        return self.noserarr.count+1;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (self.adimgurls.count>0) {
            return 170;
        }else
        return 0.0;
    }else if(indexPath.section == 1){
        if (!self.seringarr.count>0&&!self.noserarr.count>0) {
            return cell.frame.size.height;
        }
        return 50.0;
        
    }else if (indexPath.section == 2){
        if (self.seringarr.count == 0&&self.noserarr.count==0) {
            return 0.0;
        }else{
            if (indexPath.row == 0) {
                return 35.0;
            }else{
                return 50.0;
            }
        }
    }else if (indexPath.section == 3){
        if (self.noserarr.count == 0) {
            return 0.0;
        }else{
            if (indexPath.row == 0) {
                return 35.0;
            }else{
                return 50.0;
            }
        }
    }else{
        return 50.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0||section==1) {
        return 0.1;
    }else{
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0||section==1) {
        return 0.1;
    }
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headerView.backgroundColor = [UIColor colorHelpWithRed:239 green:239 blue:244 alpha:1];
    
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    footerView.backgroundColor = [UIColor colorHelpWithRed:239 green:239 blue:244 alpha:1];
    return footerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString *cellIndentifier = @"nomorecell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if(cell != nil)
            [cell removeFromSuperview];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        self.bmadscro = [[BMAdScrollView alloc] initWithNameArr:self.adimgurls  titleArr:self.adtitles height:170 offsetY:0 offsetx:10];
        self.bmadscro.vDelegate = self;
        self.bmadscro.pageCenter = CGPointMake(280, 300);
        [cell addSubview:self.bmadscro];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section==1){
        static NSString *cellIndentifier = @"nomorecell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if(cell != nil)
            [cell removeFromSuperview];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
        bgimg.image=[UIImage imageNamed:@"亲情服务界面横条"];
        bgimg.userInteractionEnabled=YES;
        [cell addSubview:bgimg];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 30)];
        lab.textColor=[UIColor whiteColor];
        lab.text=@"我的亲情服务";
        [bgimg addSubview:lab];
        UIImageView *addimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-45, 11, 18, 18)];
        addimg.image=[UIImage imageNamed:@"添加按钮常态"];
        addimg.userInteractionEnabled=YES;
        [bgimg addSubview:addimg];
        UIButton *addbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        [addbtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [bgimg addSubview:addbtn];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGRect cellFrame = [cell frame];
        cellFrame.origin = CGPointMake(0, 0);
        
        cellFrame.size.height = 80;
        
        if (!self.seringarr.count>0&&!self.noserarr.count>0) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth, 30)];
            lab.textColor=[UIColor grayColor];
            lab.text=self.empty_tip;
            lab.numberOfLines=0;
            lab.font=[UIFont systemFontOfSize:14];
            
            [cell addSubview:lab];
            if (self.empty_tip.length>0) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.empty_tip];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                [paragraphStyle setLineSpacing:2];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.empty_tip.length)];
                lab.attributedText = attributedString;
                lab.textAlignment=NSTextAlignmentCenter;
                
            }
            float lab_h=[lab labelheight:self.empty_tip withFont:[UIFont systemFontOfSize:14]];
            lab.frame=CGRectMake(10, 50, kScreenWidth-20, lab_h+20);
            cellFrame.size.height=kScreenHeitht-170;
        }
        [cell setFrame:cellFrame];
        return cell;
    }
    else if(indexPath.section==2){
        if (self.seringarr.count>0) {
            if(indexPath.row == 0){
                static NSString *cellIndentifier = @"morecell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if(cell != nil)
                    [cell removeFromSuperview];
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
                cell.textLabel.text = @"服务中";
                cell.textLabel.textColor=[UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }else{
                static NSString *cellIndentifier = @"morecell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if(cell != nil)
                    [cell removeFromSuperview];
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
                UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
                bgimg.image=[UIImage imageNamed:@"亲情服务界面横条"];
                bgimg.userInteractionEnabled=YES;
                [cell addSubview:bgimg];
                NSString *name=[self.seringarr[indexPath.row-1] objectForKey:@"name"];
                NSString *dead_date=[self.seringarr[indexPath.row-1] objectForKey:@"dead_date"];
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 80, 30)];
                lab.textColor=[UIColor whiteColor];
                lab.text=name;
                lab.numberOfLines=0;
                lab.font=[UIFont systemFontOfSize:14];
                [bgimg addSubview:lab];
                UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(85, 5, 150, 30)];
                lab1.textColor=[UIColor whiteColor];
                lab1.text=dead_date;
                lab1.textAlignment=NSTextAlignmentLeft;
                lab1.font=[UIFont systemFontOfSize:14];
                [bgimg addSubview:lab1];
                UIButton *xfbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-90, 7.5, 30, 25)];
                [xfbtn setTitle:@"续费" forState:UIControlStateNormal];
                xfbtn.tag=indexPath.row;
                xfbtn.titleLabel.font=[UIFont systemFontOfSize:13];
                [xfbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮常态"] forState:UIControlStateNormal];
                [xfbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮点击态"] forState:UIControlStateHighlighted];
                [xfbtn addTarget:self action:@selector(xfAction:) forControlEvents:UIControlEventTouchUpInside];
                [bgimg addSubview:xfbtn];
                
                UIButton *xgbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50, 7.5, 30, 25)];
                [xgbtn setTitle:@"修改" forState:UIControlStateNormal];
                xgbtn.titleLabel.font=[UIFont systemFontOfSize:13];
                xgbtn.tag=indexPath.row;
                [xgbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮常态"] forState:UIControlStateNormal];
                [xgbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮点击态"] forState:UIControlStateHighlighted];
                [xgbtn addTarget:self action:@selector(xgAction:) forControlEvents:UIControlEventTouchUpInside];
                [bgimg addSubview:xgbtn];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                return cell;
            }
        }else{
            if(indexPath.row == 0){
                static NSString *cellIndentifier = @"morecell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if(cell != nil)
                    [cell removeFromSuperview];
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                cell.textLabel.text = @"未支付";
                cell.textLabel.textColor=[UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }else{
                static NSString *cellIndentifier = @"morecell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if(cell != nil)
                    [cell removeFromSuperview];
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
                UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
                bgimg.image=[UIImage imageNamed:@"亲情服务界面横条"];
                bgimg.userInteractionEnabled=YES;
                [cell addSubview:bgimg];
                
                NSString *name=[self.noserarr[indexPath.row-1] objectForKey:@"name"];
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
                lab.textColor=[UIColor whiteColor];
                lab.text=name;
                lab.font=[UIFont systemFontOfSize:13];
                lab.numberOfLines=0;
                [bgimg addSubview:lab];
                UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(105, 5, 150, 30)];
                lab1.textColor=[UIColor redColor];
                lab1.text=@"未支付";
                lab1.textAlignment=NSTextAlignmentLeft;
                lab1.font=[UIFont systemFontOfSize:14];
//                [bgimg addSubview:lab1];
                
                UIButton *scbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-130, 7.55, 30, 25)];
                [scbtn setTitle:@"删除" forState:UIControlStateNormal];
                scbtn.tag=indexPath.row;
                scbtn.titleLabel.font=[UIFont systemFontOfSize:13];
                [scbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮常态"] forState:UIControlStateNormal];
                [scbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮点击态"] forState:UIControlStateHighlighted];
                [scbtn addTarget:self action:@selector(scAction:) forControlEvents:UIControlEventTouchUpInside];
                [bgimg addSubview:scbtn];
                UIButton *zfbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-90, 7.5, 30, 25)];
                [zfbtn setTitle:@"支付" forState:UIControlStateNormal];
                zfbtn.tag=indexPath.row;
                zfbtn.titleLabel.font=[UIFont systemFontOfSize:13];
                [zfbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮常态"] forState:UIControlStateNormal];
                [zfbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮点击态"] forState:UIControlStateHighlighted];
                [zfbtn addTarget:self action:@selector(zfAction:) forControlEvents:UIControlEventTouchUpInside];
                [bgimg addSubview:zfbtn];
                
                UIButton *xgbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50, 7.5, 30, 25)];
                [xgbtn setTitle:@"修改" forState:UIControlStateNormal];
                xgbtn.tag=indexPath.row;
                xgbtn.titleLabel.font=[UIFont systemFontOfSize:13];
                [xgbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮常态"] forState:UIControlStateNormal];
                [xgbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮点击态"] forState:UIControlStateHighlighted];
                [xgbtn addTarget:self action:@selector(secxgAction:) forControlEvents:UIControlEventTouchUpInside];
                [bgimg addSubview:xgbtn];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }

        }
        
    }else {
        if(indexPath.row == 0){
            static NSString *cellIndentifier = @"morecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if(cell != nil)
                [cell removeFromSuperview];
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.textLabel.text = @"未支付";
            cell.textLabel.textColor=[UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            static NSString *cellIndentifier = @"morecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if(cell != nil)
                [cell removeFromSuperview];
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
            bgimg.image=[UIImage imageNamed:@"亲情服务界面横条"];
            bgimg.userInteractionEnabled=YES;
            [cell addSubview:bgimg];
            
            NSString *name=[self.noserarr[indexPath.row-1] objectForKey:@"name"];
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
            lab.textColor=[UIColor whiteColor];
            lab.text=name;
            lab.numberOfLines=0;
            lab.font=[UIFont systemFontOfSize:13];
            [bgimg addSubview:lab];
            UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(105, 5, 150, 30)];
            lab1.textColor=[UIColor redColor];
            lab1.text=@"未支付";
            lab1.font=[UIFont systemFontOfSize:14];
            [bgimg addSubview:lab1];
            
            UIButton *scbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-130, 7.55, 30, 25)];
            [scbtn setTitle:@"删除" forState:UIControlStateNormal];
            scbtn.tag=indexPath.row;
            scbtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [scbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮常态"] forState:UIControlStateNormal];
            [scbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮点击态"] forState:UIControlStateHighlighted];
            [scbtn addTarget:self action:@selector(scAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgimg addSubview:scbtn];
            UIButton *zfbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-90, 7.5, 30, 25)];
            [zfbtn setTitle:@"支付" forState:UIControlStateNormal];
            zfbtn.tag=indexPath.row;
            zfbtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [zfbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮常态"] forState:UIControlStateNormal];
            [zfbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮点击态"] forState:UIControlStateHighlighted];
            [zfbtn addTarget:self action:@selector(zfAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgimg addSubview:zfbtn];
            
            UIButton *xgbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50, 7.5, 30, 25)];
            [xgbtn setTitle:@"修改" forState:UIControlStateNormal];
            xgbtn.tag=indexPath.row;
            xgbtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [xgbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮常态"] forState:UIControlStateNormal];
            [xgbtn setBackgroundImage:[UIImage imageNamed:@"横条内按钮点击态"] forState:UIControlStateHighlighted];
            [xgbtn addTarget:self action:@selector(secxgAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgimg addSubview:xgbtn];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    
}
-(void)addAction{
//    NSString *str=[ShareFun decryptWithText:@"rG9J5Kc/HSe3dpAwPpJnzdxf9aQACsAD338OI/AQToNoPAbpUstpMQ==" withkey:@"pcs**key"];
//    NSString *str1=[ShareFun encryptWithText:@"d15a3f629e634cfa5ccbc5e4af17de4c" withkey:@"pcs**key"];
    NSLog(@"添加");
    AddServerViewController *addser=[[AddServerViewController alloc]init];
    addser.type=@"0";
    [self.navigationController pushViewController:addser animated:YES];
}
-(void)xfAction:(UIButton *)sender{
    NSLog(@"续费");
    NSInteger tag=[sender tag];
    NSString *orderid=[self.seringarr[tag-1] objectForKey:@"order_id"];
    NSString *user_id=[self.seringarr[tag-1] objectForKey:@"user_id"];
    NSString *amount=[self.seringarr[tag-1] objectForKey:@"amount"];
    NSString *phone=[self.seringarr[tag-1] objectForKey:@"phone"];
     NSString *name=[self.seringarr[tag-1] objectForKey:@"name"];
     NSString *send_name=[self.seringarr[tag-1] objectForKey:@"send_name"];
     NSString *area_id=[self.seringarr[tag-1] objectForKey:@"area_id"];
     NSString *product_id=[self.seringarr[tag-1] objectForKey:@"product_id"];
     NSString *sign=[NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@",phone,area_id,send_name,name,product_id,user_id];
    PayViewController *payvc=[[PayViewController alloc]init];
    payvc.pirce=amount;
    payvc.sign=[self getMd5_32Bit_String:sign];
    payvc.orderid=orderid;
    payvc.userid=user_id;
    [self.navigationController pushViewController:payvc animated:YES];
}
-(void)xgAction:(UIButton *)sender{
    NSInteger tag=[sender tag];
    AddServerViewController *addser=[[AddServerViewController alloc]init];
    addser.type=@"1";
    addser.name=[self.seringarr[tag-1] objectForKey:@"name"];
    addser.send_name=[self.seringarr[tag-1] objectForKey:@"send_name"];
    addser.phone=[self.seringarr[tag-1] objectForKey:@"phone"];
    addser.areaid=[self.seringarr[tag-1] objectForKey:@"area_id"];
    addser.orderid=[self.seringarr[tag-1] objectForKey:@"order_id"];
    [self.navigationController pushViewController:addser animated:YES];
}
-(void)zfAction:(UIButton *)sender{
    NSInteger tag=[sender tag];
    NSString *orderid=[self.noserarr[tag-1] objectForKey:@"order_id"];
    NSString *user_id=[self.noserarr[tag-1] objectForKey:@"user_id"];
    NSString *amount=[self.noserarr[tag-1] objectForKey:@"amount"];
    NSString *phone=[self.noserarr[tag-1] objectForKey:@"phone"];
    NSString *name=[self.noserarr[tag-1] objectForKey:@"name"];
    NSString *send_name=[self.noserarr[tag-1] objectForKey:@"send_name"];
    NSString *area_id=[self.noserarr[tag-1] objectForKey:@"area_id"];
    NSString *product_id=[self.noserarr[tag-1] objectForKey:@"product_id"];
    NSString *sign=[NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@",phone,area_id,send_name,name,product_id,user_id];
    PayViewController *payvc=[[PayViewController alloc]init];
    payvc.pirce=amount;
    payvc.sign=[self getMd5_32Bit_String:sign];
    payvc.orderid=orderid;
    payvc.userid=user_id;
    [self.navigationController pushViewController:payvc animated:YES];
}
-(void)scAction:(UIButton *)sender{
    NSInteger tag=[sender tag];
    NSString *orderid=[self.noserarr[tag-1] objectForKey:@"order_id"];
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if (orderid.length>0) {
        [gz_todaywt_inde setObject:orderid forKey:@"order_id"];
    }
    
    [b setObject:gz_todaywt_inde forKey:@"gz_family_del_order"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *gz_family_private=[b objectForKey:@"gz_family_del_order"];
        NSString *result=[gz_family_private objectForKey:@"result"];
        if ([result isEqualToString:@"1"]) {
            [self getTabDatas];
        }
        
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
    
}
-(void)secxgAction:(UIButton *)sender{
    NSInteger tag=[sender tag];
    AddServerViewController *addser=[[AddServerViewController alloc]init];
    addser.type=@"1";
    addser.name=[self.noserarr[tag-1] objectForKey:@"name"];
    addser.send_name=[self.noserarr[tag-1] objectForKey:@"send_name"];
    addser.phone=[self.noserarr[tag-1] objectForKey:@"phone"];
    addser.areaid=[self.noserarr[tag-1] objectForKey:@"area_id"];
    addser.orderid=[self.noserarr[tag-1] objectForKey:@"order_id"];
    [self.navigationController pushViewController:addser animated:YES];
}
-(void)buttonClick:(int)vid{
    NSString *url=self.adurls[vid-1];
    if (url.length>0) {
        WebViewController *adVC = [[WebViewController alloc]init];
        adVC.url = self.adurls[vid-1];
        adVC.titleString =self.adtitles[vid-1];
        [self.navigationController pushViewController:adVC animated:YES];
    }
}
//32位MD5加密方式
- (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
