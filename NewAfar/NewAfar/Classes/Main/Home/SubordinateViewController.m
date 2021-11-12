//
//  SubordinateViewController.m
//  NewAfar
//
//  Created by CW on 2017/4/7.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "SubordinateViewController.h"
#import "PhotosContainerView.h"
#import "GregorianCalendarViewController.h"
#import "ReadModel.h"

#define BtnW (ViewWidth-70)/6

@interface SubordinateViewController ()

@property(nonatomic,copy)NSMutableArray *readArr;

@end

@implementation SubordinateViewController
{
    UILabel *week;
    UILabel *day;
    UILabel *dateLabel;
    
    UIScrollView *scroll;
    UILabel *titleLabel;
    PhotosContainerView *photosContainer;
    UILabel *commitDate;
    
    UILabel *read;
    UIView *bgView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:[NSString stringWithFormat:@"%@的日志",_name] hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
    [self sendRequestLogData:_date];
    [self sendRequestHadReadData];
}
- (void)initUI{
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, ViewWidth, 200)];
    imv.image = [UIImage imageNamed:@"lunbo"];
    [self.view addSubview:imv];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 130, 60, 60)];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    [imv addSubview:view];
    
    NSArray *arr = [_date componentsSeparatedByString:@" "];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *currentDate = [dateFormatter dateFromString:arr[0]];
    
    NSArray *dateArr = [arr[0] componentsSeparatedByString:@"-"];
    
    week = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    week.textAlignment = NSTextAlignmentCenter;
    week.backgroundColor = RGBColor(35, 55, 90);
    week.font = [UIFont systemFontOfSize:12];
    week.text = [self weekdayStringFromDate:currentDate];
    week.textColor = [UIColor whiteColor];
    [view addSubview:week];
    
    day = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 60, 20)];
    day.textAlignment = NSTextAlignmentCenter;
    day.font = [UIFont systemFontOfSize:14];
    day.text = dateArr[2];
    [view addSubview:day];
    
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 60, 20)];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont systemFontOfSize:10];
    dateLabel.text = [NSString stringWithFormat:@"%@年%@月",dateArr[0],dateArr[1]];
    [view addSubview:dateLabel];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureClick:)];
    imv.userInteractionEnabled = YES;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:gesture];
    
    scroll = [UIScrollView new];
    [self.view addSubview:scroll];
    
    scroll.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(imv,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    
    UILabel *tip = [UILabel new];
    tip.text = @"  工作记录";
    tip.font = [UIFont systemFontWithSize:12];
    
    titleLabel = [UILabel new];
    
    titleLabel.font = [UIFont systemFontWithSize:12];
    
    photosContainer = [[PhotosContainerView alloc] initWithMaxItemsCount:9];
    
    commitDate = [UILabel new];
    commitDate.textAlignment = NSTextAlignmentRight;
    
    commitDate.textColor = RGBColor(112, 110, 110);
    commitDate.font = [UIFont systemFontWithSize:10];
    
    read = [UILabel new];
    read.font = [UIFont systemFontWithSize:12];
    //read.backgroundColor = [UIColor redColor];
    
    bgView = [UIView new];
    //bgView.backgroundColor = [UIColor redColor];

    [scroll sd_addSubviews:@[tip,titleLabel,photosContainer,commitDate,read,bgView]];
    
    tip.sd_layout.leftSpaceToView(scroll,0).topSpaceToView(scroll,0).rightSpaceToView(scroll,0).heightIs(40);
    
    titleLabel.sd_layout.leftSpaceToView(scroll,10).topSpaceToView(tip,0).rightSpaceToView(scroll,10).autoHeightRatio(0);
    
    photosContainer.sd_layout.leftSpaceToView(scroll,10).topSpaceToView(titleLabel,10).rightSpaceToView(scroll,10);
}
- (void)gestureClick:(UITapGestureRecognizer *)gesture{
    GregorianCalendarViewController *calendar = [[GregorianCalendarViewController alloc]init];
    [calendar returnDate:^(NSString *date) {
        //choseDate = date;
        //设置转换格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        //NSString转NSDate
        NSDate *dateS = [formatter dateFromString:date];
        NSLog(@"转换前%@-装换后%@",date,dateS);
        week.text = [self weekdayStringFromDate:dateS];
        NSArray *arr = [date componentsSeparatedByString:@"-"];
        day.text = arr[2];
        dateLabel.text = [NSString stringWithFormat:@"%@年%@月",arr[0],arr[1]];
        NSLog(@"%@-%@",date,[self weekdayStringFromDate:dateS]);
        NSString *curDate = [formatter stringFromDate:[NSDate date]];
        NSDate *cur = [formatter dateFromString:curDate];
        NSComparisonResult result = [dateS compare:cur];
        if (result == NSOrderedDescending) {
            NSLog(@"之后");
            titleLabel.text = @"无记录";
            photosContainer.photoNamesArray = nil;
            commitDate.text = @"";
            read.hidden = YES;
            bgView.hidden = YES;
        }else{
            NSLog(@"之前或当天");
            read.hidden = NO;
            bgView.hidden = NO;
            [self sendRequestLogData:date];
            [self sendRequestHadReadData];
        }
    }];
    PushController(calendar)
}
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendRequestLogData:(NSString *)date{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><module>1503</module><type>0</type><query>{time=%@,readno=%@,readertel=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,date,_reader,_phone,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                read.hidden = NO;
                bgView.hidden = NO;
                //edit.hidden = YES;
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DDXMLElement *nr = [item elementsForName:@"nr"][0];
                    titleLabel.text = [NSString stringWithFormat:@"  %@",nr.stringValue];
                    DDXMLElement *tp = [item elementsForName:@"tp"][0];
                    if (![tp.stringValue isEqualToString:@"0"]) {
                        NSLog(@"有图");
                        NSArray *arr = [tp.stringValue componentsSeparatedByString:@","];
                        
                        photosContainer.photoNamesArray = arr;
                        
                        photosContainer.hidden = NO;
                        
                        commitDate.sd_layout.leftSpaceToView(scroll,10).topSpaceToView(photosContainer,5).rightSpaceToView(scroll,10).heightIs(30);
                    }else{
                        NSLog(@"无图");
                        photosContainer.hidden = YES;
                        commitDate.sd_layout.leftSpaceToView(scroll,10).topSpaceToView(titleLabel,5).rightSpaceToView(scroll,10).heightIs(30);
                    }
                    
                    DDXMLElement *date = [item elementsForName:@"date"][0];
                    commitDate.text = [NSString stringWithFormat:@"编辑时间：%@",date.stringValue];
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }else{
                titleLabel.text = @"无记录";
                photosContainer.photoNamesArray = nil;
                commitDate.text = @"";
                
                commitDate.sd_layout.leftSpaceToView(scroll,10).topSpaceToView(titleLabel,5).rightSpaceToView(scroll,10).heightIs(30);
                read.hidden = YES;
                bgView.hidden = YES;
            }
            read.sd_layout.leftSpaceToView(scroll,10).topSpaceToView(commitDate,10).rightSpaceToView(scroll,10).heightIs(30);
            bgView.sd_layout.leftSpaceToView(scroll,0).topSpaceToView(read,10).rightSpaceToView(scroll,0);
             [scroll setupAutoContentSizeWithBottomView:bgView bottomMargin:10];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
//已读
- (void)sendRequestHadReadData{
    for (UIView *view in bgView.subviews) {
        [view removeFromSuperview];
    }
    NSString *str = @"<root><api><module>1505</module><type>0</type><query>{newid=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_newid,[userDefault valueForKey:@"name"],UUID];
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    ReadModel *model = [[ReadModel alloc]init];
                    DDXMLElement *c_real_name = [item elementsForName:@"c_real_name"][0];
                    model.c_real_name = c_real_name.stringValue;
                    DDXMLElement *tx = [item elementsForName:@"tx"][0];
                    model.tx = tx.stringValue;
                    [self.readArr addObject:model];
                }
            }
        }
        //已读
        if (self.readArr.count >0) {
            read.text = [NSString stringWithFormat:@"已读%lu人",(unsigned long)self.readArr.count];
        UIView *lastView = [[UIView alloc]init];
            for (NSInteger i = 0; i<_readArr.count; i++) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10*(i%6+1)+BtnW*(i%6), 10*(i/6+1)+(BtnW+30)*(i/6), BtnW, BtnW+30)];
                //view.backgroundColor = [UIColor greenColor];
        
                [bgView addSubview:view];
                
                if (i == self.readArr.count-1) {
                    lastView = view;
                }
                ReadModel *model = _readArr[i];
                UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, BtnW, BtnW)];
                [icon sd_setImageWithURL:[NSURL URLWithString:model.tx] placeholderImage:[UIImage imageNamed:@"avatar_zhixing"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    icon.image = [image circleImage];
                }];
                [view addSubview:icon];
                
                UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, BtnW, BtnW, 30)];
                name.text = model.c_real_name;
                name.textAlignment = NSTextAlignmentCenter;
                name.font = [UIFont systemFontWithSize:12];
                [view addSubview:name];
            }
            [bgView setupAutoHeightWithBottomView:lastView bottomMargin:10];
        }else{
            read.text = @"已读0人";
            [scroll setupAutoContentSizeWithBottomView:read bottomMargin:10];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)readArr{
    if (!_readArr) {
        _readArr = [NSMutableArray array];
    }
    return _readArr;
}
@end
