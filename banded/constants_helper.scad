// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Hilfsfunktionen, um Konstanten zu berechnen


function calculate_pi (n=21) =
	4 / calculate_pi_continued_fraction(n)
;
function calculate_pi_continued_fraction (n=21, i=0) =
	let(
	j = i+1,
	b = 2*i + 1,
	a = j*j
	)
	i>=n ? b :
	b + a / calculate_pi_continued_fraction(n, i+1)
;

function get_max_accuracy_pi (n=21, pi1=0, pi2=1) =
	(pi1==pi2) ?
		pi1
	:	get_max_accuracy_pi(n+1, pi2, calculate_pi(n))
;
function check_accuracy_pi(n=21) = calculate_pi(n)==calculate_pi(n+1);

