//
//  NSUserDefaults+PDDefaultsAdditions.h
//  SproutedUtilities
//
//  Created by Philip Dow on 5/26/06.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@interface NSUserDefaults (PDDefaultsAdditions)

- (NSDictionary*) defaultEntryAttributes;

- (NSFont*) fontForKey:(NSString*)aKey;
- (void) setFont:(NSFont*)aFont forKey:(NSString*)aKey;

- (NSColor*) colorForKey:(NSString*)aKey;
- (void) setColor:(NSColor*)aColor forKey:(NSString*)aKey;

@end
