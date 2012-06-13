###
@author Matt Crinklaw-Vogt
###
define(["../components/ThreeDRotableComponentView",
		"../Templates",
		"../raster/SlideDrawer"
		"css!../res/css/TransitionSlideSnapshot.css"],
(ThreeDComponentView, Templates, SlideDrawer, empty) ->
	ThreeDComponentView.extend(
		className: "component transitionSlideSnapshot"
		events: () ->
			parentEvents = ThreeDComponentView.prototype.events()
			_.extend(parentEvents,
				"click": "clicked"
			)
		initialize: () ->
			ThreeDComponentView.prototype.initialize.apply(@, arguments)

		remove: () ->
			ThreeDComponentView.prototype.remove.call(@, true)
			if @slideDrawer?
				@slideDrawer.dispose()
			@model.set("selected", false)

		clicked: () ->
			ThreeDComponentView.prototype.clicked.apply(this, arguments)
			@model.set("active", true)

		render: () ->
			ThreeDComponentView.prototype.render.apply(@, arguments)
			if @slideDrawer?
				@slideDrawer.dispose()
			g2d = @$el.find("canvas")[0].getContext("2d")
			@slideDrawer = new SlideDrawer(@model, g2d)
			@slideDrawer.repaint()

			@$el.css({
				left: @model.get("x")
				top: @model.get("y")
			})

			@$el.find(".smartspinner[data-name='depth']").spinit(
				callback: (val) =>
					@model.set("z", -1*val) # can't do -val, uglify screws it up
				mask: "Depth"
				height: 22
				width: 45
				min: -9000
				max: 9000
				stepInc: 125
				initValue: @model.get("z")
			)

			@$el.find(".smartspinner[data-name='scale']").spinit(
				callback: (val) =>
					@model.set("impScale", val)
				mask: "Scale"
				min: 1
				max: 10
				height: 22
				width: 45
				initValue: @model.get("impScale")
			)

			@$el

		__getTemplate: () ->
			Templates.TransitionSlideSnapshot

		constructor: `function TransitionSlideSnapshot() {
			ThreeDComponentView.prototype.constructor.apply(this, arguments);
		}`
	)
)