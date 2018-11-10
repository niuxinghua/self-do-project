//
//  UIColor+EAHexColor.m
//
//  Created by Eric Anderson on 12/29/14.
//  Copyright (c) 2014 Eric Anderson. All rights reserved.
//

#import "UIColor+EAHexColor.h"


@implementation UIColor (EAHexColor)

+ (UIColor *)colorWithHex:(NSString *)rgba {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 1.0;
    
    if ([rgba hasPrefix:@"#"]) {
        NSRange range = NSMakeRange(1, rgba.length - 1);
        NSString *hex = [rgba substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:hex];
        unsigned long long hexValue = 0;
        
        if ([scanner scanHexLongLong:&hexValue]) {
            switch (hex.length) {
                case 3:
                    red = (CGFloat)((hexValue & 0xF00) >> 8) / 15.0;
                    green = (CGFloat)((hexValue & 0x0F0) >> 4) / 15.0;
                    blue = (CGFloat)(hexValue & 0x00F);
                    break;
                case 4:
                    red = (CGFloat)((hexValue & 0xF000) >> 12) / 15.0;
                    green = (CGFloat)((hexValue & 0x0F00) >> 8) / 15.0;
                    blue = (CGFloat)((hexValue & 0x00F0) >> 4) / 15.0;
                    alpha = (CGFloat)(hexValue & 0x000F) / 15.0;
                    break;
                case 6:
                    red   = (CGFloat)((hexValue & 0xFF0000) >> 16)   / 255.0;
                    green = (CGFloat)((hexValue & 0x00FF00) >> 8)    / 255.0;
                    blue  = (CGFloat)(hexValue & 0x0000FF)           / 255.0;
                    break;
                case 8:
                    red   = (CGFloat)((hexValue & 0xFF000000) >> 24) / 255.0;
                    green = (CGFloat)((hexValue & 0x00FF0000) >> 16) / 255.0;
                    blue  = (CGFloat)((hexValue & 0x0000FF00) >> 8)  / 255.0;
                    alpha = (CGFloat)(hexValue & 0x000000FF)         / 255.0;
                    break;
                default:
//                    UCLog(@"Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8");
                    break;
            }
        } else {
           // UCLog(@"Scan hex error");
        }
    } else {
       // UCLog(@"Invalid RGB string, missing '#' as prefix");
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
