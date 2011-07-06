//
//  MailMessageParser.h
//  SproutedUtilities
//
//  Created by Philip Dow on 1/12/07.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>
//#import <Pantomime/Pantomime.h>

@interface MailMessageParser : NSObject {

	NSString *_filepath;
	//CWMessage *_message;
	id _message;
	
	NSMutableString *_htmlBody;
	NSMutableString *_plaintextBody;
	//CWMIMEMultipart *_multipartContent;
	id _multipartContent;
	
	NSString *_fileType;
}

- (id) initWithFile:(NSString*)path;
- (BOOL) _initializeMessage;

//- (CWMessage*) message;
- (id) message;

- (BOOL) hasHTMLBody;
- (BOOL) hasPlainTextBody;

- (NSString*) body:(BOOL)preferHTML;

@end