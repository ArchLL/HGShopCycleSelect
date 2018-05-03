//
//  ViewController.m
//  ARSelectionCycle
//
//  Created by 黑色幽默 on 2018/4/10.
//  Copyright © 2018年 黑色幽默. All rights reserved.
//

#import "ViewController.h"
#import "ShopCycleSelectCell.h"
#import "ShopCycleSelectVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *cycleSelectDic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    [_tableView registerNib:[UINib nibWithNibName:@"ShopCycleSelectCell" bundle:nil] forCellReuseIdentifier:@"ShopCycleSelectCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 157;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopCycleSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCycleSelectCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopCycleSelectVC *vc = [[ShopCycleSelectVC alloc] init];
    vc.price = @"198.00";
    vc.cycleDays = 7;
    if (self.cycleSelectDic.allKeys.count > 0) {
        vc.dataDic = _cycleSelectDic;
    }
    __weak typeof(self) weakSelf = self;
    __block typeof(NSIndexPath *) blockIndexPath = indexPath;
    vc.userCycleSelectBlock = ^(NSDictionary *dic) {
        weakSelf.cycleSelectDic = dic;
        ShopCycleSelectCell *cell = [tableView cellForRowAtIndexPath:blockIndexPath];
        //cell赋值
        [cell updateDataWithDic:dic];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
