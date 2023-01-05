app.controller( "report-ctrl" , function( $scope , $http ){
	$scope.productIds = []
	$scope.categories = []
	$scope.report1A = []
	$scope.report1B = []
	$scope.report2A = []
	$scope.report2B = []
	$scope.report2C = []
	$scope.report2D = []
	
	$scope.report3 = {
		mode : "0"
	}
	$scope.report3A = {
		dat : [] ,
		matrix : [] ,
		years : [] ,
		stCount : {
			minXs : [] ,
			maxXs : [] ,
			minYs : [] ,
			maxYs : []
		} ,
		stTotalCost : {
			minXs : [] ,
			maxXs : [] ,
			minYs : [] ,
			maxYs : []
		}
	}
	$scope.report3B = {
		dat : [] ,
		matrix : [] ,
		quarters : [] ,
	}
	$scope.report3C = {
		dat : [] ,
		matrix : [] ,
		months : [] ,
	}
	$scope.report3D = {
		dat : [] ,
		matrix : [] ,
		days : [] ,
	}
	$scope.report4 = {
		mode : "0"
	}
	$scope.report4A = {
		dat : [] ,
		matrix : [] ,
		years : []
	}
	$scope.report4B = {
		dat : [] ,
		matrix : [] ,
		quarters : []
	}
	$scope.report4C = {
		dat : [] ,
		matrix : [] ,
		months : []
	}
	$scope.report4D = {
		dat : [] ,
		matrix : [] ,
		days : []
	}
	
	$scope.initialize = function(){
		$scope.loadReport1A()
		$scope.loadReport1B()
		$scope.loadReport2A()
		$scope.loadReport2B()
		$scope.loadReport2C()
		$scope.loadReport2D()
		
		$http.get( "/rest/products/allProductIds" ).then( resp => {
			$scope.productIds = resp.data
			$scope.loadReport3A()
			$scope.loadReport3B()
			$scope.loadReport3C()
			$scope.loadReport3D()
		} )
		$http.get( "/rest/categories" ).then( resp => {
			$scope.categories = resp.data
			$scope.loadReport4A()
			$scope.loadReport4B()
			$scope.loadReport4C()
			$scope.loadReport4D()
		} )
		
	}
	$scope.loadReport1A = function() {
		$http.get( "/rest/reports/1A" ).then( resp => {
			$scope.report1A = resp.data
		} )
	}
	$scope.loadReport1B = function() {
		$http.get( "/rest/reports/1B" ).then( resp => {
			$scope.report1B = resp.data
		} )
	}
	$scope.loadReport2A = function() {
		$http.get( "/rest/reports/2A" ).then( resp => {
			$scope.report2A = resp.data
		} )
	}
	$scope.loadReport2B = function() {
		$http.get( "/rest/reports/2B" ).then( resp => {
			$scope.report2B = resp.data
		} )
	}
	$scope.loadReport2C = function() {
		$http.get( "/rest/reports/2C" ).then( resp => {
			$scope.report2C = resp.data
		} )
	}
	$scope.loadReport2D = function() {
		$http.get( "/rest/reports/2D" ).then( resp => {
			$scope.report2D = resp.data
		} )
	}
	
	$scope.loadReport3A = function() {
		$http.get( "/rest/reports/3A" ).then( resp => {
			$scope.report3A.dat = resp.data
			const len = $scope.report3A.dat.length
			for( let i = 0 ; i < len ; i ++ ){
				const datItem = $scope.report3A.dat[ i ]
				const x = datItem.year
				const y = datItem.productId
				if( $scope.report3A.matrix[ x ] == undefined ){		
					$scope.report3A.matrix[ x ] = []
					$scope.report3A.matrix[ x ][ y ] =  {
						count : datItem.count ,
						totalCost : datItem.totalCost
					}
				} else {
					$scope.report3A.matrix[ x ][ y ] = {
						count : datItem.count ,
						totalCost : datItem.totalCost 
					}
				}
				
				if( !$scope.report3A.years.includes( x ) ){
					$scope.report3A.years.push( x )
				}
				
				//begin
				
				const count = $scope.report3A.matrix[ x ][ y ].count
				const totalCost = $scope.report3A.matrix[ x ][ y ].totalCost
				const stCount = $scope.report3A.stCount
				const stTotalCost = $scope.report3A.stTotalCost
				
				if( stCount.maxXs[ y ] == undefined ){
					stCount.maxXs[ y ] = {
						i : x ,
						count : count ,
					}
				} else if( stCount.maxXs[ y ].count < count ){
					stCount.maxXs[ y ] = {
						i : x ,
						count : count
					}
				}
				
				if( stCount.minXs[ y ] == undefined ){
					stCount.minXs[ y ] = {
						i : x ,
						count : count ,
					}
				} else if( stCount.minXs[ y ].count > count ){
					stCount.minXs[ y ] = {
						i : x ,
						count : count
					}
				}
				
				if( stCount.maxYs[ x ] == undefined ){
					stCount.maxYs[ x ] = {
						i : y ,
						count : count ,
					}
				} else if( stCount.maxYs[ x ].count < count ){
					stCount.maxYs[ x ] = {
						i : y ,
						count : count
					}
				}
				
				if( stCount.minYs[ x ] == undefined ){
					stCount.minYs[ x ] = {
						i : y ,
						count : count ,
					}
				} else if( stCount.minYs[ x ].count > count ){
					stCount.minYs[ x ] = {
						i : y ,
						count : count
					}
				}
				
				if( stTotalCost.maxXs[ y ] == undefined ){
					stTotalCost.maxXs[ y ] = {
						i : x ,
						totalCost : totalCost
					}
				} else if( stTotalCost.maxXs[ y ].totalCost < totalCost ){
					stTotalCost.maxXs[ y ] = {
						i : x ,
						totalCost : totalCost
					}
				}
				
				if( stTotalCost.minXs[ y ] == undefined ){
					stTotalCost.minXs[ y ] = {
						i : x ,
						totalCost : totalCost ,
					}
				} else if( stTotalCost.minXs[ y ].totalCost > totalCost ){
					stTotalCost.minXs[ y ] = {
						i : x ,
						totalCost : totalCost
					}
				}
				
				if( stTotalCost.maxYs[ x ] == undefined ){
					stTotalCost.maxYs[ x ] = {
						i : y ,
						totalCost : totalCost
					}
				} else if( stTotalCost.maxYs[ x ].totalCost < totalCost ){
					stTotalCost.maxYs[ x ] = {
						i : y ,
						totalCost : totalCost
					}
				}
				
				if( stTotalCost.minYs[ x ] == undefined ){
					stTotalCost.minYs[ x ] = {
						i : y ,
						totalCost : totalCost ,
					}
				} else if( stTotalCost.minYs[ x ].totalCost > totalCost ){
					stTotalCost.minYs[ x ] = {
						i : y ,
						totalCost : totalCost
					}
				}

			}
		} )
	}
	$scope.loadReport3B = function() {
		$http.get( "/rest/reports/3B" ).then( resp => {
			$scope.report3B.dat = resp.data
			const len = $scope.report3B.dat.length
			for( let i = 0 ; i < len ; i ++ ){
				const datItem = $scope.report3B.dat[ i ]
				const x = datItem.quarter + "-" + datItem.year
				const y = datItem.productId
				if( $scope.report3B.matrix[ x ] == undefined ){		
					$scope.report3B.matrix[ x ] = []
					$scope.report3B.matrix[ x ][ y ] =  {
						count : datItem.count ,
						totalCost : datItem.totalCost
					}
				} else {
					$scope.report3B.matrix[ x ][ y ] = {
						count : datItem.count ,
						totalCost : datItem.totalCost 
					}
				}
				if( !$scope.report3B.quarters.includes( x ) ){
					$scope.report3B.quarters.push( x )
				}
			}
		} )
	}
	$scope.loadReport3C = function() {
		$http.get( "/rest/reports/3C" ).then( resp => {
			$scope.report3C.dat = resp.data
			const len = $scope.report3C.dat.length
			for( let i = 0 ; i < len ; i ++ ){
				const datItem = $scope.report3C.dat[ i ]
				const x = datItem.month + "-" + datItem.year
				const y = datItem.productId
				if( $scope.report3C.matrix[ x ] == undefined ){		
					$scope.report3C.matrix[ x ] = []
					$scope.report3C.matrix[ x ][ y ] =  {
						count : datItem.count ,
						totalCost : datItem.totalCost
					}
				} else {
					$scope.report3C.matrix[ x ][ y ] = {
						count : datItem.count ,
						totalCost : datItem.totalCost 
					}
				}
				if( !$scope.report3C.months.includes( x ) ){
					$scope.report3C.months.push( x )
				}
			}
		} )
	}
	$scope.loadReport3D = function() {
		$http.get( "/rest/reports/3D" ).then( resp => {
			$scope.report3D.dat = resp.data
			const len = $scope.report3D.dat.length
			for( let i = 0 ; i < len ; i ++ ){
				const datItem = $scope.report3D.dat[ i ]
				const x = datItem.day + "-" + datItem.month + "-" + datItem.year
				const y = datItem.productId
				if( $scope.report3D.matrix[ x ] == undefined ){		
					$scope.report3D.matrix[ x ] = []
					$scope.report3D.matrix[ x ][ y ] =  {
						count : datItem.count ,
						totalCost : datItem.totalCost
					}
				} else {
					$scope.report3D.matrix[ x ][ y ] = {
						count : datItem.count ,
						totalCost : datItem.totalCost 
					}
				}
				if( !$scope.report3D.days.includes( x ) ){
					$scope.report3D.days.push( x )
				}
			}
		} )
	}
	$scope.loadReport4A = function() {
		$http.get( "/rest/reports/4A" ).then( resp => {
			
			$scope.report4A.dat = resp.data
			const len = $scope.report4A.dat.length
			
			for( let i = 0 ; i < len ; i ++ ){
				const datItem = $scope.report4A.dat[ i ]
				const x = datItem.year
				const y = datItem.categoryId
				if( $scope.report4A.matrix[ x ] == undefined ){		
					$scope.report4A.matrix[ x ] = []
					$scope.report4A.matrix[ x ][ y ] =  {
						count : datItem.count ,
						totalCost : datItem.totalCost
					}
					
				} else {
					$scope.report4A.matrix[ x ][ y ] = {
						count : datItem.count ,
						totalCost : datItem.totalCost 
					}
				}
				if( !$scope.report4A.years.includes( x ) ){
					$scope.report4A.years.push( x )
				}
			}
		} )
	}
	$scope.loadReport4B = function() {
		$http.get( "/rest/reports/4B" ).then( resp => {
			
			$scope.report4B.dat = resp.data
			const len = $scope.report4B.dat.length
	
			for( let i = 0 ; i < len ; i ++ ){
				const datItem = $scope.report4B.dat[ i ]
				const x = datItem.quarter + "-" + datItem.year
				const y = datItem.categoryId
				if( $scope.report4B.matrix[ x ] == undefined ){		
					$scope.report4B.matrix[ x ] = []
					$scope.report4B.matrix[ x ][ y ] =  {
						count : datItem.count ,
						totalCost : datItem.totalCost
					}
				} else {
					$scope.report4B.matrix[ x ][ y ] = {
						count : datItem.count ,
						totalCost : datItem.totalCost 
					}
					
				}
				if( !$scope.report4B.quarters.includes( x ) ){
					$scope.report4B.quarters.push( x )
				}
			}
		} )
	}
	$scope.loadReport4C = function() {
		$http.get( "/rest/reports/4C" ).then( resp => {
			
			$scope.report4C.dat = resp.data
			const len = $scope.report4C.dat.length
			
			for( let i = 0 ; i < len ; i ++ ){
				const datItem = $scope.report4C.dat[ i ]
				const x = datItem.month + "-" + datItem.year
				const y = datItem.categoryId
				if( $scope.report4C.matrix[ x ] == undefined ){		
					$scope.report4C.matrix[ x ] = []
					$scope.report4C.matrix[ x ][ y ] =  {
						count : datItem.count ,
						totalCost : datItem.totalCost
					}
					
				} else {
					$scope.report4C.matrix[ x ][ y ] = {
						count : datItem.count ,
						totalCost : datItem.totalCost 
					}
				}
				if( !$scope.report4C.months.includes( x ) ){
					$scope.report4C.months.push( x )
				}
			}
		} )
	}
	$scope.loadReport4D = function() {
		$http.get( "/rest/reports/4D" ).then( resp => {
			
			$scope.report4D.dat = resp.data
			const len = $scope.report4D.dat.length
			
			for( let i = 0 ; i < len ; i ++ ){
				const datItem = $scope.report4D.dat[ i ]
				const x = datItem.day + "-" + datItem.month + "-" + datItem.year
				const y = datItem.categoryId
				if( $scope.report4D.matrix[ x ] == undefined ){		
					$scope.report4D.matrix[ x ] = []
					$scope.report4D.matrix[ x ][ y ] =  {
						count : datItem.count ,
						totalCost : datItem.totalCost
					}
					
				} else {
					$scope.report4D.matrix[ x ][ y ] = {
						count : datItem.count ,
						totalCost : datItem.totalCost 
					}
				}
				if( !$scope.report4D.days.includes( x ) ){
					$scope.report4D.days.push( x )
				}
			}
		} )
		
	}
	
	$scope.initialize()
} )