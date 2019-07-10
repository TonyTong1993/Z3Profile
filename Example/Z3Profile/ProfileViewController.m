//
//  ProfileViewController.m
//  OutWork
//
//  Created by ZZHT on 2018/5/18.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileDetailViewController.h"

//#import "SubTitleTableViewCell.h"
//#import "ProfilePhoneInfoView.h"
//#import "ProfileAboutView.h"
//#import "UIDevice+Extension.h"
//#import "PatrolService.h"
//#import "Z3PlanTaskManager.h"
//#import "CoorTranUtil.h"
//#import "AppDelegate+APSN.h"
@interface ProfileViewController ()

@end

static NSString *subTitleReuseIdentifier = @"SubTitleTableViewCell";
@implementation ProfileViewController

- (UIView *)footer {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 60)];
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 20, App_Frame_Width, 40)];
    bottom.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:bottom];
    UIButton *logout = [[UIButton alloc] initWithFrame:CGRectMake((App_Frame_Width-120)/2, 0, 120, 40)];
    [logout setTitle:LocalizedString(@"logout") forState:UIControlStateNormal];
    [logout setTitleColor:HEXCOLOR(themeColorHexValue) forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:logout];

    return footerView;
}

- (ProfilePhoneInfoView *)phoneInfoView {
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ProfilePhoneInfoView class]) bundle:nil];
    ProfilePhoneInfoView *view = [[nib instantiateWithOwner:self options:nil] firstObject];
    view.frame = CGRectMake(10.0f, kTopHeight + 10.0f, SCREEN_WIDTH - 20, 134);
    
    float cpuUseAge = [[UIDevice currentDevice] GetCpuUsage];
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

- (ProfileAboutView *)aboutView {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ProfileAboutView class]) bundle:nil];
    ProfileAboutView *view = [[nib instantiateWithOwner:self options:nil] firstObject];
    CGFloat bottom = 0.0f;
    if (@available(iOS 11.0, *)) {
        bottom += self.view.safeAreaInsets.bottom - 49;
    }
    view.frame = CGRectMake(10.0f, kTopHeight + 10.0f, SCREEN_WIDTH - 20, SCREEN_HEIGHT - kTopHeight - bottom - 20);
    view.versionLabel.text = [NSString stringWithFormat:@"v%@",AppShortVersion];

    return  view;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SubTitleTableViewCell class]) bundle:nil] forCellReuseIdentifier:subTitleReuseIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:NOTIFICATION_PASSWORD_CHANGE_SUCCESS object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PASSWORD_CHANGE_SUCCESS object:nil];
     DLog(@"ProfileViewController dealloc");
}
- (void)initDataSource {
    self.dataSource = [TYSettingItem loadSettingItemsWithPlistName:@"profile.plist"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---action
- (void)logout {
    [self registerAsHttpRequestObserver:USERSERVICE_REQUEST_ID_LOG_OFF cancelExisting:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PatrolService updatePatrolManState:NO];
     [[AppDelegate sharedInstance] unbindTags];
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TYSettingItem *item = self.dataSource[indexPath.section][indexPath.row];
    UIViewController *detail = [NSClassFromString(item.className) new];
    if ([item.className isEqualToString:NSStringFromClass([UIViewController class])]) {
        detail.view.backgroundColor = HEXCOLOR(backgroundColorHexValue);
        UIView *view = nil;
        if ([item.title isEqualToString:LocalizedString(@"profile_detail_about")]) {
            view = [self aboutView];
        }else {
            view = [self phoneInfoView];
        }
        [detail.view addSubview:view];
    }
    detail.navigationItem.title = item.navTitle;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark---Process
-(void)processHttpResponse:(HttpRequestResult *)requestResult {
    [super processHttpResponse:requestResult];
    if (!requestResult.isSuccess) return;
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:KEY_USER_LOGIN_FLAG];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KEY_AUTO_LOGIN];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    Z3LoginViewController *loginVC = [[Z3LoginViewController alloc] initWithLoginSuccessBlock:^(NSXMLParser *parser) {
        CoorTranUtil *coorTrans = [[CoorTranUtil alloc] initWithParser:parser];
        [AppDelegate sharedInstance].coorTrans = coorTrans;
        [[AppDelegate sharedInstance] applicationLaunchRootViewController];
        [kUserDefaults setBool:YES forKey:KUSER_FIRST_LAUNCH_APP];
        [kUserDefaults synchronize];
    }];
    NavigationController *rootViewController = [[NavigationController alloc] initWithRootViewController:loginVC];
    loginVC.navigationItem.title = LocalizedString(@"app_display_name");
    [self presentViewController:rootViewController animated:YES completion:nil];

}
@end
