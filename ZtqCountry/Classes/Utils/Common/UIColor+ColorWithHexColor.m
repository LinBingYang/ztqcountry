//
//  UIColor+ColorWithHexColor.m
//  ZtqNew
//
//  Created by linxg on 14-2-28.
//
//

#import "UIColor+ColorWithHexColor.h"

@implementation UIColor (ColorWithHexColor)


+(UIColor *)colorWithHexColor:(NSString *)hexColor withAlpha:(float)alpha
{
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if(cString.length <6)
    {
        return [UIColor clearColor];
    }
    if([cString hasPrefix:@"OX"])
    {
        cString = [cString substringFromIndex:2];
    }
    else if([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&blue];
    
    UIColor * color = [UIColor colorWithRed:((float)red/255.0) green:((float)green/255.0) blue:((float)blue/255.0) alpha:alpha];
    return color;
}
@end
