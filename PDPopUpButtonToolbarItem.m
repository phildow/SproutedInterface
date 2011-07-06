//
//  PDPopUpButtonToolbarItem.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDPopUpButtonToolbarItem.h>
#import <SproutedInterface/PDPopUpButtonToolbarItemCell.h>

@implementation PDPopUpButtonToolbarItem


- (id)initWithCoder:(NSCoder *)decoder {
	
	if ( self = [super initWithCoder:decoder] ) 
	{
		NSMenu *theMenu = [[self menu] copyWithZone:[self zone]];
		
		[self setCell:[[[PDPopUpButtonToolbarItemCell alloc] 
				initTextCell:[self title] 
				pullsDown:[self pullsDown]] autorelease]];
		[self setMenu:theMenu];
		
		[self setIconSize:NSMakeSize(32,32)];
		[[self cell] setFont:[NSFont systemFontOfSize:11]];
		
		[theMenu release];
	}
	
	/*
	if ( self = [super initWithCoder:decoder] ) {
		
		NSArchiver * anArchiver = [[[NSArchiver alloc] 
				initForWritingWithMutableData:[NSMutableData dataWithCapacity: 256]] autorelease];
		
		[anArchiver encodeClassName:@"NSPopUpButtonCell" intoClassName:@"PDPopUpButtonToolbarItemCell"];
		[anArchiver encodeRootObject:[self cell]];
		
		[self setCell:[NSUnarchiver unarchiveObjectWithData:[anArchiver archiverData]]];
		[self setIconSize:NSMakeSize(32,32)];
		[[self cell] setFont:[NSFont systemFontOfSize:11]];
		
	}
	*/
	
	return self;
}


- (void) awakeFromNib {
	
	[[self cell] setMenu:[self menu]];
	
}


+ (Class) cellClass
{
    return [PDPopUpButtonToolbarItemCell class];
}

- (NSSize) iconSize
{
	return [(PDPopUpButtonToolbarItemCell*)[self cell] iconSize];
}

-(void) setIconSize:(NSSize)aSize
{
	[(PDPopUpButtonToolbarItemCell*)[self cell] setIconSize:aSize];
	[self setNeedsDisplay:YES];
}


@end
