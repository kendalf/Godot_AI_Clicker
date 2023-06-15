extends Node

const SAVE_INTERVAL = 30
var saveTimer = 0
var popup_data = {}

#GameState Data
onready var generator_tiers = preload("res://data/generator_tiers/generator_tiers.tres")
onready var upgrades = preload("res://data/upgrades/upgrades.tres")
onready var achievements = preload("res://data/achievments/achievements_res_array.tres")
onready var OCList = preload("res://data/overClock/overClockItems.tres")
onready var gameState = GameState.new()
onready var allTimeGameState = GameState.new()

func _ready() -> void:
	print("booting up game")
	#temporarily mute the game while everything loads
	AudioServer.set_bus_mute(0, true)
	#set the Big numbers settings
	Big.setThousandSeparator(",")  # Defaults to "."
	Big.setDecimalSeparator(".")   # Defaults to ","
	Big.setDynamicDecimals(false)  # Defaults to true
	Big.setSmallDecimals(1)     # Defaults to 2
	Big.setThousandDecimals(1)  # Defaults to 2
	Big.setBigDecimals(1)       # Defaults to 2
	#load save file if its found
	_load_game()

	if OS.is_debug_build():
		print("starting debug mode")
		debug_settings()

	#set the volume levels
	var sfx_bus := AudioServer.get_bus_index("SFX")
	var music_bus := AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(sfx_bus, linear2db(gameState.settings["SFX"]))
	AudioServer.set_bus_volume_db(music_bus, linear2db(gameState.settings["Music"]))
	AudioServer.set_bus_mute(0, false) #unmute master


func _process(delta: float) -> void:
	saveTimer += delta
	if saveTimer >= SAVE_INTERVAL:
		saveTimer = 0
		_save_game()

func _save_game():
	gameState.timeSaved = OS.get_unix_time()
	gameState.compute_daily_streak()
	var data = {}
	data["generator_tiers"] = generator_tiers.get_save_dict()
	data["upgrades"] = upgrades.get_save_dict()
	data["achievements"] = achievements.get_save_dict()
	data["gameState"] = gameState.get_save_dict()
	data["allTimeGameState"] = allTimeGameState.get_save_dict()
	data["OC"] = OCList.get_save_dict()
	SaveGame.write_save(data)
	print("saved")

func _load_game():
	var data = SaveGame.load_save()
	if data != null:
		print("save file found")
		#update game data
		generator_tiers.update_from_dict(data["generator_tiers"])
		upgrades.update_from_dict(data["upgrades"])
		achievements.update_from_dict(data["achievements"])
		gameState.update_from_dict(data["gameState"])
		allTimeGameState.update_from_dict(data["allTimeGameState"])
		OCList.update_from_dict(data["OC"])
		print("loading...")
		var earned = gameState.compute_offline_earnings()
		var oc = gameState.compute_OC_earnings()
		var message = "[center]While you were away you earned:\n[b] " + earned.toAA() \
						+ " [img=32]res://images/perceptron-256-blurry.png[/img][/b]"
		if oc > 0:
			message += " and [b]" + str(oc) + "[/b] [img=40,]res://images/chip128.png[/img]"
		popup_data = {
			"Image" : "res://images/perceptron_logo.png",
			"Title" : "Welcome Back!",
			"Message" : message,
			"NoThanks" : false
		}
	else:
		print("no save file found")
		print("starting new save file")
		popup_data = {
			"Image" : "res://images/perceptron_logo.png",
			"Title" : "Hello!",
			"Message" : "[center]Welcome to AI Clicker. Hit that compute button to earn " \
						+ "[img=40x32]res://images/perceptron-export.png[/img][/center]",
			"NoThanks" : false
		}
		gameState.runStartTime = OS.get_unix_time()
		_save_game()


func debug_settings():
#	gameState.random_click_event_wait_range = [1, 1]
	gameState.currency = [4, 22]
#	gameState.perClick = [1, 20]
#	gameState.perSec = [1, 20]
#	gameState.totalComputations = [1, 20]
	gameState.overClockPoints = 100
	pass


func reset_run() -> void:
	if gameState.runNumber == 1:
		allTimeGameState = GameState.new()
		allTimeGameState.runNumber = 1
	allTimeGameState = get_new_allTime_gameState(gameState, allTimeGameState)
	var newGameState = GameState.new()
	#save all the data that persists between runs
	newGameState.maxClickUpgradePriceMultiplier = gameState.maxClickUpgradePriceMultiplier
	newGameState.achievmentsGot = gameState.achievmentsGot
	newGameState.overClockPoints = gameState.overClockPoints
	newGameState.computerPriceMultiplier = gameState.computerPriceMultiplier
	newGameState.computerProductionDoubles = gameState.computerProductionDoubles

	newGameState.upgradePriceMultiplier = gameState.upgradePriceMultiplier
	newGameState.computerSpeedMultiplier = gameState.computerSpeedMultiplier
	newGameState.offlineTimeLimit = gameState.offlineTimeLimit
	newGameState.offlineRateMultiplier = gameState.offlineRateMultiplier
	newGameState.scifiComputers = gameState.scifiComputers
	gameState = newGameState
	gameState.runNumber = allTimeGameState.runNumber
	print("starting new run")
	gameState.runStartTime = OS.get_unix_time()
	#rename and keep the old save file just in case the user wants to revert
	var renameSave = "user://run" + str(gameState.runNumber - 1) + ".save"
	var dir = Directory.new()
	dir.rename(SaveGame.SAVE_PATH, renameSave)
	#reload resource files
	generator_tiers = preload("res://data/generator_tiers/generator_tiers.tres")
	upgrades = preload("res://data/upgrades/upgrades.tres")
	generator_tiers.resetResources()
	upgrades.resetResources()
	#apply all the individual computer owned achievements
	for c in gameState.computerProductionDoubles.keys():
		for t in generator_tiers.Tiers:
			if t.Name == c:
				var prod = t.get_BigProduces().multiply(pow(gameState.computerProductionDoubles[c], 2))
				t.set_BigProduces(prod)
	#unlock scifi computers
	for c in gameState.scifiComputers.keys():
		for t in generator_tiers.Tiers:
			if t.Name == c:
				t.Locked = gameState.scifiComputers[c]
	#save and reload scene
	_save_game()
	if OS.is_debug_build():
		print("starting debug mode")
		debug_settings()
	var _result = get_tree().reload_current_scene()


func get_current_allTime_gameState():
	return get_new_allTime_gameState(gameState, allTimeGameState)


static func get_new_allTime_gameState(gs : GameState, at : GameState):
	var newState = GameState.new()
	newState.runNumber = gs.runNumber + 1
	newState.runStartTime = at.runStartTime
	newState.numClicks = gs.numClicks + at.numClicks
	newState.set_currency(Big.max(gs.get_currency(), at.get_currency()))
	newState.set_totalComputations(gs.get_totalComputations().plus(at.get_totalComputations()))
	newState.set_perClick(gs.get_perClick().plus(at.get_perClick()))
	newState.set_perSec(Big.max(gs.get_perSec(), at.get_perSec()))
	newState.random_click_event_clicked = gs.random_click_event_clicked + at.random_click_event_clicked
	newState.numComputers = max(gs.numComputers, at.numComputers)
	newState.achievmentsGot = max(gs.achievmentsGot, at.achievmentsGot)
	newState.upgradesBought =  gs.upgradesBought + at.upgradesBought
	return newState
