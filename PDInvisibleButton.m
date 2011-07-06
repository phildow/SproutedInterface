//
//  PDInvisibleButton.m
//  SproutedInterface
//
//  Created by Philip Dow on 1/9/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDInvisibleButton.h>
#import <SproutedInterface/PDInvisibleButtonCell.h>

//
// USE: hidden escape button to, say, close a window?

@implementation PDInvisibleButton

- (id)initWithCoder:(NSCoder *)decoder {
	
	if ( self = [super initWithCoder:decoder] ) {
		
		NSArchiver * anArchiver = [[[NSArchiver alloc] 
				initForWritingWithMutableData:[NSMutableData dataWithCapacity: 256]] autorelease];
		[anArchiver encodeClassName:@"NSButtonCell" intoClassName:@"PDInvisibleButtonCell"];
		[anArchiver encodeRootObject:[self cell]];
		[self setCell:[NSUnarchiver unarchiveObjectWithData:[anArchiver archiverData]]];
		
	}
	
	return self;
}


+ (Class) cellClass
{
    return [PDInvisibleButtonCell class];
}

- (void)mouseDown:(NSEvent *)theEvent
{
	// don't do a damn thing
	return;
}

@end
