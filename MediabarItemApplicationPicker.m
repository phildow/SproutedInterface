//
//  MediabarItemApplicationPicker.m
//  SproutedInterface
//
//  Created by Philip Dow on 2/22/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

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
