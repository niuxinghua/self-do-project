//
//  NSDate+fish_Extension.h
//  WZEfengAndEtong
//
//  Created by wanzhao on 16/6/28.
//  Copyright © 2016年 wanzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (fish_Extension)

/**
 *  字符串转NSDate
 *
 *  @param theTime 字符串时间
 *  @param format  转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return <#return value description#>
 */
+ (NSDate *)dateFromString:(NSString *)timeStr
                    format:(NSString *)format;

/**
 *  NSDate转时间戳
 *
 *  @param date 字符串时间
 *
 *  @return 返回时间戳
 */
+ (NSInteger)cTimestampFromDate:(NSDate *)date;

/**
 *  字符串转时间戳
 *
 *  @param theTime 字符串时间
 *  @param format  转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回时间戳
 */
+ (NSInteger)cTimestampFromString:(NSString *)timeStr
                           format:(NSString *)format;


/**
 *  字符串转时间戳字符串
 *
 *  @param theTime 字符串时间
 *  @param format  转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回时间戳字符串
 */

+(NSString *)cTimestampStringFromString:(NSString *)timeStr
                                 format:(NSString *)format;


/**
 *  时间戳转字符串
 *
 *  @param timeStamp 时间戳
 *  @param format    转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp Format:(NSString *)format;

/**
 *  NSDate转字符串
 *
 *  @param date   NSDate时间
 *  @param format 转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format;

/**时间戳转化为时间字符串*/
+ (NSString *)dateStrFromCstampTimeStr:(NSString *)timeStampStr;

/**指定时间格式转换*/
+ (NSString *)dateStrFromCstampTimeStr:(NSString *)timeStampStr withDateFormatter:(NSString *)dateFormatter;

/**分割时间和日期*/
+ (NSArray *)separteTimeStr:(NSString *)timeStr sepStr:(NSString *)sepStr;

/**获取当前时间戳*/
+ (NSString *)getTimeStamp;

/**TimeStamp2NSDate */
//将时间戳转换成NSDate,转换的时间为格林尼治时间
+ (NSDate *)changeSpToTime:(NSString*)spString;

/**TimeStamp2NSDate  result = 北京时间 */
//将时间戳转换成NSDate,加上时区偏移。这个转换之后是北京时间
+ (NSDate*)zoneChange:(NSString*)spString;

/**时间差*/
//比较给定NSDate与当前时间的时间差，返回相差的秒数
+ (long)timeDifference:(NSDate *)date;

/**NSDate2NSString */
//将NSDate按yyyy-MM-dd HH:mm:ss格式时间输出
+ (NSString*)nsdateToString:(NSDate *)date;

/**NSString2TimeStamp */
//将yyyy-MM-dd HH:mm:ss格式时间转换成时间戳
+ (long)changeTimeToTimeSp:(NSString *)timeStr;

/**get system NSDate */
//获取当前系统的yyyy-MM-dd HH:mm:ss格式时间
+ (NSString *)getTimeDate;

/**指定时间格式获取系统当前时间*/
+ (NSString *)getTimeDateWithDateFormatter:(NSString *)dateFormatter;

/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

/**获取指定时间的时间戳*/
+ (NSDate *)nsdateTotimeStampWithHour:(NSInteger)hour minutes:(NSInteger)minutes;

/**比较两个date 类型 的时间*/
+ (NSInteger)compareWithDate:(NSString *)date otherDate:(NSString *)otherDate;

/**获取当前时间*/
+(NSString *)getCurrentDateWithDateFormatterStr:(NSString *)formaterStr;

@end

