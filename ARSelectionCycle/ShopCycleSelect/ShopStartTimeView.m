//
//  ShopstartTimeView.m
//  VensAppiOS
//
//  Created by UIDesigner on 2018/3/22.
//  Copyright © 2018年 iOS Coder. All rights reserved.
//

#import "ShopStartTimeView.h"
#import "ShopTimeSelectTool.h"

@interface ShopstartTimeView ()

@property (nonatomic, strong) UIView    * startBgView;         // 选择送货时间背景
@property (nonatomic, strong) UIView    * endBgView;           // 选择还货时间背景
@property (nonatomic,   copy) NSString  * startDate;           // 使用周期的开始日期  年-月-日
@property (nonatomic,   copy) NSString  * startTime;           // 使用周期的送货时间段
@property (nonatomic,   copy) NSString  * endTime;             // 使用周期的还货时间段
@property (nonatomic, strong) UIButton  * startLastDateBtn;    // 记录上一次选中的送货日期按钮
@property (nonatomic, strong) UIButton  * startLastTimeBtn;    // 记录上一次选中的送货时间按钮
@property (nonatomic, strong) UIButton  * endLastTimeBtn;      // 记录上一次选中的还货时间按钮
@property (nonatomic,   copy) NSDate    * networkDate;         // 最新网络时间(更新) (年-月-日 时:分:秒)
@property (nonatomic,   copy) NSString  * networkDateStr;      // 最新网络时间(更新) (年-月-日 时:分:秒)
@property (nonatomic, strong) UIView    * startBottomTimeView; // 送货底部时间间隔背景
@property (nonatomic,   copy) NSArray   * startTimeArr;        // 送货时间数组
@property (nonatomic,   copy) NSString  * todayDateStr;        // 今日时间(年月日)
@property (nonatomic,   copy) NSString  * tomorrowDateStr;     // 明日日期(年月日)

@end

@implementation ShopstartTimeView

- (instancetype)initWithFrame:(CGRect)frame NetworkDate:(NSDate *)networkDate RentDays:(NSInteger)days StartDate:(NSString *)startDate StartTime:(NSString *)startTime EndDate:(NSString *)endDate EndTime:(NSString *)endTime {
    self = [super initWithFrame:frame];
    if (self) {
        _startDate = startDate;
        _startTime = startTime;
        _endDate = endDate;
        _endTime = endTime;
        _days = days;
        _networkDate = networkDate;
        _networkDateStr = [ShopTimeSelectTool getDetailStringWithDate:networkDate];
        _todayDateStr = [ShopTimeSelectTool getSimpleStringWithDate:networkDate];
        _tomorrowDateStr = [ShopTimeSelectTool updateDateWithDate:_networkDate Interval:1*24*60*60 IsAdd:YES];
        //送货
        [self creatContentViewWithIsStart:YES];
        //换货
        [self creatContentViewWithIsStart:NO];
    }
    return self;
}

- (void)creatContentViewWithIsStart:(BOOL)isStart {
    //送货背景视图
    UIView *startBgView = [[UIView alloc] init];
    startBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:startBgView];
    
    //标题左边image
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 16, 16)];
    headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    if (isStart) {
        headerImageView.image = [UIImage imageNamed:@"送货时间"];
    }else {
        headerImageView.image = [UIImage imageNamed:@"还货时间"];
    }
    [startBgView addSubview:headerImageView];
    
    //标题
    UILabel *titleLB = [[UILabel alloc] init];
    titleLB.textColor = [UIColor blackColor];
    titleLB.font = NFont(13);
    if (isStart)  {
        titleLB.text = @"选择送货时间";
    }else {
        titleLB.text = @"选择还货时间";
    }
    [startBgView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_right).offset(5);
        make.centerY.equalTo(headerImageView);
        make.height.offset(20);
        make.right.offset(-15);
    }];

    //分割线
    UIView *topline = [[UIView alloc] init];
    topline.backgroundColor = HexRGB(0xdedede);
    [startBgView addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(titleLB.mas_bottom).offset(15);
        make.height.offset(0.5);
    }];
    [self addSubview:startBgView];
    
    //年月日背景
    UIView *topDateView = [[UIView alloc] init];
    topDateView.backgroundColor = [UIColor whiteColor];
    [startBgView addSubview:topDateView];
    [topDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(70);
        make.top.equalTo(topline.mas_bottom).offset(10);
    }];
    //创建日期选择View
    for (int i = 0; i < 3; i++) {
        CGFloat width = New_UIWidth(110);
        CGFloat height = 60;
        CGFloat space = (SCREEN_WIDTH - width*3.0)/4.0;
        
        if (i > 0 && !isStart) {
            break;
        }
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*(width + space) + space, 10, width, height)];
        [btn.titleLabel setNumberOfLines:0];
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        btn.titleLabel.font = NFont(15);
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = [UIColor whiteColor];
        [topDateView addSubview:btn];
        
        //文本
        NSMutableAttributedString *attriStr;
        if (isStart) {
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(dateBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];

            if (i == 0) {
                attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n(今日)", _todayDateStr]];
                [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0x333333)} range:NSMakeRange(0, attriStr.length)];
                [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0x999999), NSFontAttributeName:NFont(12)} range:NSMakeRange(attriStr.length - 4, 4)];
            }else if (i == 1) {
                //获取明日日期
                attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n(明日)", _tomorrowDateStr]];
                [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0x333333)} range:NSMakeRange(0, attriStr.length)];
                [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0x999999),NSFontAttributeName:NFont(12)} range:NSMakeRange(attriStr.length - 4, 4)];
            }else {
                attriStr = [[NSMutableAttributedString alloc] initWithString:@"极速送达\n(四、六星卡专享)"];
                [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0x333333)} range:NSMakeRange(0, attriStr.length)];
                [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0x999999),NSFontAttributeName:NFont(12)} range:NSMakeRange(4, attriStr.length - 4)];
            };
            
            [btn setAttributedTitle:attriStr forState:(UIControlStateNormal)];
        }else {
            //文本
            btn.tag = 103;
            attriStr = [[NSMutableAttributedString alloc] initWithString:_endDate];
            [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(0, attriStr.length)];
            btn.backgroundColor = HexRGB(0xf5f5f5);
        }
        [btn setAttributedTitle:attriStr forState:(UIControlStateNormal)];
    }
    
    //下方时间间隔选择背景
    UIView *bottomTimeView = [[UIView alloc] init];
    bottomTimeView.backgroundColor = HexRGB(0xf5f5f5);
    [startBgView addSubview:bottomTimeView];
    
    //创建时间按钮
    NSArray *timeArr = [NSArray array];
    if (isStart) {
        //先判断缓存选择的送货日期
        UIButton *startDateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        NSMutableAttributedString * newAttriStr;
        if ([_startDate isEqualToString:_tomorrowDateStr]) {
            //缓存日期是明日
            //更新日期
            startDateBtn = [self viewWithTag:101];
            newAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n(明日)", _tomorrowDateStr]];
            [newAttriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(0, newAttriStr.length)];
            [newAttriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c), NSFontAttributeName:NFont(12)} range:NSMakeRange(newAttriStr.length - 4, 4)];
            startDateBtn.backgroundColor = HexRGB(0xf5f5f5);
            //时间段
            timeArr = @[@"10:00-12:00", @"12:00-14:00", @"14:00-16:00", @"16:00-18:00", @"18:00-20:00", @"20:00-22:00"];
        }else if ([_startDate isEqualToString:@"quick"]) {
            //缓存日期是极速达
            //更新日期
            startDateBtn = [self viewWithTag:102];
            newAttriStr = [[NSMutableAttributedString alloc] initWithString:@"极速送达\n(四、六星卡专享)"];
            [newAttriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(0, newAttriStr.length)];
            [newAttriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c),NSFontAttributeName:NFont(12)} range:NSMakeRange(4, newAttriStr.length - 4)];
            startDateBtn.backgroundColor = HexRGB(0xf5f5f5);
            //时间段
            timeArr = @[@"三小时极速达"];
        }else {
            //缓存日期是今日
            //更新日期
            startDateBtn = [self viewWithTag:100];
            newAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n(今日)", _todayDateStr]];
            [newAttriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(0, newAttriStr.length)];
            [newAttriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c), NSFontAttributeName:NFont(12)} range:NSMakeRange(newAttriStr.length - 4, 4)];
            startDateBtn.backgroundColor = HexRGB(0xf5f5f5);
            //时间段
            //时间判断
            if ([self isGreaterThanWithCurrentDate:_networkDate ToDate:@"7:00"]) {
                NSLog(@"7:00之后");
                timeArr = @[@"15:00-17:00", @"17:00-19:00", @"19:00-22:00"];
            }else {
                NSLog(@"7:00之前");
                //所有时间段都可选
                timeArr = @[@"10:00-12:00", @"12:00-14:00", @"14:00-16:00", @"16:00-18:00", @"18:00-20:00", @"20:00-22:00"];
            }
        }
        [startDateBtn setAttributedTitle:newAttriStr forState:(UIControlStateNormal)];
        
        
        //设置送货/还货背景的frame
        if (timeArr.count > 3) {
            startBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250);
        }else {
            startBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        }
        
        //设置bottomTimeViewframe
        if (timeArr.count > 3) {
            bottomTimeView.frame = CGRectMake(0, 125, SCREEN_WIDTH, 120);
        }else {
            bottomTimeView.frame = CGRectMake(0, 125, SCREEN_WIDTH, 70);
        }
        
        _startLastDateBtn = startDateBtn;
        _startTimeArr = timeArr;
        _startBgView = startBgView;
        _startBottomTimeView = bottomTimeView;
        [self createTimePartViewWithView:bottomTimeView TimeArr:timeArr IsStart:YES IsFrist:YES];
        
    }else {
        
        //设置送货/还货背景的frame
        if (_startTimeArr.count > 3) {
            startBgView.frame = CGRectMake(0, 250, SCREEN_WIDTH, 250);
        }else {
            startBgView.frame = CGRectMake(0, 200, SCREEN_WIDTH, 250);
        }
        _endBgView = startBgView;
        
        timeArr = @[@"10:00-12:00", @"12:00-14:00", @"14:00-16:00", @"16:00-18:00", @"18:00-20:00", @"20:00-22:00"];
        
        //设置bottomTimeViewframe
        if (timeArr.count > 3) {
            bottomTimeView.frame = CGRectMake(0, 125, SCREEN_WIDTH, 120);
        }else {
            bottomTimeView.frame = CGRectMake(0, 125, SCREEN_WIDTH, 70);
        }
        
        [self createTimePartViewWithView:bottomTimeView TimeArr:timeArr IsStart:NO IsFrist:YES];
    }
}

#pragma mark - 创建送货/还货时间段
/**
 创建送货/还货时间段/更新可选时间段

 @param view 背景View
 @param timeArr 时间间隔title
 @param isStart 是否是送货
 @param isfrist 是否是创建界面时的首次调用
 */
- (void)createTimePartViewWithView:(UIView *)view TimeArr:(NSArray *)timeArr IsStart:(BOOL)isStart IsFrist:(BOOL)isfrist {
    
    if (isStart && !isfrist) {
        //更换送货背景的Height
        CGRect frame1 = _startBgView.frame;
        if (timeArr.count > 3) {
            frame1.size.height = 250;
        }else {
            frame1.size.height = 200;
        }
        _startBgView.frame = frame1;
        
        //更改送货时间选择背景的Height
        CGRect frame2 = view.frame;
        if (timeArr.count > 3) {
            frame2.size.height = 120;
        }else {
            frame2.size.height = 70;
        }
        view.frame = frame2;
        
        //更改换货背景的Y值
        CGRect frame3 = _endBgView.frame;
        if (timeArr.count > 3) {
            frame3.origin.y = 250;
        }else {
            frame3.origin.y = 200;
        }
        _endBgView.frame = frame3;
    
    }
    
    //创建时间区间选择按钮
    for (int i = 0; i < timeArr.count; i++) {
        UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [timeBtn setTitle:timeArr[i] forState:(UIControlStateNormal)];
        timeBtn.titleLabel.font = NFont(13);
        [timeBtn setTitleColor:HexRGB(0x999999) forState:(UIControlStateNormal)];
        [timeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        
        CGFloat width = New_UIWidth(100);
        CGFloat height = 35;
        CGFloat space = (SCREEN_WIDTH - width*3.0)/4.0;
        if (i < 3) {
            timeBtn.frame = CGRectMake(i * (width + space) + space, 20, width, height);
        }else {
            timeBtn.frame = CGRectMake((i - 3) * (width + space) + space, 20 + height + 10, width, height);
        }
        timeBtn.layer.cornerRadius = 5;
        timeBtn.layer.masksToBounds = YES;
        [view addSubview:timeBtn];
        
        if (isStart) {
            //送货
            timeBtn.tag = 200 + i;
            if (isfrist && _startTime) {
                //首次设置初始状态(上个界面的缓存) , 注意对极速达做特殊处理
                if (_startTime == timeBtn.titleLabel.text || [_startTime containsString:@"_"]) {
                    timeBtn.backgroundColor = HexRGB(0xc42d6c);
                    [timeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    _startLastTimeBtn = timeBtn;
                }
            }
        }else {
            //还货
            timeBtn.tag = 200 + i + 6;
            if (_endTime) {
                //设置初始状态(上个界面的缓存)
                if (_endTime == timeBtn.titleLabel.text) {
                    timeBtn.backgroundColor = HexRGB(0xc42d6c);
                    [timeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    _endLastTimeBtn = timeBtn;
                }
            }
        }
        
        [timeBtn addTarget:self action:@selector(timeBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

#pragma mark - 点击的时候刷新送货时间段显示
- (void)refreshStartTimePart {
    //1.获取网络时间
    [ShopTimeSelectTool getNetWorkDateSuccess:^(NSDate *networkDate, NSString *networkDateStr) {
        //2.将_bottomTimeView上的时间间隔按钮移除
        [_startBottomTimeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _startLastTimeBtn = nil;
        //得到当前时间
        _networkDate = networkDate;
        _networkDateStr = networkDateStr;
        _todayDateStr = [ShopTimeSelectTool getSimpleStringWithDate:_networkDate];
        _tomorrowDateStr = [ShopTimeSelectTool updateDateWithDate:_networkDate Interval:24*60*60 IsAdd:YES];
        //判断时间
        NSArray *timeArr = [NSArray array];
        if (_startLastDateBtn.tag - 100 == 0) {
            //今日
            if ([self isGreaterThanWithCurrentDate:networkDate ToDate:@"7:00"]) {
                NSLog(@"7:00之后");
                timeArr = @[@"15:00-17:00", @"17:00-19:00", @"19:00-22:00"];
            }else {
                NSLog(@"7:00之前");
                //所有时间段都可选
                timeArr = @[@"10:00-12:00", @"12:00-14:00", @"14:00-16:00", @"16:00-18:00", @"18:00-20:00", @"20:00-22:00"];
            }
        }else if(_startLastDateBtn.tag - 100 == 1){
            //明日
            timeArr = @[@"10:00-12:00", @"12:00-14:00", @"14:00-16:00", @"16:00-18:00", @"18:00-20:00", @"20:00-22:00"];
        }else {
            //极速达
            timeArr = @[@"三小时极速达"];
        }
        _startTimeArr = timeArr;
        //更新送货时间间隔(重新添加按钮)
        [self createTimePartViewWithView:_startBottomTimeView TimeArr:timeArr IsStart:YES IsFrist:NO];
    }];
}

#pragma mark - 选择送货日期
- (void)dateBtnAction:(UIButton *)sender {
    //1.刷新送货时间段显示
    [self refreshStartTimePart];
    
    //2.更改上一个按钮的显示状态
    NSMutableAttributedString *attriStr;
    if (_startLastDateBtn) {
        _startLastDateBtn.backgroundColor = [UIColor whiteColor];
        switch (_startLastDateBtn.tag - 100) {
            case 0:
                //今日
            {
                attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n(今日)", _todayDateStr]];
                [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0x333333)} range:NSMakeRange(0, attriStr.length)];
                [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0x999999), NSFontAttributeName:NFont(12)} range:NSMakeRange(attriStr.length - 4, 4)];
            }
                break;
            case 1:
                //明日
            {
                attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n(明日)", _tomorrowDateStr]];
                [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0x333333)} range:NSMakeRange(0, attriStr.length)];
                [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0x999999),NSFontAttributeName:NFont(12)} range:NSMakeRange(attriStr.length - 4, 4)];
            }
                break;
            case 2:
                //极速送达
            {
                attriStr = [[NSMutableAttributedString alloc] initWithString:@"极速送达\n(四、六星卡专享)"];
                [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0x333333)} range:NSMakeRange(0, attriStr.length)];
                [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0x999999),NSFontAttributeName:NFont(12)} range:NSMakeRange(4, attriStr.length - 4)];
            }
                break;
            default:
                break;
        }
        [_startLastDateBtn setAttributedTitle:attriStr forState:(UIControlStateNormal)];
    }
    
    //3.更改当前点击的按钮状态
    sender.backgroundColor = HexRGB(0xf5f5f5);
    NSMutableAttributedString *newAttriStr;
    switch (sender.tag - 100) {
        case 0:
            //今日
        {
            newAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n(今日)", _todayDateStr]];
            [newAttriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(0, attriStr.length)];
            [newAttriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c), NSFontAttributeName:NFont(12)} range:NSMakeRange(newAttriStr.length - 4, 4)];
            NSArray *arr = [sender.titleLabel.text componentsSeparatedByString:@"\n"];
            
            //更新送货时间
            _startDate = arr[0];
            //更新还货时间
            [self updateReturnGoodsBtnTitleWithIsAdd:NO];
            
            //回调
            if (self.startDateSelectBlock) {
                self.startDateSelectBlock(_startDate);
            }
        }
            break;
        case 1:
            //明日
        {
            newAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n(明日)", _tomorrowDateStr]];
            [newAttriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(0, attriStr.length)];
            [newAttriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c), NSFontAttributeName:NFont(12)} range:NSMakeRange(newAttriStr.length - 4, 4)];
            NSArray *arr = [sender.titleLabel.text componentsSeparatedByString:@"\n"];
            
            //更新送货时间
            _startDate = arr[0];
            //更新还货时间
            [self updateReturnGoodsBtnTitleWithIsAdd:YES];
            
            //回调
            if (self.startDateSelectBlock) {
                self.startDateSelectBlock(_startDate);
            }
        }
            break;
        case 2:
            //极速送达
        {
            newAttriStr = [[NSMutableAttributedString alloc] initWithString:@"极速送达\n(四、六星卡专享)"];
            [newAttriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(0, newAttriStr.length)];
            [newAttriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c),NSFontAttributeName:NFont(12)} range:NSMakeRange(4, newAttriStr.length - 4)];
            
            //更新送货时间
            _startDate = [ShopTimeSelectTool getSimpleStringWithDate:_networkDate];
            //更新还货时间
            [self updateReturnGoodsBtnTitleWithIsAdd:NO];
            
            //回调
            if (self.startDateSelectBlock) {
                self.startDateSelectBlock(@"quick");
            }
        }
            break;
        default:
            break;
    }
    
    [sender setAttributedTitle:newAttriStr forState:(UIControlStateNormal)];
    
    //4.更新上一个点击按钮
    _startLastDateBtn = sender;
}

#pragma mark - 更新时间间隔按钮状态
/*
 tag  100-105 送货
      106-111 还货
 */
- (void)updateBtnStatus:(UIButton *)sender {
    NSInteger index = sender.tag - 200;
    if (index < 6) {
        //送货
        if (_startLastTimeBtn) {
            _startLastTimeBtn.backgroundColor = [UIColor clearColor];
            [_startLastTimeBtn setTitleColor:HexRGB(0x999999) forState:(UIControlStateNormal)];
        }
        sender.backgroundColor = HexRGB(0xc42d6c);
        [sender setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _startLastTimeBtn = sender;
        //回调
        if (self.startTimeSelectBlock) {
            //三小时极速达特殊处理 7:00-16:00
            if ([sender.titleLabel.text isEqualToString:@"三小时极速达"]) {
                //根据送货时间往后延长3个小时
                NSString *endTimeStr = [ShopTimeSelectTool updatePreciseDateWithDate:_networkDate Interval:3*60*60 IsAdd:YES];
                NSString *tempStr = [NSString stringWithFormat:@"%@_%@", _networkDateStr, endTimeStr];
                self.startTimeSelectBlock(tempStr);
            }else {
                self.startTimeSelectBlock(sender.titleLabel.text);
            }
        }
    }else {
        //还货
        if (_endLastTimeBtn) {
            _endLastTimeBtn.backgroundColor = [UIColor clearColor];
            [_endLastTimeBtn setTitleColor:HexRGB(0x999999) forState:(UIControlStateNormal)];
        }
        sender.backgroundColor = HexRGB(0xc42d6c);
        [sender setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _endLastTimeBtn = sender;
        //回调
        if (self.endTimeSelectBlock) {
            self.endTimeSelectBlock(sender.titleLabel.text);
        }
    }
}

#pragma mark - 时间间隔选择事件
- (void)timeBtnAction:(UIButton *)sender {
    NSString *fromTime;
    NSString *toTime;
    //1.获取时间间隔
    if (_startLastDateBtn.tag == 102) {
        //三小时极速达
        fromTime = @"7:00";
        toTime = @"16:00";
    }else {
        NSArray *arr = [NSArray array];
        arr = [sender.titleLabel.text componentsSeparatedByString:@"-"];
        fromTime = arr[0];
        toTime = arr[1];
    }
    //2.判断是送货还是还货
    if (sender.tag - 200 < 6) {
        //送货
        //如果送货时间是明日的时候不需要根据网络时间选择时间间隔
        if (_startLastDateBtn.tag == 101) {
            //明日
            [self updateBtnStatus:sender];
        }else {
            //获取网络时间
            [ShopTimeSelectTool getNetWorkDateSuccess:^(NSDate *networkDate, NSString *networkDateStr) {
                _networkDate = networkDate;
                _networkDateStr = networkDateStr;
                _todayDateStr = [ShopTimeSelectTool getSimpleStringWithDate:_networkDate];
                _tomorrowDateStr = [ShopTimeSelectTool updateDateWithDate:_networkDate Interval:24*60*60 IsAdd:YES];
                if (_startLastDateBtn.tag == 102) {
                    //极速达 7:00-16:00可选
                    //判断时间间隔是否可选
                    if ([self isOpenTimeWithFromDate:fromTime toDate:toTime]) {
                        [self updateBtnStatus:sender];
                    }else {
                        [MBProgressHUD showError:@"当日7:00-16:00可选" toView:nil];
                    }
                }else {
                    //今日
                    if ([self isGreaterThanWithCurrentDate:networkDate ToDate:@"7:00"]) {
                        //7点之后
                        if ([self isGreaterThanWithCurrentDate:networkDate ToDate:@"12:00"]) {
                            //12:00之后三个时间段不可选
                            //判断当前时间是不是16:00之前，如果是16:00之前，提醒去选择极速达
                            if ([self isGreaterThanWithCurrentDate:networkDate ToDate:@"16:00"]) {
                                //16:00之后
                                [MBProgressHUD showError:@"当前时间不可选，请选择明日送货" toView:nil];
                            }else {
                                //12:00-16:00
                                [MBProgressHUD showError:@"请选择三小时极速达/明日送货" toView:nil];
                            }
                        }else {
                            //12:00之前 三个时间段，时间段可选择
                            [self updateBtnStatus:sender];
                        }
                    }else {
                        //7点之前
                        [self updateBtnStatus:sender];
                    }
                }
            }];
        }
    }else {
        //还货
        [self updateBtnStatus:sender];
    }
}

#pragma mark - 更新还货时间 - 外界调用
- (void)setEndDate:(NSString *)endDate {
    _endDate = endDate;
    //获取换货Button
    UIButton *btn = [self viewWithTag:103];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:endDate];
    [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(0, attriStr.length)];
    [btn setAttributedTitle:attriStr forState:(UIControlStateNormal)];
    btn.backgroundColor = HexRGB(0xf5f5f5);
}

#pragma mark - 更新租赁时常
- (void)setDays:(NSInteger)days {
    _days = days;
}

/**
 更新还货按钮的title - 内部调用（选择送货日期的时候调用）

 @param isAdd 根据还货时间改变
 */
- (void)updateReturnGoodsBtnTitleWithIsAdd:(BOOL)isAdd {
    UIButton *returnGoodsBtn = [self viewWithTag:103];
    //获取送货时间和还货时间间隔
    //首轮周期时间(初始是7天)要根据送货时间而定
    //当前时间 年-月-日
    NSString *currentDate = [ShopTimeSelectTool getSimpleStringWithDate:_networkDate];
    //判断当前送货时间比当前时间多几天
    NSInteger intervalDays = [ShopTimeSelectTool getTimeDifferenceWithFromDate:_startDate toDate:currentDate];
    //获取最新租赁时长
    NSInteger newDays;
    if (isAdd) {
        newDays = _days + intervalDays;
    }else {
        newDays = _days - intervalDays;
    }
    //获取新的还货时间
    NSString *newEndDate = [ShopTimeSelectTool updateDateWithDateStr:currentDate Interval:newDays*24*60*60 IsAdd:YES];
    _endDate = newEndDate;
    
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:newEndDate];
    [attriStr setAttributes:@{NSForegroundColorAttributeName:HexRGB(0xc42d6c)} range:NSMakeRange(0, attriStr.length)];
    [returnGoodsBtn setAttributedTitle:attriStr forState:(UIControlStateNormal)];
    
    //回调
    if (self.endDateSelectBlock) {
        self.endDateSelectBlock(attriStr.string);
    }
}

#pragma mark - 判断当前时间是否在某一时间段
/**
 @param fromDate 开始时间  @“10:00”
 @param toDate 结束时间  @“15:00”
 @return 判断结果
 */
- (BOOL)isOpenTimeWithFromDate:(NSString *)fromDate toDate:(NSString *)toDate {
    //获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:_networkDate];
    //开始时间和结束时间
    NSString *fromDateStr = [NSString stringWithFormat:@"%@ %@", dateStr, fromDate];
    NSString *endDateStr = [NSString stringWithFormat:@"%@ %@", dateStr, toDate];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval fromTime = [[formatter dateFromString:fromDateStr] timeIntervalSince1970];
    NSTimeInterval endTime = [[formatter dateFromString:endDateStr] timeIntervalSince1970];
    NSTimeInterval currentTime = [_networkDate timeIntervalSince1970];
    if (currentTime > fromTime && currentTime < endTime) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - 判断当前时间是否处于某一时间之前
/**
 判断当前时间是否处于某一时间之前

 @param currentDate 当前时间
 @param toDate 比较时间
 @return 比较结果
 */
- (BOOL)isGreaterThanWithCurrentDate:(NSDate *)currentDate ToDate:(NSString *)toDate {
    //获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:currentDate];
    //开始时间和结束时间
    NSString *toDateStr = [NSString stringWithFormat:@"%@ %@", dateStr, toDate];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval toTime = [[formatter dateFromString:toDateStr] timeIntervalSince1970];
    NSTimeInterval currentTime = [currentDate timeIntervalSince1970];
    if (currentTime > toTime) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - 判断是否已选择送货时间和还货时间
- (BOOL)judgeWeatherSelectTime {
    if (!_startLastTimeBtn && !_endLastTimeBtn) {
        [MBProgressHUD showError:@"请选择送货时间和还货时间" toView:nil];
        return NO;
    }else if(!_startLastTimeBtn) {
        [MBProgressHUD showError:@"请选择送货时间" toView:nil];
        return NO;
    }else if(!_endLastTimeBtn){
        [MBProgressHUD showError:@"请选择还货时间" toView:nil];
        return NO;
    }else {
        return YES;
    }
}

@end
