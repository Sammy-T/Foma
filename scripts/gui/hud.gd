extends MarginContainer


const HEART_FULL: Texture2D = preload("res://assets/kenney_pixelplatformer/Tiles/tile_0044.png")
const HEART_HALF: Texture2D = preload("res://assets/kenney_pixelplatformer/Tiles/tile_0045.png")
const HEART_EMPTY: Texture2D = preload("res://assets/kenney_pixelplatformer/Tiles/tile_0046.png")

@onready var health_display: HBoxContainer = %HealthDisplay
@onready var hearts: Array[Node] = health_display.get_children()
@onready var coin_display: Label = %CoinCount


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func update_health_display(health: float) -> void:
	for i in hearts.size():
		var heart: TextureRect = hearts[hearts.size() - (i + 1)]
		
		if health >= 1:
			health -= 1
			heart.texture = HEART_FULL
		elif is_equal_approx(health, 0.5):
			health -= 0.5
			heart.texture = HEART_HALF
		else:
			heart.texture = HEART_EMPTY


func update_coin_display(coin_count: int) -> void:
	coin_display.text = "x%d" % coin_count
