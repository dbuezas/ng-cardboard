angular.module('ngCardboard', [
	'ngRoute'
]).config ($routeProvider,  $locationProvider) ->
	$routeProvider.when '/intro',
		templateUrl: 'app/intro/intro.html'

	$routeProvider.when '/vr',
		templateUrl: 'app/demo/demo.html'
	$routeProvider.otherwise redirectTo: '/intro'

.constant 'Modernizr', window.Modernizr
.constant 'THREE', window.THREE
.run ($window, $location, $rootScope, $document) ->

	# $location.path('/intro').replace()
	$location.path('/vr').replace()

	if /iPhone|iPad|iPod/i.test(navigator.userAgent)
		window.AudioContext = window.AudioContext or window.webkitAudioContext
		ctx = new AudioContext()
		window.AudioContext = -> ctx
		soundWarning = angular.element('<div style="color: white;position: absolute;text-align: center;top:0;left:0;right:0;">Berühren um Ton zu aktivieren</div>')
		angular.element(document.body).append(soundWarning)
		isUnlocked = false
		angular.element($document).on 'touchstart', ()->
			return if isUnlocked
			# create empty buffer and play it
			context = new AudioContext()
			buffer = context.createBuffer(1, 1, 22050)
			source = context.createBufferSource()
			source.buffer = buffer
			source.connect context.destination
			source.noteOn 0

			# by checking the play state after some time, we know if we're really unlocked
			setTimeout ->
				if source.playbackState is source.PLAYING_STATE or source.playbackState is source.FINISHED_STATE
					isUnlocked = true  
					soundWarning.remove()
			, 0

	$window.addEventListener 'orientationchange', ()->
		if /iPhone|iPad|iPod/i.test(navigator.userAgent)
			if window.orientation in [90, -90]
				$location.path('/vr').replace()
			else 
				$location.path('/intro').replace()
		else
			orientation = window.screen.orientation or window.screen.mozOrientation
			if orientation.type in ['landscape-primary', 'landscape-secondary']
				$location.path('/vr').replace()
			else 
				$location.path('/intro').replace()
		$rootScope.$apply()
	
