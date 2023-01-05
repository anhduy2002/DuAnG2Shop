class Rectangle {
	
	constructor ( p , size ){
		if( size.x < 0 ) p.x += size.x
		if( size.y < 0 ) p.y += size.y
		this.p = p
		this.size = new Size( Math.abs( size.x ) , Math.abs( size.y ) )
	}
	
}