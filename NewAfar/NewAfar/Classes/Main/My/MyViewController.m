//
//  MyViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/21.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "MyViewController.h"
#import "SettingViewController.h"
#import "HomeCollectionCell.h"
#import "SectionHeaderView.h"
#import "PersonalInformationViewController.h"
#import "DataStatementViewController.h"
#import "ManageViewController.h"
#import "ComplainViewController.h"
#import "MyPublishViewController.h"
#import "RemindBirthdayViewController.h"
#import "AttentionMeViewController.h"
#import "MyAttentionViewController.h"
#import "ModifyMaterialViewController.h"
#import "WorkLogViewController.h"

#import "CategoryModel.h"
#import "MeasureModel.h"
#import "ClassificationModel.h"
#import "CompensateModel.h"

@interface MyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bg_collection;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *postion;

@property (weak, nonatomic) IBOutlet UIView *bg_info;
//客诉、巡场
@property(nonatomic,copy)NSMutableArray *organizationArr;
@property(nonatomic,copy)NSMutableArray *categoryArr;
@property(nonatomic,copy)NSMutableArray *measureArr;
@property(nonatomic,copy)NSMutableArray *classificationArr;
@property(nonatomic,copy)NSMutableArray *planArr;
@property(nonatomic,copy)NSMutableArray *compensateArr;
@end

@implementation MyViewController
{
    NSString *string;
}
- (void)viewWillAppear:(BOOL)animated
{
    if (_isPop) {
        [self sendRequestPersonalInfoData];
    }
    _isPop = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isPop = NO;
    [self customNavigationBar:@"个人中心" hasLeft:NO hasRight:YES withRightBarButtonItemImage:@"setting"];
    
    [self initUI];
    
    [self sendRequestPersonalInfoData];
    
    [self sendRequestConditionData:@"5"];
    [self sendRequestConditionData:@"7"];
    [self sendRequestConditionData:@"11"];
    [self sendRequestConditionData:@"9"];
    [self sendRequestConditionData:@"10"];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(modifyInfoClick:)];
    _bg_info.userInteractionEnabled = YES;
    [_bg_info addGestureRecognizer:gesture];
}
//- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image
//{
//    self.navigationItem.title = title;
//    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
//    right.frame = CGRectMake(0, 0, 20, 20);
//    [right setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    [right addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
//}
//资料修改
- (void)modifyInfoClick:(UITapGestureRecognizer *)gesture{
    ModifyMaterialViewController *material = StoryBoard(@"Modify", @"material");
    material.hidesBottomBarWhenPushed = YES;
    PushController(material)
}
//系统设置
- (void)rightBarClick
{
    SettingViewController *setting = [[SettingViewController alloc]init];
    setting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setting animated:YES];
}
- (void)initUI
{
    _icon.userInteractionEnabled = YES;
    _name.userInteractionEnabled = YES;
    _postion.userInteractionEnabled = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;//最小行间距(当垂直布局时是行间距，当水平布局时可以理解为列间距)
    layout.minimumInteritemSpacing = 10;//两个单元格之间的最小间距
    
    UICollectionView *myCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bg_info.frame)+NVHeight, ViewWidth, ViewHeight-CGRectGetHeight(_bg_info.frame)-NVHeight-49) collectionViewLayout:layout];
    myCollection.delegate = self;
    myCollection.dataSource = self;
    myCollection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myCollection];
    
    [myCollection registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"myCell"];
    // 注册头部
    [myCollection registerNib:[UINib nibWithNibName:@"SectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    // 注册尾部
    [myCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
    layout.footerReferenceSize = CGSizeMake(20, 20);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }else
        return 3;
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //宽度随便定，系统会自动取collectionView的宽度
    //高度为分组头的高度
    return CGSizeMake(0, 40);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        SectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
        header.title.backgroundColor = BaseColor;
        header.title.font = [UIFont systemFontWithSize:13];
        if (indexPath.section == 0) {
            header.title.text = @"   工作";
        }else
        {
            header.title.text = @"   朋友";
        }
        return header;
    } else { // 返回每一组的尾部视图
        UICollectionReusableView *footerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot" forIndexPath:indexPath];
        
        //footerView.backgroundColor = [UIColor purpleColor];
        return footerView;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    cell.title.font = [UIFont systemFontWithSize:13];
    if (indexPath.section == 0) {
        NSArray *titleArr = @[@"报表中心",@"巡场管理",@"客诉处理",@"工作日志",@"我的发表",@"个人信息"];
        NSArray *picArr = @[@"data",@"manage",@"complain",@"worklog",@"publish",@"personinfo"];
        cell.pic.image = [UIImage imageNamed:picArr[indexPath.item]];
        cell.title.text = titleArr[indexPath.item];
    }else
    {
        NSArray *titleArr = @[@"生日提醒",@"我关注的",@"关注我的"];
        NSArray *picArr = @[@"birth",@"myattention",@"attention"];
        cell.pic.image = [UIImage imageNamed:picArr[indexPath.item]];
        cell.title.text = titleArr[indexPath.item];
        
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
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
                default:
                    break;
            }
        }else{
            [self.view makeToast:[userDefault valueForKey:@"msg"] duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
        }
        
        if (indexPath.item == 3) {//工作日志
            if ([userDefault boolForKey:@"gzrz"]) {
                WorkLogViewController *log = [[WorkLogViewController alloc]init];
                log.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:log animated:YES];
            }else{
               [self.view makeToast:@"您尚未开通工作日志的功能" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
            }
        }else if (indexPath.item == 4){//我的发表
            MyPublishViewController *public = [[MyPublishViewController alloc]init];
            public.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:public animated:YES];
        }else if (indexPath.item == 5){//个人信息
            PersonalInformationViewController *person = [[PersonalInformationViewController alloc]init];
            person.hidesBottomBarWhenPushed = YES;
            PushController(person)
        }
    }else{
        switch (indexPath.item) {
            case 0://生日提醒
            {
                if ([userDefault boolForKey:@"srtx"]) {
                    RemindBirthdayViewController *remind = [[RemindBirthdayViewController alloc]init];
                    remind.hidesBottomBarWhenPushed = YES;
                    PushController(remind)
                }else{
                    [self.view makeToast:@"您尚未开通生日提醒的功能" duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                }
            }
                break;
            case 1://我关注的
            {
                MyAttentionViewController *my = [[MyAttentionViewController alloc]init];
                my.hidesBottomBarWhenPushed = YES;
                PushController(my)
            }
                break;
            case 2://关注我的
            {
                AttentionMeViewController *me = [[AttentionMeViewController alloc]init];
                me.hidesBottomBarWhenPushed = YES;
                PushController(me)
            }
                break;
            default:
                break;
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
    //NSString *company = [qyno substringToIndex:3];
    //NSLog(@"%@",company);
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
//个人信息
- (void)sendRequestPersonalInfoData
{
    NSString *str = @"<root><api><module>1301</module><type>0</type><query></query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *xml_string = [NSString stringWithFormat:str,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:xml_string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [self.view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                return ;
            }else
            {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    _name.text = name.stringValue;
                    [userDefault setValue:name.stringValue forKey:@"user_name"];
                    [userDefault synchronize];
                    NSLog(@"名字：%@",[userDefault valueForKey:@"user_name"]);
                    DDXMLElement *zw = [item elementsForName:@"zw"][0];
                    _postion.text = zw.stringValue;
                    
                    DDXMLElement *tx = [item elementsForName:@"tx"][0];
                    if ([tx.stringValue isEqualToString:@""]) {
                        _icon.image = [[UIImage imageNamed:@"avatar_zhixing"] circleImage];
                    }else{
                        //设置头像
                        [_icon sd_setImageWithURL:[NSURL URLWithString:tx.stringValue] placeholderImage:[UIImage imageNamed:@"avatar_zhixing.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            _icon.image = [image circleImage];
                        }];
                    }
                }
            }
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
//- (NSMutableArray *)planArr
//{
//    if (!_planArr) {
//        _planArr = [NSMutableArray array];
//    }
//    return _planArr;
//}
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
