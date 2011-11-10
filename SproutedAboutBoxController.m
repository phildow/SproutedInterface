//
//  SproutedAboutBoxController.m
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

#import <SproutedInterface/SproutedAboutBoxController.h>

@implementation SproutedAboutBoxController

+ (id)sharedController 
{
    static SproutedAboutBoxController *sharedAboutBoxController = nil;

    if (!sharedAboutBoxController) 
	{
        sharedAboutBoxController = [[SproutedAboutBoxController allocWithZone:NULL] init];
    }

    return sharedAboutBoxController;
}

- (id)init 
{
	if ( self = [self initWithWindowNibName:@"SproutedAboutBox"] ) 
	{
		[self window];
    }
    return self;
}

- (void) awakeFromNib
{
	[[additionalText enclosingScrollView] setDrawsBackground:NO];
	[additionalText setDrawsBackground:NO];
}

- (void)dealloc 
{	
	[super dealloc];	
}

- (void) windowDidLoad 
{
	// set the window's background color
	[[self window] setBackgroundColor:[NSColor whiteColor]];
	
	// prepare other fields with default values taken from the apps info.plist files
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary *localInfoDictionary = (NSDictionary *)CFBundleGetLocalInfoDictionary( CFBundleGetMainBundle() );
	
	NSString *shortVersion = [localInfoDictionary objectForKey:@"CFBundleShortVersionString"];
	NSString *version = [infoDictionary objectForKey:@"CFBundleVersion"];
	
	NSString *versionString = [NSString stringWithFormat:@"Version %@ (%@)", 
	( shortVersion != nil ? shortVersion : @"" ), ( version != nil ? version : @"" )];
	
	[appnameField setStringValue:[localInfoDictionary objectForKey:@"CFBundleName"]];
	[versionField setStringValue:versionString];
	
	[aboutText setTextContainerInset:NSMakeSize(5,10)];
	
	// prepare the about text
	NSString *path = [[NSBundle mainBundle] pathForResource:@"SproutedAboutBoxText" ofType:@"rtf"];
	if ( path == nil ) path = [[NSBundle mainBundle] pathForResource:@"SproutedAboutBoxText" ofType:@"rtfd"];
	if ( path == nil )
		NSLog(@"%@ %s - unable to locate SproutedAboutBoxText.rtf or SproutedAboutBoxText.rtfd in the application bundle", [self className], _cmd);
	else {
		[aboutText readRTFDFromFile:path];
	}
}

#pragma mark -

- (IBAction)showWindow:(id)sender
{
	[NSApp runModalForWindow:[self window]];
}

- (void)windowWillClose:(NSNotification *)aNotification 
{	
	if ( [NSApp modalWindow] == [self window] ) 
		[NSApp stopModal];	
}

@end
