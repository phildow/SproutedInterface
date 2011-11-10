//
//  PDMediabarItem.m
//  SproutedInterface
//
//  Created by Philip Dow on 2/20/07.
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

#import <SproutedInterface/PDMediabarItem.h>
#import <SproutedInterface/PDMediaBar.h>

@implementation PDMediabarItem

- (id) initWithItemIdentifier:(NSString*)aString
{
	if ( self = [self init] )
	{
		[self setIdentifier:aString];
	}
	
	return self;
}

- (id) initWithDictionaryRepresentation:(NSDictionary*)aDictionary
{
	if ( self = [self init] )
	{
		[self setIdentifier:[aDictionary objectForKey:@"identifier"]];
		[self setTypeIdentifier:[aDictionary objectForKey:@"typeIdentifier"]];
		
		NSData *scriptData = [aDictionary objectForKey:@"targetScript"];
		if ( scriptData != nil ) [self setTargetScript:[NSKeyedUnarchiver unarchiveObjectWithData:scriptData]];
		
		NSData *imageData = [aDictionary objectForKey:@"image"];
		if ( imageData != nil ) [self setImage:[NSKeyedUnarchiver unarchiveObjectWithData:imageData]];
		[self setTitle:[aDictionary objectForKey:@"title"]];
		[self setToolTip:[aDictionary objectForKey:@"tooltip"]];
		
		NSString *uriString = [aDictionary objectForKey:@"targetURI"];
		if ( uriString != nil ) [self setTargetURI:[NSURL URLWithString:uriString]];
		
	}
	
	return self;
}	

- (id) init
{
	if ( self = [super initWithFrame:NSMakeRect(0,0,32,32)] )
	{
		[(NSButtonCell*)[self cell] setImagePosition:NSImageOnly];
		[(NSButtonCell*)[self cell] setControlSize:NSRegularControlSize];
		[(NSButtonCell*)[self cell] setButtonType:NSMomentaryChangeButton];
		[(NSButtonCell*)[self cell] setLineBreakMode:NSLineBreakByWordWrapping];
		[(NSButtonCell*)[self cell] setBaseWritingDirection:NSWritingDirectionNatural];
		//[(NSButtonCell*)[self cell] setType:NSImageCellType];
		
		[self setBordered:NO];
		[self setBezelStyle:NSRegularSquareBezelStyle];
		[(NSButtonCell*)[self cell] setBezeled:NO];
		[self setTransparent:NO];
		[self setImagePosition:NSImageOnly];
		[self setShowsBorderOnlyWhileMouseInside:NO];
		[self setAutoresizingMask:(NSViewMinXMargin)];
		[self setFont:[NSFont controlContentFontOfSize:11]];

		
		[self setAllowsMixedState:NO];
		[self setState:NSOffState];
		
		[self setContinuous:NO];
		//[self sendActionOn:NSLeftMouseUpMask];

	}
	
	return self;
}

- (void) dealloc
{
	[identifier release];
	[typeIdentifier release];
	[targetURI release];
	[targetScript release];
	//[mediabar release];	
	
	[super dealloc];
}

#pragma mark -

- (NSDictionary*) dictionaryRepresentation
{
	NSMutableDictionary *representation = [NSMutableDictionary dictionaryWithCapacity:4];
	
	if ( identifier != nil ) [representation setObject:[self identifier] forKey:@"identifier"];
	if ( typeIdentifier != nil ) [representation setObject:[self typeIdentifier] forKey:@"typeIdentifier"];
	if ( targetURI != nil ) [representation setObject:[[self targetURI] absoluteString] forKey:@"targetURI"];
	if ( targetScript != nil ) [representation setObject:[NSKeyedArchiver archivedDataWithRootObject:[self targetScript]] forKey:@"targetScript"];
	
	if ( [self image] != nil ) [representation setObject:[NSKeyedArchiver archivedDataWithRootObject:[self image]] forKey:@"image"];
	if ( [self title] != nil ) [representation setObject:[self title] forKey:@"title"];
	if ( [self toolTip] != nil ) [representation setObject:[self toolTip] forKey:@"tooltip"];
	
	return representation;
}

- (void) setAttributesFromDictionaryRepresentation:(NSDictionary*)aDictionary
{
	[self setIdentifier:[aDictionary objectForKey:@"identifier"]];
	[self setTypeIdentifier:[aDictionary objectForKey:@"typeIdentifier"]];
	
	NSData *scriptData = [aDictionary objectForKey:@"targetScript"];
	if ( scriptData != nil ) [self setTargetScript:[NSKeyedUnarchiver unarchiveObjectWithData:scriptData]];
	
	NSData *imageData = [aDictionary objectForKey:@"image"];
	if ( imageData != nil ) [self setImage:[NSKeyedUnarchiver unarchiveObjectWithData:imageData]];
	[self setTitle:[aDictionary objectForKey:@"title"]];
	[self setToolTip:[aDictionary objectForKey:@"tooltip"]];
	
	NSString *uriString = [aDictionary objectForKey:@"targetURI"];
	if ( uriString != nil ) [self setTargetURI:[NSURL URLWithString:uriString]];

}

#pragma mark -

- (NSString *)identifier
{
	return identifier;
}

- (void) setIdentifier:(NSString*)aString
{
	if ( identifier != aString )
	{
		[identifier release];
		identifier = [aString copyWithZone:[self zone]];
	}
}

- (NSSize) size
{
	return [self frame].size;
}

- (void) setSize:(NSSize)aSize
{
	NSRect aFrame = [self frame];
	aFrame.size = aSize;
	[self setFrame:aFrame];
}

- (PDMediaBar*) mediabar
{
	return mediabar;
}

- (void) setMediabar:(PDMediaBar*)aMediabar
{
	if ( mediabar != aMediabar )
	{
		//[mediabar release];
		//mediabar = [aMediabar retain];
		
		// do not retain otherwise there is a retain loop between the mediabar and the mediabar items
		mediabar = aMediabar;
	}
}

#pragma mark -

- (NSNumber*) typeIdentifier
{
	return typeIdentifier;
}

- (void) setTypeIdentifier:(NSNumber*)aNumber
{
	if ( typeIdentifier != aNumber )
	{
		[typeIdentifier release];
		typeIdentifier = [aNumber copyWithZone:[self zone]];
	}
}

- (NSURL*) targetURI
{
	return targetURI;
}

- (void) setTargetURI:(NSURL*)aURL
{
	if ( targetURI != aURL )
	{
		[targetURI release];
		targetURI = [aURL copyWithZone:[self zone]];
	}
}

- (NSAttributedString*) targetScript
{
	return targetScript;
}

- (void) setTargetScript:(NSAttributedString*)aString
{
	if ( targetScript != aString )
	{
		[targetScript release];
		targetScript = [aString copyWithZone:[self zone]];
	}
}

#pragma mark -

- (void) setTitle:(NSString*)aString
{
	[super setTitle:aString];
	[self setImagePosition:NSImageOnly];
	//[(NSButtonCell*)[self cell] setType:NSImageCellType];
}

- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
	return [[self mediabar] menuForEvent:theEvent];
}

@end
