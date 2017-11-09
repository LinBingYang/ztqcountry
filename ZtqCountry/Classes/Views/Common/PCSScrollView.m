//
//  PCSScrollView.m
//  HttpTest
//
//  Created by yu lz on 11-12-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define HEIGHT_OF_PAGECONTROL 20

#import "PCSScrollView.h"

@interface PCSScrollView(PrivateMethods)
- (void) startGesture : (UIView *)pageView;
@end

@implementation PCSScrollView

@synthesize delegate;

- (id) initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame: frame]) {

		pageControl = [[UIPageControl alloc ] initWithFrame:CGRectMake(0, frame.size.height - HEIGHT_OF_PAGECONTROL, frame.size.width, HEIGHT_OF_PAGECONTROL)];
		[self addSubview:pageControl];
//		[pageControl release];
		pageControl.numberOfPages = 0;
		pageControl.currentPage = 0;
        pageControl.currentPageIndicatorTintColor =[UIColor colorHelpWithRed:23 green:112 blue:212 alpha:1];
        pageControl.pageIndicatorTintColor =[UIColor colorHelpWithRed:213 green:213 blue:213 alpha:1];
       
		CGRect scrollFrame;
		scrollFrame.origin.x = 0;
		scrollFrame.origin.y = 0;
		scrollFrame.size.width = frame.size.width;
		scrollFrame.size.height = frame.size.height;
		
		scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
		[self addSubview:scrollView];
//		[scrollView release];
		scrollView.delegate = self;
		scrollView.bounces = NO;
		scrollView.pagingEnabled = YES;
		scrollView.userInteractionEnabled = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		
		slideViews = [[NSMutableArray alloc] initWithCapacity:4];
		isScroll = NO;
    }
	return self;
}

- (void) dealloc {
	[slideViews removeAllObjects];
//	[slideViews release];
    slideViews = nil;
//	[super dealloc];
}

- (void) addSlideView:(UIView *)pageView
{
	if (pageView == nil)
		return;
	[slideViews addObject:pageView];
}

- (void) reset
{
	for (UIView *t_subView in slideViews)
	{
		if (t_subView != nil)
		{
			[t_subView removeFromSuperview];
		}
	}
	[slideViews removeAllObjects];
	isScroll = NO;
	
//	pageControl.numberOfPages = 0;
//	pageControl.currentPage = 0;
}

- (NSInteger) getCurrentPage
{
	return pageControl.currentPage;
}

- (void) setCurrentPage:(NSInteger)pageIdx
{
	if (pageIdx < 0 || pageIdx >= [slideViews count])
		return;
	
	int w = self.frame.size.width;
	int h = self.frame.size.height - HEIGHT_OF_PAGECONTROL;
	pageControl.currentPage = pageIdx;
	if (isScroll)
		[scrollView scrollRectToVisible:CGRectMake(w * (pageIdx + 1), 0, w, h) animated:NO];
	else {
		[scrollView scrollRectToVisible:CGRectMake(w * pageIdx, 0, w, h) animated:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"setmynavigation" object:nil];
    }
}

- (void) setGesturePage:(NSInteger)pageIdx
{
	if (pageIdx < 0 || pageIdx >= [slideViews count])
		return;
	
	UIView *t_subView = [slideViews objectAtIndex:pageIdx];
	[self startGesture:t_subView];
}

- (void) setScroll:(bool)is
{
	if (slideViews == nil || [slideViews count] == 0)
		return;
	isScroll = is;
	
	pageControl.currentPage = 0;
	pageControl.numberOfPages = [slideViews count];
	
	
	int w = self.frame.size.width;
	int h = self.frame.size.height - HEIGHT_OF_PAGECONTROL;
	if (isScroll)
	{//循环滑动
		for (int i=0; i<[slideViews count]; i++) {
			UIView *subView = [slideViews objectAtIndex:i];
			subView.frame = CGRectMake(w * (i + 1), 0, w, h);
			[scrollView addSubview:subView];
		}
		
		[scrollView setContentSize:CGSizeMake(w * ([slideViews count] + 2), h)];
		[scrollView setContentOffset:CGPointMake(0, 0)];
		[scrollView scrollRectToVisible:CGRectMake(w, 0, w, h) animated:NO];
	}
	else 
	{//不循环滚动
		for (int i = 0;i<[slideViews count];i++) {
			//loop this bit
			UIView *subView = [slideViews objectAtIndex:i];
			subView.frame = CGRectMake(w * i , 0, w, h);
			[scrollView addSubview:subView];
			
			[scrollView setContentSize:CGSizeMake(w * ([slideViews count]), h)];
			[scrollView setContentOffset:CGPointMake(0, 0)];
			[scrollView scrollRectToVisible:CGRectMake(0, 0, w, h) animated:NO];
		}
	}
}

- (NSInteger) count
{
	return [slideViews count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)t_scrollView {
	
	int w = self.frame.size.width;
	int h = self.frame.size.height - HEIGHT_OF_PAGECONTROL;
	if (isScroll)
	{
		int currentPage = 
		floor((scrollView.contentOffset.x - scrollView.frame.size.width / ([slideViews count] + 2)) / 
			  scrollView.frame.size.width) + 1;

		if (currentPage == 0) {
			//go last but 1 page
			[scrollView scrollRectToVisible:CGRectMake(w * [slideViews count],0, w, h) animated:NO];
		} else if (currentPage == ([slideViews count]+1)) {
			[scrollView scrollRectToVisible:CGRectMake(w, 0, w, h) animated:NO];
		}
	}
	if (delegate != nil && [delegate respondsToSelector:@selector(scrollViewDidScroll:)])
		[delegate scrollViewDidScroll:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	int w = self.frame.size.width;
	int h = self.frame.size.height - HEIGHT_OF_PAGECONTROL;
	if (isScroll)
	{
		int currentPage = 
		floor((scrollView.contentOffset.x - scrollView.frame.size.width / ([slideViews count] + 2)) / 
			  scrollView.frame.size.width) + 1;
//		NSLog(@"currentPages = %d", currentPage);

		if (currentPage == 1)
		{//第一页，把最后一页设置第一页前面，形成循环
			[[slideViews objectAtIndex:0] setFrame:CGRectMake(w, 0, w, h)];
			[[slideViews objectAtIndex:[slideViews count] - 1] setFrame:CGRectMake(0, 0, w, h)];
		}
		else if (currentPage == [slideViews count]) 
		{//最后一页，把第一页设置最后一页后面，形成循环
			[[slideViews objectAtIndex:0] setFrame:CGRectMake(w * ([slideViews count] + 1), 0, w, h)];
			[[slideViews objectAtIndex:[slideViews count] - 1] setFrame:CGRectMake(w * [slideViews count], 0, w, h)];
		}
		else if (currentPage > 1 && currentPage < [slideViews count])
		{
			[[slideViews objectAtIndex:0] setFrame:CGRectMake(w, 0, w, h)];
			[[slideViews objectAtIndex:[slideViews count] - 1] setFrame:CGRectMake(w * [slideViews count], 0, w, h)];
		}
		
		if (currentPage > 0 || currentPage < [slideViews count] + 1)
			pageControl.currentPage = currentPage - 1;
		if (currentPage == 0)
			pageControl.currentPage = [slideViews count] - 1;
		if (currentPage == [slideViews count] + 1)
			pageControl.currentPage = 0;
	}
	else 
	{
		int currentPage = 
		floor((scrollView.contentOffset.x - scrollView.frame.size.width / ([slideViews count])) / 
			  scrollView.frame.size.width) + 1;
		pageControl.currentPage = currentPage;
	}
}

- (void) startGesture : (UIView *)pageView
{
	if (pageView == nil)
		return;
	NSInteger a = pageView.frame.size.width;
	NSInteger b = pageView.frame.size.height;
	m_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, a, b)];
	[pageView addSubview:m_view];
//	[m_view release];
	m_view.userInteractionEnabled = YES;
	
	//向上手势划动
	UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc]
												initWithTarget:self
												action:@selector(swipeGestureHandler:)];
	swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
	[m_view addGestureRecognizer:swipeUpGesture];
//	[swipeUpGesture release];
	
	//向下手势划动
	UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc]
												  initWithTarget:self
												  action:@selector(swipeGestureHandler:)];
	swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
	[m_view addGestureRecognizer:swipeDownGesture];
//	[swipeDownGesture release];	
}

- (IBAction)swipeGestureHandler:(UISwipeGestureRecognizer *)sender {
	UISwipeGestureRecognizerDirection direction = [sender direction];
	
	switch (direction) {
		case UISwipeGestureRecognizerDirectionDown:
			if (delegate != nil)
				[delegate scrollViewDidScrollDown];
			break;
		case UISwipeGestureRecognizerDirectionUp:
			if (delegate != nil)
				[delegate scrollViewDidScrollUp];
			break;
		default:
			break;
	}
}

@end
