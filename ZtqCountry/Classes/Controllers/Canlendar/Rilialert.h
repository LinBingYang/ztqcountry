//
//  Rilialert.h
//  ztqFj
//
//  Created by Admin on 15-1-4.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol riliAlertDelegate <NSObject>

-(void)clickButtonWithTag:(int)tag withcontentstr:(NSString *)content;

@end
@interface Rilialert : UIView<UITextViewDelegate>
@property (weak, nonatomic) id<riliAlertDelegate>delegate;
@property (strong, nonatomic) UIImageView * logoImgV;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UITextView * contentLab;
@property (strong, nonatomic) UIButton * firstBut;
@property (strong, nonatomic) UIButton * secondBut;
@property (strong, nonatomic) UIImageView * backgroundImgV;
@property(nonatomic,strong)UILabel *bglabel;
@property(nonatomic,strong)NSString *str;
-(id)initWithLogoImage:(NSString *)imageName withTitle:(NSString *)title withContent:(NSString *)content withleftname:(NSString *)left withrightname:(NSString *)right;
-(void)show;

@end
