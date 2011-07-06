//
//  PDDelegatedToolbar.m
//  SproutedInterface
//
//  Created by Philip Dow on 12/1/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDToolbar.h>


@implementation PDToolbar

- (NSToolbarItem*) itemWithTag:(int)aTag
{
	NSToolbarItem *anItem, *theItem = nil;
	NSEnumerator *enumerator = [[self items] objectEnumerator];
	
	while ( anItem = [enumerator nextObject] )
	{
		if ( [anItem tag] == aTag )
		{
			theItem = anItem;
			break;
		}
	}
	
	return theItem;
}

- (NSToolbarItem*) itemWithIdentifier:(NSString*)identifier
{
	NSToolbarItem *anItem, *theItem = nil;
	NSEnumerator *enumerator = [[self items] objectEnumerator];
	
	while ( anItem = [enumerator nextObject] )
	{
		if ( [[anItem itemIdentifier] isEqualToString:identifier] )
		{
			theItem = anItem;
			break;
		}
	}
	
	return theItem;
}

#pragma mark -

- (void)setDisplayMode:(NSToolbarDisplayMode)displayMode
{
	[super setDisplayMode:displayMode];
	if ( [[self delegate] respondsToSelector:@selector(toolbarDidChangeDisplayMode:)] )
		[[self delegate] toolbarDidChangeDisplayMode:self];
}

- (void)setSizeMode:(NSToolbarSizeMode)sizeMode
{
	[super setSizeMode:sizeMode];
	if ( [[self delegate] respondsToSelector:@selector(toolbarDidChangeSizeMode:)] )
		[[self delegate] toolbarDidChangeSizeMode:self];

}

- (void)setVisible:(BOOL)shown
{
	[super setVisible:shown];
	
	if ( shown ) 
		[[NSNotificationCenter defaultCenter] postNotificationName:PDToolbarDidShowNotification 
				object:self 
				userInfo:nil];
	else 
		[[NSNotificationCenter defaultCenter] postNotificationName:PDToolbarDidHideNotification 
				object:self 
				userInfo:nil];
	
	if (shown && [[self delegate] respondsToSelector:@selector(toolbarDidShow:)] )
		[[self delegate] toolbarDidShow:self];
	else if ( !shown && [[self delegate] respondsToSelector:@selector(toolbarDidHide:)] )
		[[self delegate] toolbarDidHide:self];
}

@end
