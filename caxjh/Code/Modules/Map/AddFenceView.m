//
//  AddFenceView.m
//  caxjh
//
//  Created by niuxinghua on 2017/12/2.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "AddFenceView.h"
#import "AddFenceTopView.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "MyRadioButton.h"
@interface AddFenceView ()
@property (nonatomic,strong)AddFenceTopView *topView;


@property (nonatomic,strong)UILabel *lable1;
@property (nonatomic,strong)UITextField *nameTextFeild;


@property (nonatomic,strong)UILabel *lable2;


@property (nonatomic,strong)UILabel *lable3;

@property (nonatomic,strong)UILabel *lable4;

@property (nonatomic,strong)UISlider *slider;

@property (nonatomic,strong)MyRadioButtonGroup *radio;

@property (nonatomic,strong)UIButton *confirmButton;

@property (nonatomic,strong)NSString *alarmType;

@end
@implementation AddFenceView

- (instancetype)init
{
    
    if (self = [super init]) {
        _topView = [[AddFenceTopView alloc]init];
        [self addSubview:_topView];
        
        
        _lable1 = [[UILabel alloc]init];
        _lable1.textColor = [UIColor colorwithHexString:@"#333333"];
        _lable1.text = @"围栏名称";
        [self addSubview:_lable1];
        
        _lable2 = [[UILabel alloc]init];
        _lable2.textColor = [UIColor colorwithHexString:@"#333333"];
        _lable2.text = @"围栏类型";
        [self addSubview:_lable2];
        
        _lable3 = [[UILabel alloc]init];
        _lable3.textColor = [UIColor colorwithHexString:@"#333333"];
        _lable3.text = @"围栏半径";
        [self addSubview:_lable3];
        
        _lable4 = [[UILabel alloc]init];
        _lable4.textColor = [UIColor colorwithHexString:@"#333333"];
        _lable4.text = @"200米";
        _lable4.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lable4];
        
        _radio = [[MyRadioButtonGroup alloc]initWithFrame:CGRectMake(0,0,250,40)];
        _radio.direction = Horizontal;
        MyRadioButton *radio1 = [[MyRadioButton alloc]initWithTitle:@"进围栏报警" andIndex:0 withFrame:CGRectMake(0,0,100,40) autoSubSize:NO];
        _radio.delegate = self;
        [radio1 setSelected:YES];
        [_radio setDefaultSeletedWithIndex:0];
         _alarmType = @"enterFenceAlarm";
        [_radio addRadioButton:radio1];
        
           MyRadioButton *radio2 = [[MyRadioButton alloc]initWithTitle:@"出围栏报警" andIndex:1 withFrame:CGRectMake(0,0,100,40) autoSubSize:NO];
        [_radio addRadioButton:radio2];
        _radio.direction = Horizontal;
        [self addSubview:_radio];
       
        _nameTextFeild = [[UITextField alloc]init];
        
        _nameTextFeild.placeholder = @"请输入围栏名称";
        
        [self addSubview:_nameTextFeild];
        
        _slider = [[UISlider alloc]init];
        
        [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_slider];
        
        _confirmButton = [[UIButton alloc]init];
        
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        
        [_confirmButton setBackgroundColor:[UIColor colorwithHexString:@"#ff6767"]];
        [_confirmButton addTarget:self action:@selector(didConfirm) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_confirmButton];
    }
    return self;
}
- (void)didConfirm
{
//    { "table": "Fence",
//        "fields":{
//            "name":"电子围栏4",
//            "latDireaction":"E",
//            "latitude":"120.62367",
//            "lonDirection":"N",
//            "longitude":"36.82384782478",
//            "radius":"200",
//            "alarmType":"outFenceAlarm",
//            "state":"yes",
//            "watch.id":"ff8080815fe29647015fe29b14680000"}
//    }
//
    
   // (NSString *name,NSString *radius,NSString *alarmType,NSString *state)
    
    NSString *name = _nameTextFeild.text;
    if (!name) {
        name = @"";
    }
    NSString *radius = [NSString stringWithFormat:@"%f",_slider.value * 4800 + 200];
    NSString *location = [_topView getAd];
    if (!location) {
        location = @"";
    }
    
    if (self.confirmBlock) {
        self.confirmBlock(name, radius,_alarmType,@"yes",location);
    }
    
}
- (void)sliderChange:(UISlider *)slider
{
    if (_block) {
        _block(slider.value * 4800 + 200);
        [_lable4 setText:[NSString stringWithFormat:@"%d米",(int)(slider.value * 4800) + 200]];
    }
}
- (void)setTopAddress:(NSString*)add
{
    [_topView setTopAddress:add];
    
}
- (void)setBootomAddress:(NSString*)add
{
    [_topView setBootomAddress:add];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@70);
        
    }];
    
    [_lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(20);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
        make.top.equalTo(_topView.mas_bottom).offset(10);
    }];
    
    [_nameTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_lable1.mas_right).offset(10);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.centerY.equalTo(_lable1.mas_centerY);
        
    }];
    [_lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(20);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
        make.top.equalTo(_lable1.mas_bottom).offset(10);
    }];
    [_lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(20);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
        make.top.equalTo(_lable2.mas_bottom).offset(10);
    }];
    
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_lable3.mas_right).offset(10);
        make.width.equalTo(@200);
        make.height.equalTo(@10);
        make.centerY.equalTo(_lable3.mas_centerY);
    }];
    [_lable4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_slider.mas_right);
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(_slider.mas_centerY);
        make.height.equalTo(@40);
    }];
    [_radio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lable2.mas_right).offset(10);
        make.width.equalTo(@280);
        make.height.equalTo(@40);
        make.centerY.equalTo(_lable2.mas_centerY).offset(10);
    }];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.mas_bottom).offset(-30);
    }];
   
    
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    _nameTextFeild.text = [dic objectForKey:@"name"];
    if ([[dic objectForKey:@"alarmType"] isEqualToString:@"enterFenceAlarm"]) {
        [_radio setDefaultSeletedWithIndex:0];
    }else{
        [_radio setDefaultSeletedWithIndex:1];
    }
    int radius = [[dic objectForKey:@"radius"] intValue];
    [_slider setValue:(radius-200)/4800.0];
    [_lable4 setText:[NSString stringWithFormat:@"%d米",(int)(_slider.value * 4800) + 200]];
    
}

#pragma mark -delegate
-(void)myRadioButtonGroup:(MyRadioButtonGroup *)radioButtonGruop clickIndex:(int)index
{
    if (index == 0) {
        _alarmType = @"enterFenceAlarm";
    }else
    {
        _alarmType = @"outFenceAlarm";
    }
    
    
}

@end
