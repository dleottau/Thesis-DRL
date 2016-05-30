Enfoque con SARSA + trazas de elegibilidad (Lambda)

Corregido problema de la pelota.

Estados:
ro, discretizado logarítmicamente entre 10 y 1000 mm en 15 pasos.
dVrb, dos pasos, negativo o positivo.

Se agregó ruido al modelo de la pelota.

Acciones:
Velocidad del robot en eje x, entre 20 y 100 mm/s, con incrementos de 10. Es decir 9 acciones.

Se agregó ruido a las acciones.

Recopensa:
20+Vavg-Vth si Vavg>Vth && cantidad de pasos completo, Estado terminal despues 
-1  si ro>romax, Estado terminal
-1  si Vavg<Vth && cantidad de pasos completo, Estado terminal





