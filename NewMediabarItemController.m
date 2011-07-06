
//
//  NewMediabarItemController.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/NewMediabarItemController.h>

#import <SproutedInterface/PDMediaBarItem.h>
#import <SproutedInterface/JournlerGradientView.h>

#import <SproutedUtilities/PDUtilityDefinitions.h>
#import <SproutedUtilities/NSMutableString+PDAdditions.h>
#import <SproutedUtilities/NSImage_PDCategories.h>

@implementation NewMediabarItemController

- (id) init
{
	if ( self = [super initWithWindowNibName:@"NewMediabarItem"] ) 
	{
		wantsScript = YES;
		
		[self window];
		[self retain];
	}
	return self;
}

- (id) initWithDictionaryRepresentation:(NSDictionary*)aDictionary
{
	if ( self = [self init] )
	{
		[self setTitle:[aDictionary objectForKey:@"title"]];
		[self setFilepath:[aDictionary objectForKey:@"targetURI"]];
		[self setHelptip:[aDictionary objectForKey:@"tooltip"]];
		
		NSData *imageData = [aDictionary objectForKey:@"image"];
		if ( imageData != nil ) [self setIcon:[NSKeyedUnarchiver unarchiveObjectWithData:imageData]];
		
		NSData *scriptData = [aDictionary objectForKey:@"targetScript"];
		if ( scriptData != nil ) [self setScriptSource:[NSKeyedUnarchiver unarchiveObjectWithData:scriptData]];
		
		int myTypeIdentifier = [[aDictionary objectForKey:@"typeIdentifier"] intValue];
		if ( myTypeIdentifier == kMenubarItemAppleScript )
			[self setWantsScript:YES];
		else if ( myTypeIdentifier == kMenubarItemURI )
			[self setWantsFile:YES];
		else
			[self setWantsScript:YES];
		
	}
	
	return self;
}

- (void) windowDidLoad
{
	// the filepath gradient
	int borders[4] = {1,1,1,1};
	[applicationField setBordered:YES];
	[applicationField setBorders:borders];

	[applicationField setDrawsGradient:NO];
	[applicationField setBackgroundColor:[NSColor whiteColor]];
	
	// the default icon
	NSImage *scriptIcon = BundledImageWithName(@"AppleScriptActionBarSmall.png", @"com.sprouted.interface");
	[self setIcon:scriptIcon];
	
	// the example script
	// place DefaultMediabarAction.rtf in your application's main bundle
	NSString *examplePath = [[NSBundle mainBundle] pathForResource:@"DefaultMediabarAction" ofType:@"rtf"];
	if ( examplePath == nil )
	{
		NSLog(@"%@ %s - unable to locate resource \"DefaultMediabarAction\" of type \"rtf\"", [self className], _cmd);
	}
	else
	{
		NSAttributedString *attributedExample = [[[NSAttributedString alloc] initWithPath:examplePath documentAttributes:nil] autorelease];
		if ( attributedExample == nil )
		{
			NSLog(@"%@ %s - unable to initialize example from path %@", [self className], _cmd, examplePath);
		}
		else
		{
			[self setScriptSource:attributedExample];
		}
	}
	
	//targetWindow = [self window];
}

- (void) dealloc
{
	[icon release];
	[title release];
	[helptip release];
	[filepath release];
	[scriptSource release];
	
	[super dealloc];
}

- (void)windowWillClose:(NSNotification *)aNotification 
{	
	[objectController unbind:@"contentObject"];
	[objectController setContent:nil];

	[self autorelease];
}

#pragma mark -

- (NSDictionary*) dictionaryRepresentation
{
	NSNumber *typeIdentifier = nil;
	NSMutableString *identifier = [[[self title] mutableCopyWithZone:[self zone]] autorelease];
	NSMutableDictionary *representation = [NSMutableDictionary dictionaryWithCapacity:4];
	
	// preapre the type identifier
	if ( [self wantsScript] )
		typeIdentifier = [NSNumber numberWithInt:kMenubarItemAppleScript];
	else
		typeIdentifier = [NSNumber numberWithInt:kMenubarItemURI];
	
	// prepare the identifier
	[identifier replaceOccurrencesOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] 
	withString:@"" options:0 range:NSMakeRange(0,[identifier length])];

	
	if ( icon != nil ) [representation setObject:[NSKeyedArchiver archivedDataWithRootObject:icon] forKey:@"image"];
	if ( title != nil ) [representation setObject:title forKey:@"title"];
	if ( helptip != nil ) [representation setObject:helptip forKey:@"tooltip"];
	
	if ( filepath != nil && [self wantsFile] ) [representation setObject:[[NSURL fileURLWithPath:filepath] absoluteString] forKey:@"targetURI"];
	if ( scriptSource != nil && [self wantsScript] ) [representation setObject:[NSKeyedArchiver archivedDataWithRootObject:[self scriptSource]] forKey:@"targetScript"];
	
	if ( identifier != nil ) [representation setObject:identifier forKey:@"identifier"];
	if ( typeIdentifier != nil ) [representation setObject:typeIdentifier forKey:@"typeIdentifier"];
	
	return representation;

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

- (NSImage *)icon
{
	return icon;
}

- (void) setIcon:(NSImage*)anImage
{
	if ( icon != anImage )
	{
		[icon release];
		icon = [anImage copyWithZone:[self zone]];
	}
}

- (NSString *)title
{
	return title;
}

- (void) setTitle:(NSString*)aString
{
	if ( title != aString )
	{
		[title release];
		title = [aString copyWithZone:[self zone]];
	}
}

- (NSString *)helptip
{
	return helptip;
}

- (void) setHelptip:(NSString*)aString
{
	if ( helptip != aString )
	{
		[helptip release];
		helptip = [aString copyWithZone:[self zone]];
	}
}

- (NSString *)filepath
{
	return filepath;
}

- (void) setFilepath:(NSString*)aString
{
	if ( filepath != aString )
	{
		[filepath release];
		filepath = [aString copyWithZone:[self zone]];
	}
}

- (NSAttributedString *)scriptSource
{
	return scriptSource;
}

- (void) setScriptSource:(NSAttributedString*)anAttributedString
{
	if ( scriptSource != anAttributedString )
	{
		[scriptSource release];
		scriptSource = [anAttributedString copyWithZone:[self zone]];
	}
}

- (id) representedObject
{
	return representedObject;
}

- (void) setRepresentedObject:(id)anObject
{
	if ( representedObject != anObject )
	{
		[representedObject release];
		representedObject = [anObject retain];
	}
}

#pragma mark -

- (BOOL) wantsScript
{
	return wantsScript;
}

- (void) setWantsScript:(BOOL)aBool
{
	wantsScript = aBool;
	if ( wantsScript == YES ) [self setWantsFile:NO];
}

- (BOOL) wantsFile
{
	return wantsFile;
}

- (void) setWantsFile:(BOOL)aBool
{
	wantsFile = aBool;
	if ( wantsFile == YES ) [self setWantsScript:NO];
}

#pragma mark -

- (IBAction) save:(id)sender 
{	
	[objectController commitEditing];
	
	if ( [self title] == nil || [[self title] length] == 0 )
	{
		NSBeep();
		[[self window] makeFirstResponder:titleField];
	}
	else
	{
		if ( isSheet )
			[NSApp endSheet:targetWindow returnCode:NSRunStoppedResponse];
		else
			[NSApp stopModal];
	}
}

- (IBAction) cancel:(id)sender 
{	
	[objectController commitEditing];
	
	if ( isSheet )
		[NSApp endSheet:targetWindow returnCode:NSRunAbortedResponse];
	else
		[NSApp abortModal];
}

- (IBAction)chooseApplication:(id)sender
{
	int result;
    NSArray *fileTypes = /*[NSArray arrayWithObjects:@"app", @"application", @"scpt", nil]*/ nil;
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
 
    result = [oPanel runModalForDirectory:@"/Applications" file:nil types:fileTypes];
    if (result == NSOKButton) 
	{
        NSString *theFilename = [oPanel filename];
        NSString *theAppname = [[NSFileManager defaultManager] displayNameAtPath:theFilename];
		NSImage *theIcon = [[[NSWorkspace sharedWorkspace] iconForFile:theFilename] imageWithWidth:22 height:22];
		
		[applicationField setFilename:theFilename];
		[appnameField setStringValue:theAppname];
		[appImageView setImage:theIcon];
		[appImageView setHidden:NO];
		
		[self setIcon:theIcon];
		[self setFilepath:theFilename];
		[self setWantsFile:YES];
    }
}

- (BOOL) mediabarItemApplicationPicker:(MediabarItemApplicationPicker*)appPicker shouldAcceptDrop:(NSString*)aFilename
{
	NSString *theFilename = aFilename;
	NSString *theAppname = [[NSFileManager defaultManager] displayNameAtPath:theFilename];
	NSImage *theIcon = [[[NSWorkspace sharedWorkspace] iconForFile:theFilename] imageWithWidth:22 height:22];
	
	[applicationField setFilename:theFilename];
	[appnameField setStringValue:theAppname];
	[appImageView setImage:theIcon];
	[appImageView setHidden:NO];
	
	[self setIcon:theIcon];
	[self setFilepath:theFilename];
	[self setWantsFile:YES];
	
	return YES;
}

- (IBAction) verifyDraggedImage:(id)sender
{
	NSImage *anImage = [sender image];
	NSImage *resizedImage = [anImage imageWithWidth:22 height:22 inset:0];
	[self setIcon:resizedImage];
}


- (IBAction)help:(id)sender
{
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"CustomizableMediabar" inBook:@"JournlerHelp"];
}

#pragma mark -

- (void) runAsSheetForWindow:(NSWindow*)window attached:(BOOL)sheet location:(NSRect)frame 
{	
	int result = NSRunAbortedResponse;
	isSheet = sheet;
	
	id originalDelegate = [window delegate];
	[window setDelegate:self];
	
	if ( sheet ) 
	{
		sheetFrame = frame;
		sheetFrame.size.height = 0;
		
		//[NSApp beginSheet: [self window] modalForWindow: window modalDelegate: self
		//		didEndSelector: @selector(sheetDidEnd:returnCode:contextInfo:) contextInfo: nil];
		[NSApp beginSheet: [self window] modalForWindow: window modalDelegate: self
				didEndSelector: @selector(sheetDidEnd:returnCode:contextInfo:) contextInfo: nil];
	}
	else 
	{
		//result = [NSApp runModalForWindow: [self window]];
		result = [NSApp runModalForWindow: [self window]];
	}
	
	if ( !isSheet && result == NSRunAbortedResponse ) 
	{
		// only possible if ran as modal and the date was canceled
		if ( [delegate respondsToSelector:@selector(mediabarItemCreateDidCancelAction:)] )
			[delegate mediabarItemCreateDidCancelAction:self];
			
		//[[self window] close];
		[[self window] close];
	}
	else if ( !isSheet && result == NSRunStoppedResponse ) 
	{
		// only possible if ran as modal and the date was saved
		if ( [delegate respondsToSelector:@selector(mediabarItemCreateDidSaveAction:)] )
			[delegate mediabarItemCreateDidSaveAction:self];
			
		//[[self window] close];
		[[self window] close];
	}
	
	[window setDelegate:originalDelegate];
}

- (void) sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void  *)contextInfo 
{	
	if ( returnCode == NSRunAbortedResponse && [delegate respondsToSelector:@selector(mediabarItemCreateDidCancelAction:)] )
		[delegate mediabarItemCreateDidCancelAction:self];
			
	else if ( returnCode == NSRunStoppedResponse && [delegate respondsToSelector:@selector(mediabarItemCreateDidSaveAction:)] )
		[delegate mediabarItemCreateDidSaveAction:self];
	
	//[[self window] close];
	[[self window] close];
}

#pragma mark -

- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect 
{
	return sheetFrame;
}


@end
