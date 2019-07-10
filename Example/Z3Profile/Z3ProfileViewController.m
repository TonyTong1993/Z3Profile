//
//  BaseProfileViewController.m
//  OutWork
//
//  Created by ZZHT on 2018/5/21.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import "Z3ProfileViewController.h"
#import "Z3SettingItem.h"
#import "Z3User.h"
#import "Z3ProfileFirstSectionCell.h"
#import "UIColor+Z3.h"
#import "Z3Theme.h"
#import "Z3LogoutRequest.h"
#import "Z3LoginViewController.h"
@interface Z3ProfileViewController ()
@property (nonatomic,strong) Z3LogoutRequest *request;
@end

@implementation Z3ProfileViewController

#pragma mark---Getter and Setter
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Z3ProfileFirstSectionCell class]) bundle:nil] forCellReuseIdentifier:profileFirstSectionCellReuseIdentifier];
    self.tableView.tableFooterView = [self footer];
}

- (void)initDataSource {
      self.dataSource = [Z3SettingItem loadSettingItemsWithPlistName:@"profile.plist"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = self.dataSource[section];
    return rows.count;
}

static NSString *reuseIdentifier = @"UITableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self tableView:tableView subTitleCellForRowAtIndexPath:indexPath];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    
    Z3SettingItem *item = self.dataSource[indexPath.section][indexPath.row];
    if (item.icon.length) {
        cell.imageView.image = [UIImage imageNamed:item.icon];
    }
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    cell.accessoryType = (UITableViewCellAccessoryType)item.accessoryType;
    return cell;
}

static NSString *profileFirstSectionCellReuseIdentifier = @"Z3ProfileFirstSectionCell";
- (UITableViewCell *)tableView:(UITableView *)tableView subTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Z3ProfileFirstSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:profileFirstSectionCellReuseIdentifier forIndexPath:indexPath];
    Z3SettingItem *item = self.dataSource[indexPath.section][indexPath.row];
    if (item.icon.length) {
        cell.subImageView.image = [UIImage imageNamed:item.icon];
    }
    cell.titleLabel.text = [Z3User shareInstance].trueName;
    cell.subTitleLabel.text = [Z3User shareInstance].groupName;
    cell.accessoryType = (UITableViewCellAccessoryType)item.accessoryType;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 80;
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0.001f;
    return  20.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) return nil;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Z3SettingItem *item = self.dataSource[indexPath.section][indexPath.row];
    UIViewController *detail = [NSClassFromString(item.className) new];
    detail.navigationItem.title = item.navTitle;
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark---action
- (void)logout {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.request = [[Z3LogoutRequest alloc] initWithRelativeToURL:@"rest/patrolService/updatePatrolManState" method:GET parameter:@{@"isLogin":@(false)} success:^(__kindof Z3BaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self exitMainViewController];
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self exitMainViewController];
    }];
    [self.request start];
}

- (void)exitMainViewController {
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:KEY_USER_LOGIN_FLAG];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KEY_AUTO_LOGIN];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    Z3LoginViewController *loginVC = [[Z3LoginViewController alloc] initWithLoginSuccessBlock:^(NSXMLParser *parser) {
        [[AppDelegate sharedInstance] applicationLaunchRootViewController];
        [kUserDefaults setBool:YES forKey:KUSER_FIRST_LAUNCH_APP];
        [kUserDefaults synchronize];
    }];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UINavigationController *rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    loginVC.navigationItem.title = LocalizedString(@"app_display_name");
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 0.25;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [window.layer addAnimation:transition forKey:@"transition"];
    window.rootViewController = rootViewController;
}

#pragma mark --getter and setter
- (UIView *)footer {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 60)];
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 20, width, 40)];
    bottom.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:bottom];
    UIButton *logout = [[UIButton alloc] initWithFrame:CGRectMake((width-120)/2, 0, 120, 40)];
    [logout setTitle:NSLocalizedString(@"logout",@"推出") forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor colorWithHex:themeColorHex] forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:logout];
    
    return footerView;
}


@end
