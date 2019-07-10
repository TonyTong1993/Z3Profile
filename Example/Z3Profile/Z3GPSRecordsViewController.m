//
//  GPSRecordsViewController.m
//  OutWork
//
//  Created by ZZHT on 2019/1/7.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3GPSRecordsViewController.h"
#import "Z3LocationBean.h"
#import "Z3DBManager.h"
#import "Z3User.h"
@interface Z3GPSRecordsViewController ()
@property (nonatomic,assign) NSUInteger limitStartIndex;

@end

@implementation Z3GPSRecordsViewController
#pragma mark - life circle

#pragma mark - view life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self loadGPSPositionBeans];
    self.limitStartIndex = 0;
}

#pragma mark - public method
- (void)initTableView {
    [super initTableView];
    self.tableView.rowHeight = 210.0f;
}
#pragma mark - private metod
- (void)initNavigationBar {
    if (0==self.state) {
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"report",@"上报") style:UIBarButtonItemStylePlain target:self action:@selector(onRightBarButtonItemClicked)];
    }
}

static NSUInteger limitCount = 50;
- (void)loadGPSPositionBeans {
    [[Z3DBManager manager] queryLocationBeansSomeDay:[NSDate date] limitStartIndex:self.limitStartIndex limitCount:limitCount userid:[Z3User shareInstance].uid status:self.state complication:^(NSArray * _Nonnull locations) {
        self.dataSource = locations;
        [self.tableView reloadData];
    }];
}
- (void)onRightBarButtonItemClicked {
    
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

 static NSString *reuseIdentifier = @"UITableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.numberOfLines = 0;
    Z3LocationBean *bean = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [bean description];
    return cell;
}
#pragma mark - getter and setter method

@end
