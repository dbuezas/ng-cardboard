
angular.module('ngCardboard')
.directive 'vrSound', (vrAudio, THREE)->
	scope: 
		file: '@'
		playing: '='
	restrict: 'E'
	require: ['^vrScene', '?^vrContainer']
	link: ($scope, element, attribs, [vrScene, parentVrContainer])->
		
		sound = vrAudio.loadSound($scope.file)
		
		# better keep with omnidirectional for now
		# innerAngle = 1.0
		# outerAngle = 3.8
		# outerGain = 0.1
		# @sound.panner.coneInnerAngle = innerAngle * 180 / Math.PI
		# @sound.panner.coneOuterAngle = outerAngle * 180 / Math.PI
		# @sound.panner.coneOuterGain = outerGain
		$scope.$watch 'playing', (newV, oldV)->
			if newV
				sound.start()
			else
				sound.stop()

		tmpMatrix = new THREE.Matrix4()
		tmpVector = new THREE.Vector3()

		offUpdate = vrScene.$on 'update', (e, dt) ->
			return unless $scope.playing
			vrAudio.setListenerPosition vrScene.camera
			tmpMatrix.getInverse(vrScene.camera.matrixWorld)
			tmpMatrix.multiply parentVrContainer.object3d.matrixWorld
			
			tmpVector.setFromMatrixPosition(tmpMatrix)
			sound.panner.setPosition tmpVector.x, tmpVector.y, tmpVector.z

		$scope.$on '$destroy', ->
			vrAudio.destroy(sound)

			sound = null
			tmpEuler = null
			tmpVector = null
			offUpdate()

.factory 'vrAudio', (THREE, $window)->
	# setup audio context
	audio = {}
	window.AudioContext = window.AudioContext or window.webkitAudioContext
	audio.context = new AudioContext()
	audio.convolver = audio.context.createConvolver()
	audio.volume = audio.context.createGain()
	audio.mixer = audio.context.createGain()
	audio.flatGain = audio.context.createGain()
	audio.convolverGain = audio.context.createGain()
	audio.destination = audio.mixer
	audio.mixer.connect audio.flatGain
	
	#audio.mixer.connect(audio.convolver);
	audio.convolver.connect audio.convolverGain
	audio.flatGain.connect audio.volume
	audio.convolverGain.connect audio.volume
	audio.volume.connect audio.context.destination

	loadBuffer = (soundFileName, callback) ->
		request = new XMLHttpRequest()
		request.open "GET", soundFileName, true
		request.responseType = "arraybuffer"
		ctx = audio.context
		request.onload = ->
			ctx.decodeAudioData request.response, callback, ->
				alert "Decoding the audio buffer failed"
				return
			return
		request.send()

	loadSound = (soundFileName) ->
		ctx = audio.context
		sound = {}
		sound.source = ctx.createBufferSource()
		sound.source.loop = true
		sound.panner = ctx.createPanner()
		sound.volume = ctx.createGain()
		sound.source.connect sound.volume
		sound.volume.connect sound.panner
		sound.start = ()-> 
			sound.panner.connect audio.destination
			
		sound.stop = ()-> 
			sound.panner.disconnect()
			
		loadBuffer soundFileName, (buffer) ->
			sound.source.buffer = buffer
			sound.source.start( ctx.currentTime + 0.020 )

		return sound
	

	tmpVector1 = new THREE.Vector3()
	tmpVector2 = new THREE.Vector3()
	setListenerPosition = (camera) ->
		tmpVector1.setFromMatrixPosition camera.matrixWorld
		audio.context.listener.setPosition tmpVector1.x, tmpVector1.y, tmpVector1.z

		tmpVector1.set(0, 0, 1)
		m = camera.matrix
		mx = m.elements[12]
		my = m.elements[13]
		mz = m.elements[14]
		m.elements[12] = m.elements[13] = m.elements[14] = 0
		tmpVector1.applyProjection m
		tmpVector1.normalize()
		tmpVector2.set(0, -1, 0)
		tmpVector2.applyProjection m
		tmpVector2.normalize()
		audio.context.listener.setOrientation tmpVector1.x, tmpVector1.y, tmpVector1.z, tmpVector2.x, tmpVector2.y, tmpVector2.z
		m.elements[12] = mx
		m.elements[13] = my
		m.elements[14] = mz

	destroy = (sound)->
		sound.source.disconnect()
		sound.volume.disconnect()
		sound.panner.disconnect()
	return {
		destroy: destroy
		loadBuffer: loadBuffer
		loadSound: loadSound
		setListenerPosition: setListenerPosition
	}