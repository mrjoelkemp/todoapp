$ ->
	console.log("in todoapp")
	
	$("#tasks").sortable()

	# Load tasks 

	ids = Object.keys(localStorage)
	console.log("ids", ids)


	# On enter press, grab the text in todoText input
