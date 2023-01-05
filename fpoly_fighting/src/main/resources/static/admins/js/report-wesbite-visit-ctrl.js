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
app.controller( "report-website-visit-ctrl" , function( $scope , $http ){
	$scope.report5A = {}
	$scope.report5B = {}
	$scope.report5C = {}
	$scope.report5D = {}
	$scope.report5E = {}
	$scope.filter = {
		startDate: new Date( "2021/06/01" ) ,
		endDate : new Date() ,
		getDateRangeS(){
			const startDate = this.startDate.getDate() + "/" + ( this.startDate.getMonth() + 1 ) + "/" + this.startDate.getFullYear()
			const endDate = this.endDate.getDate() + "/" + ( this.endDate.getMonth() + 1 ) + "/" + this.endDate.getFullYear()
			return "TỪ " + startDate + " ĐẾN " + endDate
		} ,
		reset(){
			this.startDate = new Date( "2021/06/01" )
			this.endDate = new Date()
		} ,
		filt(){
			const dateRangeS = "?startDate=" + this.startDate.getTime() + "&endDate=" + this.endDate.getTime()
			$scope.loadReport5A( "/rest/reports/5A" + dateRangeS )
			$scope.loadReport5B( "/rest/reports/5B" + dateRangeS )
			$scope.loadReport5C( "/rest/reports/5C" + dateRangeS )
			$scope.loadReport5D( "/rest/reports/5D" + dateRangeS )
			$scope.loadReport5E( "/rest/reports/5E" + dateRangeS )
		}
	}
	$scope.initialize = function(){
		$scope.loadReport5A( "/rest/reports/5A" )
		$scope.loadReport5B( "/rest/reports/5B" )
		$scope.loadReport5C( "/rest/reports/5C" )
		$scope.loadReport5D( "/rest/reports/5D" )
		$scope.loadReport5E( "/rest/reports/5E" )
	}
	$scope.loadReport5A = function( url ) {
		hideElements( [ "line-chart-5A" , "pie-chart-5A" ] )
		$http.get( url ).then( resp => {
			$scope.report5A = resp.data
		} )
	}
	$scope.loadReport5B = function( url ) {
		hideElements( "line-chart-5B" , "pie-chart-5B" )
		$http.get( url ).then( resp => {
			$scope.report5B = []
			const reports = resp.data
			for( let i = 0 ; i < reports.length ; i ++ ){
				const report = reports[ i ]
				$scope.report5B.push( report )
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
					$scope.report5B.push( {
						year : date.getFullYear() ,
						quarter : ( date.getMonth() + 1 ) / 3 ,
						count : 0
					} )
				}
			}
		} )
	}
	$scope.loadReport5C = function( url ) {
		hideElements( [ "line-chart-5C" , "pie-chart-5C" ] )
		$http.get( url ).then( resp => {
			$scope.report5C = []
			const reports = resp.data
			for( let i = 0 ; i < reports.length ; i ++ ){
				const report = reports[ i ]
				$scope.report5C.push( report )
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
					$scope.report5C.push( {
						year : date.getFullYear() ,
						month : date.getMonth() + 1 ,
						count : 0
					} )
				}
			}
		} )
	}
	$scope.loadReport5D = function( url ) {
		hideElements( [ "line-chart-5D" , "pie-chart-5D" ] )
		$http.get( url ).then( resp => {
			$scope.report5D = []
			const reports = resp.data
			for( let i = 0 ; i < reports.length ; i ++ ){
				const report = reports[ i ]
				$scope.report5D.push( report )
				if( i == reports.length - 1 ) break
				nextReport = reports[ i + 1 ]
				const e = new Date( report.year , report.month - 1 , report.day )
				const s = new Date( nextReport.year , nextReport.month - 1 , nextReport.day ) 
				s.setDate( s.getDate() + 1 )
				let date = e
				while( date.getTime() > s.getTime() ) {
					date.setDate( date.getDate() - 1 )
					$scope.report5D.push( {
						year : date.getFullYear() ,
						month : date.getMonth() + 1 ,
						day : date.getDate() ,
						count : 0
					} )
				}
			}
		} )
	}
	$scope.loadReport5E = function( url ) {
		$http.get( url ).then( resp => {
			$scope.report5E = resp.data
		} )
	}
	$scope.showChart5A = function (){
		const chartElement = document.getElementById( "line-chart-5A" )
		const pieChartElement = document.getElementById( "pie-chart-5A" )
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			pieChartElement.style.height = 0
			return
		}
		const report5A = $scope.report5A
		if( report5A.length < 2 ){
			alert( "Không thể tạo biểu đồ!" )
			return
		}
		const chart = new LineChart( 
			"TK LƯỢT TRUY CẬP THEO NĂM " + $scope.filter.getDateRangeS() , chartElement , "Năm" , "SL" ,
			[ "Ghi chú:" , "SL: Tổng số lượt truy cập website" ]
		)
		for( let i = report5A.length - 1 ; i >= 0 ; i -- ){
			const report = report5A[ i ]
			chart.items.push( new ChartItem( report.year.toString() , report.count , "#336699" ) )
		}
		chart.show()
		const pieChart = new PieChart( 
			"TK LƯỢT TRUY CẬP THEO NĂM " + $scope.filter.getDateRangeS() , pieChartElement
		)
		for( let i = report5A.length - 1 ; i >= 0 ; i -- ){
			const report = report5A[ i ]
			if( report.count == 0 ) continue
			pieChart.items.push( 
				new ChartItem( 
					"Năm " + report.year , 
					report.count , 
					new Color( { h : 360 - i / report5A.length * 360 , s : 100 , l : 45 } ).hex
				)
			)
		}
		pieChart.show()
	}
	$scope.showChart5B = function (){
		const chartElement = document.getElementById( "line-chart-5B" )
		const pieChartElement = document.getElementById( "pie-chart-5B" )
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			pieChartElement.style.height = 0
			return
		}
		const report5B = $scope.report5B
		if( report5B.length < 2 ){
			alert( "Không thể tạo biểu đồ!" )
			return
		}
		const chart = new LineChart( 
			"TK LƯỢT TRUY CẬP THEO QUÝ " + $scope.filter.getDateRangeS() , chartElement , "Quý" , "SL" ,
			[ "Ghi chú:" , "SL: Tổng số lượt truy cập website" ]
		)
		for( let i = report5B.length - 1 ; i >= 0 ; i -- ){
			const report = report5B[ i ]
			chart.items.push( new ChartItem( "Quý " + report.quarter + "/" + report.year , report.count , "#336699" ) )
		}
		chart.show()
		const pieChart = new PieChart( 
			"TK LƯỢT TRUY CẬP THEO QUÝ " + $scope.filter.getDateRangeS() , pieChartElement
		)
		for( let i = report5B.length - 1 ; i >= 0 ; i -- ){
			const report = report5B[ i ]
			if( report.count == 0 ) continue
			pieChart.items.push( 
				new ChartItem( 
					"Quý " + report.quarter + "/" + report.year , 
					report.count , 
					new Color( { h : 360 - i / report5B.length * 360 , s : 100 , l : 45 } ).hex
				)
			)
		}
		pieChart.show()
	}
	$scope.showChart5C = function (){
		const chartElement = document.getElementById( "line-chart-5C" )
		const pieChartElement = document.getElementById( "pie-chart-5C" )
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			pieChartElement.style.height = 0
			return
		}
		const report5C = $scope.report5C
		if( report5C.length < 2 ){
			alert( "Không thể tạo biểu đồ!" )
			return
		}
		const chart = new LineChart( 
			"TK LƯỢT TRUY CẬP THEO THÁNG " + $scope.filter.getDateRangeS()  ,
			chartElement ,
			"Tháng" , "SL" ,
			[ "Ghi chú:" , "SL: Tổng số lượt truy cập website" ]
		)
		for( let i = report5C.length - 1 ; i >= 0 ; i -- ){
			const report = report5C[ i ]
			chart.items.push( new ChartItem( "Tháng " + report.month + "/" + report.year , report.count , "#336699" ) )
		}
		chart.show()
		const pieChart = new PieChart( 
			"TK LƯỢT TRUY CẬP THEO THÁNG " + $scope.filter.getDateRangeS() , pieChartElement
		)
		for( let i = report5C.length - 1 ; i >= 0 ; i -- ){
			const report = report5C[ i ]
			if( report.count == 0 ) continue
			pieChart.items.push( 
				new ChartItem( 
					"Tháng " + report.month + "/" + report.year , 
					report.count , 
					new Color( { h : 360 - i / report5C.length * 360 , s : 100 , l : 45 } ).hex
				)
			)
		}
		pieChart.show()
	}
	$scope.showChart5D = function (){
		const chartElement = document.getElementById( "line-chart-5D" )
		const pieChartElement = document.getElementById( "pie-chart-5D" )
		if( chartElement.style.height != "0px" ){
			chartElement.style.height = 0
			pieChartElement.style.height = 0
			return
		}
		const report5D = $scope.report5D
		if( report5D.length < 2 || report5D.length > 200 ){
			alert( "Không thể tạo biểu đồ vì dữ liệu quá ít hoặc quá nhiều!" )
			return
		}
		const chart = new LineChart( 
			"TK LƯỢT TRUY CẬP THEO NGÀY " + $scope.filter.getDateRangeS()  ,
			chartElement ,
			"Ngày" , "DT" ,
			[ "Ghi chú:" , "DT: Doanh thu ( Đơn vị: Nghìn VNĐ )" ]
		)
		for( let i = report5D.length - 1 ; i >= 0 ; i -- ){
			const report = report5D[ i ]
			chart.items.push( new ChartItem( report.day + "/" + report.month + "/" + report.year , report.count , "#336699" ) )
		}
		chart.show()
		const pieChart = new PieChart( 
			"TK LƯỢT TRUY CẬP THEO NGÀY " + $scope.filter.getDateRangeS()  , pieChartElement
		)
		for( let i = report5D.length - 1 ; i >= 0 ; i -- ){
			const report = report5D[ i ]
			if( report.count == 0 ) continue
			pieChart.items.push( 
				new ChartItem( 
					"Ngày " + report.day + "/" + report.month + "/" + report.year , 
					report.count , 
					new Color( { h : 360 - i / report5D.length * 360 , s : 100 , l : 45 } ).hex
				)
			)
		}
		pieChart.show()
	}
	$scope.initialize()
	
} )