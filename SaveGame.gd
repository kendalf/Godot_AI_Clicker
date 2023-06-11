class_name SaveGame
extends Resource

const SAVE_PATH = "user://currentRun.save"

static func write_save(data : Dictionary):
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	file.store_var(data)
	file.close()

static func save_exists() -> bool:
	var file = File.new()
	return file.file_exists(SAVE_PATH)

static func load_save():
	var file = File.new()
	var result = null
	if save_exists():
		file.open(SAVE_PATH, File.READ)
		result = file.get_var()
	file.close()
	return result
