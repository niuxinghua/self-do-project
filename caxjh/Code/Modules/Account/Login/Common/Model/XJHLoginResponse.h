//
//  XJHLoginResponse.h
//  caxjh
//
//  Created by Yingchao Zou on 01/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHBaseObject.h"
#import "XJHUser.h"

@interface XJHLoginResponse : XJHBaseObject

@property (nonatomic, readwrite, copy) NSString *type;
@property (nonatomic, readwrite, copy) NSString *content;
@property (nonatomic, readwrite, copy) NSString *text;
@property (nonatomic, readwrite, copy) NSString *code;
@property (nonatomic, readwrite, copy) XJHUser *data;

@end
