//
//  WorkViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/21.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "WorkViewController.h"
#import "HomeCollectionCell.h"
#import "WorkLogViewController.h"
#import "DataStatementViewController.h"
#import "ManageViewController.h"
#import "ComplainViewController.h"
#import "CompanyReportViewController.h"
#import "RemindBirthdayViewController.h"
#import "QuotationViewController.h"
#import "ShareViewController.h"
#import "RetailInfoViewController.h"
#import "CustomerServiceViewController.h"
#import "FeedbackViewController.h"

#import "CategoryModel.h"
#import "MeasureModel.h"
#import "ClassificationModel.h"
#import "CompensateModel.h"

@interface WorkViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,copy)NSMutableArray *organizationArr;
@property(nonatomic,copy)NSMutableArray *categoryArr;
@property(nonatomic,copy)NSMutableArray *measureArr;
@property(nonatomic,copy)NSMutableArray *classificationArr;
@property(nonatomic,copy)NSMutableArray *compensateArr;

@end

@implementation WorkViewController
{
    NSString *string;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"工作" hasLeft:NO hasRight:NO withRightBarButtonItemImage:nil];
    
    [self createUI];
    
    [self sendRequestConditionData:@"5"];
    [self sendRequestConditionData:@"7"];
    [self sendRequestConditionData:@"11"];
    [self sendRequestConditionData:@"9"];
    [self sendRequestConditionData:@"10"];
}
- (void)createUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;//最小行间距(当垂直布局时是行间距，当水平布局时可以理解为列间距)
    layout.minimumInteritemSpacing = 10;//两个单元格之间的最小间距
    UICollectionView *workCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,ViewWidth,ViewHeight) collectionViewLayout:layout];
    workCollection.delegate = self;
    workCollection.dataSource = self;
    //homeCollection.scrollEnabled = NO;
    workCollection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:workCollection];
    [workCollection registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"logCell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}
//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 20,0, 20);
}
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ViewWidth-40)/4, (ViewWidth-40)/4+20);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArr = @[@"报表中心",@"巡场管理",@"客诉处理",@"工作日志",@"谏言反馈"];
    NSArray *imgArr = @[@"data",@"manage",@"complain",@"worklog",@"feedback"];
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"logCell" forIndexPath:indexPath];
    cell.title.font = [UIFont systemFontWithSize:13];
    cell.title.text = titleArr[indexPath.item];
    cell.pic.image = [UIImage imageNamed:imgArr[indexPath.item]];
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
            case 1://巡场管理
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
            case 2://客诉处理
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
            case 4://谏言反馈
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
        [self.view makeToast:[userDefault valueForKey:@"msg"] duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
    }
    
    if (indexPath.item == 3) {
        if ([userDefault boolForKey:@"gzrz"]) {
            WorkLogViewController *log = [[WorkLogViewController alloc]init];
            log.hidesBottomBarWhenPushed = YES;
            PushController(log)
        }else{
            [self.view makeToast:@"您尚未开通工作日志的功能"duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
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
- (NSMutableArray *)organizationArr
{
    if (!_organizationArr) {
        _organizationArr = [NSMutableArray array];
    }
    return _organizationArr;
}
- (NSMutableArray *)compensateArr
{
    if (!_compensateArr) {
        _compensateArr = [NSMutableArray array];
    }
    return _compensateArr;
}
@end
