// Propuesta 1: Enfoque Clásico

(
SynthDef(\ruido, {
	var freq = MouseX.kr(100, 3000, \exponential);
	var rq = MouseY.kr(0.01, 0.5, \exponential);
    var sonido = WhiteNoise.ar(1!2);
    sonido = BPF.ar(sonido, freq, rq);
	sonido = sonido * rq.lincurve(0.01,1,10,1,-20);
    Out.ar(0, sonido);
}).add;
)

x = Synth(\ruido)
x.free


/****************************************************************************/
// Propuesta 2: Enfoque con Ndef

// función que servirá para definir un Nodo de sintetizador
(
~ruido = { arg freq = 440, rq = 1, amp = 1;
    var sonido = WhiteNoise.ar(1!2);
    sonido = BPF.ar(sonido, freq, rq);
};
)

//Definimos los nodos:
Ndef(\ruidoFiltrado, ~ruido)
Ndef(\ratonX, {MouseX.kr(100, 3000, \exponential)})
Ndef(\ratonY, {MouseY.kr(0.01, 0.5, \exponential)})

// Mapeamos la frecuencia y el rq con los valores del ratón;
Ndef(\ruidoFiltrado).map(\freq, Ndef(\ratonX))
Ndef(\ruidoFiltrado).map(\rq, Ndef(\ratonY))

// Activamos el bus de monitoreo del nodo que produce sonido:
Ndef(\ruidoFiltrado).play

// Paramos el sonido con un fadeTime de 6 segundos:
Ndef(\ruidoFiltrado).stop(6)

// Liberamos todos los Nodos:
Ndef.clear


/*****************************************************************************/
// Propuesta 3: Enfoque Compacto (SCTweets)

// 3.a Versión completa:
play{y=MouseY.kr(0.01);BPF.ar(y.lincurve(0.01,1,10,1,-20)*GrayNoise.ar,MouseX.kr(99,3e3),y)}

// 3.b Versión superreducida (sin normalizado de amplitud):
play{BPF.ar(GrayNoise.ar,MouseX.kr(99,3e3),MouseY.kr(0.01))} // 60 caracteres
