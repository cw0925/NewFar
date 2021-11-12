//
//  LookManageViewController.m
//  NewAfar
//
//  Created by cw on 16/11/28.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "LookManageViewController.h"
#import "PhotosContainerView.h"

//ShareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#define TextColor RGBColor(112, 110, 110)

@interface LookManageViewController ()<UITextViewDelegate>

@end

@implementation LookManageViewController
{
    PhotosContainerView *_photosContainer;
    
    UIScrollView *scroll;
    UILabel *depart;
    UILabel *people;
    UILabel *type;
    UILabel *style;
    UILabel *managep;
    UILabel *checkp;
    UILabel *statue;
    UILabel *date;
    UILabel *reckonD;
    UILabel *finishD;
    UILabel *manageD;
    UILabel *remark;
    UILabel *remark_con;
    UILabel *managePic;
    UILabel *manage;
    UILabel *manae_con;
    UILabel *handle;
    UITextView *text;
    UIButton *sure;
    
    NSString *state_type;
    UIButton *btn;
    NSString *dayString;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"巡场明细" hasLeft:YES hasRight:YES withRightBarButtonItemImage:@""];
    
    [self initUI];
    
    [self sendRequestLookManageData];
}
- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image
{
    [super customNavigationBar:title hasLeft:isLeft hasRight:isRight withRightBarButtonItemImage:image];
    if (isRight) {
        UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
        right.frame = CGRectMake(0, 0, 60, 30);
        right.titleLabel.font = [UIFont systemFontWithSize:14];
        [right setTitle:@"讲评" forState:UIControlStateNormal];
        [right setTitleColor:RGBColor(0, 162, 242) forState:UIControlStateNormal];
        [right addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    }
}
- (void)commentClick:(UIButton *)sender{
    [self sendRequestManageComment];
}
- (void)sendRequestManageComment{
    
    NSString *qyno = [userDefault valueForKey:@"qyno"];
    
    NSString *str = @"<root><api><module>1607</module><type>0</type><query>{c_newid=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_c_id,qyno,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *urlArr = [doc nodesForXPath:@"//url" error:nil];
        if (urlArr.count>0) {
            for (DDXMLElement *item in urlArr) {
                [self shareToOthers:item.stringValue];
            }
        }else{
            [self.view makeToast:@"讲评失败！"];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)shareToOthers:(NSString *)url{
    NSLog(@"分享");
    UIImage *image = [UIImage imageNamed:@"placehold"];
    NSArray* imageArray = @[image];
    
    if(imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"管翼通：企业管理好帮手，成长路上好伙伴。"
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:@"巡场讲评"
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
- (void)initUI
{
    dayString = @"日";
    
    scroll = [UIScrollView new];
    [self.view addSubview:scroll];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleEdit)];
    scroll.userInteractionEnabled = YES;
    [scroll addGestureRecognizer:gesture];
    
    scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    depart = [UILabel new];
    depart.text = @"部门:";
    depart.font = [UIFont systemFontWithSize:13];
    
    people = [UILabel new];
    people.text = @"责任人:";
    people.font = [UIFont systemFontWithSize:13];
    
    type = [UILabel new];
    type.text = @"违纪类型:";
    type.font = [UIFont systemFontWithSize:13];
    
    style = [UILabel new];
    style.text = @"处理形式:";
    style.font = [UIFont systemFontWithSize:13];
    
    managep = [UILabel new];
    managep.text = @"巡场人:";
    managep.font = [UIFont systemFontWithSize:13];
    
    checkp = [UILabel new];
    checkp.text = @"复查人:";
    checkp.font = [UIFont systemFontWithSize:13];
    
    statue = [UILabel new];
    statue.text = @"处理状态:";
    statue.font = [UIFont systemFontWithSize:13];
    
    date = [UILabel new];
    date.text = @"整改期限:";
    date.font = [UIFont systemFontWithSize:13];
    
    reckonD = [UILabel new];
    reckonD.text = @"预计整改日期:";
    reckonD.font = [UIFont systemFontWithSize:13];
    
    finishD = [UILabel new];
    finishD.text = @"完成整改日期:";
    finishD.font = [UIFont systemFontWithSize:13];
    
    manageD = [UILabel new];
    manageD.text = @"巡场时间:";
    manageD.font = [UIFont systemFontWithSize:13];
    
    remark = [UILabel new];
    remark.text = @"复查备注:";
    remark.font = [UIFont systemFontWithSize:13];
    
    remark_con = [UILabel new];
    remark_con.text = @"";
    remark_con.font = [UIFont systemFontWithSize:13];
    remark_con.textColor = TextColor;
    
    managePic = [UILabel new];
    managePic.text = @"巡场图片:";
    managePic.font = [UIFont systemFontWithSize:13];
    
    PhotosContainerView *photosContainer = [[PhotosContainerView alloc] initWithMaxItemsCount:9];
    _photosContainer = photosContainer;
    
    manage = [UILabel new];
    manage.text = @"巡场内容:";
    manage.font = [UIFont systemFontWithSize:13];
    
    manae_con = [UILabel new];
    manae_con.text = @"";
    manae_con.font = [UIFont systemFontWithSize:13];
    manae_con.textColor = TextColor;
    
    handle = [UILabel new];
    handle.text = @"是否处理";
    handle.font = [UIFont systemFontWithSize:13];
    
    btn = [UIButton new];
    [btn setBackgroundImage:[UIImage imageNamed:@"shif"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"shif1"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(changeStatueClick:) forControlEvents:UIControlEventTouchUpInside];
    
    text = [UITextView new];
    text.delegate = self;
    text.placeholder = @"填写复查备注或处理结果";
    text.layer.borderWidth = 1;
    text.layer.borderColor = RGBColor(211, 212, 213).CGColor;
    text.font = [UIFont systemFontWithSize:13];
    
    sure = [UIButton new];
    [sure setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateNormal];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //state = @"未处理";
    
    [scroll sd_addSubviews:@[depart,people,type,style,managep,checkp,statue,date,reckonD,finishD,manageD,remark,remark_con,managePic,_photosContainer,manage,manae_con,handle,btn,text,sure]];
    
    CGFloat margin = 5.0;
    CGFloat leftMargin = 10.0;
    CGFloat topMargin = 0.0;
    
    //depart.backgroundColor = [UIColor redColor];
    depart.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(scroll,topMargin).widthIs((ViewWidth-3*margin)/2).heightIs(30);
    
    people.sd_layout.leftSpaceToView(depart,margin).topSpaceToView(scroll,topMargin).rightSpaceToView(scroll,margin).heightIs(30);
    
   // type.backgroundColor = [UIColor greenColor];
    type.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(depart,topMargin).widthIs((ViewWidth-3*margin)/2).heightIs(30);
    
    style.sd_layout.leftSpaceToView(type,margin).topSpaceToView(people,topMargin).rightSpaceToView(scroll,margin).heightIs(30);
    
    managep.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(type,topMargin).widthIs((ViewWidth-3*margin)/2).heightIs(30);
    
    checkp.sd_layout.leftSpaceToView(managep,margin).topSpaceToView(style,topMargin).rightSpaceToView(scroll,margin).heightIs(30);
    
    statue.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(managep,topMargin).widthIs((ViewWidth-3*margin)/2).heightIs(30);
    
    date.sd_layout.leftSpaceToView(statue,margin).topSpaceToView(checkp,topMargin).rightSpaceToView(scroll,margin).heightIs(30);
    
    reckonD.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(statue,topMargin).widthIs(ViewWidth-2*margin).heightIs(30);
    
    finishD.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(reckonD,topMargin).widthIs(ViewWidth-2*margin).heightIs(30);
    
    manageD.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(finishD,topMargin).widthIs(ViewWidth-2*margin).heightIs(30);
    
    remark.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(manageD,topMargin).widthIs(ViewWidth-2*margin).heightIs(30);
    
    remark_con.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(remark,topMargin).widthIs(ViewWidth-2*margin).autoHeightRatio(0);
    
    managePic.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(remark_con,topMargin).widthIs(ViewWidth-2*margin).heightIs(30);
    
    _photosContainer.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(managePic,topMargin).rightSpaceToView(scroll,margin);
    
    //manage.backgroundColor = [UIColor redColor];
    manage.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(_photosContainer,topMargin).rightSpaceToView(scroll,margin).heightIs(30);
    
    manae_con.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(manage,topMargin).widthIs(ViewWidth-2*margin).autoHeightRatio(0);
    
    handle.sd_layout.leftSpaceToView(scroll,leftMargin).topSpaceToView(manae_con,topMargin).widthIs(70).heightIs(30);
    
    btn.sd_layout.leftSpaceToView(handle,margin).topSpaceToView(manae_con,7).widthIs(40).heightIs(20);
    
    text.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(handle,margin).rightSpaceToView(scroll,margin).heightIs(100);
    
    sure.sd_layout.leftSpaceToView(scroll,5*margin).topSpaceToView(text,margin*3).rightSpaceToView(scroll,5*margin).heightIs(35);
    
    // scrollview自动contentsize
    [scroll setupAutoContentSizeWithBottomView:sure bottomMargin:50];
    
}
- (void)cancleEdit
{
    [self.view endEditing:YES];
}
//更改处理状态
- (void)changeStatueClick:(UIButton *)sender{
    if (!sender.selected) {
        NSLog(@"选中");
        state_type = @"1";
    }else{
        NSLog(@"未选中");
        state_type = @"0";
    }
    NSLog(@"%@",state_type);
    sender.selected = !sender.selected;
}
//保存
- (void)saveClick:(UIButton *)sender
{
    if ([text.text isEqualToString:@""]) {
        [self.view makeToast:@"填写复查备注或处理结果！"];
    }else{
        [self sendRequestSaveData];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestLookManageData
{
    NSString *str = @"<root><api><module>1604</module><type>0</type><query>{c_newid=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_c_id,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"2===:%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [self.view makeToast:element.stringValue];
            }else{
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DDXMLElement *bm = [item elementsForName:@"bm"][0];
                    NSMutableAttributedString * departAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"部门：%@",bm.stringValue]];
                    [departAtt addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(3, bm.stringValue.length)];
                    depart.attributedText = departAtt;
                
                    DDXMLElement *zrr = [item elementsForName:@"zrr"][0];
                    NSMutableAttributedString * peopleAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"责任人：%@",zrr.stringValue]];
                    [peopleAtt addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(4, zrr.stringValue.length)];
                     people.attributedText = peopleAtt;
                    
                    DDXMLElement *wtype = [item elementsForName:@"wtype"][0];
                    NSMutableAttributedString * typeAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"违纪类型：%@",wtype.stringValue]];
                    [typeAtt addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(5, wtype.stringValue.length)];
                    type.attributedText = typeAtt;
                    
                    DDXMLElement *ctype = [item elementsForName:@"ctype"][0];
                    NSMutableAttributedString * styleAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"处理形式：%@",ctype.stringValue]];
                    [styleAtt addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(5, ctype.stringValue.length)];
                    style.attributedText = styleAtt;
                    
                    DDXMLElement *xcr = [item elementsForName:@"xcr"][0];
                    NSMutableAttributedString * managepAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"巡场人：%@",xcr.stringValue]];
                    [managepAtt addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(4, xcr.stringValue.length)];
                    managep.attributedText = managepAtt;
                    
                    DDXMLElement *fcr = [item elementsForName:@"fcr"][0];
                    NSMutableAttributedString * checkpAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"复查人：%@",fcr.stringValue]];
                    [checkpAtt addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(4, fcr.stringValue.length)];
                    checkp.attributedText = checkpAtt;
                    
                    DDXMLElement *status = [item elementsForName:@"status"][0];
                    NSMutableAttributedString * statueAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"处理状态：%@",status.stringValue]];
                    [statueAtt addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(5, status.stringValue.length)];
                    statue.attributedText = statueAtt;
                    if ([status.stringValue isEqualToString:@"已处理"]) {
                        btn.selected = YES;
                        state_type = @"1";
                    }else{
                        btn.selected = NO;
                        state_type = @"0";
                    }
                    DDXMLElement *c_qxtype = [item elementsForName:@"c_qxtype"][0];
                
                    DDXMLElement *zqx = [item elementsForName:@"zqx"][0];
                    NSMutableAttributedString * dateAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"整改期限：%@ %@",zqx.stringValue,c_qxtype.stringValue]];
                    [dateAtt addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(5, zqx.stringValue.length + c_qxtype.stringValue.length +1)];
                    date.attributedText = dateAtt;
                    
                    DDXMLElement *sdt = [item elementsForName:@"sdt"][0];
                    NSMutableAttributedString * reckonDAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预计整改日期：%@",sdt.stringValue]];
                    [reckonDAtt addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(7, sdt.stringValue.length)];
                    reckonD.attributedText = reckonDAtt;
                    
                    if ([item elementsForName:@"edt"].count>0) {
                        DDXMLElement *edt = [item elementsForName:@"edt"][0];
                        NSMutableAttributedString * finishDAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"完成整改日期：%@",edt.stringValue]];
                        [finishDAtt addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(7, edt.stringValue.length)];
                        finishD.attributedText = finishDAtt;
                    }
                    
                    DDXMLElement *xdate = [item elementsForName:@"xdate"][0];
                    NSMutableAttributedString * manageDAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"巡场时间：%@",xdate.stringValue]];
                    [manageDAtt addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(5, xdate.stringValue.length)];
                    manageD.attributedText = manageDAtt;
                    
                    DDXMLElement *fbz = [item elementsForName:@"fbz"][0];
                    remark_con.text = fbz.stringValue;
                    
                    DDXMLElement *nr = [item elementsForName:@"nr"][0];
                    manae_con.text = nr.stringValue;
                    
                    DDXMLElement *tp = [item elementsForName:@"tp"][0];
                    if ([tp.stringValue isEqualToString:@""]||[tp.stringValue isEqualToString:@"0"]) {
                        _photosContainer.hidden = YES;
                        [manage updateLayout];
                        manage.sd_layout.leftSpaceToView(scroll,10).topSpaceToView(managePic,5).rightSpaceToView(scroll,10).heightIs(30);
                        
                    }else{
                        _photosContainer.hidden = NO;
                        NSArray *picArr = [tp.stringValue componentsSeparatedByString:@","];
                        _photosContainer.photoNamesArray = picArr;
                        [manage updateLayout];
                        manage.sd_layout.leftSpaceToView(scroll,10).topSpaceToView(_photosContainer,5).rightSpaceToView(scroll,10).heightIs(30);
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)refresh:(RefreshBlock)block{
    self.refreshBlock = block;
}
#pragma mark - 更改处理状态未处理- 0 已处理-1
- (void)sendRequestSaveData
{
    NSString *str = @"<root><api><module>1605</module><type>0</type><query>{c_id=%@,bz=%@,status=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_c_id,text.text,state_type,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"1===:%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"处理成功！"]) {
                if (self.refreshBlock != nil) {
                    self.refreshBlock(YES);
                }
                [self.navigationController.viewControllers[1].view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view makeToast:element.stringValue];
            }
        }
        
    } failure:^(NSError *error) {
        //NSLog(@"error:%@",error);
    }];
}
@end
