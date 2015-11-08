//
//  DBManager.h
//  Note
//
//  Created by Admin on 11/8/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DBManager : NSObject
+ (instancetype)sharedInstance;
-(NSManagedObjectContext *)managedObjectContext;
-(NSArray *) fetchEntities:(NSString *) entityName;
-(void) saveContext;
-(void) removeObject:(NSManagedObject *) obj;
-(NSManagedObject *) createEntityName:(NSString *) entityName;
@end
