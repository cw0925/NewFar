//
//  RegistComplainViewController.m
//  NewAfar
//
//  Created by cw on 17/1/3.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "RegistComplainViewController.h"
#import "PickView.h"

@interface RegistComplainViewController ()<UITextFieldDelegate,BtnClickDelegate>

@property(nonatomic,copy)NSMutableArray *departArr;
@property(nonatomic,copy)NSMutableArray *staffArr;
@property(nonatomic,copy)NSMutableArray *typeArr;
@property(nonatomic,copy)NSMutableArray *rankArray;

@end

@implementation RegistComplainViewController
{
    UITextField *nameTf;
    UITextField *phoneTf;
    UITextField *cardTf;
    UITextView *describeTx;
    UITextField *ageTf;
    UITextField *sexTf;
    UITextField *rankTf;
    UITextField *reasonTf;
    UITextField *departTf;
    UITextView *departTx;
    UITextView *staffTx;
    UITextField *staffTf;
    UITextField *typeTf;
    UITextField *bearTf;
    UITextView *customTx;
    UITextField *codeTf;
    
    NSArray *ageArr;
    NSArray *sexArr;
    //NSArray *rankArr;
    NSArray *reasonArr;
    NSArray *statusArr;
    NSArray *feeTypeArr;
    
    PickView *pick;
    
    //NSString *level;
    NSString *cause;
    
    NSString *infoString;
    
    NSString *statueS;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"客诉登记" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    
    [self sendRequestModuleData];
    
    [self sendRequestDepartData];
    [self sendRequestInfoData:@"6"];
    [self sendRequestInfoData:@"11"];
    [self sendRequestRankData];
}
- (void)initUI
{
    ageArr = @[@"20岁以下",@"21-30岁",@"31-40岁",@"41-50岁",@"51-60岁",@"60岁以上"];
    sexArr = @[@"男",@"女"];
    //rankArr = @[@"A级客诉",@"B级客诉",@"C级客诉",@"D级客诉"];
    reasonArr = @[@"商品",@"环境",@"服务",@"管理",@"价格",@"工作失误",@"标示不明确",@"质量不合格",@"其他"];
    statusArr = @[@"未处理",@"已处理"];
    feeTypeArr = @[@"个人承担",@"企业承担"];
    
    CGFloat margin = 10;
    
    CGFloat labelW = 75;
    
    CGFloat labelH = 30;
    
    UIScrollView *scroll = [UIScrollView new];
    [self.view addSubview:scroll];
    
    scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleEdit:)];
    scroll.userInteractionEnabled = YES;
    [scroll addGestureRecognizer:gesture];
    //顾客信息区
    UILabel *custom = [UILabel new];
    custom.text = @"    顾客信息区";
    custom.textColor = RGBColor(2, 120, 204);
    custom.font = [UIFont systemFontWithSize:13];
    custom.backgroundColor = RGBColor(222, 228, 230);
    
    UIView *customInfo = [UIView new];
    customInfo.backgroundColor = RGBColor(247, 251, 252);
    
    UILabel *custom_line = [UILabel new];
    custom_line.backgroundColor = RGBColor(222, 228, 230);
    
    UILabel *code = [UILabel new];
    code.text = @"编       码:";
    code.textColor = RGBColor(89, 89, 89);
    code.font = [UIFont systemFontWithSize:13];
    
    codeTf = [UITextField new];
    codeTf.textColor = RGBColor(89, 89, 89);
    codeTf.font = [UIFont systemFontWithSize:13];
    codeTf.userInteractionEnabled = NO;
    
    
    UILabel *name = [UILabel new];
    name.text = @"顾客姓名:";
    name.textColor = RGBColor(89, 89, 89);
    name.font = [UIFont systemFontWithSize:13];
    
    nameTf = [UITextField new];
    nameTf.borderStyle = UITextBorderStyleRoundedRect;

    nameTf.font = [UIFont systemFontWithSize:13];
    nameTf.textColor = RGBColor(89, 89, 89);
    
    nameTf.backgroundColor = [UIColor whiteColor];
    
    UILabel *phone = [UILabel new];
    phone.text = @"电       话:";
    phone.textColor = RGBColor(89, 89, 89);
    phone.font = [UIFont systemFontWithSize:13];
    
    phoneTf = [UITextField new];
    phoneTf.font = [UIFont systemFontWithSize:13];

    phoneTf.borderStyle = UITextBorderStyleRoundedRect;
    phoneTf.backgroundColor = [UIColor whiteColor];
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    phoneTf.textColor = RGBColor(89, 89, 89);
    
    UILabel *age = [UILabel new];
    age.text = @"顾客年龄:";
    age.font = [UIFont systemFontWithSize:13];
    age.textColor = RGBColor(89, 89, 89);
    
    ageTf = [UITextField new];
    ageTf.borderStyle = UITextBorderStyleRoundedRect;
    ageTf.backgroundColor = [UIColor whiteColor];
    ageTf.delegate = self;
    ageTf.text = ageArr[0];
    ageTf.font = [UIFont systemFontWithSize:13];
    ageTf.textColor = RGBColor(89, 89, 89);
    
    UIButton *age_right = [UIButton buttonWithType:UIButtonTypeCustom];
    age_right.frame = CGRectMake(0, 0, 18, 18);
    [age_right setImage:[UIImage imageNamed:@"sanjiao"] forState:UIControlStateNormal];
    
    ageTf.rightView = age_right;
    ageTf.rightViewMode = UITextFieldViewModeAlways;
    
    UILabel *sex = [UILabel new];
    sex.text = @"性       别:";
    sex.font = [UIFont systemFontWithSize:13];
    sex.textColor = RGBColor(89, 89, 89);
    
    sexTf = [UITextField new];
    sexTf.borderStyle = UITextBorderStyleRoundedRect;
    sexTf.backgroundColor = [UIColor whiteColor];
    sexTf.delegate = self;
    sexTf.font = [UIFont systemFontWithSize:13];
    sexTf.text = sexArr[0];
    sexTf.textColor = RGBColor(89, 89, 89);
    
    UIButton *sex_right = [UIButton buttonWithType:UIButtonTypeCustom];
    sex_right.frame = CGRectMake(0, 0, 18, 18);
    [sex_right setImage:[UIImage imageNamed:@"sanjiao"] forState:UIControlStateNormal];
    
    sexTf.rightView = sex_right;
    sexTf.rightViewMode = UITextFieldViewModeAlways;
    
    UILabel *card = [UILabel new];
    card.text = @"身份证号:";
    card.font = [UIFont systemFontWithSize:13];
    card.textColor = RGBColor(89, 89, 89);
    
    cardTf = [UITextField new];
    cardTf.font = [UIFont systemFontWithSize:13];
    cardTf.borderStyle = UITextBorderStyleRoundedRect;
    cardTf.backgroundColor = [UIColor whiteColor];
    cardTf.textColor = RGBColor(89, 89, 89);
    cardTf.secureTextEntry = YES;
    //客诉内容区
    UILabel *content = [UILabel new];
    content.text = @"    客诉内容区";
    content.textColor = RGBColor(2, 120, 204);
    content.font = [UIFont systemFontWithSize:13];
    content.backgroundColor = RGBColor(222, 228, 230);
    
    UIView *contentInfo = [UIView new];
    contentInfo.backgroundColor = RGBColor(247, 251, 252);
    
    UILabel *content_line = [UILabel new];
    content_line.backgroundColor = RGBColor(222, 228, 230);
    
    UILabel *describe = [UILabel new];
    describe.text = @"客诉描述:";
    describe.font = [UIFont systemFontWithSize:13];
    describe.textColor = RGBColor(89, 89, 89);
    
    describeTx = [UITextView new];
    describeTx.font = [UIFont systemFontWithSize:13];
    describeTx.layer.borderWidth = 1;
    describeTx.layer.borderColor = RGBColor(165, 165, 165).CGColor;describeTx.layer.cornerRadius = 5;
    describeTx.layer.masksToBounds = YES;
    describeTx.textColor = RGBColor(89, 89, 89);
    
    //level = @"1";
    UILabel *rank = [UILabel new];
    rank.text = @"客诉级别:";
    rank.textColor = RGBColor(89, 89, 89);
    rank.font = [UIFont systemFontWithSize:13];
    
    rankTf = [UITextField new];
    rankTf.borderStyle = UITextBorderStyleRoundedRect;
    rankTf.backgroundColor = [UIColor whiteColor];
    rankTf.delegate = self;
    rankTf.font = [UIFont systemFontWithSize:13];
    rankTf.textColor = RGBColor(89, 89, 89);
    rankTf.delegate = self;
    
    UIButton *rank_right = [UIButton buttonWithType:UIButtonTypeCustom];
    rank_right.frame = CGRectMake(0, 0, 18, 18);
    [rank_right setImage:[UIImage imageNamed:@"sanjiao"] forState:UIControlStateNormal];
    
    rankTf.rightView = rank_right;
    rankTf.rightViewMode = UITextFieldViewModeAlways;
    
    UILabel *reason = [UILabel new];
    reason.text = @"类    型:";
    reason.textColor = RGBColor(89, 89, 89);
    reason.font = [UIFont systemFontWithSize:13];
    
    cause = @"1";
    reasonTf = [UITextField new];
    reasonTf.borderStyle = UITextBorderStyleRoundedRect;
    reasonTf.backgroundColor = [UIColor whiteColor];
    reasonTf.delegate = self;
    reasonTf.font = [UIFont systemFontWithSize:13];
    reasonTf.text = reasonArr[0];
    reasonTf.textColor = RGBColor(89, 89, 89);
    
    UIButton *reason_right = [UIButton buttonWithType:UIButtonTypeCustom];
    reason_right.frame = CGRectMake(0, 0, 18, 18);
    [reason_right setImage:[UIImage imageNamed:@"sanjiao"] forState:UIControlStateNormal];
    
    reasonTf.rightView = reason_right;
    reasonTf.rightViewMode = UITextFieldViewModeAlways;
    //处理方案区
    UILabel *scheme = [UILabel new];
    scheme.text = @"    处理方案区";
    scheme.textColor = RGBColor(2, 120, 204);
    scheme.font = [UIFont systemFontWithSize:13];
    scheme.backgroundColor = RGBColor(222, 228, 230);
    
    UIView *schemeInfo = [UIView new];
    schemeInfo.backgroundColor = RGBColor(247, 251, 252);
    
    UILabel *scheme_line = [UILabel new];
    scheme_line.backgroundColor = RGBColor(222, 228, 230);
    
    UILabel *depart = [UILabel new];
    depart.text = @"部       门:";
    depart.textColor = RGBColor(89, 89, 89);
    depart.font = [UIFont systemFontWithSize:13];
    
    departTf = [UITextField new];
    departTf.borderStyle = UITextBorderStyleRoundedRect;
    departTf.backgroundColor = [UIColor whiteColor];
    departTf.font = [UIFont systemFontWithSize:13];
    departTf.textColor = RGBColor(89, 89, 89);
    departTf.delegate = self;
    
    UILabel *staff = [UILabel new];
    staff.text = @"员       工:";
    staff.textColor = RGBColor(89, 89, 89);
    staff.font = [UIFont systemFontWithSize:13];
    
    
    staffTf = [UITextField new];
    staffTf.borderStyle = UITextBorderStyleRoundedRect;
    staffTf.backgroundColor = [UIColor whiteColor];
    staffTf.font = [UIFont systemFontWithSize:13];
    staffTf.textColor = RGBColor(89, 89, 89);
    staffTf.delegate = self;
    
    UILabel *type = [UILabel new];
    type.text = @"补偿方法:";
    type.textColor = RGBColor(89, 89, 89);
    type.font = [UIFont systemFontWithSize:13];
    
    typeTf = [UITextField new];
    typeTf.borderStyle = UITextBorderStyleRoundedRect;
    typeTf.backgroundColor = [UIColor whiteColor];
    typeTf.font = [UIFont systemFontWithSize:13];
    typeTf.textColor = RGBColor(89, 89, 89);
    typeTf.delegate = self;
    
    UILabel *bear = [UILabel new];
    bear.text = @"承担类型:";
    bear.textColor = RGBColor(89, 89, 89);
    bear.font = [UIFont systemFontWithSize:13];
    
    bearTf = [UITextField new];
    bearTf.borderStyle = UITextBorderStyleRoundedRect;
    bearTf.backgroundColor = [UIColor whiteColor];
    bearTf.font = [UIFont systemFontWithSize:13];
    bearTf.textColor = RGBColor(89, 89, 89);
    bearTf.delegate = self;
    //处理结果区
    UILabel *result = [UILabel new];
    result.text = @"    处理结果区";
    result.textColor = RGBColor(2, 120, 204);
    result.font = [UIFont systemFontWithSize:13];
    result.backgroundColor = RGBColor(222, 228, 230);
    
    UIView *resultInfo = [UIView new];
    resultInfo.backgroundColor = RGBColor(247, 251, 252);
    
    UILabel *result_line = [UILabel new];
    result_line.backgroundColor = RGBColor(222, 228, 230);
    
    UILabel *custom_res = [UILabel new];
    custom_res.text = @"反馈顾客结果:";
    custom_res.numberOfLines = 0;
    custom_res.textColor = RGBColor(89, 89, 89);
    custom_res.font = [UIFont systemFontWithSize:13];
    
    customTx = [UITextView new];
    customTx.layer.cornerRadius = 5;
    customTx.layer.masksToBounds = YES;
    customTx.font = [UIFont systemFontWithSize:13];
    customTx.textColor = RGBColor(89, 89, 89);
    
    UILabel *staff_res = [UILabel new];
    staff_res.text = @"员工处理结果:";
    staff_res.numberOfLines = 0;
    staff_res.textColor = RGBColor(89, 89, 89);
    staff_res.font = [UIFont systemFontWithSize:13];
    
    staffTx = [UITextView new];
    staffTx.layer.cornerRadius = 5;
    staffTx.layer.masksToBounds = YES;
    staffTx.font = [UIFont systemFontWithSize:13];
    staffTx.textColor = RGBColor(89, 89, 89);
    
    UILabel *depart_res = [UILabel new];
    depart_res.text = @"部门处理结果:";
    depart_res.numberOfLines = 0;
    depart_res.textColor = RGBColor(89, 89, 89);
    depart_res.font = [UIFont systemFontWithSize:13];
    
    departTx = [UITextView new];
    departTx.layer.cornerRadius = 5;
    departTx.layer.masksToBounds = YES;
    departTx.font = [UIFont systemFontWithSize:13];
    departTx.textColor = RGBColor(89, 89, 89);
    
    //确定
    UIButton *sure = [UIButton new];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(commitComplain:) forControlEvents:UIControlEventTouchUpInside];
    
    //顾客信息区
    [customInfo sd_addSubviews:@[code,codeTf,name,nameTf,phone,phoneTf,age,ageTf,sex,sexTf,card,cardTf]];
    
    code.sd_layout.leftSpaceToView(customInfo,margin).topSpaceToView(customInfo,margin).widthIs(labelW).heightIs(labelH);
    
    codeTf.sd_layout.leftSpaceToView(code,0).topEqualToView(code).rightSpaceToView(customInfo,margin).heightIs(labelH);
    
    name.sd_layout.leftSpaceToView(customInfo,margin).topSpaceToView(code,margin).widthIs(labelW).heightIs(labelH);
    
    nameTf.sd_layout.leftSpaceToView(name,0).topEqualToView(name).widthIs(ViewWidth/2-100).heightIs(labelH);

    phone.sd_layout.leftSpaceToView(nameTf,2*margin).topEqualToView(name).widthIs(labelW).heightIs(labelH);
    
    phoneTf.sd_layout.leftSpaceToView(phone,0).topEqualToView(nameTf).rightSpaceToView(customInfo,margin).heightIs(labelH);
    
    age.sd_layout.leftSpaceToView(customInfo,margin).topSpaceToView(name,5).widthIs(labelW).heightIs(labelH);
    
    ageTf.sd_layout.leftSpaceToView(age,0).topSpaceToView(nameTf,margin).widthIs(ViewWidth/2-100).heightIs(labelH);
    
    sex.sd_layout.leftSpaceToView(ageTf,2*margin).topEqualToView(age).widthIs(labelW).heightIs(labelH);
    
    sexTf.sd_layout.leftSpaceToView(sex,0).topSpaceToView(phone,margin).rightSpaceToView(customInfo,margin).heightIs(labelH);
    
    card.sd_layout.leftSpaceToView(customInfo,margin).topSpaceToView(age,margin).widthIs(labelW).heightIs(labelH);
    
    cardTf.sd_layout.leftSpaceToView(card,0).topSpaceToView(ageTf,margin).rightSpaceToView(customInfo,margin).heightIs(labelH);
    //客诉内容区
    [contentInfo sd_addSubviews:@[describe,describeTx,rank,rankTf,reason,reasonTf]];
    
    describe.sd_layout.leftSpaceToView(contentInfo,margin).topSpaceToView(contentInfo,margin).widthIs(labelW).heightIs(labelH);
    
    describeTx.sd_layout.leftSpaceToView(describe,0).topEqualToView(describe).rightSpaceToView(contentInfo,margin).heightIs(60);
    
    rank.sd_layout.leftSpaceToView(contentInfo,margin).topSpaceToView(describeTx,margin).widthIs(labelW).heightIs(labelH);
    
    rankTf.sd_layout.leftSpaceToView(rank,0).topEqualToView(rank).widthIs(ViewWidth/2-100).heightIs(labelH);
    
    reason.sd_layout.leftSpaceToView(rankTf,2*margin).topEqualToView(rank).widthIs(labelW).heightIs(labelH);
    
    reasonTf.sd_layout.leftSpaceToView(reason,0).topEqualToView(reason).rightSpaceToView(contentInfo,margin).heightIs(labelH);
    //处理方案区
    [schemeInfo sd_addSubviews:@[depart,departTf,staff,staffTf,type,typeTf,bear,bearTf]];
    
    depart.sd_layout.leftSpaceToView(schemeInfo,margin).topSpaceToView(schemeInfo,margin).widthIs(labelW).heightIs(labelH);
    
    departTf.sd_layout.leftSpaceToView(depart,0).topEqualToView(depart).widthIs(ViewWidth/2-100).heightIs(labelH);
    
    staff.sd_layout.leftSpaceToView(departTf,2*margin).topEqualToView(depart).widthIs(labelW).heightIs(labelH);
    
    staffTf.sd_layout.leftSpaceToView(staff,0).topEqualToView(staff).rightSpaceToView(schemeInfo,margin).heightIs(labelH);
    
    type.sd_layout.leftSpaceToView(schemeInfo,margin).topSpaceToView(depart,margin).widthIs(labelW).heightIs(labelH);
    
    typeTf.sd_layout.leftSpaceToView(type,0).topEqualToView(type).widthIs(ViewWidth/2-100).heightIs(labelH);
    
    bear.sd_layout.leftSpaceToView(typeTf,2*margin).topEqualToView(type).widthIs(labelW).heightIs(labelH);
    
    bearTf.sd_layout.leftSpaceToView(bear,0).topEqualToView(bear).rightSpaceToView(schemeInfo,margin).heightIs(labelH);
    //处理结果区
    [resultInfo sd_addSubviews:@[custom_res,customTx,staff_res,staffTx,depart_res,departTx]];
    
    custom_res.sd_layout.leftSpaceToView(resultInfo,margin).topSpaceToView(resultInfo,margin).widthIs(labelW).heightIs(60);
    
    customTx.sd_layout.leftSpaceToView(custom_res,5).topEqualToView(custom_res).rightSpaceToView(resultInfo,margin).heightIs(60);
    
    staff_res.sd_layout.leftSpaceToView(resultInfo,margin).topSpaceToView(custom_res,margin).widthIs(labelW).heightIs(60);
    
    staffTx.sd_layout.leftSpaceToView(staff_res,5).topEqualToView(staff_res).rightSpaceToView(resultInfo,margin).heightIs(60);
    
    depart_res.sd_layout.leftSpaceToView(resultInfo,margin).topSpaceToView(staff_res,margin).widthIs(labelW).heightIs(60);
    
    departTx.sd_layout.leftSpaceToView(depart_res,5).topEqualToView(depart_res).rightSpaceToView(resultInfo,margin).heightIs(60);
    
    
    [scroll sd_addSubviews:@[custom,customInfo,custom_line,content,contentInfo,content_line,scheme,schemeInfo,scheme_line,result,resultInfo,result_line,sure]];
    
    custom.sd_layout.leftSpaceToView(scroll,0).topSpaceToView(scroll,0).rightSpaceToView(scroll,0).heightIs(labelH);
    
    customInfo.sd_layout.leftEqualToView(custom).topSpaceToView(custom,0).rightEqualToView(custom).heightIs(170);
    
    custom_line.sd_layout.leftEqualToView(custom).rightEqualToView(custom).topSpaceToView(customInfo,0).heightIs(1);
    
    content.sd_layout.leftSpaceToView(scroll,0).topSpaceToView(custom_line,margin).rightSpaceToView(scroll,0).heightIs(labelH);
    
    contentInfo.sd_layout.leftEqualToView(content).topSpaceToView(content,0).rightSpaceToView(scroll,0).heightIs(120);
    
    content_line.sd_layout.leftEqualToView(contentInfo).rightEqualToView(contentInfo).topSpaceToView(contentInfo,0).heightIs(1);
    
    scheme.sd_layout.leftSpaceToView(scroll,0).topSpaceToView(content_line,margin).rightSpaceToView(scroll,0).heightIs(labelH);
    
    schemeInfo.sd_layout.leftEqualToView(scheme).topSpaceToView(scheme,0).rightSpaceToView(scroll,0).heightIs(90);
    
    scheme_line.sd_layout.leftEqualToView(schemeInfo).rightEqualToView(schemeInfo).topSpaceToView(schemeInfo,0).heightIs(1);
    
    result.sd_layout.leftSpaceToView(scroll,0).topSpaceToView(scheme_line,margin).rightSpaceToView(scroll,0).heightIs(labelH);
    
    resultInfo.sd_layout.leftSpaceToView(scroll,0).topSpaceToView(result,0).rightSpaceToView(scroll,0).heightIs(220);
    
    result_line.sd_layout.leftEqualToView(resultInfo).rightEqualToView(resultInfo).topSpaceToView(resultInfo,0).heightIs(1);
    
    sure.sd_layout.leftSpaceToView(scroll,60).topSpaceToView(result_line,20).rightSpaceToView(scroll,60).heightIs(35);
    
    [scroll setupAutoContentSizeWithBottomView:sure bottomMargin:30];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([ageTf isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:ageArr];
    }
    if ([sexTf isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:sexArr];
    }
    if ([rankTf isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:_rankArray];
    }
    if ([reasonTf isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:reasonArr];
    }
    if ([typeTf isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:_typeArr];
    }
    if ([bearTf isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:feeTypeArr];
    }
    if ([departTf isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:_departArr];
    }
    if ([staffTf isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:_staffArr];
    }
    pick.clickDelegate = self;
    [pick showPickViewWhenClick:textField];
}
#pragma mark -BtnClickDelegate
- (void)btnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if ([ageTf isFirstResponder]) {
            ageTf.text = pick.title.text;
        }
        if ([sexTf isFirstResponder]) {
            sexTf.text = pick.title.text;
        }
        if ([rankTf isFirstResponder]) {
            rankTf.text = pick.title.text;
        }
        if ([reasonTf isFirstResponder]) {
            reasonTf.text = pick.title.text;
            for (NSInteger i = 0; i<reasonArr.count; i++) {
                if ([reasonTf.text isEqualToString:reasonArr[i]]) {
                    cause = [NSString stringWithFormat:@"%d",i+1];
                }
            }
        }
        if ([typeTf isFirstResponder]) {
            typeTf.text = pick.title.text;
        }
        if ([bearTf isFirstResponder]) {
            bearTf.text = pick.title.text;
        }
        if ([departTf isFirstResponder]) {
            departTf.text = pick.title.text;
        }
        if ([staffTf isFirstResponder]) {
            staffTf.text = pick.title.text;
        }
    }
    
    [self.view endEditing:YES];
}
- (void)commitComplain:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([nameTf.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入顾客姓名！"];
    }else if ((![phoneTf.text isEqualToString:@""])&&(![JudgePhone judgePhoneNumber:phoneTf.text])){
       [self.view makeToast:@"请输入正确的手机号！"];
    }else if ([describeTx.text isEqualToString:@""]){
        [self.view makeToast:@"请输入客诉描述！"];
    }else if ([departTf.text isEqualToString:@""]){
        [self.view makeToast:@"请选择部门！"];
    }else if ([staffTf.text isEqualToString:@""]){
        [self.view makeToast:@"请选择员工！"];
    }else if ([typeTf.text isEqualToString:@""]){
        [self.view makeToast:@"请选择补偿方法！"];
    }else if ([bearTf.text isEqualToString:@""]){
        [self.view makeToast:@"请选择承担类型！"];
    }else if ([customTx.text isEqualToString:@""]){
        [self.view makeToast:@"请输入反馈顾客结果！"];
    }else if ([staffTx.text isEqualToString:@""]){
        [self.view makeToast:@"请输入员工处理结果！"];
    }else if ([departTx.text isEqualToString:@""]){
        [self.view makeToast:@"请输入部门处理结果！"];
    }else {
        statueS = @"1";//已处理
        [self sendRequestWriteComplainData];
    }
}
- (void)cancleEdit:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refresh:(RefreshBlock)block{
    self.refreshBlock = block;
}

#pragma mark - 客诉登记
- (void)sendRequestWriteComplainData
{
    NSArray *departArray = [departTf.text componentsSeparatedByString:@" "];
    NSArray *staffArray = [staffTf.text componentsSeparatedByString:@" "];
    NSArray *classifyArray = [typeTf.text componentsSeparatedByString:@" "];
    NSArray *rankArr = [rankTf.text componentsSeparatedByString:@" "];
    NSLog(@"客诉登记");
    NSString *qyno = [userDefault valueForKey:@"qyno"];
    
    NSString *str = @"<root><api><module>1701</module><type>0</type><query>{store=%@,cname=%@,sex=%@,age=%@,program=%@,tel=%@,custid=%@,kid=%@,status=%@,yid=%@,bcode=%@,hcode=%@,btype=%@,bc=%@,cjg=%@,yjg=%@,bjg=%@,newid=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"store"],nameTf.text,sexTf.text,ageTf.text,describeTx.text,phoneTf.text,cardTf.text,rankArr[0],statueS,cause,departArray[0],staffArray[0],classifyArray[0],bearTf.text,customTx.text,staffTx.text,departTx.text,codeTf.text,qyno,[userDefault valueForKey:@"name"],UUID];
    
     NSLog(@"%@",string);
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        //NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"确认成功！"]) {
                [self.navigationController.viewControllers[1].view makeToast:@"登记成功！"];
                if (self.refreshBlock != nil) {
                    self.refreshBlock(YES);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view makeToast:element.stringValue];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//请求图片存储的模块
- (void)sendRequestModuleData
{
    NSString *str = @"<root><api><module>1706</module><type>0</type><query>{type=2}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>gb</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        //NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"成功！"]){
                NSArray *rowArr = [doc nodesForXPath:@"//maxid" error:nil];
                for (DDXMLElement *item in rowArr) {
                    codeTf.text = item.stringValue;
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//11-补偿类型 4-部门 6-员工
- (void)sendRequestInfoData:(NSString *)querytype
{
    //<root><api><querytype>4</querytype><query>{store=009,sto=101}</query></api><user><company>009</company><customeruser>15603745099</customeruser></user></root>部门
    //<root><api><querytype>11</querytype><query>{store=009}</query></api><user><company>009</company><customeruser>15603745099</customeruser></user></root>补偿类型
    //<root><api><querytype>6</querytype><query>{store=009}</query></api><user><company>009</company><customeruser>15603745099</customeruser></user></root>员工
    NSString *qyno = [userDefault valueForKey:@"qyno"];
    
    NSString *str = @"<root><api><querytype>%@</querytype><query>{store=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    infoString = [NSString stringWithFormat:str,querytype,qyno,qyno,[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:LoadInfoURL parameters:infoString success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        //NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                if ([querytype isEqualToString:@"6"]) {//员工
                    for (DDXMLElement *item in rowArr) {
                        DDXMLElement *code = [item elementsForName:@"code"][0];
                        DDXMLElement *name = [item elementsForName:@"name"][0];
                        [self.staffArr addObject:[NSString stringWithFormat:@"%@ %@",code.stringValue,name.stringValue]];
                    }
                }
                if ([querytype isEqualToString:@"11"]) {//补偿方法
                    for (DDXMLElement *item in rowArr) {
                        DDXMLElement *tid = [item elementsForName:@"tid"][0];
                        DDXMLElement *tname = [item elementsForName:@"tname"][0];
                        [self.typeArr addObject:[NSString stringWithFormat:@"%@ %@",tid.stringValue,tname.stringValue]];
                    }
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//部门
- (void)sendRequestDepartData
{
    //<root><api><querytype>4</querytype><query>{store=009,sto=102}</query></api><user><company>009</company><customeruser>18300602014</customeruser></user></root>
    NSString *qyno = [userDefault valueForKey:@"qyno"];
    
    //NSString *company = [qyno substringToIndex:3];
    NSString *store = [userDefault valueForKey:@"store"];
    
    NSString *str = @"<root><api><querytype>14</querytype><query>{store=%@,sto=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,qyno,store,qyno,[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:InfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
       // NSLog(@"%@",doc);
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        for (DDXMLElement *element in rowArr) {
            if ([element elementsForName:@"dname"].count>0) {
                DDXMLElement *name = [element elementsForName:@"dname"][0];
                [self.departArr addObject:name.stringValue];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
//客诉级别
- (void)sendRequestRankData{
    NSString *str = @"<root><api><querytype>8</querytype><query>{store=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
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
                    DDXMLElement *rankID = [item elementsForName:@"id"][0];
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    [self.rankArray addObject:[NSString stringWithFormat:@"%@ %@",rankID.stringValue,name.stringValue]];
                }
                rankTf.text = _rankArray[0];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)departArr
{
    if (!_departArr) {
        _departArr = [NSMutableArray array];
    }
    return _departArr;
}
- (NSMutableArray *)typeArr
{
    if (!_typeArr) {
        _typeArr = [NSMutableArray array];
    }
    return _typeArr;
}
- (NSMutableArray *)staffArr
{
    if (!_staffArr) {
        _staffArr = [NSMutableArray array];
    }
    return _staffArr;
}
- (NSMutableArray *)rankArray
{
    if (!_rankArray) {
        _rankArray = [NSMutableArray array];
    }
    return _rankArray;
}
@end
