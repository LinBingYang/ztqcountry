//
//  MianzeViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-7-30.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "MianzeViewController.h"


@interface MianzeViewController ()

@end

@implementation MianzeViewController

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
    [self setNavigation];

    CGRect t_frame = CGRectMake(0, self.barHeight, self.view.width,kScreenHeitht-self.barHeight);
    
    NSString *k_title = @"免责声明";
    
    NSString *c_title = [NSString stringWithFormat:@"       1、 “知天气”提供的天气预报信息产品服务仅供用户作为生活、生产等活动的参考信息，用户据此作出的行为及所产生的后果与“知天气”及其关联的单位无关。\n       2、 由于不可抗力或互联网传输原因等造成信息传播的延迟、中断和缺失，“知天气”不承担任何责任。因不可预测或无法控制的系统故障、设备故障、通讯故障等原因给用户造成损失的，“知天气”不承担任何的赔偿责任。\n       3、 “知天气”努力给用户提供及时、准确的天气信息产品服务，但不承担因预报准确率原因引起的任何损失、损害。您在使用“知天气”时可能产生的GPRS流量资费各地不同，由当地运营商收取。\n       4、 “知天气”掌上气象提供的所有数据仅供参考，不具备法律效力，不得挪为他用。\n       5、 本声明的最终解释权归“知天气”所有。\n       以上风险提示，您已阅读并理解，如果继续使用，即表明您同意承担使用“知天气”所有服务可能存在的风险。"];
   AboutView * about = [[AboutView alloc] initWithView:k_title setMessage:c_title setRect:t_frame];
    about.delegate = self;
    [self.view addSubview:about];
//    [about show];

    
}

-(void)setNavigation
{
    self.titleLab.text = @"免责声明";
    self.titleLab.textColor = [UIColor whiteColor];
    self.barHiden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -AboutViewDelegate

-(void)AboutViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
