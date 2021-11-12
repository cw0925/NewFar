//
//  FriendSettingViewController.m
//  NewAfar
//
//  Created by cw on 17/3/20.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "FriendSettingViewController.h"
#import "FriendSettingCell.h"

@interface FriendSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FriendSettingViewController
{
    UITableView *settingTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"好友设置" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)initUI{
    settingTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    settingTable.delegate = self;
    settingTable.dataSource = self;
    settingTable.sectionHeaderHeight = 0;
    settingTable.sectionFooterHeight = 10;
    settingTable.rowHeight = 50;
    [self.view addSubview:settingTable];
    [settingTable registerNib:[UINib nibWithNibName:@"FriendSettingCell" bundle:nil] forCellReuseIdentifier:@"settingCell"];
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    settingTable.tableHeaderView = head;
    
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 50)];
    settingTable.tableFooterView = foot;
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    delete.frame = CGRectMake(20, 5, ViewWidth-40, 40);
    delete.layer.cornerRadius = 5;
    delete.layer.masksToBounds = YES;
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    delete.backgroundColor = RGBColor(198, 65, 68);
    [delete addTarget:self action:@selector(deleteFriendClick:) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:delete];
    
}
- (void)deleteFriendClick:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除联系人" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self sendDeleteFriendData];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = @[@"不让他看我的职场圈",@"不看他的职场圈"];
    cell.title.text = arr[indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//iflook 0 表示允许查看  1表示不允许
            NSLog(@"%@",_model.iflook);
            if ([_model.iflook isEqualToString:@"1"]) {
                cell.turn.on = YES;
            }else{
                cell.turn.on = NO;
            }
            [cell.turn addTarget:self action:@selector(monitorValueChange:) forControlEvents:UIControlEventValueChanged];
        }else{
            //NSLog(@"%@",_model.gztype);gztype 1关注 0 不关注
            if ([_model.gztype isEqualToString:@"1"]) {
                cell.turn.on = NO;
            }else{
                cell.turn.on = YES;
            }
            [cell.turn addTarget:self action:@selector(prohibitOther:) forControlEvents:UIControlEventValueChanged];
        }
    }
    return cell;
}
//不让他看我的职场圈
- (void)monitorValueChange:(UISwitch *)sender{
    if (sender.on) {// 1 表示不允许查看  0表示可以
        NSLog(@"--------1");
        [self sendProhibitData:@"1"];
    }else{
        NSLog(@"--------2");
        [self sendProhibitData:@"0"];
    }
}
//不看他的职场圈
- (void)prohibitOther:(UISwitch *)sender{
    [self sendRequestFoucsData];
}
//删除
- (void)sendDeleteFriendData{
    NSString *str = @"<root><api><module>1106</module><type>0</type><query>{ftel=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_model.tel,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            [self.view makeToast:element.stringValue];
            if ([element.stringValue isEqualToString:@"删除成功！"]) {
                [self.navigationController.viewControllers[0].view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//不让他看我的职场圈power 1 表示不允许查看  0表示可以
- (void)sendProhibitData:(NSString *)power{
    NSString *str = @"<root><api><module>1107</module><type>0</type><query>{ftel=%@,power=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_model.tel,power,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@""]) {
                
            }else
            {
                
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//关注(不看他的职场圈)
- (void)sendRequestFoucsData
{
    NSString *str = @"<root><api><module>1105</module><type>0</type><query>{c_no=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_model.c_no,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        //NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
//        for (DDXMLElement *element in msgArr) {
//            if ([element.stringValue isEqualToString:@"关注成功！"]) {
//                if (sender.selected) {
//                    [self.view makeToast:@"已关注！" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
//                }else{
//                    sender.selected = YES;
//                    [self.view makeToast:@"关注成功！" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
//                }
//            }else if ([element.stringValue isEqualToString:@"已取消！"]){
//                if (sender.selected) {
//                    sender.selected = NO;
//                    [self.view makeToast:@"取消关注！" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
//                }else{
//                    [self.view makeToast:@"未关注！" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
//                }
//            }
       // }
        
    } failure:^(NSError *error) {
        
    }];
}
@end
