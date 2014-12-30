angular.module('ngCardboard')
.directive 'vrScene', ($window, THREE, $timeout, Modernizr)->
	scope: {
		update: '&'
		stereoscopic: '='
		eyeDistance: '=' 
	}
	restrict: 'E'
	transclude: yes
	template: '
		<mirror-1 style="position: absolute; top: 0;left: 0;right: 50%;bottom: 0;-webkit-box-reflect: right 200%;transform: translateZ(0);-webkit-transform: translateZ(0);">
			<mirror-2-and-fov style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; -webkit-box-reflect: right 100%">
				<css-3d-camera style="position: absolute" ng-transclude>
				</css-3d-camera>
			</mirror-2>
		</mirror-1>'
	controller: ($scope, $element)->
		# TODO: review controller vs link vs compile semantic and put code where it belongs
		@$on = $scope.$on.bind($scope)
		@$emit = $scope.$emit.bind($scope)
		@renderer = new THREE.WebGLRenderer()
		@stereoRenderer = new THREE.StereoEffect(@renderer)
		@scene = new THREE.Scene()

		# @camera will be set by the vr-camera
		# it feels like the camera should be in a service, but it can't be a singleton as
		# there might be more that one scene in an app
		@camera = null 
		@setCssStereoscopy = angular.noop # replaced in link function
	link: ($scope, element, attribs, vrScene)->
		mirror1 = element.find('mirror-1')
		mirror2AndFov = element.find('mirror-2-and-fov')

		cssCamera = element.find('css-3d-camera')
		vrScene.cssRenderer = new THREE.CSS3DRenderer(mirror2AndFov[0],cssCamera[0])

		element.prepend vrScene.renderer.domElement
			
		clock = new THREE.Clock()
		destroyed = no
		animate = ()->
			return if destroyed
			requestAnimationFrame animate
			dt = clock.getDelta()
			t = clock.getElapsedTime()
			vrScene.$emit 'update', dt, t
			vrScene.$emit 'render', dt, t
		$timeout -> animate()

		vrScene.$on 'update', (e, dt, t)->
			$scope.update(dt:dt, t: t)
			vrScene.stereoRenderer.separation = $scope.eyeDistance/2 or 1
			# Unless we use one cssRenderer per vr-dom element, we can't do any perspective correction for each eye.
			# If that were needed, we could do:
			# mirror2AndFov.css
			# 	'-webkit-box-reflect': 'right '+ proportional_translation_of_vrDom_for_right_eye + '%'			

		offRender = vrScene.$on 'render', (e, dt)->
			renderer = if $scope.stereoscopic then vrScene.stereoRenderer else vrScene.renderer
			renderer.render vrScene.scene, vrScene.camera
			vrScene.cssRenderer.render vrScene.scene, vrScene.camera

		windowResize = ()->
			width = element[0].offsetWidth
			height = element[0].offsetHeight
			$scope.$emit 'resize', {width: width, height: height}
		
		$timeout -> windowResize()
		
		angular.element($window).on 'resize', windowResize

		offResize = vrScene.$on 'resize', (e, size)->
			vrScene.renderer.setSize size.width, size.height
			vrScene.stereoRenderer.setSize size.width, size.height
			cssWidth = if $scope.stereoscopic then size.width/2 else size.width
			vrScene.cssRenderer.setSize cssWidth, size.height

		$scope.$watch 'stereoscopic', (stereoscopic, oldValue)->
			return unless stereoscopic isnt oldValue
			mirror1.css 
				'-webkit-box-reflect': if stereoscopic then 'right 200%' else 'none'
				'right': if stereoscopic then '50%' else '0'
			mirror2AndFov.css
				'-webkit-box-reflect': if stereoscopic then 'right 100%' else 'none'
			windowResize()

		vrScene.$on '$destroy', ->
			angular.element($window).off 'resize', windowResize
			offResize()
			offRender()
			destroyed = yes
			clock = null
			vrScene.renderer = null 
			vrScene.stereoRenderer = null
			vrScene.cssRenderer = null
			for obj in $scope.scene.children
				obj?.geometry?.dispose();
				obj?.material?.dispose();
				$scope.scene.remove obj
			$scope.scene = null
