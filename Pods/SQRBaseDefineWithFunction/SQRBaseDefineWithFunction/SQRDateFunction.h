//
//  SQRDateFunction.h
//  SQRCommonToolsProject
//  
//  Created by macMini on 2018/5/25.
//  Copyright © 2018年 PR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQRDateFunction : NSObject
/**
 *  获取当前时间戳
 */
+ (NSString *)getCurrentDateString;
+ (NSString *)getInternetDate;


/**
 *  与当前时间比较格式化返回，例如：刚刚，5分钟前等
 *  @param compareDate 待比对的时间字符串
 *  @return 比对结果
 */
+ (NSString *)compareCurrentTime:(NSString *)compareDate;


/**
 *  与当前时间比较格式化返回，例如：08：56，2016/08/30 08：56等
 *  @param dateStr 待比对的时间字符串
 *  @return 比对结果
 */
+ (NSString *)compareDate:(NSString *)dateStr;


/**
 *  判断是不是今天
 *  @param date 带比对时间
 *  @return BOOL值 0/1
 */
+ (BOOL)isToday:(NSDate *)date;


/**
 *  判断是不是今天
 *  @param dateString 带比对时间
 *  @return BOOL值 0/1
 */
+ (BOOL)isTodayWithString:(NSString *)dateString;


/**
 *  判断是不是昨天
 *  @param dateString 带比对时间
 *  @return BOOL值 0/1
 */
+ (BOOL)isYersterday:(NSString *)dateString;


/**
 *  判断是不是今年
 *  @param dateString 带比对时间
 *  @return BOOL值 0/1
 */
+ (BOOL)isThisYear:(NSString *)dateString;


/**
 *  判断是否本月
 *  @param dateString 带比对时间
 *  @return BOOL值 0/1
 */
+ (BOOL)isThisMonth:(NSString *)dateString;


/**
 *  获取年份
 *  @param dateString 时间
 *  @return 年份
 */
+ (NSString *)year:(NSString *)dateString;


/**
 *  获取MM月
 *  @param dateString 时间
 *  @return MM月
 */
+ (NSString *)month:(NSString *)dateString;


/**
 *  获取当前月天数
 *  @return 当前月天数
 */
+ (NSInteger )dateNumber;


/**
 *  获取当前时间(天数)
 *  @return 当前时间
 */
+ (NSString *)toDay;


/**
 *  获取当前时间 年-月-日
 *  @return yyyy年MM月
 */
+ (NSString *)yearAndMonthAndDay;


/**
 *  获取yyyy年MM月
 *  @return yyyy年MM月
 */
+ (NSString *)yearAndMonth;


/**
 *  获取MM-dd
 *  @param dateString 时间
 *  @return MM-dd
 */
+ (NSString *)monthAndDay:(NSString *)dateString;


/**
 *  获取HH:ss
 *  @param dateString 时间
 *  @return HH:ss
 */
+ (NSString *)hourAndMinute:(NSString *)dateString;


/**
 *  获取星期
 *  @param dateString 时间
 *  @return 星期
 */
+ (NSString *)weekDayFromDateString:(NSString *)dateString;


/**
 *  时间戳转为时间 年月日
 *  @param timeStamp 时间戳
 *  formatter 时间格式
 *  @return 星期
 */
+ (NSString *)dateFromTimestamp:(NSString *)timeStamp;

/**
 *  时间转为年月日
 *  @param date 时间
 *  format 时间格式
 *  @return 年月日
 */
+ (NSString *)dateString:(NSDate*)date format:(NSString *)format;


/**
 *  时间戳转为时间 年月日 时分秒
 *  @param timeStamp 时间戳
 *  formatter 时间格式
 *  @return 星期
 */
+ (NSString *)dateFromTimestampHHmmss:(NSString *)timeStamp;


/**
 *  时间差
 *  @param date 时间
 *  @param otherDate 被比对时间
 *  @return 时间差（秒）
 */
+ (NSInteger)compareTimeDifferenceDate:(NSDate *)date otherDate:(NSDate *)otherDate;


/**
 *  比较两个日期的大小
 *  @param aDate 比较时间
 *  @param bDate 被比较时间
 *  @return a时间是否大于b时间
 */
+ (BOOL)compareDate:(NSString*)aDate withDate:(NSString*)bDate;

@end
