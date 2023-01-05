class PieChart {
	
	constructor( title , canvas ){
		this.title = title.fontSize == undefined ? new Text( title , null , 20 ) : this.title
		this.canvas = new Canvas( canvas )
		this.items = []
		this.descriptionSize = null
		this.fontSize = null
		this.p0 = null
		this.r = null
		this.totalValue = null
	}
	
	getDescriptionSize = () => {
		let sMax = 0
		for( let i = 0 ; i < this.items.length ; i ++ ){
			const item = this.items[ i ]
			const s = item.name + ": " + item.value + " [" + Math.round( ( item.value / this.totalValue * 100 ) * 100 ) / 100 + "%]"
			sMax = Math.max( sMax , s.length )
		}
		const x = 0.55 * sMax * this.fontSize + this.fontSize * 2
		const y = this.items.length * ( this.fontSize * 2 + 0 ) + this.fontSize + 20
		return new Size( x , y )
	}
	
	getTotalValue = () => {
		let total = 0
		for( let i = 0 ; i < this.items.length ; i ++ ) total += this.items[ i ].value
		return total
	}
	
	getMaxValue = () => {
		const max = this.getMaxItemValue()
		let max1 = 1
		let max2 = 2
		let max3 = 5
		while( max1 < max ) max1 *= 10
		while( max2 < max ) max2 *= 10
		while( max3 < max ) max3 *= 10
		return Math.min( max1 , max2 , max3 )
	} 
	
	getR = () => 100 + this.items.length * 2
	
	getP = () => {
		const ele = this.canvas.ele
		return new P( 
			ele.width / 2 - ( this.r * 2 + 30 + this.descriptionSize.x ) / 2 + this.r ,
			this.r + this.title.getSize().y + this.fontSize * 1.5 + 20 
		)
	}

	show = () => {
		const can = this.canvas
		const ele = this.canvas.ele
		this.fontSize = this.fontSize == null ? 14 : this.fontSize
		this.totalValue = this.getTotalValue()
		this.r = this.getR()
		this.descriptionSize = this.getDescriptionSize()
		ele.width = Math.max( 70 + this.r * 2 + this.descriptionSize.x , 20 * 2 + this.title.getSize().x )
		ele.height = this.title.getSize().y + this.fontSize * 1.5 + Math.max( this.descriptionSize.y , this.r * 2 ) + 40 - this.fontSize / 2
		ele.style.width = ele.width + "px"
		ele.style.height = ele.height + "px"
		this.p = this.getP()
		if( this.title.p == null ){
			const titleSize = this.title.getSize()
			this.title.p = this.title.p == null ? new P( ele.width / 2 - titleSize.x / 2 , titleSize.y + this.fontSize * 1.5 ) : this.title.p
		}
		can.CLR()
		can.FLT( this.title , "#333333" )
		let temp = 0
		for( let i = 0 ; i < this.items.length ; i ++ ){
			const item = this.items[ i ]
			let s = Math.round( temp / this.totalValue * 360 ) - 90
			let e = Math.round( ( item.value + temp ) / this.totalValue * 360 ) + 0.5 - 90
			can.BGP()
			can.ARC( this.p , this.r , s , e , 0 )
			can.LNT( this.p )
			can.FLL( item.color )
			temp += item.value
		}
		can.FLT( 
			new Text( 
				new Date().toLocaleString() , 
				new P( this.fontSize * 1.5 , this.fontSize * 1.5 ) , 
				this.fontSize 
			) , 
			"#333333" 
		)
		can.FLT( new Text( "Chú thích:" , new P( this.p.x + this.r + 30 , this.title.getSize().y + this.fontSize * 2.5 + 20 ) , this.fontSize ) , "#333333" )
		for( let i = 0 ; i < this.items.length ; i ++ ){
			const item = this.items[ i ]
			const p = new P( this.p.x + this.r + 30 , this.title.getSize().y + this.fontSize * 2.5 + i * this.fontSize * 2 + 40 )
			can.RCT( new Rectangle( p , new Size( this.fontSize * 1.5 , this.fontSize * 1.5 ) ) )
			can.FLL( item.color )
			can.FLT( new Text( 
					item.name + ": " + item.value + " [" + Math.round( ( item.value / this.totalValue * 100 ) * 100 ) / 100 + "%]" ,  
					new P( p.x + this.fontSize * 2 , 
					p.y + this.fontSize 
				) 
				, this.fontSize 
			) , "#333333" )
		}		
	}
}