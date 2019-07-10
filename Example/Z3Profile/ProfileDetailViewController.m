//
//  ProfileDetailViewController.m
//  OutWork
//
//  Created by ZZHT on 2018/5/21.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import "ProfileDetailViewController.h"
#import "ProfileModifyPasswordView.h"
#import "ProfileModifyPasswordView.h"
#import "UserService.h"
NSNotificationName const NOTIFICATION_PASSWORD_CHANGE_SUCCESS = @"change_password_success";
@interface ProfileDetailViewController ()<ProfileModifyPasswordViewDelegate>
@property (nonatomic,weak) MBProgressHUD *hud;
@end

static NSString *subTitleReuseIdentifier = @"SubTitleTableViewCell";
@implementation ProfileDetailViewController

- (UIView *)footer {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 120)];
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 80, App_Frame_Width, 40)];
    bottom.backgroundColor = [UIColor whiteColor];
    
    [footerView addSubview:bottom];
    
    UIButton *modify = [[UIButton alloc] initWithFrame:CGRectMake((App_Frame_Width-120)/2, 0, 120, 40)];
    [modify setTitle:LocalizedString(@"modify password") forState:UIControlStateNormal];
    [modify setTitleColor:HEXCOLOR(themeColorHexValue) forState:UIControlStateNormal];
    [modify addTarget:self action:@selector(modifyPwdAction) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:modify];
    
   
    return footerView;
}

- (ProfileModifyPasswordView *)modifyView {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ProfileModifyPasswordView class]) bundle:nil];
    ProfileModifyPasswordView *view = [[nib instantiateWithOwner:self options:nil] firstObject];
    view.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, 280);
    view.backgroundColor = HEXCOLOR(backgroundColorHexValue);
    view.delegate = self;
    view.userNameLabel.text = [Z3User shareInstance].trueName;
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)initDataSource {
    self.dataSource = [TYSettingItem loadSettingItemsWithPlistName:@"profile_detail.plist"];
    TYSettingItem *item = self.dataSource[0][0];
    item.subTitle = [Z3User shareInstance].company;
    item = self.dataSource[0][1];
    item.subTitle = [NSString stringWithFormat:@"%ld",(long)[Z3User shareInstance].uid];
    item = self.dataSource[0][2];
    item.subTitle = [Z3User shareInstance].username;
    item = self.dataSource[0][3];
    item.subTitle = [Z3User shareInstance].trueName;
    item = self.dataSource[0][4];
    item.subTitle = [StringUtil isEmpty:[Z3User shareInstance].company] ? [Z3User shareInstance].groupName : [Z3User shareInstance].company;
    item = self.dataSource[0][5];
    item.subTitle = [Z3User shareInstance].groupCode;
    item = self.dataSource[0][6];
    item.subTitle = [Z3User shareInstance].groupName;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark---action
- (void)modifyPwdAction {
    UIViewController *detail = [UIViewController new];
    [detail.view addSubview:[self modifyView]];
    detail.navigationItem.title = LocalizedString(@"modify password");
    detail.view.backgroundColor = HEXCOLOR(backgroundColorHexValue);
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - Table view data source and Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TYSettingItem *item = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = item.title;
    if (![StringUtil isEmpty:item.icon]) {
        NSTextAttachment *attachment = [NSTextAttachment new];
        attachment.image = [UIImage imageNamed:item.icon];
        attachment.bounds = CGRectMake(0, -5, 28, 28);
        NSMutableAttributedString *mastr = [NSMutableAttributedString new];
        NSAttributedString *astr = [NSAttributedString attributedStringWithAttachment:attachment];
        [mastr appendAttributedString:astr];
        [mastr appendString:item.subTitle];
        cell.detailTextLabel.attributedText = mastr;
    }else {
        cell.detailTextLabel.text = item.subTitle;
    }
}

#pragma mark--- ProfileModifyPasswordViewDelegate

- (void)modifyPwdView:(UIView *)view didClickedSubmitBtnWithNewPwd:(NSString *)password oldPwd:(NSString *)oldPwd {
    
   _hud = [MBProgressHUD showHUDAddedTo:view.superview animated:YES];
    [self registerAsHttpRequestObserver:USERSERVICE_REQUEST_ID_CHANGE_PASSWORD cancelExisting:false];
    [UserService modifyPassword:oldPwd newPassword:password];
    
}

#pragma mark--- Process

-(void)processHttpResponse:(HttpRequestResult *)requestResult {
    [super processHttpResponse:requestResult];
    [_hud hideAnimated:YES];
    if (!requestResult.isSuccess) return;
    [self removeHttpRequestObserver:self requestId:USERSERVICE_REQUEST_ID_CHANGE_PASSWORD];
    [MBProgressHUD showSuccess:LocalizedString(@"toast_modify_password_is_success")];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PASSWORD_CHANGE_SUCCESS object:nil];
    });
    
    
}


@end
