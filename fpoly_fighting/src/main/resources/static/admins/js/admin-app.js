const validateEmail = (email) => {
  return String(email)
    .toLowerCase()
    .match(
      /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    );
};
const app = angular.module( "admin-app" , [ "ngRoute" , 'ngSanitize'] ) ;
app.config( function( $routeProvider ){
	$routeProvider
		.when( "/role" , {
			templateUrl : "/admins/html/role/index.html" ,
			controller : "role-ctrl"
		} )
		.when( "/staff" , {
			templateUrl : "/admins/html/staff/index.html" ,
			controller : "staff-ctrl"
		} )
		.when( "/customer" , {
			templateUrl : "/admins/html/customer/index.html" ,
			controller : "customer-ctrl"
		} )
		.when( "/category" , {
			templateUrl : "/admins/html/category/index.html" ,
			controller : "category-ctrl"
		} )
		.when( "/brand" , {
			templateUrl : "/admins/html/brand/index.html" ,
			controller : "brand-ctrl"
		} )
		.when( "/product" , {
			templateUrl : "/admins/html/product/index.html" ,
			controller : "product-ctrl"
		} )
		.when( "/order-status" , {
			templateUrl : "/admins/html/order-status/index.html" ,
			controller : "order-status-ctrl"
		} )
		.when( "/order" , {
			templateUrl : "/admins/html/order/index.html" ,
			controller : "order-ctrl"
		} )
		.when( "/report" , {
			templateUrl : "/admins/html/report/index.html" ,
			controller : "report-ctrl"
		} )
		.when( "/report-website-visit" , {
			templateUrl : "/admins/html/website-visit/index.html" ,
			controller : "report-website-visit-ctrl"
		} )
		.when( "/basic-information" , {
			templateUrl : "/admins/html/basic-information/index.html" ,
			controller : "basic-information-ctrl"
		} )
		.when( "/favorite-product" , {
			templateUrl : "/admins/html/favorite/index.html" ,
			controller : "favorite-ctrl"
		} )
		.when( "/news" , {
			templateUrl : "/admins/html/news/index.html" ,
			controller : "news-ctrl"
		} )
		.when( "/authorize" , {
			templateUrl : "/admins/html/authorize/index.html" ,
			controller : "authorize-ctrl"
		} )
		.otherwise( {
			templateUrl : "/admins/html/home/index.html"
		} )
} )
app.controller( "admin-ctrl" , function( $scope , $http ){
	$scope.loggedInStaff = {}
	$scope.moduleId = ""
	$scope.initialize = function(){
		$http.get( "/rest/staffs/logged-in" ).then( resp => {
			$scope.loggedInStaff = resp.data
		} )
	}
	$scope.setModuleId = function( id ){
		$scope.moduleId = id
	}
	$scope.initialize()
} )
	
