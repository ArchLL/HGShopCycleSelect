//
//  HGShopCycleSelectViewController.h
//  HGShopCycleSelect
//
//  Created by Arch on 2018/3/19.
//  Copyright © 2018年 Arch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGShopCycleSelectViewController : UIViewController
@property (nonatomic, copy) NSString *price;
@property (nonatomic) NSInteger cycleDays; // 每个周期天数
@property (nonatomic) NSInteger days; // 租赁天数
@property (nonatomic, copy) NSDictionary *dataDic; // 保存上一次日期选择
@property (nonatomic, copy) NSString *cityCode; // 城市
@property (nonatomic, copy) void (^userCycleSelectBlock)(NSDictionary *dic);

@end
