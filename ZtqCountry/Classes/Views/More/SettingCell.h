//
//  SettingCell.h
//  ZtqCountry
//
//  Created by linxg on 14-7-9.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingDelegate <NSObject>

-(void)settingWithSwitch:(BOOL)yesOrNo withIndexPath:(NSIndexPath *)indexPath;

@end


@interface SettingCell : UITableViewCell
@property (strong, nonatomic) UIImageView * logoImagV;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UISwitch * settingSwitch;
@property (strong, nonatomic) NSIndexPath * IP;
@property (weak, nonatomic) id<SettingDelegate>delegate;



@end
