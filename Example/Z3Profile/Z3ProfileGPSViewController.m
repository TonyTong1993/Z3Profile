//
//  ProfileGPSStateViewController.m
//  OutWork
//
//  Created by ZZHT on 2018/5/22.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import "Z3ProfileGPSViewController.h"
#import "Z3GPSRecordsViewController.h"
#import "Z3SettingItem.h"
#import "Z3LocationBean.h"
#import "Z3LocationManager.h"
#import "Z3Common.h"
#import "CoorTranUtil.h"
#import "Z3MobileConfig.h"
#import "UIColor+Z3.h"
#import "Z3Theme.h"
@interface Z3ProfileGPSViewController ()

@end
@implementation Z3ProfileGPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
}

-(void)initDataSource {
    self.dataSource = [Z3SettingItem loadSettingItemsWithPlistName:@"profile_gps_status.plist"];
    CLLocation *location = [Z3LocationManager manager].location;
    if (location == nil) {
        [self showToast:@"暂未获取到位置信息"];
    }
    [self updateLocation:location];
}

- (void)updateLocation:(CLLocation *)lastLocation {
    double latitude = lastLocation.coordinate.latitude;
    double longitude = lastLocation.coordinate.longitude;
    double accuracy = lastLocation.horizontalAccuracy;
    CoorTranUtil *coorTrans = [Z3MobileConfig shareConfig].coorTrans;
    CGPoint point = [coorTrans CoorTrans:latitude lon:longitude height:0];
    double lastX = point.x;
    double lastY = point.y;
    NSString *lastUpdateDateStr = @"";//[[NSUserDefaults standardUserDefaults] stringForKey:Z3CommonLastUploadLocationsDateKey];
    NSInteger count = 10;//[[NSUserDefaults standardUserDefaults] integerForKey:Z3CommonLastUploadLocationsCountKey];
    Z3SettingItem *item = self.dataSource[0][0];
    item.subTitle = [NSString stringWithFormat:@"%lf",longitude];
    item = self.dataSource[0][1];
    item.subTitle = [NSString stringWithFormat:@"%lf",latitude];
    item = self.dataSource[0][2];
    item.subTitle = [NSString stringWithFormat:@"%lf",accuracy];
    item = self.dataSource[0][4];
    item.subTitle = [NSString stringWithFormat:@"%lf",lastX];
    item = self.dataSource[0][5];
    item.subTitle = [NSString stringWithFormat:@"%lf",lastY];
    item = self.dataSource[0][6];
    item.subTitle = lastUpdateDateStr;
    item = self.dataSource[0][7];
    item.subTitle = [NSString stringWithFormat:@"%ld",count];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

static NSString *reuseIdentifier = @"GPS-UITableViewCell";
static NSString *subTitleReuseIdentifier = @"GPS-SubTitleTableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (indexPath.section == 0) {
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        }
    }else {
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:subTitleReuseIdentifier];
            cell.textLabel.textColor = [UIColor colorWithHex:separatorColorHex];
            cell.detailTextLabel.textColor = [UIColor colorWithHex:textSecondary];
        }
    }
    
    Z3SettingItem *item = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    cell.accessoryType = (UITableViewCellAccessoryType)item.accessoryType;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return 20.0f;
    }
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 0) {
        Z3GPSRecordsViewController *recordsVC = [[Z3GPSRecordsViewController alloc] init];
        recordsVC.state = indexPath.row == 0 ? 1 : 0;
        Z3SettingItem *item = self.dataSource[indexPath.section][indexPath.row];
        NSString *title =  indexPath.row == 0 ? @"所有历史记录" : item.title;
        recordsVC.navigationItem.title = title;
        [self.navigationController pushViewController:recordsVC animated:YES];
    }
}


@end
