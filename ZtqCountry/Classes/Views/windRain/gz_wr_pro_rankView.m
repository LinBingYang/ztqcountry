//
//  gz_wr_pro_rankView.m
//  ZtqCountry
//
//  Created by hpf on 16/1/15.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "gz_wr_pro_rankView.h"
#import "rank_list.h"
@interface gz_wr_pro_rankView()
@property(nonatomic,weak) UILabel *tjsj;
@property(nonatomic,assign) BOOL isTempH;
@property(nonatomic,weak) UIButton *tempBtn;
@property(strong,nonatomic)rank_list *smallList;
@property(nonatomic,weak) UIButton *moreBtn;
@end

@implementation gz_wr_pro_rankView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.isTempH=YES;
        UILabel *tjsj=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 20)];
        tjsj.font=[UIFont systemFontOfSize:12];
        tjsj.backgroundColor=[UIColor clearColor];
        tjsj.textColor=[UIColor colorHelpWithRed:155 green:160 blue:167 alpha:1];
        self.tjsj=tjsj;
        [self addSubview:tjsj];
      
        UIButton *moreBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*0.8, CGRectGetMaxY(tjsj.frame), 50, 32)];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        moreBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"更多常态.png"] forState:UIControlStateNormal];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"更多点击态.png"] forState:UIControlStateHighlighted];
        [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.moreBtn=moreBtn;
        [self addSubview:moreBtn];
    }
    return self;
}
-(void)moreBtnClick
{
    if ([self.delegate respondsToSelector:@selector(gz_wr_pro_rankView: WithRank_lists: andrank_list_time:)]) {
        [self.delegate gz_wr_pro_rankView:self WithRank_lists:self.rank_lists andrank_list_time:self.rank_list_time];
    }

}
-(void)setRank_list_time:(NSString *)rank_list_time
{
    _rank_list_time=[rank_list_time copy];
    NSString *newstr=[NSString stringWithFormat:@"统计时间:%@",rank_list_time];
    self.tjsj.text=newstr;
    NSDictionary *attribute=@{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGSize newsize=[newstr boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    self.tjsj.frame=CGRectMake(self.frame.size.width-20-newsize.width, 0, newsize.width+5, 20);
    if (self.HightTemperature) {
//        self.tjsj.frame=CGRectMake(self.frame.size.width-30-newsize.width-30, 0, newsize.width+2, 20);
        UIButton *tempBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.moreBtn.frame)-70,CGRectGetMaxY(self.tjsj.frame), 60, 35)];
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"时刻.png"] forState:UIControlStateNormal];
        [tempBtn setTitle:@"高温" forState:UIControlStateNormal];
        tempBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        tempBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 15);
        [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.tempBtn=tempBtn;
        [tempBtn addTarget:self action:@selector(dateChange) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tempBtn];
    }
    
}
-(void)dateChange
{
    for (UIView *subviews in self.subviews) {
        if (subviews.tag==999) {
            [subviews removeFromSuperview];
        }
    }
 
    self.isTempH=!self.isTempH;
    if (self.isTempH) {
      [self.tempBtn setTitle:@"高温" forState:UIControlStateNormal];
        self.rank_lists=self.subrank_lists1;
        NSString *newstr=[NSString stringWithFormat:@"统计时间:%@",self.rank_list_time1];
        self.tjsj.text=newstr;
        self.tempType=tempTypeHigt;
        if(self.tempskType==YES)
        {
          self.tempType=tempTypeNormalHigt;
        }
        [self setNeedsDisplay];
    }else
    {
      [self.tempBtn setTitle:@"低温" forState:UIControlStateNormal];
        self.rank_lists=self.subrank_lists2;
        NSString *newstr=[NSString stringWithFormat:@"统计时间:%@",self.rank_list_time2];
        self.tjsj.text=newstr;
        self.tempType=tempTypeLow;
        if(self.tempskType==YES)
        {
            self.tempType=tempTypeNormalLow;
        }
        [self setNeedsDisplay];
    }
    
}
-(void)setRank_lists:(NSArray *)rank_lists
{
    _rank_lists=rank_lists;
    if (rank_lists.count==0) {
        return;
    }else{
    [self setNeedsDisplay];
    }
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //画横线和纵坐标
    
    NSArray *newArray=[self.rank_lists sortedArrayUsingComparator:^NSComparisonResult(rank_list *obj1,rank_list *obj2){
        if (obj1.val.doubleValue>obj2.val.doubleValue) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    rank_list *lists=newArray[0]; //最小值
    self.smallList=lists;
    rank_list *list=newArray.lastObject; //最大值
//    int hengxianCount=list.val.doubleValue/10+3;
    int hengxianCount=8;
    int Ymargin=((int)(list.val.doubleValue/7)+1);
    int fushuCount=0;
    int totalCount=0;
//    if([lists.type isEqualToString:@"2"])
//    {
//        hengxianCount=list.val.doubleValue/5+3;
//        
        if(lists.val.doubleValue<0) //最小值小于0
        {
            
//         fushuCount= (0-lists.val.doubleValue)/5+1;
//            if (list.val.doubleValue>0) {   //最大值大于0
//                hengxianCount=list.val.doubleValue/5+1;
//                totalCount=fushuCount+hengxianCount;
//            }else{                      //最大值小于0
//                hengxianCount=0;
//                totalCount=fushuCount;
//            
//                }
            fushuCount=1;
            Ymargin=(list.val.doubleValue-lists.val.doubleValue)/7+1;
        }
//
//    }
    
//    if([lists.type isEqualToString:@"3"])
//    {
//        hengxianCount=list.val.doubleValue/2+3;
//    }

    CGContextRef ctx= UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextSetLineWidth(ctx, 0.5);
    for (int i=0; i<hengxianCount; i++) {
//        if(fushuCount==0){
        UILabel *mmY;
            /**
             *  下面三句代码用来画横线
                */
            if (i==0) {
            CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-(self.frame.size.height*0.55/(hengxianCount-1)*i));
            CGContextAddLineToPoint(ctx, self.frame.size.width*0.95, self.frame.size.height*0.85-(self.frame.size.height*0.55/(hengxianCount-1)*i));
            CGContextStrokePath(ctx);
            }else{
            CGContextSaveGState(ctx);
            CGFloat lengths[] = {10,10};
            CGContextSetLineDash(ctx, 0, lengths, 2);
            [[UIColor colorHelpWithRed:155 green:160 blue:167 alpha:1] set];
            CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-(self.frame.size.height*0.55/(hengxianCount-1)*i));
            CGContextAddLineToPoint(ctx, self.frame.size.width*0.95, self.frame.size.height*0.85-(self.frame.size.height*0.55/(hengxianCount-1)*i));
            CGContextStrokePath(ctx);
            CGContextRestoreGState(ctx);
            }
        mmY=[[UILabel alloc ]initWithFrame:CGRectMake(0, self.frame.size.height*0.85-(self.frame.size.height*0.55/(hengxianCount-1)*i)-7, 29, 15)];
        mmY.tag=999;
        mmY.font=[UIFont systemFontOfSize:11];
        mmY.textColor=[UIColor blackColor];
//        mmY.backgroundColor=[UIColor redColor];
        mmY.textAlignment=NSTextAlignmentRight;
//        if (self.YzhouType==YzhouTypeRain) {
//        mmY.text=[NSString stringWithFormat:@"%d.0",i*((int)(list.val.doubleValue/7)+1)];
//     
//        }else if (self.YzhouType==YzhouTypeWind) {
//         
//            mmY.text=[NSString stringWithFormat:@"%d.0",i*((int)(list.val.doubleValue/7)+1)];
//        }else
//        {
//        mmY.text=[NSString stringWithFormat:@"%d.0",i*((int)(list.val.doubleValue/7)+1)];
//        }
        if (fushuCount!=0) {
            
         mmY.text=[NSString stringWithFormat:@"%.1f",i*Ymargin+lists.val.doubleValue];
        }else
        {
         mmY.text=[NSString stringWithFormat:@"%d.0",i*Ymargin];
        }
   
        [self addSubview:mmY];
        }
//    }
//    if (fushuCount!=0) {
//        UILabel *mmY;
//        CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85);
//        CGContextAddLineToPoint(ctx, self.frame.size.width*0.95, self.frame.size.height*0.85);
//        CGContextStrokePath(ctx);
//        mmY=[[UILabel alloc ]initWithFrame:CGRectMake(1, self.frame.size.height*0.9-10, 30, 15)];
//        mmY.tag=999;
//        mmY.font=[UIFont systemFontOfSize:10];
//        mmY.textColor=[UIColor colorHelpWithRed:155 green:159 blue:167 alpha:1];
//        mmY.textAlignment=NSTextAlignmentCenter;
//        
//        mmY.text=[NSString stringWithFormat:@"%.1f",(self.smallList.val.doubleValue)];
//        [self addSubview:mmY];
//        for (int i=0; i<totalCount; i++) {
//            UILabel *mmY;
//            double aaaa=(0-lists.val.doubleValue-(fushuCount-1-hengxianCount)*5)*self.frame.size.height*0.7/totalCount/5;
//            double bbb=self.frame.size.height*0.9;
            /**
             *  下面三句代码用来画横线
       
             */
   
//            CGContextSaveGState(ctx);
//            CGFloat lengths[] = {10,10};
//            CGContextSetLineDash(ctx, 0, lengths, 2);
//            [[UIColor colorHelpWithRed:155 green:160 blue:167 alpha:1] set];
//            CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85-(self.frame.size.height*0.55/totalCount*i)-(0-lists.val.doubleValue-(fushuCount-1)*5)*self.frame.size.height*0.7/totalCount/5);
//            CGContextAddLineToPoint(ctx, self.frame.size.width*0.95, self.frame.size.height*0.85-(self.frame.size.height*0.55/totalCount*i)-(0-lists.val.doubleValue-(fushuCount-1)*5)*self.frame.size.height*0.7/totalCount/5);
//            CGContextStrokePath(ctx);
//            CGContextRestoreGState(ctx);
//            mmY=[[UILabel alloc ]initWithFrame:CGRectMake(1, self.frame.size.height*0.85-(self.frame.size.height*0.55/totalCount*i)-(0-lists.val.doubleValue-(fushuCount-1)*5)*self.frame.size.height*0.7/totalCount/5-7, 30, 15)];
//            mmY.tag=999;
//            mmY.font=[UIFont systemFontOfSize:10];
//            mmY.textColor=[UIColor blackColor];
//            mmY.textAlignment=NSTextAlignmentCenter;
//            
//            mmY.text=[NSString stringWithFormat:@"%.1f",(-fushuCount+i+1)*5.0];
//            [self addSubview:mmY];
//        }
//    }
    UILabel *danweiMM=[[UILabel alloc ]initWithFrame:CGRectMake(3,self.frame.size.height*0.3-25, 30, 20)];
    danweiMM.font=[UIFont systemFontOfSize:12];
    danweiMM.textColor=[UIColor blackColor];
    danweiMM.textAlignment=NSTextAlignmentCenter;
    danweiMM.text=@"mm";
    danweiMM.tag=999;
    if (self.YzhouType==YzhouTypeTemp) {
    danweiMM.text=@"℃";
    }
    if (self.YzhouType==YzhouTypeWind) {
     danweiMM.text=@"m/s";
    }
    [self addSubview:danweiMM];
    //画纵线
//    if ([lists.type isEqualToString:@"3"]) {
        CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.85);
        CGContextAddLineToPoint(ctx, self.frame.size.width*0.1, self.frame.size.height*0.85-self.frame.size.height*0.57);
        CGContextStrokePath(ctx);
//    }else{
//    CGContextMoveToPoint(ctx, self.frame.size.width*0.1,self.frame.size.height*0.9);
//    CGContextAddLineToPoint(ctx, self.frame.size.width*0.1, self.frame.size.height*0.9-self.frame.size.height*0.1*(hengxianCount));
//    CGContextStrokePath(ctx);
//    }
    //画横坐标  和数据
    if (self.rank_lists.count>6) {
        for (int i=0; i<6; i++) {
//            int Yzhou;
//            if ([lists.type isEqualToString:@"1"]) {
//                
//                Yzhou=(hengxianCount-1)*10;
//            }
//            if ([lists.type isEqualToString:@"2"]) {
//                Yzhou=(hengxianCount-1)*5;
//            }
//            if ([lists.type isEqualToString:@"3"]) {
//                Yzhou=(hengxianCount-1)*2;
//            }
            UILabel *timeX=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i+2, self.frame.size.height*0.85, 40, 25)];
            timeX.center=CGPointMake(self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i+18, self.frame.size.height*0.85+12);
            timeX.font=[UIFont systemFontOfSize:10];
            timeX.numberOfLines=0;
            timeX.tag=999;
            timeX.textAlignment=NSTextAlignmentCenter;
//            timeX.backgroundColor=[UIColor colorHelpWithRed: (arc4random() % 256) + 1 green:(arc4random() % 256) + 1 blue:(arc4random() % 256) + 1 alpha:1];
            timeX.textColor=[UIColor blackColor];
            rank_list *lists=self.rank_lists[i];
            timeX.text=lists.city_name;
//            [timeX sizeToFit];
            [self addSubview:timeX];
            [[UIColor colorHelpWithRed:88 green:160 blue:220 alpha:1] set];
            if(fushuCount!=0){
                
                //数据  显示数据在上方
                
                    CGContextFillRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i+8, (self.frame.size.height*0.85-(lists.val.doubleValue-self.smallList.val.doubleValue)*self.frame.size.height*0.55/(hengxianCount-1)/Ymargin), 20, (lists.val.doubleValue-self.smallList.val.doubleValue)*self.frame.size.height*0.55/(hengxianCount-1)/Ymargin));
                    
                    UILabel *Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i,(self.frame.size.height*0.85-(lists.val.doubleValue-self.smallList.val.doubleValue)*self.frame.size.height*0.55/(hengxianCount-1)/Ymargin)-11, 40, 11)];
                    CGPoint Numpoint=Numcount.center;
                    Numpoint.x=self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i+18;
                    Numcount.center=Numpoint;
                    Numcount.font=[UIFont systemFontOfSize:11];
                    Numcount.textColor=[UIColor blackColor];
                    Numcount.textAlignment=NSTextAlignmentCenter;
                    Numcount.text=lists.val;
                    Numcount.tag=999;
//                    [Numcount sizeToFit];
                    [self addSubview:Numcount];
            }else if (fushuCount==0) {
//                double count=(lists.val.doubleValue*self.frame.size.height*0.55)/(hengxianCount-1)/Ymargin;
                CGContextFillRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i+8, (self.frame.size.height*0.85-(lists.val.doubleValue*self.frame.size.height*0.55)/(hengxianCount-1)/Ymargin), 20, (lists.val.doubleValue*self.frame.size.height*0.55)/(hengxianCount-1)/Ymargin));
                
                UILabel *Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i,self.frame.size.height*0.85-(lists.val.doubleValue*self.frame.size.height*0.55)/(hengxianCount-1)/Ymargin-15, 40, 11)];
                CGPoint Numpoint=Numcount.center;
                Numpoint.x=self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i+18;
                Numcount.center=Numpoint;
                Numcount.font=[UIFont systemFontOfSize:11];
                Numcount.textColor=[UIColor blackColor];
                Numcount.textAlignment=NSTextAlignmentCenter;
                Numcount.text=lists.val;
                Numcount.tag=999;
//                [Numcount sizeToFit];
                [self addSubview:Numcount];
                
                
            }
        }
    }else
    {
        for (int i=0; i<self.rank_lists.count; i++) {
            UILabel *timeX=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i+2, self.frame.size.height*0.85, 40, 25)];
            timeX.center=CGPointMake(self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i+18, self.frame.size.height*0.85+12);
            timeX.font=[UIFont systemFontOfSize:10];
            timeX.tag=999;
            timeX.textAlignment=NSTextAlignmentCenter;
            //            timeX.backgroundColor=[UIColor colorHelpWithRed: (arc4random() % 256) + 1 green:(arc4random() % 256) + 1 blue:(arc4random() % 256) + 1 alpha:1];
            timeX.textColor=[UIColor blackColor];
            rank_list *lists=self.rank_lists[i];
            timeX.text=lists.city_name;
            //            [timeX sizeToFit];
            [self addSubview:timeX];
            [[UIColor colorHelpWithRed:88 green:160 blue:220 alpha:1] set];
            if(fushuCount!=0){
                
                //数据  显示数据在上方
                
                CGContextFillRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i+8, (self.frame.size.height*0.85-(lists.val.doubleValue-self.smallList.val.doubleValue)*self.frame.size.height*0.55/(hengxianCount-1)/Ymargin), 20, (lists.val.doubleValue-self.smallList.val.doubleValue)*self.frame.size.height*0.55/(hengxianCount-1)/Ymargin));
                
                UILabel *Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i,(self.frame.size.height*0.85-(lists.val.doubleValue-self.smallList.val.doubleValue)*self.frame.size.height*0.55/(hengxianCount-1)/Ymargin)-11, 40, 11)];
                CGPoint Numpoint=Numcount.center;
                Numpoint.x=self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i+18;
                Numcount.center=Numpoint;
                Numcount.font=[UIFont systemFontOfSize:11];
                Numcount.textColor=[UIColor blackColor];
                Numcount.textAlignment=NSTextAlignmentCenter;
                Numcount.text=lists.val;
                Numcount.tag=999;
//                [Numcount sizeToFit];
                [self addSubview:Numcount];
            
            }else if (fushuCount==0) {
             
                CGContextFillRect(ctx, CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i+8, (self.frame.size.height*0.85-(lists.val.doubleValue*self.frame.size.height*0.55)/(hengxianCount-1)/Ymargin), 20, (lists.val.doubleValue*self.frame.size.height*0.55)/(hengxianCount-1)/Ymargin));
                
                UILabel *Numcount=[[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i,self.frame.size.height*0.85-(lists.val.doubleValue*self.frame.size.height*0.55)/(hengxianCount-1)/Ymargin-15, 40, 11)];
                CGPoint Numpoint=Numcount.center;
                Numpoint.x=self.frame.size.width*0.1+(self.frame.size.width*0.85)/6*i+18;
                Numcount.center=Numpoint;
                Numcount.textColor=[UIColor blackColor];
                Numcount.font=[UIFont systemFontOfSize:11];
                Numcount.textAlignment=NSTextAlignmentCenter;
                Numcount.text=lists.val;
                Numcount.tag=999;
//                [Numcount sizeToFit];
                [self addSubview:Numcount];
                
                
            }
        }

    
    }
   }
@end
