app.controller( "product-ctrl" , function( $scope , $http ){
	$scope.items = []
	$scope.categories = []
	$scope.brands = []
	$scope.defaultCategory = {}
	$scope.defaultBrand = {}
	$scope.filter = {
		brand : "" ,
		category : "" ,
		byPrice : false ,
		byDiscount : false ,
		bySalePrice : false ,
		price : {
			min : 0 ,
			max : 10000000
		} ,
		discount : {
			min : 0 ,
			max : 99
		} ,
		salePrice : {
			min : 0 ,
			max : 10000000
		} ,
		search : "" ,
		filt(){
			$http.get( "/rest/products" ).then( resp => {
				$scope.items = resp.data
				const items = $scope.items
				for( let i = items.length - 1 ; i >= 0 ; i -- ){
					const item = items[ i ]
					if( this.category != "" && this.category != item.category.id ){
						items.splice( i , 1 )
						continue
					}
					if( this.brand != "" && this.brand != item.brand.id ){
						items.splice( i , 1 )
						continue
					}
					if( this.byPrice && ( item.price < this.price.min || item.price > this.price.max ) ){
						items.splice( i , 1 )
						continue
					}
					if( this.byDiscount && ( item.discount < this.discount.min || item.discount > this.discount.max ) ){
						items.splice( i , 1 )
						continue
					}
					if( this.bySalePrice && ( item.salePrice < this.salePrice.min || item.salePrice > this.salePrice.max ) ){
						items.splice( i , 1 )
						continue
					}
					if( this.search != "" && !( item.name.toLowerCase().includes( this.search.toLowerCase() ) || item.slug.toLowerCase().includes( this.search.toLowerCase() ) ) ){
						items.splice( i , 1 )
					}
				}
			} )
		} ,
		reset(){
			$http.get( "/rest/products" ).then( resp => {
				$scope.items = resp.data
			} )
			this.brand = ""
			this.category = ""
			this.byPrice = false
			this.byDiscount = false
			this.bySalePrice = false
			this.price = {
				min : 0 ,
				max : 10000000
			}
			this.discount = {
				min : 0 ,
				max : 99
			} ,
			this.salePrice = {
				min : 0 ,
				max : 10000000
			}
		}
	}
	$scope.form = { 
		id : "" , 
		category : {} , 
		brand : {} , 
		name : "" , 
		quantity : 0 , 
		price : 0 , 
		discount : 0 , 
		salePrice : 0 , 
		imageName : "" ,
		image1Name : "" , 
		image2Name : "" , 
		image3Name : "" ,
		image4Name : "" , 
		image5Name : "" ,  
		slug : "" , 
		isDeleted : false 
	}
	$scope.propertyName = "id"
	$scope.initialize = function(){
		$scope.loadAll()
		$http.get( "/rest/categories" ).then( resp => {
			$scope.categories = resp.data
			$scope.defaultCategory = $scope.categories[0]
			$scope.form.category = $scope.defaultCategory
		} )
		$http.get( "/rest/brands" ).then( resp => {
			$scope.brands = resp.data
			$scope.defaultBrand = $scope.brands[0]
			$scope.form.brand = $scope.defaultBrand
		} )
	}
	$scope.edit = function( item ){
		$scope.form = angular.copy( item )
		document.getElementById( "nav-tab-edit" ).click()
	}
	$scope.create = function(){
		const item = angular.copy( $scope.form )
		const s = "Thêm mới sản phẩm thất bại.\n"
		if( item.name.length < 3 || item.name.length > 50 ) return alert( s + "Tên sản phẩm phải từ 3 đến 255 ký tự!" )
		if( item.slug.trim() == "" || item.slug.length > 255 ) return alert( s + "Slug phải từ 1 đến 255 ký tự!" )
		if( item.quantity == "" ) return alert( s + "Số lượng không được để trống!" )
		if( item.discount == "" ) return alert( s + "Giảm giá không được để trống!" )
		if( item.price == "" ) return alert( s + "Giá sản phẩm không được để trống!" )
		$http.post( "/rest/products" , item ).then( resp => {
			$scope.loadAll()
			alert( "Thêm mới sản phẩm thành công!" )
			$scope.reset()
			document.getElementById( "nav-tab-list" ).click()
		} ).catch( error => {
			alert( "Thêm mới sản phẩm thất bại!" )
			console.log( "error" , error )
		} )
	}
	
	$scope.update = function(){
		const item = angular.copy( $scope.form )
		const s = "Cập nhật sản phẩm thất bại.\n"
		if( item.id == "" ) return alert( s + "Vui lòng chọn 1 sản phẩm từ danh sách!" )
		if( item.name.length < 3 || item.name.length > 50 ) return alert( s + "Tên sản phẩm phải từ 3 đến 255 ký tự!" )
		if( item.slug.trim() == "" || item.slug.length > 255 ) return alert( s + "Slug phải từ 1 đến 255 ký tự!" )
		if( item.quantity == "" ) return alert( s + "Số lượng không được để trống!" )
		if( item.discount == "" ) return alert( s + "Giảm giá không được để trống!" )
		if( item.price == "" ) return alert( s + "Giá sản phẩm không được để trống!" )
		$http.put( `/rest/products/${ item.id }` , item ).then( resp => {
			$scope.loadAll()
			alert( "Cập nhật sản phẩm thành công!" )
			document.getElementById( "nav-tab-list" ).click()
		} ).catch( error => {
			alert( "Cập nhật sản phẩm thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.delete = function(){
		const item = angular.copy( $scope.form )
		if( item.id == "" ) return alert( "Xóa sản phẩm thất bại.\nVui lòng chọn 1 loại sản phẩm từ danh sách!" )
		$http.delete( `/rest/products/${item.id}` ).then( resp => {
			const index = $scope.items.findIndex( p => p.id == item.id )
			$scope.items.splice( index , 1 )
			alert( "Xóa sản phẩm thành công!" )
			$scope.reset()
			document.getElementById( "nav-tab-list" ).click()
		} ).catch( error => {
			alert( "Xóa sản phẩm thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.reset = function(){
		$scope.form = { 
			id : "" , 
			category : $scope.defaultCategory , 
			brand : $scope.defaultBrand , 
			name : "" , 
			quantity : 0 , 
			price : 0 , 
			discount : 0 , 
			salePrice : 0 , 
			imageName : "" ,
			image1Name : "" , 
			image2Name : "" , 
			image3Name : "" ,
			image4Name : "" , 
			image5Name : "" ,  
			slug : "" , 
			isDeleted : false 
		}
	}
	$scope.pager = {
		page : 1 ,
		size : 10 ,
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
		$http.get( "/rest/products" ).then( resp => {
			$scope.items = resp.data
		} )
	}
	$scope.imageChanged = function( files , imageId ){
		const data = new FormData()
		data.append( "file" , files[ 0 ] )
		$http.post( "/rest/upload/images/products/" + $scope.form.id , data , {
			transformRequest: angular.identity() ,
			headers: { "Content-Type" : undefined } 
		} ).then( resp => {
			switch( imageId ){
				case 1: 
					$scope.form.image1Name = resp.data.name
					break ;
				case 2: 
					$scope.form.image2Name = resp.data.name
					break ;
				case 3: 
					$scope.form.image3Name = resp.data.name
					break ;
				case 4: 
					$scope.form.image4Name = resp.data.name
					break ;
				case 5: 
					$scope.form.image5Name = resp.data.name
					break ;
				default: 
					$scope.form.imageName = resp.data.name
					break ;
			}
			
		} ).catch( error => {
			alert( "Không thể tải lên ảnh!" )
			console.log( "error" , error )
		} ) 
	}
	$scope.initialize()
} )