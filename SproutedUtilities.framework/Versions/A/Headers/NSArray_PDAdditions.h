//
//  NSArray_PDAdditions.h
//  SproutedUtilities
//
//  Created by Philip Dow on 11/9/06.
//  Copyright 2Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface NSArray (PDAdditions)

- (BOOL) allObjectsAreEqual;
- (BOOL) containsObjects:(NSArray*)anArray;
- (BOOL) containsAnObjectInArray:(NSArray*)anArray;

- (int) stateForInteger:(int)aValue;
- (NSArray*) objectsWithValue:(id)aValue forKey:(NSString*)aKey;

@end
