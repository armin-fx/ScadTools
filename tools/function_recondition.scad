// function_recondition.scad
//
// Enthält Funktionen zum Bearbeiten, Auswählen und Reparieren von Argumenten


function repair_matrix_3d (m) =
	fill_matrix_with (m, identity_matrix(4))
;
function repair_matrix_2d (m) =
	fill_matrix_with (m, identity_matrix(3))
;

function fill_matrix_with (m, c) =
	!is_list(m) ? c :
	[ for (i=[0:len(c)-1])
		[ for (j=[0:len(c[i])-1])
			is_num(m[i][j]) ? m[i][j] : c[i][j]
		]
	]
;
function fill_list_with (list, c) =
	!is_list(list) ? c :
	[ for (i=[0:len(c)-1])
		is_num(list[i]) ? list[i] : c[i]
	]
;


// gibt [Innenradius, Außenradius] zurück
// Argumente:
//   r, d   - mittlerer Radius oder Durchmesser
//   r1, d1 - Innenradius oder Innendurchmesser
//   r2, d2 - Außenradius oder Außendurchmesser
//   w      - Breite des Rings
// Angegeben müssen:
//   genau 2 Angaben von r oder r1 oder r2 oder w
// Regeln in Anlehnung von OpenSCAD
// - Durchmesser geht vor Radius
// - ohne Angabe: r1=1, r2=2
function parameter_ring_2r (r, w, r1, r2, d, d1, d2) =
	parameter_ring_2r_basic (
		r =get_first_good(d /2,  r),
		w =w,
		r1=get_first_good(d1/2, r1),
		r2=get_first_good(d2/2, r2)
	)
;
function parameter_ring_2r_basic (r, w, r1, r2) =
	 (r !=undef && w !=undef) ? [r-w/2   , r+w/2]
	:(r1!=undef && r2!=undef) ? [r1      , r2]
	:(r !=undef && r1!=undef) ? [r1      , 3*r-2*r1]
	:(r !=undef && r2!=undef) ? [3*r-2*r2, r2]
	:(r1!=undef && w !=undef) ? [r1      , r1+w]
	:(r2!=undef && w !=undef) ? [r2-w    , r2]
	:[1, 2]
;

// gibt [radius_unten, radius_oben] zurück
// Argumente:
//   r  - Radius oben und unten
//   r1 - Radius unten
//   r2 - Radius oben
//   d  - Durchmesser oben und unten 
//   d1 - Durchmesser unten
//   d2 - Durchmesser oben
// Regeln wie bei cylinder() von OpenSCAD
// - Durchmesser geht vor Radius
// - spezielle Angaben (r1, r2) gehen vor allgemeine Angaben (r)
// - ohne Angabe: r=1
function parameter_cylinder_r (r, r1, r2, d, d1, d2) =
	parameter_cylinder_r_basic (
		get_first_good(d /2, r),
		get_first_good(d1/2, r1),
		get_first_good(d2/2, r2))
;
function parameter_cylinder_r_basic (r, r1, r2) =
	get_first_good_2d (
		[r1,r2],
		[r1,r ],
		[r, r2],
		[r, r ],
		[1,1])
;

// gibt den Radius zurück
// Argumente:
//   r  - Radius
//   d  - Durchmesser
// Regeln wie bei circle() von OpenSCAD
// - Durchmesser geht vor Radius
// - ohne Angabe: r=1
function parameter_circle_r (r, d) = get_first_good (d/2, r, 1);

// wandelt das Argument 'size' um in einen Tupel [1,2,3]
// aus size=3       wird   [3,3,3]
// aus size=[1,2,3] bleibt [1,2,3]
function parameter_size_3d (size) =
	(is_list(size) && len(size)>0 && is_num(size[0])) ?
		(is_num(size[1])) ?
		(is_num(size[2])) ?
		 size                  // f([1,2,3])
		:[size[0], size[1], 0] // f([1,2])
		:[size[0], 0      , 0] // f([1])
	:(is_num (size)) ?
		 [size, size, size]    // f(1)
	:	 [1,1,1]               // f(undef)

;
function parameter_size_2d (size) =
	get_first_good_2d (size+[0,0], [size+0,size+0], [1,1])
;

// gibt den Winkel zurück
// Rückgabe:
//   [Öffnungswinkel, Anfangswinkel]
// Argumente:
//   angle     - Als Zahl  = Angabe Öffnungswinkel, Anfangswinkel wird auf 0 gesetzt
//             - Als Liste = [Öffnungswinkel, Anfangswinkel]
//   angle_std - Standartangabe des Winkels, wenn angle nicht gesetzt wurde
//               (Standart = [360, 0])
function parameter_angle (angle, angle_std) =
	(is_num (angle))                  ? [angle   , 0] :
	(is_list(angle) && len(angle)==2) ? angle         :
	(is_list(angle) && len(angle)==1) ? [angle[0], 0] :
	(is_list(angle) && len(angle) >2) ? [angle[0], angle[1]] :
	parameter_angle (angle_std, [360,0])
;

function parameter_mirror_vector_2d (v, v_std=[1,0]) =
	(is_list(v) && len(v)>=2) ? v : v_std
;
function parameter_mirror_vector_3d (v, v_std=[1,0,0]) =
	 !is_list(v) ? v_std
	:len(v)>=3   ? v
	:len(v)==2   ? [v[0],v[1],0]
	:v_std
;

// Wertet die Parameter edges_xxx vom Module cube_fillet() aus,
// gibt eine 4 elementige Liste zurück
// Argumente:
//   r         - Radius oder Breite
//   edge_list - 4-elementige Auswahlliste der jeweiligen Kanten,
//               wird mit r multipliziert
//             - als Zahl werden alle Elemente mit diesen Wert gesetzt
//             - andernfalls wird der Wert auf 0 gesetzt = nicht gefaste Kante
function parameter_edges_radius (edge_list, r) =
	is_list(edge_list) ?
		[ for (i=[0:3]) parameter_edge_radius (edge_list[i], r) ]
	:is_num(edge_list) ?
		[ for (i=[0:3]) parameter_edge_radius (edge_list,    r) ]
	:	[ for (i=[0:3]) 0 ]
;
function parameter_edge_radius (edge, r) =
	is_num(edge) ?
		is_num(r) ? edge * r
		:           edge
	: 0
;

// Wertet die Parameter type_xxx vom Module cube_fillet() aus,
// gibt eine 4 elementige Liste zurück
function parameter_types (type_list, type) =
	is_list(type_list) ?
		[ for (i=[0:3]) parameter_type (type_list[i], type) ]
	:	[ for (i=[0:3]) parameter_type (type_list,    type) ]
;
function parameter_type (type_x, type) =
	 (type_x == undef) ? parameter_type (type, 0)
	:(type_x < 0     ) ? parameter_type (type, 0)
	: type_x
;
