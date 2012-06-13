###
@author Matt Crinklaw-Vot
###
define(["vendor/backbone",
		"./Templates",],
(Backbone, Templates) ->
	Backbone.View.extend(
		className: "rawTextImporter modal"
		events:
			"click .ok": "okClicked"

		initialize: () ->

		show: (cb, val) ->
			@cb = cb
			if val?
				@$txtArea.val(val)

			@$el.modal("show")

		okClicked: () ->
			if @cb?
				@cb(@$txtArea.val())
			@$el.modal("hide")

		render: () ->
			@$el.html(Templates.RawTextImporter())
			@$el.modal()
			@$el.modal("hide")
			@$txtArea = @$el.find("textarea")
			@$el
	)
)