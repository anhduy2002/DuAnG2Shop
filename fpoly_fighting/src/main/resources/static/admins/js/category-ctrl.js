app.controller( "category-ctrl" , function( $scope , $http ){
	$scope.items = []
	$scope.form = { id : "" , name : "" , imageName : "" , slug : "" , isDeleted : false }
	$scope.propertyName = "id"
	$scope.initialize = function(){
		$scope.loadAll()
	}
	$scope.edit = function( item ){
		$scope.form = angular.copy( item )
		$scope.form.name = item.name
		document.getElementById( "nav-tab-edit" ).click()
	}
	$scope.create = function(){
		const item = angular.copy( $scope.form )
		const s = "Thêm mới loại sản phẩm thất bại.\n"
		if( item.name == "" || item.name.length > 50 ) return alert( s + "Tên loại sản phẩm phải từ 1 đến 50 ký tự!" )
		if( item.slug == "" || item.slug.length > 255 ) return alert( s + "Slug phải từ 1 đến 255 ký tự!" )
		$http.post( "/rest/categories" , item ).then( resp => {
			$scope.loadAll()
			alert( "Thêm mới loại sản phẩm thành công!" )
			$scope.reset()
			document.getElementById( "nav-tab-list" ).click()
		} ).catch( error => {
			alert( "Thêm mới loại sản phẩm thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.update = function(){
		const item = angular.copy( $scope.form )
		const s = "Cập nhật loại sản phẩm thất bại.\n"
		if( item.id == "" ) return alert( s + "Vui lòng chọn 1 loại sản phẩm từ danh sách!" )
		if( item.name == "" || item.name.length > 50 ) return alert( s + "Tên loại sản phẩm phải từ 1 đến 50 ký tự!" )
		if( item.slug == "" || item.slug.length > 255 ) return alert( s + "Slug phải từ 1 đến 255 ký tự!" )
		$http.put( `/rest/categories/${ item.id }` , item ).then( resp => {
			$scope.loadAll()
			alert( "Cập nhật loại sản phẩm thành công!" )
			$scope.reset()
			document.getElementById( "nav-tab-list" ).click()
		} ).catch( error => {
			alert( "Cập nhật loại sản phẩm thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.delete = function(){
		const item = angular.copy( $scope.form )
		if( item.id == "" ) return alert( "Xóa loại sản phẩm thất bại.\nVui lòng chọn 1 loại sản phẩm từ danh sách!" )
		$http.delete( `/rest/categories/${item.id}` ).then( resp => {
			$scope.loadAll()
			alert( "Xóa loại sản phẩm thành công!" )
			$scope.reset()
			document.getElementById( "nav-tab-list" ).click()
		} ).catch( error => {
			alert( "Xóa loại sản phẩm thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.reset = function(){
		$scope.form = { id : "" , name : "" , imageName : "" , slug : "" , isDeleted : false }
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
		$http.get( "/rest/categories" ).then( resp => {
			$scope.items = resp.data
		} )
	}
	$scope.imageChanged = function( files ){
		const data = new FormData()
		data.append( "file" , files[ 0 ] )
		$http.post( "/rest/upload/images/categories" , data , {
			transformRequest: angular.identity() ,
			headers: { "Content-Type" : undefined } 
		} ).then( resp => {
			$scope.form.imageName = resp.data.name
		} ).catch( error => {
			alert( "Không thể tải lên ảnh!" )
			console.log( "error" , error )
		} ) 
	}
	$scope.initialize()
} )