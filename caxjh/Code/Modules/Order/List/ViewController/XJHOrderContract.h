//
//  XJHOrderContract.h
//  caxjh
//
//  Created by Yingchao Zou on 18/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHBaseObject.h"

@interface XJHOrderContract : XJHBaseObject

@property (nonatomic, readwrite, copy) NSString *contractId;
@property (nonatomic, readwrite, copy) NSString *contractSpecId;
@property (nonatomic, readwrite, copy) NSArray<NSString *> *members;

// XJHTODO 有点冗余 额外加个校验人数的
@property (nonatomic, readwrite, assign) NSUInteger memberCount;

@end
