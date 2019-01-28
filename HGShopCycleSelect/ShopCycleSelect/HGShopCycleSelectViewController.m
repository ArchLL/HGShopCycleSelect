//
//  HGShopCycleSelectViewController.m
//  HGShopCycleSelect
//
//  Created by Arch on 2018/3/19.
//  Copyright © 2018年 Arch. All rights reserved.
//

#import "HGShopCycleSelectViewController.h"
#import "HGShopCycleSelectHeaderView.h"
#import "HGShopStartTimeView.h"
#import "HGShopTimeSelectTool.h"

@interface HGShopCycleSelectViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) HGShopStartTimeView *startTimeView;
@property (nonatomic, strong) HGShopCycleSelectHeaderView *cycleSelectView;
@property (nonatomic, copy) NSString *startDate; // 使用周期的开始日期 年 月 日
@property (nonatomic, copy) NSString *endDate; // 使用周期的结束日期
@property (nonatomic, copy) NSString *startTime; // 使用周期的送货时间段
@property (nonatomic, copy) NSString *endTime; // 使用周期的还货时间段
@property (nonatomic) NSInteger cycleNum;       // 周期数
@property (nonatomic, copy) NSString *payMoney; // 总费用
@property (nonatomic, copy) NSDate *networkDate; // 最新网络时间(更新)  (年-月-日 时:分:秒)
@property (nonatomic, copy) NSString *networkDateStr; // 最新网络时间(更新)  (年-月-日 时:分:秒)
@property (nonatomic) NSInteger firstCycleDays; // 首次一个周期的事件，根据送货时间定;

@end

@implementation HGShopCycleSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择使用周期";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.enterButton];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.top.left.right.equalTo(self.bottomView);
        make.bottom.mas_equalTo(-HGDeviceModelHelper.safeAreaInsetsBottom);
    }];
    
    [self networkReachability];
}

- (void)networkReachability {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"有网");
            __weak typeof(self) weakSelf = self;
            [HGShopTimeSelectTool getNetWorkDateSuccess:^(NSDate *networkDate, NSString *networkDateStr) {
                __weak typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.networkDate = networkDate;
                strongSelf.networkDateStr = networkDateStr;
                //初始化数据
                [strongSelf updateUserCycle];
                //选择使用周期
                [strongSelf createCycleSelectView];
                //选择送货和换货时间
                [strongSelf creatTimeSelectView];
            }];
        } else {
            NSLog(@"没有网");
        }
    }];
}

// NSDictionary *dic = @{@"cycleNum": @(self.cycleNum), @"startDate": self.startDate, @"endDate": self.endDate, @"startTime": self.startTime, @"endTime": self.endTime, @"payMoeny": self.payMoney , @"days": @(self.days)}
//更新使用周期
- (void)updateUserCycle {
    if (self.dataDic.allKeys.count > 0) {
        self.days = [self.dataDic[@"days"] integerValue];
        self.cycleNum = [self.dataDic[@"cycleNum"] integerValue];
        self.payMoney = self.dataDic[@"payMoeny"];
        self.startDate = self.dataDic[@"startDate"];
        self.startTime = self.dataDic[@"startTime"];
        self.endDate = self.dataDic[@"endDate"];
        self.endTime = self.dataDic[@"endTime"];
    }else {
        self.cycleNum = 1;
        self.days = self.cycleNum * self.cycleDays;
        self.payMoney = [NSString stringWithFormat:@"%ld", self.price.integerValue * self.cycleNum];
        self.startDate = [HGShopTimeSelectTool getSimpleStringWithDate:self.networkDate];
        
        if ([self.cityCode isEqualToString:@"SH"]) {
            self.startDate = [HGShopTimeSelectTool getSimpleStringWithDate:self.networkDate];
            self.endDate = [HGShopTimeSelectTool updateDateWithDate:self.networkDate Interval:self.days * 24 * 60 * 60 IsAdd:YES];
        } else{
            self.startDate = [HGShopTimeSelectTool updateDateWithDate:self.networkDate Interval:1 * 24 * 60 * 60 IsAdd:YES];
            self.endDate = [HGShopTimeSelectTool updateDateWithDate:self.networkDate Interval:(self.days + 1) * 24 * 60 * 60 IsAdd:YES];
        }
    }
}

#pragma mark - 头部周期选择
- (void)createCycleSelectView {
    self.cycleSelectView = [[HGShopCycleSelectHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 195) CycleNum:self.cycleNum CycleDays:self.cycleDays NetworkDate:self.networkDate Price:self.price];
    [self.scrollView addSubview:self.cycleSelectView];
    
    //周期选择回调
    __weak typeof(self) weakSelf = self;
    self.cycleSelectView.cycleSelectBlock = ^(NSString *endDate, NSInteger cycleNum , NSString *payMoney) {
        __weak typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.endDate = endDate;
        strongSelf.cycleNum = cycleNum;
        strongSelf.days = cycleNum * strongSelf.cycleDays;
        strongSelf.payMoney = [NSString stringWithFormat:@"%.2f", strongSelf.price.floatValue * strongSelf.cycleNum];
        
        //首轮周期时间(初始是7天)要根据送货时间而定
        //当前时间 年-月-日
        NSString *currentDate = [HGShopTimeSelectTool getSimpleStringWithDate:weakSelf.networkDate];
        //判断当前送货时间比当前时间多几天
        NSInteger intervalDays;
        if ([weakSelf.startDate isEqualToString:@"quick"]) {
            //极速达单独处理
            intervalDays = [HGShopTimeSelectTool getTimeDifferenceWithFromDate:currentDate toDate:currentDate];
        } else {
            intervalDays = [HGShopTimeSelectTool getTimeDifferenceWithFromDate:weakSelf.startDate toDate:currentDate];
        }
        weakSelf.firstCycleDays = weakSelf.cycleDays - intervalDays;
        //更新ShopstartTimeView的还货时间
        NSString *newEndDate = [HGShopTimeSelectTool updateDateWithDateStr:endDate Interval:intervalDays * 24 * 60 * 60 IsAdd:YES];
        //更新结束日期
        weakSelf.startTimeView.endDate = newEndDate;
        //租赁时长
        weakSelf.startTimeView.days = cycleNum * weakSelf.cycleDays;
    };
}

#pragma mark - 时间选择
- (void)creatTimeSelectView {
    self.startTimeView = [[HGShopStartTimeView alloc] initWithFrame:CGRectMake(0, 195, SCREEN_WIDTH, 550) NetworkDate:self.networkDate RentDays:self.days StartDate:self.startDate StartTime:self.startTime EndDate:self.endDate EndTime:self.endTime];
    [self.scrollView addSubview:self.startTimeView];
    
    //时间选择回调
     __weak typeof(self) weakSelf = self;
    //送货日期回调
    weakSelf.startTimeView.startDateSelectBlock = ^(NSString *startDate) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.startDate = startDate;
    };
    
    //送货时间段回调
    weakSelf.startTimeView.startTimeSelectBlock = ^(NSString *startTime) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.startTime = startTime;
    };
    
    //还货日期回调
    weakSelf.startTimeView.endDateSelectBlock = ^(NSString *endDate) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.endDate = endDate;
    };
    
    //还货时间段回调
    weakSelf.startTimeView.endTimeSelectBlock = ^(NSString *endTime) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.endTime = endTime;
    };
}

- (void)enterButtonAction {
    if ([self.startTimeView judgeWeatherSelectTime]) {
        NSDictionary *dic = @{@"cycleNum": @(self.cycleNum), @"startDate": self.startDate, @"endDate": self.endDate, @"startTime": self.startTime, @"endTime": self.endTime, @"payMoeny": self.payMoney , @"days": @(self.days)};
        if (self.userCycleSelectBlock) {
            self.userCycleSelectBlock(dic);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Getters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = HexRGB(0xf5f5f5);
        _scrollView.contentSize = CGSizeMake(0, 750);
    }
    return _scrollView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [[UIButton alloc] init];
        [_enterButton setTitle:@"确定" forState: UIControlStateNormal];
        _enterButton.adjustsImageWhenHighlighted = NO;
        [_enterButton setBackgroundImage:[UIImage imageNamed:@"btnBackground"] forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

@end
