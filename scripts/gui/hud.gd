extends MarginContainer


@onready var health_display: Label = %HealthAmt
@onready var coin_display: Label = %CoinCount


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func update_health_display(health: float) -> void:
	health_display.text = "%s" % health
	
#	print(fmod(health, 1))


func update_coin_display(coin_count: int) -> void:
	coin_display.text = "x%d" % coin_count
