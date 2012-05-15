$ ->
	console.log("in todoapp")

	$("#tasks").sortable()
		
	# Load tasks 
	#loadTasks()
	
	# On enter press, grab the text in todoText input
	textfield = $("#todotext")
	
	$("#todotext").keydown( (e) ->
		code = e.keyCode
		if code is 13
        	# Pull the text from the textfield
        	taskText = $("#todotext")[0].value
        	# TODO: Create new task with pulled text
        	console.log('Enter key was pressed.')
        	console.log("Task: " + taskText)
    )
    
create = () ->
	#
	#Create li 

loadTasks = () ->
	ids = Object.keys(localStorage)
	console.log("ids", ids)
	if tasksExist()
		# Show the title
		$("#taskList #title").show()

		# For each key
			# Create a task

tasksExist = () ->
	ids = Object.keys(localStorage)
	if not _.isEmpty(ids)
		return true
	else
		return false

