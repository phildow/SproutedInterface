//
//  PDButtonTextOnImage.m
//  SproutedInterface
//
//  Created by Philip Dow on 1/3/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDButtonTextOnImage.h>
#import <SproutedInterface/PDButtonTextOnImageCell.h>

@implementation PDButtonTextOnImage

- (id)initWithCoder:(NSCoder *)decoder {
	
	if ( self = [super initWithCoder:decoder] ) {
		
		
		NSFont *font = [[self cell] font];
		NSString *title = [self title];
		
		[self setCell:[[[PDButtonTextOnImageCell alloc] initImageCell:[self image]] autorelease]];
		
		[(PDButtonTextOnImageCell*)[self cell] setTitle:title];
		[(PDButtonTextOnImageCell*)[self cell] setFont:font];

	}
	
	return self;
}


+ (Class) cellClass
{
    return [PDButtonTextOnImageCell class];
}

- (BOOL) isFlipped { return YES; }

- (BOOL)isOpaque { return NO; }


@end
