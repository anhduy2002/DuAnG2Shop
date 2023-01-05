app.controller( "order-status-ctrl" , function( $scope , $http ){
	$scope.items = []
	$scope.form = { id : "" , name : "" }
	$scope.propertyName = "id"
	$scope.initialize = function(){
		$scope.loadAll()
	}
	$scope.edit = function( item ){
		$scope.form = angular.copy( item )
		document.getElementById( "nav-tab-edit" ).click()
	}
	$scope.update = function(){
		const item = angular.copy( $scope.form )
		const s = "Cập nhật trạng thái đơn hàng thất bại.\n"
		if( item.id == "" ) return alert( s + "Vui lòng chọn 1 trạng thái đơn hàng từ danh sách!" )
		if( item.name == "" || item.name.length > 50 ) return alert( s + "Tên trạng thái đơn hàng phải từ 1 đến 50 ký tự!" )
		$http.put( `/rest/order-statuses/${item.id}` , item ).then( resp => {
			$scope.loadAll()
			alert( "Cập nhật trạng thái đơn hàng thành công!" )
			$scope.reset()
			document.getElementById( "nav-tab-list" ).click()
		} ).catch( error => {
			alert( s + "Tên trạng thái đơn hàng đã được sử dụng!" )
		} )
	}
	$scope.reset = function(){
		$scope.form = { id : "" , name : "" }
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
		$http.get( "/rest/order-statuses" ).then( resp => {
			$scope.items = resp.data
		} )
	}
	$scope.initialize()
} )