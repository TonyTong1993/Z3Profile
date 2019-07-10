//
//  Z3ProfilePhoneViewController.m
//  Z3Profile_Example
//
//  Created by 童万华 on 2019/7/6.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3ProfilePhoneViewController.h"
#import "Z3ProfilePhoneInfoView.h"
#import <YYKit/YYKit.h>
@interface Z3ProfilePhoneViewController ()

@end

@implementation Z3ProfilePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:[self phoneInfoView]];
}

- (Z3ProfilePhoneInfoView *)phoneInfoView {
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([Z3ProfilePhoneInfoView class]) bundle:nil];
    Z3ProfilePhoneInfoView *view = [[nib instantiateWithOwner:self options:nil] firstObject];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat topHeight = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
    view.frame = CGRectMake(10.0f, topHeight + 10.0f, width - 20, 134);
    
    float cpuUseAge = [[UIDevice currentDevice] cpuUsage];
    float memoryUsed = [[UIDevice currentDevice] memoryFree];
    float memoryTotal = [[UIDevice currentDevice] memoryUsed];
    float memoryUseAge = memoryUsed / memoryTotal;
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    CGFloat batteryLevel =  [UIDevice currentDevice].batteryLevel;
    view.cpuLabel.text = [NSString stringWithFormat:@"  CPU使用率：%.2f%%",cpuUseAge];
    view.batteryLabel.text = [NSString stringWithFormat:@"  电量：%.2f%%",batteryLevel * 100];
    view.memoryLabel.text = [NSString stringWithFormat:@"   内存使用率：%.2f%%",memoryUseAge * 100];
    
    return  view;
}

@end
