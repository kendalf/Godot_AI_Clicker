extends Control

onready var particles = get_node("%Tier0_Particles")
onready var click_particles = get_node("%Click_Particles")
onready var menus = get_node("%Menus").get_children()
var random_click_event_timer = 0
var random_click_event_timeout

const UPDATE_INTERVAL = 0.2
var click_multiplier_timer = 0
var click_multiplier = 1

var click_particle_timer = 0
var is_clicking = false

func _ready() -> void:
	random_click_event_timeout = rand_range(Globals.gameState.random_click_event_wait_range[0], Globals.gameState.random_click_event_wait_range[1])
	update_particles()
	get_tree().set_auto_accept_quit(false)
	get_node("%Popup").update_content(Globals.popup_data)
	get_node("%Popup").popup()


func _process(delta: float) -> void:
	click_particle_timer += delta
	if click_particle_timer >= 1: #update every second
		click_particle_timer = 0
		update_click_particles()
		is_clicking = false
		call_deferred("update_achievements")

	#upadte click multiplier
	var alpha = get_node("%CPU").self_modulate.a
	var red = get_node("%Button").self_modulate.s
	get_node("%Button").self_modulate.s = max(0.1, red - 0.005)
	click_multiplier_timer += delta
	if click_multiplier_timer >= UPDATE_INTERVAL:
		click_multiplier_timer = 0
		click_multiplier = min(round(alpha * 10), Globals.gameState.maxClickMultiplier)
		if click_multiplier > 1:
			get_node("%ClickMultiplier").text = " X" + str(click_multiplier)
		else:
			get_node("%ClickMultiplier").text = ""
	if !is_clicking: get_node("%clickAmount").text = ""
	#decrease CPU brightnes
	get_node("%CPU").self_modulate.a = max(0.1, alpha - 0.005)

	#update random click event
	random_click_event_timer += delta
	if random_click_event_timer >= random_click_event_timeout:
		var rce = get_node("%Random_Click_Event")
		if not rce.clickable and Globals.gameState.get_perSec().isLargerThan(0):
			get_node("%Button").notif_on()
			if Globals.gameState.random_click_event_clicked == 0:
				get_node("%EventLog").add_event("Quick! Catch that rogue Neural Net!", true, "res://images/dingbats-22-export2.png")
			rce.start()

func _notification(what: int) -> void:
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST
		or what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST
		or what == MainLoop.NOTIFICATION_APP_PAUSED
		or what == MainLoop.NOTIFICATION_WM_UNFOCUS_REQUEST
		or what == MainLoop.NOTIFICATION_WM_FOCUS_OUT):
		Globals._save_game()
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()


func update_achievements():
	for achiev_res in Globals.achievements.list:
		if achiev_res.checkTrigger():
			Globals.gameState.achievmentsGot += 1
			get_node("%EventLog").add_event("Achievement Got! " + achiev_res.Description, false, "res://images/1x/trophy.png")
			get_node("%Achievements").update_ui()
#			get_node("%achivements_button/notification").visible = true
			get_node("%achivements_button").notif_on()


func update_click_particles():
	if is_clicking and click_particles.emitting == false:
		click_particles.emitting = true
		if Globals.gameState.get_perClick().isLessThan(100):
			click_particles.amount = int(Globals.gameState.get_perClick().toString()) + 1
		else:
			click_particles.amount = 100
	if is_clicking == false:
		click_particles.emitting = false


func update_particles():
	var i = 0
	for t in Globals.generator_tiers.Tiers:
		if t.Owned > 0:
			var node = get_node_or_null("%Tier" + str(i) + "_Particles")
			if node:
				node.visible = true
				node.amount = t.Owned
		i += 1


func _on_Button_pressed() -> void:
	if is_clicking == false:
		click_particle_timer = 0
	is_clicking = true
	#upadate click amount on button
	if is_clicking:
		get_node("%clickAmount").text = "+" + Globals.gameState.get_perClick().multiply(click_multiplier).toAA()
	#increase CPU brightnes and button color
	var alpha = get_node("%CPU").self_modulate.a + 0.15
	get_node("%CPU").self_modulate.a = min(1.0, alpha)
	var red = get_node("%Button").self_modulate.s + 0.15
	get_node("%Button").self_modulate.s = min(1.0, red)
	#update clicks to % of cps
	var temp = Globals.gameState.get_perSec().multiply(Globals.gameState.CPS_click_percent)
	if Globals.gameState.get_perClick().isLessThan(temp):
		Globals.gameState.set_perClick(temp)
	#update globals
	Globals.gameState.set_currency(Globals.gameState.get_currency().plus(Globals.gameState.get_perClick().multiply(click_multiplier)))
	Globals.gameState.numClicks += 1


func _on_buy_pressed() -> void:
	hide_menus()
	GuiTransitions.show("Tiers")
	yield(get_tree().create_timer(0.5), "timeout")
	hide_menus("Tiers")
#	get_node("%computers_button/notification").visible = false
	get_node("%computers_button").notif_off()

func _on_options_pressed() -> void:
	hide_menus()
	GuiTransitions.show("Options")
	yield(get_tree().create_timer(0.5), "timeout")
	hide_menus("Options")

func _on_achivements_pressed() -> void:
	hide_menus()
	GuiTransitions.show("Achievements")
	yield(get_tree().create_timer(0.5), "timeout")
	hide_menus("Achievements")
#	get_node("%achivements_button/notification").visible = false
	get_node("%achivements_button").notif_off()

func _on_upgrades_pressed() -> void:
	hide_menus()
	GuiTransitions.show("Upgrades")
	yield(get_tree().create_timer(0.5), "timeout")
	hide_menus("Upgrades")
#	get_node("%upgrades_button/notification").visible = false
	get_node("%upgrades_button").notif_off()

func _on_stats_button_pressed() -> void:
	hide_menus()
	GuiTransitions.show("StatsMenu")
	yield(get_tree().create_timer(0.5), "timeout")
	hide_menus("StatsMenu")
#	get_node("%stats_button/notification").visible = false
	get_node("%stats_button").notif_off()

func hide_menus(except := ""):
	update_particles()
	for m in menus:
		if GuiTransitions.is_shown(m.name) and m.name != except:
			GuiTransitions.hide(m.name)


func _on_Random_Click_Event_clicked(size_scale) -> void:
	Globals.gameState.random_click_event_clicked += 1
#	get_node("%Button/notification").visible = false
	get_node("%Button").notif_off()
	var multi = round((1.0 - size_scale[0].x) * Globals.gameState.random_click_event_scale_multiplier) + 1
	var amount = Globals.gameState.get_perSec()
	amount.multiply(30 * multi)
	Globals.gameState.set_currency(Globals.gameState.get_currency().plus(amount))
	random_click_event_timeout = rand_range(Globals.gameState.random_click_event_wait_range[0], Globals.gameState.random_click_event_wait_range[1])
	random_click_event_timer = 0
	if Globals.gameState.random_click_event_clicked == 1:
		get_node("%EventLog").add_event("Nice Catch! You got " + amount.toAA() + " computations!")
		yield(get_tree().create_timer(30), "timeout")
		get_node("%EventLog").add_event("Tip: You get a bonus for catching smaller Neural Nets", true, "res://images/star.png")
	else:
		get_node("%EventLog").add_event("You got " + amount.toAA() + " computations " + "with a x" + str(multi) + " bonus!")


func _on_Tiers_notification() -> void:
#	get_node("%computers_button/notification").visible = true
	get_node("%computers_button").notif_on()


func _on_Upgrades_notification() -> void:
#	get_node("%upgrades_button/notification").visible = true
	get_node("%upgrades_button").notif_on()


func _on_HeadlinesTimer_timeout() -> void:
	if Constants.headlines.size() >= 1:
# warning-ignore:narrowing_conversion
		var eventText = Constants.headlines.pop_at(rand_range(0, Constants.headlines.size()-1))
		get_node("%EventLog").add_event("News: " + eventText, false, "res://images/1x/barsHorizontal.png")


func _on_Options_Toggle_Particles(button_pressed) -> void:
	get_node("%ParticleContainer").visible = button_pressed


func _on_StatsMenu_popup(popup_data) -> void:
	get_node("%Popup").update_content(popup_data)
	get_node("%Popup").popup()


func _on_EventLog_openLog() -> void:
	hide_menus()


func _on_Achievements_rewardGot() -> void:
	get_node("%Fireworks").play()
