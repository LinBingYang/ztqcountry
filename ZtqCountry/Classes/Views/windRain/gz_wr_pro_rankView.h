//
//  gz_wr_pro_rankView.h
//  ZtqCountry
//
//  Created by hpf on 16/1/15.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class gz_wr_pro_rankView;
@protocol gz_wr_pro_rankViewDelegate <NSObject>

@optional
-(void)gz_wr_pro_rankView:(gz_wr_pro_rankView *)gz_wr_pro_rankView WithRank_lists:(NSArray *)rank_lists andrank_list_time:(NSString *)rank_list_time;
@end
@interface gz_wr_pro_rankView : UIView
@property(nonatomic,strong) NSArray *rank_lists;
@property(nonatomic,strong) NSArray *subrank_lists1;
@property(nonatomic,strong) NSArray *subrank_lists2;
@property(nonatomic,copy) NSString *rank_list_time;
@property(nonatomic,copy) NSString *rank_list_time1;
@property(nonatomic,copy) NSString *rank_list_time2;
@property(nonatomic,weak) id<gz_wr_pro_rankViewDelegate> delegate;
@property(nonatomic,assign) BOOL HightTemperature;//判断是否为高低温排名View
/**
 *  判断Y轴是降雨1 气温2 风况3
 */
@property(nonatomic,assign)YzhouType YzhouType;
/**
 *  判断高低温
 */
@property(nonatomic,assign)tempType tempType;
/**
 *  判断实况高低温
 */
@property(nonatomic,assign)BOOL tempskType;
/**
 *  判断风况
 */
@property(nonatomic,assign)WindType WindType;

@end
