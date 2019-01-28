//
//  ShopCycleSelectCell.m
//  HGShopCycleSelect
//
//  Created by Arch on 2018/3/28.
//  Copyright © 2018年 Arch. All rights reserved.
//

#import "HGShopCycleSelectCell.h"
#import "HGShopTimeSelectTool.h"

@interface HGShopCycleSelectCell()
//title
@property (weak, nonatomic) IBOutlet UILabel *userCycleTitle;
@property (weak, nonatomic) IBOutlet UILabel *startTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *endTimeTitle;

@end

@implementation HGShopCycleSelectCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

//赋值
- (void)updateDataWithDic:(NSDictionary *)dic {
 //NSDictionary *dic = @{@"cycleNum": @(self.cycleNum), @"startDate": self.startDate, @"endDate": self.endDate, @"startTime": self.startTime, @"endTime": self.endTime};
    if (kDictIsEmpty(dic)) {
        self.userCycleDetail.text = @"请选择使用周期";
        self.startTimeDetail.text = @"送货当天需本人签收，请妥善安排收货时间；";
        self.endTimeDetail.text = @"还货当天需本人归还，请妥善安排还货时间；";
        //改变title的字体大小和颜色
        self.userCycleTitle.textColor = HexRGB(0x3E3E3E);
        self.userCycleTitle.font = [UIFont systemFontOfSize:13];
        self.startTimeTitle.textColor = HexRGB(0x3E3E3E);
        self.startTimeTitle.font = [UIFont systemFontOfSize:13];
        self.endTimeTitle.textColor = HexRGB(0x3E3E3E);
        self.endTimeTitle.font = [UIFont systemFontOfSize:13];
        
        self.userCycleDetail.textColor = HexRGB(0xAFAFAF);
        self.userCycleDetail.font = [UIFont systemFontOfSize:10];
        self.startTimeDetail.textColor = HexRGB(0xAFAFAF);
        self.startTimeDetail.font = [UIFont systemFontOfSize:10];
        self.endTimeDetail.textColor = HexRGB(0xAFAFAF);
        self.endTimeDetail.font = [UIFont systemFontOfSize:10];
        return;
    }
     //改变title的字体大小和颜色
    self.userCycleTitle.textColor = HexRGB(0x999999);
    self.userCycleTitle.font = [UIFont systemFontOfSize:10];
    self.startTimeTitle.textColor = HexRGB(0x999999);
    self.startTimeTitle.font = [UIFont systemFontOfSize:10];
    self.endTimeTitle.textColor = HexRGB(0x999999);
    self.endTimeTitle.font = [UIFont systemFontOfSize:10];
    
    self.userCycleDetail.textColor = HexRGB(0x434343);
    self.userCycleDetail.font = [UIFont systemFontOfSize:13];
    self.startTimeDetail.textColor = HexRGB(0x434343);
    self.startTimeDetail.font = [UIFont systemFontOfSize:13];
    self.endTimeDetail.textColor = HexRGB(0x434343);
    self.endTimeDetail.font = [UIFont systemFontOfSize:13];
    
    NSString *startDateStr; //发货日期
    NSString *userStartDate; //N+1 使用周期开始时间
    
    if ([dic[@"startDate"] isEqualToString:@"quick"]) {
        //获取送货时间
        NSString *startTime = [dic[@"startTime"]  componentsSeparatedByString:@"_"][0];
        startDateStr = [startTime componentsSeparatedByString:@" "][0]; //年-月-日
        NSDate *startTimeDate = [HGShopTimeSelectTool getDateWithString:startTime];
        userStartDate = [HGShopTimeSelectTool updateDateWithDate:startTimeDate Interval:1 * 24 * 60 * 60 IsAdd:YES];
    }else {
        startDateStr = dic[@"startDate"];
        NSDate *startDate = [HGShopTimeSelectTool getSimpleDateWithString:startDateStr];
        userStartDate = [HGShopTimeSelectTool updateDateWithDate:startDate Interval:1 * 24 * 60 * 60 IsAdd:YES];
    }
    
    //使用周期展示
    NSInteger days = [dic[@"days"] integerValue];
    NSString *timeStr = [NSString stringWithFormat:@"%@至%@ (共%ld日)", userStartDate, dic[@"endDate"], days];
    NSMutableAttributedString *timeAttriStr = [[NSMutableAttributedString alloc] initWithString:timeStr];
    NSString *strDays = [NSString stringWithFormat:@"(共%ld日)",days];
    [timeAttriStr addAttribute:NSForegroundColorAttributeName value:HexRGB(0xC0336C) range:[timeStr rangeOfString:strDays]];
    self.userCycleDetail.attributedText = timeAttriStr;
    
    //送货时间
    if ([dic[@"startDate"] isEqualToString:@"quick"]) {
        //获取送货时间
        NSMutableAttributedString *attriStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", startDateStr, @"(三小时极速达)"]];
        [attriStr2 setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(attriStr2.length - 8, 8)];
        self.startTimeDetail.attributedText = attriStr2;
    }else {
        NSMutableAttributedString *attriStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)", dic[@"startDate"] ? : @"", dic[@"startTime"] ? : @""]];
        [attriStr2 setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(attriStr2.length - 13, 13)];
        self.startTimeDetail.attributedText = attriStr2;
    }
    
    //还货时间
    NSMutableAttributedString *attriStr3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)", dic[@"endDate"] ? : @"", dic[@"endTime"] ? : @""]];
    [attriStr3 setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(attriStr3.length - 13, 13)];
    self.endTimeDetail.attributedText = attriStr3;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
