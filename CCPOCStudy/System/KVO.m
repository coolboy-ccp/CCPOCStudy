//
//  KVO.m
//  CCPOCStudy
//
//  Created by Ceair on 2017/12/1.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "KVO.h"

#pragma mark -- Introduction --
/* KVO Key-Value Observing 观察者模式
 ** Key-value observing is a mechanism that allows objects to be notified of changes to specified properties of other objects.
 ** 当其他对象(包括self)的属性的特定属性发生改变时,通知当前对象的一种机制被称作KVO
 
 
 * 要实现KVO,需要进行下面几步:
 ** Register the observer with the observed object using the method addObserver:forKeyPath:options:context:.
 ** 使用addObserver:forKeyPath:options:context:注册观察者和被观察者
 ** Implement observeValueForKeyPath:ofObject:change:context: inside the observer to accept change notification messages.
 ** 在观察者类中实现observeValueForKeyPath:ofObject:change:context:,接收变化通知消息
 ** Unregister the observer using the method removeObserver:forKeyPath: when it no longer should receive messages. At a minimum, invoke this method before the observer is released from memory.
 ** 当观察者不需要接收消息时,使用removeObserver:forKeyPath:注销观察者.至少需要在观察者从内存中释放的时候调用该方法
 */

#pragma mark -- Registering for Key-Value Observing
/*
 ** An observing object first registers itself with the observed object by sending an addObserver:forKeyPath:options:context: message, passing itself as the observer and the key path of the property to be observed. The observer additionally specifies an options parameter and a context pointer to manage aspects of the notifications.
 
** 观察者对象一旦通过发送addObserver:forKeyPath:options:context:消息注册他自己和被观察者对象,它自己成为观察者,而属性的路径会被监测.观察者还指定了options参数和context指针来管理通知的各个方面.
 ** Options 是一个enum,它会决定change dictionary的内容和通知生成的方式
 *** NSKeyValueObservingOptionOld change dictionary提供变化之前的值
 *** NSKeyValueObservingOptionNew change dictionary提供变化之后的值
 **** NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew change dictionary提供变化之前和变化之后的值
 *** NSKeyValueObservingOptionInitial 在观察者建立是立刻发送一次change notification(在addObserver:forKeyPath:options:context:返回之前)
 *** NSKeyValueObservingOptionPrior 在改变之前发送通知
 
 */

@implementation KVO

@end
