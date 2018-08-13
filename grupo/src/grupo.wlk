// Cuarta Entrega - 1er Corrección

// Clases de Músicos

class Musico {
	
	var habilidad
	var grupo = ''
	var albumes = []
	
	var categoriaDeEjecucion
	var categoriaDeCobro
	
	constructor(_habilidad) { habilidad = _habilidad }
	
	constructor(_habilidad,_tipoDeCobro) {
		habilidad = _habilidad
		categoriaDeCobro = _tipoDeCobro
	}
	
	constructor(_habilidad,_grupo,_categoriaDeEjecucion,_tipoDeCobro){
		habilidad = _habilidad
		grupo = _grupo
		categoriaDeEjecucion = _categoriaDeEjecucion
		categoriaDeCobro = _tipoDeCobro
	}

	method habilidad() = habilidad
	method habilidad(_habilidad) { habilidad = _habilidad }
	method grupo() = grupo
	method grupo(_grupo) { grupo = _grupo }
	method dejarGrupo() { grupo = '' }
	method albumes(_albumes) { albumes = _albumes }
	method albumes() = albumes
	method albumNuevo(_album) { albumes.add(_album) }
	method esSolista() { return grupo.isEmpty() }
	
	method categoria() = categoriaDeEjecucion
	method categoriaEjecucion(_categoria) { categoriaDeEjecucion = _categoria }
	method categoriaDeCobro() = categoriaDeCobro
	method categoriaDeCobro(_categoria) { categoriaDeCobro = _categoria }	
	
	method esMinimalista() {
		return albumes.all({unAlbum => unAlbum.todasCancionesCortas()})
	}
	
	method cancionesCon(palabra) {
		return albumes.flatMap({unAlbum => unAlbum.titulosDeCancionesQueContienen(palabra)})
	}
	
	method duracionDeObra() {
		return albumes.sum({unAlbum => unAlbum.duracionTotal()})
	}
	
	method laPego() {
		return albumes.all({unAlbum => unAlbum.tieneBuenasVentas()})
	}
	
	method esAutorDe(cancion) {
		return albumes.any({unAlbum => unAlbum.tieneCancion(cancion)})
	}

	method puedeEjecutarBien(cancion) {
		return (categoriaDeEjecucion.puedeEjecutarBien(cancion) || self.esAutorDe(cancion) || self.habilidad() > 60)
	}
	
	method cuantoCobraEn(presentacion) {
		return categoriaDeCobro.cuantoCobraEn(presentacion,self)
	}
	
	//Métodos de la 4ta Entrega
	
	method cualesPuedeTocarBien(lista) {
		return self.cancionesQueEjecutaBien(lista)
	}

	method cancionesQueEjecutaBien(lista) {
		return lista.filter({unaCancion => self.puedeEjecutarBien(unaCancion)})
	}
	
}

// Categorías de Ejecución:

class Palabrero {
	
	var palabraEspecial
	
	constructor(_palabraEspecial) {palabraEspecial = _palabraEspecial}
	
	method puedeEjecutarBien(cancion) {
		return cancion.dicePalabra(palabraEspecial)
	}
}

class Larguero {
	
	var duracionNecesaria
	
	constructor(_duracion) {duracionNecesaria = _duracion}
	
	method puedeEjecutarBien(cancion) {
		return cancion.duracion() > duracionNecesaria
	}
	
}

object imparero {
	method puedeEjecutarBien(cancion) {
		return cancion.duracion().odd()
	}
}

// Categorías de cobro:

class CobroEnSolitario {
	
	var importe
	
	constructor(_importe) {importe = _importe}
	
	method nuevoImporte(_nuevoImporte) {importe = _nuevoImporte}
	method cuantoCobraEn(presentacion,artista) {
		if(presentacion.tocaSolo(artista)) {
			return importe
		} else {return importe*0.5}
	}
	
}

class CobroPorCapacidad {
	
	var importe
	var cantidadDePersonas
	
	constructor(_importe,_cantLimite) {
		importe = _importe
		cantidadDePersonas = _cantLimite
	}
	
	method importe(_importe) {importe = _importe}
	method cantidadDePersonas(_cant) {cantidadDePersonas = _cant}	
	method cuantoCobraEn(presentacion,artista) {
		if(presentacion.concurrenciaMayorA(cantidadDePersonas)) {
			return importe
		} else { return importe - 100 }
	}
	
}

class CobroPorFecha {
	
	var fechaLimite
	var importe
	var porcentajeAdicional
	
	constructor(_fecha,_importe,_porcentaje) {
		fechaLimite = _fecha
		importe = _importe
		porcentajeAdicional = _porcentaje
	}
	
	method cambioDeFecha(_fechaNueva) {fechaLimite = _fechaNueva}
	method cambioDePorcentaje(_porcentajeNuevo) {porcentajeAdicional = _porcentajeNuevo}
	
	method cuantoCobraEn(presentacion,artista) {
		if(self.hastaFechaLimite(presentacion)) {
			return importe
		} else { return importe*(1+porcentajeAdicional) }
	}
	
	method hastaFechaLimite(presentacion) { return (presentacion.fechaPresentacion() <= fechaLimite) }
	
}

//Clases de Músicos

class MusicoDeGrupo inherits Musico {
	
	var extraPorSerDeGrupo
	
	constructor(_extra,_habilidad) = super(_habilidad) { extraPorSerDeGrupo = _extra }
	constructor(_extra,_habilidad,_grupo) = super(_habilidad,_grupo) { extraPorSerDeGrupo = _extra }
	constructor(_extra,_habilidad,_grupo,_categoriaDeEjecucion,_tipoDeCobro) = super(_habilidad,_grupo,_categoriaDeEjecucion,_tipoDeCobro) { extraPorSerDeGrupo = _extra }
	
	method extraPorSerDeGrupo(_extra) { extraPorSerDeGrupo = _extra }
	
	override method habilidad() {
		if(!grupo.isEmpty()) {
			return habilidad + extraPorSerDeGrupo
		}
		return habilidad
	}
	
}

class VocalistaPopular inherits Musico {
	
	override method habilidad() {
		if(!grupo.isEmpty()) {
			return habilidad - 20
		}
		return habilidad
	}
	
}

// Músicos

object luisAlberto inherits Musico(8,new CobroPorFecha(new Date(30,09,2017),1000,0.2)){
	
	var guitarraActual = fender
	
	method asignarGuitarra(_guitarra) { guitarraActual = _guitarra }
	
	override method habilidad() {
		return 100.min(habilidad*(guitarraActual.unidadDeGuitarra()))
	}
	
	override method puedeEjecutarBien(cancion) = true
	
}

//Guitarras

object fender {
	var unidadDeGuitarra = 10
	method unidadDeGuitarra() =  unidadDeGuitarra
}

object gibson {
	var estado = true
	var unidadDeGuitarra
	method unidadDeGuitarra(_UG) { unidadDeGuitarra = _UG }
	method unidadDeGuitarra() {
		if(!estado) {
		return 5
	} else { return 15 }
	}
	method romperGuitarra() { estado = false }
	method estado() = estado
}

//Canciones

class Cancion {
	
	var titulo
	var duracionCancion
	var letra
	
	constructor() {}
	
	constructor(_titulo,_duracionCancion,_letra) {
		titulo = _titulo
		duracionCancion = _duracionCancion
		letra = _letra
	}
	
	method titulo() {return titulo}
	method duracion() {return duracionCancion}
	method letra() {return letra}
	method longLetra() { return letra.words().size() }
	
	method dicePalabra(palabra) {
 		return ((letra.toLowerCase()).contains(palabra))
 	}
 	
 	method esCorta() {return duracionCancion < 180}
 	
}

//Remixes

class Remix inherits Cancion {
	
	var cancionOriginal
	
	constructor(_cancionOriginal) = super() {
		cancionOriginal = _cancionOriginal
		titulo = self.titulo()
		duracionCancion = (cancionOriginal.duracion())*3
		letra = self.letra()
	}
	
	override method letra() = 'mueve tu cuerpo baby ' + cancionOriginal.letra() + ' yeah oh yeah'
	override method titulo() = 'Remix de ' + cancionOriginal.titulo()
}

//Mashups

class Mashup inherits Cancion{
	
	var canciones = []
	
	constructor(_canciones) { 
		canciones = _canciones
		duracionCancion = self.duracion()
		letra = self.letra()
	}
	
	override method duracion() = return canciones.max(duracion.bloque()).duracion() 
	
	override method letra() {
		return (self.letrasDeCanciones()).join(' ')
	}
		
	method letrasDeCanciones() {
		return canciones.map({unaCancion => unaCancion.letra()})
	}

}

//Álbumes

class Album {
	
	var titulo
	var canciones = []
	var fechaLanzamiento 
	var unidadesALaVenta
	var unidadesVendidas
	
	constructor(_titulo,_canciones,_fecha,_uVta,_uVendidas) {
		titulo = _titulo
		canciones = _canciones
		fechaLanzamiento = _fecha
		unidadesALaVenta = _uVta
		unidadesVendidas = _uVendidas
	}
	
	method titulo(_titulo) {titulo = _titulo}
	method titulo() = titulo
	method canciones(_canciones) {canciones = _canciones}
	method canciones() = canciones
	method unidadesALaVenta() = unidadesALaVenta
	method unidadesVendidas() = unidadesVendidas
	
	method todasCancionesCortas() {
		return canciones.all({unaCancion => unaCancion.esCorta()})
	}
	
	method titulosDeCancionesQueContienen(palabra) {
		return (self.cancionesQueContienen(palabra)).map({unaCancion => unaCancion.titulo()})
	}

	method cancionesQueContienen(palabra) {
	return canciones.filter({unaCancion => unaCancion.dicePalabra(palabra)})
	}
	
	method duracionTotal() {
		return canciones.sum({unaCancion => unaCancion.duracion()})
	}

	method tieneBuenasVentas() {
		return unidadesVendidas >= (unidadesALaVenta*0.75)
	}
	
	method tieneCancion(cancion) {
		return canciones.contains(cancion)
	}
	
//Comparar canciones:

	method cancionMaxSegun(criterio) {
		return canciones.max(criterio.bloque())
	}
	
}

//Criterios

class Criterio {
	var criterio = {}
	
	constructor(_bloque) {
		criterio = _bloque
		}
		
	method bloque() = criterio
}

object duracion inherits Criterio({unaC => unaC.duracion()}) {}

//Presentaciones

class Presentacion {
	
	var fecha
	var lugar
	var artistas = []
	
	constructor(_lugar,_artistas) {
		lugar = _lugar
		artistas = _artistas
	}
	
	constructor(_fecha,_lugar,_artistas) {
		fecha = _fecha
		lugar = _lugar
		artistas = _artistas
	}
	
	method fechaPresentacion() = fecha
	method cambiarFecha(_fechaNueva) {fecha = _fechaNueva}
	method lugar() = lugar
	method artistas() = artistas
	
	method esSabado() {
	 	return fecha.dayOfWeek() == 6
	}
	
	method agregarMusico(_musico) { artistas.add(_musico) }
	method quitarMusico(_musico) { artistas.remove(_musico) }
	
	method tocaSolo(unMusico) { 
		return artistas.size() == 1 && artistas.contains(unMusico)
	}
		
	method costoDePresentacion() {
		return self.costoDeArtistas()
	}
	
	method esConcurrida() {
		return lugar.capacidadEn(self) > 5000
	}
	
	method estaEnLaPresentacion(unMusico) {
		return artistas.contains(unMusico)
	}
	
	//Métodos de la 4ta Entrega
	
	method costoDeArtistas() {
		return artistas.sum({unMusico => unMusico.cuantoCobraEn(self)})
	}
	
	method concurrenciaMayorA(cantidad) {
		return lugar.capacidadEn(self) > cantidad //
	}
	
	method magia() {
		return artistas.sum({unMusico => unMusico.habilidad()})
	}
	
}	

//Pdepalooza

object pdepalooza inherits Presentacion(new Date(15,12,2017),lunaPark,[]) {
	
	var restricciones = []
	
	method agregarRestriccion(_restriccion) {
		restricciones.add(_restriccion)
	}
	
	method quitarRestriccion(_restriccion) {
		restricciones.remove(_restriccion)
	}
	
	override method agregarMusico(musico) {
		if(self.cumpleTodasLasCondiciones(musico)) {
			super(musico)
		}
	}
	
	method cumpleTodasLasCondiciones(musico) {
		return restricciones.all({unaCondicion => unaCondicion.cumpleCondicion(musico)})
	}
	
}

//Restricciones

class Restriccion {
	
	var condicion 
	var mensajeDeError
	
	constructor(_condicion,_mensaje) {
		condicion = _condicion
		mensajeDeError = _mensaje
	}
	
	method condicion() = condicion
	method mensaje() = mensajeDeError
	
	method cambiarCondicionYMensaje(_condicion,_mensaje) {
		condicion = _condicion
		mensajeDeError = _mensaje
	}
		
	method cumpleCondicion(_musico) {
		if(!(condicion.apply(_musico))) {
			throw new UserException(mensajeDeError)
		} else return true
	}
}

class UserException inherits Exception {}

//Lugares

class Lugar {
	var capacidad
	constructor(_capacidad) {capacidad = _capacidad}
	method capacidadEn(presentacion) = capacidad
}
	
object lunaPark inherits Lugar(9290){} //Pdepalooza lo utiliza
 
object laTrastienda inherits Lugar(700) {
	
	var capacidadPB = 400
	var capacidad1erPiso = 300
	
	override method capacidadEn(presentacion) {
		if(presentacion.esSabado()) {
			return (capacidadPB + capacidad1erPiso)
		} else { return capacidadPB }
	}

}

//Bandas

class Grupo {
	
	var musicos = []
	var representante
	
	constructor(_musicos,_representante) {
		musicos = _musicos
		representante = _representante
	}
	
	method habilidad() {
		return 1.1*self.habilidadTotal()
	}
	
	method habilidadTotal() { return musicos.sum({unMusico => unMusico.habilidad()}) }
	
	method cuantoCobraEn(presentacion) {
		return representante.cuantoCobraEn(presentacion) + self.cobroDeLosMusicosEn(presentacion)
	}
	
	method cobroDeLosMusicosEn(presentacion) {
		return musicos.sum({unMusico => unMusico.cuantoCobraEn(presentacion)})
	}
	
	method puedeEjecutarBien(cancion) {
		return musicos.all({unMusico => unMusico.puedeEjecutarBien(cancion)})
	}
}

//Representantes

class Representante {
	var apodo
	var importe
	constructor(_apodo,_importe) {
		apodo = _apodo
		importe = _importe
	}
	method cuantoCobraEn(presentacion) {return importe}
}