//
//  Photo+CoreDataProperties.h
//  Note
//
//  Created by Admin on 11/7/15.
//  Copyright © 2015 Admin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Photo.h"

NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *photoData;
@property (nullable, nonatomic, retain) NSString *photoName;
@property (nullable, nonatomic, retain) NSNumber *photoNumber;

@end

NS_ASSUME_NONNULL_END
