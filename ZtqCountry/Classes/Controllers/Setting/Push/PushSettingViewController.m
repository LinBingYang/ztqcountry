//
//  PushSettingViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-7-21.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "PushSettingViewController.h"
#import "UISwitch+CustomText.h"

@interface PushSettingViewController ()
@property (strong, nonatomic) UITableView * pushSettingTab;
@property (strong, nonatomic) NSMutableArray * settingDatas;
@property (strong, nonatomic) UIView * cityBg;
@property (strong, nonatomic) UITableView * cityList;
@property (strong, nonatomic) UIButton * yujinCity;
@property (strong, nonatomic) UIButton * tianqiCity;
@property (assign, nonatomic) int butID;//标志是预警设置城市打开的列表还是天气预报打开的城市列表
@property (strong, nonatomic) UIImageView * bgImgV;

@property (strong, nonatomic) NSString * yujingCityStr;
@property (strong, nonatomic) NSString * tianqiCityStr;


@end

@implementation PushSettingViewController

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

    [self configData];
    [self setNavigation];
    _pushSettingTab = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight+10, kScreenWidth, kScreenHeitht-self.barHeight)];
    
    _pushSettingTab.delegate = self;
    _pushSettingTab.dataSource = self;
    _pushSettingTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_pushSettingTab];
}

-(void)setNavigation
{

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
    _navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:_navigationBarBg];
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [_navigationBarBg addSubview:leftimg];
    
    
    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    [_leftBut addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    
    _rightBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-55, 7+place, 50, 30)];
    [_rightBut addTarget:self action:@selector(sendbtn) forControlEvents:UIControlEventTouchUpInside];
    [_rightBut setTitle:@"提交" forState:UIControlStateNormal];
    _rightBut.titleLabel.font=[UIFont systemFontOfSize:15];
    [_rightBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightBut setBackgroundImage:[UIImage imageNamed:@"提交框常态"] forState:UIControlStateNormal];
    [_rightBut setBackgroundImage:[UIImage imageNamed:@"提交框二态"] forState:UIControlStateHighlighted];
    [_navigationBarBg addSubview:_rightBut];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 12+place, self.view.width-120, 20)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor whiteColor];
    [_navigationBarBg addSubview:_titleLab];
    self.barHiden = NO;
    self.titleLab.text = @"温馨提示推送";
    self.titleLab.textColor = [UIColor whiteColor];
   
    self.marr=[[NSMutableArray alloc]init];
    [self queryPushTag];
    
}


-(void)sendpush{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    if (!self.jieqi.length>0) {
        self.jieqi=@"1";
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kJieriPushOpen];
         [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (!self.jieri.length>0) {
        self.jieri=@"1";
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kJieqiPushOpen];
         [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (!self.zt.length>0) {
        self.zt=@"1";
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kzhuantiPushOpen];
         [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (!self.chanpin.length>0) {
        self.chanpin=@"1";
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kchanpinPushOpen];
         [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [tip setObject:self.jieri forKey:@"tips_holiday"];
    [tip setObject:self.jieqi forKey:@"tips_jieqi"];
    [tip setObject:self.chanpin forKey:@"tips_notice"];
        [tip setObject:self.zt forKey:@"tips_special"];
    [setProperty setObject:tip forKey:@"tags"];
    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    [b setObject:setProperty forKey:@"gz_set_pushtag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *setpust=[b objectForKey:@"gz_set_pushtag"];
        NSString *result=[setpust objectForKey:@"result"];
        
//        NSString * error = [h objectForKey:@"error"];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    
}
//标签查询
-(void)queryPushTag{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    [b setObject:setProperty forKey:@"gz_query_pushtag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *setpust=[b objectForKey:@"gz_query_pushtag"];
        NSArray *tags=[setpust objectForKey:@"tags"];
        if (tags.count>0) {
            for (int i=0; i<tags.count; i++) {
                NSString *tagkey=[tags[i] objectForKey:@"tag_key"];
                NSString *tag_value=[tags[i] objectForKey:@"tag_value"];
                if ([tagkey isEqualToString:@"tips_holiday"]) {
                    self.jieri=tag_value;
                    if ([self.jieri isEqualToString:@"0"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kJieriPushOpen];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kJieriPushOpen];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([tagkey isEqualToString:@"tips_jieqi"]) {
                    self.jieqi=tag_value;
                    if ([self.jieqi isEqualToString:@"0"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kJieqiPushOpen];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kJieqiPushOpen];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([tagkey isEqualToString:@"tips_notice"]) {
                    self.chanpin=tag_value;
                    if ([self.chanpin isEqualToString:@"0"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kchanpinPushOpen];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kchanpinPushOpen];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([tagkey isEqualToString:@"tips_special"]) {
                    self.zt=tag_value;
                    if ([self.zt isEqualToString:@"0"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kzhuantiPushOpen];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kzhuantiPushOpen];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                
            }
            
        }
        [self sendpush];
        [self.pushSettingTab reloadData];
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    
}
-(void)configData
{
    self.settingDatas = [[NSMutableArray alloc] init];
//    NSDictionary * yujingInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"预警信息推送",@"title",@"设置城市",@"city", nil];
//    [self.settingDatas addObject:yujingInfo];
//    NSDictionary * tianqiInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"天气预报推送",@"title",@"设置城市",@"city", nil];
//    [self.settingDatas addObject:tianqiInfo];
    NSDictionary * jieri = [[NSDictionary alloc] initWithObjectsAndKeys:@"节日提醒推送",@"title", nil];
    [self.settingDatas addObject:jieri];
    NSDictionary * jieqi = [[NSDictionary alloc] initWithObjectsAndKeys:@"节气提醒推送",@"title", nil];
    [self.settingDatas addObject:jieqi];
    NSDictionary * zhuanti = [[NSDictionary alloc] initWithObjectsAndKeys:@"专题提醒推送",@"title", nil];
    [self.settingDatas addObject:zhuanti];
    NSDictionary * chanpin = [[NSDictionary alloc] initWithObjectsAndKeys:@"产品公告推送",@"title", nil];
    [self.settingDatas addObject:chanpin];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendbtn{
    self.isedit=NO;
    NSString *jieri=[[NSUserDefaults standardUserDefaults]objectForKey:kJieriPushOpen];
    NSString *jieqi=[[NSUserDefaults standardUserDefaults]objectForKey:kJieqiPushOpen];
    NSString *zt=[[NSUserDefaults standardUserDefaults]objectForKey:kzhuantiPushOpen];
    NSString *cp=[[NSUserDefaults standardUserDefaults]objectForKey:kchanpinPushOpen];
    NSString *newjr=[NSString stringWithFormat:@"%@",jieri];
    NSString *newjq=[NSString stringWithFormat:@"%@",jieqi];
    NSString *newzt=[NSString stringWithFormat:@"%@",zt];
     NSString *newcp=[NSString stringWithFormat:@"%@",cp];
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    if (jieri==nil) {
        newjr=@"1";
    }
    if (jieqi==nil) {
        newjq=@"1";
    }
    if (zt==nil) {
        newzt=@"1";
    }
    if (cp==nil) {
        newcp=@"1";
    }
    [tip setObject:newjr forKey:@"tips_holiday"];
    [tip setObject:newjq forKey:@"tips_jieqi"];
    [tip setObject:newcp forKey:@"tips_notice"];
    [tip setObject:newzt forKey:@"tips_special"];
    [setProperty setObject:tip forKey:@"tags"];
    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    [b setObject:setProperty forKey:@"gz_set_pushtag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"提交中..." animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *setpust=[b objectForKey:@"gz_set_pushtag"];
        NSString *result=[setpust objectForKey:@"result"];
        if ([result isEqualToString:@"1"]) {
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"嘿嘿,提交成功了" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [al show];
        }else{
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"提交失败,再试试吧" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [al show];
        }
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error
                    ) {
        
    } withCache:NO];
}

#pragma mark -tableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.cityList])
    {
        [UIView animateWithDuration:0.2 animations:^{
            cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                cell.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    cell.transform = CGAffineTransformMakeScale(1.05, 1.05);
                } completion:^(BOOL finished) {
                    //                _bgImgV.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }];
            cell.transform = CGAffineTransformMakeScale(1, 1);
        }];

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.cityList])
    {
        return [setting sharedSetting].citys.count;
    }
    else
    {
        return self.settingDatas.count;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.cityList])
    {
        return 30;
    }
    else
    {
       
            return 50;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.cityList])
    {
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"City"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"City"];
        }
        NSDictionary * cityInfo = [[setting sharedSetting].citys objectAtIndex:indexPath.row];
        NSString * name = [cityInfo objectForKey:@"city"];
        NSString * ID = [cityInfo objectForKey:@"ID"];
        cell.textLabel.text = name;
        cell.textLabel.font = [UIFont fontWithName:kBaseFont size:13];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"灰色隔条.png"]];
        [m_image setFrame:CGRectMake(0, 29, kScreenWidth, 1)];
        [cell addSubview:m_image];
        return cell;
    }
    else
    {
        
        
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"other"];
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"other"];
                    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 120, 20)];
                    title.backgroundColor = [UIColor clearColor];
                    title.textAlignment = NSTextAlignmentLeft;
                    title.font = [UIFont systemFontOfSize:15];
                    title.textColor = [UIColor blackColor];
                    title.tag = 1;
                    [cell.contentView addSubview:title];
                    
//                    UISwitch * openSwithch = [[UISwitch alloc] initWithFrame:CGRectMake(230, 5, 65, 20)];
                    UISwitch * openSwithch = [UISwitch switchWithLeftText:@"开" andRight:@"关"];
                    openSwithch.frame = CGRectMake(kScreenWidth-85, 5, 65, 20);
                    openSwithch.tag = indexPath.row + 10;
                    [openSwithch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
                    [cell.contentView addSubview:openSwithch];
                }
                NSDictionary * dataInfo = [self.settingDatas objectAtIndex:indexPath.row];
                
                UILabel * title = (UILabel *)[cell.contentView viewWithTag:1];
                title.text = [dataInfo objectForKey:@"title"];
                UISwitch * openSwitch = (UISwitch *)[cell.contentView viewWithTag:indexPath.row +10];
                switch (indexPath.row) {
                    case 0:
                    {
                        
                        BOOL isOpen =  [[[NSUserDefaults standardUserDefaults] objectForKey:kJieriPushOpen] boolValue];
                        openSwitch.on = isOpen;
                        break;
                    }
                    case 1:
                    {
                       
                        BOOL isOpen =  [[[NSUserDefaults standardUserDefaults] objectForKey:kJieqiPushOpen] boolValue];
                        openSwitch.on = isOpen;
//                         openSwitch.on=YES;
                        break;
                    }
                    case 2:
                    {
                       
                        BOOL isOpen =  [[[NSUserDefaults standardUserDefaults] objectForKey:kzhuantiPushOpen] boolValue];
                        openSwitch.on = isOpen;
//                         openSwitch.on=YES;
                        break;
                    }
                    case 3:
                    {
                        
                        BOOL isOpen =  [[[NSUserDefaults standardUserDefaults] objectForKey:kchanpinPushOpen] boolValue];
                        openSwitch.on = isOpen;
//                         openSwitch.on=YES;
                        break;
                    }
                }
                UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"灰色隔条.png"]];
                [m_image setFrame:CGRectMake(0, 39, kScreenWidth, 1)];
                [cell addSubview:m_image];
                return cell;
            }
    
        
    
    return nil;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if([tableView isEqual:self.cityList])
//    {
//        if(self.butID == 1)
//        {
//            NSString * originName = self.yujinCity.titleLabel.text;
//            NSDictionary * cityInfo = [[setting sharedSetting].citys objectAtIndex:indexPath.row];
//            NSString * name = [cityInfo objectForKey:@"city"];
//            self.yujingCityStr = name;
//            NSString * ID = [cityInfo objectForKey:@"ID"];
//            if(![originName isEqualToString:name])
//            {
//                [self setPropertywithValue:ID withKey:@"yujing_city" withView:self.yujinCity];
////                self.yujinCity.titleLabel.text = name;
////                NSDictionary * yujingcityinfo = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",ID,@"ID", nil];
////                [[NSUserDefaults standardUserDefaults] setObject:yujingcityinfo forKey:kYujingPushCity];
////                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
//
//        }
//        if(self.butID == 2)
//        {
//            NSString * originName = self.tianqiCity.titleLabel.text;
//            NSDictionary * cityInfo = [[setting sharedSetting].citys objectAtIndex:indexPath.row];
//            NSString * name = [cityInfo objectForKey:@"city"];
//            self.tianqiCityStr = name;
//            NSString * ID = [cityInfo objectForKey:@"ID"];
//            if(![originName isEqualToString:name])
//            {
//                [self setPropertywithValue:ID withKey:@"tianqi_city" withView:self.tianqiCity];
////                self.tianqiCity.titleLabel.text = name;
////                NSDictionary * tianqicityinfo = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",ID,@"ID", nil];
////                [[NSUserDefaults standardUserDefaults] setObject:tianqicityinfo forKey:kTianqiPushCity];
////                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
//
//        }
//        self.cityBg.hidden = YES;
//    }
}


-(void)switchChange:(UISwitch *)sender
{
    self.isedit=YES;
    int tag = sender.tag - 10;
    NSString * state = nil;
    if(sender.on)
    {
        state = @"1";
    }
    else
    {
        state = @"0";
    }

    switch (tag) {

        case 0:
        {

            [self setPropertywithValue:state withKey:@"tips_holiday" withView:sender];
            break;
        }
        case 1:
        {

            [self setPropertywithValue:state withKey:@"tips_jieqi" withView:sender];
            break;
        }
        case 3:
        {
            [self setPropertywithValue:state withKey:@"tips_notice" withView:sender];
            break;
        }
        case 2:
        {

            [self setPropertywithValue:state withKey:@"tips_special" withView:sender];
            break;
        }
    }
}
-(void)setPropertywithValue:(NSString *)value withKey:(NSString *)key withView:(id)sender
{
//    NSString * urlStr = URL_SERVER;
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
//    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    [tip setObject:value forKey:key];
//    [setProperty setObject:tip forKey:@"tags"];
//    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
//    [b setObject:setProperty forKey:@"setPushTag"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
//        NSDictionary * b = [returnData objectForKey:@"b"];
//        NSDictionary *setpust=[b objectForKey:@"setPushTag"];
//        NSString *result=[setpust objectForKey:@"result"];
//        int is = [result intValue];
//        NSString * error = [h objectForKey:@"error"];
//        if(is ==1)
//        {
            //成功
        if([key isEqualToString:@"tips_holiday"])
            {
                //节日
                if([value isEqualToString:@"0"])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kJieriPushOpen];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kJieriPushOpen];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }

            }
            if([key isEqualToString:@"tips_jieqi"])
            {
                //节气
                if([value isEqualToString:@"0"])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kJieqiPushOpen];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kJieqiPushOpen];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }

            }
            if([key isEqualToString:@"tips_notice"])
            {
                //产品
                if([value isEqualToString:@"0"])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kchanpinPushOpen];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kchanpinPushOpen];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }

            }
            if([key isEqualToString:@"tips_special"])
            {
                //专题
                if([value isEqualToString:@"0"])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kzhuantiPushOpen];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kzhuantiPushOpen];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }

            }
//        }
//        else
//        {
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            //失败
//
//            if([key isEqualToString:@"tips_holiday"])
//            {
//                //节日
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//            if([key isEqualToString:@"tips_jieqi"])
//            {
//                //节气
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//            if([key isEqualToString:@"tips_notice"])
//            {
//                //产品
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//            if([key isEqualToString:@"tips_special"])
//            {
//                //专题
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//
//        }
//           } withFailure:^(NSError *error) {
//               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//               [alert show];
//                if([key isEqualToString:@"tips_holiday"])
//               {
//                   //节日
//                   UISwitch * s = sender;
//                   BOOL isOpen = s.on;
//                   s.on = !isOpen;
//               }
//               if([key isEqualToString:@"tips_jieqi"])
//               {
//                   //节气
//                   UISwitch * s = sender;
//                   BOOL isOpen = s.on;
//                   s.on = !isOpen;
//               }
//               if([key isEqualToString:@"tips_notice"])
//               {
//                   //产品
//                   UISwitch * s = sender;
//                   BOOL isOpen = s.on;
//                   s.on = !isOpen;
//               }
//               if([key isEqualToString:@"tips_special"])
//               {
//                   //专题
//                   UISwitch * s = sender;
//                   BOOL isOpen = s.on;
//                   s.on = !isOpen;
//               }
//
//           } withCache:NO];

}

-(void)backAction:(UIButton *)sender
{
    if (self.isedit==YES ) {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"设置信息还未保存，要放弃吗？" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"放弃", nil];
        al.delegate=self;
        [al show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        return;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    self.cityBg.hidden = YES;
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
