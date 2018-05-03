//
//  ShopCycleSelectHeaderView.m
//  VensAppiOS
//
//  Created by UIDesigner on 2018/3/20.
//  Copyright © 2018年 iOS Coder. All rights reserved.
//

#import "ShopCycleSelectHeaderView.h"
#import "ShopTimeSelectTool.h"

@interface ShopCycleSelectHeaderView()

@property (nonatomic, assign) NSInteger   cycleNum;    // 初始周期数
@property (nonatomic, assign) NSInteger   cycleDays;   // 每个周期天数
@property (nonatomic,   copy) NSString  * price;       // 单价
@property (nonatomic, strong) UILabel   * cycleNumLB;  // 显示周期数
@property (nonatomic, strong) UILabel   * timeLB;      // 租赁时间(使用周期)
@property (nonatomic, strong) UILabel   * userCostLB;  // 使用费
@property (nonatomic,   copy) NSDate    * networkDate; // 当前时间
@property (nonatomic,   copy) NSDate    * currentDate; // 当前时间
@property (nonatomic,   copy) NSString  * endDate;     // 结束日期 年-月-日

@end

@implementation ShopCycleSelectHeaderView

- (instancetype)initWithFrame:(CGRect)frame CycleNum:(NSInteger)cycleNum CycleDays:(NSInteger)cycleDays NetworkDate:(NSDate *)networkDate Price:(NSString *)price {
    self = [super initWithFrame:frame];
    if (self) {
        _price = price;
        _cycleNum = cycleNum;
        _cycleDays = cycleDays;
        _networkDate = networkDate;
        [self addContentView];
    }
    return self;
}

#pragma mark -- 加载视图
- (void)addContentView {
    self.backgroundColor = HexRGB(0xf4f3f3);
    //续住周期视图
    UIView *renewCycleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185)];
    renewCycleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:renewCycleView];
    
    //标题左边image
    UIImageView *oneHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 16, 16)];
    oneHeaderImageView.contentMode = UIViewContentModeScaleAspectFit;
    oneHeaderImageView.image = [UIImage imageNamed:@"使用周期"];
    [renewCycleView addSubview:oneHeaderImageView];
    
    //标题
    UILabel *renewCycleLab = [[UILabel alloc] init];
    renewCycleLab.textColor = [UIColor blackColor];
    renewCycleLab.font = NFont(13);
    NSMutableAttributedString *renewCycleAttributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"选择使用周期 (7日为一个使用周期)"]];
    [renewCycleAttributedStr setAttributes:@{NSFontAttributeName:NFont(12),NSForegroundColorAttributeName:HexRGB(0x999999)}range:NSMakeRange(7, 11)];
    renewCycleLab.attributedText = renewCycleAttributedStr;
    [renewCycleView addSubview:renewCycleLab];
    [renewCycleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneHeaderImageView.mas_right).offset(5);
        make.centerY.equalTo(oneHeaderImageView);
        make.height.offset(20);
    }];
    
    //分割线
    UIView *topline = [[UIView alloc] init];
    topline.backgroundColor = HexRGB(0xdedede);
    [renewCycleView addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(renewCycleLab.mas_bottom).offset(15);
        make.height.offset(0.5);
    }];
    
    //减
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btnJian_selected"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [renewCycleView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50);
        make.top.equalTo(topline.mas_bottom).offset(15);
        make.width.height.offset(57);
    }];
    
    //周期数
    self.cycleNumLB = [[UILabel alloc] init];
    if (!_cycleNum) {
        _cycleNum = 1;
    }
    _cycleNumLB.textColor = HexRGB(0xC0336C);
    _cycleNumLB.textAlignment = NSTextAlignmentCenter;
    [self changeCycleShow];
    [renewCycleView addSubview:_cycleNumLB];
    [_cycleNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(renewCycleView);
        make.centerY.equalTo(leftBtn);
        make.width.offset(SCREEN_WIDTH - 230);
        make.height.offset(57);
    }];
    
    //加
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btnJia_selected"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [renewCycleView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-50);
        make.top.equalTo(leftBtn.mas_top);
        make.width.height.offset(57);
    }];
    
    //分割线
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = HexRGB(0xdedede);
    [renewCycleView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(leftBtn.mas_bottom).offset(15);
        make.height.offset(0.5);
    }];
    
    UILabel *rentTitle = [[UILabel alloc] init];
    rentTitle.text = @"使用周期";
    rentTitle.font = NFont(13);
    [renewCycleView addSubview:rentTitle];
    [rentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(bottomLine.mas_bottom).offset(10);
        make.height.offset(0);
        make.width.offset(80);
    }];
    
    //租赁时间
    self.timeLB = [[UILabel alloc] init];
    _timeLB.font = NFont(13);
    _timeLB.textAlignment = NSTextAlignmentRight;
    [renewCycleView addSubview:_timeLB];
    [_timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(rentTitle);
        make.height.equalTo(rentTitle);
    }];
    
    //使用费
    UILabel *priceTitle = [[UILabel alloc] init];
    priceTitle.text = @"使用费";
    priceTitle.font = NFont(13);
    [self addSubview:priceTitle];
    [priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(rentTitle.mas_bottom).offset(5);
        make.width.offset(50);
        make.height.offset(25);
    }];
    
    //总价
    self.userCostLB = [[UILabel alloc] init];
    _userCostLB.text = [NSString stringWithFormat:@"¥%.2f", _price.floatValue * _cycleNum];
    _userCostLB.font = NFont(13);
    _userCostLB.textAlignment = NSTextAlignmentRight;
    [self addSubview:_userCostLB];
    [_userCostLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceTitle);
        make.right.offset(-15);
        make.height.equalTo(_userCostLB);
        make.width.offset(100);
    }];
}

#pragma mark -- btn action
- (void)leftBtnAction:(UIButton *)btn {
    if (self.cycleNum == 1) {
        return;
    }
    _cycleNum--;
    [self changeCycleShow];
}

- (void)rightBtnAction:(UIButton *)btn {
    _cycleNum++;
    [self changeCycleShow];
}


#pragma mark - 数据更新
//更新上方周期、使用周期、使用费
- (void)changeCycleShow {
    [self updateTopCycleShow];
    [self updateUserCost];
    //还货时间
    _endDate = [ShopTimeSelectTool updateDateWithDate:_networkDate Interval:_cycleNum*_cycleDays*24*60*60 IsAdd:YES];
    //回调，更改其他View的时间显示
    if (self.cycleSelectBlock) {
        self.cycleSelectBlock(_endDate, _cycleNum, _userCostLB.text);
    }
}

//更新上方周期显示
- (void)updateTopCycleShow {
    NSInteger days = _cycleNum * _cycleDays;
    //加减号中间的周期显示
    NSMutableAttributedString *cycleNumAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld周 (%ld日)", _cycleNum, days]];
    [cycleNumAttriStr setAttributes:@{NSFontAttributeName:NFont(40),NSForegroundColorAttributeName:HexRGB(0xC0336C)}range:NSMakeRange(0, @(_cycleNum).stringValue.length)];
    [cycleNumAttriStr setAttributes:@{NSFontAttributeName:NFont(25),NSForegroundColorAttributeName:HexRGB(0xC0336C)}range:NSMakeRange(@(_cycleNum).stringValue.length, 1)];
    [cycleNumAttriStr setAttributes:@{NSFontAttributeName:NFont(12),NSForegroundColorAttributeName:[UIColor blackColor]}range:NSMakeRange(@(_cycleNum).stringValue.length + 2, @(days).stringValue.length + 3)];
    
    //文字底部对齐
    [cycleNumAttriStr addAttribute:NSBaselineOffsetAttributeName value:@(-2) range:NSMakeRange(0, @(_cycleNum).stringValue.length)];
    [cycleNumAttriStr addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(@(_cycleNum).stringValue.length, 1)];
    [cycleNumAttriStr addAttribute:NSBaselineOffsetAttributeName value:@(-0.5) range:NSMakeRange(@(_cycleNum).stringValue.length + 2, @(days).stringValue.length + 3)];
    
    _cycleNumLB.attributedText = cycleNumAttriStr;
}

//更新使用费
- (void)updateUserCost {
    _userCostLB.text = [NSString stringWithFormat:@"¥%ld", _price.integerValue * _cycleNum];
}

@end
