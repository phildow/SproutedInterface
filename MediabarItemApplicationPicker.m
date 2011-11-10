//
//  MediabarItemApplicationPicker.m
//  SproutedInterface
//
//  Created by Philip Dow on 2/22/07.
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

#import <SproutedInterface/MediabarItemApplicationPicker.h>


@implementation MediabarItemApplicationPicker

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		[self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    }
    return self;
}

- (void) dealloc
{
	[filename release];
	[self unregisterDraggedTypes];
	
	[super dealloc];
}

#pragma mark -

- (void)drawRect:(NSRect)rect {
    // Drawing code here.f
	[super drawRect:rect];
}

#pragma mark -

- (id) delegate
{
	return delegate;
}

- (void) setDelegate:(id)anObject
{
	delegate = anObject;
}

- (NSString*) filename
{
	return filename;
}

- (void) setFilename:(NSString*)aString
{
	if ( filename != aString )
	{
		[filename release];
		filename = [aString copyWithZone:[self zone]];
		[self setNeedsDisplay:YES];
	}
}

#pragma mark -

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSArray *types = [pboard types];
	
	if ( ![types containsObject:NSFilenamesPboardType] )
	{
		NSBeep(); return NO;
	}
	
	NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
	if ( [filenames count] == 0 ) return NO;
	
	if ( [[self delegate] respondsToSelector:@selector(mediabarItemApplicationPicker:shouldAcceptDrop:)] )
		return [[self delegate] mediabarItemApplicationPicker:self shouldAcceptDrop:[filenames objectAtIndex:0]];
	else
		return NO;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{	
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSArray *types = [pboard types];
	
	if ( ![types containsObject:NSFilenamesPboardType] )
		return NSDragOperationNone;
	
	NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
	return ( [filenames count] == 1 ? NSDragOperationCopy : NSDragOperationNone );
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSArray *types = [pboard types];
	
	if ( ![types containsObject:NSFilenamesPboardType] )
		return NSDragOperationNone;
	
	NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
	return ( [filenames count] == 1 ? NSDragOperationCopy : NSDragOperationNone );
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    return;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
	return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
	return;
}

- (BOOL)ignoreModifierKeysWhileDragging 
{
	return YES;
}


@end
