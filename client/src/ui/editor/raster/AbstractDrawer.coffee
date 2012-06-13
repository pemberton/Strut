define(() ->
	class AbstractDrawer
		applyTransforms: (component, bbox) ->
			rotation = component.get("rotate")
			@g2d.translate(bbox.width/2 + bbox.x, bbox.height/2 + bbox.y)

			if rotation?
				@g2d.rotate(rotation)

			scale = component.get("scale")
			if scale?
				@g2d.scale(scale, scale)

			skewX = component.get("skewX")
			skewY = component.get("skewY")
			if skewX or skewY
				transform = [1,0,0,1,0,0]
				if skewX
					transform[2] = skewX
				if skewY
					transform[1] = skewY
				@g2d.transform.apply(@g2d, transform)
			
			@g2d.translate(-1 * (bbox.width/2 + bbox.x), -1 * (bbox.height/2 + bbox.y))
)