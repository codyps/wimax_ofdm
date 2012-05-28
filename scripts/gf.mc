

declare("xor", noun) $
"xor"(r,s) := (r and not s) or (not r and s)$ infix("xor") $

poly_add(a, b)   := map("xor", a, b) $
band(a, b)   := map("and", a, b) $

poly_mult_x(a) := append(a, 0)
poly_mult_x_reduced(a, p) := block([n:[],
	n:append(a, 0),
	if (first(n) = 0)
		then rest(poly_add(n, p))
		else rest(n)
) $

/*
blshift(a,b) :=
*/

makebits(name, num) := makelist (concat (name,i), i, num - 1, 0, -1) $

a : block([a:a], makebits(a, 8)) $
b : block([b:b], makebits(b, 8)) $


x : map(xor, a, b) ;

/* ffmul(a, b) :=
	block([aa: a, bb:b, r:0, t:t],
	while aa # 0 do (

	), )
	*/

