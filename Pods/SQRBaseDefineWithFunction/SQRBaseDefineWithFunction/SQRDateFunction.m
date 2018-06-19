//
//  SQRDateFunction.m
//  SQRCommonToolsProject
//  日期获取及比对转换
//  Created by macMini on 2018/5/25.
//  Copyright © 2018年 PR. All rights reserved.
//

#import "SQRDateFunction.h"
#import "SQRCommonFunction.h"

@implementation SQRDateFunction

+ (NSString *)getCurrentDateString {
    
    NSString *string = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]*1000 + 0];
    NSString *dateString = [[string componentsSeparatedByString:@"."]objectAtIndex:0];
    return dateString;
}

+ (NSString *)getInternetDate
{
    NSString *urlString = @"http://m.baidu.com";
    
    //    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    // 实例化NSMutableURLRequest，并进行参数配置
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString: urlString]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [request setTimeoutInterval: 2];
    
    [request setHTTPShouldHandleCookies:FALSE];
    
    [request setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request
     
                          returningResponse:&response error:&error];
    
    // 处理返回的数据
    if (error) {
        return [self getCurrentDateString];
    }
    
    //推荐使用这种请求方法；
    //    NSURLSession *session = [NSURLSession sharedSession];
    //
    //    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //
    //        if (error) {
    //
    //        }
    //    }];
    
    //    [dataTask resume];
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    
    date = [date substringFromIndex:5];
    
    date = [date substringToIndex:[date length]-4];
    
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60 * 60 * 8];
    
    NSString *string = [NSString stringWithFormat:@"%f", [netDate timeIntervalSince1970] * 1000 + 1];
    
    NSString *dateString = [[string componentsSeparatedByString:@"."] objectAtIndex:0];
    
    return dateString;
}


+ (NSString *)compareCurrentTime:(NSString *)compareDate {
    if (compareDate.length == 0 || [compareDate isEqualToString:@""] || [compareDate isEqualToString:@"0"]) {
        return @"";
    }
    double unixTimeStamp = compareDate.length >= 13? [[compareDate substringToIndex:compareDate.length -3 ]  doubleValue]: [compareDate doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *_date=[_formatter stringFromDate:date];
    NSDate * newdate = [_formatter dateFromString:_date];
    //    ////NSLog(@"输入的时间%@",_date);
    NSTimeInterval  timeInterval = [newdate timeIntervalSinceNow];  //当前时间与获取时间的值
    
    timeInterval = -timeInterval;
    long temp = 0;
    
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    } else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    } else if((temp = temp/60) <=24 ){
        result =[self isToday:date]?[NSString stringWithFormat:@"%ld小时前",temp]:[self compareDate:compareDate];
    } else if((temp = temp/24 ) <30){
        result = [self compareDate:compareDate];
    } else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    } else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

+ (NSString *)compareDate:(NSString *)compareDate {
    double unixTimeStamp = compareDate.length >= 13? [[compareDate substringToIndex:compareDate.length -3 ]  doubleValue]: [compareDate doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *destDate = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate * localeDate = [date1  dateByAddingTimeInterval: interval];
    
    NSDateFormatter *_formatter1=[[NSDateFormatter alloc]init];
    [_formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *today =localeDate;
    
    NSDate *tomorrow, *yesterday,*qiantianDaty;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    qiantianDaty = [today dateByAddingTimeInterval:-2*secondsPerDay];
    
    
    
    NSString * todayString = [[_formatter1 stringFromDate:today] substringToIndex:10];
    
    NSString * dateString = [[_formatter1 stringFromDate:destDate] substringToIndex:10];//接收得时间
    
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"HH:mm"];
    
    if ([dateString isEqualToString:todayString]) {
        [_formatter setDateFormat:@"HH:mm"];
        NSString *_date=[_formatter stringFromDate:destDate];
        return _date;
    } else if ([[dateString substringToIndex:4] isEqualToString:[todayString substringToIndex:4]]) {
        [_formatter setDateFormat:@"MM/dd HH:mm"];
        NSString *_date=[_formatter stringFromDate:destDate];
        return _date;
    } else {
        [_formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *_date=[_formatter stringFromDate:destDate];
        return _date;
    }
    
}

+ (BOOL)isToday:(NSDate *)date {
    
    NSRange range;
    range.length = 10;
    range.location = 0;
    NSString *timeStr = [self getCurrentDateString];
    NSTimeInterval _interval=[timeStr.length >= 13 ? [timeStr substringToIndex:10]:timeStr doubleValue];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithName:@"UTC"];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setTimeZone:timeZone];
    NSString *dateNewString = [formatter stringFromDate:nowDate];
    NSString *dateOldString = [formatter stringFromDate:date];
    if ([[dateNewString substringWithRange:range] isEqualToString:[dateOldString substringWithRange:range]]) {
        return YES;
    }
    return NO;
    
}

+ (BOOL)isTodayWithString:(NSString *)dateString{
    double unixTimeStamp = dateString.length >= 13? [[dateString substringToIndex:dateString.length -3 ]  doubleValue]: [dateString doubleValue];
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:unixTimeStamp];
    
    format.dateFormat = @"yyyy-MM-dd";
    NSString *createDateString = [format stringFromDate:createDate];
    
    NSDate *now = [NSDate date];
    NSString *nowDate = [format stringFromDate:now];
    
    return [createDateString isEqualToString:nowDate];
}



+ (BOOL)isYersterday:(NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *now = [NSDate date];
    NSDate *date = [formatter dateFromString:dateString];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *createdDate = [formatter stringFromDate:date];
    NSString *nowDate = [formatter stringFromDate:now];
    date = [formatter dateFromString:createdDate];
    now = [formatter dateFromString:nowDate];
    NSCalendar * celendar = [NSCalendar currentCalendar];
    NSDateComponents * Components = [celendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now toDate:date options:0];
    return Components.month == 0 && Components.day == 1 && Components.year == 0;
}

+ (BOOL)isThisYear:(NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *now = [NSDate date];
    NSDate *date = [formatter dateFromString:dateString];
    
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:now];
    NSDateComponents *dateComps = [calendar components:unit fromDate:date];
    
    return nowCmps.year == dateComps.year;
    
}

+ (BOOL)isThisMonth:(NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *now = [NSDate date];
    NSDate *date = [formatter dateFromString:dateString];
    
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:now];
    NSDateComponents *dateComps = [calendar components:unit fromDate:date];
    
    return nowCmps.year == dateComps.year && nowCmps.month == dateComps.month;
    
}

+ (NSString *)year:(NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    formatter.dateFormat = @"yyyy";
    return [formatter stringFromDate:date];
}

+ (NSString *)month:(NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    formatter.dateFormat = @"MM月";
    return [formatter stringFromDate:date];
}

+ (NSInteger )dateNumber {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}

+ (NSString *)toDay {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}


+ (NSString *)yearAndMonthAndDay {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}

+ (NSString *)yearAndMonth{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}

+ (NSString *)monthAndDay:(NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    formatter.dateFormat = @"MM-dd";
    return [formatter stringFromDate:date];
}

+ (NSString *)hourAndMinute:(NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    formatter.dateFormat = @"HH:mm";
    return [formatter stringFromDate:date];
}

+ (NSString *)weekDayFromDateString:(NSString *)dateString{
    
    if ([SQRCommonFunction isBlankString:dateString]) {
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *currentComps = [[NSDateComponents alloc]init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:date];
    NSInteger week = [currentComps weekday];
    NSArray * arrWeek=[NSArray arrayWithObjects:@"周天",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    return [NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week - 1]];
}


+ (NSString *)dateFromTimestamp:(NSString *)timeStamp {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];;
    
    return confromTimespStr;
}



+ (NSString *)dateString:(NSDate*)date format:(NSString *)format {
    if (!format) {
        format = @"yyyy-MM-dd";
    }
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];//格式化
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}



+ (NSString *)dateFromTimestampHHmmss:(NSString *)timeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];;
    
    return confromTimespStr;
}

//时间差
+ (NSInteger)compareTimeDifferenceDate:(NSDate *)date otherDate:(NSDate *)otherDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:otherDate options:0];
    
    NSInteger totalSecond = [d hour]*3600+[d minute]*60+[d second];
    
    return totalSecond;
}



+ (BOOL)compareDate:(NSString*)aDate withDate:(NSString*)bDate {
    BOOL isBig = NO;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    
    if (result==NSOrderedSame){
        isBig = NO;     //相等
    }else if (result==NSOrderedAscending){
        isBig = NO;     //b大于a
    }else if (result==NSOrderedDescending){
        isBig = YES;    //a大于b
    }
    
    return isBig;
}


@end
