//
//  CustomMAanitionView.m
//  ZtqCountry
//
//  Created by 派克斯科技 on 17/1/12.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import "CustomMAanitionView.h"

@interface CustomMAanitionView ()

@property (nonatomic, strong)UILabel *numlab;

@property (nonatomic, strong)UIImageView *aqiImageView;


@end



@implementation CustomMAanitionView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self ) {
        self.bounds = CGRectMake(0, 0, 40, 34);
        self.aqiImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.aqiImageView.userInteractionEnabled = YES;
        self.numlab = [[UILabel alloc]initWithFrame:CGRectMake(4, 2, 32, 20)];
        self.numlab.textAlignment = NSTextAlignmentCenter;
        self.numlab.textColor = [UIColor whiteColor];
        self.numlab.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.aqiImageView];
        [self addSubview:self.numlab];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(animationPostMsg:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

- (void)setAqiNum:(NSString *)aqiNum {
    self.numlab.text = aqiNum;
}
- (void)setAqiImage:(UIImage *)aqiImage {
    self.aqiImageView.image = aqiImage;
}


- (void)animationPostMsg:(UIButton *)btn {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"animationPostMsg" object:self.areaId];
}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    if (self.selected == selected)
//    {
//        return;
//    }
//    
//    if (selected)
//    {
//        
//    }
//    else
//    {
//        
//    }
//    
//
//}
//
//-  (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    BOOL inside = [super pointInside:point withEvent:event];
//    
//    return inside;
//}


@end
