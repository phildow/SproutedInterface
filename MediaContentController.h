//
//  MediaContentController.h
//  SproutedInterface
//
//  Created by Philip Dow on 6/11/06.
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

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

#define PDMediabarItemShowInFinder		@"PDMediabarItemShowInFinder"
#define PDMediabarItemOpenWithFinder	@"PDMediabarItemOpenWithFinder"
#define PDMediaBarItemGetInfo			@"PDMediaBarItemGetInfo"

@class PDMediaBar;
@class PDMediabarItem;
@class JournlerGradientView;

@interface MediaContentController : NSObject {
	
	IBOutlet NSView *contentView;
	IBOutlet PDMediaBar *bar;
	
	id delegate;
	NSURL *URL;
	
	id representedObject;
	NSString *searchString;
	
	NSDictionary *fileError;
	NSManagedObjectContext *managedObjectContext;
}

- (id) initWithOwner:(id)anObject managedObjectContext:(NSManagedObjectContext*)moc;

- (NSView*) contentView;
- (NSUndoManager*) undoManager;

- (id) delegate;
- (void) setDelegate:(id)anObject;

- (NSManagedObjectContext*) managedObjectContext;
- (void) setManagedObjectContext:(NSManagedObjectContext*)moc;

- (id) representedObject;
- (void) setRepresentedObject:(id)anObject;

- (NSURL*) URL;
- (void) setURL:(NSURL*)aURL;

- (NSString*) searchString;
- (void) setSearchString:(NSString*)aString;

- (BOOL) loadURL:(NSURL*)aURL;
- (BOOL) highlightString:(NSString*)aString;

- (IBAction) printSelection:(id)sender;
- (IBAction) exportSelection:(id)sender;

- (IBAction) getInfo:(id)sender;
- (IBAction) showInFinder:(id)sender;
- (IBAction) openInFinder:(id)sender;

- (void) prepareTitleBar;
- (void) setWindowTitleFromURL:(NSURL*)aURL;

- (NSResponder*) preferredResponder;
- (void) appropriateFirstResponder:(NSWindow*)window;
- (void) appropriateAlternateResponder:(NSWindow*)aWindow;
- (void) establishKeyViews:(NSView*)previous nextKeyView:(NSView*)next;

- (BOOL) commitEditing;
- (void) ownerWillClose:(NSNotification*)aNotification;

- (void) updateContent;
- (void) stopContent;

- (BOOL) handlesFindCommand;
- (void) performCustomFindPanelAction:(id)sender;

- (BOOL) handlesTextSizeCommand;
- (void) performCustomTextSizeAction:(id)sender;

- (BOOL) canAnnotateDocumentSelection;
- (IBAction) annotateDocumentSelection:(id)sender;

- (BOOL) canHighlightDocumentSelection;
- (IBAction) highlightDocumentSelection:(id)sender;

- (BOOL)validateMenuItem:(NSMenuItem*)menuItem;

@end

@interface NSObject (MediaContentDelegate)

- (void) contentController:(MediaContentController*)controller changedTitle:(NSString*)title;
- (void) contentController:(MediaContentController*)aController showLexiconSelection:(id)anObject term:(NSString*)aTerm;

@end

@interface NSView (MediaContentAdditions)

- (void) setImage:(NSImage*)anImage;

@end
