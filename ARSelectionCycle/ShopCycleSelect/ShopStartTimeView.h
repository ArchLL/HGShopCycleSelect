//
//  ShopstartTimeView.h
//  VensAppiOS
//
//  Created by UIDesigner on 2018/3/22.
//  Copyright © 2018年 iOS Coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopstartTimeView : UIView

@property (nonatomic,   copy) NSString   *endDate;  //使用周期的结束日期
@property (nonatomic, strong) NSTimer    *timer;    //定时器
@property (nonatomic, assign) NSInteger   days;     //租赁时长

@property (nonatomic, copy) void (^startDateSelectBlock) (NSString *startDate);  // 送货日期回调
@property (nonatomic, copy) void (^startTimeSelectBlock) (NSString *startTime);  // 送货时间回调 （送货时间段）
@property (nonatomic, copy) void (^endDateSelectBlock)   (NSString *endDate);    // 还货日期回调
@property (nonatomic, copy) void (^endTimeSelectBlock)   (NSString *endTime);    // 送货时间回调 （还货时间段）

/**
 初始化

 @param frame frame
 @param networkDate 当前时间
 @param days  租赁天数
 @param startDate 送货日期/开始日期
 @param endDate   结束日期
 @param startTime 送货时间段
 @param endTime   还货时间段
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame NetworkDate:(NSDate *)networkDate RentDays:(NSInteger)days StartDate:(NSString *)startDate StartTime:(NSString *)startTime EndDate:(NSString *)endDate EndTime:(NSString *)endTime;

//判断是否已选择送货时间和还货时间
- (BOOL)judgeWeatherSelectTime;

@end
