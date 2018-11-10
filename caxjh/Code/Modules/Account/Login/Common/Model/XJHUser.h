//
//  XJHUser.h
//  caxjh
//
//  Created by Yingchao Zou on 01/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJHUser : NSObject

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *phone;
@property (nonatomic, readwrite, copy) NSString *login;
@property (nonatomic, readwrite, copy) NSString *password;
@property (nonatomic, readwrite, copy) NSString *oldPassword;
@property (nonatomic, readwrite, copy) NSString *smsCode;
@property (nonatomic, readwrite, copy) NSString *email;
@property (nonatomic, readwrite, copy) NSString *theID; // id
@property (nonatomic, readwrite, copy) NSString *userType;
@property (nonatomic, readwrite, copy) NSString *adminId;
@property (nonatomic, readwrite, copy) NSString *isAdmin;
@property (nonatomic, readwrite, copy) NSString *admin;
@property (nonatomic, readwrite, copy) NSString *passwordText;
@property (nonatomic, readwrite, copy) NSString *confirmCode;
@property (nonatomic, readwrite, copy) NSString *type;
@property (nonatomic, readwrite, copy) NSString *nickName;
@property (nonatomic, readwrite, copy) NSString *schoolType;
@property (nonatomic, readwrite, copy) NSString *idCard;
@property (nonatomic, readwrite, copy) NSString *token;
@property (nonatomic, readwrite, copy) NSString *roleProfile;

@end
