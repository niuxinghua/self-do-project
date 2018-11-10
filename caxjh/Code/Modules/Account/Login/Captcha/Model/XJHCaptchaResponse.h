//
//  XJHCaptchaResponse.h
//  caxjh
//
//  Created by Yingchao Zou on 02/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHBaseObject.h"

@interface XJHCaptchaResponse : XJHBaseObject

@property (nonatomic, readwrite, copy) NSString *type;
@property (nonatomic, readwrite, copy) NSString *content;
@property (nonatomic, readwrite, copy) NSString *text;
@property (nonatomic, readwrite, copy) NSString *code;
@property (nonatomic, readwrite, copy) NSString *data;

@end
