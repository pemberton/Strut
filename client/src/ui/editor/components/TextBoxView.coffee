###
@author Tantaman
###
define(["./ComponentView",
		"../Templates"],
(ComponentView, Templates) ->
	styles = ["family", "size", "weight", "style", "color", "decoration", "align"]
	ComponentView.extend(
		className: "component textBox"
		tagName: "div"
		events: () ->
			parentEvents = ComponentView.prototype.events.call(@)
			myEvents = 
				"dblclick": "dblclicked"
				"editComplete": "editCompleted"
			_.extend(parentEvents, myEvents)

		initialize: () ->
			ComponentView.prototype.initialize.apply(@, arguments)
			for style in styles
				@model.on("change:" + style, @_styleChanged, @)
			#@model.on("change:style", @_styleChanged, @)

		dblclicked: (e) ->
			@$el.addClass("editable")
			@$el.find(".content").attr("contenteditable", true) #selectText()
			@allowDragging = false
			@editing = true

		editCompleted: () ->
			text = @$textEl.html()
			@editing = false
			if text is ""
				@remove()
			else
				console.log "ALLOWING DRAGGING"
				@model.set("text", text)
				@$el.find(".content").attr("contenteditable", false)
				@allowDragging = true

		_styleChanged: (model, style, opts) ->
			for key,value of opts.changes
				if value
					if key is "decoration" or key is "align"
						console.log "DECORATION CHANGE"
						key = "text" + key.substring(0,1).toUpperCase() + key.substr(1)
					else if key isnt "color"
						key = "font" + key.substr(0,1).toUpperCase() + key.substr(1)
					@$el.css(key, style)

		render: () ->
			ComponentView.prototype.render.call(@)
			@$textEl = @$el.find(".content")
			@$textEl.html(@model.get("text"))
			@$el.css({
				fontFamily: @model.get("family")
				fontSize: @model.get("size")
				fontWeight: @model.get("weight")
				fontStyle: @model.get("style")
				color: "#" + @model.get("color")
				top: @model.get("y")
				left: @model.get("x")
				textDecoration: @model.get("decoration")
				textAlign: @model.get("align")
			})

			@$el

		constructor: `function TextBoxView() {
			ComponentView.prototype.constructor.apply(this, arguments);
		}`
	)
)