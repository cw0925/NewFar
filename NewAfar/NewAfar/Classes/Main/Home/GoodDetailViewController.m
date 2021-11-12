//
//  GoodDetailViewController.m
//  NewAfar
//
//  Created by cw on 16/12/16.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "GoodDetailViewController.h"

@interface GoodDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *gcode;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *supply;
@property (weak, nonatomic) IBOutlet UILabel *brand;
@property (weak, nonatomic) IBOutlet UILabel *barcode;
@property (weak, nonatomic) IBOutlet UILabel *depart;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *stock;
@property (weak, nonatomic) IBOutlet UILabel *sale;
@property (weak, nonatomic) IBOutlet UILabel *buy;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *salerank;
@property (weak, nonatomic) IBOutlet UILabel *buyrank;
@property (weak, nonatomic) IBOutlet UILabel *retail;
@property (weak, nonatomic) IBOutlet UILabel *member;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UILabel *wholesale;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (weak, nonatomic) IBOutlet UIView *bg;
@end

@implementation GoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"商品详情" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)initUI
{
    _bg.layer.borderWidth = 1;
    _bg.layer.borderColor = RGBColor(151, 151, 151).CGColor;
    _tip.text = [NSString stringWithFormat:@"%@ %@",_model.gcode,_model.code];
//    _gcode.text = _model.barcode;
//    _name.text = _model.code;
    _category.text = [NSString stringWithFormat:@"%@ %@",_model.splb,_model.lbmc];
    _supply.text = [NSString stringWithFormat:@"%@ %@",_model.gys,_model.gysmc];
    _brand.text = [NSString stringWithFormat:@"%@ %@",_model.pp,_model.PPMC];
    _barcode.text = _model.barcode;
    _depart.text = [NSString stringWithFormat:@"%@ %@",_model.bm,_model.bmmc];
    _address.text = [NSString stringWithFormat:@"%@ %@",_model.cd,_model.cdmc];
    _stock.text = _model.cur_number;
    _sale.text = _model.sale_number;
    _buy.text = _model.cur_rec;
    _date.text = _model.last_saleday;
    _rank.text = _model.gg;
    _salerank.text = _model.xsdw;
    _buyrank.text = _model.jhdw;
    _retail.text = [NSString stringWithFormat:@"%.02f",[_model.lsj doubleValue]];
    _member.text = [NSString stringWithFormat:@"%.02f",[_model.hyj doubleValue]];
    _discount.text = [NSString stringWithFormat:@"%.02f",[_model.zkj doubleValue]];
    _wholesale.text = [NSString stringWithFormat:@"%.02f",[_model.pfj doubleValue]];
    _price.text = [NSString stringWithFormat:@"%.02f",[_model.jj doubleValue]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
