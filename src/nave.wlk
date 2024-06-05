class Nave {
	var property velocidad = 0
	var property direccion = 0
	var property combustible = 0
	
	method acelerar(cuanto) { velocidad = (velocidad + cuanto).min(100000)}
	method desacelerar(cuanto) { velocidad = (velocidad - cuanto).max(0) }
	method irHaciaElSol() { direccion = 10 }
	method escaparDelSol() { direccion = -10 }
	method ponerseParaleloAlSol() { direccion = 0 }
	method acercarseUnPocoAlSol() { direccion = (direccion + 1).max(10) }
	method alejarseUnPocoDelSol() { direccion = (direccion - 1).min(-10) }	
	method cargarCombustible(cuanto) { combustible += cuanto}
	method descargarCombustible(cuanto) { combustible = (combustible - cuanto).max(0)}
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method estaTranquila(){ return (combustible >= 4000) and (velocidad <= 12000) }
	method estaDeRelajo(){ return self.estaTranquila() }
} 

class NaveBaliza inherits Nave{
	var property colorBaliza
	const property colores = []
	
	method cambiarColorDeBaliza(colorNuevo){
		colorBaliza = colorNuevo
		colores.add(colorNuevo)
	}
	override method prepararViaje(){
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	
	override method estaTranquila(){
		return super() and (self.colorBaliza() != "rojo")
	}
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method escapar(){self.irHaciaElSol()}
	method avisar(){ colorBaliza = "rojo"}
	override method estaDeRelajo(){ return super() and colores.isEmpty()}
}


class NavePasajeros inherits Nave{
	var property cantidadDePasajeros 
	var property racionesDeComida
	var property racionesDeBebida
	var property racionesDeComidaServida = 0
	
	method cargarRacionComida(cantidad){ racionesDeComida += cantidad}
	method descargarRacionComida(cantidad){ racionesDeComida = (racionesDeComida - cantidad).max(0) }	
	method cargarRacionBebida(cantidad){ racionesDeBebida += cantidad }
	method descargarRacionBebida(cantidad){ racionesDeBebida = (racionesDeBebida -cantidad).max(0)}	
	override method prepararViaje(){ 
		super()
		self.cargarRacionComida(4 * cantidadDePasajeros)
		self.cargarRacionBebida(6 * cantidadDePasajeros)
		self.acercarseUnPocoAlSol()
	}
	method recibirAmenaza() {
		self.escapar()
		self.avisar()
	}
	method escapar(){ velocidad *= 2}
	method avisar() {
		racionesDeComida -= cantidadDePasajeros
		racionesDeBebida -= cantidadDePasajeros * 2
		racionesDeComidaServida += cantidadDePasajeros
	}
	override method estaDeRelajo() {return super() and racionesDeComidaServida < 50}
}

class NaveCombate inherits Nave{
	var property invisible 
	var property misilesDesplegados
	const property mensajesEmitidos = [] 
	method ponerseVisible(){ invisible = false }
	method ponerseInvisible() {invisible = true}
	method estaInvisible() {return invisible}
	method desplegarMisiles(){ misilesDesplegados = true}
	method replegarMisiles() { misilesDesplegados = false}
	method misilesDesplegados() { return misilesDesplegados}
	method emitirMensaje(mensaje) { mensajesEmitidos.add(mensaje)}
	method mensajesEmitidos() { return mensajesEmitidos.size() }
	method primerMensajeEmitido() {return mensajesEmitidos.first()}
	method ultimoMensajeEmitido() { return mensajesEmitidos.last()}
	method esEscueta() { return not mensajesEmitidos.any({x => x.size() > 30})}
	method emitioMensaje(mensaje) {return mensajesEmitidos.contains(mensaje)}
	override method prepararViaje(){
		super()
		self.acelerar(15000)
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	override method estaTranquila(){
		return super() and (not self.misilesDesplegados())
	}
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method escapar(){ 
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}
	override method estaDeRelajo() { return super() and self.esEscueta()}
}

class NaveHospital inherits NavePasajeros {
	var property quirofanosPreparados
	
	override method estaTranquila(){
		return super() and(not self.quirofanosPreparados())
	}
	override method recibirAmenaza() {
		super()
		quirofanosPreparados = true
	}
}

class NaveCombateSigilosa inherits NaveCombate {
	override method estaTranquila(){ return super() and(not self.estaInvisible()) }
	override method recibirAmenaza(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}


