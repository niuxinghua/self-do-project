//
//  TeaEncryption.h
//  IntelligentLock
//
//  Created by kent on 2018/3/1.
//  Copyright © 2018年 com.haier. All rights reserved.
//

//#import <Foundation/Foundation.h>
#include <sys/types.h>
#include <netinet/in.h>

void encrypt(uint8_t *buf, uint16_t len);
void decrypt(uint8_t *buf, uint16_t len);

