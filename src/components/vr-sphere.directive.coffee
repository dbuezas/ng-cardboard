angular.module('ngCardboard')
.directive 'vrSphere', (THREE)->
	scope: 
		radius: '='
		texture: '@'
	restrict: 'E'
	require: ['^vrScene', '?^vrContainer']
	link: ($scope, element, attribs, [vrScene, parentVrContainer])->
		material = new THREE.MeshBasicMaterial
			overdraw: true

		hSegments = vSegments = 32
		geometry = new THREE.SphereGeometry(1, hSegments, vSegments)
		mesh = new THREE.Mesh geometry, material
		$scope.$watch 'radius', (newV, oldV)->
			mesh.scale.set( newV, newV, newV ) # x is negative to make the sphere show the texture on its inside
		material.side = THREE.DoubleSide

		$scope.$watch 'texture', (newV, oldV)->
			texture = THREE.ImageUtils.loadTexture newV
			material.map = texture

		unless parentVrContainer?
			vrScene.scene.add mesh
		parentVrContainer?.object3d.add mesh
		$scope.$on '$destroy', ->
			parentVrContainer?.object3d.remove mesh
			mesh.geometry.dispose();
			mesh.material.dispose();
			vrScene.scene?.remove mesh
			material = null
			geometry = null
			mesh = null