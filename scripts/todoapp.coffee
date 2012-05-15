$ ->
	console.log("in todoapp")

	$("#tasks").sortable()
		
	# Load tasks 
	#loadTasks()
	
	# On enter press, grab the text in todoText input
	textfield = $("#todotext")
	
	$("#todotext").keydown( (e) ->
		enterPressed = e.keyCode is 13
		if enterPressed
        	# Pull the text from the textfield
        	text = $("#todotext")[0].value
        	console.log("Task: " + text)
        	isBlank = text is ""

        	if not isBlank
	        	# Reset the textfield
	        	$("#todotext")[0].value = ""

	        	# Create task with submitted text
	        	id = getNewId()
	        	rank = getNewRank()
	        	create(id, rank, text)
    )

loadTasks = () ->
# Precond: 	Task Structure = id, rank, text
# Notes:	Since local storage only uses strings, we have to parse into a JS object
	if not tasksExist()
		return

	# Show the title
	$("#taskList #title").show()

	ids = Object.keys(localStorage)

	# Grab the task objects associated with the ids
	tasks = _.map(ids, (id) ->
		taskString = localStorage.getItem(id)
		taskObj = JSON.parse(taskString)
		return taskObj
	)

	# Recreate the task
	_.each(tasks, (taskObj) ->
		create(taskObj.id, taskObj.rank, taskObj.text)
	)

create = (id, rank, text) ->
# Purpose: 	Creates a Jquery obj representing the task, adds it to the UI, and persists if necessary
# Notes:	Doing all of this here 
	# Create li 
	task = $("<li></li>").clone()
	task.data("id", id)
	task.data("rank", rank)
	task.html(text)
	
	# Add task to the list of tasks
	task.appendTo("#tasks")

	# Persist, if necessary
	store(task)

store = (taskJSON) ->
# Purpose: 	Persists the string representation of the passed obj to local storage
# Precond: 	Takes in a JSON obj representing the string
	id = taskJSON.id
	task = JSON.stringify(taskJSON)
	localStorage.setItem(id, task)

taskToObject = (task) ->
# Precond: 	Takes in a Jquery obj representing the task
# Notes:	We'll look at the hidden data to populate the object
	json = "id": task.data("id")
		"rank": task.data("rank")
		"text": task.data("text")
	return json

# Helpers
getNewId = () ->
	return getLargestId() + 1

getLargestId = () ->
	if taskListEmpty
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
	return _.isEmpty(tasks)

getTasksFromUI = () ->
	return $("#tasks").children()

tasksExist = () ->
	ids = Object.keys(localStorage)
	if not _.isEmpty(ids)
		return true
	else
		return false

