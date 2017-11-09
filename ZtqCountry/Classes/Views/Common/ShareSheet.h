//
//  ShareSheet.h
//  ZtqCountry
//
//  Created by linxg on 14-6-25.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareSheetDelegate <NSObject>

-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath;

@end

@interface ShareSheet : UIView

@property (strong, nonatomic) UIImageView * sheetBgView;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) NSArray * butTitles;
@property (strong, nonatomic) NSArray * butImages;
@property (strong, nonatomic) NSArray * hightLightImages;
@property (weak, nonatomic) id<ShareSheetDelegate>delegate;


-(id)initWithTitle:(NSString *)title withButImages:(NSArray *)imageNames withHightLightImage:(NSArray *)hightlightimg withButTitles:(NSArray *)titles withDelegate:(id)delegate;
-(id)initDefaultWithTitle:(NSString *)title withDelegate:(id)delegate;
-(void)show;

@end
