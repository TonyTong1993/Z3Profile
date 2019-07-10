//
//  ProfileAboutView.m
//  OutWork
//
//  Created by ZZHT on 2018/5/22.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import "Z3ProfileAboutView.h"
#import "UIColor+Z3.h"
#import "Z3Theme.h"
#import <YYKit/YYKit.h>
@implementation Z3ProfileAboutView


-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor colorWithHex:separatorColorHex] CGColor];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.35;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CALayer *seperatorLine = [CALayer new];
    seperatorLine.size = CGSizeMake(screenW - 40, 1.0f);
    seperatorLine.backgroundColor =[[UIColor colorWithHex:separatorColorHex] CGColor];
    
    CGFloat top = CGRectGetMaxY(self.versionLabel.bounds)-1;
    seperatorLine.top = top;
    [self.versionLabel.layer addSublayer:seperatorLine];
}

@end
