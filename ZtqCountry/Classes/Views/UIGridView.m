//
//  UIGridView.m
//  Ztq_public
//
//  Created by linxg on 12-2-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIGridView.h"
#import <QuartzCore/QuartzCore.h>

//! scrollview 视图布局
//! 设置origin
#define SCROLL_ORIGIN_POINT CGPointMake(0, 0)//(220, 0)

//! 设置size
#define SCROLL_SIZE_PORTRAIT CGSizeMake(320, 480)//(547, 1024)
#define SCROLL_SIZE_LANDSCAPE CGSizeMake(480, 320)//(804, 768)

//! 设置frame
#define SCROLL_FRAME_PORTRAIT CGRectMake(SCROLL_ORIGIN_POINT.x, SCROLL_ORIGIN_POINT.y, SCROLL_SIZE_PORTRAIT.width, SCROLL_SIZE_PORTRAIT.height)
#define SCROLL_FRAME_LANDSCAPE CGRectMake(SCROLL_ORIGIN_POINT.x, SCROLL_ORIGIN_POINT.y, SCROLL_SIZE_LANDSCAPE.width, SCROLL_SIZE_LANDSCAPE.height)

// 默认的item视图大小
#define ITEM_VIEW_SIZE CGSizeMake(95, 100)
#define ITEM_VIEW_BOUNDS CGRectMake(0, 0, ITEM_VIEW_SIZE.width, ITEM_VIEW_SIZE.height)

//! 横竖显示
#define ROW_COUNT_PORTRAIT 3
#define ROW_COUNT_LANDSCAPE 3

//! itemview在scrollview开始布局的origion
#define LAYOUT_START_ORRIGIN CGPointMake(0, 0)

//! 动画开关
#define WHIPPING_DELETE_ANIMATION 1	// 摆动效果
#define SCALE_ANIMATION 0			// 缩放效果

//! 点击有效移动距离
#define TOUCH_MOVE_EFFECT_DIST 10.0f

//! 初始视图数目
#define ORIGIN_ITEM_VIEWS_COUNT 5

//! 删除激活时间 
#define DELETE_ACTIVING_TIME 1.5

//! 删除动画抖动
#define DELETE_BTN_FRAME		CGRectMake(-17, -16, 50, 50)
#define DELETE_BTN_IMAGE_NAME	@"删除1.png"

@interface UIGridView(private)
// init 
- (void)initItemViews;
- (void)initScrollView;
- (void)initAlphaLayer;
- (void)initNavigationBarBtn;

// layout 
- (void)layoutItemViews;
- (BOOL)exchangeViewsPosition:(UIView*)touchView;
- (CGPoint)getOriginPointWithIndex:(NSInteger)index;
- (CGPoint)getCenterPointWithIndex:(NSInteger)index;
- (void)resetLayoutValues;
- (void)setScrollViewContentSize;

// view layer show dismiss
- (void)addAlphaLayerInView:(UIView*)superView;
- (void)removeAlphaLayer;
- (void)removeItemView:(UIView*)cView;
- (void)checkDeleteWithShowAlertView:(UIButton*)sender;

// animation
- (void)showDeleteAnimation;
- (void)cancelDeleteAnimation;
- (void)showScaleAnimation;
- (void)whippingAnimationWithView:(UIView*)view;
- (void)scaleAnimationWithView:(UIView*)view;
- (void)removeAnimationWithView:(UIView*)view;

// timer
- (void)checkTouchTime:(NSTimer*)timer;
- (void)startTimerThead;
- (void)stopTouchTimer;
@end


@implementation gridScrollView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.multipleTouchEnabled = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	[[self nextResponder] touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesMoved:touches withEvent:event];
	[[self nextResponder] touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	[[self nextResponder] touchesEnded:touches withEvent:event];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

//- (void)dealloc {
//    [super dealloc];
//}

@end


@implementation UIGridView
@synthesize delegate;
@synthesize dataSource;
@synthesize deleteActiving;
@synthesize touchStartTime = touchStartTime;
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		itemViews = [[NSMutableArray alloc] init];
		deleteBtns = [[NSMutableArray alloc] init];
		
		[self initScrollView];
		[self initAlphaLayer];
		
		[self resetLayoutValues];
		[self layoutItemViews];
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

//- (void)dealloc {
//	// view
//	[scrollView release];
//	[alphaLayer release];
//	//	[alphaLayer release];  为什么要释放两次呢？
//	
//	// data
//	[itemViews release];
//	[deleteBtns release];
//	
//	[touchStartTime release];
//	[self stopTouchTimer];
//	
//    [super dealloc];
//}


- (void)initScrollView{
	scrollView = [[gridScrollView alloc] initWithFrame:self.frame];
	
	scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	scrollView.userInteractionEnabled = YES;
	scrollView.backgroundColor = [UIColor clearColor];
	
	[self addSubview:scrollView];
}

- (void)initItemViews{
	//	UIView *view;
	//	
	//	for (int i = 0; i < ORIGIN_ITEM_VIEWS_COUNT; ++i) {
	//		view = [[UIView alloc] initWithFrame:ITEM_VIEW_BOUNDS];
	//		[itemViews addObject:view];
	//		view.tag = i;
	//		[view release]; 
	//	}
}

- (void)initAlphaLayer {
	alphaLayer = [[CALayer alloc] init];
	alphaLayer.frame = ITEM_VIEW_BOUNDS;
	alphaLayer.cornerRadius = 6;
	alphaLayer.masksToBounds = YES;
	alphaLayer.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f].CGColor;	
}

- (void)resetLayoutAfterRotation {
	[self resetLayoutValues];
	[self layoutItemViews];
}

#pragma mark add remove view layer
- (void)addAlphaLayerInView:(UIView*)superView{
	if (alphaLayer.superlayer != superView.layer) {
		[superView.layer addSublayer:alphaLayer];
	}
}

- (void)removeAlphaLayer{
	if (alphaLayer.superlayer != nil) {
		[alphaLayer removeFromSuperlayer];
	}
}

- (void)checkDeleteWithShowAlertView:(UIButton*)sender{	
	NSLog(@"delegate view");
    
    
    
	UIView *superView = [itemViews objectAtIndex:sender.superview.tag];
	[self removeItemView:superView];
}

// 简单测试
//- (void)addNewItemView{
//	UIGridItem *view = [[UIGridItem alloc] initWithFrame:ITEM_VIEW_BOUNDS];	
//	
//	// 插入末尾
//	view.tag = [itemViews count];
//	[itemViews addObject:view];
//	
//	// 插入开头
//	//[itemViews insertObject:view atIndex:0];
//	
//	// 取消动画
//	if (deleteActiving) {
//		[self cancelDeleteAnimation];
//	}
//	
//	// 修改tag值 此处可优化
//	for (int i = 0; i < [itemViews count]; ++i) {
//		UIGridItem *cView = [itemViews objectAtIndex:i];
//		cView.tag = i;
//	}
//	[view release];
//	
//	[self setScrollViewContentSize];
//	[self layoutItemViews];	
//}

- (void)removeItemView:(UIView*)cView{
	[cView removeFromSuperview];
	
	NSInteger tag = cView.tag;
	[itemViews removeObjectAtIndex:tag];
	
	// 修改tag，此处可以优化，懒了 :)
	UIView *view;
	for (int i = 0; i < [itemViews count]; ++i) {
		view = [itemViews objectAtIndex:i];
		view.tag = i;
	}
	
	if (delegate)
		[delegate viewDeletedWithIndex:self withIndex:tag];
	
	[self reloadData];
}

- (void)reloadData
{
	if (dataSource == nil)
		return;
	
	[itemViews removeAllObjects];
	
	//重新载入数据
	int count = [dataSource gridItemCount:self];
	for (NSInteger i=0; i<count; i++)
	{
		UIGridItem *view = [dataSource gridItemWithIndex:self withIndex:i];
		[itemViews addObject:view];
		if ([self dequeueReusableCellWithIdentifier:view._identifier] != nil)
			continue;
		
		[view setFrame:ITEM_VIEW_BOUNDS];
		[view setTag:i];
		[self addSubview:view];
		
		if (deleteActiving)
		{
			UIButton *btn = [[UIButton alloc] initWithFrame:DELETE_BTN_FRAME];
			[btn setBackgroundImage:[UIImage imageNamed:DELETE_BTN_IMAGE_NAME] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(checkDeleteWithShowAlertView:) forControlEvents:UIControlEventTouchUpInside];
			[view addSubview:btn];
			[deleteBtns addObject:btn];
//			[btn release];
			
			[self whippingAnimationWithView:view];
		}
		
		//NSLog(@"_identifier = %@", [view _identifier]);
	}
	
	[self setScrollViewContentSize];
	[self layoutItemViews];
	
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.userInteractionEnabled = YES;
}

- (UIGridItem *) dequeueReusableCellWithIdentifier:(NSString *)str
{
	if (str == nil)
		return nil;
	
	for (UIView *aView in [self subviews])
	{
		if ([aView isKindOfClass:[UIGridItem class]])
		{
			UIGridItem *item = (UIGridItem *)aView;
			if (item != nil && [item._identifier isEqualToString:str])
			{
				return item;
			}
		}
		
	}
	
	return nil;
}

#pragma mark layout  

- (void)layoutItemViews{
	CGPoint centerPoint;
	for (int i = 0; i < [itemViews count]; ++i) {
		centerPoint = [self getCenterPointWithIndex:i];
		
		UIView *view = [itemViews objectAtIndex:i];
		
		if (currentSelectedView != view) {
			//			[UIView beginAnimations:nil context:NULL];
			//			[UIView setAnimationBeginsFromCurrentState:YES];
			//			[UIView setAnimationDuration:0.5];
			//			[UIView setAnimationCurve: UIViewAnimationCurveLinear];
			
			[view setCenter:centerPoint];
			
			if (nil == view.superview) {
				[scrollView addSubview:view];
			}
			//			[UIView commitAnimations];
		}
	}
}

- (void)resetLayoutValues{
	CGSize viewSize = ITEM_VIEW_BOUNDS.size;
	
	if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])){
		scrollView.frame = SCROLL_FRAME_PORTRAIT;
	}
	else {
		scrollView.frame = SCROLL_FRAME_LANDSCAPE;
	}
	
	rowCount = scrollView.frame.size.width / viewSize.width; //ROW_COUNT_PORTRAIT;
	rowIntervalSpace = (scrollView.frame.size.width - viewSize.width * rowCount) / (rowCount+1);
	
	columnCount = scrollView.frame.size.height / viewSize.height; //COLUMN_COUNT_PORTRAIT;
	columnIntervalSpace = (scrollView.frame.size.height - viewSize.height * columnCount) / (columnCount+1);
	
	[self setScrollViewContentSize];
}

- (void)setScrollViewContentSize{
	
	if (dataSource == nil)
		return;
	scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame) + LAYOUT_START_ORRIGIN.x, 
										ceilf(1.0f * [dataSource gridItemCount:self] / rowCount)  * (ITEM_VIEW_BOUNDS.size.height + columnIntervalSpace)+ LAYOUT_START_ORRIGIN.y);
}

- (CGPoint)getOriginPointWithIndex:(NSInteger)index{
	CGSize viewSize = ITEM_VIEW_BOUNDS.size;
	
	int row = index / rowCount;
	int column = index % rowCount;
	
	CGPoint originPoint = CGPointMake(LAYOUT_START_ORRIGIN.x + rowIntervalSpace + column * (rowIntervalSpace + viewSize.width) , 
									  LAYOUT_START_ORRIGIN.y + columnIntervalSpace + row * (columnIntervalSpace + viewSize.height));
	//NSLog(@"getOriginPointWithIndex %d = (%f,%f)", index, originPoint.x, originPoint.y);
	return originPoint;
}

- (CGPoint)getCenterPointWithIndex:(NSInteger)index{
	CGSize viewSize = ITEM_VIEW_BOUNDS.size;
	CGPoint originPoint = [self getOriginPointWithIndex:index];
	
	CGPoint centerPoint = CGPointMake(originPoint.x + viewSize.width * 0.5, 
									  originPoint.y + viewSize.height * 0.5);
	
	//NSLog(@"getCenterPointWithIndex %d = (%f,%f)", index, centerPoint.x, centerPoint.y);
	return centerPoint;
}

/*
 * 判断origin的x，y改变值，与(间隔距离+视图高或宽一半)比较
 */
- (BOOL)exchangeViewsPosition:(UIView*)touchView{
	CGPoint baseOriginPoint = [self getOriginPointWithIndex:touchView.tag];
	
	// 现在的初始位置
	CGPoint currentOriginPoint = touchView.frame.origin;
	NSInteger exchangedIndex = touchView.tag;
	
	//<-- 不是行首
	if (touchView.tag % rowCount != 0
		&& currentOriginPoint.x - baseOriginPoint.x < -(rowIntervalSpace + ITEM_VIEW_SIZE.width * 0.5f)) {
		//	NSLog(@"left exchange!");
		exchangedIndex = touchView.tag - 1;
	}
	//--> 不是行尾且不是最后一个
	else if (touchView.tag % rowCount != rowCount - 1 && touchView.tag != [itemViews count]-1
			 && currentOriginPoint.x - baseOriginPoint.x > (rowIntervalSpace + ITEM_VIEW_SIZE.width * 0.5f)) {
		//	NSLog(@"right exchange!");
		exchangedIndex = touchView.tag + 1;
	}
	//^
	//|
	else if (currentOriginPoint.y - baseOriginPoint.y < -(columnIntervalSpace + ITEM_VIEW_SIZE.height * 0.5f)) {
		//	NSLog(@"above exchange!");
		exchangedIndex = touchView.tag - rowCount;
	}
	//|
	//~
	else if (currentOriginPoint.y - baseOriginPoint.y > (columnIntervalSpace + ITEM_VIEW_SIZE.height * 0.5f)) {
		//	NSLog(@"below exchange!");
		exchangedIndex = touchView.tag + rowCount;
	}
	
	//	NSLog(@"exchanged index = %d", exchangedIndex);
	if ((exchangedIndex >= 0 && exchangedIndex < [itemViews count]) 
		&& exchangedIndex != touchView.tag) {
		UIView *exchangedView = [itemViews objectAtIndex:exchangedIndex];
		
		if (delegate)
			[delegate viewExchangeWithIndex:self withIndex1:touchView.tag withIndex2:exchangedView.tag];
		
		// 交换移动位置
//		[exchangedView retain];
//		[touchView retain];
		
		if (touchView.tag > exchangedView.tag) {
			// 从后面往后移动
			for (int i = touchView.tag-1; i >= exchangedView.tag; --i) {
				UIView *view = [itemViews objectAtIndex:i];
				[itemViews replaceObjectAtIndex:i + 1 withObject:view];
				view.tag = i + 1;
			}			
		}
		else {
			// 从前面往前移动
			for (int i = touchView.tag + 1; i <= exchangedView.tag; ++i) {
				UIView *view = [itemViews objectAtIndex:i];
				[itemViews replaceObjectAtIndex:i - 1 withObject:view];
				view.tag = i - 1;
			}
		}
		
		touchView.tag = exchangedIndex;
		[itemViews replaceObjectAtIndex:exchangedIndex withObject:touchView];
		
//		[exchangedView release];
//		[touchView release];	
		
		return YES;
	}
	return NO;
}

#pragma mark touch event
/*
 * 为了保持iphone/ipad通用，采用基本touch事件模拟长按手势、移动手势 
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesBegan");
	UITouch *touch = [touches anyObject];
	UIView *touchView = [touch view];
	if ([touchView isKindOfClass:[UIGridItem class]]) {
		currentSelectedView = touchView;
		[self addAlphaLayerInView:touchView];
		[self removeAnimationWithView:currentSelectedView];
		
		if (!deleteActiving) {
//			[touchStartTime release];
//			touchStartTime = [[NSDate date] retain];
            self.touchStartTime = [NSDate date];
			//! 将定时器放入独立线程,保证在touch事件响应的同时也执行定时器的action
			if (nil == timerThread) {
				timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(startTimerThead) object:nil];
				[timerThread start];
			}
		}
		else {
			// 开始移动，其不能滑动
			scrollView.scrollEnabled = NO;
			[self scaleAnimationWithView:currentSelectedView];
		}
		touchStartPoint = [touch locationInView:scrollView];
		lastTouchPoint = touchStartPoint;
	}

	//del by linxg 2012-8-21
	// 点击自身视图，取消动画
//	else if (deleteActiving) {
//		if (touchView == self || touchView == scrollView) {
//			[self cancelDeleteAnimation];
//		}
//	}
	//del end
	
	self.userInteractionEnabled = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesMoved");
	UITouch *touch = [touches anyObject];
	UIView *touchView = [touch view];
	CGPoint movedPoint = [touch locationInView:scrollView];
	if (deleteActiving) {
		CGPoint deltaVector = CGPointMake(movedPoint.x - lastTouchPoint.x, movedPoint.y - lastTouchPoint.y);
		lastTouchPoint = movedPoint;
		
		if ([touchView isKindOfClass:[UIGridItem class]]) {
			touchView.center = CGPointMake(touchView.center.x + deltaVector.x, touchView.center.y + deltaVector.y);
			// 检测是否可以移位
			if ([self exchangeViewsPosition:touchView]) {
				[self layoutItemViews];
			}
		}
	}
	else {
		CGPoint deltaVector = CGPointMake(movedPoint.x - touchStartPoint.x, movedPoint.y - touchStartPoint.y);
		
		if (fabsf(deltaVector.x) > TOUCH_MOVE_EFFECT_DIST
			|| fabsf(deltaVector.y) > TOUCH_MOVE_EFFECT_DIST) {
			
			[self removeAlphaLayer];
			[self stopTouchTimer];
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesEnded");
	UITouch *touch = [touches anyObject];
	UIView *touchView = [touch view];
	CGPoint movedPoint = [touch locationInView:scrollView];
	CGPoint deltaVector = CGPointMake(movedPoint.x - touchStartPoint.x, movedPoint.y - touchStartPoint.y);
	
	if ([touchView isKindOfClass:[UIGridItem class]]) {
		// 首先移除透明层、动画
		[self removeAlphaLayer];
		[self removeAnimationWithView:currentSelectedView];
		
		if (deleteActiving) {
			CGPoint centerPoint = [self getCenterPointWithIndex:touchView.tag];
			// 添加一个动画
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationBeginsFromCurrentState:YES];
			[UIView setAnimationDuration:0.3];
			[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
			[touchView setCenter:centerPoint];
			[UIView commitAnimations];
			
			// 恢复动画在缩放结束开始
			[self whippingAnimationWithView:currentSelectedView];
			//[self performSelector:@selector(whippingAnimationWithView:) withObject:currentSelectedView afterDelay:0.3];
			
			// touch结束后使其能滑动
			scrollView.scrollEnabled = YES;
		}		
		else {
			[self stopTouchTimer];
			// touch移动在可允许范围内，相应touch进入界面
			if (fabsf(deltaVector.x) < TOUCH_MOVE_EFFECT_DIST
				&& fabsf(deltaVector.y) < TOUCH_MOVE_EFFECT_DIST) {
				
				
				//UIGridItem *view = [itemViews objectAtIndex:currentSelectedView.tag];
				//todo: with delegate
				[delegate viewSelectedWithIndex:self withIndex:currentSelectedView.tag];
			}
		}
		currentSelectedView = nil;		
	}
	self.userInteractionEnabled = YES;
}
#pragma mark  action
- (void)startTimerThead{
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//	
//	touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
//												  target:self 
//												selector:@selector(checkTouchTime:) 
//												userInfo:nil repeats:YES];
//	
//	[runLoop run];
//	[pool release];
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                      target:self
                                                    selector:@selector(checkTouchTime:)
                                                    userInfo:nil repeats:YES];
        
        [runLoop run];

    }
}

- (void)stopTouchTimer{
	if (touchTimer != nil) {
		[touchTimer invalidate];
		touchTimer = nil;
	}
	if (timerThread != nil) {
		[timerThread cancel];
//		[timerThread release];
		timerThread = nil;
	}
}

- (void)checkTouchTime:(NSTimer*)timer{
	if (!scrollView.dragging) {
		if (!deleteActiving) {
			
			NSDate *nowDate = [NSDate date];
			NSTimeInterval didTouchTime = [nowDate timeIntervalSinceDate:touchStartTime];
			if (didTouchTime > DELETE_ACTIVING_TIME){
				
				self.deleteActiving = YES;
				[[NSNotificationCenter defaultCenter] postNotificationName:@"editCity" object:nil];
				[self stopTouchTimer];
				[self showDeleteAnimation];
			}
		}
	}
	else {
		[self stopTouchTimer];
		[self removeAlphaLayer];
	}
}

#pragma mark animation
/*
 * 删除动画抖动
 */

- (void)showDeleteAnimation{
	if (deleteActiving) {
		for (UIView *view in itemViews) {
			
			if (view != currentSelectedView) {
				[self whippingAnimationWithView:view];
			}
			else {
				[self scaleAnimationWithView:view];
			}
			
			// 为每个视图临时添加一个删除按钮
			UIButton *btn = [[UIButton alloc] initWithFrame:DELETE_BTN_FRAME];
			[btn setBackgroundImage:[UIImage imageNamed:DELETE_BTN_IMAGE_NAME] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(checkDeleteWithShowAlertView:) forControlEvents:UIControlEventTouchUpInside];
			[view addSubview:btn];
			[deleteBtns addObject:btn];
//			[btn release];
		}
	}
}

// 取消动画
- (void)cancelDeleteAnimation{
	for (UIView *view in itemViews) {
		[self removeAnimationWithView:view];
	}
	
	// 及时移除释放按钮 
	for (UIButton *btn in deleteBtns) {
		[btn removeFromSuperview];
	}
	[deleteBtns removeAllObjects];
	
	self.deleteActiving = NO;
}

//! 抖动数据设置
#define WHIPPING_ANGLE 0.05f
#define WHIPPING_MOVE_DELTA_X 1.0f
#define WHIPPING_MOVE_DELTA_Y 1.0f
#define WHIPPING_TIMER_INTERVAL 0.15f

- (void)whippingAnimationWithView:(UIView*)view{
#if WHIPPING_DELETE_ANIMATION
	view.transform = CGAffineTransformMakeRotation(-WHIPPING_ANGLE/2.0);
	//2	view.transform = CGAffineTransformTranslate(view.transform, -WHIPPING_MOVE_DELTA_X/2.0, 0);
	view.transform = CGAffineTransformTranslate(view.transform, 0, -WHIPPING_MOVE_DELTA_Y/2.0);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:WHIPPING_TIMER_INTERVAL];
	[UIView setAnimationRepeatCount:LONG_MAX];
	[UIView setAnimationRepeatAutoreverses:YES];
	CGAffineTransform transform = CGAffineTransformRotate(view.transform ,WHIPPING_ANGLE);
	//2	view.transform = CGAffineTransformTranslate(transform, WHIPPING_MOVE_DELTA_X, 0);
	view.transform = CGAffineTransformTranslate(transform, 0, WHIPPING_MOVE_DELTA_Y);
	[UIView commitAnimations];
#endif
}

- (void)removeAnimationWithView:(UIView*)view{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	view.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

// 视图放大动画
- (void)scaleAnimationWithView:(UIView*)view{		
#if SCALE_ANIMATION
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3];
	view.transform = CGAffineTransformMakeScale(1.1, 1.1);
	[UIView commitAnimations];
#endif
}

@end