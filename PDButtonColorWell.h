//
//  PDButtonColorWell.h
//  SproutedInterface
//
//  Created by Philip Dow on 1/7/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@interface PDButtonColorWell : NSButton {
	NSString *defaultsKey;
}

- (NSColor*) color;
- (void) setColor:(NSColor*)color;

- (NSString*) defaultsKey;
- (void) setDefaultsKey:(NSString*)aKey;

@end
