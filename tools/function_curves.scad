// function_curves.scad
//
// Enthält Funktionen, die Kurven beschreiben


// ermittelt den Punkt einer Bezierkurve n. Grades abhängig von den Parametern
// Argumente:
//   t - ein Wert zwischen 0...1
//   p - [p0, ..., pn] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, pn = Endpunkt der Kurve
//       Das Array darf nicht weniger als n+1 Elemente enthalten
//   n - Angabe des Grades der Bezierkurve
//       es werden nur die Punkte bis p[n] genommen
//       ohne Angabe von n wird der Grad anhand der Größe des Arrays genommen
//                   
function bezier_point (t, p, n) =
	 (!is_list(p)) ? undef
	:(n==undef) ?
		(len(p)<1) ? undef
		:bezier_point_intern (t, p, len(p)-1, len(p)-1)
	:
		 (n <0)       ? undef
		:(len(p)<n+1) ? undef
		:bezier_point_intern (t, p, n, n)
;
function bezier_point_intern (t, p, n, j) =
	 (j <0) ? undef
	:(j==0) ? p[0] * (pow((1-t), n))
	:         p[j] * (pow((1-t), n-j) * pow(t, j) * binomial_coefficient(n, j))
	          + bezier_point_intern(t, p, n, j-1) 
;

// gibt ein Array mit den Punkten einer Bezierkurve aus
// Argumente:
//   p - [p0, ..., pn] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, pn = Endpunkt der Kurve
//       Das Array darf nicht weniger als n+1 Elemente enthalten
//   n - Angabe des Grades der Bezierkurve
//       es werden nur die Punkte bis p[n] genommen
//       ohne Angabe von n wird der Grad anhand der Größe des Arrays genommen
//   slices - Bezierkurve wird in diese Anzahl an Punkten aufgeteilt, mindestens 2 Punkte
//       ohne Angabe werden die Anzahl der Punkte von $fn, $fa, $fs ermittelt (grob implementiert)
//                   
function bezier_curve (p, n, slices) =
	let (
	Slices =
		slices==undef ? max(2, get_fn_circle_current  (max_norm(p)/4) ) :
		slices=="x"   ? max(2, get_fn_circle_current_x(max_norm(p)/4) ) :
		slices< 2     ? 2 :
		slices
	)
	[for (i = [0 : Slices-1]) bezier_point(i/(Slices-1),p,n)]
;

// ermittelt den Punkt einer Bezierkurve 1. Grades (linear) abhängig von den Parametern
// Argumente:
//   t - ein Wert zwischen 0...1
//   p - [p0, p1] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, p1 = Endpunkt der Kurve
function bezier_1 (t, p) =
	  p[0] * (1-t)
	+ p[1] * t
;

// ermittelt den Punkt einer Bezierkurve 2. Grades (quadratisch) abhängig von den Parametern
// Argumente:
//   t - ein Wert zwischen 0...1
//   p - [p0, p1, p2] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, p2 = Endpunkt der Kurve
function bezier_2 (t, p) =
	  p[0] *   (    (1-t)*(1-t))
	+ p[1] * 2*(t * (1-t))
	+ p[2] *   (t*t)
;

// ermittelt den Punkt einer Bezierkurve 3. Grades (kubisch) abhängig von den Parametern
// Argumente:
//   t - ein Wert zwischen 0...1
//   p - [p0, ..., p3] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, p3 = Endpunkt der Kurve
function bezier_3 (t, p) =
	  p[0] *   (      (1-t)*(1-t)*(1-t))
	+ p[1] * 3*(t   * (1-t)*(1-t))
	+ p[2] * 3*(t*t * (1-t))
	+ p[3] *   (t*t*t)
;

// ermittelt den Punkt einer Bezierkurve 4. Grades abhängig von den Parametern
// Argumente:
//   t - ein Wert zwischen 0...1
//   p - [p0, ..., p4] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, p4 = Endpunkt der Kurve
function bezier_4 (t, p) =
	  p[0] *   (        (1-t)*(1-t)*(1-t)*(1-t))
	+ p[1] * 4*(t     * (1-t)*(1-t)*(1-t))
	+ p[2] * 6*(t*t   * (1-t)*(1-t))
	+ p[3] * 4*(t*t*t * (1-t))
	+ p[4] *   (t*t*t*t)
;


// ermittelt einen Punkt eines Kreises
// Argumente:
// r, (d) - Radius oder Durchmesser
// angle  - Winkel in Grad
function circle_point   (r, angle=0, d) = circle_point_r(parameter_circle_r(r,d), angle);
function circle_point_r (r, angle=0) =
	r * [cos(angle), sin(angle)]
;

// gibt ein Array mit den Punkten eines Kreisbogens zurück
// Argumente:
// r, (d) - Radius oder Durchmesser
// angle  - gezeichneter Winkel in Grad, Standart=360
//          als Zahl  = Winkel von 0 bis 'angle' = Öffnungswinkel
//          als Liste = [Öffnungswinkel, Anfangswinkel]
// slices - Anzahl der Segmente, ohne Angabe wird wie bei circle() gerechnet
// piece  - true  = wie ein Tortenstück
//          false = Enden des Kreises verbinden
//          0     = zum weiterverarbeiten, Enden nicht verbinden, keine zusätzlichen Kanten
// outer  - 0...1 = 0 - Ecken auf der Kreislinie ... 1 - Tangenten auf der Kreislinie
function circle_curve (r, angle=360, slices, piece=true, outer=0, d) =
	let(
		 R = parameter_circle_r(r,d)
		,angles      = parameter_angle (angle, [360,0])
		,angle_begin = angles[1]
		,Angle       = angles[0]
		,Slices =
			slices==undef ? get_fn_circle_current  (R,Angle,piece) :
			slices=="x"   ? get_fn_circle_current_x(R,Angle,piece) :
			slices<2 ?
				(piece==true || piece==0) ? 1 : 2
			:slices
		,r_outer =
			(Angle==0) ? R
			:            R * get_circle_factor(Slices*360/Angle, outer)
		,circle_list =
			circle_curve_intern(r_outer, Angle, angle_begin, Slices)
	)
	(piece==true && Angle!=360) ?
		concat( circle_list, [[0,0]])
	:	circle_list
;
function circle_curve_intern (r, angle, angle_begin, slices) =
	let (angle_pie = angle/slices)
	[for (i = [0 : (angle==0 ? 0 : slices)])
		circle_point_r(r, angle_begin + i*angle_pie )
	]
;

// ermittelt den Punkt einer Superellipse
// t  - Position des Punkts von 0...360
// n  - Grad der Kurve, steuert die Kurvenform
// s  - Parameter "Superness", steuert die Kurvenform, optional
//      Wurde n angegeben, wird s ignoriert
// r  - Radius
// a  - steuert die Breitenverhältnisse der jeweiligen Achsen
//        als Zahl  = jede Achse enthält den gleichen Faktor
//        als Liste = jede Achse enthält ihren eigenen Faktor [X,Y]
//        Standart  = [1,1]
function superellipse_point (t, n, r, a, s) =
	let (
		 T = is_num(t) ? t : 0
		,N = is_list(n) ? n :
		    is_num(n)  ? [n,n] :
		    [2,2]
		,R = is_num(r) ? r : 1,
		,A = is_list(a) ? a :
		     is_num (a) ? [a,a] :
		     [1,1]
		,S = is_list(s) ? s :
		     is_num(s)  ? [s,s] :
		     undef
	)
	(S==undef) ? superellipse_point_n (T, N, R, A)
	:            superellipse_point_s (T, S, R, A)
;
function superellipse_point_n (t=0, n=[2,2], r=1, a=[1,1]) =
	let(
		e = 2/n
	)
	superellipse_point_intern (t, e, r*a)
;
function superellipse_point_s (t=0, s=[1/sqrt(2),1/sqrt(2)], r=1, a=[1,1]) =
	let(
		e = (-2/ln(2)) * [ln(s[0]),ln(s[1])]
	)
	superellipse_point_intern (t, e, r*a)
;
// e - calculated exponent
function superellipse_point_intern (t, e, a) =
	let (
		sint = sin(t),
		cost = cos(t)
	)
	[ a[0] * pow( abs(cost), e[0]) * sign(cost),
	  a[1] * pow( abs(sint), e[1]) * sign(sint)
	]
;

// Argumente:
// interval - Intervallgrenze von t. [Anfang, Ende]
// slices   - Anzahl der Punkte im Intervall
// piece    - true  = wie ein Tortenstück
//            false = Enden des Kreises verbinden
//            0     = zum weiterverarbeiten, Enden nicht verbinden, keine zusätzlichen Kanten
function superellipse_curve (interval, n, r, a, s, slices, piece=true) =
	let (
		 I = is_list(interval) ? interval :
		     [0,360]
		,N = is_list(n) ? n :
		     is_num(n)  ? [n,n] :
		     [2,2]
		,R = is_num(r) ? r : 1
		,A = is_list(a) ? a :
		     is_num (a) ? [a,a] :
		     [1,1]
		,S = is_list(s) ? s :
		     is_num(s)  ? [s,s] :
		     undef
		,Slices =
			slices==undef ? get_fn_circle_current  (R*max(A),I[1]-I[0],piece) :
			slices=="x"   ? get_fn_circle_current_x(R*max(A),I[1]-I[0],piece) :
			slices<2 ?
				(piece==true || piece==0) ? 1 : 2
			:slices
		,e =
			S==undef ? 2/N
			:          (-2/ln(2)) * [ln(S[0]),ln(S[1])]
		,superellipse_list = superellipse_curve_intern (I, e, A*R, Slices)
	)
	(piece==true && (I[1]-I[0])!=360) ?
		concat( superellipse_list, [[0,0]])
	:	superellipse_list
;
function superellipse_curve_intern (interval, e, a, slices) =
	[ for (i = [0 : slices])
		let (t = bezier_1(i/slices, interval))
		superellipse_point_intern (t, e, a)
	]
;

// Polynomfunktion
// P(x) = a[0] + a[1]*x + a[2]*x^2 + ... a[n]*x^n
// Argumente:
// x - Variable
// a - Array mit den Koeffizienten
// n - Grad des Polynoms, es werden nur so viele Koeffizienten genommen wie angegeben
//     ohne Angabe wird der Grad entsprechend der Größe des Arrays der Koeffizienten genommen
function polynom (x, a, n=undef) =
	let (
		N = n==undef ? len(a) : min(len(a),n)
	)
	polynom_intern(x, a, N)
;
function polynom_intern (x, a, n, i=0, x_i=1, value=0) =
	(i >= n) ? value
	:polynom_intern(x, a, n, i+1, x_i*x, value + a[i]*x_i)
;

// gibt ein Array mit den Punkten eines Polynomintervalls zurück
// Argumente:
// interval - Intervallgrenze von x. [Anfang, Ende]
// slices   - Anzahl der Punkte im Intervall
function polynom_curve (interval, a, n=undef, slices) =
	let (
		Slices =
			slices==undef ? 5 :
			slices<2      ? 2 :
			slices
	)
	[for (i = [0 : Slices])
		let (x = bezier_1(i/Slices, interval))
		[x, polynom(x, a, n)]
	]
;

// gibt ein 2D-Quadrat als Punkteliste zurück
// Argumente wie von square() von OpenSCAD
function square_curve(size, center=false) =
	let (
		Size = parameter_size_2d(size),
		x=Size[0],
		y=Size[1],
		square_list=[[0,0], [x,0], [x,y], [0,y]]
	)
	(center==false) ? square_list
	:translate_list(  square_list, [-x/2,-y/2])
;

