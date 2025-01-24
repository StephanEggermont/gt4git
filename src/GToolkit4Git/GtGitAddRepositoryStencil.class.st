Class {
	#name : #GtGitAddRepositoryStencil,
	#superclass : #BrStencil,
	#instVars : [
		'dropdown',
		'repoGroup',
		'onCreated',
		'container'
	],
	#category : #'GToolkit4Git-Inspector Integration'
}

{ #category : #accessing }
GtGitAddRepositoryStencil >> container [
	container ifNil: [
		container := self initialPage ].
	^ container
]

{ #category : #accessing }
GtGitAddRepositoryStencil >> create [
	^ self container 
]

{ #category : #accessing }
GtGitAddRepositoryStencil >> dropdown: aDropdown [ 
	dropdown := aDropdown
]

{ #category : #accessing }
GtGitAddRepositoryStencil >> githubPage [
	| stencil|
	stencil := GtGitGithubPageFormStencil new.
	stencil dropdown: dropdown.
	stencil onCreated: self onCreated.
	^ stencil create.
]

{ #category : #accessing }
GtGitAddRepositoryStencil >> initialPage [
	| element button local label |
	label := BrLabel new.
	label
		aptitude: BrGlamorousLabelAptitude;
		text: 'Import a Git repository'.
	button := BrButton new.
	button
		label: 'remotely'.
	button aptitude: BrGlamorousButtonWithLabelAptitude.
	button action: [ self openGithubPage ].
	local := BrButton new.
	local
		label: 'locally'.
	local aptitude: BrGlamorousButtonWithLabelAptitude.
	local action: [ self openLocalPage ].
	element := BrVerticalPane new.
	label margin: (BlInsets all: 5).
	button margin: (BlInsets all: 5).
	local margin: (BlInsets all: 5).
	element addChild: label.
	element addChild: (BrHorizontalPane new addChild: button; addChild: local; fitContent).
	^ element fitContent
]

{ #category : #accessing }
GtGitAddRepositoryStencil >> localPage [

	| fileBrowser |
	fileBrowser := BrFileSelector new margin: (BlInsets all: 5).

	fileBrowser vExact: 400.
	fileBrowser hExact: 464.

	fileBrowser buttonLabel: 'Import'.
	fileBrowser okAction: [ :filePath | 
		| repo |
		repo := IceRepositoryCreator new
			        location: filePath;
			        createRepository.
		repo register.
		Iceberg announcer announce: (IceRepositoryAnnouncement for: repo).
		self onCreated value: repo.
		dropdown ifNotNil: [ 
			dropdown enqueueTask: (BlTaskAction new action: [ 
					 dropdown dispatchEvent:
						 (BrDropdownHideWish new anchor: dropdown) ]) ] ].

	fileBrowser fileFilterBlock: [ :aFileReference | 
		aFileReference isDirectory and: [ 
			(FileSystemDirectoryEntry reference: aFileReference) isHidden not ] ].
	^ fileBrowser
]

{ #category : #accessing }
GtGitAddRepositoryStencil >> onCreated [

	^ onCreated ifNil: [ [ :repo |  ] ]
]

{ #category : #accessing }
GtGitAddRepositoryStencil >> onCreated: aBlock [
	onCreated := aBlock
]

{ #category : #accessing }
GtGitAddRepositoryStencil >> openGithubPage [

	container removeChildren.
	container addChild: self githubPage
]

{ #category : #accessing }
GtGitAddRepositoryStencil >> openLocalPage [

	container removeChildren.
	container addChild: self localPage
]
