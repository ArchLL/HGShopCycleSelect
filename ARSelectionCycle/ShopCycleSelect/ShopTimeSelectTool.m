//
//  ShopTimeSelectTool.m
//  VensAppiOS
//
//  Created by UIDesigner on 2018/3/26.
//  Copyright © 2018年 iOS Coder. All rights reserved.
//

#import "ShopTimeSelectTool.h"

@implementation ShopTimeSelectTool

//获取当前时间 - 简单
+ (NSString *)getCurrentDate {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:currentDate];
    return dateStr;
}

//NSDate - > NSString 年-月-日
+ (NSString *)getSimpleStringWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

//NSDate - > NSString 年-月-日 时:分:秒
+ (NSString *)getDetailStringWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

//NSString - > Date 年-月-日 时:分:秒
+ (NSDate *)getDateWithString:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateStr];
    return date;
}

//NSString - > Date 年-月-日
+ (NSDate *)getSimpleDateWithString:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateStr];
    return date;
}

//根据时间间隔计算新的时间 年-月-日 字符串格式(年-月-日)
+ (NSString *)updateDateWithDateStr:(NSString *)dateStr Interval:(NSTimeInterval)interval IsAdd:(BOOL)isAdd {
    NSTimeInterval endTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval fromTime = [[formatter dateFromString:dateStr] timeIntervalSince1970];
    if (isAdd) {
        endTime = fromTime + interval;
    }else {
        endTime = fromTime - interval;
    }
    //时间戳转时间
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *endDateStr = [dateformatter stringFromDate:endDate];
    return endDateStr;
}

//根据时间间隔计算新的时间 年-月-日
+ (NSString *)updateDateWithDate:(NSDate *)date Interval:(NSTimeInterval)interval IsAdd:(BOOL)isAdd {
    NSTimeInterval endTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *fromDateStr = [formatter stringFromDate:date];
    NSTimeInterval fromTime = [[formatter dateFromString:fromDateStr] timeIntervalSince1970];
    if (isAdd) {
        endTime = fromTime + interval;
    }else {
        endTime = fromTime - interval;
    }
    //时间戳转时间
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *endDateStr = [dateformatter stringFromDate:endDate];
    return endDateStr;
}

//根据时间间隔计算新的时间 年-月-日 时:分:秒
+ (NSString *)updatePreciseDateWithDate:(NSDate *)date Interval:(NSTimeInterval)interval IsAdd:(BOOL)isAdd {
    NSTimeInterval endTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fromDateStr = [formatter stringFromDate:date];
    NSTimeInterval fromTime = [[formatter dateFromString:fromDateStr] timeIntervalSince1970];
    if (isAdd) {
        endTime = fromTime + interval;
    }else {
        endTime = fromTime - interval;
    }
    //时间戳转时间
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *endDateStr = [dateformatter stringFromDate:endDate];
    return endDateStr;
}

//比较两个时间差
+ (NSInteger )getTimeDifferenceWithFromDate:(NSString *)fromDate toDate:(NSString *)toDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval fromInterval = [[formatter dateFromString:fromDate] timeIntervalSince1970];
    NSTimeInterval endInterval = [[formatter dateFromString:toDate] timeIntervalSince1970];
    //返回天数
    return (NSInteger)(fromInterval - endInterval)/60/60/24;;
}

//获取网络时间
+ (void)getNetWorkDateSuccess:(void(^)(NSDate *networkDate, NSString *networkDateStr))success {
    NSString *urlString = @"https://www.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:5];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    __block NSDate *localDate;
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (!connectionError) {
            //要把网络数据强转 不然用不了下面那个方法获取不到内容（个人感觉，不知道对不）
            NSHTTPURLResponse *responsee = (NSHTTPURLResponse *)response;
            NSString *date = [[responsee allHeaderFields] objectForKey:@"Date"];
            date = [date substringFromIndex:5];
            date = [date substringToIndex:[date length]-4];
            NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
            dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
            //处理八小时问题-这里获取到的是标准时间
            NSDate *netDate = [dMatter dateFromString:date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSInteger interval = [zone secondsFromGMTForDate:netDate];
            NSLog(@"interval: %ld", interval);
            localDate = [netDate dateByAddingTimeInterval: interval];
            NSLog(@"%@________1",localDate);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSString *nowtimeStr = [NSString string];
            nowtimeStr = [formatter stringFromDate:localDate];
            NSLog(@"%@--------2",nowtimeStr);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(localDate, nowtimeStr);
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:@"网络异常，请稍后重试" toView:nil];
            });
        }
    }];
}

@end
