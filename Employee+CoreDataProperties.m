//
//  Employee+CoreDataProperties.m
//  CoreDateDemo
//
//  Created by 扆佳梁 on 2016/10/11.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "Employee+CoreDataProperties.h"

@implementation Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
}

@dynamic age;
@dynamic height;
@dynamic name;
@dynamic depart;

@end
