//
//  ShopCycleSelectCell.h
//  VensAppiOS
//
//  Created by UIDesigner on 2018/3/28.
//  Copyright © 2018年 iOS Coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCycleSelectCell : UITableViewCell

//Detail
@property (weak, nonatomic) IBOutlet UILabel *userCycleDetail;
@property (weak, nonatomic) IBOutlet UILabel *startTimeDetail;
@property (weak, nonatomic) IBOutlet UILabel *endTimeDetail;

//赋值
- (void)updateDataWithDic:(NSDictionary *)dic;

@end
