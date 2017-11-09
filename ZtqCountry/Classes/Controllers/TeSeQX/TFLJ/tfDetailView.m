//
//  tfDetailView.m
//  WeatherForecast
//
//  Created by lihj on 12-9-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "tfDetailView.h"
#import <QuartzCore/QuartzCore.h>
#import "typhoonDetailModel.h"

static tfDetailView *shareTfDetailView;

@implementation tfDetailView


+ (id) shareTfDetailView
{
	@synchronized(self){
        if (!shareTfDetailView) {
            shareTfDetailView = [[tfDetailView alloc] initWithFrame:CGRectMake(0, 0, 160, 125)];
        }
    }
    return shareTfDetailView;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		// Initialization code.
		[self setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6]];
		self.layer.cornerRadius = 3.0;//圆角 
		self.layer.masksToBounds = YES;//在所在的层绘制圆角 
		
		UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 40, 15)];
		[t_label setText:@"时间:"];
		[t_label setTextColor:[UIColor whiteColor]];
		[t_label setFont:[UIFont systemFontOfSize:13]];
		[t_label setBackgroundColor:[UIColor clearColor]];
		[self addSubview:t_label];
//		[t_label release];
		
		t_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 40, 15)];
		[t_label setText:@"经度:"];
		[t_label setTextColor:[UIColor whiteColor]];
		[t_label setFont:[UIFont systemFontOfSize:13]];
		[t_label setBackgroundColor:[UIColor clearColor]];
		[self addSubview:t_label];
//		[t_label release];
		
		t_label = [[UILabel alloc] initWithFrame:CGRectMake(85, 20, 40, 15)];
		[t_label setText:@"纬度:"];
		[t_label setTextColor:[UIColor whiteColor]];
		[t_label setFont:[UIFont systemFontOfSize:13]];
		[t_label setBackgroundColor:[UIColor clearColor]];
		[self addSubview:t_label];
//		[t_label release];
		
        t_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 80, 15)];
        [t_label setText:@"移动时速:"];
        [t_label setTextColor:[UIColor whiteColor]];
        [t_label setFont:[UIFont systemFontOfSize:13]];
        [t_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:t_label];
        
		t_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 80, 15)];
		[t_label setText:@"最大风速:"];
		[t_label setTextColor:[UIColor whiteColor]];
		[t_label setFont:[UIFont systemFontOfSize:13]];
		[t_label setBackgroundColor:[UIColor clearColor]];
		[self addSubview:t_label];
//		[t_label release];
		
		t_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 65, 80, 15)];
		[t_label setText:@"中心风力:"];
		[t_label setTextColor:[UIColor whiteColor]];
		[t_label setFont:[UIFont systemFontOfSize:13]];
		[t_label setBackgroundColor:[UIColor clearColor]];
		[self addSubview:t_label];
//		[t_label release];
		
		t_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 80, 80, 15)];
		[t_label setText:@"中心气压:"];
		[t_label setTextColor:[UIColor whiteColor]];
		[t_label setFont:[UIFont systemFontOfSize:13]];
		[t_label setBackgroundColor:[UIColor clearColor]];
		[self addSubview:t_label];
//		[t_label release];
		
		t_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 95, 120, 15)];
		[t_label setText:@"七级风圈半径:"];
		[t_label setTextColor:[UIColor whiteColor]];
		[t_label setFont:[UIFont systemFontOfSize:13]];
		[t_label setBackgroundColor:[UIColor clearColor]];
		[self addSubview:t_label];
//		[t_label release];
		
		t_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 110, 120, 15)];
		[t_label setText:@"十级风圈半径:"];
		[t_label setTextColor:[UIColor whiteColor]];
		[t_label setFont:[UIFont systemFontOfSize:13]];
		[t_label setBackgroundColor:[UIColor clearColor]];
		[self addSubview:t_label];
//		[t_label release];
		
		m_label0 = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 100, 15)];
		[m_label0 setTextColor:[UIColor whiteColor]];
		[m_label0 setFont:[UIFont systemFontOfSize:13]];
		[m_label0 setBackgroundColor:[UIColor clearColor]];
		[self addSubview:m_label0];
//		[m_label0 release];
		
		m_label1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 20, 50, 15)];
		[m_label1 setTextColor:[UIColor whiteColor]];
		[m_label1 setFont:[UIFont systemFontOfSize:13]];
		[m_label1 setBackgroundColor:[UIColor clearColor]];
		[self addSubview:m_label1];
//		[m_label1 release];
		
		m_label2 = [[UILabel alloc] initWithFrame:CGRectMake(125, 20, 50, 15)];
		[m_label2 setTextColor:[UIColor whiteColor]];
		[m_label2 setFont:[UIFont systemFontOfSize:13]];
		[m_label2 setBackgroundColor:[UIColor clearColor]];
		[self addSubview:m_label2];
//		[m_label2 release];
		
        ydspeedlab = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, 75, 15)];
        [ydspeedlab setTextColor:[UIColor whiteColor]];
        [ydspeedlab setFont:[UIFont systemFontOfSize:13]];
        [ydspeedlab setBackgroundColor:[UIColor clearColor]];
        [self addSubview:ydspeedlab];
        
		m_label3 = [[UILabel alloc] initWithFrame:CGRectMake(70, 50, 75, 15)];
		[m_label3 setTextColor:[UIColor whiteColor]];
		[m_label3 setFont:[UIFont systemFontOfSize:13]];
		[m_label3 setBackgroundColor:[UIColor clearColor]];
		[self addSubview:m_label3];
//		[m_label3 release];
		
		m_label4 = [[UILabel alloc] initWithFrame:CGRectMake(70, 65, 75, 15)];
		[m_label4 setTextColor:[UIColor whiteColor]];
		[m_label4 setFont:[UIFont systemFontOfSize:13]];
		[m_label4 setBackgroundColor:[UIColor clearColor]];
		[self addSubview:m_label4];
//		[m_label4 release];
		
		m_label5 = [[UILabel alloc] initWithFrame:CGRectMake(70, 80, 75, 15)];
		[m_label5 setTextColor:[UIColor whiteColor]];
		[m_label5 setFont:[UIFont systemFontOfSize:13]];
		[m_label5 setBackgroundColor:[UIColor clearColor]];
		[self addSubview:m_label5];
//		[m_label5 release];
		
		m_label6 = [[UILabel alloc] initWithFrame:CGRectMake(95, 95, 80, 15)];
		[m_label6 setTextColor:[UIColor whiteColor]];
		[m_label6 setFont:[UIFont systemFontOfSize:13]];
		[m_label6 setBackgroundColor:[UIColor clearColor]];
		[self addSubview:m_label6];
//		[m_label6 release];
		
		m_label7 = [[UILabel alloc] initWithFrame:CGRectMake(95, 110, 80, 15)];
		[m_label7 setTextColor:[UIColor whiteColor]];
		[m_label7 setFont:[UIFont systemFontOfSize:13]];
		[m_label7 setBackgroundColor:[UIColor clearColor]];
		[self addSubview:m_label7];
//		[m_label7 release];
		
		m_btn = [[UIButton alloc] initWithFrame:self.frame];
		[m_btn setTitle:@"▲" forState:UIControlStateNormal];
		m_btn.titleLabel.font = [UIFont systemFontOfSize:10];
		[m_btn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
		[m_btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
		[m_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_btn];
//		[m_btn release];
    }
    return self;
}
//
//- (void)dealloc {
//    [super dealloc];
//}

- (void)showData:(typhoonYearModel *)t_model withNum:(NSInteger)t_num;
{
	typhoonDetailModel *t_detail = (typhoonDetailModel *)[t_model.ful_points objectAtIndex:t_num];
	
	NSString *t_str[9];
	t_str[0] = t_detail.time;
	t_str[1] = t_detail.jd;
	t_str[2] = t_detail.wd;
	t_str[3] = t_detail.fs_max;
	t_str[4] = t_detail.fl;
	t_str[5] = t_detail.qy;
	t_str[6] = t_detail.fl_7;
	t_str[7] = t_detail.fl_10;
    t_str[8]=t_detail.ydss;
	
	NSString *d_date;
	if (t_str[0]) {
		NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
		[dateformat setDateFormat:@"MMddHH"];
		NSDate *s_date = [dateformat dateFromString:t_str[0]];
		[dateformat setDateFormat:@"MM月dd日 HH时"];
		d_date = [dateformat stringFromDate:s_date];
//		[dateformat release];
	}
	
	for (int i = 0; i < 9; i++) {
		if (t_str[i] == nil) {
			t_str[i] = @"N/A";
		}
	}
	
	[m_label0 setText:d_date];
	[m_label1 setText:[NSString stringWithFormat:@"%@", t_str[1]]];
	[m_label2 setText:[NSString stringWithFormat:@"%@", t_str[2]]];
    [ydspeedlab setText:[NSString stringWithFormat:@"%@",t_str[8]]];//移动时速
	[m_label3 setText:[NSString stringWithFormat:@"%@m/s", t_str[3]]];
	[m_label4 setText:[NSString stringWithFormat:@"%@级", t_str[4]]];
	[m_label5 setText:[NSString stringWithFormat:@"%@hPa", t_str[5]]];
	[m_label6 setText:[NSString stringWithFormat:@"%@km", t_str[6]]];
	[m_label7 setText:[NSString stringWithFormat:@"%@km", t_str[7]]];
	
}

- (void)btnClick:(id)sender
{
	m_btn.selected = !m_btn.selected;
	if (m_btn.selected) {
		[m_btn setTitle:@"▼" forState:UIControlStateNormal];
		[self setFrame:CGRectMake(0, 0, 160, 21)];
		[m_btn setFrame:self.frame];
	}
	else {
		[m_btn setTitle:@"▲" forState:UIControlStateNormal];
		[self setFrame:CGRectMake(0, 0, 160, 125)];
		[m_btn setFrame:self.frame];
	}
}

- (void)setIfHidden:(BOOL)t_hidden
{
	self.hidden = t_hidden;
}

@end
