//
//  ShopCycleSelectCell.m
//  VensAppiOS
//
//  Created by UIDesigner on 2018/3/28.
//  Copyright © 2018年 iOS Coder. All rights reserved.
//

#import "ShopCycleSelectCell.h"
#import "ShopTimeSelectTool.h"

@interface ShopCycleSelectCell()
//title
@property (weak, nonatomic) IBOutlet UILabel *userCycleTitle;
@property (weak, nonatomic) IBOutlet UILabel *startTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *endTimeTitle;

@end

@implementation ShopCycleSelectCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

//赋值
- (void)updateDataWithDic:(NSDictionary *)dic {
 //NSDictionary *dic = @{@"userCycle":_userCycle, @"cycleNum":@(_cycleNum), @"startDate":_startDate, @"endDate":_endDate, @"startTime":_startTime, @"endTime":_endTime};
     //改变title的字体大小和颜色
    _userCycleTitle.textColor = HexRGB(0x999999);
    _userCycleTitle.font = [UIFont systemFontOfSize:10];
    _startTimeTitle.textColor = HexRGB(0x999999);
    _startTimeTitle.font = [UIFont systemFontOfSize:10];
    _endTimeTitle.textColor = HexRGB(0x999999);
    _endTimeTitle.font = [UIFont systemFontOfSize:10];
    
    _userCycleDetail.textColor = HexRGB(0x434343);
    _userCycleDetail.font = [UIFont systemFontOfSize:13];
    _startTimeDetail.textColor = HexRGB(0x434343);
    _startTimeDetail.font = [UIFont systemFontOfSize:13];
    _endTimeDetail.textColor = HexRGB(0x434343);
    _endTimeDetail.font = [UIFont systemFontOfSize:13];
    
    NSString  *startDate;     //发货日期
    NSString  *userStartDate; //N+1  使用周期开始时间
    
    if ([dic[@"startDate"] isEqualToString:@"quick"]) {
        //获取送货时间
        NSString *startTime = [dic[@"startTime"]  componentsSeparatedByString:@"_"][0];
        NSDate *startTimeDate = [ShopTimeSelectTool getDateWithString:startTime];
        startDate = [startTime componentsSeparatedByString:@" "][0];
        userStartDate = [ShopTimeSelectTool updateDateWithDate:startTimeDate Interval:1*24*60*60 IsAdd:YES];
    }else {
        startDate = dic[@"startDate"];
        userStartDate = [ShopTimeSelectTool updateDateWithDate:[ShopTimeSelectTool getDateWithString:[NSString stringWithFormat:@"%@ %@", startDate ,@"12:00:00"]] Interval:1*24*60*60 IsAdd:YES];
    }
    
    //使用周期展示[]
    NSInteger days = [dic[@"days"] integerValue];
    NSString *timeStr = [NSString stringWithFormat:@"%@至%@ (共%ld日)", userStartDate, dic[@"endDate"], days];
    NSMutableAttributedString *timeAttriStr = [[NSMutableAttributedString alloc] initWithString:timeStr];
    NSString *strDays = [NSString stringWithFormat:@"(共%ld日)",days];
     [timeAttriStr addAttribute:NSForegroundColorAttributeName value:HexRGB(0xc0336c) range:[timeStr rangeOfString:strDays]];
    _userCycleDetail.attributedText = timeAttriStr;
    
    //送货时间
    if ([dic[@"startDate"] isEqualToString:@"quick"]) {
        //获取送货时间
        NSMutableAttributedString *attriStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", startDate, @"(三小时极速达)"]];
        [attriStr2 setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(attriStr2.length - 8, 8)];
        _startTimeDetail.attributedText = attriStr2;
    }else {
        NSMutableAttributedString *attriStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)",dic[@"startDate"] ? : @"", dic[@"startTime"] ? : @""]];
        [attriStr2 setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(attriStr2.length - 13, 13)];
        _startTimeDetail.attributedText = attriStr2;
    }
    
    //还货时间
    NSMutableAttributedString *attriStr3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)",dic[@"endDate"] ? : @"", dic[@"endTime"] ? : @""]];
    [attriStr3 setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(attriStr3.length - 13, 13)];
    _endTimeDetail.attributedText = attriStr3;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
