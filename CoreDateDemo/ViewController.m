//
//  ViewController.m
//  CoreDateDemo
//
//  Created by 扆佳梁 on 2016/10/11.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Employee+CoreDataProperties.h"
#import "Employee+CoreDataClass.h"
#import "Department+CoreDataClass.h"
#import "Department+CoreDataProperties.h"

@interface ViewController ()

@property(nonatomic,strong)NSManagedObjectContext *context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupCoreDateContext];
    
}


#pragma mark - NSCoreData 配置相关方法
-(void)setupCoreDateContext{
    //创建一个数据库 Company
    //创建表 employee
    
    // 上下文并发性  私有队里中并发
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    //创建一个 NSManagedObjectModel 模型对象
    
    //传nil 会把bundle下所有模型文件 关联起来
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    //持久化 调度器
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    NSError *error = nil;
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlitePath = [documentPath stringByAppendingPathComponent:@"company.sqlite"];
    
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:&error];
    context.persistentStoreCoordinator = store;
    
    _context = context;

}



/**
 根据输入的表名 和查询条件

 @param tableName 要查询的数据库表名
 @param pre       查询的条件  谓词
 
 example:NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@ AND height>%f",@"王五",1.5];


 @return 返回查询的数据
 */
-(NSArray *)findFromTable:(NSString *)tableName withRequets:(NSPredicate *)pre{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:tableName];
    request.predicate = pre;
    
    NSError *error = nil;
    
    NSArray *emps = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error%@",error);
        return nil;
    }else{
        return emps;
    }
    
}
-(void)synchronizeSqlite{
    NSError *error = nil;
    [_context save:&error];
    if (!error) {
        NSLog(@"SynchronizeSqlite success");
    }else{
        NSLog(@"%@",error);
    }

}

#pragma mark - 添加 数据



#pragma mark 多表数据 修改

/**
 添加员工信息  多表数据 添加 一次添加两个表的数据de

 @param sender 按钮
 */
- (IBAction)addEmployee:(id)sender {
    
    //创建员工
    //添加 张三 属于ios部门
    //添加 李四 属于 android 部门
    
    Employee *employee1 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:_context];
    
    //设置员工属性
    
    employee1.name = @"张三";
    employee1.age = 28;
    employee1.height = 1.70;
    //创建一个部门
    Department *depios = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:_context];
    depios.name = @"ios";
    depios.createDate = [NSDate date];
    depios.departNo = @"001";
    employee1.depart = depios;
    
    
    Employee *employee2 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:_context];
    
    //设置员工属性
    
    employee2.name = @"张三";
    employee2.age = 28;
    employee2.height = 1.70;
    //创建一个部门
    Department *depAndroid = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:_context];
    depAndroid.name = @"Android";
    depAndroid.createDate = [NSDate date];
    depAndroid.departNo = @"002";
    employee2.depart = depAndroid;
    
    
    [self synchronizeSqlite];
    

}

- (IBAction)addMultipleData:(id)sender {
    
    for (int i = 0; i<20; i++) {
        //创建员工
        Employee *employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:_context];
        
        //设置员工属性
        
        employee.name = [NSString stringWithFormat:@"张三%d",i];
        employee.age = 28+i;
        employee.height = 1.70;
        
        //保存 通过上下文
        NSError *error = nil;
        [_context save:&error];
        if (!error) {
            NSLog(@"Insert success");
        }else{
            NSLog(@"%@",error);
        }
    }
    
}


#pragma mark - 查询相关

- (IBAction)readEmployee:(id)sender {
    //创建 一个请求对象
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    //读取信息
    NSError *error = nil;
    NSArray *emps = [self.context executeFetchRequest:request error:&error];
    
    if (!error) {
        NSLog(@"emps:%@",emps);
        for (Employee *emp in emps) {
            NSLog(@"%@ %d %f %@",emp.name,emp.age,emp.height,emp.depart.name);
        }
    }else{
        NSLog(@"%@",error);
    }
}


- (IBAction)multipleTbaleReadSpecialEmployee:(id)sender {
    //创建 一个请求对象
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"depart.name=%@",@"ios"];
    
    request.predicate = pre;
    //读取信息
    NSError *error = nil;
    NSArray *emps = [self.context executeFetchRequest:request error:&error];
    
    if (!error) {
        NSLog(@"emps:%@",emps);
        for (Employee *emp in emps) {
            NSLog(@"%@ %d %f %@",emp.name,emp.age,emp.height,emp.depart.name);
        }
    }else{
        NSLog(@"%@",error);
    }
    
}


- (IBAction)readSpecialEmployee:(id)sender {
    //创建 一个请求对象
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@ AND height>%f",@"王五",1.5];
    
    request.predicate = pre;
    //读取信息
    NSError *error = nil;
    NSArray *emps = [self.context executeFetchRequest:request error:&error];
    
    if (!error) {
        NSLog(@"emps:%@",emps);
        for (Employee *emp in emps) {
            NSLog(@"%@ %d %f",emp.name,emp.age,emp.height);
        }
    }else{
        NSLog(@"%@",error);
    }

}

- (IBAction)readAndSortEmployee:(id)sender {
    //创建 一个请求对象
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@ AND height>%f",@"王五",1.5];
    
    request.predicate = pre;
    
    
    //增加请求条件 排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:YES];
    request.sortDescriptors = @[sort];
    //读取信息
    NSError *error = nil;
    NSArray *emps = [self.context executeFetchRequest:request error:&error];
    
    if (!error) {
        NSLog(@"emps:%@",emps);
        for (Employee *emp in emps) {
            NSLog(@"%@ %d %f",emp.name,emp.age,emp.height);
        }
    }else{
        NSLog(@"%@",error);
    }

}
- (IBAction)readByPageQuery:(id)sender {
    //分页查询
    //创建 一个请求对象
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    request.fetchLimit = 5; //每页显示5条数据
    request.fetchOffset = 0; //每次查询Start 开始的数据 第几条数据开始  Example: 第一页从0 开始,第二页从5开始
  
    //读取信息
    NSError *error = nil;
    NSArray *emps = [self.context executeFetchRequest:request error:&error];
    
    if (!error) {
        NSLog(@"emps:%@",emps);
        for (Employee *emp in emps) {
            NSLog(@"%@ %d %f",emp.name,emp.age,emp.height);
        }
    }else{
        NSLog(@"%@",error);
    }

    
    
}


/**
 模糊查询

 @param sender 按钮
 */
- (IBAction)likeSearch:(id)sender {
    
    /*Example 查询以wang 开头的员工
    
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name BEGINSWITH %@",@"张三"];
    
    NSArray *findArray = [self findFromTable:@"Employee" withRequets:pre];
    
    for (Employee *emp in findArray) {
        NSLog(@"%@ %d %f",emp.name,emp.age,emp.height);
    }
     
     */
    
    

    /*Example 查询以 什么结尾的员工
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name ENDSWITH %@",@"王五"];
    
    NSArray *findArray = [self findFromTable:@"Employee" withRequets:pre];
    
    for (Employee *emp in findArray) {
        NSLog(@"%@ %d %f",emp.name,emp.age,emp.height);
    }

     */
    
    
    /* Example 查询 包含某个字符的 员工
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name CONTAINS %@",@"2"];
    NSArray *findArray = [self findFromTable:@"Employee" withRequets:pre];
    
    for (Employee *emp in findArray) {
        NSLog(@"%@ %d %f",emp.name,emp.age,emp.height);
    }
     */
    
    // Like 关键字 使用 Example
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name like %@",@"王五*"];
    NSArray *findArray = [self findFromTable:@"Employee" withRequets:pre];
    
    for (Employee *emp in findArray) {
        NSLog(@"%@ %d %f",emp.name,emp.age,emp.height);
        
    }


}

#pragma mark - 删除相关

- (IBAction)deleteEmployee:(id)sender {
    
    //删除 删除也可以有条件
    
    //第一步 查找张三
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@",@"张三"];
    request.predicate = pre;
    
    
    //第二步 删除张三.
    
    NSArray *emps = [self.context executeFetchRequest:request error:nil];
    
    for (Employee *emp in emps) {
        [self.context deleteObject:emp];
    }
    //第三步 同步数据库
    
    
    NSError *error = nil;
    
    [self.context save:&error];
    if (!error) {
        
        NSLog(@"删除成功");
    }else{
        NSLog(@"%@",error);
    }
    
}

#pragma mark - 更新相关

- (IBAction)updateEmployeeData:(id)sender {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@",@"王五9"];
    
    NSArray *findArray = [self findFromTable:@"Employee" withRequets:pre];
    
    
    for (Employee *emp in findArray) {
        emp.height = 2.1;
    }
    [self synchronizeSqlite];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
