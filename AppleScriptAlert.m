//
//  AppleScriptAlert.m
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
