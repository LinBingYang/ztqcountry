//
//  WindowAndRainVC.h
//  ZtqCountry
//
//  Created by Admin on 16/1/13.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import "TFSheet.h"
#import "WRScrollView.h"
@interface WindowAndRainVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ActionSheetDelegate,wrClickDelegate>{
        UIPickerView *mypickerview;
        TreeNode *m_allCity;
}
@property(nonatomic, strong) UITableView *tableView;
@property(strong,nonatomic)NSArray *ranks,*ranknames;
@property(strong,nonatomic)NSString *ranktime,*rankname;
@property(strong,nonatomic)UIButton *rankbtn;
@property(assign)BOOL isothertype;//是否其他地方返回
@property(assign)BOOL ispaysuccess;
@property(strong,nonatomic)WRScrollView *mywrscrollview;
@property(strong,nonatomic)NSMutableArray *adtitles,*adimgurls,*adurls;
@property(assign)float cellheight;
@end
