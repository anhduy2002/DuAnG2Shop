app.controller( "order-ctrl" , function( $scope , $http ){
	$scope.isConfirmed = false
	$scope.items = []
	$scope.itemsOs0 = []
	$scope.itemsOs1 = []
	$scope.staffs = []
	$scope.itemsForShippingStaff = []
	$scope.form = {
		id : "" , 
		customer : {} ,
		createdDate : "" ,
		phone : "" ,
		address : "" ,
		details : [] ,
		totalProductCost : 0 ,
		orderStatus : "" ,
		confirmingStaff : {} ,
		shippingFee : 0 ,
		shippingStaff : {} ,
		receivedDate : "" , 
		totalCost : 0
	}
	$scope.propertyName = "createdDate"
	$scope.filter = {
		orderStatus : "" ,
		confirmingStaffId : 1 ,
		shippingStaffId : 1 ,
		byTotalCost : false ,
		byShippingFee : false ,
		byCreatedDate : false ,
		byReceivedDate : false ,
		byConfirmingStaffId : false ,
		totalCost : {
			min : 0 ,
			max : 100000000
		} ,
		shippingFee : {
			min : 0 ,
			max : 500000
		} ,
		createdDate : {
			min : new Date( 2021 , 6 , 1 ) ,
			max : new Date()
		} ,
		receivedDate : {
			min : new Date( 2021 , 6 , 1 ) ,
			max : new Date()
		} ,
		filt(){
			$http.get( "/rest/orders" ).then( resp => {
				$scope.items = resp.data
				const items = $scope.items
				for( let i = items.length - 1 ; i >= 0 ; i -- ){
					const item = items[ i ]
					if( this.orderStatus != "" && this.orderStatus != item.orderStatus.id ){
						items.splice( i , 1 )
						continue
					}
					if( this.byTotalCost && ( item.totalCost < this.totalCost.min || item.totalCost > this.totalCost.max ) ){
						items.splice( i , 1 )
						continue
					}
					if( this.byShippingFee && ( item.shippingFee < this.shippingFee.min || item.shippingFee > this.shippingFee.max ) ){
						items.splice( i , 1 )
						continue
					}
					const _createdDate = new Date( item.createdDate )
					if( this.byCreatedDate && ( _createdDate < this.createdDate.min || _createdDate > this.createdDate.max ) ){
						items.splice( i , 1 )
						continue
					}
					const _receivedDate = new Date( item.receivedDate )
					if( this.byReceivedDate && ( _receivedDate < this.receivedDate.min || _receivedDate > this.receivedDate.max ) ){
						items.splice( i , 1 )
						continue
					}
					if( this.byConfirmingStaffId && ( item.confirmingStaff == null || item.confirmingStaff.id != this.confirmingStaffId ) ){
						items.splice( i , 1 )
						continue
					}
					if( this.byShippingStaffId && ( item.shippingStaff == null || item.shippingStaff.id != this.shippingStaffId ) ){
						items.splice( i , 1 )
						continue
					}
				}
			} )
		} ,
		reset(){
			$http.get( "/rest/orders" ).then( resp => {
				$scope.items = resp.data
			} )
			this.orderStatus = ""
			this.confirmingStaffId = 1
			this.shippingStaffId = 1
			this.byTotalCost = false
			this.byShippingFee = false
			this.byCreatedDate = false
			this.byReceivedDate = false
			this.byConfirmingStaffId = false
			this.byShippingStaffId = false
			this.totalCost = {
				min : 0 ,
				max : 100000000
			}
			this.shippingFee = {
				min : 0 ,
				max : 500000
			}
			this.createdDate = {
				min : new Date( 2021 , 06 , 01 ) ,
				max : new Date()
			}
			this.receivedDate = {
				min : new Date( 2021 , 06 , 01 ) ,
				max : new Date()
			}
		}
	}
	$scope.initialize = function(){
		$scope.loadAll()
		$scope.loadAllStaffs()
		$scope.loadAllOrderStatuses()
	}
	$scope.edit = function( item ){
		$scope.form = angular.copy( item )
		$http.get( "/rest/order-details/by-order-id/" + item.id ).then( resp => {
			$scope.form.details = resp.data
		} )
		document.getElementById( "nav-tab-edit" ).click()
	}
	
	$scope.updateOrderStatus = function( orderStatusId ){
		$scope.isConfirmed = false
		const item = angular.copy( $scope.form )
		const shippingFee = $scope.form.shippingFee
		if( orderStatusId == 1 ){
			$http.put( `/rest/orders/${ item.id }?orderStatusId=1&shippingFee=${ shippingFee }` , item ).then( resp => {
				$scope.loadAll()
				alert( "X??c nh???n ????n h??ng th??nh c??ng.\nS??? l?????ng t???n kho c??c s???n ph???m ???????c y??u c???u trong ????n h??ng ???? ???????c c???p nh???t!" )
				
				document.getElementById( "nav-tab-list" ).click()
			} ).catch( error => {
				if( error.status == "403" ){
					alert( "????n h??ng c?? ??t nh???t m???t y??u c???u s???n ph???m v?????t qu?? s??? l?????ng t???n kho t????ng ???ng.\nX??c nh???n ????n h??ng th???t b???i.\nVui l??ng ????? ngh??? kh??ch h??ng h???y ????n h??ng!" )
				}
				alert( "X??c nh???n ????n h??ng th???t b???i!" )
				console.log( "error" , error )
			} )
		}
		if( orderStatusId == 2 ){
			$http.put( `/rest/orders/${ item.id }?orderStatusId=2` , item ).then( resp => {
				$scope.loadAll()
				alert( "Nh???n giao ????n h??ng th??nh c??ng!" )
				document.getElementById( "nav-tab-list" ).click()
			} ).catch( error => {
				alert( "Nh???n giao ????n h??ng th???t b???i!" )
				console.log( "error" , error )
			} )
		}
		if( orderStatusId == 3 ){
			$http.put( `/rest/orders/${ item.id }?orderStatusId=3` , item ).then( resp => {
				$scope.loadAll()
				alert( "X??c nh???n ???? l???y h??ng th??nh c??ng!" )
				document.getElementById( "nav-tab-list" ).click()
			} ).catch( error => {
				alert( "X??c nh???n ???? l???y h??ng th???t b???i!" )
				console.log( "error" , error )
			} )
		}
		if( orderStatusId == 4 ){
			$http.put( `/rest/orders/${ item.id }?orderStatusId=4` , item ).then( resp => {
				$scope.loadAll()
				alert( "X??c nh???n ???? v???n chuy???n h??ng ?????n n??i giao h??ng th??nh c??ng!" )
				document.getElementById( "nav-tab-list" ).click()
			} ).catch( error => {
				alert( "X??c nh???n ???? v???n chuy???n h??ng ?????n n??i giao h??ng th???t b???i!" )
				console.log( "error" , error )
			} )
		}
		if( orderStatusId == 5 ){
			$http.put( `/rest/orders/${ item.id }?orderStatusId=5` , item ).then( resp => {
				$scope.loadAll()
				alert( "X??c nh???n kh??ch h??ng ???? thanh to??n ?????y ????? th??nh c??ng.\nHo??n t???t ????n h??ng!" )
				document.getElementById( "nav-tab-list" ).click()
			} ).catch( error => {
				alert( "X??c nh???n kh??ch h??ng ???? thanh to??n ?????y ????? th???t b???i!" )
				console.log( "error" , error )
			} )
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
	    $scope.reverse = ( $scope.propertyName === propertyName ) ? ! $scope.reverse : false ;
	    $scope.propertyName = propertyName;
	}
	$scope.loadAll = function() {
		$http.get( "/rest/orders" ).then( resp => {
			$scope.items = resp.data
		} )
		$scope.loadAllOs0()
		$scope.loadAllOs1()
		$scope.loadAllForShippingStaff()
	}
	$scope.loadAllOs0 = function(){
		$http.get( "/rest/orders?orderStatusId=0" ).then( resp => {
			$scope.itemsOs0 = resp.data
		} )
	}
	$scope.loadAllOs1 = function(){
		$http.get( "/rest/orders?orderStatusId=1" ).then( resp => {
			$scope.itemsOs1 = resp.data
		} )
	}
	$scope.loadAllForShippingStaff = function(){
		if( $scope.loggedInStaff.role.id != 4 ) return
		$http.get( "/rest/orders?shippingStaffId=" + $scope.loggedInStaff.id + "&orderStatusIds=2&orderStatusIds=3&orderStatusIds=4" ).then( resp => {
			$scope.itemsForShippingStaff = resp.data
		} )
	}
	$scope.loadAllStaffs = function(){
		$http.get( "/rest/staffs" ).then( resp => {
			$scope.staffs = resp.data
		} )
	}
	$scope.loadAllOrderStatuses = function(){
		$http.get( "/rest/order-statuses" ).then( resp => {
			$scope.orderStatuses = resp.data
		} )
	}
	$scope.downloadOrderBill = function( orderId ){
		$http.get( "/rest/orders/downloadBill/" + orderId ).then( resp => {
			alert( "T???i xu???ng h??a ????n b??n h??ng th??nh c??ng!" ) 
		} ).catch( error => {
			alert( "T???i xu???ng h??a ????n b??n h??ng th???t b???i!" )
			console.log( "error" , error )
		} )
	}
	$scope.initialize()
} )