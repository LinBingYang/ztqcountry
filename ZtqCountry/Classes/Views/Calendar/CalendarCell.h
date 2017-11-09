//
//  CalendarCell.h
//  Calendar
//
//  Created by 黄 芦荣 on 12-4-1.
//  Copyright 2012 卓派. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CalendarCell;
@protocol CalendarCellDelegate<NSObject>
@required

-(void)selectedCell:(UIImageView *)t_image setDay:(int)t_day setMonth:(int)t_month setYear:(int)t_year withTag:(int)tag;

@end




@interface CalendarCell : UIView {
    
    //	id<CalendarCellDelegate> delegate;
    __weak id<CalendarCellDelegate> delegate;
	
	UILabel *m_dateText;
	UILabel *m_almanacText;
	UIImageView *m_bgImage;
	int m_type;
	int m_month;
	int m_year;
}

@property(nonatomic, weak)id<CalendarCellDelegate>delegate;
@property(nonatomic, readonly)UILabel *m_dateText;
@property(nonatomic, readonly)UILabel *m_almanacText;
@property(nonatomic, readonly)UIImageView *m_bgImage,*pointimg,*hwimg;
@property(nonatomic, assign)int m_type;
@property(nonatomic, assign)int m_month;
@property(nonatomic, assign)int m_year;
@property (nonatomic, assign) UIImageView * selectedImage;
@property (nonatomic, strong) UIButton * selectedBut;

-(id)initWithType:(int)t_type setFrame:(CGRect)t_frame;

@end
