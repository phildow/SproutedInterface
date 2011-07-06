//
//  PDMatrixButton.m
//  SproutedInterface
//
//  Created by Philip Dow on 5/10/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDMatrixButton.h>
#import <SproutedInterface/PDMatrixButtonCell.h>

@implementation PDMatrixButton

- (id)initWithCoder:(NSCoder *)decoder {
	
	if ( self = [super initWithCoder:decoder] ) {
		
		NSArchiver * anArchiver = [[[NSArchiver alloc] 
				initForWritingWithMutableData:[NSMutableData dataWithCapacity: 256]] autorelease];
		[anArchiver encodeClassName:@"NSButtonCell" intoClassName:@"PDMatrixButtonCell"];
		[anArchiver encodeRootObject:[self cell]];
		[self setCell:[NSUnarchiver unarchiveObjectWithData:[anArchiver archiverData]]];
		
	}
	
	return self;
}


+ (Class) cellClass
{
    return [PDMatrixButtonCell class];
}

@end
