//
//  TFListView.h
//  ZtqCountry
//
//  Created by Admin on 15/6/30.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "typhoonYearModel.h"
@class TFListView;
@protocol tflistDelegate <NSObject>

- (void) tflistdidSelect:(TFListView *)list withIndex:(NSInteger)index;
-(void)tfActionwith:(NSMutableArray *)mytflist;
@end
@interface TFListView : UIView<UITableViewDelegate,UITableViewDataSource>{
    //    UITableView *m_tableView;
    __strong NSArray *list;            //下拉列表数据
    BOOL showList;             //是否弹出下拉列表
    UIButton *button;		//按钮
    UITableView *listView;    //下拉列表
    UIColor *lineColor, *listBgColor;//下拉框的边框色、背景色
    CGFloat lineWidth;               //下拉框边框粗细
    CGRect oldFrame, newFrame;
     typhoonYearModel *tf_yearModel;
    
}
@property (weak, nonatomic) id<tflistDelegate>delegate;
@property (nonatomic,strong)NSArray *list;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UITableView *listView;
@property (nonatomic,strong)UIColor *lineColor,*listBgColor;
@property(strong,nonatomic)NSArray *tflists;
@property(strong,nonatomic)NSMutableArray *mytflist;
- (void) drawView;
- (BOOL) getShowList;
- (void) setShowList:(BOOL)b;

@end
