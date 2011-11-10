//
//  PDDelegatedToolbar.m
//  SproutedInterface
//
//  Created by Philip Dow on 12/1/06.
//  Copyright Philip Dow / Sprouted. All rights reserved.
//

/*
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the organization nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

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
