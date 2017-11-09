//
//  AirinfoList.h
//  ZtqCountry
//
//  Created by Admin on 15/6/17.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AirinfoList;
@protocol airlistDelegate <NSObject>

- (void) airlistdidSelect:(AirinfoList *)list withIndex:(NSInteger)index;
-(void)airinfodlist:(AirinfoList *)dropDownList;
@end
@interface AirinfoList : UIView<UITableViewDelegate,UITableViewDataSource>{
    //    UITableView *m_tableView;
    __strong NSArray *list;            //下拉列表数据
    BOOL showList;             //是否弹出下拉列表
    UIButton *button;		//按钮
    UITableView *listView;    //下拉列表
    UIColor *lineColor, *listBgColor;//下拉框的边框色、背景色
    CGFloat lineWidth;               //下拉框边框粗细
    CGRect oldFrame, newFrame;
    
}
@property (weak, nonatomic) id<airlistDelegate>delegate;
@property (nonatomic,strong)NSArray *list;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UITableView *listView;
@property (nonatomic,strong)UIColor *lineColor,*listBgColor;

- (void) drawView;
- (BOOL) getShowList;
- (void) setShowList:(BOOL)b;

@end
