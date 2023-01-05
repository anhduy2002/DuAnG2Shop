app.controller( "basic-information-ctrl" , function( $scope , $http ){
	$scope.items = []
	$scope.form = { 
		id: '',
		title : '' ,
		phone : '',
		phone2 : '', 
		email : '', 
		address : '', 
		embedAddressCode : '' ,
		embedHelpYoutubeVideoIds : '' ,
		termsAndPolicies : ''
	}
	$scope.initialize = function(){
		$http.get( '/rest/basic-information' ).then( resp => {
			$scope.form = resp.data
		} )
	}
	$scope.update = function(){
		const item = angular.copy( $scope.form )
		const s = "Cập nhật thông tin cơ bản thất bại.\n"
		if( item.title.length < 5 || item.title.length > 50 ) return alert( s + "Tiêu đề trang website phải từ 5 đến 255 ký tự!" )
		if( item.phone.length < 9 || item.phone.length > 12 ) return alert( s + "Số điện thoại phải từ 9 đến 12 ký tự số!" )
		if( (item.phone2.length != 0 && item.phone2.length < 9) || item.phone2.length > 11 ) return alert( s + "Số điện thoại 2 phải từ 9 đến 11 ký tự số!" )
		if( !validateEmail( item.email ) || item.email.length > 50 ) return alert( s + "Email phải phải hợp lệ và có tối đa 50 ký tự!" )
		if( item.address.length < 5 || item.address.length > 255 ) return alert( s + "Địa chỉ phải từ 5 đến 255 ký tự!" )
		if( item.embedAddressCode == "" ) return alert( s + "Mã nhúng địa chỉ không được để trống!" )	
		$http.put( '/rest/basic-information' , item ).then( resp => {
			alert( "Cập nhật thông tin cơ bản thành công!" )
			window.location.reload()
		} ).catch( error => {
			alert( "Cập nhật thông tin cơ bản thất bại!" )
			console.log( "error" , error )
		} )
	}
	$scope.initialize()
} )