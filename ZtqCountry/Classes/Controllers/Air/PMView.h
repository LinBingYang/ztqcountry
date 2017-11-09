//
//  PMView.h
//  WeatherForecast
//
//  Created by 黄 芦荣 on 13-3-11.
//  Copyright 2013 卓派. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PMView : UIView {
    
    UILabel *_abscissa[6];//横坐标
    float _abscissa_width;
    
    UILabel *_ordinate[7]; //纵坐标
    float _ordinate_height;
    
    
    __strong NSArray *_array;
    
    NSMutableArray *_imageArray;
    UIImageView *_drawImage;
}
@property(strong,nonatomic)NSArray *harr,*valuearr,*newarr;
@property(strong,nonatomic)NSMutableArray *timearr,*levarr;
@property(nonatomic, strong)NSArray *array;
-(void)PMviewgetaqidata:(NSArray *)data with:(NSString *)nurrtime;
@end
