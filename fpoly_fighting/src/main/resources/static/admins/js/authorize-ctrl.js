app.controller( "authorize-ctrl" , function( $scope , $http ){
	$scope.roles = []
	$scope.staffs = []
	$scope.countResult = []
	$scope.initialize = function(){
		$scope.loadAll()
	}
	$scope.loadAll = function(){
		$http.get( "/rest/roles" ).then( resp => {
			$scope.roles = resp.data
			$scope.roles.splice( 0 , 1 )
			$http.get( "/rest/staffs" ).then( resp => {
				$scope.staffs = resp.data
				$scope.count()
			} )
		} )
	}
	$scope.updateRole = function( staff , roleId ){
		staff.role.id = roleId
		if( staff.id == $scope.loggedInStaff.id ) return alert( s + "Bạn không được tự cập nhật vai trò cho mình!" )
		$http.put( `/rest/staffs/${ staff.id }` , staff ).then( resp => {
			$scope.loadAll()
			alert( "Cập nhật thành công!" )
		} ).catch( error => {
			alert( "Cập nhật thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.count = function(){
		const staffs = $scope.staffs
		const roles = $scope.roles
		$scope.countResult = []
		for( let i = 0 ; i < roles.length ; i ++ ){
			const roleId = roles[ i ].id
			$scope.countResult[ roleId ] = 0
		}
		for( let i = 0 ; i < staffs.length ; i ++ ){
			const staff = staffs[ i ]
			const roleId = staff.role.id
			if( $scope.countResult[ roleId ] == undefined ){
				$scope.countResult[ roleId ] = 1
				continue
			}
			$scope.countResult[ roleId ] += 1
		}
	}
	$scope.initialize()
} )