//
//  Department+CoreDataProperties.h
//  CoreDateDemo
//
//  Created by 扆佳梁 on 2016/10/11.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "Department+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Department (CoreDataProperties)

+ (NSFetchRequest<Department *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *departNo;
@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
