//
//  NSObject_JSAdditions.h
//  SproutedUtilities
//
//  Created by Phil Dow on 11/18/06.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//
//	Was NSObject_JSAdditions


#import <Cocoa/Cocoa.h>


@interface NSObject (PDScriptingAdditions)

- (void) returnError:(int)n string:(NSString*)s;

@end

@interface NSScriptCommand (PDScriptingAdditions)

- (id) subjectsSpecifier;
- (id) evaluatedDirectParameters;

@end

@interface NSScriptObjectSpecifier (PDScriptingAdditions)

+ (NSScriptObjectSpecifier*) _objectSpecifierFromDescriptor:(NSAppleEventDescriptor*)eventDescriptor inCommandConstructionContext:(id)context;

@end