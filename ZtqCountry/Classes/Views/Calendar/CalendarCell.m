//
//  CalendarCell.m
//  Calendar
//
//  Created by 黄 芦荣 on 12-4-1.
//  Copyright 2012 卓派. All rights reserved.
//

#import "CalendarCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CalendarCell

@synthesize delegate;
@synthesize m_dateText;
@synthesize m_almanacText;
@synthesize m_bgImage;
@synthesize m_type;
@synthesize m_month;
@synthesize m_year;
@synthesize pointimg;
@synthesize hwimg;

-(id)initWithFrame:(CGRect)frame{
	
	if(self = [super initWithFrame:frame]){
		
		
		m_bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[self addSubview:m_bgImage];
        //		[m_bgImage release];
        
        CGRect t_frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
		UIButton *t_button = [[UIButton alloc] initWithFrame:t_frame];
        self.selectedBut = t_button;
		[t_button setBackgroundColor:[UIColor clearColor]];
		[t_button setBackgroundImage:[UIImage imageNamed:@"日历_14.png"] forState:UIControlStateHighlighted];
        [t_button setBackgroundImage:[UIImage imageNamed:@"日历_14.png"] forState:UIControlStateSelected];
		[t_button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:t_button];
		if (0 == m_type) {
			
            m_dateText = [[UILabel alloc] initWithFrame:CGRectMake(0, 2.5, self.frame.size.width, 20)];
            //            m_dateText.enabled = NO;
            m_dateText.font = [UIFont systemFontOfSize:15];
            m_dateText.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
            m_dateText.textAlignment = NSTextAlignmentCenter;
            m_dateText.backgroundColor = [UIColor clearColor];
            m_dateText.textColor = [UIColor blackColor];
            [self addSubview:m_dateText];
            //			[m_dateText release];
		}else if ( 1 == m_type) {
            pointimg = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-6, 0, 6, 6)];
            [self addSubview:pointimg];
            
            //加班节假日图标
            hwimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
            [self addSubview:hwimg];
            
//            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
//            line.backgroundColor=[UIColor grayColor];
//            [self addSubview:line];
//            UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
//            line1.backgroundColor=[UIColor grayColor];
//            [self addSubview:line1];
            
//            UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 0.5)];
//            line2.backgroundColor=[UIColor grayColor];
//            [self addSubview:line2];
//            UIImageView *line3=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-1, 0, 0.5, self.frame.size.height)];
//            line3.backgroundColor=[UIColor grayColor];
//            [self addSubview:line3];
            
            m_dateText = [[UILabel alloc] initWithFrame:CGRectMake(0, 2.5, self.frame.size.width, 20)];
            //            m_dateText.enabled = NO;
            m_dateText.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height*3/8);
            m_dateText.font = [UIFont systemFontOfSize:15];
            m_dateText.textAlignment = NSTextAlignmentCenter;
            m_dateText.textColor = [UIColor blackColor];
            m_dateText.backgroundColor = [UIColor clearColor];
            [self addSubview:m_dateText];
            
			
			m_almanacText = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*3/8+3, self.frame.size.width, 25)];
            //            m_almanacText.enabled = NO;
			m_almanacText.font = [UIFont systemFontOfSize:13];
			[m_almanacText setTextAlignment:NSTextAlignmentCenter];
			m_almanacText.backgroundColor = [UIColor clearColor];
			m_almanacText.textColor = [UIColor grayColor];
			[self addSubview:m_almanacText];
            //			[m_almanacText release];
		}
        //        m_bgImage.center = m_dateText.center;
        
        //		[t_button release];
	}
	
	return self;
}

-(void)buttonPressed{
	
	int t_day = [m_dateText.text intValue];
	if (nil == delegate ) {
		return;
	}else {
		[delegate selectedCell:m_bgImage setDay:t_day setMonth:m_month setYear:m_year withTag:self.tag];
	}
    
    
}

#pragma mark -
#pragma mark -public

-(id)initWithType:(int)t_type setFrame:(CGRect)t_frame{
    
	m_type = t_type;
	return [self initWithFrame:t_frame];
	
    //	return self;
	
}

@end
