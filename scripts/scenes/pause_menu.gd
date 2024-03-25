extends CenterContainer

signal resume()
signal exit_to_menu()
signal quit()

func _on_resume_btn_pressed():
	resume.emit()


func _on_main_menu_btn_pressed():
	exit_to_menu.emit()


func _on_quit_btn_pressed():
	quit.emit()
