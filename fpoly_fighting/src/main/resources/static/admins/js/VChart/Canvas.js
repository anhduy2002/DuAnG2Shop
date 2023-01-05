class Canvas {

	constructor( element ){
		this.ele = element
		this.ctx = this.ele.getContext( "2d" )
	}

	BGP = () => this.ctx.beginPath()

	MVT = p => this.ctx.moveTo( p.x , p.y )

	LNT = p => this.ctx.lineTo( p.x , p.y )

	LIN = ( p1 , p2 ) => {
		this.MVT( p1 )
		this.LNT( p2 )
	}
	
	LIN2 = ( p1 , size ) => this.LIN( p1 , new P( p1.x + size.x , p1.y + size.y ) )

	RCT = rectangle => this.ctx.rect( rectangle.p.x , rectangle.p.y , rectangle.size.x , rectangle.size.y )

	CVT = c => this.ctx.bezierCurveTo( c.p1.x , c.p1.y , c.p2.x , c.p2.y , c.p3.x , c.p3.y )

	STK = ( lineWidth , style ) => {
		const ctx = this.ctx
		if( lineWidth != undefined ) ctx.lineWidth = lineWidth
		if( style != undefined ) this.ctx.strokeStyle = style
		ctx.stroke()
	}

	FLL = style => {
		if( style != undefined ) this.ctx.fillStyle = style
		this.ctx.fill()
	}

	CLR = r => this.ctx.clearRect( 0 , 0 , this.ele.width , this.ele.height )

	ARC = ( p , r , s , e , c ) => this.ctx.arc( p.x , p.y , r , d2R( s ) , d2R( e ) , c )

	CIR = ( p , r ) => this.ARC( p , r , 0 , 360 , 0 )

	PRV = () => this.ele.addEventListener( "contextmenu" , function( event ){
		event.preventDefault() 
	} )

	EXP = name => {
		const a = document.createElement( 'a' )
		const b = document.body
		a.href = this.sto.toDataURL( "image/png" , 1.0 )
		a.download = name
		b.appendChild( a )
		a.click()
		b.removeChild( a )
	}

	FLT = ( text , style ) => {
		this.BGP()
		this.ctx.font = text.fontSize + "px Consolas"
		if( style != undefined ) this.ctx.fillStyle = style
		this.ctx.fillText( text.s , text.p.x , text.p.y )
	}

	STT = ( text , lw , c ) => {
		this.BGP()
		this.ctx.font = text.fontSize + "px Consolas"
		this.ctx.lineWidth = lw
		this.ctx.strokeText( text.s , text.p.x , text.p.y )
		
	}
	
	
	
}

