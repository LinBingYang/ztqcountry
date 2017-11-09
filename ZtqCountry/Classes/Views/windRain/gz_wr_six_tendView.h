//
//  gz_wr_six_tendView.h
//  ZtqCountry
//
//  Created by hpf on 16/1/14.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef enum {
//    YzhouTypeRain,
//    YzhouTypeTemp,
//    YzhouTypeWind
//}YzhouType;
@interface gz_wr_six_tendView : UIView
@property(nonatomic,strong) NSArray *wr_lists;
/**
 *  判断Y轴是降雨1 气温2 风况3
 */
@property(nonatomic,assign)YzhouType YzhouType;
@end
