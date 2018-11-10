//
//  SendKeyTextView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/8.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "SendKeyTextView.h"
#import "Masonry.h"
#import "JMDropMenu.h"
#import "JMDropMenu.h"
#import "Const.h"
@interface SendKeyTextView()<JMDropMenuDelegate>


@property (nonatomic,strong)UIButton *rightButton;

@property (nonatomic,strong)UILabel *leftLable;

@property (nonatomic,assign)BOOL isChecked;

@property (nonatomic,strong)UIView *mylineView;

@end

@implementation SendKeyTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
     
        _rightButton = [[UIButton alloc]init];
        [self addSubview:_rightButton];
        
        _leftLable = [[UILabel alloc]init];
        _leftLable.textColor = [UIColor colorWithRed:150/255.0 green:160/255.0 blue:123/255.0 alpha:1.0];
        //_leftLable.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:250/255.0 blue:244/255.0 alpha:1.0];
        [self addSubview:_leftLable];
        
       
        _leftLable.textColor = UICOLOR_HEX(0x336130);
        
        self.leftIcon.hidden = YES;
        self.backgroundColor = UICOLOR_HEX(0xeff3ec);
       // self.backgroundColor = [UIColor whiteColor];
        _mylineView = [[UIView alloc]init];
        [self addSubview:_mylineView];
        
    }
    
    return  self;
}


- (void)layoutSubviews
{
   // [super layoutSubviews];
  
    
    

    
    if (_type == SendKeyTextViewTypeTextAndButton) {
        [self.leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(10);
            
            make.centerY.equalTo(self);
            
            make.height.equalTo(@40);
            
            make.width.equalTo(@80);
            
        }];
        [self.textFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.leftLable.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-150);
            make.height.equalTo(@30);
            make.centerY.equalTo(self.mas_centerY);
            
        }];
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.textFeild.mas_right).offset(10);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@30);
            make.centerY.equalTo(self.mas_centerY);
            
        }];
        [self.rightButton setTitle:[kMultiTool getMultiLanByKey:@"pkey"] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"arrowdown"] forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor colorWithRed:150/255.0 green:160/255.0 blue:123/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [self.rightButton addTarget:self action:@selector(didTouchSelectType:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else if (_type == SendKeyTextViewTypeTextAndButtonNoImage)
    {
        [self.leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(10);
            
            make.centerY.equalTo(self);
            
            make.height.equalTo(@40);
            
            make.width.equalTo(@80);
            
        }];
        [self.textFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.leftLable.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-80);
            make.height.equalTo(@30);
            make.centerY.equalTo(self.mas_centerY);
            
        }];
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.textFeild.mas_right).offset(10);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@30);
            make.centerY.equalTo(self.mas_centerY);
            
        }];
        
     
        [self.rightButton setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    
        [self.rightButton addTarget:self action:@selector(didTouchScanButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    else if (_type == SendKeyTextViewTypeNone)
    {
        [self.leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(10);
            
            make.centerY.equalTo(self);
            
            make.height.equalTo(@40);
            
            make.width.equalTo(@80);
            
        }];
        [self.textFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.leftLable.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-80);
            make.height.equalTo(@30);
            make.centerY.equalTo(self.mas_centerY);
            
        }];
        
        
        
    }
    else if (_type == SendKeyTextViewTypeCheckBox)
    {
        [self.leftLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(10);
            
            make.centerY.equalTo(self);
            
            make.height.equalTo(@40);
            
            make.width.equalTo(@200);
            
        }];
        [self.textFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.leftLable.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-80);
            make.height.equalTo(@30);
            make.centerY.equalTo(self.mas_centerY);
            
        }];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.textFeild.mas_right).offset(10);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@30);
            make.centerY.equalTo(self.mas_centerY);
            
        }];
  
        [self.rightButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(didtouchcheckbox) forControlEvents:UIControlEventTouchUpInside];
       
        
        
        
        
    }
    
    [_mylineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    _mylineView.backgroundColor = UICOLOR_HEX(0xdee0dd);
    
    
}


#pragma mark methods

- (void)didtouchcheckbox
{
    _isChecked = !_isChecked;
    
    if (_isChecked) {
          [self.rightButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }else{
        
      [self.rightButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        
    }
    if (self.checkBlock) {
        self.checkBlock(_isChecked);
    }
    
    
}



- (void)didTouchScanButton:(id)sender
{
    if (self.scanBlock) {
        self.scanBlock();
    }
    
    
    
}


- (void)didTouchSelectType:(id)sender
{
    NSArray *titleArray = @[[kMultiTool getMultiLanByKey:@"pkey"],[kMultiTool getMultiLanByKey:@"tkey"]];
    
    
    [JMDropMenu showDropMenuFrame:CGRectMake(self.frame.size.width - 120, 64 + 60, 120, titleArray.count *40 + 10) ArrowOffset:16.f TitleArr:titleArray ImageArr:@[@"",@""] Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeTitle RowHeight:40.f Delegate:self];

    
    
    
    
    
    
}
- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image
{
    if ([title isEqualToString:[kMultiTool getMultiLanByKey:@"pkey"]]) {
        if (self.permanentBlock) {
            self.permanentBlock(YES);
        }
    }else{
        if (self.permanentBlock) {
         self.permanentBlock(NO);
        }
    }
    
    
}
- (void)setLeftIcon:(UIImage *)lefticon textFeildText:(NSString *)text rightLable:(NSString *)rightText textFeildCanEdit:(BOOL)canedit
{
    [self.leftIcon setImage:lefticon];
    NSMutableAttributedString *attrPlaceHolder = [[NSMutableAttributedString alloc]initWithString:text];
    [attrPlaceHolder addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, text.length)];
    [attrPlaceHolder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:12]
                        range:NSMakeRange(0, text.length)];
    

    self.textFeild.attributedPlaceholder = attrPlaceHolder;
    self.rightLable.text = rightText;
    self.textFeild.enabled = canedit;
    self.textFeild.textColor = UICOLOR_HEX(0x336130);
    
    
    
}
#pragma mark setters

- (void)setLeftText:(NSString *)leftText
{
    
    self.leftLable.text = leftText;
    
}

- (void)setType:(SendKeyTextViewType)type
{
    _type = type;
    
    [self setNeedsLayout];
    
    
}

- (void)setRightText:(NSString *)text
{
    [_rightButton setTitle:text forState:UIControlStateNormal];
    
    
}

@end
