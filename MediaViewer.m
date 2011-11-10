//
//  MediaViewer.m
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

#import <SproutedInterface/MediaContentController.h>MediaViewer.h>

/*
#import "NSWorkspace_PDCategories.h"
#import "MediaContentController.h"

#import "AudioViewController.h"
#import "MovieViewController.h"
#import "WebViewController.h"
#import "PDFViewController.h"
#import "ImageViewController.h"
#import "AddressRecordController.h"
#import "MailMessageController.h"
#import "WordDocumentController.h"
#import "TextDocumentController.h"
*/

//#import "JournlerResource.h"

@implementation MediaViewer

+ (BOOL) canDisplayMediaOfType:(NSString*)uti url:(NSURL*)aURL
{
	BOOL can_display = NO;
	/*
	if ( uti == nil ) 
		return NO;
	
	NSString *path = nil;
	if ( [aURL isFileURL] )
		path = [aURL path];
		
	NSString *mime_type = (NSString*)UTTypeCopyPreferredTagWithClass((CFStringRef)uti,kUTTagClassMIMEType);
		
	if ( UTTypeConformsTo((CFStringRef)uti,kUTTypeWebArchive) || UTTypeConformsTo( (CFStringRef)uti, kUTTypeHTML) )
		can_display = YES;
	else if ( UTTypeConformsTo((CFStringRef)uti,kUTTypePDF) )
		can_display = YES;
	else if ( UTTypeConformsTo((CFStringRef)uti,kUTTypeImage) )
		can_display = YES;
	else if ( [[NSWorkspace sharedWorkspace] canPlayFile:path] )
		can_display = YES;
	else if ( [[NSWorkspace sharedWorkspace] canWatchFile:path] )
		can_display = YES;
	
	else if ( UTTypeConformsTo((CFStringRef)uti,kUTTypeURL) || UTTypeConformsTo((CFStringRef)uti,(CFStringRef)LexUTTypeURL) )
		can_display = YES;
	else if ( UTTypeConformsTo((CFStringRef)uti,(CFStringRef)LexUTTypeABPerson) )
		can_display = YES;
	else if ( UTTypeConformsTo((CFStringRef)uti,(CFStringRef)LexUTTypeMailEmail) )
		can_display = YES;
	
	else if ( UTTypeConformsTo( (CFStringRef)uti, (CFStringRef)@"com.microsoft.word.doc") )
		can_display = YES;
	else if ( mime_type != nil && [WebView canShowMIMEType:mime_type] )
		can_display = YES;
	else if ( UTTypeConformsTo( (CFStringRef)uti, kUTTypeRTF ) || UTTypeConformsTo( (CFStringRef)uti, kUTTypeRTFD ) || UTTypeConformsTo( (CFStringRef)uti, kUTTypePlainText ) )
		can_display = YES;
	else
		can_display = NO;
		
	if ( mime_type != nil ) 
		[mime_type release];
	*/
	return can_display;
}

#pragma mark -

- (id) initWithURL:(NSURL*)url uti:(NSString*)uti
{
	_contentController = nil;
	Class controllerClass = nil;
	
	/*
	// first determine if we can display the media
	if ( [url isFileURL] ) 
	{
		if ( UTTypeConformsTo((CFStringRef)uti,kUTTypeWebArchive) || UTTypeConformsTo( (CFStringRef)uti, kUTTypeHTML) )
			controllerClass = [WebViewController class];
			
		else if ( UTTypeConformsTo((CFStringRef)uti,(CFStringRef)kUTTypePDF) )
			controllerClass = [PDFViewController class];
		
		else if ( UTTypeConformsTo((CFStringRef)uti,(CFStringRef)kUTTypeImage) )
			controllerClass = [ImageViewController class];
		
		else if ( UTTypeConformsTo((CFStringRef)uti,(CFStringRef)kUTTypeAudio) )
			controllerClass = [AudioViewController class];
		
		else if ( UTTypeConformsTo((CFStringRef)uti,(CFStringRef)@"public.movie") )
			controllerClass = [MovieViewController class];
		
		else if ( UTTypeConformsTo((CFStringRef)uti,(CFStringRef)LexUTTypeMailEmail) )
			controllerClass = [MailMessageController class];
		
		else if ( UTTypeConformsTo( (CFStringRef)uti, (CFStringRef)@"com.microsoft.word.doc") )
			controllerClass = [WordDocumentController class];
		
		else if ( UTTypeConformsTo( (CFStringRef)uti, kUTTypeRTF ) || UTTypeConformsTo( (CFStringRef)uti, kUTTypeRTFD ) || UTTypeConformsTo( (CFStringRef)uti, kUTTypePlainText ) )
			controllerClass = [TextDocumentController class];
		
		else if ( uti != nil )
		{
			// check the mime type
			NSString *mime_type = (NSString*)UTTypeCopyPreferredTagWithClass((CFStringRef)uti,kUTTagClassMIMEType);
			if ( mime_type != nil && [WebView canShowMIMEType:mime_type] )
				controllerClass = [WebViewController class];
		}
	}
	
	
	else 
	{
		if ( UTTypeConformsTo((CFStringRef)uti,kUTTypeURL) || UTTypeConformsTo((CFStringRef)uti,(CFStringRef)LexUTTypeURL) )
			controllerClass = [WebViewController class];
		else if ( UTTypeConformsTo((CFStringRef)uti,(CFStringRef)LexUTTypeABPerson) )
			controllerClass = [AddressRecordController class];
	}
	*/
	
	if ( controllerClass == nil ) 
	{
		[self release];
		return nil;
	}
	
	else if ( self = [self initWithWindowNibName:@"MediaViewer"] ) 
	{
		// take control of ourselves
		//[self setShouldCascadeWindows:NO];
		
		homeURL = [url retain];
		_contentController = [[controllerClass alloc] init];
		[self retain];
	}
	
	return self;
}


- (void) windowDidLoad 
{	
	[[self window] setFrameUsingName:@"Media Viewer Window" force:YES];
	[[self window] setBackgroundColor:[NSColor whiteColor]];
	
	[[_contentController contentView] setFrame:[contentPlaceholder frame]];
	[[[self window] contentView] replaceSubview:contentPlaceholder with:[_contentController contentView]];
	
	//[[self window] setContentView:[_contentController contentView]];
	
	[_contentController setDelegate:self];
	[_contentController loadURL:homeURL];
	
}

- (void) dealloc 
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s", [self className], _cmd);
	#endif
	
	[_contentController ownerWillClose:nil];
	[_contentController release];
	[homeURL release];
	
	[super dealloc];
}

- (void)windowWillClose:(NSNotification *)aNotification 
{
	[self autorelease];
}

#pragma mark -

- (id) representedObject
{
	return [_contentController representedObject];
}

- (void) setRepresentedObject:(id)anObject
{
	[_contentController setRepresentedObject:anObject];
}

#pragma mark -

- (MediaContentController*) contentController
{
	return _contentController;
}

#pragma mark -

- (void) contentController:(MediaContentController*)controller changedTitle:(NSString*)title 
{
	if ( controller != _contentController ) 
		return;
	
	if ( title != nil ) 
		[[self window] setTitle:title];
}

#pragma mark -

- (BOOL) highlightString:(NSString*)aString
{
	// pass it on to the controller
	return [_contentController highlightString:aString];
}

- (IBAction) printDocument:(id)sender 
{
	// pass it on to the controller
	[_contentController printDocument:sender];
}

- (IBAction) save:(id)sender
{
	NSBeep();
	return;
}

- (IBAction) exportSelection:(id)sender
{
	// pass it on to the controller
	[_contentController exportSelection:sender];
}

- (IBAction) doPageSetup:(id) sender 
{	
	NSPageLayout *pageLayout = [NSPageLayout pageLayout];
	//[pageLayout setAccessoryView:[[PageSetupController sharedPageSetup] contentView]];
	
	if ( [[self window] isMainWindow] )
		[pageLayout beginSheetWithPrintInfo:[NSPrintInfo sharedPrintInfo] modalForWindow:[self window] 
				delegate:nil didEndSelector:nil contextInfo:nil];
	else
		[pageLayout runModalWithPrintInfo:[NSPrintInfo sharedPrintInfo]];
	
}

- (BOOL)validateMenuItem:(NSMenuItem*)menuItem
{
	BOOL enabled = YES;
	SEL action = [menuItem action];
	
	if ( action == @selector(printDocument:) )
		enabled = YES;
		
	else if ( action == @selector(doPageSetup:) )
		enabled = YES;
		
	else if ( action == @selector(exportSelection:) )
		enabled = YES;
		
	else if ( action == @selector(save:) )
		enabled = NO;
	
	else if ( action == @selector(performCustomFindPanelAction:) )
		enabled = [_contentController handlesFindCommand];
	
	else if ( action == @selector(performCustomTextSizeAction:) )
		enabled = [_contentController handlesTextSizeCommand];
	
	return enabled;
}

@end

@implementation MediaViewer (CustomMenuSupport)

- (void)performCustomFindPanelAction:(id)sender
{
	// the first responder should only make it this far under special circumstances
	if ( [_contentController handlesFindCommand] && [_contentController respondsToSelector:@selector(performCustomFindPanelAction:)] )
		[_contentController performSelector:@selector(performCustomFindPanelAction:) withObject:sender];
	else
	{
		NSBeep();
	}
}

- (void) performCustomTextSizeAction:(id)sender
{
	// the first responder should only make it this far under special circumstances
	if ( [_contentController handlesTextSizeCommand] && [_contentController respondsToSelector:@selector(performCustomTextSizeAction:)] )
		[_contentController performSelector:@selector(performCustomTextSizeAction:) withObject:sender];
	else
	{
		NSBeep();
	}
}

@end