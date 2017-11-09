//
//  rankListModle.h
//  ZtqNew
//
//  Created by linxg on 13-8-6.
//
//

#import <Foundation/Foundation.h>

@interface rankListModle : NSObject{
    int rank;
    NSString *province;
    NSString *city;
    NSString *number;
    NSString *areaid;
}
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)NSString *areaid;
@property int rank;

@end
