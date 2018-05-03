//
//  ShopCycleSelectVC.h
//  VensAppiOS
//
//  Created by UIDesigner on 2018/3/19.
//  Copyright © 2018年 iOS Coder. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma 上海的周期选择
@interface ShopCycleSelectVC : XXBaseViewController

@property (nonatomic,   copy) NSString     *price;
@property (nonatomic, assign) NSInteger    cycleDays;    // 每个周期天数
@property (nonatomic, assign) NSInteger    days;         // 租赁天数
@property (nonatomic,   copy) NSDictionary *dataDic;     // 上一次日期选择
@property (nonatomic,   copy) NSString     *cityCode;    //是哪个城市
//确定按钮回调
@property (nonatomic,   copy) void (^userCycleSelectBlock)(NSDictionary *dic);

@end
