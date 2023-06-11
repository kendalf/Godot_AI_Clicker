extends Control

onready var I = Constants.ICON
signal popup

var timer = 0

func _ready() -> void:
	display_stats("This Run", make_run_dict(Globals.gameState))
	var allTime = Globals.get_new_allTime_gameState(Globals.gameState, Globals.allTimeGameState)
	var allTimeDict = make_allTime_dict(allTime)
	display_stats("All Time", allTimeDict)


func _process(delta: float) -> void:
	timer += delta
	if timer >= 1:
		timer  = 0
		get_node("%StatsTextBox").clear()
		call_deferred("_ready")


func make_allTime_dict(gs):
	return {
		"RunTime" : ["Time Played", gs.get_hours_played(), I["time"]],
		"TotalComputations" : ["Total Computations", gs.get_totalComputations().toAA(), I["perc"]],
		"CPS" : ["Highest CPS", gs.get_perSec().toAA(), I["perc"]],
		"Clicks" : ["Button Clicks", Big.new(gs.numClicks).toAA(), I["hand"]],
		"NeuralNets" : ["Neural Nets Caught", Big.new(gs.random_click_event_clicked).toAA(), I["nnet"]],
		"Computers" : ["Computers Owned", Big.new(gs.numComputers).toAA(), I["comp"]],
		"OfflineTime" : ["Offline Earnings Time Limit", str(Globals.gameState.offlineTimeLimit) + "m", I["time"]],
		"OfflineRate" : ["Offline Earnings Rate", str(Globals.gameState.offlineRateMultiplier * 100) + "%", I["time"]],
	}

func make_run_dict(gs):
	return {
		"RunNumber" : ["Run Number", str(gs.runNumber), I["rsrt"]],
		"RunTime" : ["Time Played", gs.get_hours_played(), I["time"]],
		"TotalComputations" : ["Total Computations", gs.get_totalComputations().toAA(), I["perc"]],
		"CPS" : ["Highest CPS", gs.get_perSec().toAA(), I["perc"]],
		"Clicks" : ["Button Clicks", Big.new(gs.numClicks).toAA(), I["hand"]],
		"PerClick" : ["Computes Per Click", gs.get_perClick().toAA(), I["hand"]],
		"NeuralNets" : ["Neural Nets Caught", Big.new(gs.random_click_event_clicked).toAA(), I["nnet"]],
		"Computers" : ["Computers Owned", Big.new(gs.numComputers).toAA(), I["comp"]],
		"ComputerSpeed" : ["Computer Speed Multiplier", Big.new(gs.computerSpeedMultiplier * 100).toAA() + "%", I["comp"]],
		"ComputerPrice" : ["Computer Price Multiplier", Big.new(gs.computerPriceMultiplier * 100).toAA() + "%", I["comp"]],
		"UpgradePrice" : ["Upgrade Price Multiplier", Big.new(gs.upgradePriceMultiplier * 100).toAA() + "%", I["upgr"]],
	}

func display_stats(section_title, data):
	var text = get_node("%StatsTextBox")
	text.push_align(RichTextLabel.ALIGN_CENTER)
	text.push_bold()
	text.add_image(I["star"], 40, 40, 3)
	text.append_bbcode(section_title)
	text.add_image(I["star"], 40, 40, 3)
	text.pop()
	text.push_color("7e858c")
	text.push_table(3)
	for r in data:
		text.push_cell()
		text.append_bbcode(data[r][0])
		text.pop()
		text.push_cell()
		text.push_mono()
		text.push_color("90e36f")
		text.append_bbcode(data[r][1])
		text.pop()
		text.pop()
		text.pop()
		text.push_cell()
		text.add_image(data[r][2], 32, 32, 1)
		text.pop()
	text.pop()
	text.pop()
	text.pop()
	text.newline()
	text.newline()


func _on_back_pressed() -> void:
	GuiTransitions.hide(self.name)

func _on_Reset_pressed() -> void:
	pass

func _on_OCButton_pressed() -> void:
	var popup_data = {
		"Image" : Constants.ICON['rsrt'].resource_path,
		"Title" : "OverClock",
		"Message" : "[center]In order to spend OverClock points you need to " \
					+ "reset your progress. You will keep your" \
					+ " achievements.[/center]",
		"NoThanks" : true,
		"callFunc" : "show",
		"callNode" : GuiTransitions,
		"args" : "PrestigeMenu"
	}
	emit_signal("popup", popup_data)

