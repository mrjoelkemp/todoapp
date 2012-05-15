class @Todo
	constructor: (id, rank, text) ->
		@id = id
		@rank = rank
		@text = text

	save: () ->
		# TODO: Pushes the current item to local storage
		# Create a JS object and convert to a string
		# Key = id; value = JS object representing this todo item
		