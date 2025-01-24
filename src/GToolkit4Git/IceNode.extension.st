Extension { #name : #IceNode }

{ #category : #'*GToolkit4Git' }
IceNode >> gtViewChildrenFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Children';
		priority: 50;
		items: [ self children ];
		column: 'Node' text: [ :aNode | aNode gtDisplayString ];
		column: 'Value' text: [ :aNode | aNode value gtDisplayString ]
]

{ #category : #'*GToolkit4Git' }
IceNode >> gtViewDiffFor: aView [

	<gtView>
	| view |
	((self value isKindOf: IceOperation) or: [ 
		 self value isKindOf: IceOperationMerge ]) ifFalse: [ ^ aView empty ].

	view := aView textEditor
		        title: 'Diff' translated;
		        priority: 20;
		        text: [ :anEditor | 
			        GtEpiceaDiffStencil new
				        from: self value rightContents;
				        to: self value leftContents;
				        create ].

	self value isConflict ifTrue: [ 
		view
			actionDropdownButtonLabel: 'Resolve'
			tooltip: 'Resolve Conflict'
			content: [ :aDropdown :aTarget | 
				| leftButton rightButton |
				leftButton := BrButton new.
				leftButton
					aptitude: BrGlamorousButtonWithIconAptitude;
					icon: BrGlamorousVectorIcons left;
					label: 'Choose Right';
					disabled: self value isRightChosen;
					action: [ 
						self value selectRight.
						Iceberg announcer announce: GtIceMergeConflictResolved new.
						aDropdown enqueueTask: (BlTaskAction new action: [ 
										 aDropdown dispatchEvent:
												 (BrDropdownHideWish new anchor: aDropdown) ]).
						rightButton phlow fireUpdateWish ].

				rightButton := BrButton new.
				rightButton
					aptitude: BrGlamorousButtonWithIconAptitude;
					icon: BrGlamorousVectorIcons right;
					label: 'Choose Left';
					disabled: self value isLeftChosen;
					action: [ 
						self value selectLeft.
						Iceberg announcer announce: GtIceMergeConflictResolved new.
						aDropdown enqueueTask: (BlTaskAction new action: [ 
										 aDropdown dispatchEvent:
												 (BrDropdownHideWish new anchor: aDropdown) ]).
						rightButton phlow fireUpdateWish ].

				BrHorizontalPane new
					hFitContent;
					vFitContentLimited;
					padding: (BlInsets all: 10);
					addChildren: { 
							leftButton.
							rightButton } ] ].

	^ view
]

{ #category : #'*GToolkit4Git' }
IceNode >> gtViewNodeValuesTreeFor: aView [
	<gtView>
	
	^ aView tree
		title: 'Node values';
		priority: 25;
		items: [ { self } ];
		children: [ :each | each children ];
		itemText: [ :aNode | aNode value gtDisplayString ];
		expandAll;
		send: [ :aNode | aNode value ]
]

{ #category : #'*GToolkit4Git' }
IceNode >> gtViewNodesTreeFor: aView [
	<gtView>
	
	^ aView columnedTree
		title: 'Nodes';
		items: [ { self } ];
		children: [ :each | each children ];
		column: 'Node' text: [ :aNode | aNode gtDisplayString ];
		column: 'Value' text: [ :aNode | aNode value gtDisplayString ];
		expandAll
]
