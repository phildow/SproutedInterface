//
//  LinkController.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/LinkController.h>

@implementation LinkController

- (id) initWithLink:(NSString*)link URL:(NSString*)url {
	
	//if ( self = [super init] ) {
	if ( self = [super initWithWindowNibName:@"InsertLink"] ) {
		//[self window];
		
		//[self setWindowFrameAutosaveName:@"InsertLink"];
		
		_linkString = [link copyWithZone:[self zone]];
		_URLString = [url copyWithZone:[self zone]];
		
		//[self setLinkString:link];
		//[self setURLString:url];
		
		//[NSBundle loadNibNamed:@"InsertLink" owner:self];
		
	}
	
	return self;
	
}

- (void) dealloc {
	
	[_linkString release];
		_linkString = nil;
	[_URLString release];
		_URLString = nil;
	
	[super dealloc];
	
}

- (void)windowWillClose:(NSNotification *)aNotification {
	
	[objectController unbind:@"objectContent"];
	[objectController setContent:nil];

}

#pragma mark -

- (NSString*) linkString { return _linkString; }

- (void) setLinkString:(NSString*)string {
	if ( _linkString != string ) {
		[_linkString release];
		_linkString = [string copyWithZone:[self zone]];
	}
}

- (NSString*) URLString { return _URLString; }

- (void) setURLString:(NSString*)string {
	if ( _URLString != string ) {
		[_URLString release];
		_URLString = [string copyWithZone:[self zone]];
	}
}

#pragma mark -

- (int) runAsSheetForWindow:(NSWindow*)window attached:(BOOL)sheet {
	
	int result;
	
	if ( sheet )
		[NSApp beginSheet: [self window] modalForWindow: window modalDelegate: nil
				didEndSelector: nil contextInfo: nil];
	
    result = [NSApp runModalForWindow: [self window]];
	
	if ( ![objectController commitEditing] )
		NSLog(@"%@ %s - unable to commit editing", [self className], _cmd);
	
	if ( sheet )
		[NSApp endSheet: [self window]];
	
	[self close];
	
	return result;
	
}

#pragma mark -

- (IBAction)genericCancel:(id)sender
{
	[NSApp abortModal];
}

- (IBAction)genericOkay:(id)sender
{
	[NSApp stopModal];
}

@end
