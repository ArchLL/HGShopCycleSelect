//
//  HGShopCycleSelectCell.h
//  HGShopCycleSelect
//
//  Created by Arch on 2018/3/28.
//  Copyright © 2018年 Arch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGShopCycleSelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userCycleDetail;
@property (weak, nonatomic) IBOutlet UILabel *startTimeDetail;
@property (weak, nonatomic) IBOutlet UILabel *endTimeDetail;

- (void)updateDataWithDic:(NSDictionary *)dic;

@end
