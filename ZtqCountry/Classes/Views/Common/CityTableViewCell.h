//
//  CityTableViewCell.h
//  ZtqCountry
//
//  Created by 林炳阳	 on 14-6-25.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewCell : UITableViewCell
//城市管理
@property(retain,nonatomic)UILabel *city_labe,*sstq;
@property(retain,nonatomic)UIImageView *titleImg,*ico;
@property(assign)BOOL isclick;

//景点收藏
@property(retain,nonatomic)UILabel *city,*hlwd;
@property(retain,nonatomic)UIImageView *icoImg;

@end
