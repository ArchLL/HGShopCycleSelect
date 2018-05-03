//
//  ShopTimeSelectTool.h
//  VensAppiOS
//
//  Created by UIDesigner on 2018/3/26.
//  Copyright © 2018年 iOS Coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopTimeSelectTool : NSObject


//获取本地时间 - 年 月 日
+ (NSString *)getCurrentDate;

//NSDate - > NSString 年-月-日
+ (NSString *)getSimpleStringWithDate:(NSDate *)date;

//NSDate - > NSDate 年-月-日 时:分:秒
+ (NSString *)getDetailStringWithDate:(NSDate *)date;

//NSString - > Date 年-月-日 时:分:秒
+ (NSDate   *)getDateWithString:(NSString *)dateStr;

//NSString - > Date 年-月-日
+ (NSDate   *)getSimpleDateWithString:(NSString *)dateStr;

//根据时间间隔计算新的时间 年-月-日 字符串格式(年-月-日)
+ (NSString *)updateDateWithDateStr:(NSString *)dateStr Interval:(NSTimeInterval)interval IsAdd:(BOOL)isAdd;

//根据时间间隔计算新的时间 年-月-日
+ (NSString *)updateDateWithDate:(NSDate *)date Interval:(NSTimeInterval)interval IsAdd:(BOOL)isAdd;

//根据时间间隔计算新的时间 年-月-日 时:分:秒
+ (NSString *)updatePreciseDateWithDate:(NSDate *)date Interval:(NSTimeInterval)interval IsAdd:(BOOL)isAdd;

//比较两个时间差(fromDate-toDate)
+ (NSInteger)getTimeDifferenceWithFromDate:(NSString *)fromDate toDate:(NSString *)toDate;

//获取网络时间
+ (void)getNetWorkDateSuccess:(void(^)(NSDate *networkDate, NSString *networkDateStr))success;

@end
