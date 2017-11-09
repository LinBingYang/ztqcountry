//
//  PMViewController.h
//  ZtqNew
//
//  Created by linxg on 13-8-8.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PMView.h"
#import "airIndexModle.h"
#import "AirDialog.h"

@interface PMViewController : UIViewController<AirDialogDelegate>{
    UIButton *city_button;
    UILabel *t_updateTime;
    UILabel *t_aqi;
    UILabel *t_pm25;
    UILabel *t_pm10;
    UILabel *t_co;
    UILabel *t_no2;
    UILabel *t_o3;
    UILabel *t_o38h;
    UILabel *t_so2;
    UILabel *t_quality;
    UILabel *t_health;
    UIImageView *prompt;//aqi描述背景图
    PMView *_pmView;//图表
    
    float _imageLabelWidth;
    
    NSMutableArray *m_cityArray;//弹窗 数据
    NSMutableArray *m_cityValue;//弹窗 返回值
    NSString *dateType;//城市or监测点
    
    UIImageView *m_gdBg;
    
    TreeNode *m_province;
	TreeNode *m_allCity;
}
@property(nonatomic,strong)NSMutableArray *m_cityArray;//弹窗 数据
@property(nonatomic,strong)NSMutableArray *m_cityValue;//弹窗 返回值
@property(nonatomic,strong)NSString *dateType;//城市or监测点
@property(nonatomic,strong)NSString *m_city;//当前城市，放在第一列
@property(nonatomic,strong)NSString *titlename;
@property(assign)float barHeight;
@property(retain,nonatomic)UIImageView *navigationBarBg;
@property(assign)int sign;//判断返回那一页
@property(strong,nonatomic)NSString *areaid;
@property(assign)int youyunum;//优于全国的城市的值
@property(strong,nonatomic)NSString *healthstr;//健康建议


-(void)getDataWithcity:(NSString*)t_city type:(NSString*)t_type;
@end
