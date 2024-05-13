class_name Task
extends Resource

const NULL: String = "__null__"

@export var id: String

@export var parent  :       String  = NULL
@export var children: Array[String] = [  ]
