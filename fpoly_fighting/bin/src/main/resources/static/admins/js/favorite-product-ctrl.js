app.controller( "favorite-product-ctrl" , function( $scope , $http ){
	$scope.propertyName = ""
	$scope.initialize = function(){
		$scope.loadAll()
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
	    $scope.reverse = ( $scope.propertyName === propertyName ) ? !$scope.reverse : true;
	    $scope.propertyName = propertyName;
	}
	$scope.loadAll = function() {
		$http.get( "/rest/products/favorite-product" ).then( resp => {
			$scope.items = resp.data
		} )
	}
	$scope.initialize()
} )