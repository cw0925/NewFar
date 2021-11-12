//
//  ComplainDetailViewController.m
//  NewAfar
//
//  Created by cw on 16/12/22.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "ComplainDetailViewController.h"
#import "ComplainDModel.h"

@interface ComplainDetailViewController ()<UITextFieldDelegate>

@property(nonatomic,copy)NSMutableArray *commentArr;

@end

@implementation ComplainDetailViewController
{
    UIView *commentView;
    UIScrollView *scroll;
    UITextField *comment;
    //UILabel *commentData;
    UIView *commentData;
    UILabel *end_line;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager   sharedManager].enable = YES;
}
- (void)update:(UpdateBlock)block
{
    self.updateBlock = block;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"客诉详情" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    
    [self initCommentView];
    
    [self addNotification];
    
    [self sendRequestCommentData];
    
    [self sendRequestUpdateReadNumData:_model.c_newid];//更新阅读量
}
- (void)backPage{
    [super backPage];
    self.updateBlock(self.commentArr.count);
}
- (void)initUI
{
    scroll = [UIScrollView new];
    [self.view addSubview:scroll];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleEdit:)];
    scroll.userInteractionEnabled = YES;
    [scroll addGestureRecognizer:gesture];
    
    UILabel *date = [UILabel new];
    date.text = _model.date;
    date.font = [UIFont systemFontWithSize:14];
    
    UILabel *state = [UILabel new];
    state.text = _model.status;
    state.textAlignment = NSTextAlignmentRight;
    state.font = [UIFont systemFontWithSize:14];
    if ([_model.status isEqualToString:@"未处理"]) {
        state.textColor = [UIColor redColor];
    }else{
        state.textColor = RGBColor(192, 110, 53);
    }
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *type = [UILabel new];
    type.text = [NSString stringWithFormat:@"类型：%@",_model.yy];
    type.font = [UIFont systemFontWithSize:13];
    type.textColor = RGBColor(112, 110, 110);
    
    UILabel *reason = [UILabel new];
    reason.text = _model.program;
    reason.font = [UIFont systemFontWithSize:13];
    
    UILabel *result_line = [UILabel new];
    result_line.text = @"--处理结果-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
    result_line.textColor = RGBColor(112, 110, 110);
    result_line.font = [UIFont systemFontWithSize:13];
    result_line.lineBreakMode = NSLineBreakByCharWrapping;
    
    UILabel *compensate = [UILabel new];
    compensate.text = [NSString stringWithFormat:@"补偿方法：%@",_model.btype];
    compensate.font = [UIFont systemFontWithSize:13];
    compensate.textColor = RGBColor(112, 110, 110);
    
    UILabel *fee = [UILabel new];
    fee.text = [NSString stringWithFormat:@"承担类型：%@",_model.bc];
    fee.font = [UIFont systemFontWithSize:13];
    fee.textColor = RGBColor(112, 110, 110);
    
    UILabel *complain = [UILabel new];
    complain.text = [NSString stringWithFormat:@"被投诉：%@",_model.hname];
    complain.font = [UIFont systemFontWithSize:13];
    complain.textColor = RGBColor(112, 110, 110);
    
    UILabel *depart = [UILabel new];
    depart.text = [NSString stringWithFormat:@"部门：%@",_model.bm];
    depart.font = [UIFont systemFontWithSize:13];
    depart.textColor = RGBColor(112, 110, 110);
    
    UILabel *result = [UILabel new];
    result.text = _model.uyj;
    result.font = [UIFont systemFontWithSize:13];
    
    UILabel *idea_line = [UILabel new];
    idea_line.text = @"--主管意见-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
    idea_line.textColor = RGBColor(112, 110, 110);
    idea_line.font = [UIFont systemFontWithSize:13];
    idea_line.lineBreakMode = NSLineBreakByCharWrapping;

    
    UILabel *idea = [UILabel new];
    idea.text = _model.byj;
    idea.font = [UIFont systemFontWithSize:13];
    
    UILabel *people = [UILabel new];
    people.text = [NSString stringWithFormat:@"录入人：%@",_model.wname];
    people.font = [UIFont systemFontWithSize:13];
    people.textColor = RGBColor(112, 110, 110);
    
    end_line = [UILabel new];
    end_line.backgroundColor = [UIColor lightGrayColor];
    
//    commentData = [UILabel new];
//    commentData.text = @"";
//    commentData.font = [UIFont systemFontWithSize:13];
    
    commentData = [UIView new];
    
    [scroll sd_addSubviews:@[date,state,line,type,reason,result_line,compensate,fee,complain,depart,result,idea_line,idea,people,end_line,commentData]];
    
    CGFloat margin = 10;
    
    scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    //state.backgroundColor = [UIColor redColor];
    state.sd_layout.topSpaceToView(scroll,margin).rightSpaceToView(scroll,margin).widthIs(80).heightIs(30);
    
    date.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(scroll,margin).rightSpaceToView(state,margin).heightIs(30);
    
    line.sd_layout.leftSpaceToView(scroll,0).topSpaceToView(date,5).rightSpaceToView(scroll,0).heightIs(1);
    
    type.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(line,margin).rightSpaceToView(scroll,margin).heightIs(20);
    
    reason.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(type,margin).rightSpaceToView(scroll,margin).autoHeightRatio(0);
    
    result_line.sd_layout.leftSpaceToView(scroll,0).topSpaceToView(reason,margin).rightSpaceToView(scroll,0).heightIs(20);
    
    //compensate.backgroundColor = [UIColor purpleColor];
    compensate.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(result_line,margin).widthIs(150).heightIs(20);
    
    fee.sd_layout.leftSpaceToView(compensate,margin).topSpaceToView(result_line,margin).rightSpaceToView(scroll,margin).heightIs(20);
    
    complain.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(compensate,margin).rightSpaceToView(scroll,margin).heightIs(20);
    
    depart.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(complain,margin).rightSpaceToView(scroll,margin).heightIs(20);
    
    result.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(depart,margin).rightSpaceToView(scroll,margin).autoHeightRatio(0);
    
    idea_line.sd_layout.leftSpaceToView(scroll,0).topSpaceToView(result,margin).rightSpaceToView(scroll,0).heightIs(20);
    
    idea.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(idea_line,margin).rightSpaceToView(scroll,margin).autoHeightRatio(0);
    
    people.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(idea,margin).rightSpaceToView(scroll,margin).heightIs(20);
    
    end_line.sd_layout.leftSpaceToView(scroll,0).topSpaceToView(people,margin).rightSpaceToView(scroll,0).heightIs(1);
    
    commentData.sd_layout.leftSpaceToView(scroll,margin).topSpaceToView(end_line,margin).rightSpaceToView(scroll,margin);
    
    //[scroll setupAutoContentSizeWithBottomView:commentData bottomMargin:10];
    [scroll setupAutoHeightWithBottomViewsArray:@[end_line,commentData] bottomMargin:10];
}
- (void)cancleEdit:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}
- (void)initCommentView
{
    commentView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight-45-BottomHeight, ViewWidth, 45)];
    [self.view addSubview:commentView];
    commentView.backgroundColor = [UIColor lightGrayColor];
    
    comment = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, ViewWidth-10, 35)];
    comment.backgroundColor = [UIColor whiteColor];
    comment.placeholder = @"请输入评论内容！";
    comment.returnKeyType = UIReturnKeySend;
    comment.font = [UIFont systemFontOfSize:15];
    comment.borderStyle = UITextBorderStyleRoundedRect;
    comment.delegate = self;
    [commentView addSubview:comment];
}
#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [self sendRequestCommentData:_model.c_newid];
    return YES;
}
#pragma mark - 输入框随键盘移动
- (void)onKeyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfoDic = notification.userInfo;
    
    NSTimeInterval duration        = [userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //这里是将时间曲线信息(一个64为的无符号整形)转换为UIViewAnimationOptions，要通过左移动16来完成类型转换。
    UIViewAnimationOptions options = \
    [userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    CGRect keyboardRect            = [userInfoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight         = MIN(CGRectGetWidth(keyboardRect), CGRectGetHeight(keyboardRect));
    
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        commentView.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight+BottomHeight);
    } completion:nil];
}

- (void)onKeyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfoDic = notification.userInfo;
    
    NSTimeInterval duration        = [userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //这里是将时间曲线信息(一个64为的无符号整形)转换为UIViewAnimationOptions，要通过左移动16来完成类型转换。
    UIViewAnimationOptions options = \
    [userInfoDic[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    [UIView animateWithDuration:duration delay:0 options:options \
                     animations:^{
                         commentView.transform = CGAffineTransformIdentity;
                     } completion:nil];
}
- (void)addNotification
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(onKeyboardWillShow:)
                   name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self
               selector:@selector(onKeyboardWillHide:)
                   name:UIKeyboardWillHideNotification object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//更新阅读数据
- (void)sendRequestUpdateReadNumData:(NSString *)index
{
    NSString *str = @"<root><api><module>1704</module><type>0</type><query>{newid=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,index,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"成功！"]) {
                [self.view makeToast:element.stringValue];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//发送评论数据
- (void)sendRequestCommentData:(NSString *)index
{
    for (UIView *view in commentData.subviews) {
        [view removeFromSuperview];
    }
    if (_commentArr.count>0) {
        [_commentArr removeAllObjects];
    }
    NSString *str = @"<root><api><module>1703</module><type>0</type><query>{newid=%@,content=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,index,comment.text,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            [self.view makeToast:element.stringValue];
            if ([element.stringValue isEqualToString:@"评论成功！"]) {
                comment.text = @"";
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    ComplainDModel  *model = [[ComplainDModel alloc]init];
                    DDXMLElement *c_real_name = [item elementsForName:@"c_real_name"][0];
                    model.c_real_name = c_real_name.stringValue;
                    DDXMLElement *c_content = [item elementsForName:@"c_content"][0];
                    model.c_content = c_content.stringValue;
                    [self.commentArr addObject:model];
                }
                UILabel *bottomLabel = nil;
                
                if (_commentArr.count>0) {
                    for (NSInteger i=0; i<_commentArr.count; i++) {
                        
                        ComplainDModel  *model = _commentArr[i];
                        UILabel *label = [UILabel new];
                        label.font = [UIFont systemFontWithSize:11];
                        
                        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",model.c_real_name,model.c_content]];
                        [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBColor(93, 106, 146) range:NSMakeRange(0, model.c_real_name.length)];
                        label.attributedText = attributeStr;
                        [commentData addSubview:label];
                        
                        label.sd_layout.leftSpaceToView(commentData,0).topSpaceToView(bottomLabel,5).rightSpaceToView(commentData,0).autoHeightRatio(0);
                        
                        bottomLabel = label;
                        
                    }
                    [commentData setupAutoHeightWithBottomView:bottomLabel bottomMargin:10];
                }else{
//                    [scroll setupAutoHeightWithBottomView:end_line bottomMargin:10];
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//查看评论
- (void)sendRequestCommentData
{
    NSString *str = @"<root><api><module>1705</module><type>0</type><query>{newid=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_model.c_newid,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        for (DDXMLElement *element in rowArr) {
            ComplainDModel  *model = [[ComplainDModel alloc]init];
            DDXMLElement *c_real_name = [element elementsForName:@"c_real_name"][0];
            model.c_real_name = c_real_name.stringValue;
            DDXMLElement *c_content = [element elementsForName:@"c_content"][0];
            model.c_content = c_content.stringValue;
            [self.commentArr addObject:model];
        }
        UILabel *bottomLabel = nil;
        
        for (NSInteger i=0; i<_commentArr.count; i++) {
            
            ComplainDModel  *model = _commentArr[i];
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontWithSize:11];
            
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",model.c_real_name,model.c_content]];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBColor(93, 106, 146) range:NSMakeRange(0, model.c_real_name.length)];
            label.attributedText = attributeStr;
            [commentData addSubview:label];
            
            label.sd_layout.leftSpaceToView(commentData,0).topSpaceToView(bottomLabel,5).rightSpaceToView(commentData,0).autoHeightRatio(0);
            
            bottomLabel = label;
            
        }
        [commentData setupAutoHeightWithBottomView:bottomLabel bottomMargin:10];
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)commentArr
{
    if (!_commentArr) {
        _commentArr = [NSMutableArray array];
    }
    return _commentArr;
}

@end
