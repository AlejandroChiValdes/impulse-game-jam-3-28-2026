extends RichTextLabel

func show_new_time(new_time: float):
	text = String.num(new_time, 2)
	#clear()
	#add_text(String.num(new_time, 2))
