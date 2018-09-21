Class {
	#name : #BaselineOfZcl,
	#superclass : #BaselineOf,
	#category : #BaselineOfZcl
}

{ #category : #baselines }
BaselineOfZcl >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec
		baseline: 'Clap' with: [ spec repository: 'github://cdlm/clap-st/src' ];
		package: 'Zcl']
]
