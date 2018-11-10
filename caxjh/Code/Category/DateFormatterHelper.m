//
//  DateFormatterHelper.m
//  SDateFormatterHelper
//
//  Created by tongxuan on 16/12/5.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "DateFormatterHelper.h"

static NSDateFormatter * dateFormatter;

@implementation DateFormatterHelper

+ (NSDate *)getDateFromDateStr:(NSString *)dateStr dateStyle:(NSString *)dateStyle {
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = dateStyle;
    //dateFormatter.timeZone = [NSTimeZone localTimeZone];
   // [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    return [dateFormatter dateFromString:dateStr];
}

+ (NSString *)getDateStrFromDate:(NSDate *)date dateStyle:(NSString *)dateStyle {
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = dateStyle;
   // dateFormatter.timeZone = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    return [dateFormatter stringFromDate:date];
}



@end
