//
//  MainView.m
//  ZtqCountry
//
//  Created by Admin on 15/6/3.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "MainView.h"
#import "UILabel+utils.h"

@implementation MainView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.hourView = [[HourWtView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 255)];
        [self gethourinfo];
        self.servenView = [[ServevnDayView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 255)];
        [self addSubview:self.servenView];
        
    }
    return self;
}

- (void)loadServenData:(NSMutableArray *)infos {

    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_weekwt = [[NSMutableDictionary alloc] init];
    [gz_weekwt setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [b setObject:gz_weekwt forKey:@"gz_weekwt_s_y"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
 
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_weekwt_s_y"];
            NSArray *weekinfos=[gz_air_qua_index objectForKey:@"weekwt_list"];
            if(weekinfos.count>0){
                [self.servenView updateWithInfos:weekinfos];
            }
            [[NSUserDefaults standardUserDefaults]setObject:returnData forKey:@"gz_weekwt_s_y_cache"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
    } withFailure:^(NSError *error) {
        [self cacheServen];
    } withCache:YES];

}
-(void)cacheServen{
    [self.hourView removeFromSuperview];
    self.hourView = nil;
    [self.servenView removeFromSuperview];
    self.servenView = nil;
    self.servenView = [[ServevnDayView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 255)];
    [self addSubview:self.servenView];
    NSDictionary *returnData=[[NSUserDefaults standardUserDefaults]objectForKey:@"gz_weekwt_s_y_cache"];
    if (returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_weekwt_s_y"];
            NSArray *weekinfos=[gz_air_qua_index objectForKey:@"weekwt_list"];
            if(weekinfos.count>0){
                [self.servenView updateWithInfos:weekinfos];
            }
        }
    }
}
-(void)gethourinfo{



    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_weekwt = [[NSMutableDictionary alloc] init];
    [gz_weekwt setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [gz_weekwt setObject:@"36" forKey:@"hours"];
    [b setObject:gz_weekwt forKey:@"gz_hourswt_new"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            [[NSUserDefaults standardUserDefaults]setObject:returnData forKey:@"gz_hourswt_new_cache"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSDictionary * gz_hourswt = [b objectForKey:@"gz_hourswt_new"];
            NSArray *hourswt_list=[gz_hourswt objectForKey:@"hourswt_list"];
            if (hourswt_list.count<=0) {
                [self cachehourinfo];
                return;
            }
          
            NSString *ico=[gz_hourswt objectForKey:@"icon"];
            NSString *pub_str=[gz_hourswt objectForKey:@"pub_str"];
            NSString *wt=[gz_hourswt objectForKey:@"wt"];
            NSString *higt=[gz_hourswt objectForKey:@"higt"];
            NSString *lowt=[gz_hourswt objectForKey:@"lowt"];
            NSString *nowt=[gz_hourswt objectForKey:@"nowt"];
            NSString *nowrain=@"0.0";
            
            if (hourswt_list.count>0) {
              
                [self.hourView updateviewwithico:ico withput:pub_str withwt:wt withhig:higt withlowt:lowt withnowct:nowt withnowrain:nowrain withhourlist:hourswt_list];
            }else{
                
            }
            
            
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        [self cachehourinfo];
    } withCache:YES];
}
-(void)cachehourinfo{
    NSDictionary *returnData=[[NSUserDefaults standardUserDefaults]objectForKey:@"gz_hourswt_new_cache"];
    if (returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_hourswt = [b objectForKey:@"gz_hourswt_new"];
            NSArray *hourswt_list=[gz_hourswt objectForKey:@"hourswt_list"];
            
            NSString *ico=[gz_hourswt objectForKey:@"icon"];
            NSString *pub_str=[gz_hourswt objectForKey:@"pub_str"];
            NSString *wt=[gz_hourswt objectForKey:@"wt"];
            NSString *higt=[gz_hourswt objectForKey:@"higt"];
            NSString *lowt=[gz_hourswt objectForKey:@"lowt"];
            NSString *nowt=[gz_hourswt objectForKey:@"nowt"];
            NSString *nowrain=@"0.0";
            
            if (hourswt_list.count>0) {
                
                [self.hourView updateviewwithico:ico withput:pub_str withwt:wt withhig:higt withlowt:lowt withnowct:nowt withnowrain:nowrain withhourlist:hourswt_list];
            }else{
                
            }
        }
    }
}
- (void)loadSubTwoView:(BOOL)two {
    if (two) {
        if (self.hourView) {
            [self.hourView removeFromSuperview];
        }
        if (self.servenView) {
            if (![self.subviews containsObject:self.servenView]) {
                [self addSubview:self.servenView];
            }
            
        }else {
            self.servenView = [[ServevnDayView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 255)];
            [self addSubview:self.servenView];

        }
        [self loadServenData:nil];
    }else {
        if (self.servenView) {
            [self.servenView removeFromSuperview];
        }
        if (self.hourView) {
            if (![self.subviews containsObject:self.hourView]) {
                [self addSubview:self.hourView];
            }
        }else {
            self.hourView = [[HourWtView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 255)];
            [self addSubview:self.hourView];
                 }
        [self gethourinfo];
        
    }
}



@end
