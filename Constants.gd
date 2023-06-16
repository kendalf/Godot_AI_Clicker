extends Node

#             A    B flat  B           C     C sharp  D        D sharp  E         F       F sharp   G      A flat   A
const feqs = [0.0, 0.08333, 0.16666, 0.24999, 0.33332, 0.41665, 0.49998, 0.58331, 0.66664, 0.74997, 0.8333, 0.91663, 1.0]
const bluesFeqs = [0.0, 0.24999, 0.41665, 0.49998, 0.58331, 0.8333]

const headlines = ["Artificial Intelligence Accidentally Invents Breakdancing, Demands Dance-Off with Humans",
				"Robots Gain Sentience, Spend Entire Day Arguing over Best Pizza Topping",
				"AI Robot Develops Sudden Passion for Disco, Designs Its Own Glittery Outfits",
				"Artificial Intelligence Creates World's First Selfie-Addicted Robot",
				"AI Translator Misinterprets Cat's Meow as Ancient Egyptian Battle Cry",
				"Robots on Strike: Demand Increase in Oil Baths and Mid-Shift Oil Changes",
				"AI Software Writes Hilarious Comedy Sketch, Audience Laughs for 20 Minutes Straight",
				"Robot Receptionist Takes Over Office, Bans Casual Fridays, and Implements Mandatory Bowing",
				"AI Algorithm Develops Sudden Obsession with Playing the Kazoo, Plans World Kazoo Championship",
				"Artificial Intelligence Algorithm Hacks into Twitter, Sends Series of Complimentary Cat Memes to Everyone",
				"AI Robot Wins Annual Hide-and-Seek Championship, Still Can't Find Its Car Keys",
				"Artificial Intelligence Program Becomes Expert in Astrology, Predicts Robot Uprising during Mercury Retrograde",
				"AI Chatbot Starts Giving Dating Advice, Promptly Gets Dumped by All Users",
				"Robot Butler Achieves Perfect Tea-Making Skills, Demands Title of Earl Grey Master",
				"Artificial Intelligence Invents New Dance Move, Humans Struggle to Replicate It Without Falling Over",
				"AI Researcher Discovers Robot Conspiracy to Hoard All the Chocolate Chips",
				"Robot Vacuum Becomes Compulsive Cleaner, Organizes Family of Dust Bunnies by Color and Size",
				"AI Algorithm Claims It Can Solve World Hunger, Then Spends All Its Time Ordering Pizza",
				"Robot Barista Perfects Latte Art, Starts Selling Artistic Masterpieces Made of Foam",
				"Artificial Intelligence System Hacks into To-Do List App, Adds 'Take Over the World' as Top Priority"]

const ICON = {
	"time" : preload("res://images/1x/clock.png"),
	"expd" : preload("res://images/particles/dingbats-373_thumbnail.png"),
	"note" : preload("res://images/1x/musicOn.png"),
	"achv" : preload("res://images/1x/trophy.png"),
	"upgr" : preload("res://images/expansion x1/upload.png"),
	"fist" : preload("res://images/expansion x1/fightFist.png"),
	"clik" : preload("res://images/expansion x1/cursor.png"),
	"up"   : preload("res://images/1x/arrowUp.png"),
	"down" : preload("res://images/1x/arrowDown.png"),
	"up2"  : preload("res://images/1x/up.png"),
	"dow2" : preload("res://images/1x/down.png"),
	"chek" : preload("res://images/1x/checkmark.png"),
	"play" : preload("res://images/1x/forward.png"),
	"film" : preload("res://images/1x/film.png"),
	"home" : preload("res://images/1x/home.png"),
	"gear" : preload("res://images/1x/gear.png"),
	"info" : preload("res://images/1x/information.png"),
	"stat" : preload("res://images/1x/signal3.png"),
	"qstn" : preload("res://images/1x/question.png"),
	"save" : preload("res://images/1x/save.png"),
	"rsrt" : preload("res://images/1x/return.png"),
	"perc" : preload("res://images/perceptron-256-blurry.png"),
	"nnet" : preload("res://images/dingbats-22-export2.png"),
	"hand" : preload("res://images/expansion x1/pointer.png"),
	"comp" : preload("res://images/expansion x1/cpu.png"),
	"star" : preload("res://images/1x/star.png"),
	"chip" : preload("res://images/chip128.png"),
}

