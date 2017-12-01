//
//  KVC.h
//  CCPOCStudy
//
//  Created by Ceair on 2017/11/29.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    float x,y,z;
} TFs;

@interface KVC : NSObject

//
@property (nonatomic, strong) NSString *kvc_1;
//
@property (nonatomic, strong) KVC *kvcInstance;
//
@property (nonatomic) TFs tfs;


@end
