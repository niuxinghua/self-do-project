//
//  XJHOrderObject.h
//  caxjh
//
//  Created by Yingchao Zou on 18/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHBaseObject.h"
#import "XJHOrderContract.h"

@interface XJHOrderObject : XJHBaseObject

@property (nonatomic, readwrite, copy) NSString *memberId;
@property (nonatomic, readwrite, copy) NSString *studentId;
@property (nonatomic, readwrite, copy) NSArray<XJHOrderContract *> *contracts;

@end
