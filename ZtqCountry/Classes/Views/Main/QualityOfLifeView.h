//
//  QualityOfLifeView.h
//  ZtqCountry
//
//  Created by linxg on 14-7-3.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LunarDB.h"
#import "Calendar.h"
#import "EGOImageView.h"
@interface QualityOfLifeInfo : NSObject



@property (strong, nonatomic) NSString * index_name;//舒适度
@property (strong, nonatomic) NSString * des;//舒适度白天2级
@property (strong, nonatomic) NSString * simple_des;//不舒适
@property (strong, nonatomic) NSString * ico_path;//
@property (strong, nonatomic) NSString * create_time;//
@property (strong, nonatomic) NSString * lv;
@property (strong, nonatomic) NSString * ico_name;
@property (strong, nonatomic) NSString * shzs_url;
@property (strong, nonatomic) NSMutableArray * contentStrs;
@property (strong, nonatomic) NSMutableArray * contentImages;




-(id)initWithIndex_name:(NSString *)index_name
                withDes:(NSString *)des
         withSimple_des:(NSString *)simple_des
           withIco_path:(NSString *)ico_path
        withCreate_time:(NSString *)create_time
                 withLv:(NSString *)lv
           withIco_name:(NSString *)ico_name
           withShzs_rul:(NSString *)shzs_url;

@end


@protocol QualityOfLifeViewDelegate <NSObject>

-(void)buttonActionWithTag:(int)tag withQualityOflifeInfo:(QualityOfLifeInfo *)lifeInfo withInfos:(NSMutableArray *)infos;
//-(void)rilibtnAction;
@end

@interface QualityOfLifeView : UIView
{
    LunarDB *m_lunarDB;
    Calendar *m_calendar;
    NSDate *m_currentDate;
}

@property (weak, nonatomic) id controller;
@property (strong, nonatomic) NSArray * infos;
@property(strong,nonatomic)NSMutableArray *newinfos;
@property(strong,nonatomic)EGOImageView *rl_img;
@property (weak, nonatomic) id<QualityOfLifeViewDelegate>delegate;
-(id)initWithFrame:(CGRect)frame withInfos:(NSArray *)infos withController:(id)controller wiheHeight:(float)heigh withSerinfos:(NSArray *)serinfos;

@end
