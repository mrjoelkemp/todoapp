loadFromStorage = () ->
	# Precond: 	Task Structure = id, rank, text
	# Notes:	Since local storage only uses strings, 
	#			we have to parse into a JS object
	
	if not tasksExist()
		return 0

	# Show the title
	$("#taskList #title").show()

	ids = Object.keys(localStorage)

	# Grab the task objects associated with the ids
	tasks = _.map(ids, (id) ->
		taskString = localStorage.getItem(id)
		taskObj = JSON.parse(taskString)
		return taskObj
	)

	# Recreate the task and append to tasklist but don't persist
	# Get the json objects, sort by rank, add to task list
	_.each(tasks, (taskObj) ->
		create(taskObj.id, taskObj.rank, taskObj.text, false)
	)

create = (id, rank, text, persist) ->
	# Purpose: 	Creates a Jquery obj representing the task, adds it to the UI, 
	#			and persists if necessary
	# Notes:	Doing all of this here for ease.
	# Create li 
	task = $("<li></li>").clone()
	task.data("id", id)
		.data("rank", rank)
		.html(text)
		.addClass("task")
	
	# Add task to the list of tasks
	task.appendTo("#tasks")

	# Persist, if necessary
	if persist
		taskObj = taskToObject(task)
		store(taskObj)

	return task

store = (task) ->
	# Purpose: 	Persists the string representation of the passed obj to local storage
	taskJSON = taskToObject(task)
	id = taskJSON.id
	task = JSON.stringify(taskJSON)
	localStorage.setItem(id, task)

taskToObject = (task) ->
	# Precond: 	Takes in a Jquery obj representing the task
	# Notes:	We'll look at the hidden data to populate the object
	json = 
		"id": task.data("id"),
		"rank": task.data("rank"),
		"text": task.html()
	return json

# Helpers
getNewId = () ->
	return getLargestId() + 1

getLargestId = () ->
	if taskListEmpty()
		return -1

	tasks = getTasksFromUI()
	ids = _.map(tasks, (task) ->
		return task.data("id")
	)
	largest = _.max(ids)
	return largest

getNewRank = () ->
	# Purpose:	Generates a rank for a new task
	# Notes:	New tasks are ranked last
	
	if taskListEmpty()
		return 1

	# Extract the ranks from the children
	tasks = getTasksFromUI()

	ranks = _.map(tasks, (task) ->
		return task.data("rank")
	)
	newRank = _.max(ranks) + 1
	return newRank

taskListEmpty = () ->
	# Purpose: 	Checks if the task list has tasks
	
	tasks = getTasksFromUI()
	isEmpty = tasks.length == 0
	return isEmpty

getTasksFromUI = () ->
	# Purpose: 	Grabs the li elements within the tasks ul
	# Returns: 	A list of Jquery objects containing the li elements
	children = $("#tasks").children()
	
	if children.length == 0
		return []

	# Convert the li elements to Jquery objects
	children = _.map(children, (c) ->
		return $(c)
	)
	return children

tasksExist = () ->
	ids = Object.keys(localStorage)
	if not _.isEmpty(ids)
		return true
	else
		return false

sortStopHandler = (e, ui) ->
	# Purpose: 	Handles the sort stop event
	
	# Get the dragged item
	item = $(ui.item)

	#Give my upper neighbor my old rank

$ ->
	$("#tasks").sortable()
				.bind("sortstop", (e, ui) -> sortStopHandler(e, ui))

	# On enter press, grab the text in todoText input
	$("#todotext").keydown( (e) ->
		enterPressed = e.keyCode is 13
		if enterPressed
        	# Pull the text from the textfield
        	text = $("#todotext")[0].value
        	isBlank = text is ""

        	if not isBlank
	        	# Reset the textfield
	        	$("#todotext")[0].value = ""

	        	# Create task with submitted text and persist
	        	id = getNewId()
	        	rank = getNewRank()
	        	create(id, rank, text, true)
    	)
	
	# Load tasks
	loadFromStorage()
