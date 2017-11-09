//
//  UISwitch+CustomText.m
//  ZtqCountry
//
//  Created by linxg on 14-8-8.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "UISwitch+CustomText.h"
#define TAG_OFFSET    900

@implementation UISwitch (CustomText)

-(void)locateAndTagAndTag:(UIView *)aView withCount:(int *)count
{
    for(UIView * subview in [aView subviews])
    {
        if([subview isKindOfClass:[UILabel class]])
        {
            *count +=1;
            [subview setTag:(TAG_OFFSET+*count)];
        }
        else
        {
            [self locateAndTagAndTag:subview withCount:count];
        }
    }
}

-(UILabel *)label1
{
    return (UILabel *)[self viewWithTag:TAG_OFFSET + 1];
}
-(UILabel *)label2
{
    return (UILabel *)[self viewWithTag:TAG_OFFSET + 2];
}

+(UISwitch *)switchWithLeftText:(NSString *)tag1 andRight:(NSString *)tag2
{
    UISwitch * switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    int labelCount = 0;
    [switchView locateAndTagAndTag:switchView withCount:&labelCount];
    if(labelCount == 2)
    {
        [switchView.label1 setText:tag1];
        [switchView.label2 setText:tag2];
    }
    return  switchView;
}

@end
