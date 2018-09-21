"
I implement command line handlers for starting a static file server on the a directory using Clap.
"
Class {
	#name : #ZclCommands,
	#superclass : #Object,
	#category : #Zcl
}

{ #category : #commands }
ZclCommands class >> serve [
	"Serve a directory in a port"
	<commandline>

	| directoryPositional portPositional prefixPositional |
	directoryPositional := ClapPositional withName: 'DIRECTORY'.
	portPositional := ClapPositional withName: 'PORT'.
	prefixPositional := ClapPositional withName: 'PREFIX'.

	^ (ClapCommand withName: 'serve')
		description: 'Serve a directory in a port in localhost. By default serves the working directory in port 8080';
		add: ClapFlag forHelp;
		add: ((ClapFlag withName: 'directory')
			add: directoryPositional;
			description: 'Directory to serve';
			meaningScalar;
			defaultMeaning: [ FileSystem workingDirectory ]);
		add: ((ClapFlag withName: 'port')
			add: portPositional;
			description: 'Server port';
			meaningScalar;
			defaultMeaning: [ 8080 ]);
		add: ((ClapFlag withName: 'prefix')
			add: prefixPositional;
			description: 'Server prefix';
			meaningScalar;
			defaultMeaning: [ '' ]);
		meaning: [ :args |
			args atName: 'help' ifFound: [ :help |
				help value.
				help context exitSuccess ].

			self new serveWithArgs: args ]
]

{ #category : #serving }
ZclCommands >> serveWithArgs: arguments [

	| port prefix directory |
	port := (arguments atName: 'port') value asNumber.
	prefix := (arguments atName: 'prefix') value.
	directory := (arguments atName: 'directory') value asFileReference.
	
	ZnServer startDefaultOn: port.
	ZnServer default delegate: (ZnStaticFileServerDelegate new
		prefixFromString: prefix;
		directory: directory;
		yourself).
		
	arguments context stdout
		nextPutAll: ('Serving {1} at http://localhost:{2}/{3}' format: {
			directory fullName.
			port asString.
			prefix asString.
		});
		flush;
		newLine.
	self waitForEver.
]

{ #category : #serving }
ZclCommands >> waitForEver [
	"If we let the clap process finish, it will close the image.
	We then need a way to suspend the current process to let the server run."
	
	Processor activeProcess suspend.
]
