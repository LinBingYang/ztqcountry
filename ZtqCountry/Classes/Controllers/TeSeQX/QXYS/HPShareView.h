//
//  HPShareView.h
//  ztqFj
//
//  Created by 胡彭飞 on 2017/2/17.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import "ShareView.h"
@class HPShareView;
@protocol HPShareViewDelegate <NSObject>

-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath andShareView:(HPShareView *)shareview;

@end
@interface HPShareView : ShareView
-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath;
@property(nonatomic,weak) id<HPShareViewDelegate> delegate;
-(void)mobileAction;
@end
