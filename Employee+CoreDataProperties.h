//
//  Employee+CoreDataProperties.h
//  CoreDateDemo
//
//  Created by 扆佳梁 on 2016/10/11.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "Employee+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t age;
@property (nonatomic) double height;

@end

NS_ASSUME_NONNULL_END
