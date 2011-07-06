//
//  PDTextClipping.h
//  SproutedUtilities
//
//  Created by Phil Dow on 3/17/07.
//  Copyright 2007 Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface PDTextClipping : NSObject {
	
	id textRepresentation;
	BOOL isRichText;
}

- (id) initWithContentsOfFile:(NSString*)filename;

- (BOOL) isRichText;

- (NSString*) plainTextRepresentation;
- (NSAttributedString*) richTextRepresentation;

@end
