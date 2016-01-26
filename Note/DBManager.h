//
//  DBManager.h
//  Note
//
//  Created by Admin on 1/26/16.
//  Copyright © 2016 KirillTer. All rights reserved.
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
