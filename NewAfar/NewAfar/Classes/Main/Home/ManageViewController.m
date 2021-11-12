//
//  ManageViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/22.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "ManageViewController.h"
#import "ManageCell.h"
#import "ManageHistoryViewController.h"
#import "CheckManageViewController.h"
#import "ManagingModel.h"
#import "LookManageViewController.h"
#import "RegistManageViewController.h"
#import "CountViewController.h"

#import "DOPDropDownMenu.h"
#import "BaseNavigationController.h"

#import "CategoryModel.h"
#import "MeasureModel.h"

#import "UIButton+LXMImagePosition.h"
//ShareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#define SIZE 20

@interface ManageViewController ()<UITableViewDelegate,UITableViewDataSource,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>

@property (nonatomic, weak) DOPDropDownMenu *menu;
@property(nonatomic,copy)NSMutableArray *dataArr;

@property(nonatomic,copy)NSString *organization_row;
@property(nonatomic,copy)NSString *measure_row;
@property(nonatomic,copy)NSString *type_row;
@property(nonatomic,copy)NSString *statue_row;

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger allPage;
@property(nonatomic,copy)NSString *refreshState;//是否上拉刷新

@property(nonatomic,copy)NSMutableArray *selectArr;
@property(nonatomic,copy)NSMutableString *selectStr;
@end

@implementation ManageViewController
{
    UITableView *mainTable;
    UIView *bottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"巡场管理" hasLeft:YES hasRight:YES withRightBarButtonItemImage:@""];
    
    [self initTopView];
    
    [self createMainView];
    
    self.refreshState = @"initLoad";
    self.page = 1;
    
    [self updateData];
}
- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image
{
    [super customNavigationBar:title hasLeft:isLeft hasRight:isRight withRightBarButtonItemImage:image];
    if (isRight) {
        UIButton *count = [UIButton buttonWithType:UIButtonTypeCustom];
        count.frame = CGRectMake(0, 0, 40, 30);
        count.titleLabel.font = [UIFont systemFontWithSize:14];
        [count setTitle:@"统计" forState:UIControlStateNormal];
        [count setTitleColor:RGBColor(18,184,246) forState:UIControlStateNormal];
        [count addTarget:self action:@selector(countClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *count_item = [[UIBarButtonItem alloc]initWithCustomView:count];
        
        UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
        edit.frame = CGRectMake(0, 0, 20, 20);
        edit.center = barView.center;
        [edit setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        [edit addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:edit];
        UIBarButtonItem *edit_item = [[UIBarButtonItem alloc]initWithCustomView:barView];
        
        NSArray *items = [NSArray array];
         NSLog([userDefault boolForKey:@"xcwrite"]?@"巡场管理写权限":@"巡场管理没有写权限");
        if ([userDefault boolForKey:@"xcwrite"]) {
            items = @[edit_item,count_item];
        }else{
            items = @[count_item];
        }
        self.navigationItem.rightBarButtonItems = items;
    }
}
- (void)countClick:(UIButton *)sender{
    CountViewController *count = StoryBoard(@"Home", @"count")
    count.isManage = YES;
    PushController(count)
}
//正在巡场
- (void)rightBarClick
{
    if ([userDefault boolForKey:@"xcwrite"]) {
        RegistManageViewController *regist = [[RegistManageViewController alloc]init];
        [regist refresh:^(BOOL isPop) {
             NSLog(isPop?@"返回YES刷新":@"返回NO不刷新");
            [mainTable.mj_header beginRefreshing];
        }];
        PushController(regist)
    }else{
        [self.view makeToast:@"您尚未获得添加巡场的权限" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
    }
}
- (void)initTopView
{
    _organization_row = @"";
    _measure_row = @"";
    _type_row = @"";
    _statue_row = @"";
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, NVHeight) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    _menu = menu;    
    // 创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    //[menu selectDefalutIndexPath];
}
//分栏数目
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 4;
}
//每个栏目的行数
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return _data1.count;
    }else if (column == 1){
        return _data2.count;
    }else if(column == 2){
        return _data3.count;
    }else{
        return _data4.count;
    }
}
//每个栏目的每行的内容
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return _data1[indexPath.row];
    } else if (indexPath.column == 1){
        MeasureModel *model = _data2[indexPath.row];
        return model.name;
    } else  if(indexPath.column == 2){
        CategoryModel *model = _data3[indexPath.row];
        return model.tname;
    }else{
        return _data4[indexPath.row];
    }
}
//展示列点击事件 巡场数据 机构102 措施1 类型1 状态0
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了1: %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了2: %ld - %ld 项目",indexPath.column,indexPath.row);
        if (indexPath.column == 0) {
            NSArray *arr = [_data1[indexPath.row] componentsSeparatedByString:@" "];
            if ([arr[0] isEqualToString:@"机构"]) {
                _organization_row = @"";
            }else{
                _organization_row = arr[0];
            }
        }else if (indexPath.column == 1){
            if (indexPath.row == 0) {
                _measure_row = @"";
            }else{
                MeasureModel *model = _data2[indexPath.row];
                _measure_row  = model.ID;
            }
        }else if (indexPath.column == 2){
            if (indexPath.row == 0) {
                _type_row = @"";
            }else{
                CategoryModel *model = _data3[indexPath.row];
                _type_row = model.tid;
            }
        }else{
            if (indexPath.row == 0) {
                _statue_row = @"";
            }else{
                _statue_row = [NSString stringWithFormat:@"%ld",indexPath.row-1];
            }
        }
        if (self.dataArr.count>0) {
            [self.dataArr removeAllObjects];
            [mainTable reloadData];
        }
        [self sendRequestManageData:_page];
    }
}
//底部
- (void)initBottomView:(BOOL)isEditing
{
    if (bottomView) {
        [bottomView removeFromSuperview];
    }
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight-45-BottomHeight, ViewWidth, 45)];
    [self.view addSubview:bottomView];
    if (isEditing) {
        UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
        share.backgroundColor = [UIColor redColor];
        [share setTitle:@"讲评" forState:UIControlStateNormal];
        [share setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [share addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:share];
        share.sd_layout.leftSpaceToView(bottomView,0).topSpaceToView(bottomView,0).widthIs(ViewWidth/2).bottomSpaceToView(bottomView,0);
        
        UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
        cancle.backgroundColor = [UIColor darkGrayColor];
        [cancle setTitle:@"取消" forState:UIControlStateNormal];
        [cancle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancle addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:cancle];
        cancle.sd_layout.leftSpaceToView(share,0).topSpaceToView(bottomView,0).rightSpaceToView(bottomView,0).bottomSpaceToView(bottomView,0);
    }else{
        bottomView.backgroundColor = RGBColor(246, 246, 246);
        UIButton *hisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hisBtn.frame = CGRectMake(0, 0, ViewWidth, 45);
        [hisBtn addTarget:self action:@selector(manageHistoryClick:) forControlEvents:UIControlEventTouchUpInside];
        [hisBtn setImage:[UIImage imageNamed:@"manageHis"] forState:UIControlStateNormal];
        hisBtn.titleLabel.font = [UIFont systemFontWithSize:14];
        [hisBtn setTitle:@"巡场记录" forState:UIControlStateNormal];
        [hisBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [hisBtn setImagePosition:LXMImagePositionLeft spacing:10];
        [bottomView addSubview:hisBtn];
    }
}
//取消
- (void)cancleClick:(UIButton *)sender{
    mainTable.editing = NO;
    [self initBottomView:mainTable.editing];
    [self.selectArr removeAllObjects];
}
//讲评
- (void)commentClick:(UIButton *)sender{
    if (self.selectArr.count<=0) {
        [self.view makeToast:@"请选择要讲评的巡场记录！"];
    }else{
        [self sendRequestManageComment];
    }
}
//巡场记录
- (void)manageHistoryClick:(UIButton *)sender
{
    ManageHistoryViewController *his = StoryBoard(@"Manage", @"manageHis")
    PushController(his)
}
- (void)createMainView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0,44+NVHeight, ViewWidth, ViewHeight-44-NVHeight-30) style:UITableViewStyleGrouped];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.sectionHeaderHeight = 5;
    mainTable.sectionFooterHeight = 5;
    mainTable.backgroundColor = BaseColor;
    mainTable.editing = NO;
    mainTable.allowsMultipleSelection = YES;
    [self.view addSubview:mainTable];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    mainTable.tableHeaderView = view;
    
    [mainTable registerNib:[UINib nibWithNibName:@"ManageCell" bundle:nil] forCellReuseIdentifier:@"manageCell"];
    
    [self initBottomView:mainTable.editing];
    
    
#pragma mark - MJ刷新
    mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.refreshState = @"drop-down";//下拉状态
        self.page = 1;
        [self updateData];
    }];
    mainTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.refreshState = @"pull";//上拉状态
        if (self.page < _allPage) {
            //_page++;
            _page++;
            [self updateData];
        }else{
            [mainTable.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
}
-(void)endRefresh{
    [mainTable.mj_header endRefreshing];
    [mainTable.mj_footer endRefreshing];
}
- (void)updateData{
    [self sendRequestManageData:_page];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   // NSLog(@"--------------1");
    mainTable.mj_footer.hidden = (_dataArr.count==0);
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"--------------2");
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"--------------3");
    ManagingModel *model = _dataArr[indexPath.section];
    return [mainTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ManageCell class] contentViewWidth:ScreenWidth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"--------------4");
    ManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"manageCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[ManageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"manageCell"];
    }
    cell.model = _dataArr[indexPath.section];
    //长按选择
//    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureClick:)];
//    cell.userInteractionEnabled = YES;
//    [cell addGestureRecognizer:gesture];
    
    return cell;
}
//- (void)gestureClick:(UILongPressGestureRecognizer *)gesture{
//    mainTable.editing = YES;
//    [self initBottomView:mainTable.editing];
//}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"--------------5");
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"--------------6");
    if (tableView.editing) {
        ManagingModel *model = _dataArr[indexPath.section];
        [self.selectArr addObject:model.c_newid];
        NSLog(@"选择:%@",self.selectArr);
    }else{
        LookManageViewController *check = [[LookManageViewController alloc]init];
        ManagingModel *model = _dataArr[indexPath.section];
        check.c_id = model.c_newid;
        [check refresh:^(BOOL isPop) {
            [mainTable.mj_header beginRefreshing];
        }];
        PushController(check)
    }
}
//取消选择cell
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"--------------7");
    if (tableView.editing) {
        ManagingModel *model = _dataArr[indexPath.section];
        [self.selectArr removeObject:model.c_newid];
        NSLog(@"取消：%@",self.selectArr);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//巡场数据 机构102 措施1 类型1 状态0
- (void)sendRequestManageData:(NSInteger)page
{
    if ([_refreshState isEqualToString:@"drop-down"]) {
        [_dataArr removeAllObjects];
        [mainTable reloadData];
    }
    if ([_refreshState isEqualToString:@"initLoad"]) {
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    }
    
    NSString *str = @"<root><api><module>1602</module><type>0</type><query>{store=%@,solution=%@,type=%@,status=%@,page=%d,size=%d}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_organization_row,_measure_row,_type_row,_statue_row,page,SIZE,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
   // NSLog(@"%@",string);
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        //NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [self.view makeToast:element.stringValue];
            }else
            {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    ManagingModel *model = [[ManagingModel alloc]init];
                    DDXMLElement *c_id = [item elementsForName:@"c_id"][0];
                    model.c_id = c_id.stringValue;
                    DDXMLElement *rq = [item elementsForName:@"rq"][0];
                    model.rq = rq.stringValue;
                    DDXMLElement *zt = [item elementsForName:@"zt"][0];
                    model.zt = zt.stringValue;
                    DDXMLElement *type = [item elementsForName:@"type"][0];
                    model.type = type.stringValue;
                    DDXMLElement *clx = [item elementsForName:@"clx"][0];
                    model.clx = clx.stringValue;
                    DDXMLElement *nr = [item elementsForName:@"nr"][0];
                    model.nr = nr.stringValue;
                    DDXMLElement *zrr = [item elementsForName:@"zrr"][0];
                    model.zrr = zrr.stringValue;
                    DDXMLElement *bm = [item elementsForName:@"bm"][0];
                    model.bm = bm.stringValue;
                    if ([item elementsForName:@"fcdate"].count>0) {
                        DDXMLElement *fcdate = [item elementsForName:@"fcdate"][0];
                        model.fcdate = fcdate.stringValue;
                    }else{
                        model.fcdate = @"";
                    }
                    DDXMLElement *xcr = [item elementsForName:@"xcr"][0];
                    model.xcr = xcr.stringValue;
                    DDXMLElement *c_newid = [item elementsForName:@"c_newid"][0];
                    model.c_newid = c_newid.stringValue;
                    //图片字段可能不存在
                    if ([item elementsForName:@"xctp"].count >0) {
                        DDXMLElement *xctp = [item elementsForName:@"xctp"][0];
                        model.xctp = xctp.stringValue;
                    }
                    [self.dataArr addObject:model];
                    
                    NSArray *allpageArr = [doc nodesForXPath:@"//allpage" error:nil];
                    for (DDXMLElement *item in allpageArr) {
                        self.allPage = [item.stringValue integerValue];
                    }
                }
                [mainTable reloadData];
            }
            [self endRefresh];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)sendRequestManageComment{
    if (self.selectArr.count == 1) {
        [self.selectStr appendString:_selectArr[0]];
         }else{
             for (NSString *itemStr in self.selectArr) {
                 [self.selectStr appendFormat:@"%@.",itemStr];
             }
             [self.selectStr deleteCharactersInRange:NSMakeRange(self.selectStr.length-1, 1)];
         }
    NSLog(@"%@",_selectStr);
    NSString *qyno = [userDefault valueForKey:@"qyno"];
    
    NSString *str = @"<root><api><module>1607</module><type>0</type><query>{c_newid=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_selectStr,qyno,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *urlArr = [doc nodesForXPath:@"//url" error:nil];
        if (urlArr.count>0) {
            for (DDXMLElement *item in urlArr) {
                [self shareToOthers:item.stringValue];
                 NSLog(@"%@",item.stringValue);
            }
        }else{
            [self.view makeToast:@"讲评失败！"];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)shareToOthers:(NSString *)url{
    NSLog(@"分享");
    UIImage *image = [UIImage imageNamed:@"placehold.png"];
    NSArray* imageArray = @[image];
    
    if(imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享测试"
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:nil
                                           type:SSDKContentTypeAuto];
               //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformTypeSinaWeibo)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       NSLog(@"%@",error);
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               [ShowAlter showAlertToController:self title:@"分享成功！" message:@"" buttonAction:@"取消" buttonBlock:^{
                                   
                               }];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               [ShowAlter showAlertToController:self title:@"分享失败！" message:@"" buttonAction:@"取消" buttonBlock:^{
                                   
                               }];
                               
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    }
}
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)selectArr
{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}
- (NSMutableString *)selectStr{
    if (!_selectStr) {
        _selectStr = [NSMutableString string];
    }
    return _selectStr;
}
@end
