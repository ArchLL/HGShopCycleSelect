//
//  HGShopCycleSelectHeaderView.m
//  HGShopCycleSelect
//
//  Created by Arch on 2018/3/20.
//  Copyright © 2018年 Arch. All rights reserved.
//

#import "HGShopCycleSelectHeaderView.h"
#import "HGShopTimeSelectTool.h"

@interface HGShopCycleSelectHeaderView()
@property (nonatomic) NSInteger cycleNum; // 初始周期数
@property (nonatomic) NSInteger cycleDays; // 每个周期天数
@property (nonatomic, copy) NSString *price; // 单价
@property (nonatomic, strong) UILabel *cycleNumLB; // 显示周期数
@property (nonatomic, strong) UILabel *userCostLB; // 使用费
@property (nonatomic, copy) NSDate *networkDate; // 当前时间
@property (nonatomic, copy) NSDate *currentDate; // 当前时间
@property (nonatomic, copy) NSString *endDate; // 结束日期 年-月-日

@end

@implementation HGShopCycleSelectHeaderView

- (instancetype)initWithFrame:(CGRect)frame CycleNum:(NSInteger)cycleNum CycleDays:(NSInteger)cycleDays NetworkDate:(NSDate *)networkDate Price:(NSString *)price {
    self = [super initWithFrame:frame];
    if (self) {
        self.price = price;
        self.cycleNum = cycleNum;
        self.cycleDays = cycleDays;
        self.networkDate = networkDate;
        [self addContentView];
    }
    return self;
}

#pragma mark -- 加载视图
- (void)addContentView {
    self.backgroundColor = HexRGB(0xf4f3f3);
    //周期视图
    UIView *renewCycleView = [[UIView alloc] init];
    renewCycleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:renewCycleView];
    [renewCycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 185));
    }];
    
    //标题左边image
    UIImageView *leftHeaderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"使用周期"]];
    leftHeaderImageView.contentMode = UIViewContentModeScaleAspectFit;
    [renewCycleView addSubview:leftHeaderImageView];
    [leftHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    //标题
    UILabel *renewCycleLab = [[UILabel alloc] init];
    renewCycleLab.textColor = [UIColor blackColor];
    renewCycleLab.font = NFont(13);
    NSMutableAttributedString *renewCycleAttributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"选择使用周期 (7日为一个使用周期)"]];
    [renewCycleAttributedStr setAttributes:@{NSFontAttributeName:NFont(12),NSForegroundColorAttributeName:HexRGB(0x999999)}range:NSMakeRange(7, 11)];
    renewCycleLab.attributedText = renewCycleAttributedStr;
    [renewCycleView addSubview:renewCycleLab];
    [renewCycleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftHeaderImageView.mas_right).offset(5);
        make.centerY.equalTo(leftHeaderImageView);
    }];
    
    //分割线
    UIView *topline = [[UIView alloc] init];
    topline.backgroundColor = HexRGB(0xdedede);
    [renewCycleView addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(renewCycleLab.mas_bottom).offset(15);
        make.height.mas_equalTo(0.5);
    }];
    
    //减
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btnJian_selected"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [renewCycleView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.equalTo(topline.mas_bottom).offset(15);
        make.width.height.offset(57);
    }];
    
    //周期数
    self.cycleNumLB = [[UILabel alloc] init];
    if (!self.cycleNum) {
        self.cycleNum = 1;
    }
    self.cycleNumLB.textColor = HexRGB(0xC0336C);
    self.cycleNumLB.textAlignment = NSTextAlignmentCenter;
    [self changeCycleShow];
    [renewCycleView addSubview:self.cycleNumLB];
    [self.cycleNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(renewCycleView);
        make.centerY.equalTo(leftBtn);
        make.height.mas_equalTo(57);
    }];
    
    //加
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btnJia_selected"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [renewCycleView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.top.equalTo(leftBtn.mas_top);
        make.width.height.offset(57);
    }];
    
    //分割线
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = HexRGB(0xdedede);
    [renewCycleView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(leftBtn.mas_bottom).offset(15);
        make.height.mas_equalTo(0.5);
    }];
    
    //使用费
    UILabel *priceTitle = [[UILabel alloc] init];
    priceTitle.text = @"使用费";
    priceTitle.font = NFont(13);
    [renewCycleView addSubview:priceTitle];
    [priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(bottomLine.mas_bottom).offset(15);
    }];
    
    //总价
    self.userCostLB = [[UILabel alloc] init];
    self.userCostLB.text = [NSString stringWithFormat:@"¥%.2f", self.price.floatValue * self.cycleNum];
    self.userCostLB.font = NFont(13);
    self.userCostLB.textAlignment = NSTextAlignmentRight;
    [renewCycleView addSubview:self.userCostLB];
    [self.userCostLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceTitle);
        make.right.mas_equalTo(-15);
    }];
}

#pragma mark -- btn action
- (void)leftBtnAction:(UIButton *)btn {
    if (self.cycleNum == 1) {
        return;
    }
    self.cycleNum--;
    [self changeCycleShow];
}

- (void)rightBtnAction:(UIButton *)btn {
    self.cycleNum++;
    [self changeCycleShow];
}


#pragma mark - 数据更新
//更新上方周期、使用周期、使用费
- (void)changeCycleShow {
    [self updateTopCycleShow];
    [self updateUserCost];
    //还货时间
    self.endDate = [HGShopTimeSelectTool updateDateWithDate:self.networkDate Interval:self.cycleNum * self.cycleDays * 24 * 60 * 60 IsAdd:YES];
    //回调，更改其他View的时间显示
    if (self.cycleSelectBlock) {
        self.cycleSelectBlock(self.endDate, self.cycleNum, self.userCostLB.text);
    }
}

//更新上方周期显示
- (void)updateTopCycleShow {
    NSInteger days = self.cycleNum * self.cycleDays;
    //加减号中间的周期显示
    NSMutableAttributedString *cycleNumAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld周 (%ld日)", self.cycleNum, days]];
    [cycleNumAttriStr setAttributes:@{NSFontAttributeName:NFont(40),NSForegroundColorAttributeName:HexRGB(0xC0336C)}range:NSMakeRange(0, @(self.cycleNum).stringValue.length)];
    [cycleNumAttriStr setAttributes:@{NSFontAttributeName:NFont(25),NSForegroundColorAttributeName:HexRGB(0xC0336C)}range:NSMakeRange(@(self.cycleNum).stringValue.length, 1)];
    [cycleNumAttriStr setAttributes:@{NSFontAttributeName:NFont(12),NSForegroundColorAttributeName:[UIColor blackColor]}range:NSMakeRange(@(self.cycleNum).stringValue.length + 2, @(days).stringValue.length + 3)];
    
    //文字底部对齐
    [cycleNumAttriStr addAttribute:NSBaselineOffsetAttributeName value:@(-2) range:NSMakeRange(0, @(self.cycleNum).stringValue.length)];
    [cycleNumAttriStr addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(@(self.cycleNum).stringValue.length, 1)];
    [cycleNumAttriStr addAttribute:NSBaselineOffsetAttributeName value:@(-0.5) range:NSMakeRange(@(self.cycleNum).stringValue.length + 2, @(days).stringValue.length + 3)];
    
    self.cycleNumLB.attributedText = cycleNumAttriStr;
}

//更新使用费
- (void)updateUserCost {
    self.userCostLB.text = [NSString stringWithFormat:@"¥%ld", self.price.integerValue * self.cycleNum];
}

@end
