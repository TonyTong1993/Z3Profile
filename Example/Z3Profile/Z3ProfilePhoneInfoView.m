//
//  ProfilePhoneInfoView.m
//  OutWork
//
//  Created by ZZHT on 2018/5/22.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import "Z3ProfilePhoneInfoView.h"
#import "UIColor+Z3.h"
#import "Z3Theme.h"
#import <YYKit/YYKit.h>
@implementation Z3ProfilePhoneInfoView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor colorWithHex:separatorColorHex] CGColor];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.35;
    
    //添加间隔线
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CALayer *seperatorLine = [CALayer new];
    seperatorLine.size = CGSizeMake(screenW - 20, 1.0f);
    seperatorLine.backgroundColor = [[UIColor colorWithHex:separatorColorHex] CGColor];
    
    seperatorLine.top = CGRectGetMaxY(self.cpuLabel.bounds)-1;
    [self.cpuLabel.layer addSublayer:seperatorLine];
    
    
    CALayer *newLine = [CALayer new];
    newLine.size = CGSizeMake(screenW - 20, 1.0f);
    newLine.backgroundColor = [[UIColor colorWithHex:separatorColorHex] CGColor];
    newLine.top = CGRectGetMaxY(self.batteryLabel.bounds)-1;
    [self.batteryLabel.layer addSublayer:newLine];
    
}

-(void)dealloc {
    [UIDevice currentDevice].batteryMonitoringEnabled = NO;  
}
@end
