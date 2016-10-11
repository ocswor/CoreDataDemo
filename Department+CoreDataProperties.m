//
//  Department+CoreDataProperties.m
//  CoreDateDemo
//
//  Created by 扆佳梁 on 2016/10/11.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "Department+CoreDataProperties.h"

@implementation Department (CoreDataProperties)

+ (NSFetchRequest<Department *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Department"];
}

@dynamic departNo;
@dynamic createDate;
@dynamic name;

@end
