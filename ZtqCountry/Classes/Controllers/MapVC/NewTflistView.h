//
//  NewTflistView.h
//  ZtqCountry
//
//  Created by Admin on 16/2/16.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "typhoonYearModel.h"
@protocol tfAlertDelegate <NSObject>

-(void)tfActionwith:(NSMutableArray *)mytflist;
@end
@interface NewTflistView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UITableView *m_tableView;
}

@property (weak, nonatomic) id<tfAlertDelegate>delegate;
@property (strong, nonatomic) UIImageView * backgroundImgV;
@property(strong,nonatomic)NSArray *tflists;
@property(strong,nonatomic)NSMutableArray *mytflist;
-(id)initWithFrame:(CGRect)frame WithTFdatas:(NSArray *)tflist;
-(void)show;

@end
