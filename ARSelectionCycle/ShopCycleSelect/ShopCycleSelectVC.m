//
//  ShopCycleSelectVC.m
//  VensAppiOS
//
//  Created by UIDesigner on 2018/3/19.
//  Copyright © 2018年 iOS Coder. All rights reserved.
//

#import "ShopCycleSelectVC.h"
#import "ShopCycleSelectHeaderView.h"
#import "ShopStartTimeView.h"
#import "ShopTimeSelectTool.h"

@interface ShopCycleSelectVC ()

@property (nonatomic, strong) UIButton                   * bottomButton;    // 确定按钮
@property (nonatomic, strong) UIScrollView               * mainScrollView;
@property (nonatomic, strong) ShopstartTimeView          * startTimeView;
@property (nonatomic, strong) ShopCycleSelectHeaderView  * cycleSelectView;

@property (nonatomic,   copy) NSString * startDate;      // 使用周期的开始日期 年 月 日
@property (nonatomic,   copy) NSString * endDate;        // 使用周期的结束日期
@property (nonatomic,   copy) NSString * startTime;      // 使用周期的送货时间段
@property (nonatomic,   copy) NSString * endTime;        // 使用周期的还货时间段
@property (nonatomic, assign) NSInteger  cycleNum;       // 周期数
@property (nonatomic,   copy) NSString * payMoney;       // 总费用
@property (nonatomic,   copy) NSDate   * networkDate;    // 最新网络时间(更新)  (年-月-日 时:分:秒)
@property (nonatomic,   copy) NSString * networkDateStr; // 最新网络时间(更新)  (年-月-日 时:分:秒)
@property (nonatomic, assign) NSInteger  firstCycleDays; // 首次一个周期的事件，根据送货时间定;

@end

@implementation ShopCycleSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择使用周期";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainScrollView];
    self.isShowTopLine = YES;
    //网络检测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"有网");
            [ShopTimeSelectTool getNetWorkDateSuccess:^(NSDate *networkDate, NSString *networkDateStr) {
                _networkDate = networkDate;
                _networkDateStr = networkDateStr;
                //初始化数据
                [self updateUserCycle];
                //选择使用周期
                [self createCycleSelectView];
                //选择送货和换货时间
                [self creatTimeSelectView];
                [self.view addSubview:self.bottomButton];
            }];
        }else {
            NSLog(@"没有网");
        }
    }];
}

//  NSDictionary *dic = @{@"cycleNum":@(_cycleNum), @"startDate":_startDate, @"endDate":_endDate, @"startTime":_startTime, @"endTime":_endTime, @"payMoeny":_payMoney , @"days":@(_days)}
//更新使用周期
- (void)updateUserCycle {
    if (self.dataDic.allKeys.count > 0) {
        _days      = [self.dataDic[@"days"] integerValue];
        _cycleNum  = [self.dataDic[@"cycleNum"] integerValue];
        _payMoney  = self.dataDic[@"payMoeny"];
        _startDate = self.dataDic[@"startDate"];
        _startTime = self.dataDic[@"startTime"];
        _endDate   = self.dataDic[@"endDate"];
        _endTime   = self.dataDic[@"endTime"];
    }else {
        _cycleNum  = 1;
        _days      = _cycleNum * _cycleDays;
        _payMoney  = [NSString stringWithFormat:@"%ld", _price.integerValue * _cycleNum];
        _startDate = [ShopTimeSelectTool getSimpleStringWithDate:_networkDate];

        if ([self.cityCode isEqualToString:@"SH"]) {
            _startDate = [ShopTimeSelectTool getSimpleStringWithDate:_networkDate];
            _endDate   =  [ShopTimeSelectTool updateDateWithDate:_networkDate Interval:_days*24*60*60 IsAdd:YES];
        }else{
            _startDate = [ShopTimeSelectTool updateDateWithDate:_networkDate Interval:1*24*60*60 IsAdd:YES];
            _endDate   =  [ShopTimeSelectTool updateDateWithDate:_networkDate Interval:(_days+1)*24*60*60 IsAdd:YES];
        }
    }
}

#pragma mark - 头部周期选择
- (void)createCycleSelectView {
    _cycleSelectView = [[ShopCycleSelectHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 195) CycleNum:_cycleNum CycleDays:_cycleDays NetworkDate:_networkDate Price:_price];
    [_mainScrollView addSubview:_cycleSelectView];
    //周期选择回调
    __weak typeof(self) weakSelf = self;
    _cycleSelectView.cycleSelectBlock = ^(NSString *endDate, NSInteger cycleNum , NSString *payMoney) {
        
        weakSelf.endDate = endDate;
        weakSelf.cycleNum = cycleNum;
        weakSelf.days = cycleNum * weakSelf.cycleDays;
        weakSelf.payMoney = [NSString stringWithFormat:@"%.2f", _price.floatValue * _cycleNum];
        
        //首轮周期时间(初始是7天)要根据送货时间而定
        //当前时间 年-月-日
        NSString *currentDate = [ShopTimeSelectTool getSimpleStringWithDate:weakSelf.networkDate];
        //判断当前送货时间比当前时间多几天
        NSInteger intervalDays;
        if ([weakSelf.startDate isEqualToString:@"quick"]) {
            //极速达单独处理
            intervalDays = [ShopTimeSelectTool getTimeDifferenceWithFromDate:currentDate toDate:currentDate];
        }else {
            intervalDays = [ShopTimeSelectTool getTimeDifferenceWithFromDate:weakSelf.startDate toDate:currentDate];
        }
        weakSelf.firstCycleDays = weakSelf.cycleDays - intervalDays;
        //更新ShopstartTimeView的还货时间
        NSString *newEndDate = [ShopTimeSelectTool updateDateWithDateStr:endDate Interval:intervalDays*24*60*60 IsAdd:YES];
        //更新结束日期
        weakSelf.startTimeView.endDate = newEndDate;
        //租赁时长
        weakSelf.startTimeView.days = cycleNum * weakSelf.cycleDays;
    };
}

#pragma mark - 时间选择
- (void)creatTimeSelectView {
    __weak typeof(self) weakSelf = self;
    _startTimeView = [[ShopstartTimeView alloc] initWithFrame:CGRectMake(0, 195, SCREEN_WIDTH, 550) NetworkDate:_networkDate RentDays:_days StartDate:_startDate StartTime:_startTime EndDate:_endDate EndTime:_endTime];
    [_mainScrollView addSubview:_startTimeView];
    
#pragma mark - 时间选择回调
    //送货日期回调
    _startTimeView.startDateSelectBlock = ^(NSString *startDate) {
        NSLog(@"送货日期：%@", startDate);
        weakSelf.startDate = startDate;
    };
    
    //送货时间段回调
    _startTimeView.startTimeSelectBlock = ^(NSString *startTime) {
        NSLog(@"送货时间段：%@", startTime);
        weakSelf.startTime = startTime;
    };
    
    //还货日期回调
    _startTimeView.endDateSelectBlock = ^(NSString *endDate) {
        NSLog(@"还货日期：%@", endDate);
        weakSelf.endDate = endDate;
    };
    
    //还货时间段回调
    _startTimeView.endTimeSelectBlock = ^(NSString *endTime) {
        NSLog(@"还货时间段：%@", endTime);
        weakSelf.endTime = endTime;
    };
}

#pragma mark - 底部确定按钮事件
- (void)bottomButtonAction {
    NSLog(@"点击了确定按钮");
    if ([_startTimeView judgeWeatherSelectTime]) {
        //回调
        NSDictionary *dic = @{@"cycleNum":@(_cycleNum), @"startDate":_startDate, @"endDate":_endDate, @"startTime":_startTime, @"endTime":_endTime, @"payMoeny":_payMoney , @"days":@(_days)};
        if (self.userCycleSelectBlock) {
            self.userCycleSelectBlock(dic);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 懒加载
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.naviBarHeight + 1, SCREEN_WIDTH, SCREEN_HEIGHT - self.naviBarHeight - self.tabBarHeight - 1)];
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 745);
        _mainScrollView.bounces = NO;
    }
    return _mainScrollView;
}

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - self.tabBarHeight, SCREEN_WIDTH, self.tabBarHeight)];
        [_bottomButton setTitle:@"确定" forState: UIControlStateNormal];
        if (isIphoneX) {
            [_bottomButton setTitleEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
        }
        _bottomButton.adjustsImageWhenHighlighted = NO;
        [_bottomButton setBackgroundImage:[UIImage imageNamed:@"btnBackground"] forState:UIControlStateNormal];
        [_bottomButton addTarget:self action:@selector(bottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

@end
