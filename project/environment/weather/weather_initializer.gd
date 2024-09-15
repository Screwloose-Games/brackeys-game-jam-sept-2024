extends CanvasLayer

@onready var animation_tree : AnimationTree = $AnimationTree
func _ready() -> void:
  animation_tree.active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
