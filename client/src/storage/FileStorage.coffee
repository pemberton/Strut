define([],
() ->
	class FileStorage
		constructor: () ->
			@storageImpl = localStorage

		fileNames: () ->
			numFiles = @storageImpl.length
			idx = 0
			fileNames = []
			while idx < numFiles
				fileNames.push(localStorage.key(idx))
				++idx
			fileNames

		remove: (fileName) ->
			@storageImpl.removeItem(fileName)

		save: (fileName, contents) ->
			@storageImpl.setItem(fileName, JSON.stringify(contents))

		open: (fileName) ->
			JSON.parse(@storageImpl.getItem(fileName))

	new FileStorage()
)