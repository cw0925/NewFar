//
//  JurisdictionViewController.m
//  NewFarSoft
//
//  Created by CW on 16/8/24.
//  Copyright © 2016年 NewFar. All rights reserved.
//

#import "JurisdictionViewController.h"

@interface JurisdictionViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JurisdictionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"选择权限" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
}
- (void)initUI
{
    UITableView *jurisdiceTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    jurisdiceTable.delegate = self;
    jurisdiceTable.dataSource = self;
    [self.view addSubview:jurisdiceTable];
    [jurisdiceTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"jurisdiceCell"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"jurisdiceCell"];
    cell.textLabel.font = [UIFont systemFontWithSize:14];
    cell.detailTextLabel.font = [UIFont systemFontWithSize:12];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"jurisdiceCell" forIndexPath:indexPath];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"公开";
        cell.detailTextLabel.text = @"所有朋友可见";
    }else //if(indexPath.row == 1)
    {
        cell.textLabel.text = @"私密";
        cell.detailTextLabel.text = @"仅自己可见";
    }
//    else if(indexPath.row == 1)
//    {
//        cell.textLabel.text = @"部分可见";
//        cell.detailTextLabel.text = @"选中的朋友可见";
//    }else
//    {
//        cell.textLabel.text = @"不给谁看";
//        cell.detailTextLabel.text = @"选中的朋友不可见";
//    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.returnLimitBlock!= nil) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                self.returnLimitBlock(@"公开");
            }else{
                 self.returnLimitBlock(@"私密");
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 反向传回位置信息
- (void)returnLimit:(ReturnLimitBlock)block
{
    self.returnLimitBlock = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
