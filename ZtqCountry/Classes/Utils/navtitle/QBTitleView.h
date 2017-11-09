/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class QBTitleView;

@protocol QBTitleViewDelegate <NSObject>

@optional
- (void)titleViewDidTouchDown:(QBTitleView *)titleView;
- (void)titleViewDidTouchUpInside:(QBTitleView *)titleView;
- (void)titleViewDidTouchUpOutside:(QBTitleView *)titleView;

@end

@interface QBTitleView : UIView

@property (nonatomic, assign) id<QBTitleViewDelegate> delegate;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGSize imageViewSize;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setTitle:(NSString *)title;
- (NSString *)title;
- (void)setImage:(UIImage *)image;
- (UIImage *)image;
- (void)setHighlightedImage:(UIImage *)highlightedImage;
- (UIImage *)highlightedImage;
- (void)update;

@end
