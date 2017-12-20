//
//  CCPCoredataManager.m
//  CCPOCStudy
//
//  Created by chuchengpeng on 2017/12/15.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "CCPCoredataManager.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation CCPCoredataManager

@synthesize mom = _mom;
@synthesize moc = _moc;
@synthesize psc = _psc;




//http://blog.csdn.net/chaoyang805/article/details/53446551  创建堆栈
//http://www.cocoachina.com/ios/20160802/17260.html 进阶(模糊，分页，批处理)

/*
 * NSManagedObjectContext 托管对象上下文，使用initWithConcurrencyType:创建
 * NSManagedObjectModel 托管对象模型，一个模型关联着一个模型文件(.xcdatamodeld),存储着数据库的数据结构
 * NSPersitenStoreCoordinator 持久化存储协调器，负责协调存储区和上下文之间的关系
 * NSManagedObject 托管对象类，所有coreData中的托管对象都必须继承
 */

/*
 * 属性
 ** default Value:设置默认值，除了二进制类型
 ** optional：在使用时是否可选。如果是NO，MOC进行save操作时，这个属性必须有值，否则会返回一个error。默认是YES
 ** transient：设置当前属性是否只存在于内存，不被持久化到本地，如果设置为YES，这个属性就不参与持久化操作，属性的其他操作没有区别。transient非常适合存储一些在内存中缓存的数据。
 ** indexed:设置当前属性是否是索引。添加索引后可以有效的提升检索的操作速度。对于，如果删除此属性，其他地方需要作出相应的变化，所以速度会比较慢。
 ** validation：设置Max Value和Min Value,数值类型约束最大最小值，字符串约束长度，date约束时间。
 ** Reg.Ex.(Regular Expression)：设置正则表达式，用来验证和控制数据，不对数据本身有影响，只能用于string类型。
 ** Allows External Storage:存储比较大的二进制文件，是否存储在存储区外。If YES，存储文件超过1MB，都会存储到存储区之外。否则大型文件存储在存储区内，SQLite进行表操作时，效率会受到影响。
 
 */


/*
 * Relationships
 * 多表关联的删除关系（A.ab -> B）
 ** No Action:当A删除时，B不变，但会指向一个不存在的对象，一般不建议使用
 ** Nullify(作废):A删除时，B对象指向A的对象会置空，如果是一对多的关系，则从B容器中移除A。Default
 ** Cascade(级联):A被删除时，A对象指向的B对象也被删除
 ** Deny(拒绝):当对象B存在时，删除A操作会被拒绝
 */

/*
 * Fetch Requests
 * 配置请求对象（长按Add Entity,选中Add Feth Request）
 * 使用NSManagedObjectModel类的fetchRequestTemplateForName:方法获取这个请求的对象
 
 */

- (NSURL *)applicationDocumentDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)mom {
    if (_mom != nil) {
        return _mom;
    }
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"CCPOCStudy" withExtension:@"momd"];
    _mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    return _mom;
}

- (NSPersistentStoreCoordinator *)psc {
    if (_psc != nil) {
        return _psc;
    }
    _psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_mom];
    NSURL *sqlUrl = [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"CCPOCStudy.sqlite"];
    NSError *error;
    [_psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
    if (error) {
        NSLog(@"failed to create persitentStoreCoordinator cause of %@",error.localizedDescription);
    }
    return _psc;
}

- (NSManagedObjectContext *)moc {
    if (_moc != nil) {
        return _moc;
    }
    _moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _moc.persistentStoreCoordinator = self.psc;
    return _moc;
}


- (void)saveContext {
    if (self.moc != nil) {
        NSError *error;
        if ([self.moc hasChanges] && ![self.moc save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        }
        
    }
}

+ (instancetype)shareManager {
    static CCPCoredataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CCPCoredataManager new];
    });
    return manager;
}

#pragma mark -- Add --
- (void) saveEmployee {
    CCPCoredataManager *manager = [CCPCoredataManager shareManager];
    Employee *emp = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:manager.moc];
    emp.name = @"lbl";
    emp.height = 2.0;
    emp.birthday = [NSDate date];
    [manager saveContext];
}

#pragma mark -- Delete --
- (void) deleteEmployee {
    CCPCoredataManager *manager = [CCPCoredataManager shareManager];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",@"lbl"];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *employees = [manager.moc executeFetchRequest:request error:&error];
    [employees enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [manager.moc deleteObject:obj];
    }];
    [manager saveContext];
    if (error) {
        NSLog(@"CoreData delete data error: %@",error.localizedDescription);
    }
}

#pragma mark -- Update --
- (void) updateEmployee {
    CCPCoredataManager *manager = [CCPCoredataManager shareManager];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",@"lbl"];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *employees = [manager.moc executeFetchRequest:request error:&error];
    [employees enumerateObjectsUsingBlock:^(Employee *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.height = 2.1;
    }];
    [manager saveContext];
    if (error) {
        NSLog(@"CoreData Update Data Error: %@",error.localizedDescription);
    }
    
}

#pragma mark -- 模糊查询 --

/*
 * @"name BEGINSWITH %@", @"lxz"--以lxz开头
 * @"name ENDSWITH %@", @"lxz"--以lxz结尾
 * @"name contains %@", @"lxz"--包含lxz
 * @"name LIKE %@", @"*lxz*"--包含lxz
 */

//查询name包含lbl字段的employee
- (void)vagueRequest {
    CCPCoredataManager *manager = [CCPCoredataManager shareManager];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE %@",@"*lbl*"];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *employees = [manager.moc executeFetchRequest:request error:&error];
    NSLog(@"emloyees: %@",employees);
}

#pragma mark -- NSFetchRequest --

/*
 * fetchRequestWithEntityName: 指定查询表名
 * predicate: 设置查询条件
 * sortDescriptors: 设置结果数组的排序方式
 * fetchOffset: 设置从第几个开始获取
 * fetchLimit: 设置每次获取多少个
 */

/*
 * resultType: 返回类型
 ** NSManagedObjectResultType: 返回NSManagedObject的子类
 ** NSManagedObjectIDResultType: 返回NSManagedObjectID对象，也就是NSManagedObject的ID，对内存占用比较小。MOC可以通过ID获取托管对象，通过缓存NSManagedObjectID参数节省内存消耗
 ** NSDictionaryResultType: 返回字典类型对象
 ** NSCountResultType: 返回请求结果的count值，这个操作是发生在数据库层级的，不需要将数据加载到内存中
 */

#pragma mark -- 获取count --
//方法一：设置resultType = NSCountResultType
//方法二：使用NSUInteger count = [context countForFetchRequest:fetchRequest error:&error];

#pragma mark -- 位运算 --
- (void)bitOperation {
    CCPCoredataManager *manager = [CCPCoredataManager shareManager];
    // 创建请求对象，指明操作Employee表
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    // 设置返回值为字典类型，这是为了结果可以通过设置的name名取出，这一步是必须的
    fetchRequest.resultType = NSDictionaryResultType;
    // 创建描述对象
    NSExpressionDescription *expressionDes = [[NSExpressionDescription alloc] init];
    // 设置描述对象的name，最后结果需要用这个name当做key来取出结果
    expressionDes.name = @"sumOperatin";
    // 设置返回值类型，根据运算结果设置类型
    expressionDes.expressionResultType = NSFloatAttributeType;
    // 创建具体描述对象，用来描述对那个属性进行什么运算(可执行的运算类型很多，这里描述的是对height属性，做sum运算)
    NSExpression *expression = [NSExpression expressionForFunction:@"sum:" arguments:@[[NSExpression expressionForKeyPath:@"height"]]];
    // 只能对应一个具体描述对象
    expressionDes.expression = expression;
    // 给请求对象设置描述对象，这里是一个数组类型，也就是可以设置多个描述对象
    fetchRequest.propertiesToFetch = @[expressionDes];
    // 执行请求，返回值还是一个数组，数组中只有一个元素，就是存储计算结果的字典
    NSError *error = nil;
    NSArray *resultArr = [manager.moc executeFetchRequest:fetchRequest error:&error];
    // 通过上面设置的name值，当做请求结果的key取出计算结果
    NSNumber *number = resultArr.firstObject[@"sumOperatin"];
    NSLog(@"fetch request result is %f", [number floatValue]);
    // 错误处理
    if (error) {
        NSLog(@"fetch request result error : %@", error);
    }
}

#pragma mark -- 批量更新,批量删除 --
- (void)batchUpdate {
    CCPCoredataManager *manager = [CCPCoredataManager shareManager];
    // 创建批量更新对象，并指明操作Employee表。
    NSBatchUpdateRequest *updateRequest = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:@"Employee"];
    // 设置返回值类型，默认是什么都不返回(NSStatusOnlyResultType)，这里设置返回发生改变的对象Count值
    updateRequest.resultType = NSUpdatedObjectsCountResultType;
    // 设置发生改变字段的字典
    updateRequest.propertiesToUpdate = @{@"height" : [NSNumber numberWithFloat:5.f]};
    // 执行请求后，返回值是一个特定的result对象，通过result的属性获取返回的结果。MOC的这个API是从iOS8出来的，所以需要注意版本兼容。
    NSError *error = nil;
    NSBatchUpdateResult *result = [manager.moc executeRequest:updateRequest error:&error];//ios8后可以使用
    NSLog(@"batch update count is %ld", [result.result integerValue]);
    // 错误处理
    if (error) {
        NSLog(@"batch update request result error : %@", error);
    }
    // 更新MOC中的托管对象，使MOC和本地持久化区数据同步
    [manager.moc refreshAllObjects];//ios9后可以使用
}

- (void)batchDelete {
    CCPCoredataManager *manager = [CCPCoredataManager shareManager];
   // Employee *emp = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:manager.moc];
    // 创建请求对象，并指明对Employee表做操作
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    // 通过谓词设置过滤条件，设置条件为height小于1.7
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"height < %f", 1.7f];
    fetchRequest.predicate = predicate;
    // 创建批量删除请求，并使用上面创建的请求对象当做参数进行初始化
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    // 设置请求结果类型，设置为受影响对象的Count
    deleteRequest.resultType = NSBatchDeleteResultTypeCount;
    // 使用NSBatchDeleteResult对象来接受返回结果，通过id类型的属性result获取结果
    NSError *error = nil;
    NSBatchDeleteResult *result = [manager.moc executeRequest:deleteRequest error:&error];
    NSLog(@"batch delete request result count is %ld", [result.result integerValue]);
    // 错误处理
    if (error) {
        NSLog(@"batch delete request error : %@", error);
    }
    // 更新MOC中的托管对象，使MOC和本地持久化区数据同步
    [manager.moc refreshAllObjects];//ios9之后
   // [manager.moc refreshObject:emp mergeChanges:YES];//ios8
}

#pragma mark -- 异步请求 --
- (void)asyncRequest {
    CCPCoredataManager *manager = [CCPCoredataManager shareManager];
    // 创建请求对象，并指明操作Employee表
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    // 创建异步请求对象，并通过一个block进行回调，返回结果是一个NSAsynchronousFetchResult类型参数
    //线程安全，在前一个任务访问数据库是，coreData会将数据库枷锁
    //NSAsynchronousFetchRequest提供了cancel方法，也就是可以在请求过程中，将这个请求取消。还可以通过一个NSProgress类型的属性，获取请求完成进度。NSAsynchronousFetchRequest类从iOS8开始可以使用，所以低版本需要做版本兼容
    NSAsynchronousFetchRequest *asycFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetchRequest completionBlock:^(NSAsynchronousFetchResult * _Nonnull result) {
        [result.finalResult enumerateObjectsUsingBlock:^(Employee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"fetch request result Employee.count = %ld, Employee.name = %@", result.finalResult.count, obj.name);
        }];
    }];
    // 执行异步请求，和批量处理执行同一个请求方法
    NSError *error = nil;
    [manager.moc executeRequest:asycFetchRequest error:&error];
    // 错误处理
    if (error) {
        NSLog(@"fetch request result error : %@", error);
    }
}


@end
