SIPOObject
==========

##Introduction

This class is designed to be a lightweight alternative to Apple property lists.

Design requirements / features are:

- compatible with native Cocoa classes
- values and structure stored in easily editable textfile
- support for different classes including NSData and NSColor
- easy access to child elements
- included editor for demonstration and creation of data files

##Usage

Load a NSArray of SIPOObject objects from a file URL:

    +(NSMutableArray*)arrayOfObjectsWithContentsOfURL:(NSURL *)fileURL;
    
You can now access the values of the containing objects via normal getter and setter functions.

	NSArray* myObjArray = [SIPOObject arrayOfObjectsWithContentsOfURL:myURL];
	NSString* valueString = myObjArray.lastObject.value;
	myObjArray.lastObject.value = @"testString";
	
or you can use the special properties mapped to this values:

	@property (assign) BOOL boolValue;
	@property (assign, nonatomic) NSNumber* numberValue;
	@property (assign, nonatomic) NSNumber* boolTagValue;
	@property (assign, nonatomic) NSData* dataValue;
	@property (assign, nonatomic) NSColor* colorValue;

If you modify or create a SIPOObject instance, do not forget to set the correct type for this value. For example to store a NSColor value:

	NSColor* myColor;
	SIPOObject* colorObject = [[SIPOObject alloc] init];
	colorObject.name = @"myColor";
	colorObject.type = SIPOObjectColorValue;
	colorObject.colorValue = myColor;
	[myMutableArrayOfColorObjects addObject:colorObject];
	
Valid types are:

    SIPOObjectStringValue		// for NSString
    SIPOObjectNumberValue		// for NSNumber
	SIPOObjectBOOLValue			// for BOOL
	SIPOObjectDataValue			// for NSData
	SIPOObjectColorValue		// for NSColor

To access child elements you can access NSMutableArray property childs directly or use these convenience functions:

	-(SIPOObject*)childWithName:(NSString*)name;
	-(void)addObject:(SIPOObject*)childObject;
	
To search for a specific in a NSArray of SIPOObject instances use

	+(id)valueForName:(NSString*)name inArray:(NSArray*)array;


Save NSArray with SIPOObject instances to a file URL:

    +(void)saveArray:(NSArray*)array toURL:(NSURL*)fileURL;

##Examples

Please refer to the included editor project as example on how to use this class.

##Editor

This repository includes an Cocoa editor project to demonstrate functionality of this class and to edit files including SIPOObject instances.

##ARC

This class requires ARC.

##License
This class is provided without any warranty as-is. You may include it to any of your commercial or non-commercial projects. Please mention license and usage in your projects about section and do not modify license information in the source file headers. For more details see Apache license.