define(["vendor/Handlebars",
		"./Templates"],
(Handlebars, Templates) ->
	class ImpressRenderer
		constructor: () ->
			Handlebars.registerHelper("renderComponent", (componentModel) =>
				result = ""

				switch componentModel.get("type")
					when "ImageModel" then result = Templates.Image(componentModel.attributes)
					when "TextBox" then result = Templates
						.TextBox(@convertTextBoxData(componentModel.attributes))

				new Handlebars.SafeString(result)
			)


			Handlebars.registerHelper("scaleX", (x) ->
				x * slideConfig.size.width / 150 # TODO FIXME
			)

			Handlebars.registerHelper("scaleY", (y) ->
				y * slideConfig.size.width / 150 # TODO FIXME
			)

			Handlebars.registerHelper("toDeg", (v) ->
				v * 180 / Math.PI
			)

			Handlebars.registerHelper("extractBG", (styles) ->
				if styles? and styles.length > 0
					result = ""
					style = styles[0]
					browsers = [
						"-moz-",
						"-webkit-",
						"-o-",
						"-ms-",
						""
					]

					for prefix in browsers
						result += "background-image: " + prefix + style + "; "

					result
				else
					""
			)

			Handlebars.registerPartial("ComponentContainer", Templates.ComponentContainer)

		render: (deckAttrs) ->
			slides = deckAttrs.slides
			colCnt = 6
			cnt = 0
			# TODO FIXME
			slides.each((slide) =>
				x = slide.get("x")
				if not x?
					slide.set("x", cnt * 160 + 30)
					slide.set("y", ((cnt / colCnt) | 0) * 160 + 80)
				++cnt)
			result = Templates.ImpressTemplate(deckAttrs)
			result

		convertTextBoxData: (attrs) ->
			copy = _.extend({}, attrs)
			copy.text = new Handlebars.SafeString(attrs.text)
			copy

	new ImpressRenderer()
)