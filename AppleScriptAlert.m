//
//  AppleScriptAlert.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/AppleScriptAlert.h>

@implementation AppleScriptAlert

- (id) initWithSource:(id)theSource error:(id)theError
{
	if ( self = [super initWithWindowNibName:@"AppleScriptAlert"] )
	{
		source = [theSource retain];
		error = [theError retain];
		
		[self retain];
	}
	
	return self;
}

- (void) windowDidLoad
{
	if ( [source isKindOfClass:[NSString class]] )
		[sourceView setString:source];
	
	else if ( [source isKindOfClass:[NSAttributedString class]] )
	{
		[[sourceView textStorage] beginEditing];
		[[sourceView textStorage] setAttributedString:source];
		[[sourceView textStorage] endEditing];
	}
	
	if ( error == nil )
		[errorView setString:[NSString string]];
	else
		[errorView setString:[error description]];
}

- (void) dealloc
{
	[source release];
	[error release];
	
	[super dealloc];
}

- (void) windowWillClose:(NSNotification*)aNotification
{
	[self autorelease];
}

#pragma mark -

- (IBAction) showWindow:(id)sender
{
	[[self window] center];
	[super showWindow:sender];
}

@end
