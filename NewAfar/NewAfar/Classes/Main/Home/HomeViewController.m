//
//  HomeViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/19.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "HomeViewController.h"
#import "ScrollModel.h"
#import "CycleScrollView.h"
#import "HomeCollectionCell.h"
#import "DataStatementViewController.h"
#import "ManageViewController.h"
#import "ComplainViewController.h"
#import "CompanyReportViewController.h"
#import "RemindBirthdayViewController.h"
#import "QuotationViewController.h"
#import "ShareViewController.h"
#import "RetailInfoViewController.h"
#import "CustomerServiceViewController.h"
#import "WorkLogViewController.h"
#import "FeedbackViewController.h"

#import "WonderfulViewController.h"

#import "CategoryModel.h"
#import "MeasureModel.h"
#import "ClassificationModel.h"
#import "CompensateModel.h"

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bg_Scroll;
@property (weak, nonatomic) IBOutlet UIView *bg_Collection;
@property(nonatomic,copy)NSMutableArray *scrollArr;

@property(nonatomic,copy)NSMutableArray *organizationArr;
@property(nonatomic,copy)NSMutableArray *categoryArr;
@property(nonatomic,copy)NSMutableArray *measureArr;
@property(nonatomic,copy)NSMutableArray *classificationArr;
@property(nonatomic,copy)NSMutableArray *compensateArr;

@end

@implementation HomeViewController
{
    CycleScrollView *cycleScroll;
    NSString *string;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"管翼通2.0" hasLeft:NO hasRight:NO withRightBarButtonItemImage:nil];
    [self.view makeToast:@"登录成功！" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self sendRequestScrollViewData];
    [self showCollectionView];

    [self sendRequestConditionData:@"5"];
    [self sendRequestConditionData:@"7"];
    [self sendRequestConditionData:@"9"];
    [self sendRequestConditionData:@"10"];
    [self sendRequestConditionData:@"11"];
}
- (void)initUI
{
    cycleScroll = [[CycleScrollView alloc]init];
    cycleScroll.iconArr = _scrollArr;
    [cycleScroll createScrollView:_bg_Scroll];
}
- (void)showCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;//最小行间距(当垂直布局时是行间距，当水平布局时可以理解为列间距)
    layout.minimumInteritemSpacing = 10;//两个单元格之间的最小间距
    UICollectionView *homeCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,ViewWidth,ViewHeight-CGRectGetHeight(_bg_Scroll.frame)-64-47) collectionViewLayout:layout];
    homeCollection.delegate = self;
    homeCollection.dataSource = self;
    homeCollection.backgroundColor = [UIColor whiteColor];
    homeCollection.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [_bg_Collection addSubview:homeCollection];
    [homeCollection registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"homeCell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}
//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 30,0, 30);
}
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ViewWidth-40)/4, (ViewWidth-40)/4+20);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeCell" forIndexPath:indexPath];
    [cell configCollectionCell:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([userDefault boolForKey:@"bind"]) {
        switch (indexPath.item) {
            case 0://报表中心
            {
                if ([userDefault boolForKey:@"sjbb"]) {
                    DataStatementViewController *data = [[DataStatementViewController alloc]init];
                    data.hidesBottomBarWhenPushed = YES;
                    PushController(data)
                }else{
                    [self.view makeToast:@"您尚未开通数据报表的功能" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                }
            }
                break;
            case 1://企业公告
            {
                if ([userDefault boolForKey:@"qygg"]) {
                    CompanyReportViewController *company = [[CompanyReportViewController alloc]init];
                    company.hidesBottomBarWhenPushed = YES;
                    PushController(company)
                }else{
                    [self.view makeToast:@"您尚未开通企业公告的功能"duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                }
            }
                break;
            case 3://巡场管理
            {
                if ([userDefault boolForKey:@"xcgl"]) {
                    ManageViewController *manage = [[ManageViewController alloc]init];
                    manage.data1 = _organizationArr;
                    manage.data2 = _measureArr;
                    manage.data3 = _categoryArr;
                    manage.data4 = @[@"状态",@"未处理",@"已处理"];
                    manage.hidesBottomBarWhenPushed = YES;
                    if (_organizationArr.count<=0||_measureArr.count<=0||_categoryArr.count<=0) {
                        [self.view makeToast:@"请稍候，数据请求未完成！" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                    }else{
                        PushController(manage)
                    }
                }else{
                    [self.view makeToast:@"您尚未开通巡场管理的功能" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                }
            }
                break;
            case 4://客诉管理
            {
                if ([userDefault boolForKey:@"kscl"]) {
                    ComplainViewController *complain = [[ComplainViewController alloc]init];
                    complain.data1 = _organizationArr;
                    complain.data2 = _classificationArr;
                    complain.data3 = _compensateArr;
                    complain.data4 = @[@"状态",@"已处理"];
                    complain.hidesBottomBarWhenPushed = YES;
                    if (_organizationArr.count<=0||_classificationArr.count<=0||_compensateArr.count<=0) {
                        [self.view makeToast:@"请稍候，数据请求未完成！" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                    }else{
                        PushController(complain)
                    }
                }else{
                    [self.view makeToast:@"您尚未开通客诉处理的功能" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                }
            }
                break;
            case 6://谏言反馈
            {
                if ([userDefault boolForKey:@"jyfk"]) {
                    FeedbackViewController *feedback = StoryBoard(@"Modify", @"feedback")
                    feedback.hidesBottomBarWhenPushed = YES;
                    PushController(feedback)
                }else{
                    [self.view makeToast:@"您尚未开通谏言反馈的功能"duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                }
            }
                break;
            default:
                break;
        }
    }else{
        if (indexPath.item == 0||indexPath.item == 1||indexPath.item ==3||indexPath.item == 4||indexPath.item == 6) {
            [self.view makeToast:[userDefault valueForKey:@"msg"] duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
        }
    }
    if (indexPath.item == 2) {//精彩分享
        if ([userDefault boolForKey:@"jcfx"]) {
            //        WonderfulViewController *wonder = [[WonderfulViewController alloc]init];
            //        wonder.hidesBottomBarWhenPushed = YES;
            ShareViewController *share = [[ShareViewController alloc]init];
            share.hidesBottomBarWhenPushed = YES;
            PushController(share)
        }else{
            [self.view makeToast:@"您尚未开通精彩分享的功能"duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
        }
    }else if (indexPath.item == 5){//工作日志
        if ([userDefault boolForKey:@"gzrz"]) {
            WorkLogViewController *log = [[WorkLogViewController alloc]init];
            log.hidesBottomBarWhenPushed = YES;
            PushController(log)
        }else{
            [self.view makeToast:@"您尚未开通工作日志的功能"duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
        }

    }else if (indexPath.item == 7){//生日提醒
        if ([userDefault boolForKey:@"srtx"]) {
            RemindBirthdayViewController *remind = [[RemindBirthdayViewController alloc]init];
            remind.hidesBottomBarWhenPushed = YES;
            PushController(remind)
        }else{
            [self.view makeToast:@"您尚未开通生日提醒的功能"duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
        }
    }else if (indexPath.item == 8){//零售资讯
        if ([userDefault boolForKey:@"lszx"]) {
            RetailInfoViewController *retail = [[RetailInfoViewController alloc]init];
            retail.hidesBottomBarWhenPushed = YES;
            PushController(retail)
        }else{
            [self.view makeToast:@"您尚未开通零售资讯的功能"duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 加载巡场、客诉下拉菜单数据，如果数据请求未完成跳转巡场、客诉界面会造成应用崩溃
- (void)sendRequestConditionData:(NSString *)querytype
{
    NSString *qyno = [userDefault valueForKey:@"qyno"];
//    NSString *company = [qyno substringToIndex:3];
//    NSLog(@"%@",company);
    //加载用户下属的所有机构
    if ([querytype isEqualToString:@"10"]) {
        NSString *str = @"<root><api><querytype>10</querytype><query>{storetype=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
        
        string = [NSString stringWithFormat:str,[userDefault valueForKey:@"storetype"],qyno,[userDefault valueForKey:@"name"]];
    }
    //巡场类型-5,巡场措施-7,客诉类别-9,客诉方案-8
    if ([querytype isEqualToString:@"5"]||[querytype isEqualToString:@"7"]||[querytype isEqualToString:@"9"]||[querytype isEqualToString:@"11"]) {
        NSString *str = @"<root><api><querytype>%@</querytype><query>{store=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
        string = [NSString stringWithFormat:str,querytype,qyno,qyno,[userDefault valueForKey:@"name"]];
    }
    [NetRequest sendRequest:LoadInfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        NSLog(@"doc:%@",doc);
        if ([querytype isEqualToString:@"5"]) {
            for (DDXMLElement *element in rowArr) {
                CategoryModel *model = [[CategoryModel alloc]init];
                DDXMLElement *tname = [element elementsForName:@"tname"][0];
                model.tname = tname.stringValue;
                DDXMLElement *tid = [element elementsForName:@"tid"][0];
                model.tid = tid.stringValue;
                [self.categoryArr addObject:model];
            }
            CategoryModel *model = [[CategoryModel alloc]init];
            model.tid = @"";
            model.tname = @"类型";
            [self.categoryArr insertObject:model atIndex:0];
            NSLog(@"-------------5类型:%lu",(unsigned long)self.categoryArr.count);
        }
        if ([querytype isEqualToString:@"7"]) {
            for (DDXMLElement *element in rowArr) {
                MeasureModel *model = [[MeasureModel alloc]init];
                DDXMLElement *name = [element elementsForName:@"name"][0];
                model.name = name.stringValue;
                DDXMLElement *ID = [element elementsForName:@"id"][0];
                model.ID = ID.stringValue;
                [self.measureArr addObject:model];
            }
            MeasureModel *model = [[MeasureModel alloc]init];
            model.ID = @"";
            model.name = @"措施";
            [self.measureArr insertObject:model atIndex:0];
            NSLog(@"-------------7措施:%lu",(unsigned long)self.measureArr.count);
        }
        if ([querytype isEqualToString:@"9"]) {
            for (DDXMLElement *element in rowArr) {
                ClassificationModel *model = [[ClassificationModel alloc]init];
                DDXMLElement *tname = [element elementsForName:@"tname"][0];
                model.tname = tname.stringValue;
                DDXMLElement *tid = [element elementsForName:@"tid"][0];
                model.tid = tid.stringValue;
                [self.classificationArr addObject:model];
            }
            ClassificationModel *model = [[ClassificationModel alloc]init];
            model.tid = @"";
            model.tname = @"原因";
            [self.classificationArr insertObject:model atIndex:0];
            NSLog(@"-------------9原因:%lu",(unsigned long)self.classificationArr.count);
        }

        if ([querytype isEqualToString:@"10"]) {
            for (DDXMLElement *element in rowArr) {
                DDXMLElement *name = [element elementsForName:@"name"][0];
                NSArray *arr = [name.stringValue componentsSeparatedByString:@","];
                [self.organizationArr addObjectsFromArray:arr];
            }
            [self.organizationArr insertObject:@"机构" atIndex:0];
            NSLog(@"-------------10机构:%lu",(unsigned long)self.organizationArr.count);
        }
        if ([querytype isEqualToString:@"11"]) {
            for (DDXMLElement *element in rowArr) {
                CompensateModel *model = [[CompensateModel alloc]init];
                DDXMLElement *tid = [element elementsForName:@"tid"][0];
                model.tid = tid.stringValue;
                DDXMLElement *tname = [element elementsForName:@"tname"][0];
                model.tname = tname.stringValue;
                [self.compensateArr addObject:model];
            }
            CompensateModel *model = [[CompensateModel alloc]init];
            model.tid = @"";
            model.tname = @"补偿类型";
            [self.compensateArr insertObject:model atIndex:0];
            NSLog(@"-------------11补偿:%lu",(unsigned long)self.compensateArr.count);
        }
    } failure:^(NSError *error) {
        
    }];
}
//轮播图数据
- (void)sendRequestScrollViewData
{
    [NetRequest sendRequest:InfoURL parameters:ScrollXML success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        for (DDXMLElement *element in rowArr) {
            ScrollModel *model = [[ScrollModel alloc]init];
            DDXMLElement *path = [element elementsForName:@"path"][0];
            model.path = path.stringValue;
            DDXMLElement *url = [element elementsForName:@"url"][0];
            model.url = url.stringValue;
            [self.scrollArr addObject:model];
        }
        [self initUI];
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)organizationArr
{
    if (!_organizationArr) {
        _organizationArr = [NSMutableArray array];
    }
    return _organizationArr;
}
- (NSMutableArray *)categoryArr
{
    if (!_categoryArr) {
        _categoryArr = [NSMutableArray array];
    }
    return _categoryArr;
}
- (NSMutableArray *)measureArr
{
    if (!_measureArr) {
        _measureArr = [NSMutableArray array];
    }
    return _measureArr;
}
- (NSMutableArray *)classificationArr
{
    if (!_classificationArr) {
        _classificationArr = [NSMutableArray array];
    }
    return _classificationArr;
}

- (NSMutableArray *)scrollArr
{
    if (!_scrollArr) {
        _scrollArr = [NSMutableArray array];
    }
    return _scrollArr;
}
- (NSMutableArray *)compensateArr
{
    if (!_compensateArr) {
        _compensateArr = [NSMutableArray array];
    }
    return _compensateArr;
}
@end
