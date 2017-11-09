//
//  CustomSheet.h
//  ztqFj
//
//  Created by Admin on 15/6/12.
//  Copyright (c) 2015年 yyf. All rights reserved.
//
@class CustomSheet;
#import <UIKit/UIKit.h>

@protocol ACSheetDelegate <NSObject>

-(void)SheetClickWithIndexPath:(NSInteger)indexPath;
-(void)SheetClickWithIndexPath:(NSInteger)indexPath WithACSheet:(CustomSheet *)actionSheet;
@end
@interface CustomSheet : UIView
@property (strong, nonatomic) UIImageView * sheetBgView;
@property (weak, nonatomic) id<ACSheetDelegate>delegate;
-(id)initWithupbtn:(NSString *)upname Withdownbtn:(NSString *)downname WithCancelbtn:(NSString *)cacelname withDelegate:(id)delegate;
-(void)show;
@end
