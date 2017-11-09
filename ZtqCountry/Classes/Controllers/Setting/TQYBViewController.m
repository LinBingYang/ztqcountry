//
//  TQYBViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-29.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "TQYBViewController.h"
#import "SelectCityViewController.h"
@interface TQYBViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView * table;
@property (strong, nonatomic) UIButton * cityBut;


@property (strong, nonatomic) UIView * cityBg;
@property (strong, nonatomic) UITableView * cityList;
@property (strong, nonatomic) UIImageView * bgImgV;
@property (strong, nonatomic) NSMutableString * speekingStr;

@end

@implementation TQYBViewController

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
    [_leftBut setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [_leftBut setBackgroundImage:[UIImage imageNamed:@"返回点击.png"] forState:UIControlStateHighlighted];
    //    [_leftBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    [_leftBut setTitle:@"back" forState:UIControlStateNormal];
    [_leftBut addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 12+place, self.view.width-120, 20)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:18];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor whiteColor];
    [_navigationBarBg addSubview:_titleLab];
    self.barHiden = NO;
    self.titleLab.text = @"天气预报通知";
    self.titleLab.textColor = [UIColor whiteColor];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight) style:UITableViewStylePlain];
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:@"TQYBpush"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:path] == NO)
    {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        [self sendpush];
    }
}
-(void)sendpush{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    [tip setObject:[setting sharedSetting].currentCityID forKey:@"weatherForecast_city"];
    [tip setObject:@"0" forKey:@"weatherForecast_morning"];
    [tip setObject:@"0" forKey:@"weatherForecast_evening"];
    [setProperty setObject:tip forKey:@"tags"];
    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    [b setObject:setProperty forKey:@"setPushTag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *setpust=[b objectForKey:@"setPushTag"];
        NSString *result=[setpust objectForKey:@"result"];
        int is = [result intValue];
        NSString * error = [h objectForKey:@"error"];
        
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    
}
-(void)backAction:(UIButton *)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:NO];
}
-(void)configData
{
    self.tqdic=[[NSUserDefaults standardUserDefaults]objectForKey:@"tqcitydic"];
    NSString * originName = self.cityBut.titleLabel.text;
    //        NSDictionary * cityInfo = [[setting sharedSetting].citys objectAtIndex:indexPath.row];
    NSString * name = [self.tqdic objectForKey:@"city"];
    NSString * ID = [self.tqdic objectForKey:@"ID"];
    if (!name.length>0) {
        name=[setting sharedSetting].currentCity;
        ID=[setting sharedSetting].currentCityID;
    }
    self.strid=ID;
    if(![originName isEqualToString:name])
    {
        
        [self.cityBut setTitle:name forState:UIControlStateNormal];
        
        NSDictionary * infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"CITYNAME",ID,@"ID", [NSNumber numberWithBool:NO],@"ZAOSTATE",        [NSNumber numberWithBool:NO],@"WANSTATE", nil];
        [[NSUserDefaults standardUserDefaults] setObject:infoDic forKey:@"TIANQIYUBAOTONGZHI"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.table reloadData];}
//    NSDictionary * infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"TIANQIYUBAOTONGZHI"];
//    if(!infoDic)
//    {
//        NSString * cityName = [setting sharedSetting].currentCity;
//        NSString * ID = [setting sharedSetting].currentCityID;
//        infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:cityName,@"CITYNAME",ID,@"ID", [NSNumber numberWithBool:NO],@"ZAOSTATE",        [NSNumber numberWithBool:NO],@"WANSTATE", nil];
//        [[NSUserDefaults standardUserDefaults] setObject:infoDic forKey:@"TIANQIYUBAOTONGZHI"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mrak -TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.cityList])
    {
        return [setting sharedSetting].citys.count;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.self.cityList])
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
//            infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:cityName,@"CITYNAME",ID,@"ID", [NSNumber numberWithBool:NO],@"ZAOSTATE",        [NSNumber numberWithBool:NO],@"WANSTATE", nil];
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
        UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"灰色隔条.png"]];
        [m_image setFrame:CGRectMake(0, 29, kScreenWidth, 1)];
        [cell addSubview:m_image];
        return cell;
        
    }
    else
    {
        NSDictionary * infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"TIANQIYUBAOTONGZHI"];
        NSString * cityName = [infoDic objectForKey:@"CITYNAME"];
//        NSString * ID = [infoDic objectForKey:@"ID"];
//        BOOL zaoState = [[infoDic objectForKey:@"ZAOSTATE"] boolValue];
//        BOOL wanState = [[infoDic objectForKey:@"WANSTATE"] boolValue];
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 0)
        {
            UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
            titleLab.textAlignment = NSTextAlignmentLeft;
            titleLab.font = [UIFont fontWithName:kBaseFont size:15];
            titleLab.backgroundColor = [UIColor clearColor];
            titleLab.textColor = [UIColor blackColor];
            titleLab.text = @"城市设置";
            [cell.contentView addSubview:titleLab];
            
            UIButton * cityBut = [[UIButton alloc] initWithFrame:CGRectMake(200, 5, 100, 30)];
            [cityBut setTitle:cityName forState:UIControlStateNormal];
            self.cityBut = cityBut;
            [cityBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            cityBut.titleLabel.font = [UIFont fontWithName:kBaseFont size:15];
            [cityBut addTarget:self action:@selector(cityButAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:cityBut];
            UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"灰色隔条.png"]];
            [m_image setFrame:CGRectMake(0, 39, kScreenWidth, 1)];
            [cell addSubview:m_image];
            return cell;
        }
        if(indexPath.row == 1)
        {
            UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
            titleLab.textAlignment = NSTextAlignmentLeft;
            titleLab.font = [UIFont fontWithName:kBaseFont size:15];
            titleLab.backgroundColor = [UIColor clearColor];
            titleLab.textColor = [UIColor blackColor];
            titleLab.text = @"早间天气预报推送";
            [cell.contentView addSubview:titleLab];
            
            UISwitch * stateSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(230, 5, 60, 30)];
            stateSwitch.tag = indexPath.row;
//            stateSwitch.on = zaoState;
            stateSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"monPushNotification"];
            [stateSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:stateSwitch];
            UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"灰色隔条.png"]];
            [m_image setFrame:CGRectMake(0, 39, kScreenWidth, 1)];
            [cell addSubview:m_image];
            return cell;
        }
        if(indexPath.row == 2)
        {
            UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
            titleLab.textAlignment = NSTextAlignmentLeft;
            titleLab.font = [UIFont fontWithName:kBaseFont size:15];
            titleLab.backgroundColor = [UIColor clearColor];
            titleLab.textColor = [UIColor blackColor];
            titleLab.text = @"晚间天气预报推送";
            [cell.contentView addSubview:titleLab];
            
            UISwitch * stateSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(230, 5, 60, 30)];
            stateSwitch.tag = indexPath.row;
//            stateSwitch.on = wanState;
            stateSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"evePushNotification"];
            [stateSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:stateSwitch];
            UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"灰色隔条.png"]];
            [m_image setFrame:CGRectMake(0, 39, kScreenWidth, 1)];
            [cell addSubview:m_image];
            return cell;
        }
        return nil;

    }
}

-(void)cityButAction:(UIButton *)sender
{
    SelectCityViewController *selectcity=[[SelectCityViewController alloc]init];
    [selectcity setDataSource: m_treeNodeProvince withCitys:m_treeNodeAllCity];
    selectcity.type=@"tianqi";
    [selectcity setDelegate:self];
    [self.navigationController pushViewController:selectcity animated:YES];
//    if(self.cityBg == nil)
//    {
//        self.cityBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
//        self.cityBg.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:self.cityBg];
//        UIView * bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
//        bg.backgroundColor = [UIColor blackColor];
//        bg.alpha = 0.3;
//        [self.cityBg addSubview:bg];
//        
//        _bgImgV = [[UIImageView alloc] init];
//        _bgImgV.frame = CGRectMake(150, 104-40, CGRectGetWidth(self.view.frame)-150, 260);
//        _bgImgV.userInteractionEnabled = YES;
//        _bgImgV.image = [UIImage imageNamed:@"kqzl2背景.png"];
//        [self.cityBg addSubview:_bgImgV];
//        
//        
//        
//        self.cityList = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, CGRectGetWidth(_bgImgV.frame)-20, 260-50)];
//        self.cityList.backgroundColor = [UIColor clearColor];
//        self.cityList.delegate = self;
//        self.cityList.dataSource = self;
//        [_bgImgV addSubview:self.cityList];
//        NSLog(@"11#%f#",self.cityList.frame.origin.x);
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//        [bg addGestureRecognizer:tap];
//        _bgImgV.transform = CGAffineTransformMakeScale(0.1, 0.1);
//        [UIView animateWithDuration:0.2 animations:^{
//            _bgImgV.transform = CGAffineTransformMakeScale(1.1, 1.1);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.15 animations:^{
//                _bgImgV.transform = CGAffineTransformMakeScale(0.8, 0.8);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.05 animations:^{
//                    _bgImgV.transform = CGAffineTransformMakeScale(1.05, 1.05);
//                } completion:^(BOOL finished) {
//                    _bgImgV.transform = CGAffineTransformMakeScale(1, 1);
//                }];
//            }];
//            _bgImgV.transform = CGAffineTransformMakeScale(1, 1);
//        }];
//        NSLog(@"22#%f#",self.cityList.frame.origin.x);
//    }
//    else
//    {
//        NSLog(@"33#%f#",self.cityList.frame.origin.x);
//        self.cityBg.hidden = NO;
//        NSLog(@"44#%f#",self.cityList.frame.origin.x);
//        [self.cityList reloadData];
//        _bgImgV.transform = CGAffineTransformMakeScale(0.1, 0.1);
//        [UIView animateWithDuration:0.2 animations:^{
//            _bgImgV.transform = CGAffineTransformMakeScale(1.1, 1.1);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.15 animations:^{
//                _bgImgV.transform = CGAffineTransformMakeScale(0.8, 0.8);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.05 animations:^{
//                    _bgImgV.transform = CGAffineTransformMakeScale(1.05, 1.05);
//                } completion:^(BOOL finished) {
//                    _bgImgV.transform = CGAffineTransformMakeScale(1, 1);
//                }];
//            }];
//            _bgImgV.transform = CGAffineTransformMakeScale(1, 1);
//        }];
//        NSLog(@"#%f#",self.cityList.frame.origin.x);
//    }

}

-(void)switchAction:(UISwitch *)sender
{
    int tag = sender.tag;
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
            
        case 1:
        {
            
            [self setPropertywithValue:state withKey:@"weatherForecast_morning" withView:sender];
            break;
        }
        case 2:
        {
            
            [self setPropertywithValue:state withKey:@"weatherForecast_evening" withView:sender];
            break;
        }
           }

    
//    NSDictionary * infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"TIANQIYUBAOTONGZHI"];
//    NSMutableDictionary * newDic = [[NSMutableDictionary alloc] initWithDictionary:infoDic];
//    switch (sender.tag) {
//        case 1:
//        {
//            if(sender.on)
//            {
//                [self loadingSSTQ];
//                CFAbsoluteTime t_currentTime = CFAbsoluteTimeGetCurrent();
//                CFGregorianDate m_currentDate = CFAbsoluteTimeGetGregorianDate(t_currentTime, CFTimeZoneCopyDefault());
//                NSString *t_dateWords = [NSString stringWithFormat:@"%d-%d-%d 07:00:00",(int) m_currentDate.year, m_currentDate.month,m_currentDate.day];
//                NSDate * date = [ShareFun NSStringToNSDate:t_dateWords];
//                [self addTuisongWithInfo:_speekingStr withTitle:@"天气预报通知" withClockID:@"zaojiantianqiyubao" withFireDate:date];
//            }
//            else
//            {
//                [self removeNotificationWithClockID:@"zaojiantianqiyubao"];
//            }
//            [newDic setObject:[NSNumber numberWithBool:sender.on] forKey:@"ZAOSTATE"];
//            [[NSUserDefaults standardUserDefaults] setObject:newDic forKey:@"TIANQIYUBAOTONGZHI"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            return;
//        }
//        case 2:
//        {
//            if(sender.on)
//            {
//                [self loadingSSTQ];
//                CFAbsoluteTime t_currentTime = CFAbsoluteTimeGetCurrent();
//                CFGregorianDate m_currentDate = CFAbsoluteTimeGetGregorianDate(t_currentTime, CFTimeZoneCopyDefault());
//                NSString *t_dateWords = [NSString stringWithFormat:@"%d-%d-%d 18:00:00",(int) m_currentDate.year, m_currentDate.month,m_currentDate.day];
//                NSDate * date = [ShareFun NSStringToNSDate:t_dateWords];
//                [self addTuisongWithInfo:_speekingStr withTitle:@"天气预报通知" withClockID:@"wanjiantianqiyubao" withFireDate:date];
//            }
//            else
//            {
//                [self removeNotificationWithClockID:@"wanjiantianqiyubao"];
//            }
//
//            [newDic setObject:[NSNumber numberWithBool:sender.on] forKey:@"WANSTATE"];
//            [[NSUserDefaults standardUserDefaults] setObject:newDic forKey:@"TIANQIYUBAOTONGZHI"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            return;
//        }
//    }
}
-(void)setPropertywithValue:(NSString *)value withKey:(NSString *)key withView:(id)sender
{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    [tip setObject:value forKey:key];
    NSString *cityid=nil;
    if (self.strid.length>0) {
        cityid=self.strid;
    }else{
        cityid=[setting sharedSetting].currentCityID;
    }
    [tip setObject:cityid forKey:@"weatherForecast_city"];
    [setProperty setObject:tip forKey:@"tags"];
    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    [b setObject:setProperty forKey:@"setPushTag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *setpust=[b objectForKey:@"setPushTag"];
        NSString *result=[setpust objectForKey:@"result"];
        int is = [result intValue];
        NSString * error = [h objectForKey:@"error"];
        if(is ==1)
        {
            //成功
            if([key isEqualToString:@"weatherForecast_morning"])
            {
                //hongse
                if([value isEqualToString:@"0"])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"monPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"monPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            if([key isEqualToString:@"weatherForecast_evening"])
            {
                //
                if([value isEqualToString:@"0"])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"evePushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"evePushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
         
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"设置失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            //失败
            
            if([key isEqualToString:@"weatherForecast_morning"])
            {
                //节日
                UISwitch * s = sender;
                BOOL isOpen = s.on;
                s.on = !isOpen;
            }
            if([key isEqualToString:@"weatherForecast_evening"])
            {
                //节气
                UISwitch * s = sender;
                BOOL isOpen = s.on;
                s.on = !isOpen;
            }
            
            
        }
    } withFailure:^(NSError *error) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        if([key isEqualToString:@"weatherForecast_morning"])
        {
            //节日
            UISwitch * s = sender;
            BOOL isOpen = s.on;
            s.on = !isOpen;
        }
        if([key isEqualToString:@"weatherForecast_evening"])
        {
            //节气
            UISwitch * s = sender;
            BOOL isOpen = s.on;
            s.on = !isOpen;
        }
  
        
    } withCache:NO];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if([tableView isEqual:self.cityList])
//    {
//        NSString * originName = self.cityBut.titleLabel.text;
//        NSDictionary * cityInfo = [[setting sharedSetting].citys objectAtIndex:indexPath.row];
//        NSString * name = [cityInfo objectForKey:@"city"];
//        NSString * ID = [cityInfo objectForKey:@"ID"];
//        self.strid=ID;
//        if(![originName isEqualToString:name])
//        {
//            [self.cityBut setTitle:name forState:UIControlStateNormal];
//            
//            NSDictionary * infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"TIANQIYUBAOTONGZHI"];
//            NSMutableDictionary * newDic = [[NSMutableDictionary alloc] initWithDictionary:infoDic];
//            [newDic setObject:name forKey:@"CITYNAME"];
//            [newDic setObject:ID forKey:@"ID"];
//            [[NSUserDefaults standardUserDefaults] setObject:newDic forKey:@"TIANQIYUBAOTONGZHI"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [self removeNotificationWithClockID:@"zaojiantianqiyubao"];
//            [self removeNotificationWithClockID:@"wanjiantianqiyubao"];
//        }
//        self.cityBg.hidden = YES;
//    }
}

-(void)tapAction:(UITapGestureRecognizer *)sender
{
    self.cityBg.hidden = YES;
}

#pragma mark -本地通知

-(void)addTuisongWithInfo:(NSString *)info withTitle:(NSString *)title withClockID:(NSString *)clockID withFireDate:(NSDate *)fireDate
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        //        NSDate *now = [NSDate date];
        //从现在开始，10秒以后通知
        //             notification.fireDate = [NSDate dat]
        notification.repeatInterval = kCFCalendarUnitDay;
        //使用本地时区
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=info;
        notification.fireDate = fireDate;
        
        
        //通知提示音 使用默认的
        notification.soundName= UILocalNotificationDefaultSoundName;
        notification.alertAction=@"关闭";
        //存入的字典，用于传入数据，区分多个通知
        NSMutableDictionary * dicUserInfo = [[NSMutableDictionary alloc] init];
        //        NSString * clockID = [NSString stringWithFormat:@"%@%@%@",self.cityBut.titleLabel.text,color,[ShareFun NSDateToNSString:now]];
        
        [dicUserInfo setValue:clockID forKey:@"clockID"];
        [dicUserInfo setValue:info forKey:@"message"];
        [dicUserInfo setValue:title forKey:@"title"];
        notification.userInfo = [NSDictionary dictionaryWithObject:dicUserInfo forKey:@"dictionary"];
        
        
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
    }
}


-(void)removeNotificationWithClockID:(NSString *)clockID
{
    NSArray * array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSUInteger acount = [array count];
    if(acount>0)
    {
        for(int i=0;i<acount;i++)
        {
            UILocalNotification * myUILocalNotification = [array objectAtIndex:i];
            NSDictionary * userInfo = myUILocalNotification.userInfo;
            NSDictionary * dictionary = [userInfo objectForKey:@"dictionary"];
            NSString * currentID = [dictionary objectForKey:@"clockID"];
            if([currentID isEqual:clockID])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
                break;
            }
        }
    }
}

-(void)loadingSSTQ
{
    NSString * currentID = [setting sharedSetting].currentCityID;
    NSMutableDictionary * clockInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kClockCity];
    if(clockInfo != nil)
    {
        currentID = [clockInfo objectForKey:@"ID"];
    }
//    NSDictionary * returnData = [[setting sharedSetting].DEMO_AllCitySstq objectForKey:currentID];
    NSDictionary * returnData = nil;
    if(returnData)
    {
        NSDictionary* b = [returnData objectForKey:@"b"];
        NSDictionary * sstqAll = [b objectForKey:@"sstq"];
        NSDictionary * sstq = [sstqAll objectForKey:@"sstq"];
        NSString * week = [sstq objectForKey:@"week"];
        NSString * ct = [sstq objectForKey:@"ct"];
        NSString * wt_ico = [sstq objectForKey:@"wt_ico"];
        NSString * wind = [sstq objectForKey:@"wind"];
        NSString * wt_night = [sstq objectForKey:@"wt_night"];
        NSString * wt_daytime = [sstq objectForKey:@"wt_daytime"];
        NSString * humidity = [sstq objectForKey:@"humidity"];
        NSString * wt_night_ico = [sstq objectForKey:@"wt_night_ico"];
        NSString * wt_daytime_ico = [sstq objectForKey:@"wt_daytime_ico"];
        NSString * higt = [sstq objectForKey:@"higt"];
        NSString * lowt = [sstq objectForKey:@"lowt"];
        NSString * cityName = [sstq objectForKey:@"cityName"];
        //        _weekInfoStr = [NSString stringWithFormat:@"%@"]
        
        if(_speekingStr!=nil)
        {
            _speekingStr = nil;
        }
        _speekingStr = [[NSMutableString alloc] initWithString:@""];
        
        
        HL_Temperature time = [ShareFun timeRules];
        
        if(time == Morning)
        {
            [_speekingStr appendFormat:@"今天白天，%@",wt_daytime];
            if([higt intValue]<0)
            {
                [_speekingStr appendFormat:@"最高温度零下%d℃",-[higt intValue]];
            }else
            {
                [_speekingStr appendFormat:@"最高温度%@℃",higt];
            }
            [_speekingStr appendFormat:@"今天夜间，%@",wt_night];
            if([lowt intValue]<0)
            {
                [_speekingStr appendFormat:@"最低温度零下%d℃",-[lowt intValue]];
            }else
            {
                [_speekingStr appendFormat:@"最低温度%@℃",lowt];
            }
            [_speekingStr appendFormat:@"%@",wind];
            if([ct intValue]<0)
            {
                [_speekingStr appendFormat:@"现在温度，零下%d℃",-[ct intValue]];
            }else
            {
                [_speekingStr appendFormat:@"现在温度,%@℃",ct];
            }
            
            //        [_temperatureBut setTitle:[NSString stringWithFormat:@"%@°~%@°",lowt,higt] forState:UIControlStateNormal];
            //            if(lowt.length && higt.length)
            //            {
            //                //            _temperatureLab.text = [NSString stringWithFormat:@"%@°~%@°",lowt,higt];
            //                _H_temperatureImgV.hidden = NO;
            //                _L_temperatyreImgV.hidden = NO;
            //                _H_temperatureImgV.image = [UIImage imageNamed:@"zy温度下"];//低
            //                _H_temperatureLab.text = [NSString stringWithFormat:@"%@℃",lowt];
            //                _L_temperatyreImgV.image = [UIImage imageNamed:@"zy温度上"];//高
            //                _L_temperatyreLab.text = [NSString stringWithFormat:@"%@℃",higt];
            //            }
        }
        else if(time == Noon)
        {
            [_speekingStr appendFormat:@"今天夜间，%@",wt_night];
            if([lowt intValue]<0)
            {
                [_speekingStr appendFormat:@"最低温度零下%d℃",-[lowt intValue]];
            }else
            {
                [_speekingStr appendFormat:@"最低温度%@℃",lowt];
            }
            [_speekingStr appendFormat:@"明天白天，%@",wt_daytime];
            if([higt intValue]<0)
            {
                [_speekingStr appendFormat:@"最高温度零下%d℃",-[higt intValue]];
            }else
            {
                [_speekingStr appendFormat:@"最高温度%@℃",higt];
            }
            [_speekingStr appendFormat:@"%@",wind];
            if([ct intValue]<0)
            {
                [_speekingStr appendFormat:@"现在温度，零下%d℃",-[ct intValue]];
            }else
            {
                [_speekingStr appendFormat:@"现在温度,%@℃",ct];
            }
            
            //        [_temperatureBut setTitle:[NSString stringWithFormat:@"%@°~%@°",higt,lowt] forState:UIControlStateNormal];
            //            if(lowt.length && higt.length)
            //            {
            //                //            _temperatureLab.text = [NSString stringWithFormat:@"%@°~%@°",higt,lowt];
            //                _H_temperatureImgV.hidden = NO;
            //                _L_temperatyreImgV.hidden = NO;
            //                _H_temperatureImgV.image = [UIImage imageNamed:@"zy温度上"];//高
            //                _H_temperatureLab.text = [NSString stringWithFormat:@"%@℃",higt];
            //                _L_temperatyreImgV.image = [UIImage imageNamed:@"zy温度下"];//低
            //                _L_temperatyreLab.text = [NSString stringWithFormat:@"%@℃",lowt];
            //            }
        }
        else if(time == Evening)
        {
            [_speekingStr appendFormat:@"今天夜间，%@",wt_night];
            if([lowt intValue]<0)
            {
                [_speekingStr appendFormat:@"最低温度零下%d℃",-[lowt intValue]];
            }else
            {
                [_speekingStr appendFormat:@"最低温度%@℃",lowt];
            }
            [_speekingStr appendFormat:@"今天白天，%@",wt_daytime];
            if([higt intValue]<0)
            {
                [_speekingStr appendFormat:@"最高温度零下%d℃",-[higt intValue]];
            }else
            {
                [_speekingStr appendFormat:@"最高温度%@℃",higt];
            }
            [_speekingStr appendFormat:@"%@",wind];
            if([ct intValue]<0)
            {
                [_speekingStr appendFormat:@"现在温度，零下%d℃",-[ct intValue]];
            }else
            {
                [_speekingStr appendFormat:@"现在温度,%@℃",ct];
            }
            //        [_temperatureBut setTitle:[NSString stringWithFormat:@"夜间最低温%@°",lowt] forState:UIControlStateNormal];
            //            if(lowt.length && higt.length)
            //            {
            //                //            _temperatureLab.text = [NSString stringWithFormat:@"夜间最低温%@°",lowt];
            //                _H_temperatureImgV.image = [UIImage imageNamed:@"zy温度下"];//低
            //                _L_temperatyreImgV.hidden = YES;
            //                _H_temperatureLab.text = [NSString stringWithFormat:@"%@℃",lowt];
            //            }
            //
        }
        //        if([ShareFun isNight])
        //        {
        //            _weatherLab.text = wt_night;
        //            _weatherLogoIV.image = [UIImage imageNamed:wt_night_ico];
        //        }
        //        else
        //        {
        //            _weatherLab.text = wt_daytime;
        //            _weatherLogoIV.image = [UIImage imageNamed:wt_daytime_ico];
        //        }
        //        
        //        
        //        _humidityLab.text = humidity;
        //        NSLog(@"#%@#",humidity);
        //        _windLab.text = wind;
        
        
    }
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
