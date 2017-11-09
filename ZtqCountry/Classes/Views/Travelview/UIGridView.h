//
//  UIGridView.h
//  Ztq_public
//
//  Created by linxg on 12-2-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "UIGridItem.h"
/*
 * todo:
 * 1、分页
 * 2、横屏滑动还是竖屏滑动切换
 * 3、移动一个视图从一页到另一页
 */
@protocol UIGridViewDelegate;
@protocol UIGridViewDataSource;

@interface gridScrollView : UIScrollView {
	
}
@end

@interface UIGridView : UIView {
	gridScrollView *scrollView;		
	UIView *currentSelectedView;		// 指向当前选中子视图
	CALayer *alphaLayer;				// 透明遮罩层
	
	// 横竖版布局
	int rowCount;						// 一行视图个数
	int columnCount;					// 一列视图个数
	
	CGFloat rowIntervalSpace;			// 行间距
	CGFloat columnIntervalSpace;		// 列间距
	
	NSMutableArray *itemViews;			// 子视图数组
	NSMutableArray *deleteBtns;			// 删除按钮
	
	BOOL deleteActiving;				// 长按进入删除激活状态中标志
	NSDate *touchStartTime;				// touch开始时间
	CGPoint touchStartPoint;			// 开始触摸位置
	CGPoint lastTouchPoint;				// 上次触摸位置
	
	NSThread *timerThread;				// 时间线程
	NSTimer *touchTimer;				// 触摸定时器
	
//	id<UIGridViewDelegate> delegate;
//	id<UIGridViewDataSource> dataSource;
     __weak id<UIGridViewDelegate> delegate;
	__weak id<UIGridViewDataSource> dataSource;
}
@property(nonatomic, weak) id<UIGridViewDelegate> delegate;
@property(nonatomic, weak) id<UIGridViewDataSource> dataSource;

@property(nonatomic, assign) BOOL deleteActiving;
@property (nonatomic, strong) NSDate * touchStartTime;

- (void)reloadData;
- (UIGridItem *) dequeueReusableCellWithIdentifier:(NSString *)str;

- (void)showDeleteAnimation;
- (void)cancelDeleteAnimation;
- (void)resetLayoutAfterRotation;
@end

@protocol UIGridViewDataSource
- (NSInteger)gridItemCount:(UIGridView *)gridView;
- (UIGridItem *)gridItemWithIndex:(UIGridView *)gridView withIndex:(NSInteger)index;
@end


@protocol UIGridViewDelegate<NSObject>
- (void)viewSelectedWithIndex:(UIGridView *)gridView withIndex:(NSInteger)index;
- (void)viewDeletedWithIndex:(UIGridView *)gridView withIndex:(NSInteger)index;

//index1为源索引,index2为目标索引(insert)
- (void)viewExchangeWithIndex:(UIGridView *)gridView withIndex1:(NSInteger)index1 withIndex2:(NSInteger)index2;
@end
