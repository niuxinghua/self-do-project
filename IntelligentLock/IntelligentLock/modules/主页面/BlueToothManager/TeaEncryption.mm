//
//  TeaEncryption.m
//  IntelligentLock
//
//  Created by kent on 2018/3/1.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "TeaEncryption.h"

//0x85116032, 0x52142588, 0x36457321, 0x95273217
const uint32_t qq_key[4]={0x85116032, 0x52142588, 0x36457321, 0x95273217};


void encrypt(uint8_t *buf, uint16_t len)
{
    uint8_t i,n;
    uint32_t *ptr;
    uint32_t y, z, sum=0;         /* set up */
    uint32_t delta=0x9e3779b9;                 /* a key schedule constant */
    uint32_t a=qq_key[0], b=qq_key[1], c=qq_key[2], d=qq_key[3];   /* cache key */
    
    if((len%8) != 0)
        return;
    ptr = (uint32_t *)buf;
    
    n = 0;
    while(len)
    {
        y = ptr[n];
        z = ptr[n+1];
        sum = 0;
        for (i=0; i < 32; i++) {                        /* basic cycle start */
            sum += delta;
            y += ((z<<4) + a) ^ (z + sum) ^ ((z>>5) + b);
            z += ((y<<4) + c) ^ (y + sum) ^ ((y>>5) + d);/* end cycle */
        }
        ptr[n]=y;
        ptr[n+1]=z;
        n+=2;
        len -= 8;
    }
}


void decrypt(uint8_t *buf, uint16_t len)
{
    uint8_t i,n;
    uint32_t *ptr;
    uint32_t y, z, sum=0xC6EF3720u; /* set up */
    uint32_t delta=0x9e3779b9u;                  /* a key schedule constant */
    uint32_t a=qq_key[0], b=qq_key[1], c=qq_key[2], d=qq_key[3];    /* cache key */
    
    if((len%8) != 0)
        return;
    ptr = (uint32_t *)buf;
    n = 0;
    while(len)
    {
        y = ptr[n];
        z = ptr[n+1];
        sum=0xC6EF3720;
        for(i=0; i<32; i++) {                            /* basic cycle start */
            z -= ((y<<4) + c) ^ (y + sum) ^ ((y>>5) + d);
            y -= ((z<<4) + a) ^ (z + sum) ^ ((z>>5) + b);
            sum -= delta;                                /* end cycle */
        }
        ptr[n]=y;
        ptr[n+1]=z;
        n+=2;
        len -= 8;
    }
}
