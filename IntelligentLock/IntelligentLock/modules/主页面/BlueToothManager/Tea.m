//
//  Tea.m
//  IntelligentLock
//
//  Created by lxc on 18/2/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tea.h"

static Tea *manager;
static int KEY[4] = { // 加密解密所用的KEY
    0xD2C1C3C0, 0xCCD8B5E7, 0xD7D3D4AC, 0xB9FAB6B0
    //            0x85116032, 0x52142588, 0x36457321, 0x95273217
};
@implementation Tea
// 若某字节为负数则需将其转成无符号正数
+  (int) transform:(Byte* )temp {
    int tempInt = (int) temp;
    if (tempInt < 0) {
        tempInt += 256;
    }
    return tempInt;
}
// byte[]型数据转成int[]型数据
+ (int*) byteToInt:(Byte *)content offset:(int)offset{
    int len=sizeof(content)/sizeof(content[0]);
    int result[len >> 2];
    for (int i = 0, j = offset; j < len; i++, j += 4) {
//        result[i] = transform(content[j + 3]) | transform(content[j + 2]) << 8 | transform(content[j + 1]) << 16
//        | (int) content[j] << 24;
//        result[i] = (content[j] & 0xff) | ((content[j + 1] << 8) & 0xff00)| ((content[j + 2] << 24) >>> 8) | (content[j + 3] << 24);
        result[i] = ((content[j] & 0xFF)
                     | ((content[j+1] & 0xFF)<<8)
                     | ((content[j+2] & 0xFF)<<16)
                     | ((content[j+3] & 0xFF)<<24));
    }
    return result;
    
}
// int[]型数据转成byte[]型数据
+ (Byte*)  intToByte:(int*)content offset:(int)offset {
    int len=sizeof(content)/sizeof(content[0]);
    Byte* result[len<< 2];// 乘以2的n次方 == 左移n位 即
    // content.length * 4 ==
    // content.length << 2
    for (int i = 0, j = offset; j < len; i++, j += 4) {
        
        result[j] = (Byte) (content[i] & 0xff);// 最低位
        result[j + 1] = (Byte) ((content[i] >> 8) & 0xff);// 次低位
        result[j + 2] = (Byte) ((content[i] >> 16) & 0xff);// 次高位
        result[j + 3] = (Byte) ((content[i]>>24) & 0xFF);// 最高位,无符号右移。
    }
    return result;
}

// 通过TEA算法加密信息
+ (Byte*) encrypt:(Byte*) temp {
    int n = 0;
    int len=sizeof(temp)/sizeof(temp[0]);
    if (len % 8 != 0) {
        n = 8 - len % 8;// 若temp的位数不足8的倍数,需要填充的位数
    }
    Byte encryptStr [len + n];
    for (int j = 0; j < len ; j = j + 1) {
        encryptStr[j]=temp[j];
    }
    int* array = byteToInt(encryptStr, 0);
    int y = 0, z = 0, sum = 0;
    int delta = 0x9e3779b9; // 这是算法标准给的值
    int a = KEY[0], b = KEY[1], c = KEY[2], d = KEY[3];
    len=sizeof(array)/sizeof(array[0]);
    for (int j = 0; j < len - 1; j = j + 2) {
        y = array[j];
        z = array[j + 1];
        sum = 0;
        for (int i = 0; i < 32; i++) {
            sum += delta;
            y += ((z << 4) + a) ^ (z + sum) ^ ((z >> 5) + b);
            z += ((y << 4) + c) ^ (y + sum) ^ ((y >> 5) + d);
        }
        array[j] = y;
        array[j + 1] = z;
    }
    return intToByte(array, 0);
}

// 通过TEA算法加密信息
+ (Byte*)decrypt:(Byte*) temp {
    int n = 0;
    int len=sizeof(temp)/sizeof(temp[0]);
    if (len % 8 != 0) {
        n = 8 - len % 8;// 若temp的位数不足8的倍数,需要填充的位数
    }
    Byte encryptStr [len + n];
    for (int j = 0; j < len ; j = j + 1) {
        encryptStr[j]=temp[j];
    }
    int* array = byteToInt(encryptStr, 0);
    int y = 0, z = 0, sum = 0xC6EF3720;
    int delta = 0x9e3779b9; // 这是算法标准给的值
    int a = KEY[0], b = KEY[1], c = KEY[2], d = KEY[3];
    len=sizeof(array)/sizeof(array[0]);

    for (int i = 0; i < len - 1; i = i + 2) {
        y = array[i];
        z = array[i + 1];
        sum = 0xC6EF3720;
        for (int j = 0; j < 32; j++) {
            z -= ((y << 4) + c) ^ (y + sum) ^ ((y >> 5) + d);
            y -= ((z << 4) + a) ^ (z + sum) ^ ((z >> 5) + b);
            sum -= delta;
        }
        array[i] = y;
        array[i + 1] = z;
    }
    return intToByte(array, 0);
}

/**
 * 校验和
 *
 * @param temp
 * @return
 */
+ (int) check:(Byte*)temp {
    int sum = 0;
    int len=sizeof(temp)/sizeof(temp[0]);
    if (len > 2) {
        for (int i = 1; i < len - 2; i++) {
            int a = temp[i];
            if (a < 0) {
                a += 256;
            }
            sum += a;
        }
    }
    return sum & 0x000000FF;
}

@end
