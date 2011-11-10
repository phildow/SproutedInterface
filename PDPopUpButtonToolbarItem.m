//
//  PDPopUpButtonToolbarItem.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
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
