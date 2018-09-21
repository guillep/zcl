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

	^ (ClapCommand withName: 'serve')
		description: 'Serve a directory in a port in localhost. By default serves the working directory in port 8080';
		add: ClapFlag forHelp;
		add: ((ClapFlag withName: 'directory')
			description: 'Directory to serve';
			defaultMeaning: [ FileSystem workingDirectory ]);
		add: ((ClapPositional withName: 'port')
			description: 'Server port';
			defaultMeaning: [ 8080 ]);
		add: ((ClapPositional withName: 'prefix')
			description: 'Server prefix';
			defaultMeaning: [ '' ]);
		meaning: [ :args |
			args atName: 'help' ifFound: [ :help |
				help value.
				help context exitSuccess ].

			self new serveWithArgs: args ]
]

{ #category : #serving }
ZclCommands >> serveWithArgs: arguments [

	ZnServer startDefaultOn: (arguments atName: 'port') value asNumber.
	ZnServer default delegate: (ZnStaticFileServerDelegate new
		prefixFromString: (arguments atName: 'prefix') value;
		directory: (arguments atName: 'directory') value asFileReference;
		yourself).
]
