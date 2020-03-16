// operator_transform.scad
//
// Enthält zusätzliche Operatoren zum Transformieren von Objekten
//
// Aufbau: modul() {Objekt();}


// Spiegelt an der jeweiligen Achse wie die Hauptfunktionen
module mirror_x () { mirror([1,0,0]) children(); }
module mirror_y () { mirror([0,1,0]) children(); }
module mirror_z () { mirror([0,0,1]) children(); }
//
module mirror_copy_x () { mirror_copy([1,0,0]) children(); }
module mirror_copy_y () { mirror_copy([0,1,0]) children(); }
module mirror_copy_z () { mirror_copy([0,0,1]) children(); }
//
module mirror_at_x (p) { mirror_at([1,0,0], p) children(); }
module mirror_at_y (p) { mirror_at([0,1,0], p) children(); }
module mirror_at_z (p) { mirror_at([0,0,1], p) children(); }
//
module mirror_copy_at_x (p) { mirror_copy_at([1,0,0], p) children(); }
module mirror_copy_at_y (p) { mirror_copy_at([0,1,0], p) children(); }
module mirror_copy_at_z (p) { mirror_copy_at([0,0,1], p) children(); }

// erzeugt ein Objekt und ein gespiegeltes Objekt
module mirror_copy (v)
{
	V = !is_undef(v) ? v : [1,0,0];
	children(0);
	mirror(v)
	children(0);
}

// erzeugt ein gespiegeltes Objekt
// Spiegel an Position p
module mirror_at (v, p)
{
	V = !is_undef(v) ? v : [1,0,0];
	if (!is_undef(p))
		translate(p)
		mirror(V)
		translate(-p)
		children(0);
	else
		mirror(V) children(0);
}

// erzeugt ein Objekt und ein gespiegeltes Objekt
// Spiegel an Position p
module mirror_copy_at (v, p)
{
	children(0);
	mirror_at(v, p)
	children(0);
}

// spiegelt ein Objekt mehrfach (bis zu 3 mal) hintereinander
module mirror_repeat (v=[1,0,0], v2=undef, v3=undef)
{
	mirror(v) mirror_check(v2) mirror_check(v3) children(0);
}

// erzeugt ein Objekt und ein gespiegeltes Objekt
// spiegelt das Objekt mehrfach (bis zu 3 mal) hintereinander
module mirror_repeat_copy (v=[1,0,0], v2=undef, v3=undef)
{
	children(0);
	mirror(v) mirror_check(v2) mirror_check(v3) children(0);
}

module mirror_check (v)
{
	if (is_undef(v)) children(0);
	else mirror(v)   children(0);
}

// rotiert ein Objekt rückwärts
// Argumente wie bei rotate()
module rotate_backwards (a, v)
{
	if (is_list(a))
		rotate_x(-a[0]) rotate_y(-a[1]) rotate_z(-a[2]) children(0);
	else if (is_num(a))
		rotate(-a,v) children(0);
	else
		children(0);
}

// rotiert ein Objekt an der angegebenen Position
// Argumente:
// a, (v) - wie bei rotate()
// p      - wie bei translate()
module rotate_at (a, p, v)
{
	translate(p)
	rotate(a, v)
	translate(-p)
	children(0);
}

// rotiert ein Objekt rückwärts an der angegebenen Position
// Argumente wie rotate_at()
// a, (v) - wie bei rotate()
// p      - wie bei translate()
module rotate_backwards_at (a, p, v)
{
	translate(p)
	rotate_backwards(a, v)
	translate(-p)
	children(0);
}

// Objekt von in Richtung Z-Achse in Richtung Vektor v drehen
// a = Objekt um die eigene Achse drehen
module rotate_to_vector (v, a)
{
	V     = (is_list(v) && len(v)==3) ? v : [0,0,1];
	angle = is_num(a) ? a : 0;
	b     = acos(V[2]/norm(V)); // inclination angle
	c     = atan2(V[1],V[0]);   // azimuthal angle
	//
	rotate([0, b, c]) rotate_z(angle) children(0);
}
// Objekt von in Richtung Z-Achse in Richtung Vektor v rückwärts drehen
module rotate_backwards_to_vector (v, a)
{
	V     = (is_list(v) && len(v)==3) ? v : [0,0,1];
	angle = is_num(a) ? a : 0;
	b     = acos(V[2]/norm(V)); // inclination angle
	c     = atan2(V[1],V[0]);   // azimuthal angle
	//
	rotate_backwards_z(angle) rotate_backwards([0, b, c]) children(0);
}

// Objekt von in Richtung Z-Achse in Richtung Vektor v drehen an der angegebenen Position
module rotate_to_vector_at (v, p, a)
{
	translate(p)
	rotate_to_vector(v, a)
	translate(-p)
	children(0);
}
// Objekt von in Richtung Z-Achse in Richtung Vektor v rückwärts drehen an der angegebenen Position
module rotate_backwards_to_vector_at (v, p, a)
{
	translate(p)
	rotate_backwards_to_vector(v, a)
	translate(-p)
	children(0);
}

// rotiert um die jeweilige Achse wie die Hauptfunktion
module rotate_x (a) { if (!is_num(a)) children(0); else  rotate([a,0,0]) children(0); }
module rotate_y (a) { if (!is_num(a)) children(0); else  rotate([0,a,0]) children(0); }
module rotate_z (a) { if (!is_num(a)) children(0); else  rotate([0,0,a]) children(0); }
//
module rotate_backwards_x (a) { if (!is_num(a)) children(0); else  rotate_backwards([a,0,0]) children(0); }
module rotate_backwards_y (a) { if (!is_num(a)) children(0); else  rotate_backwards([0,a,0]) children(0); }
module rotate_backwards_z (a) { if (!is_num(a)) children(0); else  rotate_backwards([0,0,a]) children(0); }
//
module rotate_at_x (a, p) { if (!is_num(a)) children(0); else  rotate_at([a,0,0], p) children(0); }
module rotate_at_y (a, p) { if (!is_num(a)) children(0); else  rotate_at([0,a,0], p) children(0); }
module rotate_at_z (a, p) { if (!is_num(a)) children(0); else  rotate_at([0,0,a], p) children(0); }
//
module rotate_backwards_at_x (a, p) { if (!is_num(a)) children(0); else  rotate_backwards_at([a,0,0], p) children(0); }
module rotate_backwards_at_y (a, p) { if (!is_num(a)) children(0); else  rotate_backwards_at([0,a,0], p) children(0); }
module rotate_backwards_at_z (a, p) { if (!is_num(a)) children(0); else  rotate_backwards_at([0,0,a], p) children(0); }

// verschiebt in der jeweiligen Achse wie die Hauptfunktion
module translate_x (l) { if (!is_num(l)) children(0); else  translate([l,0,0]) children(0); }
module translate_y (l) { if (!is_num(l)) children(0); else  translate([0,l,0]) children(0); }
module translate_z (l) { if (!is_num(l)) children(0); else  translate([0,0,l]) children(0); }
module translate_xy (t)
{
	if (is_list(t) && len(t)>=2 && is_num(t[0]) && is_num(t[1]))
		translate([t[0],t[1],0]) children(0);
	else
		children(0);
}

// vergrößert das Objekt an der jeweiligen Achse wie die Hauptfunktion
module scale_x (f) { if (!is_num(f)) children(0); else  scale([l,0,0]) children(0); }
module scale_y (f) { if (!is_num(f)) children(0); else  scale([0,l,0]) children(0); }
module scale_z (f) { if (!is_num(f)) children(0); else  scale([0,0,l]) children(0); }

