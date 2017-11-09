//
//  gz_wr_six_tendView.m
//  ZtqCountry
//
//  Created by hpf on 16/1/14.
//  Copyright © 2016年 yyf. All rights reserved.
//
#import "wr_list.h"
#import "gz_wr_six_tendView.h"
@interface gz_wr_six_tendView()
@property(strong,nonatomic)wr_list *smallList;
@end
@implementation gz_wr_six_tendView
-(void)setWr_lists:(NSArray *)wr_lists
{
    _wr_lists=wr_lists;
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
//    NSLog(@"%@",self.wr_lists);
    //画横线和纵坐标
   wr_list *lists=self.wr_lists[0];
   
    wr_list *h_numL;
    
    wr_list *l_numS;
    if (lists.h_num) {
        NSArray *newArrayH=[self.wr_lists sortedArrayUsingComparator:^NSComparisonResult(wr_list *obj1,wr_list *obj2){
            if (obj1.h_num.doubleValue>obj2.h_num.doubleValue) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        NSArray *newArrayL=[self.wr_lists sortedArrayUsingComparator:^NSComparisonResult(wr_list *obj1,wr_list *obj2){
            if (obj1.l_num.doubleValue>obj2.l_num.doubleValue) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        h_numL=newArrayH.lastObject; //高温最大值    限定Y轴坐标范围
        l_numS=newArrayL[0];//低温最小值     限定Y轴坐标范围
    }
    NSArray *newArrayNum;
    if (lists.num) {
        newArrayNum=[self.wr_lists sortedArrayUsingComparator:^NSComparisonResult(wr_list *obj1,wr_list *obj2){
            if (obj1.num.doubleValue>obj2.num.doubleValue) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];

    }
    wr_list *listsmall;
    wr_list *listlarge;
    int Ymargin=1;
    if (lists.num) {
        listsmall=newArrayNum[0]; //最小值
        self.smallList=lists;
        listlarge=newArrayNum.lastObject; //最大值
        Ymargin=((int)(listlarge.num.doubleValue/7)+1);
    }
    if (lists.h_num) {
        listsmall=l_numS; //最小值
        self.smallList=lists;
        listlarge=h_numL; //最大值
        Ymargin=((int)(listlarge.h_num.doubleValue/7)+1);
    }
    int hengxianCount=8;
    int fushuCount=0;
    int totalCount=0;
    if(listsmall.num.doubleValue<0) //最小值小于0
    {
        fushuCount=1;
        Ymargin=(listlarge.num.doubleValue-listsmall.num.doubleValue)/7+1;
    }
    if (l_numS.l_num.doubleValue<0) {//最小值小于0
        fushuCount=1;
        Ymargin=(h_numL.h_num.doubleValue-l_numS.l_num.doubleValue)/7+1;
    }
//    if(lists.h_num)
//    {
//       hengxianCount=9;
//        if (l_numS.l_num.doubleValue<0)
//        {
//            fushuCount= (0-l_numS.l_num.doubleValue)/5+2;
//                if (h_numL.h_num.doubleValue>0) {
//                    hengxianCount=h_numL.h_num.doubleValue/5+1;
//                    totalCount=fushuCount+hengxianCount;
//                }else{
//                    hengxianCount=0;
//                    totalCount=fushuCount;
//                }
//                
//            }
//        }
    
   
//    if ([lists.type isEqualToString:@"2"]) {
//            hengxianCount=6;
//    }
//    if(self.wr_lists.count==0)
//    {
//         if (self.YzhouType==YzhouTypeRain) {
//             hengxianCount=8;
//         }else if(self.YzhouType==YzhouTypeTemp)
//         {
//             hengxianCount=9;
//         }else
//         {
//             hengxianCount=6;
//    
//         }
//    }
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextSetLineWidth(ctx, 0.5);
         UILabel *mmY;
    for (int i=0; i<hengxianCount; i++) {
        if (i==0) {
            /**
             *  下面三句代码用来画横线
             */
            CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.7/(hengxianCount-1)*i);
            CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.7/(hengxianCount-1)*i);
            CGContextStrokePath(ctx);
        }else
        {
            CGContextSaveGState(ctx);
            CGFloat lengths[] = {10,10};
            CGContextSetLineDash(ctx, 0, lengths, 2);
            [[UIColor colorHelpWithRed:155 green:160 blue:167 alpha:1] set];
            CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.7/(hengxianCount-1)*i);
            CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.7/(hengxianCount-1)*i);
            CGContextStrokePath(ctx);
            CGContextRestoreGState(ctx);
        }
        
        mmY=[[UILabel alloc ]initWithFrame:CGRectMake(0, self.frame.size.height*0.85-(self.frame.size.height*0.7/(hengxianCount-1)*i)-7, 29, 15)];
        mmY.font=[UIFont systemFontOfSize:11];
        mmY.textColor=[UIColor blackColor];
        mmY.textAlignment=NSTextAlignmentRight;
      
        
        [self addSubview:mmY];

        if (lists.num) {
            if (fushuCount!=0) {
                
                mmY.text=[NSString stringWithFormat:@"%.1f",i*Ymargin+lists.num.doubleValue];
            }else
            {
                mmY.text=[NSString stringWithFormat:@"%d.0",i*Ymargin];
            }
            
        }else if(lists.h_num)
        {
            if (fushuCount!=0) {
                
                mmY.text=[NSString stringWithFormat:@"%.1f",i*Ymargin+l_numS.l_num.doubleValue];
            }else
            {
                mmY.text=[NSString stringWithFormat:@"%d.0",i*Ymargin];
            }

        }else
        {
            mmY.text=[NSString stringWithFormat:@"%d.0",i*Ymargin];
        
        }
    }
//        }else if([lists.type isEqualToString:@"2"])
//        {
//            /**
//             *  下面三句代码用来画横线
//             */
//            if (i==0) {
//                CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.13*i);
//                CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.13*i);
//                CGContextStrokePath(ctx);
//            }else
//            {
//                CGContextSaveGState(ctx);
//                CGFloat lengths[] = {10,10};
//                CGContextSetLineDash(ctx, 0, lengths, 2);
//                 [[UIColor colorHelpWithRed:155 green:160 blue:167 alpha:1] set];
//                CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.13*i);
//                CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.13*i);
//                CGContextStrokePath(ctx);
//                CGContextRestoreGState(ctx);
//            }
//           
//            mmY=[[UILabel alloc ]initWithFrame:CGRectMake(3, self.frame.size.height*0.85-(self.frame.size.height*0.65/5*i)-12, 30, 20)];
//            mmY.font=[UIFont systemFontOfSize:12];
//            mmY.textColor=[UIColor colorHelpWithRed:155 green:159 blue:167 alpha:1];
//            mmY.textAlignment=NSTextAlignmentCenter;
//            mmY.text=[NSString stringWithFormat:@"%d",i*5];
// 
//        }else if (l_numS.l_num.doubleValue>0)
//        {  /**
//            *  下面三句代码用来画横线
//            */
//            if (i==0) {
//                CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.09*i);
//                CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.09*i);
//                CGContextStrokePath(ctx);
//            }else
//            {
//                CGContextSaveGState(ctx);
//                CGFloat lengths[] = {10,10};
//                CGContextSetLineDash(ctx, 0, lengths, 2);
//                [[UIColor colorHelpWithRed:155 green:160 blue:167 alpha:1] set];
//                CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.09*i);
//                CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.09*i);
//                CGContextStrokePath(ctx);
//                CGContextRestoreGState(ctx);
//            }
////            CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.09*i);
////            CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.09*i);
////            CGContextStrokePath(ctx);
//            mmY=[[UILabel alloc ]initWithFrame:CGRectMake(3, self.frame.size.height*0.85-(self.frame.size.height*0.72/8*i)-10, 30, 20)];
//            mmY.font=[UIFont systemFontOfSize:12];
//            mmY.textColor=[UIColor colorHelpWithRed:155 green:159 blue:167 alpha:1];
//            mmY.textAlignment=NSTextAlignmentCenter;
//             mmY.text=[NSString stringWithFormat:@"%d",i*5];
//            
//        }else {
//            if (self.YzhouType==YzhouTypeRain) {
//                /**
//                 *  下面三句代码用来画横线
//                 */
//                if (i==0) {
//                    CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.1*i);
//                    CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.1*i);
//                    CGContextStrokePath(ctx);
//                }else
//                {
//                    CGContextSaveGState(ctx);
//                    CGFloat lengths[] = {10,10};
//                    CGContextSetLineDash(ctx, 0, lengths, 2);
//                   [[UIColor colorHelpWithRed:155 green:160 blue:167 alpha:1] set];
//                    CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.1*i);
//                    CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.1*i);
//                    CGContextStrokePath(ctx);
//                   CGContextRestoreGState(ctx);
//                }
//           
//                mmY=[[UILabel alloc ]initWithFrame:CGRectMake(3, self.frame.size.height*0.85-(self.frame.size.height*0.7/7*i)-12, 30, 20)];
//                mmY.font=[UIFont systemFontOfSize:12];
//                mmY.textColor=[UIColor colorHelpWithRed:155 green:159 blue:167 alpha:1];
//                mmY.textAlignment=NSTextAlignmentCenter;
//                mmY.text=[NSString stringWithFormat:@"%d",i*10];
//                
//            }else if(self.YzhouType==YzhouTypeTemp)
//            {
////                CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.09*i);
////                CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.09*i);
////                CGContextStrokePath(ctx);
////                mmY=[[UILabel alloc ]initWithFrame:CGRectMake(3, self.frame.size.height*0.85-(self.frame.size.height*0.72/8*i)-10, 30, 20)];
////                mmY.font=[UIFont systemFontOfSize:12];
////                mmY.textColor=[UIColor colorHelpWithRed:155 green:159 blue:167 alpha:1];
////                mmY.textAlignment=NSTextAlignmentCenter;
////                mmY.text=[NSString stringWithFormat:@"%d",i*5];
//            }else{
//                /**
//                 *  下面三句代码用来画横线
//                 */
//                if (i==0) {
//                    CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.1*i);
//                    CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.1*i);
//                    CGContextStrokePath(ctx);
//                }else
//                {
//                    CGContextSaveGState(ctx);
//                    CGFloat lengths[] = {10,10};
//                    CGContextSetLineDash(ctx, 0, lengths, 2);
//                    [[UIColor colorHelpWithRed:155 green:160 blue:167 alpha:1] set];
//                    CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.1*i);
//                    CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.1*i);
//                    CGContextStrokePath(ctx);
//                    CGContextRestoreGState(ctx);
//                }
//           
//                mmY=[[UILabel alloc ]initWithFrame:CGRectMake(3, self.frame.size.height*0.85-(self.frame.size.height*0.7/7*i)-12, 30, 20)];
//                mmY.font=[UIFont systemFontOfSize:12];
//                mmY.textColor=[UIColor colorHelpWithRed:155 green:159 blue:167 alpha:1];
//                mmY.textAlignment=NSTextAlignmentCenter;
//                mmY.text=[NSString stringWithFormat:@"%d",i*10];
//            }
//        
//        
//        }
//          [self addSubview:mmY];
//
//    }
//    if (l_numS.l_num.doubleValue<0){
//        
//        if (totalCount!=0) {
//            for (int i=0; i<totalCount; i++) {
//                /**
//                 *  下面三句代码用来画横线
//                 
//                 */
//                if (i==0) {
//                    CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.7/totalCount*i);
//                    CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.7/totalCount*i);
//                    CGContextStrokePath(ctx);
//                }else
//                {
//                    CGContextSaveGState(ctx);
//                    CGFloat lengths[] = {10,10};
//                    CGContextSetLineDash(ctx, 0, lengths, 2);
//                    [[UIColor colorHelpWithRed:155 green:160 blue:167 alpha:1] set];
//                    CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-self.frame.size.height*0.7/totalCount*i);
//                    CGContextAddLineToPoint(ctx, self.frame.size.width*0.9, self.frame.size.height*0.85-self.frame.size.height*0.7/totalCount*i);
//                    CGContextStrokePath(ctx);
//                    CGContextRestoreGState(ctx);
//                }
//            
//                mmY=[[UILabel alloc ]initWithFrame:CGRectMake(3, self.frame.size.height*0.85-(self.frame.size.height*0.7/totalCount*i)-7, 30, 15)];
//                mmY.font=[UIFont systemFontOfSize:12];
//                mmY.textColor=[UIColor colorHelpWithRed:155 green:159 blue:167 alpha:1];
//                mmY.textAlignment=NSTextAlignmentCenter;
//                mmY.text=[NSString stringWithFormat:@"%d",(-fushuCount+i+1)*5];
//                [self addSubview:mmY];
//            }
//            
//        }
//        
//    }
    
    UILabel *danweiMM=[[UILabel alloc ]initWithFrame:CGRectMake(3,0, 30, 20)];
    danweiMM.font=[UIFont systemFontOfSize:12];
    danweiMM.textColor=[UIColor blackColor];
    danweiMM.textAlignment=NSTextAlignmentCenter;
    danweiMM.text=@"mm";
      if (self.YzhouType==YzhouTypeTemp) {
     danweiMM.text=@"℃";
      }
    if (self.YzhouType==YzhouTypeWind) {
        danweiMM.text=@"m/s";
    }
    [self addSubview:danweiMM];
  //画纵线
    CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85);
    CGContextAddLineToPoint(ctx, self.frame.size.width*0.1, self.frame.size.height*0.85-self.frame.size.height*0.75);
    CGContextStrokePath(ctx);
//    [[UIColor blackColor] set];
//    if ([lists.type isEqualToString:@"2"]) {
//        CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85);
//        CGContextAddLineToPoint(ctx, self.frame.size.width*0.1, self.frame.size.height*0.85-self.frame.size.height*0.13*(hengxianCount));
//        CGContextStrokePath(ctx);
//    }else{
//    CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85);
//    CGContextAddLineToPoint(ctx, self.frame.size.width*0.1, self.frame.size.height*0.85-self.frame.size.height*0.1*(hengxianCount));
//    CGContextStrokePath(ctx);
//    }
//    if (lists.h_num) {
//        CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85);
//        CGContextAddLineToPoint(ctx, self.frame.size.width*0.1, self.frame.size.height*0.85-self.frame.size.height*0.1*(totalCount));
//        CGContextStrokePath(ctx);
//    }
    //画横坐标  和数据
//    CGFloat w=self.frame.size.height
    for (int i=0; i<self.wr_lists.count; i++) {
        UILabel *timeX=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-10, self.frame.size.height*0.85, 30, 30)];
        timeX.font=[UIFont systemFontOfSize:12];
        timeX.textColor=[UIColor blackColor];
        wr_list *lists=self.wr_lists[i];
        timeX.text=lists.time;
        [self addSubview:timeX];
        [[UIColor colorHelpWithRed:30 green:140 blue:158 alpha:1] set];
        //数据  显示数据在上方
        
        if(lists.num){//雨量6天趋势
        if(i==0){
        CGContextMoveToPoint(ctx, self.frame.size.width*0.1,(self.frame.size.height*0.85-(lists.num.doubleValue*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin));
        }else{
//            NSLog(@"%f  %f", self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i,self.frame.size.height*0.85-(lists.num.doubleValue*self.frame.size.height*0.7)/70);
        CGContextAddLineToPoint(ctx, self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i, (self.frame.size.height*0.85-(lists.num.doubleValue*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin));
        }
        UILabel *Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i,(self.frame.size.height*0.85-(lists.num.doubleValue*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin)-15, 25, 15)];
        Numcount.font=[UIFont systemFontOfSize:12];
        Numcount.textColor=[UIColor blackColor];
        Numcount.textAlignment=NSTextAlignmentCenter;
        Numcount.text=lists.num;
        [Numcount sizeToFit];
        [self addSubview:Numcount];
        }
//        }else if([lists.type isEqualToString:@"2"]) //风况6天趋势
//        {
//            if(i==0){
//                CGContextMoveToPoint(ctx, self.frame.size.width*0.1,(self.frame.size.height*0.85-(lists.num.doubleValue*self.frame.size.height*0.65)/25));
//            }else{
////                NSLog(@"%f  %f", self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i,self.frame.size.height*0.85-(lists.num.doubleValue*self.frame.size.height*0.65)/25);
//                CGContextAddLineToPoint(ctx, self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i, (self.frame.size.height*0.85-(lists.num.doubleValue*self.frame.size.height*0.65)/25));
//            }
//            UILabel *Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-5,self.frame.size.height*0.85-(lists.num.doubleValue*self.frame.size.height*0.65)/25-15, 25, 15)];
//            Numcount.font=[UIFont systemFontOfSize:12];
//            Numcount.textColor=[UIColor blackColor];
//            Numcount.textAlignment=NSTextAlignmentCenter;
//            Numcount.text=lists.num;
//            [Numcount sizeToFit];
//            [self addSubview:Numcount];
//        
//        }
            if(lists.h_num){//高温6天趋势
                [[UIColor colorHelpWithRed:193 green:7 blue:18 alpha:1] set];
                if (fushuCount!=0){
                if(i==0){
                    CGContextMoveToPoint(ctx, self.frame.size.width*0.1,(self.frame.size.height*0.85-((lists.h_num.doubleValue-l_numS.l_num.doubleValue)*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin));
                }else{
                    //                NSLog(@"%f  %f", self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i,self.frame.size.height*0.85-(lists.h_num.doubleValue*self.frame.size.height*0.63)/70);
                    CGContextAddLineToPoint(ctx, self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i, (self.frame.size.height*0.85-((lists.h_num.doubleValue-l_numS.l_num.doubleValue)*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin));
                }
                UILabel *Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i,(self.frame.size.height*0.85-((lists.h_num.doubleValue-l_numS.l_num.doubleValue)*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin)-15, 25, 15)];
                Numcount.font=[UIFont systemFontOfSize:12];
                Numcount.textColor=[UIColor blackColor];
                Numcount.textAlignment=NSTextAlignmentCenter;
                Numcount.text=lists.h_num;
                [Numcount sizeToFit];
                [self addSubview:Numcount];
                }else
                {
                    if(i==0){
                        CGContextMoveToPoint(ctx, self.frame.size.width*0.1,(self.frame.size.height*0.85-((lists.h_num.doubleValue)*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin));
                    }else{
                        //                NSLog(@"%f  %f", self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i,self.frame.size.height*0.85-(lists.h_num.doubleValue*self.frame.size.height*0.63)/70);
                        CGContextAddLineToPoint(ctx, self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i, (self.frame.size.height*0.85-(lists.h_num.doubleValue*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin));
                    }
                    UILabel *Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i,(self.frame.size.height*0.85-(lists.h_num.doubleValue*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin)-15, 25, 15)];
                    Numcount.font=[UIFont systemFontOfSize:12];
                    Numcount.textColor=[UIColor blackColor];
                    Numcount.textAlignment=NSTextAlignmentCenter;
                    Numcount.text=lists.h_num;
                    [Numcount sizeToFit];
                    [self addSubview:Numcount];
                
                }
            }
//        }else if(totalCount!=0)
//        {
//            int Yzhou=0;
//            if(lists.h_num){//高温6天趋势
//                [[UIColor colorHelpWithRed:193 green:7 blue:18 alpha:1] set];
//                if(i==0){
//                    
//                    if (lists.h_num.doubleValue<0) {
//                        Yzhou=(fushuCount-1)*5;
//                        CGContextMoveToPoint(ctx, self.frame.size.width*0.1,(self.frame.size.height*0.85-self.frame.size.height*0.7/totalCount*(fushuCount-1))+((0-lists.h_num.doubleValue)*self.frame.size.height*0.7/totalCount*(fushuCount-1)/Yzhou));
//                    }else{
//                         Yzhou=(hengxianCount)*5;
//                        CGContextMoveToPoint(ctx, self.frame.size.width*0.1,(self.frame.size.height*0.85-(lists.h_num.doubleValue*self.frame.size.height*0.7/totalCount*(hengxianCount)/Yzhou))-self.frame.size.height*0.7/totalCount*(fushuCount-1));
//                    }
//                }else{
//                    if (lists.h_num.doubleValue<0) {
//                        Yzhou=(fushuCount-1)*5;
//                        CGContextAddLineToPoint(ctx, self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i,(self.frame.size.height*0.85-self.frame.size.height*0.7/totalCount*(fushuCount-1))+((0-lists.h_num.doubleValue)*self.frame.size.height*0.7/totalCount*(fushuCount-1)/Yzhou));
//                    }else{
//                         Yzhou=(hengxianCount)*5;
//                        CGContextAddLineToPoint(ctx, self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i, (self.frame.size.height*0.85-(lists.h_num.doubleValue*self.frame.size.height*0.7/totalCount*(hengxianCount)/Yzhou))-self.frame.size.height*0.7/totalCount*(fushuCount-1));
//                        
//                    }
//                    
//                }
//                UILabel *Numcount;
//                  if (lists.h_num.doubleValue<0) {
//                      Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-5,(self.frame.size.height*0.85-self.frame.size.height*0.7/totalCount*(fushuCount-1))+((0-lists.h_num.doubleValue)*self.frame.size.height*0.7/totalCount*(fushuCount-1)/Yzhou)-15, 25, 15)];
//                  }else
//                  {
//                      Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-5,(self.frame.size.height*0.85-(lists.h_num.doubleValue*self.frame.size.height*0.7/totalCount*(hengxianCount)/Yzhou))-self.frame.size.height*0.7/totalCount*(fushuCount-1)-15, 25, 15)];
//                  }
//                Numcount.font=[UIFont systemFontOfSize:12];
//                Numcount.textColor=[UIColor blackColor];
//                Numcount.textAlignment=NSTextAlignmentCenter;
//                Numcount.text=lists.h_num;
//                [Numcount sizeToFit];
//                [self addSubview:Numcount];
//            }
//            
//        
//        
//        }
// 
        }
    CGContextSetLineWidth(ctx, 2);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextStrokePath(ctx);
   [[UIColor colorHelpWithRed:30 green:140 blue:158 alpha:1] set];
    for (int i=0; i<self.wr_lists.count; i++){
        wr_list *lists=self.wr_lists[i];
//        int Yzhou=0;
//          if (totalCount==0) {
              if(lists.l_num){//低温6天趋势
                  if (fushuCount!=0) {
                if(i==0){
                     CGContextMoveToPoint(ctx, self.frame.size.width*0.1,(self.frame.size.height*0.85-((lists.l_num.doubleValue-l_numS.l_num.doubleValue)*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin));
                 }else{
        //             NSLog(@"%f  %f", self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i,self.frame.size.height*0.85-(lists.l_num.doubleValue*self.frame.size.height*0.7)/70);
                     CGContextAddLineToPoint(ctx, self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i, (self.frame.size.height*0.85-((lists.l_num.doubleValue-l_numS.l_num.doubleValue)*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin));
                 }
                 UILabel *Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i,self.frame.size.height*0.85-((lists.l_num.doubleValue-l_numS.l_num.doubleValue)*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin-15, 25, 15)];
                 Numcount.font=[UIFont systemFontOfSize:12];
                 Numcount.textColor=[UIColor blackColor];
                 Numcount.textAlignment=NSTextAlignmentCenter;
                 Numcount.text=lists.l_num;
                 [Numcount sizeToFit];
                 [self addSubview:Numcount];
                  }else
                  {
                      if(i==0){
                          CGContextMoveToPoint(ctx, self.frame.size.width*0.1,(self.frame.size.height*0.85-(lists.l_num.doubleValue*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin));
                      }else{
                          //             NSLog(@"%f  %f", self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i,self.frame.size.height*0.85-(lists.l_num.doubleValue*self.frame.size.height*0.7)/70);
                          CGContextAddLineToPoint(ctx, self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i, self.frame.size.height*0.85-(lists.l_num.doubleValue*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin);
                      }
                      UILabel *Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i,self.frame.size.height*0.85-(lists.l_num.doubleValue*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin-13, 25, 15)];
                      Numcount.font=[UIFont systemFontOfSize:12];
                      Numcount.textColor=[UIColor blackColor];
                      Numcount.textAlignment=NSTextAlignmentCenter;
                      Numcount.text=lists.l_num;
                      [Numcount sizeToFit];
                      [self addSubview:Numcount];
                  }
              }
    }
//          }else if(totalCount!=0){
//              if(lists.l_num){//低温6天趋势
//                  if(i==0){
//                      if (lists.l_num.doubleValue<0) {
//                          Yzhou=(fushuCount-1)*5;
//                          CGContextMoveToPoint(ctx, self.frame.size.width*0.1,(self.frame.size.height*0.85-self.frame.size.height*0.7/totalCount*(fushuCount-1))+((0-lists.l_num.doubleValue)*self.frame.size.height*0.7/totalCount*(fushuCount-1)/Yzhou));
//                      }else{
//                          Yzhou=(hengxianCount)*5;
//                          CGContextMoveToPoint(ctx, self.frame.size.width*0.1,(self.frame.size.height*0.85-(lists.l_num.doubleValue*self.frame.size.height*0.7/totalCount*(hengxianCount)/Yzhou))-self.frame.size.height*0.7/totalCount*(fushuCount-1));
//                      }
//                  }else{
//                      if (lists.l_num.doubleValue<0) {
//                          Yzhou=(fushuCount-1)*5;
//                          CGContextAddLineToPoint(ctx, self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i,(self.frame.size.height*0.85-self.frame.size.height*0.7/totalCount*(fushuCount-1))+((0-lists.l_num.doubleValue)*self.frame.size.height*0.7/totalCount*(fushuCount-1)/Yzhou));
//                      }else{
//                          Yzhou=(hengxianCount)*5;
//                          CGContextAddLineToPoint(ctx, self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i, (self.frame.size.height*0.85-(lists.l_num.doubleValue*self.frame.size.height*0.7/totalCount*(hengxianCount)/Yzhou))-self.frame.size.height*0.7/totalCount*(fushuCount-1));
//                          
//                      }
//                  }
//                  UILabel *Numcount;
//                  if (lists.l_num.doubleValue<0) {
//                      Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-5,(self.frame.size.height*0.85-self.frame.size.height*0.7/totalCount*(fushuCount-1))+((0-lists.l_num.doubleValue)*self.frame.size.height*0.7/totalCount*(fushuCount-1)/Yzhou), 25, 15)];
//                  }else
//                  {
//                      Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-5,(self.frame.size.height*0.85-(lists.l_num.doubleValue*self.frame.size.height*0.7/totalCount*(hengxianCount)/Yzhou))-self.frame.size.height*0.7/totalCount*(fushuCount-1), 25, 15)];
//                  }
//                  Numcount.font=[UIFont systemFontOfSize:12];
//                  Numcount.textColor=[UIColor blackColor];
//                  Numcount.textAlignment=NSTextAlignmentCenter;
//                  Numcount.text=lists.l_num;
//                  [Numcount sizeToFit];
//                  [self addSubview:Numcount];
//
//              }
//     
//        }
//    }
        CGContextSetLineWidth(ctx, 2);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextStrokePath(ctx);
    /**
     *  画圆点
     */
    for (int i=0; i<self.wr_lists.count; i++) {
      wr_list *lists=self.wr_lists[i];
//        int Yzhou=0;
        if (lists.num) {
          [[UIColor colorHelpWithRed:30 green:140 blue:158 alpha:1] set];
            CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-2.5,self.frame.size.height*0.85-(lists.num.doubleValue*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin-2.5, 5,5));
            CGContextFillPath(ctx);
//        }else if([lists.type isEqualToString:@"2"])
//        {
//            [[UIColor colorHelpWithRed:30 green:140 blue:158 alpha:1] set];
//            CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-2.5,self.frame.size.height*0.85-(lists.num.doubleValue*self.frame.size.height*0.65)/25-2.5, 5,5));
//            CGContextFillPath(ctx);

        }else if(lists.h_num)
        { //高低温
            
            if (fushuCount!=0) {
                [[UIColor colorHelpWithRed:193 green:7 blue:18 alpha:1] set];
                CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-2.5,(self.frame.size.height*0.85-((lists.h_num.doubleValue-l_numS.l_num.doubleValue)*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin)-2.5, 5,5));
                CGContextFillPath(ctx);
                [[UIColor colorHelpWithRed:30 green:140 blue:158 alpha:1] set];
                CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-2.5,self.frame.size.height*0.85-((lists.l_num.doubleValue-l_numS.l_num.doubleValue)*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin-2.5, 5,5));
                CGContextFillPath(ctx);
            }else
            {
                [[UIColor colorHelpWithRed:193 green:7 blue:18 alpha:1] set];
                CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-2.5,(self.frame.size.height*0.85-(lists.h_num.doubleValue*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin)-2.5, 5,5));
                CGContextFillPath(ctx);
                [[UIColor colorHelpWithRed:30 green:140 blue:158 alpha:1] set];
                CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-2.5,self.frame.size.height*0.85-(lists.l_num.doubleValue*self.frame.size.height*0.7)/(hengxianCount-1)/Ymargin-2.5, 5,5));
                CGContextFillPath(ctx);
            }
//            }else{
//                [[UIColor colorHelpWithRed:193 green:7 blue:18 alpha:1] set];
//                if (lists.h_num.doubleValue<0) {
//                    Yzhou=(fushuCount-1)*5;
//                    CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-2.5,(self.frame.size.height*0.85-self.frame.size.height*0.7/totalCount*(fushuCount-1))+((0-lists.h_num.doubleValue)*self.frame.size.height*0.7/totalCount*(fushuCount-1)/Yzhou)-2.5, 5,5));
//                    CGContextFillPath(ctx);
//                }else
//                {
//                    Yzhou=(hengxianCount)*5;
//                    CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-2.5,(self.frame.size.height*0.85-(lists.h_num.doubleValue*self.frame.size.height*0.7/totalCount*(hengxianCount)/Yzhou))-self.frame.size.height*0.7/totalCount*(fushuCount-1)-2.5, 5,5));
//                    CGContextFillPath(ctx);
//                }
//                
//                [[UIColor colorHelpWithRed:30 green:140 blue:158 alpha:1] set];
//                if (lists.l_num.doubleValue<0) {
//                     Yzhou=(fushuCount-1)*5;
//                    CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-2.5,(self.frame.size.height*0.85-self.frame.size.height*0.7/totalCount*(fushuCount-1))+((0-lists.l_num.doubleValue)*self.frame.size.height*0.7/totalCount*(fushuCount-1)/Yzhou)-2.5, 5,5));
//                    CGContextFillPath(ctx);
//                }else
//                {
//                    Yzhou=(hengxianCount)*5;
//                    CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.8)/5*i-2.5,(self.frame.size.height*0.85-(lists.l_num.doubleValue*self.frame.size.height*0.7/totalCount*(hengxianCount)/Yzhou))-self.frame.size.height*0.7/totalCount*(fushuCount-1)-2.5, 5,5));
//                    CGContextFillPath(ctx);
//
//                }
//                
            
          
        }
       
    }

}
@end
