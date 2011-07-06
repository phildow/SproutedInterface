//
//  PDStylesButton.m
//  SproutedInterface
//
//  Created by Philip Dow on 5/1/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDStylesButton.h>
#import <SproutedInterface/PDStylesButtonCell.h>

@implementation PDStylesButton

- (id)initWithCoder:(NSCoder *)decoder {
	
	if ( self = [super initWithCoder:decoder] ) {
		
		NSArchiver * anArchiver = [[[NSArchiver alloc] 
				initForWritingWithMutableData:[NSMutableData dataWithCapacity: 256]] autorelease];
		[anArchiver encodeClassName:@"NSButtonCell" intoClassName:@"PDStylesButtonCell"];
		[anArchiver encodeRootObject:[self cell]];
		[self setCell:[NSUnarchiver unarchiveObjectWithData:[anArchiver archiverData]]];
	}
	
	return self;
}


+ (Class) cellClass
{
    return [PDStylesButtonCell class];
}

- (int) superscriptValue {
	return [[self cell] superscriptValue];
}

- (void) setSuperscriptValue:(int)offset {
	[[self cell] setSuperscriptValue:offset];
}

@end
