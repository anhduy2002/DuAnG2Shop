const GRAYS = []

const hex2Rgb = h => {

    const c = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec( h )
    
    return { 
        r : parseInt( c[1] , 16 ) , 
        g : parseInt( c[2] , 16 ) , 
        b : parseInt( c[3] , 16 ) 
    }
}

const hex2Hsl = c => {
    
    const d = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec( c )
    const r = parseInt( d[1] , 16 ) / 255
    const g = parseInt( d[2] , 16 ) / 255
    const b = parseInt( d[3] , 16 ) / 255
    const m = Math.max( r , g , b )
    const n = Math.min( r , g , b )
    const u = m + n
    const l = u / 2
    let h = 0
    let s = 0

    if( m == n ) h = s = 0
    else {
        const t = m - n
        s = l > 0.5 ? t / ( 2 - u ) : t / u
        switch( m ){
            case r : 
                h = ( g - b ) / t + ( g < b ? 6 : 0 )
                break
            case g : 
                h = ( b - r ) / t + 2 
                break
            case b : 
                h = ( r - g ) / t + 4
                break
        }
    }
    return { h : Math.round( h / 6 * 360 ) , s : Math.round( s * 100 ) , l : Math.round( l * 100 ) }
}

const toHex = c => {

    const h = c.toString( 16 )

    return h.length < 2 ? "0" + h : h
}

const rgb2Hex = c => "#" + toHex( c.r ) + toHex( c.g ) + toHex( c.b )

const rgb2Hsl = c => {

    const hex = rgb2Hex( c )

    return hex2Hsl( c )
}

const hsl2Hex = c => {
    
    const f = x => {
        const c = Math.round( 255 * x ).toString( 16 )
        return c.length === 1 ? '0' + c : c
    }

    const f2 = ( p , q , t ) => {
        let c = t
        if( c < 0 ) c += 1
        if( c > 1 ) c -= 1
        return c < 1/6 ? p + ( q - p ) * 6 * c : c < 1/2 ? q : c < 2/3 ? p + ( q - p ) * ( 2/3 - c ) * 6 : p
    }

    const H = c.h / 360
    const S = c.s / 100
    const L = c.l / 100

    if( S === 0 ){

        const t = f( L )

        return '#' + t + t + t
    }

    const c0 = L < 0.5 ? L * ( S + 1 ) : L + S - L * S
    const c1 = 2 * L - c0

    return '#' + f( f2( c1 , c0 , H + 1/3 ) ) + f( f2( c1 , c0 , H ) ) + f( f2( c1 , c0 , H - 1/3 ) )
}

const hsl2Rgb = c => { 

    const hex = hsl2Hex( c )

    return hex2Rgb( c )
}

class Color{

    constructor( c ){

        if( c[ 0 ] == "#" ){
            this.hex = c

            const rgb = hex2Rgb( this.hex )
            const hsl = hex2Hsl( this.hex )

            this.r = rgb.r
            this.g = rgb.g
            this.b = rgb.b
            this.h = hsl.h
            this.s = hsl.s
            this.l = hsl.l

            return ;
        }

        if( Object.keys( c )[0] == "r" ){
            this.r = c.r
            this.g = c.g
            this.b = c.b
            this.hex = rgb2Hex( this )
            
            const hsl = hex2Hsl( this.hex )

            this.h = hsl.h
            this.s = hsl.s
            this.l = hsl.l
        
            return
        }
        
        this.h = c.h
        this.s = c.s
        this.l = c.l
        this.hex = hsl2Hex( this )

        const rgb = hex2Rgb( this.hex )

        this.r = rgb.r
        this.g = rgb.g
        this.b = rgb.b
    }

    updateHSL = () => {
        this.hex = hsl2Hex( this )

        const rgb = hex2Rgb( this.hex )

        this.r = rgb.r
        this.g = rgb.g
        this.b = rgb.b
    }

    updateRGB = () => {
        this.hex = hsl2Hex( this )

        const hsl = hex2Hsl( this.hex )

        this.r = rgb.r
        this.g = rgb.g
        this.b = rgb.b
    }

    setH = h => {
        this.h = h
        this.updateHSL()
    }

    setS = s => {
        this.s = s
        this.updateHSL()
    }

    setL = l => {
        this.l = l
        this.updateHSL()
    }

    setR = r => {
        this.r = r
        this.updateRGB()
    }

    setG = g => {
        this.g = g
        this.updateRGB()
    }

    setB = b => {
        this.b = b
        this.updateRGB()
    }

    setHex = hex => {

        const rgb = hex2Rgb( hex ) 
        const hsl = hex2Hsl( hex ) 

        this.hex = hex
        this.r = rgb.r
        this.g = rgb.g
        this.b = rgb.b
        this.h = hsl.h
        this.s = hsl.s
        this.l = hsl.l
    }

}

const color = {
    init : () => {
        for( let i = 0 ; i <= 100 ; i ++ ){
            GRAYS.push( new Color( { h : 0 , s : 0 , l : i } ) )
        }
    }
}

color.init()

