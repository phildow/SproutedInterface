//
//  PDCircleButton.m
//  SproutedInterface
//
//  Created by Philip Dow on 12/10/05.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDCircleButton.h>
#import <SproutedInterface/PDCircleButtonCell.h>

@implementation PDCircleButton

- (id)initWithCoder:(NSCoder *)decoder {
	
	if ( self = [super initWithCoder:decoder] ) {
		
		NSArchiver * anArchiver = [[[NSArchiver alloc] 
				initForWritingWithMutableData:[NSMutableData dataWithCapacity: 256]] autorelease];
		[anArchiver encodeClassName:@"NSButtonCell" intoClassName:@"PDCircleButtonCell"];
		[anArchiver encodeRootObject:[self cell]];
		[self setCell:[NSUnarchiver unarchiveObjectWithData:[anArchiver archiverData]]];
		
	}
	
	return self;
}


+ (Class) cellClass
{
    return [PDCircleButtonCell class];
}


@end
