extends TextureProgress

func _process(delta):
	$Sprite.global_position.x = self.rect_global_position.x + self.rect_size.x * (self.value/self.max_value)
	$Sprite.global_position.y = self.rect_global_position.y + self.rect_size.y/2
	$City.global_position.x = self.rect_global_position.x + self.rect_size.x
	$City.global_position.y = self.rect_global_position.y + self.rect_size.y/2
