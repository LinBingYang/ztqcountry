//
//  PCSScrollView.h
//  HttpTest
//
//  Created by yu lz on 11-12-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>


@class PCSScrollView;
@protocol PCSScrollViewDelegate <NSObject>
@required
//上下滑动事件
- (void) scrollViewDidScrollUp;
- (void) scrollViewDidScrollDown;
- (void) scrollViewDidScroll:(PCSScrollView *)scrollView;
@end


@interface PCSScrollView : UIView <UIScrollViewDelegate> {
//	id <PCSScrollViewDelegate> delegate;
    __weak id <PCSScrollViewDelegate> delegate;
	NSMutableArray	*slideViews;
	UIScrollView	*scrollView;
	UIPageControl	*pageControl;
	
	bool isScroll;
	int index;
	UIView *m_view;
}
@property (weak)id delegate;

- (void) addSlideView:(UIView *)pageView;
- (void) reset;
- (NSInteger) getCurrentPage;
- (void) setCurrentPage:(NSInteger)pageIdx;
- (void) setGesturePage:(NSInteger)pageIdx;
//当所有滑动视图add完成后，调用setScroll必须调用且仅调用一次，来设置是否循环滑动
- (void) setScroll:(bool)is;
- (NSInteger) count;
@end
