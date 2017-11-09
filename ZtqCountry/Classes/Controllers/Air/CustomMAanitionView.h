//
//  CustomMAanitionView.h
//  ZtqCountry
//
//  Created by 派克斯科技 on 17/1/12.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CustomMAanitionView : MAAnnotationView

@property (nonatomic, strong)NSString *aqiNum;
@property (nonatomic, strong)UIImage *aqiImage;
@property (nonatomic, strong)NSString *areaId;
@end
