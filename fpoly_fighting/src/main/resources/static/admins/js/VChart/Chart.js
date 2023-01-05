class ChartItem {
	constructor( name , value , color ){
		this.name = name
		this.value = value
		this.color = color
	}
}

class Chart {
	
	constructor( title , canvas , itemLabel , valueLabel , notes ){
		this.title = title.fontSize == undefined ? new Text( title , null , 20 ) : this.title
		this.canvas = new Canvas( canvas )
		this.itemLabel = itemLabel
		this.valueLabel = valueLabel
		this.items = []
		this.notes = notes
		this.itemSize = 0
		this.fontSize = null
		this.p0 = null
		this.partValue = null
		this.maxValue = null
		this.maxLevel = null
		this.partSize = null
		this.size = null
		this.itemLineWidth = null
		this.dx = null
	}
	
	getMaxItemValue = () => {
		let max = this.items[ 0 ].value
		for( let i = 1 ; i < this.items.length ; i ++ ){
			const item = this.items[ i ]
			if( max < item.value ){
				max = item.value
			}
		}
		return max ;
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
	
	getSizeX = () => {
		let noteMax = 0
		for( let i = 0 ; i < this.notes.length ; i ++ ){
			noteMax = Math.max( noteMax , this.notes[ i ].length )
		}
		let _max = ( Math.max( this.title.getSize().x , noteMax * 0.55 * this.fontSize ) - this.getDx() - this.itemLabel.length * 0.55 * this.fontSize ) * this.items.length / ( this.items.length + 1 )
		let max = 0
		for( let i = 0 ; i < this.items.length ; i ++ ){
			const item = this.items[ i ]
			max = Math.max( max , item.name.length , item.value.toString().length )
		}
		return Math.max( _max , max * this.items.length * 0.55 * this.fontSize * 1.5 )
	}
	
	getDx = () => Math.round( 7.7 * Math.max( this.getMaxValue().toString().length , this.valueLabel.toString().length ) + 20 )
	
	show = () => {
		const ele = this.canvas.ele
		this.fontSize = this.fontSize == null ? 14 : this.fontSize
		this.dx = this.dx == null ? this.getDx() : this.dx
		if( this.size == null ){
			this.size = new Size()
			//this.size.x = ( ele.width - 20 * 2 - this.getDx() - Math.round( this.itemLabel.length * 7.7 ) ) * this.items.length / ( this.items.length + 1 ) 
			//this.size.y = ( ele.height - this.title.getSize().y - this.fontSize * 5.5 - 35 ) / 11 * 10
			this.size.x = this.getSizeX()
			this.size.y = 10 * this.fontSize * 3
			this.p0 = new P()
			this.p0.x = 20 + this.getDx()
			this.p0.y = this.title.getSize().y + this.fontSize * 1.5 + this.size.y * 11 / 10 + 25
			ele.width = this.size.x / this.items.length * ( this.items.length + 1 ) + 20 * 2 + this.dx + Math.round( this.itemLabel.length * 7.7 )
			ele.height = this.size.y * 11 / 10 + this.title.getSize().y + this.fontSize * ( 4 + 1.5 * this.notes.length ) + 35
			ele.style.width = ele.width + "px"
			ele.style.height = ele.height + "px"
		}
		if( this.title.p == null ){
			const titleSize = this.title.getSize()
			this.title.p = this.title.p == null ? new P( ele.width / 2 - titleSize.x / 2 , titleSize.y + this.fontSize * 1.5 ) : this.title.p
		}
		this.maxValue = this.maxValue == null ? this.getMaxValue() : this.maxValue
		this.partValue = this.partValue == null ? this.maxValue / 10 : this.partValue
		this.maxLevel = Math.round( this.maxValue / this.partValue )
		this.partSize = this.size.y / this.maxLevel
		this.itemSize = this.size.x / this.items.length
		this.itemLineWidth = this.itemLineWidth == null ? this.itemSize / 1.5 : this.itemLineWidth
		const can = this.canvas
		can.CLR()
		can.FLT( this.title , "#333333" )
		can.BGP()
		ele.width - 20
		//ele.width - 20 * 2 - this.getDx() - Math.round( this.itemLabel.length * 7.7 )
		can.LIN2( this.p0 , new Size( this.size.x * ( this.items.length + 1 ) / this.items.length + Math.round( this.itemLabel.length * 7.7 ) , 0 ) )
		can.LIN( this.p0 , new P( this.p0.x , this.p0.y - this.size.y * 11 / 10 ) )
		can.STK( 1 , "#333333" )
		can.FLT( new Text( 
			this.valueLabel , 
			new P( 
				this.p0.x - this.dx , this.title.fontSize * 1.5 + this.fontSize * 1.5 + 25 ) , 
				this.fontSize 
			) , 
			"#333333" 
		)
		can.FLT( new Text( 
			this.itemLabel , 
			new P( this.p0.x + this.size.x * ( this.items.length + 1 ) / this.items.length , 
			this.p0.y + this.fontSize * 1.5 ) , this.fontSize ) , 
			"#333333" 
		)
		for( let i = 0 ; i <= this.maxLevel ; i ++ ){
			can.FLT( new Text( i * this.partValue , new P( this.p0.x - this.dx , this.p0.y - ( i * this.partSize ) ) , this.fontSize ) , "#333333" )
			can.BGP()
			can.CIR( new P( this.p0.x , this.p0.y - ( i * this.partSize ) ) , 2 )
			can.FLL( "#333333" )
		}
		for( let i = 0 ; i < this.items.length ; i ++ ){
			const item = this.items[ i ]
			can.FLT( new Text( item.name , new P( this.p0.x + ( i + 1 )* this.itemSize - this.itemLineWidth / 2 , this.p0.y + this.fontSize * 1.5 , this.fontSize ) ) , "#333333" )
		}
		//value
		can.BGP()
		for( let i = 0 ; i < this.items.length ; i ++ ){
			const item = this.items[ i ]
			can.LIN2( new P( this.p0.x + ( i + 1 ) * this.itemSize , this.p0.y ) , new Size( 0 , - item.value / this.maxValue * this.size.y ) )
			can.STK( this.itemLineWidth , item.color )
			can.FLT( new Text( item.value ,new P( this.p0.x + ( i + 1 ) * this.itemSize - this.itemLineWidth / 2 , this.p0.y - item.value / this.maxValue * this.size.y - this.fontSize / 2 ) ) , "#333333" )
		}
		
		for( let i = 1 ; i < this.maxLevel ; i += 2 ){
			can.BGP()
			can.ctx.globalAlpha = 0.03
			can.RCT( new Rectangle( new P( this.p0.x , this.p0.y - i * this.partSize ) , new Size( this.size.x * ( this.items.length + 1 ) / this.items.length + Math.round( this.itemLabel.length * 7.7 ) , - this.partSize ) ) )
			can.FLL( "#000000" )
			can.ctx.globalAlpha = 1
		}	
		for( let i = 0 ; i < this.notes.length ; i ++ ){
			can.FLT( new Text( this.notes[ i ] , new P( 20 , this.p0.y + this.fontSize * 1.5 * ( 2 + i ) + 10 ) ) , "#333333" )
		}
		can.FLT( new Text( new Date().toLocaleString() , new P( this.fontSize * 1.5 , this.fontSize * 1.5 ) , this.fontSize ) , "#333333" )
		
	}
	
}