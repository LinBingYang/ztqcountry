//
//  YearAndMonthList.h
//  ZtqCountry
//
//  Created by Admin on 15/12/3.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YearAndMonthList;
@protocol YAMlistDelegate <NSObject>

- (void) YAMdidSelect:(YearAndMonthList *)list withIndex:(NSInteger)index;

@end
@interface YearAndMonthList : UIView<UITableViewDelegate,UITableViewDataSource>{
    //    UITableView *m_tableView;
    __strong NSArray *list;            //下拉列表数据
    BOOL showList;             //是否弹出下拉列表
    UIButton *button;		//按钮
    UITableView *listView;    //下拉列表
    UIColor *lineColor, *listBgColor;//下拉框的边框色、背景色
    CGFloat lineWidth;               //下拉框边框粗细
    CGRect oldFrame, newFrame;
    
    
}
@property (weak, nonatomic) id<YAMlistDelegate>delegate;
@property (nonatomic,strong)NSArray *list;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UITableView *listView;
@property (nonatomic,strong)UIColor *lineColor,*listBgColor;
@property(nonatomic,strong)NSString *isopen;
- (void) drawView;
- (BOOL) getShowList;
- (void) setShowList:(BOOL)b;

@end
