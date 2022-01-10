Class {
	#name : #GtGitStatusIncoming,
	#superclass : #GtGitStatusWithCount,
	#category : #'GToolkit4Git-Model'
}

{ #category : #accessing }
GtGitStatusIncoming >> bareIcon [
	^ BrGlamorousVectorIcons down
]

{ #category : #accessing }
GtGitStatusIncoming >> color [
	^ BrGlamorousColors selectedListItemColor
]

{ #category : #accessing }
GtGitStatusIncoming >> label [
	^ count asString, ' incoming changes'
]