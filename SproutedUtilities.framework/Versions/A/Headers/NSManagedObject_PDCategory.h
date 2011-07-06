//
//  NSManagedObject_PDCategory.h
//  SproutedUtilities
//
//  Created by Philip Dow on 5/14/07.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface NSManagedObject (PDCategory)

- (NSURL*) URIRepresentation;
- (NSURL*) UUIDURIRepresentation;

@end
