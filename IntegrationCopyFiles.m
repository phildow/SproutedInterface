
//
//  IntegrationCopyFiles.m
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

#import <SproutedInterface/IntegrationCopyFiles.h>

@implementation IntegrationCopyFiles

- (id) init {
	if ( self = [super initWithWindowNibName:@"IntegrationFileCopy"] ) 
	{
		[self setNoticeText:NSLocalizedString(@"integration copying files",@"")];
		[self retain];
	}
	
	return self;
}

- (void) windowDidLoad {
	
	[[self window] setHidesOnDeactivate:NO];
	//[progress setUsesThreadedAnimation:YES];
	
}

- (void) dealloc
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif
	
	[noticeText release];
	[super dealloc];
}

#pragma mark -

- (NSString*)noticeText
{
	return noticeText;
}

- (void) setNoticeText:(NSString*)aString
{
	if ( noticeText != aString )
	{
		[noticeText release];
		noticeText = [aString copyWithZone:[self zone]];
	}
}

- (void) runNotice {
	
	[[self window] center];
	[[self window] makeKeyAndOrderFront:self];
	
	[progress startAnimation:self];
	
}

- (void) endNotice {
	[progress stopAnimation:self];
	[[self window] close];
}

- (void)windowWillClose:(NSNotification *)aNotification 
{
	[controller unbind:@"contentObject"];
	[controller setContent:nil];
	
	[self autorelease];
}

@end
