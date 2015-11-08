//
//  Note+CoreDataProperties.h
//  Note
//
//  Created by Admin on 11/7/15.
//  Copyright © 2015 Admin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSDate *time;
@property (nullable, nonatomic, retain) Photo *photo;

@end

NS_ASSUME_NONNULL_END
