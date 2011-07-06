//
//  NSManagedObjectContext_PDCategory.h
//  SproutedUtilities
//
//  Created by Philip Dow on 5/14/07.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (PDCategory)

- (NSManagedObject*) managedObjectForURIRepresentation:(NSURL *)aURL;
- (NSManagedObject*) managedObjectRegisteredForURIRepresentation:(NSURL*)aURL;

- (NSManagedObject*) managedObjectForUUIDRepresentation:(NSURL*)aURL;
- (NSManagedObject*) managedObjectForUUID:(NSString*)uuid entity:(NSString*)entityName;

@end
