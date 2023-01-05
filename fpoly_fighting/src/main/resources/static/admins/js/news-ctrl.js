app.controller( "news-ctrl" , function( $scope , $http ){
	$scope.items = []
	$scope.form = { id : "" , title : "" , createdDate : "" , imageName : "" , content : "" , isDeleted : false , isShowedOnHomepage : true }
	$scope.propertyName = "id"
	$scope.initialize = function(){
		$scope.loadAll()
	}
	$scope.edit = function( item ){
		$scope.form = angular.copy( item )
		document.getElementById( "nav-tab-edit" ).click()
	}
	$scope.create = function(){
		const item = angular.copy( $scope.form )
		const s = "Thêm mới tin tức.\n"
		if( item.title == "" || item.title.length > 255 ) return alert( s + "Tên tin tức phải từ 1 đến 255 ký tự!" )
		if( item.content == "" ) return alert( s + "Nội dung tin tức không được để trống!" )
		$http.post( "/rest/news" , item ).then( resp => {
			$scope.loadAll()
			alert( "Thêm mới tin tức thành công!" )
			$scope.reset()
			document.getElementById( "nav-tab-list" ).click()
		} ).catch( error => {
			alert( "Thêm mới tin tức thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.update = function(){
		const item = angular.copy( $scope.form )
		const s = "Cập nhật tin tức thất bại.\n"
		if( item.id == "" ) return alert( s + "Vui lòng chọn 1 tin tức từ danh sách!" )
		if( item.title == "" || item.title.length > 255 ) return alert( s + "Tên tin tức phải từ 1 đến 255 ký tự!" )
		if( item.content == "" ) return alert( s + "Nội dung tin tức không được để trống!" )
		$http.put( `/rest/news/${ item.id }` , item ).then( resp => {
			$scope.loadAll()
			alert( "Cập nhật tin tức thành công!" )
			$scope.reset()
			document.getElementById( "nav-tab-list" ).click()
		} ).catch( error => {
			alert( "Cập nhật tin tức thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.delete = function(){
		const item = angular.copy( $scope.form )
		if( item.id == "" ) return alert( "Xóa tin tức thất bại.\nVui lòng chọn 1 tin tức từ danh sách!" )
		$http.delete( `/rest/news/${item.id}` ).then( resp => {
			$scope.loadAll()
			alert( "Xóa tin tức thành công!" )
			$scope.reset()
			document.getElementById( "nav-tab-list" ).click()
		} ).catch( error => {
			alert( "Xóa tin tức thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.reset = function(){
		$scope.form = { id : "" , title : "" , createdDate : "" , imageName : "" , content : "" , isDeleted : false , isShowedOnHomepage : true }
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
		$http.get( "/rest/news" ).then( resp => {
			$scope.items = resp.data
		} )
	}
	$scope.imageChanged = function( files ){
		const data = new FormData()
		data.append( "file" , files[ 0 ] )
		$http.post( "/rest/upload/images/news" , data , {
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