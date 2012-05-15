$ ->
	console.log("in todoapp")
	
	$("#tasks").sortable()
		
	# Load tasks 
	#loadTasks()
	
	# On enter press, grab the text in todoText input
	$("#todotext").keydown( (e) ->
        code = e.keyCode
        console.log("Code pressed: " + code)
        if code == 13 or code == 10
        	console.log('Enter key was pressed.')
        e.preventDefault()
    )

loadTasks = () ->
	ids = Object.keys(localStorage)
	console.log("ids", ids)
	if not _.isEmpty(ids)
		# Show the title
		$("#taskList #title").show()

		# For each key
			# Create a task

tasks_exist = () ->
	ids = Object.keys(localStorage)
	if not _.isEmpty(ids)
		return true
	else
		return false

create = () ->
	#
	#Create li 