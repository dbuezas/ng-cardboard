π = Math.PI
angular.module('ngCardboard')
.directive 'vrImage', (THREE)->
	scope: 
		height: '='	
		width: '='	
		texture: '@'
	restrict: 'E'
	require: ['^vrScene', '?^vrContainer']
	link: ($scope, element, attribs, [vrScene, parentVrContainer])->
		#todo: react to scoope changes
		texture = THREE.ImageUtils.loadTexture $scope.texture
		material = new THREE.MeshBasicMaterial
			map: texture
			overdraw: yes
			transparent: yes
		
		material.side = THREE.DoubleSide
		
		geometry = new THREE.PlaneBufferGeometry( $scope.width, $scope.height );
		mesh = new THREE.Mesh geometry, material

		if parentVrContainer?
			parentVrContainer.object3d.add mesh
		else
			vrScene.scene.add mesh
		