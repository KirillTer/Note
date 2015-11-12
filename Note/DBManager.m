//
//  DBManager.m
//  Note
//
//  Created by Admin on 11/8/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "DBManager.h"

#import "AppDelegate.h"

@implementation DBManager

+ (instancetype)sharedInstance {
    static DBManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DBManager new];
    });
    return sharedInstance;
}

-(NSArray *) fetchEntities:(NSString *) entityName {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:entityName];
    NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return array;
}
-(void) saveContext{
    [[self managedObjectContext] save:nil];
}
-(void) removeObject:(NSManagedObject *) obj{
    [[self managedObjectContext] deleteObject:obj];
}

- (void)cleanContext
{
    [[self managedObjectContext] deletedObjects];
}

-(NSManagedObject *) createEntityName:(NSString *) entityName{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                  inManagedObjectContext:[self managedObjectContext]];
    return object;
}

#pragma mark - Private Methods
-(NSManagedObjectContext *)managedObjectContext {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    return [delegate managedObjectContext];
}

@end
