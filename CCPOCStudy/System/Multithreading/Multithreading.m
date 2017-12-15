//
//  Multithreading.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2017/12/13.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "Multithreading.h"

/*
 * 进程：
 ** 进程是指在系统中正在运行的一个应用程序，每个进程之间是独立的，每个进程均运行在其专用且受保护的内存空间内

 * 线程：
 ** 一个进程想要执行任务，必须要有线程（每一个进程至少有一条线程）
 ** 线程是进程的基本执行单元，一个进程（程序）的所有任务都在线程中执行
 
 * 线程的串行
 ** 一个线程中的任务的执行是串行的，如果在一个线程中执行多个任务，只能一个一个按顺序执行，也就是说，在同一时间内，一个线程只能执行一个任务
 
 * 多线程：
 ** 一个进程中可以开启多条线程，每条线程可以并行执行不同的任务
 ** 同一时间，CPU只能处理一条线程，只有一条线程在执行。多线程并发执行，其实是CPU快速的在多条线程之间调度。
 ** 如果CPU调度线程的时间足够快，就造成了多线程并发执行的假象。
 ** 如果线程过多，CPU会在N多线程之间调度，消耗大量的CPU资源，线程的执行效率降低
 
 * 多线程的优缺点
 ** 优点
 *** 能适当提高程序的执行效率
 *** 能适当提高资源利用率（CPU，内存利用率）
 ** 缺点
 *** 开启线程需要占用一定的内存空间（默认情况下，主线程占用1M，子线程占用512KB），如果开启大量的线程，会占用大量的内存空间，降低程序的性能
 *** 线程越多，CPU在调度线程上的开销就越大
 *** 程序设计更加复杂：多线程之间的通信，多线程的数据共享
 
 * 多线程在ios开发中的应用
 ** 主线程：一个ios程序运行后，默认会开启一条线程，称为‘主线程’或‘UI线程’
 *** 主线程的主要作用：
 **** 显示、刷新UI界面
 **** 处理UI事件（点击、滚动、拖拽等）
 */


/*
 * 线程安全
 * 多线程的安全隐患
 ** 资源共享：一块资源可能会被多个线程共享，也就是多个线程可能会访问同一快资源。当多个线程访问同一快资源时，很容易引发数据错乱和数据安全问题
 
 
 */

@interface Multithreading ()

//
@property (nonatomic, strong) NSThread *th1;
//
@property (nonatomic, strong) NSThread *th2;
//
@property (nonatomic, strong) NSThread *th3;
//剩余票数
@property (nonatomic, assign) int leftTicket;
//
@property (atomic, assign) int age;

@end

@implementation Multithreading

/**/

- (instancetype)init
{
    self = [super init];
    if (self) {
        _leftTicket = 10;
        _th1 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
        _th1.name = @"conductor A";
        _th2 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
        _th2.name = @"conductor B";
        _th3 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
        _th3.name = @"conductor C";
        
        [_th1 start];
        [_th2 start];
        [_th3 start];
        
    }
    return self;
}

/* 存在安全隐患的代码 */
- (void)sellTickets {
    while (1) {
        if (_leftTicket > 0) {
            [NSThread sleepForTimeInterval:0.002];
            _leftTicket -= 1;
            NSThread *th = [NSThread currentThread];
            NSLog(@"%@ sell one ticket, left %d tickets",th,_leftTicket);
        }
        else {
            [NSThread exit];
        }
    }
    
}


/*
 * 添加互斥锁
 * 优点: 有效的防止因多线程抢夺资源造成的数据安全问题
 * 缺点： 需要消耗大量的CPU资源
 * 互斥锁使用的前提：多条线程抢夺同一块资源
 * 互斥锁，就是使用了线程同步技术
 */
- (void)sellTickets_synchronized {
    while (1) {
        @synchronized(self) {
            if (_leftTicket > 0) {
                [NSThread sleepForTimeInterval:0.002];
                _leftTicket -= 1;
                NSThread *th = [NSThread currentThread];
                NSLog(@"%@ sell one ticket, left %d tickets",th,_leftTicket);
            }
            else {
                [NSThread exit];
            }
            
        }
    }
}

/*
 * 原子性和非原子性
 * oc在定义属性时，有nonatomic，atomic两种选择
 ** atomic:原子属性，为setter方法加锁（默认）
 ** nonatomic:非原子属性，不会为setter加锁
 */
- (void)setAge:(int)age {
    @synchronized(self) {
        _age = age;
    }
}

/*
 * 线程间的通信
 * - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
 * - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait;
  ps: 关于wait。如果YES，则会阻塞当前线程，直到aSelector执行完毕，如果NO，则不需要等到aSelector执行完毕
 */

- (void)testWait {
        [NSThread detachNewThreadWithBlock:^{
            NSLog(@"%s_before",__func__);
            [self performSelectorOnMainThread:@selector(test_YES) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(test_YES) withObject:nil waitUntilDone:NO];
            NSLog(@"%s_after",__func__);
        }];
}

- (void)test_YES {
    [NSThread sleepForTimeInterval:1.0];
    NSLog(@"%s",__func__);
}

- (void)test_NO {
    [NSThread sleepForTimeInterval:1.0];
    NSLog(@"%s",__func__);
}

@end
