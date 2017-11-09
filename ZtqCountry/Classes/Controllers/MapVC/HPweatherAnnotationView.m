//
//  HPweatherAnnotationView.m
//  ZtqCountry
//
//  Created by 胡彭飞 on 16/3/15.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "HPweatherAnnotationView.h"

@interface HPweatherAnnotationView ()
@property(nonatomic,weak) UIImageView *imageView;
@end

@implementation HPweatherAnnotationView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(-20, -20, 40, 40)];//设置图标大小
        self.imageView=imageView;
        [self addSubview:imageView];
    }
    
    return self;
}
-(void)setImageName:(NSString *)imageName
{
    _imageName=[imageName copy];
    self.imageView.image=[UIImage imageNamed:imageName];
}
@end
