//
//  LoadInitialize+CategoryLoadInitialze.m
//  CCPOCStudy
//
//  Created by Ceair on 2017/12/1.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "LoadInitialize+CategoryLoadInitialze.h"

@implementation LoadInitialize (CategoryLoadInitialze)

+ (void)load {
    NSLog(@"categoryLI_load");
}

+ (void)initialize {
    NSLog(@"categoryLI_initialize");
}

- (void)categoryMethod {
    NSLog(@"%s",__func__);
}

@end
