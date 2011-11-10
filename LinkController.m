//
//  LinkController.m
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
