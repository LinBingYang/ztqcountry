//
//  PMView.m
//  WeatherForecast
//
//  Created by 黄 芦荣 on 13-3-11.
//  Copyright 2013 卓派. All rights reserved.
//

#import "PMView.h"
#import"ShareFunction.h"

@implementation PMView

@synthesize array = _array;


//-(void)setArray:(NSArray *)t_array{
//	if (_array !=nil) {
////		[_array release];
//		_array = nil;
//	}
////	_array = [t_array retain];
//    _array = t_array;
//	[self setNeedsDisplay];
//}

-(void)PMviewgetaqidata:(NSArray *)data with:(NSString *)nurrtime{
    
    self.newarr=data;
   
    [self.levarr removeAllObjects];
    [self.timearr removeAllObjects];
   
    for (int i=0; i<data.count; i++) {
        NSString *aqi=[[data objectAtIndex:i]objectForKey:@"aqi"];
        NSString *time=[[data objectAtIndex:i]objectForKey:@"time"];
//        NSString *num=[[data objectAtIndex:i]objectForKey:@"num"];
       
        [self.levarr addObject:aqi];
        [self.timearr addObject:time];
       
       
    }
     [self setNeedsDisplay];
    self.harr=[[self.timearr reverseObjectEnumerator]allObjects];
    self.valuearr=[[self.levarr reverseObjectEnumerator]allObjects];//倒序
    
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.timearr=[[NSMutableArray alloc]init];
        self.levarr=[[NSMutableArray alloc]init];
        _imageArray = [[NSMutableArray alloc] initWithCapacity:5];
        _abscissa_width = self.width/8;
        _ordinate_height = 15;
        
        UIImageView *proportionBackground  = [[UIImageView alloc] initWithFrame:self.bounds];
        [proportionBackground setBackgroundColor:[UIColor whiteColor]];
        [proportionBackground setAlpha:0.3f];
        //	[self addSubview:proportionBackground];
        //		[proportionBackground release];
        
        //纵坐标标签
        /*UILabel *ordinateTitle = [ShareFunction LabelWithText:@"PM2.5"
         withFrame:CGRectMake(25, 5, 40, 15)
         withFontSize:13];
         [self addSubview:ordinateTitle];
         [ordinateTitle release];*/
        
        //图标标签
        UILabel *chartTitle = [ShareFunction LabelWithText:@"24小时趋势图"
                                                 withFrame:CGRectMake(230, 5, 120, 15)
                                              withFontSize:13];
        //	[self addSubview:chartTitle];
        //		[chartTitle release];
        /*
         //横坐标
         for (int i = 0; i < 24; i++) {
         
         //	if (i%3 != 0 && i != 23) {
         //		continue;
         //	}
         if (i == 23) {
         _abscissa[i] = [ShareFunction LabelWithText:@"(时)" withFrame:CGRectMake(30+_abscissa_width*i-5,210, _abscissa_width*2, 15)];
         _abscissa[i].font = [UIFont fontWithName:@"Helvetica" size:11];
         }else if (i%2!=0){
         _abscissa[i] = [ShareFunction LabelWithText:[NSString stringWithFormat:@"%d",i] withFrame:CGRectMake(30+_abscissa_width*i,210, _abscissa_width*1.5, 15)];
         _abscissa[i].font = [UIFont fontWithName:@"Helvetica" size:13];
         }
         //_abscissa[i] = [ShareFunction LabelWithText:@"" withFrame:CGRectMake(30+_abscissa_width*i,210, _abscissa_width*1.5, 15)];
         
         _abscissa[i].tag=i+200;
         _abscissa[i].textAlignment = UITextAlignmentLeft;
         _abscissa[i].backgroundColor = [UIColor clearColor];
         [_abscissa[i] setTextColor:[UIColor whiteColor]];
         [self addSubview:_abscissa[i]];
         [_abscissa[i] release];
         }
         //*/
        //纵坐标
        NSArray *ordinateArray = [[NSArray alloc] initWithObjects:@"500", @"300", @"200",@"150",@"100",@"50",@"0",nil];
        NSArray *titleArray = [[NSArray alloc] initWithObjects:@"严重污染",@"重度污染",@"中度污染",@"轻度污染",@"良",@"优",nil];
        
        for (int i = 0; i < 7; i++) {
            
            if (i < 6) {
                UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake( 26, 27+i*_ordinate_height+i*15, self.width-36,_ordinate_height*2-1)];
                [backImage setBackgroundColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.3f]];
                [self addSubview:backImage];
                //				[backImage release];
                
                UIImageView *tagImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7, backImage.frame.size.height)];
                [backImage addSubview:tagImage];
                //				[tagImage release];
                
                UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake( 26, 56+i*_ordinate_height+i*15, self.width-36,1)];
                line.backgroundColor=[UIColor grayColor];
                if (i<5) {
                    line.alpha=0.5;
                }
                [self addSubview:line];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backImage.frame.size.width-4, backImage.frame.size.height)];
                titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
                titleLabel.textAlignment = NSTextAlignmentRight;
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.text = (NSString *)[titleArray objectAtIndex:i];
                [titleLabel setTextColor:[UIColor blackColor]];
                [backImage addSubview:titleLabel];
                //				[titleLabel release];
                
                switch (i) {
                    case 5:
                        tagImage.backgroundColor = [UIColor colorWithRed:101.0/255.0f green:240.0/255.0f blue:2.0/255.0f alpha:1.0f];
                        [titleLabel setTextColor:[UIColor colorWithRed:101.0/255.0f green:240.0/255.0f blue:2.0/255.0f alpha:1.0f]];
                        break;
                    case 4:
                        tagImage.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:28.0/255.0f alpha:1.0f];
                        [titleLabel setTextColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:28.0/255.0f alpha:1.0f]];
                        break;
                    case 3:
                        tagImage.backgroundColor = [UIColor colorWithRed:253.0/255.0f green:164.0/255.0f blue:10.0/255.0f alpha:1.0f];
                        [titleLabel setTextColor:[UIColor colorWithRed:253.0/255.0f green:164.0/255.0f blue:10.0/255.0f alpha:1.0f]];
                        break;
                    case 2:
                        tagImage.backgroundColor = [UIColor colorWithRed:239.0/255.0f green:8.0/255.0f blue:2.0/255.0f alpha:1.0f];
                        [titleLabel setTextColor:[UIColor colorWithRed:239.0/255.0f green:8.0/255.0f blue:2.0/255.0f alpha:1.0f]];
                        break;
                    case 1:
                        tagImage.backgroundColor = [UIColor colorWithRed:162.0/255.0f green:0.0/255.0f blue:91.0/255.0f alpha:1.0f];
                        [titleLabel setTextColor:[UIColor colorWithRed:162.0/255.0f green:0.0/255.0f blue:91.0/255.0f alpha:1.0f]];
                        break;
                    case 0:
                        tagImage.backgroundColor = [UIColor colorWithRed:139.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0f];
                        [titleLabel setTextColor:[UIColor colorWithRed:139.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0f]];
                        break;
                    default:
                        break;
                }
                
            }
            
            
            
            _ordinate[i] = [ShareFunction LabelWithText:@"" withFrame:CGRectMake( 0, 25+i*_ordinate_height+i*15, 25,_ordinate_height)];
            _ordinate[i].font = [UIFont fontWithName:@"Helvetica" size:13];
            //_ordinate[i].textAlignment = UITextAlignmentRight;
            //if (i== 0) {
            _ordinate[i].textAlignment = NSTextAlignmentCenter;
            //}
            _ordinate[i].backgroundColor = [UIColor clearColor];
            _ordinate[i].text = (NSString *)[ordinateArray objectAtIndex:i];
            [_ordinate[i] setTextColor:[UIColor blackColor]];
            [self addSubview:_ordinate[i]];
            //			[_ordinate[i] release];
        }
        //		[ordinateArray release];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    int count = [self.harr count];
    CGPoint point[count];
    float per;
    NSString *yString;
    int y;
    /*
     UILabel *label;
     for (int i = 0; i < 24; i++) {
     if (_array != nil && i <[_array count]) {
     label=(UILabel *)[self viewWithTag:i+200];
     //	if (i%3 != 0 && i != 23) {
     //		continue;
     //	}
     if (i == 23) {
     
     [label setText:[NSString stringWithFormat:@"1111(时)"]];
     }else if (i%2!=0) {
     //设置时间
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"MM月dd日HH时"];
     NSDate *uptime = [dateFormatter dateFromString:(NSString *)[(NSDictionary *)[_array objectAtIndex:i] objectForKey:@"time_hour"]];
     NSLog(@"%@", uptime);
     [dateFormatter setDateFormat:@"HH"];
     NSString *dateString = [dateFormatter stringFromDate:uptime];
     [label setText:dateString];
     [dateFormatter release];
     }
     }
     
     }
     //*/
    //横坐标
    for (int i = 0; i < count; i++) {
        NSString *xString=self.harr[i];
        _abscissa[i].text=nil;
        
        _abscissa[i] = [ShareFunction LabelWithText:[NSString stringWithFormat:@"%@",xString] withFrame:CGRectMake(26+_abscissa_width*i, 210, _abscissa_width, 15)];
        
        
        
        _abscissa[i].font = [UIFont fontWithName:@"Helvetica" size:12];
        _abscissa[i].textAlignment = NSTextAlignmentCenter;
        _abscissa[i].backgroundColor = [UIColor clearColor];
        [_abscissa[i] setTextColor:[UIColor blackColor]];
        [self addSubview:_abscissa[i]];
        //        [_abscissa[i] release];
    }
    
    for (int i = 0; i < [_imageArray count]; i++) {
        UIImageView *imageView = [_imageArray objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    [_imageArray removeAllObjects];
    
    if(_drawImage != nil)
        [_drawImage removeFromSuperview];
    
    _drawImage = [[UIImageView alloc] initWithImage:nil];
    _drawImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //[_drawImage setBackgroundColor:[UIColor redColor]];
    [self addSubview:_drawImage];
    //	[_drawImage release];
    
    
    for (int i = 0 ; i < count; i++) {
        yString  = self.valuearr[i];
        
        y = [yString intValue];
        if (y>500) {
            y=500;
        }
        //   NSLog(@"%d",y);
        point[i].x = 25+_abscissa_width/2.0+_abscissa_width*i;
        
        if (0<= y && y< 50) {
            per = _ordinate_height*2/50;
            point[i].y = 205-per*y;
        }else if (50 <= y && y< 100 ) {
            per = _ordinate_height *2/50;
            point[i].y = 205-(_ordinate_height*2+per*(y-50));
        }else if (100 <= y && y< 150) {
            per = _ordinate_height *2 /50;
            point[i].y = 205-(_ordinate_height*4+per*(y-100));
        }else if (150 <= y && y< 200) {
            per = _ordinate_height *2 /50;
            point[i].y = 205-(_ordinate_height*6+per*(y-150));
        }else if (200 <= y && y< 300) {
            per = _ordinate_height *2 /100;
            point[i].y = 205-(_ordinate_height*8+per*(y-200));
        }
        else if (300 <= y && y<= 500) {
            per = _ordinate_height *2 /200;
            point[i].y = 205-(_ordinate_height*10+per*(y-300));
        }
        
        if (i > 0) {
            UIGraphicsBeginImageContext(self.frame.size);
            [_drawImage.image drawInRect:CGRectMake(0, 0, _drawImage.frame.size.width, _drawImage.frame.size.height)]; 
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound); 
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 24/255.0, 119/255.0, 192/255.0, 1.0);
            CGContextBeginPath(UIGraphicsGetCurrentContext());
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), point[i-1].x, point[i-1].y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point[i].x, point[i].y);
            CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(2, 2), 3);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            _drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        UIImageView *imagePoint = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:@"一周趋势蓝点.png"];
        imagePoint.image = image;
        imagePoint.frame = CGRectMake(point[i].x - 4, point[i].y - 4, 8, 8);
        [_imageArray addObject:imagePoint];
        [self addSubview:imagePoint];
        //		[imagePoint release];
    }
    
}


//- (void)dealloc {
//	
//    [super dealloc];
//}


@end
