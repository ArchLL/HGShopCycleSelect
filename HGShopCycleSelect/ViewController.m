//
//  ViewController.m
//  HGShopCycleSelect
//
//  Created by Arch on 2018/4/10.
//  Copyright © 2018年 Arch. All rights reserved.
//

#import "ViewController.h"
#import "HGShopCycleSelectCell.h"
#import "HGShopCycleSelectViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *cycleSelectDic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HGShopCycleSelectCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HGShopCycleSelectCell class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 157;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HGShopCycleSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HGShopCycleSelectCell class])];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HGShopCycleSelectViewController *vc = [[HGShopCycleSelectViewController alloc] init];
    vc.price = @"198.00";
    vc.cycleDays = 7;
    if (!kDictIsEmpty(self.cycleSelectDic)) {
        vc.dataDic = _cycleSelectDic;
    }
    __weak typeof(self) weakSelf = self;
    __block typeof(NSIndexPath *) blockIndexPath = indexPath;
    vc.userCycleSelectBlock = ^(NSDictionary *dic) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.cycleSelectDic = dic;
        HGShopCycleSelectCell *cell = [tableView cellForRowAtIndexPath:blockIndexPath];
        [cell updateDataWithDic:dic];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
