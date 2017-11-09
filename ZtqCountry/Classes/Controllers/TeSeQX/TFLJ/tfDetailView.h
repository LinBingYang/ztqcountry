//
//  tfDetailView.h
//  WeatherForecast
//
//  Created by lihj on 12-9-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "typhoonYearModel.h"

@interface tfDetailView : UIView {

	UILabel *m_label0;
	UILabel *m_label1;
	UILabel *m_label2;
	UILabel *m_label3;
	UILabel *m_label4;
	UILabel *m_label5;
	UILabel *m_label6;
	UILabel *m_label7;
    UILabel *ydspeedlab;
	
	UIButton *m_btn;
}

+ (id) shareTfDetailView;
- (void)showData:(typhoonYearModel *)t_model withNum:(NSInteger)t_num;
- (void)setIfHidden:(BOOL)t_hidden;

@end
