//
//  ImageInfo.m
//  hlrenTest
//
//  Created by blue on 13-4-23.
//  Copyright (c) 2013年 blue. All rights reserved.
//

#import "ImageInfo.h"
#import "EGOImageView.h"

@implementation ImageInfo

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        
        
        self.thumbURL = [dictionary objectForKey:@"img_path"];
        NSArray *images=[dictionary objectForKey:@"images"];
        if (images.count>0) {
            self.thumbURL=[images[0]objectForKey:@"url"];
        }
        //获取随机高度
        self.width=(arc4random() % 160) + 110;
        self.height=150;
        //        NSLog(@"%f",self.height);
                self.userImg = [dictionary objectForKey:@"head_url"];
        self.zanNum = [[dictionary objectForKey:@"praise"] intValue];
        self.commentNum = [[dictionary objectForKey:@"browsenum"] intValue];
        //        self.forwardNum = [[dictionary objectForKey:@"forwardNum"] intValue];
        self.userName = [dictionary objectForKey:@"nick_name"];
        self.userID = [dictionary objectForKey:@"user_id"] ;
        self.shareTime = [dictionary objectForKey:@"date_time"];
        self.imageType = [dictionary objectForKey:@"imageType"];
        self.weather=[dictionary objectForKey:@"weather"];
        self.itemid=[dictionary objectForKey:@"item_id"];
        self.address=[dictionary objectForKey:@"address"];
        self.des=[dictionary objectForKey:@"des"];
        self.click_type=[dictionary objectForKey:@"isagree"];
//         self.head_url=[dictionary objectForKey:@"head_url"];
        //        NSLog(@"%@",self.thumbURL);
        //
        //        NSLog(@"%f",self.width);
        //        NSLog(@"%f",self.height);
        //        NSLog(@"%d",self.zanNum);
        //        NSLog(@"%d",self.commentNum);
        //        NSLog(@"%d",self.forwardNum);
        //        NSLog(@"%@",self.userName);
        //        NSLog(@"%@",self.userID);
        //        NSLog(@"%@",self.itemid);
        //        NSLog(@"%@",self.shareTime);
        //        NSLog(@"%@",self.imageType);
    }
    return self;
}
//-(void)getimagedata:(NSString *)url{
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[ShareFun makeImageUrl:url]];
//    [request setHTTPMethod:@"GET"]; //设置请求方式
//    [request setTimeoutInterval:60];//设置超时时间
//    self.mutableData = [[NSMutableData alloc] init];
//    [NSURLConnection connectionWithRequest:request delegate:self];//发送一个异步请求
//
//}
//#pragma mark - NSURLConnection delegate
////数据加载过程中调用,获取数据
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    [self.mutableData appendData:data];
//}
//
////数据加载完成后调用
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    UIImage *image = [UIImage imageWithData:self.mutableData];
//    self.imageview.image = image;
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    NSLog(@"请求网络失败:%@",error);
//}
//-(NSString *)description
//{
//    return [NSString stringWithFormat:@"thumbURL:%@ width:%f height:%f",self.thumbURL,self.width,self.height];
//}
@end
