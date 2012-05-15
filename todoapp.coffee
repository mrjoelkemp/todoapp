$ ->
	$("#tasks").sortable()

	# Load tasks 

	ids = Object.keys(localStorage)
	console.log("ids", ids)