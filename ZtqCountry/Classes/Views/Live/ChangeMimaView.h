//
//  ChangeMimaView.h
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/5.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChangeMimaView;
@protocol ChangeMimaViewDelegate<NSObject>
@optional
-(void)changeMimaViewSuccess:(ChangeMimaView *)view;
@end
@interface ChangeMimaView : UIView
@property(nonatomic,weak)   id<ChangeMimaViewDelegate> delegate;
@property(nonatomic,strong) NSDictionary *user_info;
@end
