//
//  XXBaseViewController.m
//  VensAppiOS
//
//  Created by UIDesigner on 2018/1/11.
//  Copyright © 2018年 iOS Coder. All rights reserved.
//

#import "XXBaseViewController.h"

@interface XXBaseViewController ()

@end

@implementation XXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = HexRGB(0xf5f5f5);
    self.tabBarHeight = TabBarHeight;
    self.naviBarHeight = NaviBarHeight;
}

- (void)setIsShowTopLine:(BOOL)isShowTopLine {
    if (isShowTopLine) {
        // 分割线
        UIView *labLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        labLine.backgroundColor = HexRGB(0x999999);
        [self.view addSubview:labLine];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
