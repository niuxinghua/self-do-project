//
//  LoginTextView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/6.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LoginTextView.h"
#import "Masonry.h"
@interface LoginTextView()<UITextFieldDelegate>


@end
@implementation LoginTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        [self addSubview:self.leftIcon];
        [self addSubview:self.textFeild];
        [self addSubview:self.rightLable];
        [self addSubview:self.lineView];
    

        
        
    }
    
   // self.backgroundColor = [UIColor colorWithRed:120/255.0 green:156/255.0 blue:106/255.0 alpha:1.0];
    
    return self;
}
#pragma mark UI getter
- (UIImageView*)leftIcon
{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc]init];
        _leftIcon.contentMode = UIViewContentModeCenter;
    }
    
    return _leftIcon;
    
}
- (UITextField*)textFeild
{
    if (!_textFeild) {
        _textFeild = [[UITextField alloc]init];
        _textFeild.delegate = self;
        [_textFeild setValue:[UIColor greenColor] forKeyPath:@"_placeholderLabel.textColor"];
        
    }
    
    return _textFeild;
    
}

- (UILabel*)rightLable
{
    if (!_rightLable) {
        _rightLable = [[UILabel alloc]init];
        _rightLable.textColor = [UIColor whiteColor];
        _rightLable.font = [UIFont systemFontOfSize:12];
    }
    
    return _rightLable;
    
}
- (UIView*)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    
    return _lineView;
    
}

#pragma mark life circle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [_leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(15);
        make.width.height.equalTo(@22);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    [_textFeild mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_leftIcon.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.equalTo(@2);
        make.top.equalTo(_textFeild.mas_bottom).offset(2);
        
    }];
    
    
    [_rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_textFeild.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    
    
}
- (void)setLeftIcon:(UIImage *)lefticon textFeildText:(NSString *)text rightLable:(NSString *)rightText textFeildCanEdit:(BOOL)canedit
{
    [_leftIcon setImage:lefticon];
    NSMutableAttributedString *attrPlaceHolder = [[NSMutableAttributedString alloc]initWithString:text];
    [attrPlaceHolder addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, text.length)];
    [attrPlaceHolder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, text.length)];
    _textFeild.attributedPlaceholder = attrPlaceHolder;
    _textFeild.font = [UIFont systemFontOfSize:14];
    _rightLable.text = rightText;
    _textFeild.enabled = canedit;
    _rightLable.textAlignment = NSTextAlignmentRight;
    _textFeild.textColor = [UIColor whiteColor];
    
    
    
}

- (NSString *)getText
{
    
    return _textFeild.text;
    
}
- (void)setTexfieldPassWordStyle
{
    
    _textFeild.secureTextEntry = YES;
    
}

- (NSString *)getPlaceHolderText
{
    
 return _textFeild.placeholder;
    
}
- (void)setPlaceHolderAttributedString:(NSAttributedString *)attr
{
    
    _textFeild.attributedPlaceholder = attr;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (self.didtapBlock) {
        self.didtapBlock();
    }
    
}

@end
