Class {
	#name : #GtGitStatusOutgoing,
	#superclass : #GtGitStatusWithCount,
	#category : #'GToolkit4Git-Model'
}

{ #category : #accessing }
GtGitStatusOutgoing >> bareIcon [
	^ BrGlamorousVectorIcons up
]

{ #category : #accessing }
GtGitStatusOutgoing >> color [
	^ BrGlamorousColors successBackgroundColor 
]

{ #category : #accessing }
GtGitStatusOutgoing >> label [
	^ count asString, ' outgoing changes'
]