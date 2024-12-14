extends Node

var draggingid = null
var state = "main"
var allIconTypes = ["Box", "Heart", "Snowflake", "Tree", "Water", "Wheat", "Snake", "Dot", "Pot"]
var iconTypes = ["icon"]
var iconQueue = []
var paused = false
var orders = -1
