//
//  SproutedAboutBoxController.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

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
