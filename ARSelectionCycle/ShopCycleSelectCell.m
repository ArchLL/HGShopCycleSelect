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
 //NSDictionary *dic = @{@"cycleNum":@(_cycleNum), @"startDate":_startDate, @"endDate":_endDate, @"startTime":_startTime, @"endTime":_endTime};
    if (kDictIsEmpty(dic)) {
        _userCycleDetail.text = @"请选择使用周期";
        _startTimeDetail.text = @"送货当天需本人签收，请妥善安排收货时间；";
        _endTimeDetail.text = @"还货当天需本人归还，请妥善安排还货时间；";
        //改变title的字体大小和颜色
        _userCycleTitle.textColor = HexRGB(0x3E3E3E);
        _userCycleTitle.font = [UIFont systemFontOfSize:13];
        _startTimeTitle.textColor = HexRGB(0x3E3E3E);
        _startTimeTitle.font = [UIFont systemFontOfSize:13];
        _endTimeTitle.textColor = HexRGB(0x3E3E3E);
        _endTimeTitle.font = [UIFont systemFontOfSize:13];
        
        _userCycleDetail.textColor = HexRGB(0xAFAFAF);
        _userCycleDetail.font = [UIFont systemFontOfSize:10];
        _startTimeDetail.textColor = HexRGB(0xAFAFAF);
        _startTimeDetail.font = [UIFont systemFontOfSize:10];
        _endTimeDetail.textColor = HexRGB(0xAFAFAF);
        _endTimeDetail.font = [UIFont systemFontOfSize:10];
        return;
    }
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
    
    NSString  *startDateStr;     //发货日期
    NSString  *userStartDate; //N+1  使用周期开始时间
    
    if ([dic[@"startDate"] isEqualToString:@"quick"]) {
        //获取送货时间
        NSString *startTime = [dic[@"startTime"]  componentsSeparatedByString:@"_"][0];
        startDateStr = [startTime componentsSeparatedByString:@" "][0]; //年-月-日
        NSDate *startTimeDate = [ShopTimeSelectTool getDateWithString:startTime];
        userStartDate = [ShopTimeSelectTool updateDateWithDate:startTimeDate Interval:1*24*60*60 IsAdd:YES];
    }else {
        startDateStr = dic[@"startDate"];
        NSDate *startDate = [ShopTimeSelectTool getSimpleDateWithString:startDateStr];
        userStartDate = [ShopTimeSelectTool updateDateWithDate:startDate Interval:1*24*60*60 IsAdd:YES];
    }
    
    //使用周期展示
    NSInteger days = [dic[@"days"] integerValue];
    NSString *timeStr = [NSString stringWithFormat:@"%@至%@ (共%ld日)", userStartDate, dic[@"endDate"], days];
    NSMutableAttributedString *timeAttriStr = [[NSMutableAttributedString alloc] initWithString:timeStr];
    NSString *strDays = [NSString stringWithFormat:@"(共%ld日)",days];
    [timeAttriStr addAttribute:NSForegroundColorAttributeName value:HexRGB(0xC0336C) range:[timeStr rangeOfString:strDays]];
    _userCycleDetail.attributedText = timeAttriStr;
    
    //送货时间
    if ([dic[@"startDate"] isEqualToString:@"quick"]) {
        //获取送货时间
        NSMutableAttributedString *attriStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", startDateStr, @"(三小时极速达)"]];
        [attriStr2 setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(attriStr2.length - 8, 8)];
        _startTimeDetail.attributedText = attriStr2;
    }else {
        NSMutableAttributedString *attriStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)", dic[@"startDate"] ? : @"", dic[@"startTime"] ? : @""]];
        [attriStr2 setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(attriStr2.length - 13, 13)];
        _startTimeDetail.attributedText = attriStr2;
    }
    
    //还货时间
    NSMutableAttributedString *attriStr3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)", dic[@"endDate"] ? : @"", dic[@"endTime"] ? : @""]];
    [attriStr3 setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(attriStr3.length - 13, 13)];
    _endTimeDetail.attributedText = attriStr3;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
