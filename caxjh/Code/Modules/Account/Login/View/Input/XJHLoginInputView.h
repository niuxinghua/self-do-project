//
//  XJHLoginInputView.h
//  caxjh
//
//  Created by Yingchao Zou on 31/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHBaseView.h"

@interface XJHLoginInputView : XJHBaseView

@property (nonatomic, readwrite, strong) UITextField *textFieldRole;
@property (nonatomic, readwrite, strong) UITextField *textFieldNumber;
@property (nonatomic, readwrite, strong) UITextField *textFieldCode;

@property (nonatomic, readwrite, strong) UIImageView *imageViewCode;

@property (nonatomic, readwrite, strong) UIButton *arrowButton;

@end
