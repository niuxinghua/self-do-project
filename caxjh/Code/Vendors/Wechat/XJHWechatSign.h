//
//  XJHWechatSign.h
//  caxjh
//
//  Created by Yingchao Zou on 06/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHBaseObject.h"

@interface XJHWechatSign : XJHBaseObject

@property (nonatomic, readwrite, copy) NSString *_package;
@property (nonatomic, readwrite, copy) NSString *appid;
@property (nonatomic, readwrite, copy) NSString *sign;
@property (nonatomic, readwrite, copy) NSString *partnerid;
@property (nonatomic, readwrite, copy) NSString *prepayid;
@property (nonatomic, readwrite, copy) NSString *noncestr;
@property (nonatomic, readwrite, copy) NSString *timestamp;

@end
