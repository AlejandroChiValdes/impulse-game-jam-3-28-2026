extends RichTextLabel

func update_text(elapsed_time : float):
	text = "Elapsed Time: {time}".format({"time": String.num(elapsed_time, 2) })
