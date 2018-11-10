
//
//  NSDate+fish_Extension.m
//  WZEfengAndEtong
//
//  Created by wanzhao on 16/6/28.
//  Copyright © 2016年 wanzhao. All rights reserved.
//

#import "NSDate+fish_Extension.h"

static NSDateFormatter *dateFormatter;

@implementation NSDate (fish_Extension)

+(NSDateFormatter *)defaultFormatter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc]init];
    });
    return dateFormatter;
}


+(NSString *)getCurrentDateWithDateFormatterStr:(NSString *)formaterStr {
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formaterStr];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

+ (NSDate *)dateFromString:(NSString *)timeStr
                    format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [NSDate defaultFormatter];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    return date;
}

+ (NSInteger)cTimestampFromDate:(NSDate *)date
{
    return (long)[date timeIntervalSince1970];
}


+(NSInteger)cTimestampFromString:(NSString *)timeStr
                          format:(NSString *)format
{
    NSDate *date = [NSDate dateFromString:timeStr format:format];
    return [NSDate cTimestampFromDate:date];
}

+(NSString *)cTimestampStringFromString:(NSString *)timeStr
                          format:(NSString *)format
{
    NSDate *date = [NSDate dateFromString:timeStr format:format];
    return [NSString stringWithFormat:@"%ld",[NSDate cTimestampFromDate:date] * 1000];
}

+ (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp Format:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp / 1000];
    return [NSDate datestrFromDate:date withDateFormat:format];
}

+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format
{
    NSDateFormatter* dateFormat = [NSDate defaultFormatter];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}

// 时间戳转时间字符串
+ (NSString *)dateStrFromCstampTimeStr:(NSString *)timeStampStr
{
    long long cTime = [timeStampStr longLongValue];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:cTime / 1000];
    
    NSDateFormatter  *dateformatter1 = [[NSDateFormatter alloc] init];
    
//    [dateformatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateformatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    return [dateformatter1 stringFromDate:date1];
}

/**指定时间格式转换*/
+ (NSString *)dateStrFromCstampTimeStr:(NSString *)timeStampStr withDateFormatter:(NSString *)dateFormatter
{
    long long cTime = [timeStampStr longLongValue];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:cTime / 1000];
    
    NSDateFormatter *dateformatter1 = [[NSDateFormatter alloc] init];
    
        [dateformatter1 setDateFormat:dateFormatter];
    
    return [dateformatter1 stringFromDate:date1];
}

+ (NSArray *)separteTimeStr:(NSString *)timeStr sepStr:(NSString *)sepStr{
    
    NSArray *stringArray = [timeStr componentsSeparatedByString:sepStr];
    return stringArray;
}


/**获取当前时间戳*/
+ (NSString *)getTimeStamp {
    
    // 获取当前时间
    NSDate *fromdate=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* string=[dateFormat stringFromDate:fromdate];
    
    // 时间字符串转时间戳字符串
    
    NSInteger strStamp = [NSDate cTimestampFromString:string format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", strStamp];
//    NSString *timeStamp;
//    NSDate *fromdate=[NSDate date];
//    timeStamp = [NSString stringWithFormat:@"%f",[fromdate timeIntervalSince1970]*1000];
    return timeStamp;
}

/**TimeStamp2NSDate */
//将时间戳转换成NSDate,转换的时间为格林尼治时间
+ (NSDate *)changeSpToTime:(NSString*)spString {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString doubleValue]/1000];
    //    NSLog(@"%@",confromTimesp);
    
    return confromTimesp;
    
}

/**TimeStamp2NSDate  result = 北京时间 */
//将时间戳转换成NSDate,加上时区偏移。这个转换之后是北京时间
+ (NSDate*)zoneChange:(NSString*)spString {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString doubleValue]/1000];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:confromTimesp];
    NSDate *localeDate = [confromTimesp  dateByAddingTimeInterval: interval];
    //    NSLog(@"%@",localeDate);
    return localeDate;
}

/**时间差*/
//比较给定NSDate与当前时间的时间差，返回相差的秒数
+ (long)timeDifference:(NSDate *)date {
    NSDate *localeDate = [NSDate date];
    long difference = fabs([localeDate timeIntervalSinceDate:date]);
    return difference;
}

/**NSDate2NSString */
//将NSDate按yyyy-MM-dd HH:mm:ss格式时间输出
+ (NSString*)nsdateToString:(NSDate *)date{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* string=[dateFormat stringFromDate:date];
    //    NSLog(@"%@",string);
    return string;
}

/**NSString2TimeStamp */
//将yyyy-MM-dd HH:mm:ss格式时间转换成时间戳
+ (long)changeTimeToTimeSp:(NSString *)timeStr {
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:timeStr];
    time = (long)[fromdate timeIntervalSince1970];
    //    NSLog(@"%ld",time);
    return time;
}

/**get system NSDate */
//获取当前系统的yyyy-MM-dd HH:mm:ss格式时间
+ (NSString *)getTimeDate {
    NSDate *fromdate=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}

/**指定时间格式获取系统当前时间*/
+ (NSString *)getTimeDateWithDateFormatter:(NSString *)dateFormatter {
    NSDate *fromdate=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:dateFormatter];
    
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}

/***************时间轴相关****************/
- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}

- (BOOL)isThisYear
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

//- (BOOL)isToday
//{
//    // 日历
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
//
//    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
//    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
//
//    return nowCmps.year == selfCmps.year
//    && nowCmps.month == selfCmps.month
//    && nowCmps.day == selfCmps.day;
//}

- (BOOL)isToday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    
    return [nowString isEqualToString:selfString];
}

- (BOOL)isYesterday
{
    // 2014-12-31 23:59:59 -> 2014-12-31
    // 2015-01-01 00:00:01 -> 2015-01-01
    
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}


/**获取某一刻的时间戳*/
+ (NSDate *)nsdateTotimeStampWithHour:(NSInteger)hour minutes:(NSInteger)minutes {
    
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
//    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [greCalendar setTimeZone: timeZone];
    
    NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  fromDate:[NSDate date]];
    
    //  定义一个NSDateComponents对象，设置一个时间点
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setDay:dateComponents.day];
    [dateComponentsForDate setMonth:dateComponents.month];
    [dateComponentsForDate setYear:dateComponents.year];
    [dateComponentsForDate setHour:hour];
    [dateComponentsForDate setMinute:minutes];
    
    NSDate *dateFromDateComponentsForDate = [greCalendar dateFromComponents:dateComponentsForDate];
    return dateFromDateComponentsForDate;
}


+ (NSInteger)compareWithDate:(NSString *)date otherDate:(NSString *)otherDate {
    
    // 设置时间日期格式
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date1 = [NSDate new];
    NSDate *date2 = [NSDate new];
    
    date1 = [df dateFromString:date];
    date2 = [df dateFromString:otherDate];
    
    NSInteger result = [date1 compare:date2];
    
    return result;
}

@end

