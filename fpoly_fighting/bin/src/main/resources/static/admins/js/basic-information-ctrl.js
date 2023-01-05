app.controller( "basic-information-ctrl" , function( $scope , $http ){
	$scope.items = []
	$scope.form = { 
		id: '',
		phone : '',
		phone2 : '', 
		email : '', 
		address : '', 
		introduce : ''
	}
	$scope.initialize = function(){
		$http.get( '/rest/basic-information' ).then( resp => {
			$scope.form = resp.data
		} )
	}
	$scope.update = function(){
		const item = angular.copy( $scope.form )
		if( item.phone.trim().length < 9 || item.phone.trim().length > 11 ) return alert( s + "Số điện thoại phải từ 9 đến 11 ký tự số!" )
		if( (item.phone2.trim().length != 0 && item.phone2.trim().length < 9) || item.phone2.trim().length > 11 ) return alert( s + "Số điện thoại phải từ 9 đến 11 ký tự số!" )
		if( !validateEmail( item.email ) || item.email.trim().length > 100 ) return alert( s + "Email phải phải hợp lệ và có tối đa 100 ký tự!" )
		if( item.address.trim().length < 5 || item.address.trim().length > 250 ) return alert( s + "Địa chỉ phải từ 5 đến 250 ký tự!" )
		if( item.introduce.trim().length < 5 || item.introduce.trim().length > 50 ) return alert( s + "Tiêu đề trang website phải từ 5 đến 50 ký tự!" )
		$http.put( '/rest/basic-information' , item ).then( resp => {
			alert( "Cập nhật thông tin website thành công!" )
			window.location.reload()
		} ).catch( error => {
			alert( "Cập nhật thông tin website thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.initialize()
} )