//
//  gz_wr_more_rankViewController.h
//  ZtqCountry
//
//  Created by hpf on 16/1/16.
//  Copyright © 2016年 yyf. All rights reserved.
//
#import "BaseViewController.h"
#import "MJExtension.h"
@interface gz_wr_more_rankViewController : BaseViewController{
    BOOL _reloading;
}
@property(nonatomic,strong) NSArray *rank_lists;
@property(nonatomic,copy) NSString *rank_list_time;
@property(strong,nonatomic)NSArray *next_datas;
@property(nonatomic,strong)NSMutableArray *dats;
@property(nonatomic,assign)YzhouType titleType;
@property(nonatomic,assign)tempType tempType;
@property(nonatomic,assign)WindType WindType;
@end
