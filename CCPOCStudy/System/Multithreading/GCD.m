//
//  GCD.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2017/12/14.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "GCD.h"

/*
 * Grand Central Dispatch 中枢调度器 纯c语言
 * 优势：
 ** GCD是苹果公司为多核的并发运算提出的解决方案
 ** GCD会自动利用更多的CPU内核
 ** GCD会自动管理线程的生命周期（创建，调度，销毁）
 */

/*
 * GCD两个执行任务的函数
 * dispatch_sync(dispatch_queue_t queue, dispatch_block_t block),同步函数
 * dispatch_async(dispatch_queue_t queue, dispatch_block_t block),异步函数
 */

@implementation GCD

@end
