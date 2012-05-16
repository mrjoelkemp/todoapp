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
	objs = _.map(tasks, (taskObj) ->
		return create(taskObj.id, taskObj.rank, taskObj.text)
	)

	ranked_objs = _.sortBy(objs, (o) -> return o.data("rank"))
	appendTasksToTaskList(ranked_objs)

create = (id, rank, text) ->
	# Purpose: 	Creates a Jquery obj representing the task, adds it to the UI, 
	#			and persists if necessary
	# Notes:	Doing all of this here for ease.
	# Create li 
	task = $("<li></li>").clone()
	task.data("id", id)
		.data("rank", rank)
		.html(text)
		.addClass("task")
		# On double-click, delete items
		.dblclick(() -> 
			this.remove()
		)

	# DEBUG: colors for rank
	colorClasses = ["green", "red", "blue", "black", "green", "red", "blue", "black"]
	task.addClass(colorClasses[rank % colorClasses.length])

	return task


dblClickHandler: (task) ->
	

appendTasksToTaskList = (tasks) ->
	# Append each element of the list to the task list
	_.each(tasks, (t) -> appendToTaskList(t))

appendToTaskList = (task) ->
	# Add task to the list of tasks
	task.appendTo("#tasks")

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
	# New ids auto increment
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
		return 0

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

getTopNeighborRank = (id) ->
	# Purpose: 	Gets the rank of the task above the task with the passed id
	# Note:		This is known as a "top neighbor"

	# Get neighboring tasks
	tasks = getTasksFromUI()

	# Change task rank to that of its new top neighbor
	# Find the top neighbor, the one right before task in the list of children
	neighborRank = 0
	for i in [0 ... tasks.length]
		top_neighbor = tasks[i + 1].data("id") == id
		if top_neighbor
			neighborRank = tasks[i].data("rank")
			
	return neighborRank

getTopNeighbors = (rank, tasks) ->
	# Find top neighbors (tasks with a lower or equal rank)
	tops = _.filter(tasks, (t) -> return t.data("rank") <= rank)
	return tops

getBottomNeighbors = (rank, tasks) ->
	# Find top neighbors (tasks with a larger rank)
	bottoms = _.filter(tasks, (t) -> return t.data("rank") > rank)
	return bottoms

modifyNeighborRanks = (tasks, offset) ->
	# Purpose: 	Either increases or decreases the ranks of the passed tasks by the offset
	_.each(tasks, (t) -> t.data("rank", t.data("rank") - offset))

sortStopHandler = (e, ui) ->
	# Purpose: 	Handles the sort stop event for a dragged task
	# Once the task is in its new place,
	#	get the rank of the top neighbor
	#	change the current task's rank
	#	change the top neighbors' ranks since they've moved up
	
	# Get the dragged item
	draggedTask = $(ui.item)
	taskRank = draggedTask.data("rank")
	taskId = draggedTask.data("id")

	# Get neighboring tasks
	tasks = getTasksFromUI()

	# Change task rank to that of its new top neighbor
	newRank = getTopNeighborRank(taskId)
	draggedTask.data("rank", newRank)

	# Exclude dragged task
	tasks = _.reject(tasks, (t) -> t.data("id") is taskId)

	# Find top neighbors (tasks with a lower rank)
	# Note: we haven't changed the task that has our new rank, so <=
	tops = getTopNeighbors(newRank, tasks)

	# Move the top neighbors' ranks higher
	modifyNeighborRanks(tops, -1)

	# Save all tasks
	store(draggedTask)
	_.each(tops, (t) -> store(t))

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
