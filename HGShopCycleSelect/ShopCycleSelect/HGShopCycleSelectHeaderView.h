//
//  HGShopCycleSelectHeaderView.h
//  HGShopCycleSelect
//
//  Created by Arch on 2018/3/20.
//  Copyright © 2018年 Arch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGShopCycleSelectHeaderView : UIView

@property (nonatomic, copy) void (^cycleSelectBlock)(NSString *endDate, NSInteger cycleNum ,NSString *payMoney);

/**
 初始化

 @param frame frame
 @param cycleNum  初始周期数
 @param cycleDays 每个周期天数
 @param networkDate 今日日期 年-月-日 时:分:秒
 @param price 单价
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame CycleNum:(NSInteger)cycleNum CycleDays:(NSInteger)cycleDays NetworkDate:(NSDate *)networkDate Price:(NSString *)price;

@end
