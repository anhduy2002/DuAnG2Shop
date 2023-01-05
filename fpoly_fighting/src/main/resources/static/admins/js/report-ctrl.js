hideElement = id => {
	const element = document.getElementById( id )
	if( element == null ) return
	element.style.height = "0px"
}
hideElements = ids => {
	for( let i = 0 ; i < ids.length ; i ++ ){
		hideElement( ids[ i ] )
	}
}
app.controller( "report-ctrl" , function( $scope , $http ){
	$scope.categories = []
	$scope.products = []
	$scope.report1A = []
	$scope.report1B = []
	$scope.report2A = []
	$scope.report2B = []
	$scope.report2C = []
	$scope.report2D = []
	$scope.report2E = {}
	$scope.report3A = {}
	$scope.report3B = {}
	$scope.report3C = {}
	$scope.report3D = {}
	$scope.report3E = {}
	$scope.report4A = {}
	$scope.report4B = {}
	$scope.report4C = {}
	$scope.report4D = {}
	$scope.report4E = []
	$scope.filter = {
		startDate: new Date( "2021/06/01" ) ,
		endDate : new Date() ,
		forReport2s : {
			g : "DOANH THU ĐƠN HÀNG"
		} ,
		mode : "0" ,
		mode2 : "0" ,
		modeCategory : "-1" ,
		getDateRangeS(){
			const startDate = this.startDate.getDate() + "/" + ( this.startDate.getMonth() + 1 ) + "/" + this.startDate.getFullYear()
			const endDate = this.endDate.getDate() + "/" + ( this.endDate.getMonth() + 1 ) + "/" + this.endDate.getFullYear()
			return "TỪ " + startDate + " ĐẾN " + endDate
		} ,
		reset(){
			this.startDate = new Date( "2021/06/01" )
			this.endDate = new Date()
			this.forReport2s.g = "DOANH THU ĐƠN HÀNG"
			this.mode = "0"
			this.mode2 = "0"
			this.modeCategory = "-1"
			this.filt()
		} ,
		filt(){
			const dateRangeS = "?startDate=" + this.startDate.toISOString() + "&endDate=" + this.endDate.toISOString()
			const categoryIdS = this.modeCategory == -1 ? "" : "&categoryId=" + this.modeCategory
			$scope.loadReport2A( "/rest/reports/2A" + dateRangeS )
			$scope.loadReport2B( "/rest/reports/2B" + dateRangeS )
			$scope.loadReport2C( "/rest/reports/2C" + dateRangeS )
			$scope.loadReport2D( "/rest/reports/2D" + dateRangeS )
			$scope.loadReport2E( "/rest/reports/2E" + dateRangeS )
			$http.get( "/rest/products" + (  this.modeCategory == -1 ? "" : "?categoryId=" + this.modeCategory ) ).then( resp => {
				$scope.products = resp.data
				$scope.loadReport3A( "/rest/reports/3A" + dateRangeS + categoryIdS )
				$scope.loadReport3B( "/rest/reports/3B" + dateRangeS + categoryIdS )
				$scope.loadReport3C( "/rest/reports/3C" + dateRangeS + categoryIdS )
				$scope.loadReport3D( "/rest/reports/3D" + dateRangeS + categoryIdS )
				$scope.loadReport3E( "/rest/reports/3E" + dateRangeS + categoryIdS )
			} )
			$scope.loadReport4A( "/rest/reports/4A" + dateRangeS )
			$scope.loadReport4B( "/rest/reports/4B" + dateRangeS )
			$scope.loadReport4C( "/rest/reports/4C" + dateRangeS )
			$scope.loadReport4D( "/rest/reports/4D" + dateRangeS )
			$scope.loadReport4E( "/rest/reports/4E" + dateRangeS )
		}
	}
	$scope.initialize = function(){
		$scope.loadReport1A( "/rest/reports/1A" )
		$scope.loadReport1B( "/rest/reports/1B" )
		$scope.loadReport2A( "/rest/reports/2A" )
		$scope.loadReport2B( "/rest/reports/2B" )
		$scope.loadReport2C( "/rest/reports/2C" )
		$scope.loadReport2D( "/rest/reports/2D" )
		$scope.loadReport2E( "/rest/reports/2E" )
		$http.get( "/rest/products" ).then( resp => {
			$scope.products = resp.data
			$scope.loadReport3A( "/rest/reports/3A" )
			$scope.loadReport3B( "/rest/reports/3B" )
			$scope.loadReport3C( "/rest/reports/3C" )
			$scope.loadReport3D( "/rest/reports/3D" )
			$scope.loadReport3E( "/rest/reports/3E" )
		} )
		$http.get( "/rest/categories" ).then( resp => {
			$scope.categories = resp.data
			$scope.loadReport4A( "/rest/reports/4A" )
			$scope.loadReport4B( "/rest/reports/4B" )
			$scope.loadReport4C( "/rest/reports/4C" )
			$scope.loadReport4D( "/rest/reports/4D" )
			$scope.loadReport4E( "/rest/reports/4E" )
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
	$scope.loadReport2A = function( url ) {
		hideElements( [ "line-chart-2A" , "pie-chart-2A" ] )
		$http.get( url ).then( resp => {
			$scope.report2A = resp.data
		} )
	}
	$scope.loadReport2B = function( url ) {
		hideElements( "line-chart-2B" , "pie-chart-2B" )
		$http.get( url ).then( resp => {
			$scope.report2B = []
			const reports = resp.data
			for( let i = 0 ; i < reports.length ; i ++ ){
				const report = reports[ i ]
				$scope.report2B.push( report )
				if( i == reports.length - 1 ) break
				nextReport = reports[ i + 1 ]
				const e = new Date( report.year , report.quarter * 3 - 1 , 1 )
				const s = new Date( nextReport.year , nextReport.quarter * 3 - 1 , 1 ) 
				if( s.getMonth() < 11 ){
					s.setMonth( s.getMonth() + 3 )
				} else {
					s.setFullYear( s.getFullYear() + 1 )
				}
				let date = e
				while( date.getTime() > s.getTime() ) {
					if( date.getMonth() > 0 ){
						date.setMonth( date.getMonth() - 3 )
					} else {
						date.setFullYear( s.getFullYear() - 1 )
					}
					$scope.report2B.push( {
						year : date.getFullYear() ,
						quarter : ( date.getMonth() + 1 ) / 3 ,
						count : 0 ,
						productCount : 0 ,
						totalProductCost : 0 ,
						totalCost : 0
					} )
				}
			}
		} )
	}
	$scope.loadReport2C = function( url ) {
		hideElements( [ "line-chart-2C" , "pie-chart-2C" ] )
		$http.get( url ).then( resp => {
			$scope.report2C = []
			const reports = resp.data
			for( let i = 0 ; i < reports.length ; i ++ ){
				const report = reports[ i ]
				$scope.report2C.push( report )
				if( i == reports.length - 1 ) break
				nextReport = reports[ i + 1 ]
				const e = new Date( report.year , report.month - 1 , 1 )
				const s = new Date( nextReport.year , nextReport.month - 1 , 1 ) 
				if( s.getMonth() < 11 ){
					s.setMonth( s.getMonth() + 1 )
				} else {
					s.setFullYear( s.getFullYear() + 1 )
				}
				let date = e
				while( date.getTime() > s.getTime() ) {
					if( date.getMonth() > 0 ){
						date.setMonth( date.getMonth() - 1 )
					} else {
						date.setFullYear( s.getFullYear() - 1 )
					}
					$scope.report2C.push( {
						year : date.getFullYear() ,
						month : date.getMonth() + 1 ,
						count : 0 ,
						productCount : 0 ,
						totalProductCost : 0 ,
						totalCost : 0
					} )
				}
			}
		} )
	}
	$scope.loadReport2D = function( url ) {
		hideElements( [ "line-chart-2D" , "pie-chart-2D" ] )
		$http.get( url ).then( resp => {
			$scope.report2D = []
			const reports = resp.data
			for( let i = 0 ; i < reports.length ; i ++ ){
				const report = reports[ i ]
				$scope.report2D.push( report )
				if( i == reports.length - 1 ) break
				nextReport = reports[ i + 1 ]
				const e = new Date( report.year , report.month - 1 , report.day )
				const s = new Date( nextReport.year , nextReport.month - 1 , nextReport.day ) 
				s.setDate( s.getDate() + 1 )
				let date = e
				while( date.getTime() > s.getTime() ) {
					date.setDate( date.getDate() - 1 )
					$scope.report2D.push( {
						year : date.getFullYear() ,
						month : date.getMonth() + 1 ,
						day : date.getDate() ,
						count : 0 ,
						productCount : 0 ,
						totalProductCost : 0 ,
						totalCost : 0
					} )
				}
			}
		} )
	}
	$scope.loadReport2E = function( url ) {
		$http.get( url ).then( resp => {
			$scope.report2E = resp.data
		} )
	}
	$scope.loadReport4A = function( url ) {
		hideElements( "multi-line-chart-4A" )
		$http.get( url ).then( resp => {
			const categories = $scope.categories
			$scope.report4A = {
				dat : [] ,
				matrix : [] ,
				years : []
			}
			const report4A = $scope.report4A
			report4A.dat = resp.data
			const dat = report4A.dat
			const matrix = report4A.matrix
			const years = report4A.years
			for( let i = 0 ; i < dat.length ; i ++ ){
				const item = dat[ i ]
				const year = item.year
				if( matrix[ year ] == undefined ) matrix[ year ] = []
				matrix[ year ][ item.categoryId ] = {
					count : item.count ,
					totalCost : item.totalCost 
				}
				if( !years.includes( year ) ) years.push( year )
			}
			for( let i = 0 ; i < years.length ; i ++ ){
				const year = years[ i ]
				for( let j = 0 ; j < categories.length ; j ++ ){
					const categoryId = categories[ j ].id
					if( matrix[ year ][ categoryId ] == undefined ) matrix[ year ][ categoryId ] = { 
						count : 0 , 
						totalCost : 0 
					}
				}
			}
		} )
	}
	$scope.loadReport3A = function( url ) {
		hideElements( "multi-line-chart-3A" )
		$http.get( url ).then( resp => {
			const products = $scope.products
			$scope.report3A = {
				dat : [] ,
				matrix : [] ,
				years : []
			}
			const report3A = $scope.report3A
			report3A.dat = resp.data
			const dat = report3A.dat
			const matrix = report3A.matrix
			const years = report3A.years
			for( let i = 0 ; i < dat.length ; i ++ ){
				const item = dat[ i ]
				const year = item.year
				if( matrix[ year ] == undefined ) matrix[ year ] = []
				matrix[ year ][ item.productId ] = {
					count : item.count ,
					totalCost : item.totalCost 
				}
				if( !years.includes( year ) ) years.push( year )
			}
			for( let i = 0 ; i < years.length ; i ++ ){
				const year = years[ i ]
				for( let j = 0 ; j < products.length ; j ++ ){
					const productId = products[ j ].id
					if( matrix[ year ][ productId ] == undefined ) matrix[ year ][ productId ] = { 
						count : 0 , 
						totalCost : 0 
					}
				}
			}
		} )
	}
	$scope.loadReport4B = function( url ) {
		hideElement( "multi-line-chart-4B" )
		$http.get( url ).then( resp => {
			const categories = $scope.categories
			$scope.report4B = {
				dat : [] ,
				matrix : [] ,
				quarters : []
			}
			const report4B = $scope.report4B
			report4B.dat = resp.data
			const dat = report4B.dat
			const matrix = report4B.matrix
			const quarters = report4B.quarters
			for( let i = 0 ; i < dat.length ; i ++ ){
				const item = dat[ i ]
				const quarter = item.quarter + "-" + item.year
				if( matrix[ quarter ] == undefined ) matrix[ quarter ] = []
				matrix[ quarter ][ item.categoryId ] = {
					count : item.count ,
					totalCost : item.totalCost 
				}
				if( quarters.length == 0 ){
					quarters.push( quarter )
					continue
				}
				if( !quarters.includes( quarter ) ){
					let temp = quarters[ quarters.length - 1 ].split( "-" )
					const _quarter = temp[ 0 ]
					const _year = temp[ 1 ]
					let temp2 = quarter.split( "-" )
					const nextQuarter = temp2[ 0 ]
					const nextYear = temp2[ 1 ]
					const e = new Date( _year , _quarter * 3 - 1 , 1 )
					const s = new Date( nextYear , nextQuarter * 3 - 1 , 1 ) 
					if( s.getMonth() < 11 ){
						s.setMonth( s.getMonth() + 3 )
					} else {
						s.setFullYear( s.getFullYear() + 1 )
					}
					let date = e
					while( date.getTime() > s.getTime() ) {
						if( date.getMonth() > 0 ){
							date.setMonth( date.getMonth() - 3 )
						} else {
							date.setFullYear( s.getFullYear() - 1 )
						}
						quarters.push( ( date.getMonth() + 1 ) / 3 + "-" + date.getFullYear() )
					}
					quarters.push( quarter )
				}
			}
			for( let i = 0 ; i < quarters.length ; i ++ ){
				const quarter = quarters[ i ]
				for( let j = 0 ; j < categories.length ; j ++ ){
					const categoryId = categories[ j ].id
					if( matrix[ quarter ] == undefined ) matrix[ quarter ] = []
					if( matrix[ quarter ][ categoryId ] == undefined ) matrix[ quarter ][ categoryId ] = { 
						count : 0 , 
						totalCost : 0 
					}
				}
			}
		} )
	}
	$scope.loadReport3B = function( url ) {
		hideElement( "multi-line-chart-3B" )
		$http.get( url ).then( resp => {
			const products = $scope.products
			$scope.report3B = {
				dat : [] ,
				matrix : [] ,
				quarters : []
			}
			const report3B = $scope.report3B
			report3B.dat = resp.data
			const dat = report3B.dat
			const matrix = report3B.matrix
			const quarters = report3B.quarters
			for( let i = 0 ; i < dat.length ; i ++ ){
				const item = dat[ i ]
				const quarter = item.quarter + "-" + item.year
				if( matrix[ quarter ] == undefined ) matrix[ quarter ] = []
				matrix[ quarter ][ item.productId ] = {
					count : item.count ,
					totalCost : item.totalCost 
				}
				if( quarters.length == 0 ){
					quarters.push( quarter )
					continue
				}
				if( !quarters.includes( quarter ) ){
					let temp = quarters[ quarters.length - 1 ].split( "-" )
					const _quarter = temp[ 0 ]
					const _year = temp[ 1 ]
					let temp2 = quarter.split( "-" )
					const nextQuarter = temp2[ 0 ]
					const nextYear = temp2[ 1 ]
					const e = new Date( _year , _quarter * 3 - 1 , 1 )
					const s = new Date( nextYear , nextQuarter * 3 - 1 , 1 ) 
					if( s.getMonth() < 11 ){
						s.setMonth( s.getMonth() + 3 )
					} else {
						s.setFullYear( s.getFullYear() + 1 )
					}
					let date = e
					while( date.getTime() > s.getTime() ) {
						if( date.getMonth() > 0 ){
							date.setMonth( date.getMonth() - 3 )
						} else {
							date.setFullYear( s.getFullYear() - 1 )
						}
						quarters.push( ( date.getMonth() + 1 ) / 3 + "-" + date.getFullYear() )
					}
					quarters.push( quarter )
				}
			}
			for( let i = 0 ; i < quarters.length ; i ++ ){
				const quarter = quarters[ i ]
				for( let j = 0 ; j < products.length ; j ++ ){
					const productId = products[ j ].id
					if( matrix[ quarter ] == undefined ) matrix[ quarter ] = []
					if( matrix[ quarter ][ productId ] == undefined ) matrix[ quarter ][ productId ] = { 
						count : 0 , 
						totalCost : 0 
					}
				}
			}
		} )
	}
	$scope.loadReport4C = function( url ) {
		hideElement( "multi-line-chart-4C" )
		$http.get( url ).then( resp => {
			const categories = $scope.categories
			$scope.report4C = {
				dat : [] ,
				matrix : [] ,
				months : []
			}
			const report4C = $scope.report4C
			report4C.dat = resp.data
			const dat = report4C.dat
			const matrix = report4C.matrix
			const months = report4C.months
			for( let i = 0 ; i < dat.length ; i ++ ){
				const item = dat[ i ]
				const month = item.month + "-" + item.year
				if( matrix[ month ] == undefined ) matrix[ month ] = []
				matrix[ month ][ item.categoryId ] = {
					count : item.count ,
					totalCost : item.totalCost 
				}
				if( months.length == 0 ){
					months.push( month )
					continue
				}
				if( !months.includes( month ) ){
					let temp = months[ months.length - 1 ].split( "-" )
					const _month = temp[ 0 ]
					const _year = temp[ 1 ]
					let temp2 = month.split( "-" )
					const nextMonth = temp2[ 0 ]
					const nextYear = temp2[ 1 ]
					const e = new Date( _year , _month - 1 , 1 )
					const s = new Date( nextYear , nextMonth - 1 , 1 ) 
					if( s.getMonth() < 11 ){
						s.setMonth( s.getMonth() + 1 )
					} else {
						s.setFullYear( s.getFullYear() + 1 )
					}
					let date = e
					while( date.getTime() > s.getTime() ) {
						if( date.getMonth() > 0 ){
							date.setMonth( date.getMonth() - 1 )
						} else {
							date.setFullYear( s.getFullYear() - 1 )
						}
						months.push( ( date.getMonth() + 1 ) + "-" + date.getFullYear() )
					}
					months.push( month )
				}
			}
			for( let i = 0 ; i < months.length ; i ++ ){
				const month = months[ i ]
				for( let j = 0 ; j < categories.length ; j ++ ){
					const categoryId = categories[ j ].id
					if( matrix[ month ] == undefined ) matrix[ month ] = []
					if( matrix[ month ][ categoryId ] == undefined ) matrix[ month ][ categoryId ] = { 
						count : 0 , 
						totalCost : 0 
					}
				}
			}
		} )
	}
	$scope.loadReport3C = function( url ) {
		hideElement( "multi-line-chart-3C" )
		$http.get( url ).then( resp => {
			const products = $scope.products
			$scope.report3C = {
				dat : [] ,
				matrix : [] ,
				months : []
			}
			const report3C = $scope.report3C
			report3C.dat = resp.data
			const dat = report3C.dat
			const matrix = report3C.matrix
			const months = report3C.months
			for( let i = 0 ; i < dat.length ; i ++ ){
				const item = dat[ i ]
				const month = item.month + "-" + item.year
				if( matrix[ month ] == undefined ) matrix[ month ] = []
				matrix[ month ][ item.productId ] = {
					count : item.count ,
					totalCost : item.totalCost 
				}
				if( months.length == 0 ){
					months.push( month )
					continue
				}
				if( !months.includes( month ) ){
					let temp = months[ months.length - 1 ].split( "-" )
					const _month = temp[ 0 ]
					const _year = temp[ 1 ]
					let temp2 = month.split( "-" )
					const nextMonth = temp2[ 0 ]
					const nextYear = temp2[ 1 ]
					const e = new Date( _year , _month - 1 , 1 )
					const s = new Date( nextYear , nextMonth - 1 , 1 ) 
					if( s.getMonth() < 11 ){
						s.setMonth( s.getMonth() + 1 )
					} else {
						s.setFullYear( s.getFullYear() + 1 )
					}
					let date = e
					while( date.getTime() > s.getTime() ) {
						if( date.getMonth() > 0 ){
							date.setMonth( date.getMonth() - 1 )
						} else {
							date.setFullYear( s.getFullYear() - 1 )
						}
						months.push( ( date.getMonth() + 1 ) + "-" + date.getFullYear() )
					}
					months.push( month )
				}
			}
			for( let i = 0 ; i < months.length ; i ++ ){
				const month = months[ i ]
				for( let j = 0 ; j < products.length ; j ++ ){
					const productId = products[ j ].id
					if( matrix[ month ] == undefined ) matrix[ month ] = []
					if( matrix[ month ][ productId ] == undefined ) matrix[ month ][ productId ] = { 
						count : 0 , 
						totalCost : 0 
					}
				}
			}
		} )
	}
	$scope.loadReport4D = function( url ) {
		hideElement( "multi-line-chart-4D" )
		$http.get( url ).then( resp => {
			const categories = $scope.categories
			$scope.report4D = {
				dat : [] ,
				matrix : [] ,
				days : []
			}
			const report4D = $scope.report4D
			report4D.dat = resp.data
			const dat = report4D.dat
			const matrix = report4D.matrix
			const days = report4D.days
			for( let i = 0 ; i < dat.length ; i ++ ){
				const item = dat[ i ]
				const day = item.day + "-" + item.month + "-" + item.year
				if( matrix[ day ] == undefined ) matrix[ day ] = []
				matrix[ day ][ item.categoryId ] = {
					count : item.count ,
					totalCost : item.totalCost 
				}
				if( days.length == 0 ){
					days.push( day )
					continue
				}
				if( !days.includes( day ) ){
					let temp = days[ days.length - 1 ].split( "-" )
					const _day = temp[ 0 ]
					const _month = temp[ 1 ]
					const _year = temp[ 2 ]
					let temp2 = day.split( "-" )
					const nextDay = temp2[ 0 ]
					const nextMonth = temp2[ 1 ]
					const nextYear = temp2[ 2 ]
					const e = new Date( _year , _month - 1 , _day )
					const s = new Date( nextYear , nextMonth - 1 , nextDay ) 
					s.setDate( s.getDate() + 1 )
					let date = e
					while( date.getTime() > s.getTime() ) {
						date.setDate( date.getDate() - 1 )
						days.push( date.getDate() + "-" + ( date.getMonth() + 1 ) + "-" + date.getFullYear() )
					}
					days.push( day )
				}
			}
			for( let i = 0 ; i < days.length ; i ++ ){
				const day = days[ i ]
				for( let j = 0 ; j < categories.length ; j ++ ){
					const categoryId = categories[ j ].id
					if( matrix[ day ] == undefined ) matrix[ day ] = [] 
					if( matrix[ day ][ categoryId ] == undefined ) matrix[ day ][ categoryId ] = { 
						count : 0 , 
						totalCost : 0 
					}
				}
			}
		} )
	}
	$scope.loadReport3D = function( url ) {
		hideElement( "multi-line-chart-3D" )
		$http.get( url ).then( resp => {
			const products = $scope.products
			$scope.report3D = {
				dat : [] ,
				matrix : [] ,
				days : []
			}
			const report3D = $scope.report3D
			report3D.dat = resp.data
			const dat = report3D.dat
			const matrix = report3D.matrix
			const days = report3D.days
			for( let i = 0 ; i < dat.length ; i ++ ){
				const item = dat[ i ]
				const day = item.day + "-" + item.month + "-" + item.year
				if( matrix[ day ] == undefined ) matrix[ day ] = []
				matrix[ day ][ item.productId ] = {
					count : item.count ,
					totalCost : item.totalCost 
				}
				if( days.length == 0 ){
					days.push( day )
					continue
				}
				if( !days.includes( day ) ){
					let temp = days[ days.length - 1 ].split( "-" )
					const _day = temp[ 0 ]
					const _month = temp[ 1 ]
					const _year = temp[ 2 ]
					let temp2 = day.split( "-" )
					const nextDay = temp2[ 0 ]
					const nextMonth = temp2[ 1 ]
					const nextYear = temp2[ 2 ]
					const e = new Date( _year , _month - 1 , _day )
					const s = new Date( nextYear , nextMonth - 1 , nextDay ) 
					s.setDate( s.getDate() + 1 )
					let date = e
					while( date.getTime() > s.getTime() ) {
						date.setDate( date.getDate() - 1 )
						days.push( date.getDate() + "-" + ( date.getMonth() + 1 ) + "-" + date.getFullYear() )
					}
					days.push( day )
				}
			}
			for( let i = 0 ; i < days.length ; i ++ ){
				const day = days[ i ]
				for( let j = 0 ; j < products.length ; j ++ ){
					const productId = products[ j ].id
					if( matrix[ day ] == undefined ) matrix[ day ] = [] 
					if( matrix[ day ][ productId ] == undefined ) matrix[ day ][ productId ] = { 
						count : 0 , 
						totalCost : 0 
					}
				}
			}
		} )
	}
	
	$scope.loadReport4E = function( url ) {
		hideElements( [ "line-chart-4E" , "pie-chart-4E" ] )
		$http.get( url ).then( resp => {
			$scope.report4E = []
			const report4E = $scope.report4E
			const categories = $scope.categories
			const dat = resp.data
			for( let i = 0 ; i < dat.length ; i ++ ){
				const item = dat[ i ]
				report4E[ item.categoryId ] = {
					count : item.count ,
					totalCost : item.totalCost 
				}	
			}
			for( let i = 0 ; i < categories.length ; i ++ ){
				const categoryId = categories[ i ].id
				if( report4E[ categoryId ] == undefined ) report4E[ categoryId ] = { count : 0 , totalCost : 0 }
			}
		} )
	}
	
	$scope.loadReport3E = function( url ) {
		hideElements( [ "line-chart-3E" , "pie-chart-3E" ] )
		$http.get( url ).then( resp => {
			$scope.report3E = []
			const report3E = $scope.report3E
			const products = $scope.products
			const dat = resp.data
			for( let i = 0 ; i < dat.length ; i ++ ){
				const item = dat[ i ]
				report3E[ item.productId ] = {
					count : item.count ,
					totalCost : item.totalCost 
				}	
			}
			for( let i = 0 ; i < products.length ; i ++ ){
				const productId = products[ i ].id
				if( report3E[ productId ] == undefined ) report3E[ productId ] = { count : 0 , totalCost : 0 }
			}
		} )
	}
	
	$scope.showChart1A = function (){
		const chartElement = document.getElementById( "chart-1A" )
		const pieChartElement = document.getElementById( "pie-chart-1A" )
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			pieChartElement.style.height = 0
			return
		}
		const report1A = $scope.report1A
		const chart = new Chart( 
			"TK TỒN KHO THEO LOẠI SẢN PHẨM" ,
			chartElement ,
			"LSP" , "SL" ,
			[ "Ghi chú:" , "LSP: Loại sản phẩm" , "SL: Tổng số lượng sản phẩm tồn kho" ]
		)
		for( let i = 0 ; i < report1A.length ; i ++ ){
			const report = report1A[ i ]
			chart.items.push( 
				new ChartItem( 
					"#" + report.category.id , report.totalQuantity , 
					new Color( { h : i / report1A.length * 360 , s : 100 , l : 45 } ).hex 
				) 
			)
			chart.notes.push( "#" + report.category.id + ": " + report.category.name )
		}
		chart.show()
		const pieChart = new PieChart( 
			"TK TỒN KHO THEO LOẠI SẢN PHẨM" ,
			pieChartElement
		)
		for( let i = 0 ; i < report1A.length ; i ++ ){
			const report = report1A[ i ]
			if( report.count == 0 ) continue
			pieChart.items.push(
				new ChartItem( 
					"#" + report.category.id + " - " + report.category.name , 
					report.totalQuantity , 
					new Color( { h : i / report1A.length * 360 , s : 100 , l : 45 } ).hex
				) 
			)
		}
		pieChart.show()
	}
	
	$scope.showChart1B = function (){
		const chartElement = document.getElementById( "chart-1B" )
		const pieChartElement = document.getElementById( "pie-chart-1B" )
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			pieChartElement.style.height = 0
			return
		}
		const report1B = $scope.report1B
		const chart = new Chart( 
			"TK TỒN KHO THEO THƯƠNG HIỆU" ,
			chartElement ,
			"TH" , "SL" ,
			[ "Ghi chú:" , "TH: Thương hiệu" , "SL: Tổng số lượng sản phẩm tồn kho" ]
		)
		for( let i = 0 ; i < report1B.length ; i ++ ){
			const report = report1B[ i ]
			chart.items.push( 
				new ChartItem( 
					"#" + report.brand.id , report.totalQuantity , 
					new Color( { h : i / report1B.length * 360 , s : 100 , l : 45 } ).hex 
				) 
			)
			chart.notes.push( "#" + report.brand.id + ": " + report.brand.name )
		}
		chart.show()
		const pieChart = new PieChart( 
			"TK TỒN KHO THEO THƯƠNG HIỆU" ,
			pieChartElement
		)
		for( let i = 0 ; i < report1B.length ; i ++ ){
			const report = report1B[ i ]
			if( report.count == 0 ) continue
			pieChart.items.push(
				new ChartItem( 
					"#" + report.brand.id + " - " + report.brand.name , 
					report.totalQuantity , 
					new Color( { h : i / report1B.length * 360 , s : 100 , l : 45 } ).hex
				) 
			)
		}
		pieChart.show()
	}
	
	$scope.showChart2A = function (){
		const chartElement = document.getElementById( "line-chart-2A" )
		const pieChartElement = document.getElementById( "pie-chart-2A" )
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			pieChartElement.style.height = 0
			return
		}
		const report2A = $scope.report2A
		if( report2A.length < 2 ){
			alert( "Không thể tạo biểu đồ!" )
			return
		}
		const chart = new LineChart( 
			"TK " + $scope.filter.forReport2s.g + " THEO NĂM " + $scope.filter.getDateRangeS() , chartElement , "Năm" , "DT/DS" ,
			[ "Ghi chú:" , "DT: Doanh thu ( Đơn vị: Nghìn VNĐ )" , "DS: Doanh số" ]
		)
		for( let i = report2A.length - 1 ; i >= 0 ; i -- ){
			const report = report2A[ i ]
			let value = 0
			switch( $scope.filter.forReport2s.g ){
				case "DOANH SỐ ĐƠN HÀNG" : {
					value = report.count
					break
				}
				case "DOANH SỐ SẢN PHẨM" : {
					value = report.productCount
					break
				}
				case "DOANH THU SẢN PHẨM" : {
					value = report.totalProductCost / 1000
					break
				}
				case "DOANH THU ĐƠN HÀNG" : {
					value = report.totalCost / 1000
				}
			}
			chart.items.push( new ChartItem( report.year.toString() , value , "#336699" ) )
		}
		chart.show()
		const pieChart = new PieChart( 
			"TK " + $scope.filter.forReport2s.g + " THEO NĂM " + $scope.filter.getDateRangeS() , pieChartElement
		)
		for( let i = report2A.length - 1 ; i >= 0 ; i -- ){
			const report = report2A[ i ]
			if( report.count == 0 ) continue
			let value = 0
			switch( $scope.filter.forReport2s.g ){
				case "DOANH SỐ ĐƠN HÀNG" : {
					value = report.count
					break
				}
				case "DOANH SỐ SẢN PHẨM" : {
					value = report.productCount
					break
				}
				case "DOANH THU SẢN PHẨM" : {
					value = report.totalProductCost / 1000
					break
				}
				case "DOANH THU ĐƠN HÀNG" : {
					value = report.totalCost / 1000
				}
			}
			pieChart.items.push( 
				new ChartItem( 
					"Năm " + report.year , 
					value , 
					new Color( { h : 360 - i / report2A.length * 360 , s : 100 , l : 45 } ).hex
				)
				
			)
		}
		pieChart.show()
	}
	
	$scope.showChart2B = function (){		
		const chartElement = document.getElementById( "line-chart-2B" )
		const pieChartElement = document.getElementById( "pie-chart-2B" )
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			pieChartElement.style.height = 0
			return
		}
		const report2B = $scope.report2B
		if( report2B.length < 2 ){
			alert( "Không thể tạo biểu đồ!" )
			return
		}
		const chart = new LineChart( 
			"TK " + $scope.filter.forReport2s.g + " THEO QUÝ " + $scope.filter.getDateRangeS()  ,
			chartElement ,
			"Quý" , "DT/DS" ,
			[ "Ghi chú:" , "DT: Doanh thu ( Đơn vị: Nghìn VNĐ )" , "DS: Doanh số" ]
		)
		for( let i = report2B.length - 1 ; i >= 0 ; i -- ){
			const report = report2B[ i ]
			let value = 0
			switch( $scope.filter.forReport2s.g ){
				case "DOANH SỐ ĐƠN HÀNG" : {
					value = report.count
					break
				}
				case "DOANH SỐ SẢN PHẨM" : {
					value = report.productCount
					break
				}
				case "DOANH THU SẢN PHẨM" : {
					value = report.totalProductCost / 1000
					break
				}
				case "DOANH THU ĐƠN HÀNG" : {
					value = report.totalCost / 1000
				}
			}
			chart.items.push( new ChartItem( report.quarter + "/" + report.year , value , "#336699" ) )
		}
		chart.show()
		const pieChart = new PieChart( 
			"TK " + $scope.filter.forReport2s.g + " THEO QUÝ " + $scope.filter.getDateRangeS() , pieChartElement
		)
		for( let i = report2B.length - 1 ; i >= 0 ; i -- ){
			const report = report2B[ i ]
			if( report.count == 0 ) continue
			let value = 0
			switch( $scope.filter.forReport2s.g ){
				case "DOANH SỐ ĐƠN HÀNG" : {
					value = report.count
					break
				}
				case "DOANH SỐ SẢN PHẨM" : {
					value = report.productCount
					break
				}
				case "DOANH THU SẢN PHẨM" : {
					value = report.totalProductCost / 1000
					break
				}
				case "DOANH THU ĐƠN HÀNG" : {
					value = report.totalCost / 1000
				}
			}
			pieChart.items.push( 
				new ChartItem( 
					"Quý " + report.quarter + "/" + report.year , 
					value , 
					new Color( { h : 360 - i / report2B.length * 360 , s : 100 , l : 45 } ).hex
				)
			)
		}
		pieChart.show()
	}
	
	$scope.showChart2C = function (){
		const chartElement = document.getElementById( "line-chart-2C" )
		const pieChartElement = document.getElementById( "pie-chart-2C" )
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			pieChartElement.style.height = 0
			return
		}
		const report2C = $scope.report2C
		if( report2C.length < 2 ){
			alert( "Không thể tạo biểu đồ!" )
			return
		}
		const chart = new LineChart( 
			"TK " + $scope.filter.forReport2s.g + " THEO THÁNG " + $scope.filter.getDateRangeS()  ,
			chartElement ,
			"Tháng" , "DT" ,
			[ "Ghi chú:" , "DT: Doanh thu ( Đơn vị: Nghìn VNĐ )" , "DS: Doanh số" ]
		)
		for( let i = report2C.length - 1 ; i >= 0 ; i -- ){
			const report = report2C[ i ]
			let value = 0
			switch( $scope.filter.forReport2s.g ){
				case "DOANH SỐ ĐƠN HÀNG" : {
					value = report.count
					break
				}
				case "DOANH SỐ SẢN PHẨM" : {
					value = report.productCount
					break
				}
				case "DOANH THU SẢN PHẨM" : {
					value = report.totalProductCost / 1000
					break
				}
				case "DOANH THU ĐƠN HÀNG" : {
					value = report.totalCost / 1000
				}
			}
			chart.items.push( new ChartItem( report.month + "/" + report.year , value , "#336699" ) )
		}
		chart.show()
		const pieChart = new PieChart( 
			"TK " + $scope.filter.forReport2s.g + " THEO THÁNG " + $scope.filter.getDateRangeS() , pieChartElement
		)
		for( let i = report2C.length - 1 ; i >= 0 ; i -- ){
			const report = report2C[ i ]
			if( report.count == 0 ) continue
			let value = 0
			switch( $scope.filter.forReport2s.g ){
				case "DOANH SỐ ĐƠN HÀNG" : {
					value = report.count
					break
				}
				case "DOANH SỐ SẢN PHẨM" : {
					value = report.productCount
					break
				}
				case "DOANH THU SẢN PHẨM" : {
					value = report.totalProductCost / 1000
					break
				}
				case "DOANH THU ĐƠN HÀNG" : {
					value = report.totalCost / 1000
				}
			}
			pieChart.items.push( 
				new ChartItem( 
					"Tháng " + report.month + "/" + report.year , 
					value , 
					new Color( { h : 360 - i / report2C.length * 360 , s : 100 , l : 45 } ).hex
				)
			)
		}
		pieChart.show()
	}
	
	$scope.showChart2D = function (){
		const chartElement = document.getElementById( "line-chart-2D" )
		const pieChartElement = document.getElementById( "pie-chart-2D" )
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			pieChartElement.style.height = 0
			return
		}
		const report2D = $scope.report2D
		if( report2D.length < 2 ){
			alert( "Không thể tạo biểu đồ!" )
			return
		}
		const chart = new LineChart( 
			"TK DOANH THU ĐƠN HÀNG THEO NGÀY " + $scope.filter.getDateRangeS()  ,
			chartElement ,
			"Ngày" , "DT" ,
			[ "Ghi chú:" , "DT: Doanh thu ( Đơn vị: Nghìn VNĐ )" ]
		)
		for( let i = report2D.length - 1 ; i >= 0 ; i -- ){
			const report = report2D[ i ]
			chart.items.push( new ChartItem( report.day + "/" + report.month + "/" + report.year , report.totalCost / 1000 , "#336699" ) )
		}
		chart.show()
		const pieChart = new PieChart( 
			"TK " + $scope.filter.forReport2s.g + " THEO NGÀY " + $scope.filter.getDateRangeS()  , pieChartElement
		)
		for( let i = report2D.length - 1 ; i >= 0 ; i -- ){
			const report = report2D[ i ]
			if( report.count == 0 ) continue
			let value = 0
			switch( $scope.filter.forReport2s.g ){
				case "DOANH SỐ ĐƠN HÀNG" : {
					value = report.count
					break
				}
				case "DOANH SỐ SẢN PHẨM" : {
					value = report.productCount
					break
				}
				case "DOANH THU SẢN PHẨM" : {
					value = report.totalProductCost / 1000
					break
				}
				case "DOANH THU ĐƠN HÀNG" : {
					value = report.totalCost / 1000
				}
			}
			pieChart.items.push( 
				new ChartItem( 
					"Ngày " + report.day + "/" + report.month + "/" + report.year , 
					value , 
					new Color( { h : 360 - i / report2D.length * 360 , s : 100 , l : 45 } ).hex
				)
			)
		}
		pieChart.show()
	}
	
	$scope.showChart4A = function (){
		const chartElement = document.getElementById( "multi-line-chart-4A" )
		const mode = $scope.filter.mode
		const report4A = $scope.report4A
		const matrix = report4A.matrix
		const years = report4A.years
		const categories = $scope.categories
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			return
		}
		const chart = new MultiLineChart( 
			"TK " + ( mode == 0 ? "DOANH THU" : "DOANH SỐ" ) + " LOẠI SẢN PHẨM THEO NĂM " + $scope.filter.getDateRangeS() ,
			chartElement ,
			"Năm" , mode == 0 ? "DT" : "DS" , 
			[ "Ghi chú:" , mode == 0 ? "DT: Doanh thu loại sản phẩm ( Đơn vị: Nghìn VNĐ )" : "DS: Doanh số loại sản phẩm" ] ,
		)
		for( let i = 0 ; i < categories.length ; i ++ ){
			const category = categories[ i ]
			chart.items.push( {
				name : "#" + category.id + " - " + category.name ,
				color : new Color( { h : i / categories.length * 360 , s : 100 , l : 45 } ).hex ,
				items : []
			} )
			const items = chart.items[ chart.items.length - 1 ].items
			for( let j = years.length - 1 ; j >= 0 ; j -- ){
				const year = years[ j ]
				const report = matrix[ year ][ category.id ]
				items.push( 
					new ChartItem(
						year.toString() ,
						mode == 0 ? report.totalCost / 1000 : report.count
					)
				)
			}
		}
		chart.show()
	}
	$scope.showChart3A = function (){
		const chartElement = document.getElementById( "multi-line-chart-3A" )
		const mode = $scope.filter.mode2
		const report3A = $scope.report3A
		const matrix = report3A.matrix
		const years = report3A.years
		const products = $scope.products
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			return
		}
		const chart = new MultiLineChart( 
			"TK " + ( mode == 0 ? "DOANH THU" : "DOANH SỐ" ) + " TỪNG SẢN PHẨM THEO NĂM " + $scope.filter.getDateRangeS() ,
			chartElement ,
			"Năm" , mode == 0 ? "DT" : "DS" , 
			[ "Ghi chú:" , mode == 0 ? "DT: Doanh thu từng sản phẩm ( Đơn vị: Nghìn VNĐ )" : "DS: Doanh số từng sản phẩm" ] ,
		)
		for( let i = 0 ; i < products.length ; i ++ ){
			const product = products[ i ]
			chart.items.push( {
				name : "#" + product.id + " - " + product.name ,
				color : new Color( { h : i / products.length * 360 , s : 100 , l : 45 } ).hex ,
				items : []
			} )
			const items = chart.items[ chart.items.length - 1 ].items
			for( let j = years.length - 1 ; j >= 0 ; j -- ){
				const year = years[ j ]
				const report = matrix[ year ][ product.id ]
				items.push( 
					new ChartItem(
						year.toString() ,
						mode == 0 ? report.totalCost / 1000 : report.count
					)
				)
			}
		}
		chart.show()
	}
	$scope.showChart4B = function (){
		const chartElement = document.getElementById( "multi-line-chart-4B" )
		const mode = $scope.filter.mode
		const report4B = $scope.report4B
		const matrix = report4B.matrix
		const quarters = report4B.quarters
		const categories = $scope.categories
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			return
		}
		const chart = new MultiLineChart( 
			"TK " + ( mode == 0 ? "DOANH THU" : "DOANH SỐ" ) + " LOẠI SẢN PHẨM THEO QUÝ " + $scope.filter.getDateRangeS() ,
			chartElement,
			"Quý" , mode == 0 ? "DT" : "DS" , 
			[ "Ghi chú:" , mode == 0 ? "DT: Doanh thu loại sản phẩm ( Đơn vị: Nghìn VNĐ )" : "DS: Doanh số loại sản phẩm" ] ,
		)
		for( let i = 0 ; i < categories.length ; i ++ ){
			const category = categories[ i ]
			chart.items.push( {
				name : "#" + category.id + " - " + category.name ,
				color : new Color( { h : i / categories.length * 360 , s : 100 , l : 45 } ).hex ,
				items : []
			} )
			const items = chart.items[ chart.items.length - 1 ].items
			for( let j = quarters.length - 1 ; j >= 0 ; j -- ){
				const quarter = quarters[ j ]
				const report = matrix[ quarter ][ category.id ]
				items.push( 
					new ChartItem(
						quarter ,
						mode == 0 ? report.totalCost / 1000 : report.count
					)
				)
			}
		}
		chart.show()
	}
	$scope.showChart3B = function (){
		const chartElement = document.getElementById( "multi-line-chart-3B" )
		const mode = $scope.filter.mode2
		const report3B = $scope.report3B
		const matrix = report3B.matrix
		const quarters = report3B.quarters
		const products = $scope.products
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			return
		}
		const chart = new MultiLineChart( 
			"TK " + ( mode == 0 ? "DOANH THU" : "DOANH SỐ" ) + " TỪNG SẢN PHẨM THEO QUÝ " + $scope.filter.getDateRangeS() ,
			chartElement,
			"Quý" , mode == 0 ? "DT" : "DS" , 
			[ "Ghi chú:" , mode == 0 ? "DT: Doanh thu từng sản phẩm ( Đơn vị: Nghìn VNĐ )" : "DS: Doanh số từng sản phẩm" ] ,
		)
		for( let i = 0 ; i < products.length ; i ++ ){
			const product = products[ i ]
			chart.items.push( {
				name : "#" + product.id + " - " + product.name ,
				color : new Color( { h : i / products.length * 360 , s : 100 , l : 45 } ).hex ,
				items : []
			} )
			const items = chart.items[ chart.items.length - 1 ].items
			for( let j = quarters.length - 1 ; j >= 0 ; j -- ){
				const quarter = quarters[ j ]
				const report = matrix[ quarter ][ product.id ]
				items.push( 
					new ChartItem(
						quarter ,
						mode == 0 ? report.totalCost / 1000 : report.count
					)
				)
			}
		}
		chart.show()
	}
	$scope.showChart4C = function (){
		const chartElement = document.getElementById( "multi-line-chart-4C" )
		const mode = $scope.filter.mode
		const report4C = $scope.report4C
		const matrix = report4C.matrix
		const months = report4C.months
		const categories = $scope.categories
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			return
		}
		const chart = new MultiLineChart( 
			"TK " + ( mode == 0 ? "DOANH THU" : "DOANH SỐ" ) + " LOẠI SẢN PHẨM THEO THÁNG " + $scope.filter.getDateRangeS() ,
			chartElement,
			"Tháng" , mode == 0 ? "DT" : "DS" , 
			[ "Ghi chú:" , mode == 0 ? "DT: Doanh thu loại sản phẩm ( Đơn vị: Nghìn VNĐ )" : "DS: Doanh số loại sản phẩm" ] ,
		)
		for( let i = 0 ; i < categories.length ; i ++ ){
			const category = categories[ i ]
			chart.items.push( {
				name : "#" + category.id + " - " + category.name ,
				color : new Color( { h : i / categories.length * 360 , s : 100 , l : 45 } ).hex ,
				items : []
			} )
			const items = chart.items[ chart.items.length - 1 ].items
			for( let j = months.length - 1 ; j >= 0 ; j -- ){
				const month = months[ j ]
				const report = matrix[ month ][ category.id ]
				items.push( 
					new ChartItem(
						month ,
						mode == 0 ? report.totalCost / 1000 : report.count
					)
				)
			}
		}
		chart.show()
	}
	$scope.showChart3C = function (){
		const chartElement = document.getElementById( "multi-line-chart-3C" )
		const mode = $scope.filter.mode2
		const report3C = $scope.report3C
		const matrix = report3C.matrix
		const months = report3C.months
		const products = $scope.products
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			return
		}
		const chart = new MultiLineChart( 
			"TK " + ( mode == 0 ? "DOANH THU" : "DOANH SỐ" ) + " TỪNG SẢN PHẨM THEO THÁNG " + $scope.filter.getDateRangeS() ,
			chartElement,
			"Tháng" , mode == 0 ? "DT" : "DS" , 
			[ "Ghi chú:" , mode == 0 ? "DT: Doanh thu từng sản phẩm ( Đơn vị: Nghìn VNĐ )" : "DS: Doanh số từng sản phẩm" ] ,
		)
		for( let i = 0 ; i < products.length ; i ++ ){
			const product = products[ i ]
			chart.items.push( {
				name : "#" + product.id + " - " + product.name ,
				color : new Color( { h : i / products.length * 360 , s : 100 , l : 45 } ).hex ,
				items : []
			} )
			const items = chart.items[ chart.items.length - 1 ].items
			for( let j = months.length - 1 ; j >= 0 ; j -- ){
				const month = months[ j ]
				const report = matrix[ month ][ product.id ]
				items.push( 
					new ChartItem(
						month ,
						mode == 0 ? report.totalCost / 1000 : report.count
					)
				)
			}
		}
		chart.show()
	}
	$scope.showChart4D = function (){
		const chartElement = document.getElementById( "multi-line-chart-4D" )
		const mode = $scope.filter.mode
		const report4D = $scope.report4D
		const matrix = report4D.matrix
		const days = report4D.days
		const categories = $scope.categories
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			return
		}
		const chart = new MultiLineChart( 
			"TK " + ( mode == 0 ? "DOANH THU" : "DOANH SỐ" ) + " LOẠI SẢN PHẨM THEO NGÀY " + $scope.filter.getDateRangeS() ,
			chartElement,
			"Ngày" , mode == 0 ? "DT" : "DS" , 
			[ "Ghi chú:" , mode == 0 ? "DT: Doanh thu loại sản phẩm ( Đơn vị: Nghìn VNĐ )" : "DS: Doanh số loại sản phẩm" ] ,
		)
		for( let i = 0 ; i < categories.length ; i ++ ){
			const category = categories[ i ]
			chart.items.push( {
				name : "#" + category.id + " - " + category.name ,
				color : new Color( { h : i / categories.length * 360 , s : 100 , l : 45 } ).hex ,
				items : []
			} )
			const items = chart.items[ chart.items.length - 1 ].items
			for( let j = days.length - 1 ; j >= 0 ; j -- ){
				const day = days[ j ]
				const report = matrix[ day ][ category.id ]
				items.push( 
					new ChartItem(
						day ,
						mode == 0 ? report.totalCost / 1000 : report.count
					)
				)
			}
		}
		chart.show()
	}
	$scope.showChart3D = function (){
		const chartElement = document.getElementById( "multi-line-chart-3D" )
		const mode = $scope.filter.mode2
		const report3D = $scope.report3D
		const matrix = report3D.matrix
		const days = report3D.days
		const products = $scope.products
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			return
		}
		const chart = new MultiLineChart( 
			"TK " + ( mode == 0 ? "DOANH THU" : "DOANH SỐ" ) + " TỪNG SẢN PHẨM THEO NGÀY " + $scope.filter.getDateRangeS() ,
			chartElement,
			"Ngày" , mode == 0 ? "DT" : "DS" , 
			[ "Ghi chú:" , mode == 0 ? "DT: Doanh thu từng sản phẩm ( Đơn vị: Nghìn VNĐ )" : "DS: Doanh số từng sản phẩm" ] ,
		)
		for( let i = 0 ; i < products.length ; i ++ ){
			const product = products[ i ]
			chart.items.push( {
				name : "#" + product.id + " - " + product.name ,
				color : new Color( { h : i / products.length * 360 , s : 100 , l : 45 } ).hex ,
				items : []
			} )
			const items = chart.items[ chart.items.length - 1 ].items
			for( let j = days.length - 1 ; j >= 0 ; j -- ){
				const day = days[ j ]
				const report = matrix[ day ][ product.id ]
				items.push( 
					new ChartItem(
						day ,
						mode == 0 ? report.totalCost / 1000 : report.count
					)
				)
			}
		}
		chart.show()
	}
	$scope.showChart4E = function (){
		const chartElement = document.getElementById( "line-chart-4E" )
		const pieChartElement = document.getElementById( "pie-chart-4E" )
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			pieChartElement.style.height = 0
			return
		}
		const mode = $scope.filter.mode2
		const report4E = $scope.report4E
		const categories = $scope.categories
		const chart = new Chart( 
			"TK TỔNG HỢP " + ( mode == 0 ? "DOANH THU" : "DOANH SỐ" ) + " LOẠI SẢN PHẨM " + $scope.filter.getDateRangeS() ,
			chartElement ,
			"LSP" , mode == 0 ? "DT" : "DS" ,
			[ "Ghi chú:" , "LSP: Loại sản phẩm" , mode == 0 ? "DT: Doanh thu loại sản phẩm ( Đơn vị: Nghìn VNĐ )" : "DS: Doanh số loại sản phẩm" ]
		)
		for( let i = 0 ; i < categories.length ; i ++ ){
			const category = categories[ i ]
			const report = report4E[ category.id ]
			chart.items.push( new ChartItem( "#" + category.id , mode == 0 ? report.totalCost / 1000 : report.count , new Color( { h : i / categories.length * 360 , s : 100 , l : 45 } ).hex ) )
			chart.notes.push( "#" + category.id + ": " + category.name )
		}
		chart.show()
		const pieChart = new PieChart( 
			"TK TỔNG HỢP " + ( mode == 0 ? "DOANH THU" : "DOANH SỐ" ) + " LOẠI SẢN PHẨM " + $scope.filter.getDateRangeS() ,
			pieChartElement
		)
		for( let i = 0 ; i < categories.length ; i ++ ){
			const category = categories[ i ]
			const report = report4E[ category.id ]
			if( report.count == 0 ) continue
			pieChart.items.push(
				new ChartItem( 
					"#" + category.id + " - " + category.name , 
					mode == 0 ? report.totalCost : report.count , 
					new Color( { h : i / categories.length * 360 , s : 100 , l : 45 } ).hex 
				) 
			)
			chart.items.push( new ChartItem( "#" + category.id , mode == 0 ? report.totalCost : report.count , "#336699" ) )
		}
		pieChart.show()
	}
	$scope.showChart3E = function (){
		const chartElement = document.getElementById( "line-chart-3E" )
		const pieChartElement = document.getElementById( "pie-chart-3E" )
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			pieChartElement.style.height = 0
			return
		}
		const mode = $scope.filter.mode
		const report3E = $scope.report3E
		const products = $scope.products
		const chart = new Chart( 
			"TK TỔNG HỢP " + ( mode == 0 ? "DOANH THU" : "DOANH SỐ" ) + " TỪNG SẢN PHẨM " + $scope.filter.getDateRangeS() ,
			chartElement ,
			"SP" , mode == 0 ? "DT" : "DS" ,
			[ "Ghi chú:" , "SP: Sản phẩm" , mode == 0 ? "DT: Doanh thu từng sản phẩm ( Đơn vị: Nghìn VNĐ )" : "DS: Doanh số từng sản phẩm" ]
		)
		for( let i = 0 ; i < products.length ; i ++ ){
			const product = products[ i ]
			const report = report3E[ product.id ]
			chart.items.push( new ChartItem( "#" + product.id , mode == 0 ? report.totalCost / 1000 : report.count , new Color( { h : i / products.length * 360 , s : 100 , l : 45 } ).hex ) )
			chart.notes.push( "#" + product.id + ": " + product.name )
		}
		chart.show()
		const pieChart = new PieChart( 
			"TK TỔNG HỢP " + ( mode == 0 ? "DOANH THU" : "DOANH SỐ" ) + " LOẠI SẢN PHẨM " + $scope.filter.getDateRangeS() ,
			pieChartElement
		)
		for( let i = 0 ; i < products.length ; i ++ ){
			const product = products[ i ]
			const report = report3E[ product.id ]
			if( report.count == 0 ) continue
			pieChart.items.push(
				new ChartItem( 
					"#" + product.id + " - " + product.name , 
					mode == 0 ? report.totalCost : report.count , 
					new Color( { h : i / products.length * 360 , s : 100 , l : 45 } ).hex 
				) 
			)
			chart.items.push( new ChartItem( "#" + product.id , mode == 0 ? report.totalCost : report.count , "#336699" ) )
		}
		pieChart.show()
	}
	$scope.initialize()
} )