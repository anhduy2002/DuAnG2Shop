class Text{
	constructor( s , p , fontSize ){
		this.s = s
		this.p = p
		this.fontSize = fontSize == null ? 14 : fontSize
	}
	getSize = () => new Size( Math.round( 0.55 * this.s.length * this.fontSize ) , this.fontSize * 1.5 )
	
}