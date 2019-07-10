//
//  ProfileSystemSettingsViewController.m
//  OutWork
//
//  Created by ZZHT on 2018/5/22.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import "Z3ProfileSettingsViewController.h"
#import <Z3SettingItem.h>
#import "Z3SettingsManager.h"
#import <MBProgressHUD+Z3.h>
@interface Z3ProfileSettingsViewController ()
@end

@implementation Z3ProfileSettingsViewController
#pragma mark - life circle

#pragma mark - view life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - public method

#pragma mark - private metod
-(void)initDataSource {
    self.dataSource = [Z3SettingItem loadSettingItemsWithPlistName:@"profile_system_settings.plist"];
    Z3SettingItem *versionItem = [[self.dataSource lastObject] lastObject];
    versionItem.subTitle = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
#ifdef DEBUG
    Z3SettingItem *locationSettingItem = [[Z3SettingItem alloc] init];
    [locationSettingItem setTitle:@"模拟定位"];
    [locationSettingItem setAccessoryType:SettingItemAccessorySwitch];
    [locationSettingItem setSwitchOn:@"开启"];
    [locationSettingItem setSwitchOff:@"关闭"];
    NSMutableArray *dataSource = [self.dataSource lastObject];
    [dataSource addObject:locationSettingItem];
#endif
   
}
-(void)switchValueDidChanged:(UISwitch *)sender {
    if (sender.tag == Z3SettingsManagerLocationWarnTag) {
         [[Z3SettingsManager sharedInstance] setLocationWarn:sender.isOn];
    }else {
        [[Z3SettingsManager sharedInstance] setLocationSimulate:sender.isOn];
    }
   
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *items = self.dataSource[section];
    return items.count;
}

static NSString *reuseIdentifier = @"UITableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    
    Z3SettingItem *item = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    if (item.accessoryType == SettingItemAccessorySwitch) {
        UISwitch *switchView = [[UISwitch alloc] init];
        [switchView setTarget:self action:@selector(switchValueDidChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    }else {
          cell.accessoryType = (UITableViewCellAccessoryType)item.accessoryType;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Z3SettingItem *item = self.dataSource[indexPath.section][indexPath.row];
    if (item.accessoryType == SettingItemAccessorySwitch) {
        UISwitch *switchView = (UISwitch *) cell.accessoryView;
        switchView.tag = indexPath.row == 0 ? Z3SettingsManagerLocationWarnTag : Z3SettingsManagerLocationSimulateTag;
        BOOL isOn = false;
        if ( switchView.tag == Z3SettingsManagerLocationWarnTag) {
           isOn = [[Z3SettingsManager sharedInstance] locationWarn];
        }else {
            isOn = [[Z3SettingsManager sharedInstance] locationSimulate];
        }
        [switchView setOn:isOn animated:true];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
       cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     Z3SettingItem *item = self.dataSource[indexPath.section][indexPath.row];
//    if ([item.title isEqualToString:LocalizedString(@"clear cache")]) {
//        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
////        // 清空缓存
//        [cache.memoryCache removeAllObjects];
//        // 清空磁盘缓存，带进度回调
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//       hud.mode = MBProgressHUDModeDeterminate;
//        [cache.diskCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
//           float progress = removedCount / (float)totalCount;
//           hud.progress = progress;
//        } endBlock:^(BOOL error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hideAnimated:YES];
//                [MBProgressHUD showSuccess:LocalizedString(@"clear cache success")];
//            });
//        }];
//    }
}






#pragma mark - getter and setter method

@end
