//
//  PDButton.m
//  SproutedInterface
//
//  Created by Philip Dow on 12/4/05.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDButton.h>
#import <SproutedInterface/PDButtonCell.h>

@implementation PDButton


- (id)initWithCoder:(NSCoder *)decoder {
	
	if ( self = [super initWithCoder:decoder] ) {
		
		NSArchiver * anArchiver = [[[NSArchiver alloc] 
				initForWritingWithMutableData:[NSMutableData dataWithCapacity: 256]] autorelease];
		[anArchiver encodeClassName:@"NSButtonCell" intoClassName:@"PDButtonCell"];
		[anArchiver encodeRootObject:[self cell]];
		[self setCell:[NSUnarchiver unarchiveObjectWithData:[anArchiver archiverData]]];
		
	}
	
	return self;
}


+ (Class) cellClass
{
    return [PDButtonCell class];
}
	
@end
