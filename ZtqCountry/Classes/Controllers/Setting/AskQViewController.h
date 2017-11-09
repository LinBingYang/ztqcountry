//
//  AskQViewController.h
//  ZtqCountry
//
//  Created by Admin on 14-7-17.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AskQViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mtableview;
    
    int m_expandSection;
    int m_expandRow;
}
//@property(strong,nonatomic)NSArray *arr;
//@property(strong,nonatomic)NSArray *desk,*voice,*share,*run,*tf,*weath;
@property(strong, nonatomic)NSMutableArray * allClassAQ;
@property(strong,nonatomic)NSString *answerheigh;
@end
