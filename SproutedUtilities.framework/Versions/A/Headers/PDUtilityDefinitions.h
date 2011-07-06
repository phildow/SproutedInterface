//
//  PDUtilityDefinitions.h
//  SproutedUtilities
//
//  Created by Philip Dow on 5/15/07.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//


#include <Carbon/Carbon.h>
#include <Cocoa/Cocoa.h>

#define TempDirectory() ( NSTemporaryDirectory() != nil ? NSTemporaryDirectory() : [NSString stringWithString:@"/tmp"] )
#define BundledImageWithName(x,y) [[[NSImage alloc] initWithContentsOfFile:[[NSBundle bundleWithIdentifier:y] pathForImageResource:x]] autorelease]

#define kiLifeIntegrationPboardType		@"iMBNativePasteboardFlavor"
#define kABPeopleUIDsPboardType			@"ABPeopleUIDsPboardType"
#define kMailMessagePboardType			@"MV Super-secret message transfer pasteboard type"
#define kWebURLsWithTitlesPboardType	@"WebURLsWithTitlesPboardType"

#define kPDUTTypeABPerson				@"com.apple.addressbook.person"
#define kPDUTTypeMailEmail				@"com.apple.mail.emlx"
#define kPDUTTypeChatTranscript			@"com.apple.ichat.ichat"
#define kPDUTTypeMailStandardEmail		@"com.apple.mail.email"

#define kPDUTTypeAppleScriptText		@"com.apple.applescript.text"
#define kPDUTTypeAppleScriptData		@"com.apple.applescript.script"
#define kPDUTTypeAppleScriptDictionary	@"com.apple.scripting-definition"