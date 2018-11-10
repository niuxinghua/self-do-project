//
//  DateFormatterHelper.h
//  SDateFormatterHelper
//
//  Created by tongxuan on 16/12/5.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDateStyleLine1             @"yyyy"
#define kDateStyleLine2             @"yyyy-MM"
#define kDateStyleLine3             @"yyyy-MM-dd"
#define kDateStyleLine4             @"yyyy-MM-dd HH"
#define kDateStyleLine5             @"yyyy-MM-dd HH:mm"
#define kDateStyleLine6             @"yyyy-MM-dd HH:mm:ss"

#define kDateStyleYear1             @"yyyy年"
#define kDateStyleYear2             @"yyyy年MM"
#define kDateStyleYear3             @"yyyy年MM月dd日"
#define kDateStyleYear4             @"yyyy年MM月dd日 HH"
#define kDateStyleYear5             @"yyyy年MM月dd日 HH:mm"
#define kDateStyleYear6             @"yyyy年MM月dd日 HH:mm:ss"


@interface DateFormatterHelper : NSObject

/**
 获取时间

 @param dateStr 时间字符串
 @param dateStyle 时间字符串的时间格式
 @return date
 */
+ (NSDate *)getDateFromDateStr:(NSString *)dateStr dateStyle:(NSString *)dateStyle;

/**
 获取时间字符串

 @param date 时间
 @param dateStyle 时间字符串的时间格式
 @return dateStr
 */
+ (NSString *)getDateStrFromDate:(NSDate *)date dateStyle:(NSString *)dateStyle;



@end
