//
//  popInfoView.h
//  ZtqNew
//
//  Created by wang zw on 12-10-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface popInfoView : UIView {
    UIView *panelView;
}

@property (nonatomic, readonly)UIView *panelView;

- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated;

@end