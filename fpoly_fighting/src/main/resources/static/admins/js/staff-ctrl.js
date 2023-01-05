app.controller( "staff-ctrl" , function( $scope , $http ){
	$scope.items = []
	$scope.roles = []
	$scope.defaultRole = {}
	$scope.form = { 
		id : "" , 
		username : "" ,
		fullname : "" , 
		email : "" , 
		phone : "" , 
		address : "" , 
		createdDate : '' , 
		isDeleted : false , 
		isEnabled : false ,
		role : {}
	}
	$scope.propertyName = "id"
	$scope.initialize = function(){
		$scope.loadAll()
		$http.get( "/rest/roles" ).then( resp => {
			$scope.roles = resp.data
			$scope.roles.splice( 0 , 1 )
			$scope.defaultRole = $scope.roles[0]
			$scope.form.role = $scope.defaultRole
		} )
	}
	$scope.edit = function( item ){
		$scope.form = angular.copy( item )
		document.getElementById( "nav-tab-edit" ).click()
	}
	$scope.create = function(){
		const item = angular.copy( $scope.form )
		const s = "Thêm mới nhân viên thất bại.\n"
		if( item.fullname.trim().length < 3 || item.fullname.trim().length > 50 ) return alert( s + "Họ và tên phải từ 3 đến 50 ký tự!" )
		if( item.username.trim().length < 3 || item.username.trim().length > 50 ) return alert( s + "Tên đăng nhập phải từ 3 đến 50 ký tự!" )
		if( item.phone.trim().length < 9 || item.phone.trim().length > 11 ) return alert( s + "Số điện thoại phải từ 9 đến 11 ký tự số!" )
		if( !validateEmail( item.email ) || item.email.trim().length > 100 ) return alert( s + "Email phải phải hợp lệ và có tối đa 100 ký tự!" )
		if( item.address.trim().length < 5 || item.address.trim().length > 250 ) return alert( s + "Địa chỉ phải từ 5 đến 250 ký tự!" )
		$http.post( "/rest/staffs/" , item ).then( resp => {
			$scope.loadAll()
			alert( "Thêm mới nhân viên thành công!" )
			$scope.reset()
			document.getElementById( "nav-tab-list" ).click()
		} ).catch( error => {
			alert( "Thêm mới nhân viên thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.update = function(){
		const item = angular.copy( $scope.form )
		const s = "Cập nhật nhân viên thất bại.\n"
		if( item.id == "" ) return alert( s + "Vui lòng chọn 1 nhân viên từ danh sách!" )
		$http.put( `/rest/staffs/${ item.id }` , item ).then( resp => {
			$scope.loadAll()
			alert( "Cập nhật nhân viên thành công!" )
			$scope.reset()
			document.getElementById( "nav-tab-list" ).click()
		} ).catch( error => {
			alert( "Cập nhật nhân viên thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.delete = function(){
		const item = angular.copy( $scope.form )
		const s = "Xóa nhân viên thất bại.\n"
		if( item.id == "" ) return alert( s + "Vui lòng chọn 1 nhân viên từ danh sách!" )
		if( item.id == $scope.loggedInStaff.id ) return alert( s + "Bạn không được tự xóa chính mình!" )
		$http.delete( `/rest/staffs/${item.id}` ).then( resp => {
			$scope.loadAll()
			alert( "Xóa nhân viên thành công!" )
			$scope.reset()
			document.getElementById( "nav-tab-list" ).click()
		} ).catch( error => {
			alert( "Xóa nhân viên thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.reset = function(){
		$scope.form = { 
			id : "" , 
			username : "" ,
			fullname : "" , 
			email : "" , 
			phone : "" , 
			address : "" , 
			createdDate : '' , 
			isDeleted : false , 
			isEnabled : false ,
			role : $scope.defaultRole
		}
	}
	$scope.pager = {
		page : 1 ,
		size : 10 ,
		get items(){
			const start = this.page * this.size
			return $scope.items.slice( start , start + this.size )
		} ,
		get count(){
			return Math.ceil( $scope.items.length / this.size )
		} ,
		first(){
			this.page = 1
		} ,
		prev(){
			this.page > 1 ? this.page -- : 1
		} ,
		next(){
			this.page < this.count ? this.page ++ : this.count
		} ,
		last(){
			this.page = this.count
		} ,
		isInCurrentPage( id ){
			return ( ( id >= ( this.page - 1 ) * this.size ) && ( id < this.page * this.size ) )
		}
	}
	$scope.sortBy = function( propertyName ) {
	    $scope.reverse = ( $scope.propertyName === propertyName ) ? !$scope.reverse : false;
	    $scope.propertyName = propertyName;
	}
	$scope.loadAll = function() {
		$http.get( "/rest/staffs" ).then( resp => {
			$scope.items = resp.data
		} )
	}
	$scope.initialize()
} )