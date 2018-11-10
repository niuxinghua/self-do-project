//
//  XJHIMTokenResponse.h
//  caxjh
//
//  Created by Yingchao Zou on 09/10/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHBaseObject.h"

@interface XJHIMTokenResponse : XJHBaseObject

@property (nonatomic, readwrite, copy) NSString *code;
@property (nonatomic, readwrite, copy) NSString *userId;
@property (nonatomic, readwrite, copy) NSString *token;
@property (nonatomic, readwrite, copy) NSString *errorMessage;

@end
