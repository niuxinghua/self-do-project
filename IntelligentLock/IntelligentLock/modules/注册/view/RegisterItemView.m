//
//  RegisterItemView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/7.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "RegisterItemView.h"
#import "Masonry.h"
#import "JKCountDownButton.h"
#import "Const.h"
@interface RegisterItemView()

@property(nonatomic,strong)UIView *xlineView;

@end
@implementation RegisterItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.getVerify];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didtaprightButton)];
        self.rightLable.userInteractionEnabled = YES;
        [self.rightLable addGestureRecognizer:tap];
        UIGestureRecognizer *rec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:rec];
        
       _xlineView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        _xlineView.backgroundColor = UICOLOR_HEX(0xdee0dd);
        [self addSubview:_xlineView];
    }
    
    return self;
}


- (void)didtaprightButton
{
    if (self.didtapRightLableBlcok) {
        self.didtapRightLableBlcok();
    }
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.getVerify mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.right.equalTo(self.rightLable.mas_right);
        make.centerY.equalTo(self.rightLable.mas_centerY);
        
    }];
    [self.xlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(@1);
        make.right.equalTo(self.rightLable.mas_right);
        make.width.equalTo(self);
        make.bottom.equalTo(self);
       // make.centerY.equalTo(self.rightLable.mas_centerY);
        
    }];
    
   self.backgroundColor = UICOLOR_HEX(0xeff3ec);
}

- (void)setLeftIcon:(UIImage *)lefticon textFeildText:(NSString *)text rightLable:(NSString *)rightText textFeildCanEdit:(BOOL)canedit
{
    self.lineView.hidden = YES;
   // self.backgroundColor = [UIColor whiteColor];
    [self.leftIcon setImage:lefticon];
    NSMutableAttributedString *attrPlaceHolder = [[NSMutableAttributedString alloc]initWithString:text];
    [attrPlaceHolder addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, text.length)];
    self.textFeild.attributedPlaceholder = attrPlaceHolder;
    self.rightLable.text = rightText;
    self.rightLable.textColor = [UIColor grayColor];
    self.textFeild.enabled = canedit;
    self.textFeild.textColor = UICOLOR_HEX(0x336130);
    self.backgroundColor = UICOLOR_HEX(0xeff3ec);
    
    
}
- (void)showButton:(BOOL)show
{
    
    self.getVerify.hidden = !show;
    
}
- (void)getVerifyBlock
{
    if (self.getVerifyblock) {
        self.getVerifyblock();
    }
    
    
}
#pragma mark UI getter

- (UIButton *)getVerify
{
    if (!_getVerify) {
        _getVerify = [[JKCountDownButton alloc]init];
        [_getVerify setTitle:[kMultiTool getMultiLanByKey:@"fasongyanzhengma"] forState:UIControlStateNormal];
        [_getVerify setTitleColor:[UIColor colorWithRed:151/255.0 green:162/255.0 blue:144/255.0 alpha:1.0] forState:UIControlStateNormal];
        _getVerify.titleLabel.font = [UIFont systemFontOfSize:14];
        _getVerify.hidden = YES;
        [_getVerify addTarget:self action:@selector(getVerifyBlock) forControlEvents:UIControlEventTouchUpInside];
        [_getVerify countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
            sender.enabled = NO;
            
            [sender startCountDownWithSecond:60];
            
            [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"%zd",second];
                return title;
            }];
            [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                return [kMultiTool getMultiLanByKey:@"fasongyanzhengma"];
                
            }];
            
        }];
    }
    
    return _getVerify;
}
- (void)tap
{
    if (self.didtapViewBlcok) {
        self.didtapViewBlcok();
    }
    
    
}
- (void)stopCount
{
    [self.getVerify stopCountDown];
}
@end
