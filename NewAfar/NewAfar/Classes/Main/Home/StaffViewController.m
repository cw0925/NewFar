//
//  StaffViewController.m
//  NewAfar
//
//  Created by CW on 2017/4/10.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "StaffViewController.h"
#import "StaffModel.h"
#import "StaffCell.h"

@interface StaffViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *selArr;
@property(nonatomic,copy)NSMutableArray *stateArr;

@end

@implementation StaffViewController
{
    UITableView *staffTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"选择联系人" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestStaffData];
}
- (void)initUI{
    staffTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight-40) style:UITableViewStylePlain];
    staffTable.delegate = self;
    staffTable.dataSource = self;
    staffTable.rowHeight = 60;
    [self.view addSubview:staffTable];
    [staffTable registerNib:[UINib nibWithNibName:@"StaffCell" bundle:nil] forCellReuseIdentifier:@"staffCell"];
    staffTable.tableFooterView = [[UIView alloc]init];
    
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight-40-BottomHeight, ViewWidth, 40)];
    foot.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:foot];
    
    UIButton *allSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    allSelect.frame = CGRectMake(0, 0, ViewWidth/2, 40);
    [allSelect setBackgroundColor:[UIColor redColor]];
    [allSelect setTitle:@"全选" forState:UIControlStateNormal];
    [allSelect addTarget:self action:@selector(allselectClick:) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:allSelect];
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    sure.frame = CGRectMake(ViewWidth/2,0, ViewWidth/2, 40);
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:sure];
}
//全选
- (void)allselectClick:(UIButton *)sender{
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {
        //改变这个值
        NSMutableArray *indexArr = [NSMutableArray array];
        
        for (NSInteger i = 0; i<self.stateArr.count; i++) {
            [self.stateArr replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            [indexArr addObject:index];
        }
        
        //刷新视图
        [staffTable reloadRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationAutomatic];
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全不选"]){
        NSMutableArray *indexArr = [NSMutableArray array];
        
        for (NSInteger i = 0; i<self.stateArr.count; i++) {
            [self.stateArr replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            [indexArr addObject:index];
        }
        
        //刷新视图
        [staffTable reloadRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationAutomatic];
        [sender setTitle:@"全选" forState:UIControlStateNormal];
    }
}
- (void)returnName:(ReturnSelectName)block{
    self.returnName = block;
}
//确定
- (void)sureClick:(UIButton *)sender{
    NSLog(@"stateCount:%lu",(unsigned long)self.stateArr.count);
    for (NSInteger i = 0; i<self.stateArr.count; i++) {
        if ([self.stateArr[i] boolValue]) {
            StaffModel *model = self.dataArr[i];
            [self.selArr addObject:model];
        }
    }
    if (self.returnName != nil) {
        self.returnName(self.selArr,self.stateArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StaffCell *cell = [tableView dequeueReusableCellWithIdentifier:@"staffCell" forIndexPath:indexPath];
    StaffModel *model = _dataArr[indexPath.row];
    [cell configCell:model];
    cell.flag.selected = [self.stateArr[indexPath.row] boolValue];
    [cell.flag addTarget:self action:@selector(senderClick:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)senderClick:(UIButton *)sender event:(id)event{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint Position = [touch locationInView:staffTable];
    NSIndexPath *indexPath= [staffTable indexPathForRowAtPoint:Position];
    if (indexPath!= nil)    {
        //这个indexpath就是button后面cell的indexpath
        BOOL isClick = [self.stateArr[indexPath.row] boolValue];
        //改变这个值
        [self.stateArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!isClick]];
        //刷新视图
        [staffTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    NSLog(@"sender点击");
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isClick = [self.stateArr[indexPath.row] boolValue];
    //改变这个值
    [self.stateArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!isClick]];
    //刷新视图
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSLog(@"cell点击");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestStaffData{
    //<root><api><querytype>15</querytype><query>{store=009}</query></api><user><company>009</company><customeruser>15515950185</customeruser></user></root>
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    NSString *str = @"<root><api><querytype>15</querytype><query>{store=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:LoadInfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    StaffModel *model = [[StaffModel alloc]init];
                    DDXMLElement *c_real_name = [item elementsForName:@"c_real_name"][0];
                    model.c_real_name = c_real_name.stringValue;
                    DDXMLElement *c_position = [item elementsForName:@"c_position"][0];
                    model.c_position = c_position.stringValue;
                    DDXMLElement *c_addresszc = [item elementsForName:@"c_addresszc"][0];
                    model.c_addresszc = c_addresszc.stringValue;
                    DDXMLElement *c_no = [item elementsForName:@"c_no"][0];
                    model.c_no = c_no.stringValue;
                    [self.dataArr addObject:model];
                    if (self.indexArr.count >0) {
                        [self.stateArr removeAllObjects];
                        [self.stateArr addObjectsFromArray:self.indexArr];
                    }else{
                        [self.stateArr addObject:[NSNumber numberWithBool:NO]];
                    }
                }
                [staffTable reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }else{
                [self.view makeToast:element.stringValue];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)selArr{
    if (!_selArr) {
        _selArr = [NSMutableArray array];
    }
    return _selArr;
}
- (NSMutableArray *)stateArr{
    if (!_stateArr) {
        _stateArr = [NSMutableArray array];
    }
    return _stateArr;
}
@end
