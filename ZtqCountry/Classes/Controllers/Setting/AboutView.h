//
//  AboutView.h
//  AboutView
//
//  Created by 黄 芦荣 on 12-3-19.
//  Copyright 2012 卓派. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol AboutViewDelegate <NSObject>

-(void)AboutViewBack;

@end

@interface AboutView : UIView {
	UIImageView *aboutImageView;
	UIImageView *logoImageView;
	UILabel *title;
	UITextView *content;
	UIButton *my_button;
	NSString *text;
}

@property(nonatomic, readonly)UIImageView *aboutImageView; 
@property(nonatomic, readonly)UIImageView *logoImageView;
@property(nonatomic, readonly)UILabel *title;
@property(nonatomic, readonly)UITextView *content;
@property(nonatomic, readonly)UIButton *my_button;
@property(nonatomic, strong)NSString *text;
@property(nonatomic, weak) id<AboutViewDelegate>delegate;

-(id)initWithView:(NSString *)my_title setMessage:(NSString *)messageText setRect:(CGRect)rect;


-(void)show;

@end
