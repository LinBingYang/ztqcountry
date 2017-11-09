//
//  AirRankProvinceVC.h
//  ZtqCountry
//
//  Created by 派克斯科技 on 16/7/29.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "AirDialog.h"
#import "CityRankDialog.h"
#import "ShareSheet.h"
#import "weiboVC.h"

@interface AirRankProvinceVC : UIViewController<UITableViewDelegate, UITableViewDataSource,AirDialogDelegate,CityDialogDelegate,MFMessageComposeViewControllerDelegate,UIGestureRecognizerDelegate>{
    UITableView *m_tableView;
    NSMutableArray *m_tableData;
    UIButton *kqzl_button;//空气质量
    UIButton *air_button;//空气质量指数说明
    UIButton *order_button;//排序按钮
    UIButton *city_button;//城市选择弹窗
    
    NSString *airNamge;//空气质量名称
    Boolean orderflag;//排序标示
    NSString *aqiCity;//aqi城市
    
    bool showcolor;//排名是否显示颜色
    
    NSString *airDes;//空气指数描述
    NSMutableArray *m_airArray;//弹窗 数据
    NSMutableArray *m_airValue;//弹窗 返回值
    NSMutableArray *m_cityArray;//弹窗 数据
    NSMutableArray *m_cityValue;//弹窗 返回值
    NSMutableArray *m_areaid;
    NSInteger sign;
    NSInteger menuflag;//返回是否出现菜单 0不出现 1出现
    UIImageView *m_gdBg;
    TreeNode *m_allCity;
}
@property(nonatomic,strong)AirDialog *airdialog;//弹窗
@property(nonatomic,strong)CityRankDialog *citydailog;//
@property(nonatomic,strong)NSString *airDes;//空气指数描述
@property(nonatomic,strong)NSMutableArray *m_airArray;//弹窗 数据
@property(nonatomic,strong)NSMutableArray *m_airValue;//弹窗 返回值
@property(nonatomic,strong)NSMutableArray *m_cityArray;//弹窗 数据
@property(nonatomic,strong)NSMutableArray *m_cityValue;//弹窗 返回值
@property(nonatomic,strong)NSMutableArray *m_areaid;
@property(nonatomic,strong)NSString *aqiCity;//aqi城市
@property(assign)float heigh;
@property(assign)float barhight;
@property(retain,nonatomic)UIImageView *navigationBarBg;
@property(strong,nonatomic)UISegmentedControl *myseg;
@property NSInteger menuflag;
@property(assign)float ctwidth;//词条长度
@property(strong,nonatomic)UIImageView *line;

@property(assign)int cityrow;//城市的第几个

@property(strong,nonatomic)NSString *areaid;
@property(strong,nonatomic)NSString *rankType;//空气排名类型

@property(strong,nonatomic)NSString *sharecontent;//分享内容
@property(strong,nonatomic)UIImage *shareimg;
@property(nonatomic, strong)NSString *selectProvinceName;//选中的省份的名字
@property(nonatomic, assign)BOOL isProvince;

@end

