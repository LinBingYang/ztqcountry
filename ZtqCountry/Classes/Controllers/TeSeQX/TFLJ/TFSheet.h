//
//  TFSheet.h
//  ZtqCountry
//
//  Created by Admin on 14-9-24.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ActionSheetDelegate <NSObject>
@required

- (void)doneBtnClicked;


@end

@interface TFSheet : UIView{
    __weak id <ActionSheetDelegate> delegate;
    UIView* view;
}
@property (nonatomic, weak)id delegate;
@property(nonatomic,strong)UIView* view,*titleview;
@property (strong, nonatomic) UIView * sheetBgView,*titleImg;
-(id)initWithHeight:(float)height WithSheetTitle:(NSString*)title withLeftBtn:(NSString *)leftTitle withRightBtn:(NSString *)rightTitle;
-(void)show;
@end
