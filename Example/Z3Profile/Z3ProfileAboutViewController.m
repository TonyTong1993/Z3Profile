//
//  Z3ProfileAboutViewController.m
//  Z3Profile_Example
//
//  Created by 童万华 on 2019/7/6.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3ProfileAboutViewController.h"
#import "ProfileAboutView.h"
@interface Z3ProfileAboutViewController ()

@end

@implementation Z3ProfileAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:[self aboutView]];
}

- (ProfileAboutView *)aboutView {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ProfileAboutView class]) bundle:nil];
    ProfileAboutView *view = [[nib instantiateWithOwner:self options:nil] firstObject];
    CGFloat bottom = 0.0f;
    if (@available(iOS 11.0, *)) {
        bottom += self.view.safeAreaInsets.bottom - 49;
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat topHeight = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
    view.frame = CGRectMake(10.0f, topHeight + 10.0f, width - 20, height - topHeight - bottom - 20);
    view.versionLabel.text = [NSString stringWithFormat:@"v%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    return  view;
}


@end
