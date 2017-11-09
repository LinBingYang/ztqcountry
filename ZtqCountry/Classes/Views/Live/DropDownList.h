//
//  DropDownList.h
//  ZtqFujian_new
//
//  Created by linxg on 12-9-5.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DropDownList;

@protocol DropDownListDelegate <NSObject>

- (void) didSelectDropListItem:(DropDownList *)dropDownList withIndex:(NSInteger)index;
-(void)dlist:(DropDownList *)dropDownList;
@end


@interface DropDownList : UIView<UITableViewDelegate,UITableViewDataSource> {
	__weak id <DropDownListDelegate> delegate;
	
	__strong NSArray *list;            //下拉列表数据
	BOOL showList;             //是否弹出下拉列表
	UIButton *button;		//按钮
	UITableView *listView;    //下拉列表
	UIColor *lineColor, *listBgColor;//下拉框的边框色、背景色
	CGFloat lineWidth;               //下拉框边框粗细
	CGRect oldFrame, newFrame;
    
}

@property (nonatomic,weak)id delegate;
@property (nonatomic,strong)NSArray *list;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UITableView *listView;
@property (nonatomic,strong)UIColor *lineColor,*listBgColor;

- (void) drawView;
- (BOOL) getShowList;
- (void) setShowList:(BOOL)b;

@end
