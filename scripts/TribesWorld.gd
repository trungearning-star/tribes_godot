extends RefCounted
class_name TribesWorld
## Port of original class `b` (b.java) — world/tribe simulation.
## IN PROGRESS. Ported so far: field declarations, constructor, bind_engine()
## (was `a(f)`), and reset_state() (was `void_a()`). The remaining ~5500 lines
## (all other methods) are being ported incrementally — see
## docs/PORTING_NOTES.md for the running checklist of what's done vs pending.
##
## Naming: kept the original decompiled field names 1:1 (var_byte_a, aR, aQ, ...)
## on purpose, even though they're meaningless — renaming while porting this
## much magic-offset code would make it far harder to diff against
## docs/original_source/b.java to catch transcription mistakes. A readable
## rename pass can happen after the port is verified working.
##
## IMPORTANT — byte[] storage: Java `byte` is SIGNED 8-bit (-128..127) and this
## code compares/branches on that sign a lot. Godot's PackedByteArray stores
## UNSIGNED 0..255 — using it here would silently corrupt every value >127 that
## the original treated as negative. So every Java `byte[]` is ported as
## PackedInt32Array holding values already in Java's signed range, and every
## write goes through JNum.to_byte() to keep the exact truncation/wraparound
## behavior. (Caught and fixed this after the first pass — see PORTING_NOTES.md.)
##
## Method-name collisions: Java allows overloads (same name, different params);
## GDScript doesn't. CFR already partly disambiguates by return type
## (a / byte_a / void_a / int_a / boolean_a...), but several original names still
## collide across different parameter lists. Disambiguation scheme used from here
## on: <original_name>_<param type codes>, i=int, b=byte, z=boolean, s=short,
## e.g. `void_a(int,int)` -> void_a_ii, `void_a(boolean)` -> void_a_z,
## `byte_a(int,int,int,int)` -> byte_a_iiii. Zero-arg / already-unique names keep
## a plain descriptive name instead (reset_state, bind_engine). Every renamed
## method's comment states the original Java signature for traceability.

var var_f_a # : GameEngine (f) — set via bind_engine()

var var_byte_arr_a: PackedInt32Array  # Java byte[] (signed) — NOT PackedByteArray, see note below
var var_byte_arr_arr_arr_a: Array = []      # byte[][][]
var var_byte_arr_arr_arr_b: Array = []      # byte[][][]
var var_short_arr_arr_a: Array = []         # short[][]
var var_byte_arr_b: PackedInt32Array  # Java byte[] (signed) — NOT PackedByteArray, see note below
var var_short_arr_a: PackedInt32Array
var var_short_arr_b: PackedInt32Array
var var_short_arr_c: PackedInt32Array
var var_byte_arr_arr_arr_c: Array = []      # byte[][][]
var var_byte_arr_arr_a: Array = []          # byte[][]
var var_byte_arr_arr_b: Array = []          # byte[][]
var var_byte_a: int = 0
var var_byte_b: int = 0
var var_byte_c: int = 0
var var_byte_arr_c: PackedInt32Array  # Java byte[] (signed) — NOT PackedByteArray, see note below
var var_byte_arr_d: PackedInt32Array  # Java byte[] (signed) — NOT PackedByteArray, see note below
var var_byte_arr_e: PackedInt32Array  # Java byte[] (signed) — NOT PackedByteArray, see note below
var var_byte_arr_f: PackedInt32Array  # Java byte[] (signed) — NOT PackedByteArray, see note below
var var_byte_arr_arr_arr_d: Array = []      # byte[][][]
var var_byte_arr_g: PackedInt32Array  # Java byte[] (signed) — NOT PackedByteArray, see note below
var var_byte_arr_arr_arr_e: Array = []      # byte[][][]
var var_byte_arr_h: PackedInt32Array  # Java byte[] (signed) — NOT PackedByteArray, see note below
var var_byte_d: int = 0
var var_byte_e: int = 0
var var_byte_arr_arr_c: Array = []          # byte[][]
var var_int_a: int = 0
var var_int_b: int = 0
var var_int_c: int = 0
var var_int_d: int = 0
var var_int_e: int = 0
var var_int_f: int = 0
var var_int_g: int = 0
var var_int_h: int = 0
var var_byte_f: int = 0
var var_byte_g: int = 0
var var_int_i: int = 0
var var_boolean_arr_a: Array = []           # boolean[]
var var_int_j: int = 0
var var_int_k: int = 0
var var_int_l: int = 0
var var_int_m: int = 0
var var_int_n: int = 0
var var_byte_arr_arr_d: Array = []          # byte[][]
var var_byte_h: int = 0
var var_byte_i: int = 0
var var_byte_j: int = 0
var var_byte_k: int = 0
var var_byte_l: int = 0
var var_byte_m: int = 0
var var_int_o: int = 0
var var_int_p: int = 0
var var_int_q: int = 0
var var_int_r: int = 0
var var_byte_n: int = 0
var var_byte_o: int = 0
var var_byte_p: int = 0
var var_int_s: int = 0
var var_int_t: int = 0
var var_byte_q: int = 0
var var_byte_r: int = 0
var var_short_arr_d: PackedInt32Array
var var_int_u: int = 0
var var_int_v: int = 0
var var_int_w: int = 0
var var_int_x: int = 0
var var_int_y: int = 0
var var_int_z: int = 0
var var_int_A: int = 0
var var_int_B: int = 0
var var_int_C: int = 0
var var_int_D: int = 0
var var_int_E: int = 0
var var_int_F: int = 0
var var_boolean_a: bool = false
var var_boolean_b: bool = false
var var_boolean_c: bool = false
var var_int_G: int = 0
var var_int_H: int = 0
var var_boolean_d: bool = false
var var_byte_s: int = 0
var var_int_I: int = 0
var var_int_J: int = 0
var var_int_K: int = 0
var var_byte_t: int = 0
var var_byte_u: int = 0
var var_int_L: int = 0
var var_byte_arr_i: PackedInt32Array  # Java byte[] (signed) — NOT PackedByteArray, see note below
var var_byte_v: int = 0
var var_byte_w: int = 0
var var_byte_x: int = 0
var var_int_M: int = 0
var var_byte_y: int = 0
var var_byte_z: int = 0
var var_byte_A: int = 0
var var_byte_B: int = 0
var var_byte_C: int = 0
var var_byte_D: int = 0
var var_byte_E: int = 0
var var_byte_F: int = 0
var var_int_N: int = 0
var var_int_O: int = 0
var var_int_P: int = 0
var var_int_Q: int = 0
var var_byte_arr_arr_e: Array = []          # byte[][]
var var_byte_G: int = 0
var var_byte_H: int = 0
var var_boolean_e: bool = false
var var_int_R: int = 0
var var_int_S: int = 0
var var_boolean_f: bool = false
var T: int = 0
var var_boolean_g: bool = false
var U: int = 0
var V: int = 0
var W: int = 0
var X: int = 0
var Y: int = 0
var Z: int = 0
var aa: int = 0
var ab: int = 0
var ac: int = 0
var var_boolean_h: bool = false
var ad: int = 0
var ae: int = 0
var af: int = 0
var var_byte_I: int = 0
var ag: int = 0
var ah: int = 0
var ai: int = 0
var aj: int = 0
var ak: int = 0
var al: int = 0
var am: int = 0
var an: int = 0
var ao: int = 0
var ap: int = 0
var aq: int = 0
var ar: int = 0
var as_: int = 0   # `as` is a GDScript keyword -> renamed as_
var at: int = 0
var au: int = 0
var av: int = 0
var aw: int = 0
var ax: int = 0
var ay: int = 0
var az: int = 0
var aA: int = 0
var aB: int = 0
var aC: int = 0
var aD: int = 0
var aE: int = 0
var aF: int = 0
var aG: int = 0
var aH: int = 0
var aI: int = 0
var aJ: int = 0
var var_byte_arr_arr_f: Array = []          # byte[][]
var var_byte_arr_arr_g: Array = []          # byte[][]
var aK: int = 0
var aL: int = 0
var aM: int = 0
var var_byte_J: int = 0
var var_byte_K: int = 0
var var_byte_L: int = 0
var aN: int = 0
var aO: int = 0
var aP: int = 0
var var_byte_arr_j: PackedInt32Array  # Java byte[] (signed) — NOT PackedByteArray, see note below
var var_byte_M: int = 0
var var_byte_N: int = 0
var var_byte_O: int = 0
var var_byte_P: int = 0
var var_byte_Q: int = 0
var var_byte_R: int = 0
var aQ: int = 0
var aR: int = 0
var aS: int = 0
var aT: int = 0
var aU: int = 0
var aV: int = 0
var aW: int = 0
var aX: int = 0
var aY: int = 0
var var_int_arr_a: PackedInt32Array = PackedInt32Array()
var var_byte_S: int = 0
var var_byte_arr_k: PackedInt32Array  # Java byte[] (signed) — NOT PackedByteArray, see note below


func _init() -> void:
	# public b()
	var_int_arr_a.resize(26)
	var_int_arr_a[0] = 0
	var_int_arr_a[1] = 1
	var_int_arr_a[2] = 3
	var_int_arr_a[3] = 7
	var_int_arr_a[4] = 15
	var_int_arr_a[5] = 31
	var_int_arr_a[6] = 63
	var_int_arr_a[7] = 127
	var_int_arr_a[8] = 255
	var_int_arr_a[9] = 511
	var_int_arr_a[10] = 1023
	var_int_arr_a[11] = 2047
	var_int_arr_a[12] = 4095
	var_int_arr_a[13] = 8191
	var_int_arr_a[14] = 16383
	var_int_arr_a[15] = 32767          # Short.MAX_VALUE
	var_int_arr_a[16] = 65535
	var_int_arr_a[17] = 131071
	var_int_arr_a[18] = 262143
	var_int_arr_a[19] = 524287
	var_int_arr_a[20] = 1048575
	var_int_arr_a[21] = 0x1FFFFF
	var_int_arr_a[22] = 0x3FFFFF
	var_int_arr_a[23] = 0x7FFFFF
	var_int_arr_a[24] = 0xFFFFFF
	var_int_arr_a[25] = 0x1FFFFFF


## final void a(f f2) — link this world object to the owning game engine and
## alias several of its arrays (Java kept these as separate field references
## to the *same* array objects; GDScript arrays/Packed*Array are also
## reference/copy-on-write types for Array, but PackedByteArray/PackedInt32Array
## assignment COPIES in GDScript, not aliases — see NOTE below).
func bind_engine(f_ref) -> void:
	var_f_a = f_ref
	var_byte_arr_arr_b = var_f_a.var_byte_arr_arr_c
	# NOTE (packed-array aliasing gap): in Java these four lines make var_byte_arr_a /
	# var_short_arr_arr_a / var_byte_arr_b / var_short_arr_a / var_short_arr_b /
	# var_short_arr_c on `b` literally the SAME array object as on `f` — writes
	# through either reference are visible on both. PackedByteArray/PackedInt32Array
	# in GDScript are value types (copied on assignment), so this line-for-line
	# translation would silently break that sharing. This needs one of:
	#   (a) convert these particular arrays to a shared wrapper object, or
	#   (b) have `b` read/write directly through var_f_a.xxx instead of a local alias.
	# Flagging here rather than guessing; will resolve when porting the methods
	# that actually use var_byte_arr_a / var_short_arr_arr_a, etc., so the fix
	# matches real usage instead of being speculative.
	var_byte_arr_a = var_f_a.var_byte_arr_e
	var_short_arr_arr_a = var_f_a.var_short_arr_arr_a
	var_byte_arr_b = var_f_a.var_byte_arr_a
	var_short_arr_a = var_f_a.var_short_arr_a
	var_short_arr_b = var_f_a.var_short_arr_b
	var_short_arr_c = var_f_a.var_short_arr_c


## final void void_a() — reset per-game state. Renamed reset_state() for clarity
## at the call-site level (callers ported later will call this by new name).
func reset_state() -> void:
	var_byte_g = 0
	var_byte_f = 0
	var_int_F = 0
	var_byte_J = 0
	var_byte_L = 0
	var_byte_S = 1
	var_byte_K = 50
	var_f_a.var_c_a.clear_queue()  # was var_f_a.var_c_a.a() -> DialogText.clear_queue()
	var_byte_I = JNum.to_byte(3 if var_f_a.var_byte_q == 2 else 0)
	var_byte_O = JNum.to_byte(-1)
	aR = -1
	aQ = -1
	var_byte_R = JNum.to_byte(128 if (var_f_a.var_byte_q == 2 or var_f_a.var_byte_q == 4) else 0)
	var_byte_Q = JNum.to_byte(-1)
	var_byte_P = JNum.to_byte(-1)
	var_int_a = 0
	while var_int_a < 3:
		var_f_a.var_byte_arr_t[var_int_a] = 0
		var_int_a += 1
	var_int_a = 0
	while var_int_a < 10:
		var_byte_arr_arr_c[4][var_int_a] = 0
		var_int_a += 1
	var_int_a = 0
	while var_int_a < 6:
		var_short_arr_d[var_int_a] = -1
		var_int_a += 1
	var_int_a = 0
	while var_int_a < 10:
		var_byte_arr_arr_f[0][var_int_a] = 0
		var_int_a += 1
	var_int_a = 0
	while var_int_a < 20:
		var_byte_arr_arr_g[0][var_int_a] = 0
		var_int_a += 1
	var_int_a = 0
	while var_int_a < 50:
		var_byte_arr_j[var_int_a] = JNum.to_byte(var_int_a)
		var_int_a += 1
	_void_j()   # TODO: port void_j() — not yet reached in the source pass
	var_int_G = var_short_arr_a[219] + var_f_a.var_byte_q * 4


func _void_j() -> void:
	push_warning("TribesWorld._void_j() not ported yet (original: private void void_j(), defined at b.java:4990)")


# ---------------------------------------------------------------------------
# Pathfinding / movement-step cluster (b.java lines 283-419)
# ---------------------------------------------------------------------------

## original: private byte a(int n, int n2, int n3, int n4, int n5, int n6)
func a_iiiiii(n: int, n2: int, n3: int, n4: int, n5: int, n6: int) -> int:
	# NOTE: original wraps the whole body in try{}catch(Exception){} and always
	# falls through to the same `return this.var_byte_arr_f[this.var_byte_arr_g[0]];`
	# whether or not an exception was thrown. GDScript has no catch-all try/except,
	# so any runtime error here (e.g. bad array index) would crash instead of being
	# silently swallowed like the original. Flagging this pattern now since it
	# recurs constantly through b.java/f.java — will revisit once enough of the
	# array-init methods are ported that these indices are provably always in range.
	var_int_i = 65 if n6 == 0 else 5
	a_iiiii(n2, n, n4, n3, n6)
	var_int_a = 0
	while var_int_a < var_byte_c:
		f_i(n6)
		if not var_boolean_arr_a[0] and not var_boolean_arr_a[1]:
			void_d_i(n6)
			if var_int_m < 0:
				var_byte_arr_f[var_byte_arr_g[0]] = JNum.to_byte(var_byte_arr_arr_arr_e[0][2][var_int_a] + 1)
				break
			var_byte_arr_f[var_byte_arr_g[(var_int_m & 1) + 1]] = JNum.to_byte((var_int_m >> 1) + 1)
			var_boolean_arr_a[var_int_m & 1] = true
			void_a_z(false)
			var_boolean_arr_a[var_int_m & 1] = false
			break
		void_a_z(true)
		if var_byte_arr_f[var_byte_arr_g[0]] + n5 >= var_int_i:
			break
		var_int_a += 1
	var_int_j = 0
	while var_int_j < var_byte_c:
		if var_byte_arr_arr_arr_e[1][0][var_int_j] >= 0:
			var_f_a.var_byte_arr_arr_b[var_byte_arr_arr_arr_e[1][1][var_int_j]][var_byte_arr_arr_arr_e[1][0][var_int_j]] = var_byte_arr_h[var_int_j]
		var_int_j += 1
	if var_byte_arr_f[var_byte_arr_g[0]] + n5 >= var_int_i:
		var_byte_arr_f[var_byte_arr_g[0]] = JNum.to_byte(var_int_i - n5)
	var_int_a = 0
	while var_int_a < var_byte_arr_f[var_byte_arr_g[0]]:
		if n6 == 0:
			var_byte_arr_arr_arr_a[0][var_int_v][var_int_a + n5] = var_byte_arr_arr_arr_d[var_byte_arr_g[0]][0][var_int_a]
			var_byte_arr_arr_arr_a[1][var_int_v][var_int_a + n5] = var_byte_arr_arr_arr_d[var_byte_arr_g[0]][1][var_int_a]
		else:
			var_byte_arr_arr_arr_b[0][var_int_v][var_int_a + n5] = var_byte_arr_arr_arr_d[var_byte_arr_g[0]][0][var_int_a]
			var_byte_arr_arr_arr_b[1][var_int_v][var_int_a + n5] = var_byte_arr_arr_arr_d[var_byte_arr_g[0]][1][var_int_a]
		var_int_a += 1
	if n6 == 0:
		var_byte_arr_a[707 + var_int_v] = 0
		var_byte_arr_a[3030 + var_int_v] = 0
		P()
	return var_byte_arr_f[var_byte_arr_g[0]]


## original: private byte byte_a(int n, int n2, int n3, int n4)
func byte_a_iiii(n: int, n2: int, n3: int, n4: int) -> int:
	var_byte_arr_arr_d[0][0] = JNum.to_byte(n2)
	var_byte_arr_arr_d[1][0] = JNum.to_byte(n)
	var_int_d = 1
	a_iiiii(n2, n, n4, n3, 0)
	var_int_a = 0
	while var_int_a < var_byte_c:
		f_i(0)
		if not var_boolean_arr_a[0] and not var_boolean_arr_a[1]:
			void_d_i(0)
			var_byte_arr_arr_d[0][var_int_d] = (var_byte_arr_arr_arr_e[0][0][var_int_a] if var_int_m < 0
				else var_byte_arr_arr_arr_d[var_byte_arr_g[(var_int_m & 1) + 1]][0][var_int_m >> 1])
			var_byte_arr_arr_d[1][var_int_d] = (var_byte_arr_arr_arr_e[0][1][var_int_a] if var_int_m < 0
				else var_byte_arr_arr_arr_d[var_byte_arr_g[(var_int_m & 1) + 1]][1][var_int_m >> 1])
			var_int_j = 0
			while var_int_j < var_byte_c:
				if var_byte_arr_arr_arr_e[1][0][var_int_j] >= 0:
					var_f_a.var_byte_arr_arr_b[var_byte_arr_arr_arr_e[1][1][var_int_j]][var_byte_arr_arr_arr_e[1][0][var_int_j]] = var_byte_arr_h[var_int_j]
				var_int_j += 1
			return JNum.to_byte(var_int_d)
		var_int_b = 1 if (var_boolean_arr_a[0] and var_byte_arr_f[var_byte_arr_g[1]] < var_byte_arr_f[var_byte_arr_g[2]]) or not var_boolean_arr_a[1] else 2
		var_byte_arr_arr_d[0][var_int_d] = var_byte_arr_arr_arr_d[var_byte_arr_g[var_int_b]][0][int(var_byte_arr_f[var_byte_arr_g[var_int_b]] / 2)]
		var_byte_arr_arr_d[1][var_int_d] = var_byte_arr_arr_arr_d[var_byte_arr_g[var_int_b]][1][int(var_byte_arr_f[var_byte_arr_g[var_int_b]] / 2)]
		var_int_a = var_byte_arr_e[var_byte_arr_g[var_int_b]]
		var_int_d += 1
		var_int_a += 1
	var_int_l = 0
	var_byte_arr_arr_d[0][var_int_d] = JNum.to_byte(n4)
	var_byte_arr_arr_d[1][var_int_d] = JNum.to_byte(n3)
	var_int_j = 0
	while var_int_j < var_byte_c:
		if var_byte_arr_arr_arr_e[1][0][var_int_j] >= 0:
			var_f_a.var_byte_arr_arr_b[var_byte_arr_arr_arr_e[1][1][var_int_j]][var_byte_arr_arr_arr_e[1][0][var_int_j]] = var_byte_arr_h[var_int_j]
		var_int_j += 1
	return JNum.to_byte(var_int_d)


## original: private void void_d(int n)
func void_d_i(n: int) -> void:
	int_a_iii(var_byte_arr_arr_arr_e[0][0][var_int_a], var_byte_arr_arr_arr_e[0][1][var_int_a], n)
	var_int_l = ((var_byte_q - var_byte_arr_arr_arr_e[0][0][var_int_a]) * (var_byte_q - var_byte_arr_arr_arr_e[0][0][var_int_a])
		+ (var_byte_r - var_byte_arr_arr_arr_e[0][1][var_int_a]) * (var_byte_r - var_byte_arr_arr_arr_e[0][1][var_int_a]))
	var_int_m = -1
	if var_int_l > var_int_B:
		var_int_n = var_byte_arr_f[var_byte_arr_g[1 if var_byte_arr_f[var_byte_arr_g[1]] > var_byte_arr_f[var_byte_arr_g[2]] else 2]] * 2
		var_int_j = 0
		while var_int_j < var_int_n:
			if var_byte_arr_f[var_byte_arr_g[(var_int_j & 1) + 1]] > (var_int_j >> 1):
				var_int_k = ((var_byte_q - var_byte_arr_arr_arr_d[var_byte_arr_g[(var_int_j & 1) + 1]][0][var_int_j >> 1]) * (var_byte_q - var_byte_arr_arr_arr_d[var_byte_arr_g[(var_int_j & 1) + 1]][0][var_int_j >> 1])
					+ (var_byte_r - var_byte_arr_arr_arr_d[var_byte_arr_g[(var_int_j & 1) + 1]][1][var_int_j >> 1]) * (var_byte_r - var_byte_arr_arr_arr_d[var_byte_arr_g[(var_int_j & 1) + 1]][1][var_int_j >> 1]))
				if var_int_k < var_int_l:
					var_int_l = var_int_k
					var_int_m = var_int_j
					if int(int_a_iii(var_byte_arr_arr_arr_d[var_byte_arr_g[(var_int_j & 1) + 1]][0][var_int_j >> 1], var_byte_arr_arr_arr_d[var_byte_arr_g[(var_int_j & 1) + 1]][1][var_int_j >> 1], n) / 10) <= var_int_B:
						return
			var_int_j += 1


## original: private byte byte_b(int n, int n2, int n3, int n4)
func byte_b_iiii(n: int, n2: int, n3: int, n4: int) -> int:
	var_byte_i = 0
	var_byte_h = byte_a_iiii(n, n2, n3, n4)
	var_byte_j = 0
	while var_byte_j < var_byte_h:
		var_byte_i = JNum.to_byte(var_byte_i + a_iiiiii(var_byte_arr_arr_d[1][var_byte_j], var_byte_arr_arr_d[0][var_byte_j], var_byte_arr_arr_d[1][var_byte_j + 1], var_byte_arr_arr_d[0][var_byte_j + 1], var_byte_i, 0))
		if not var_boolean_arr_a[0] and not var_boolean_arr_a[1]:
			break
		var_byte_j = JNum.to_byte(var_byte_j + 1)
	if var_f_a.var_byte_q == 3 and var_byte_i > 2:
		return 2
	return var_byte_i


# ---------------------------------------------------------------------------
# Stubs for methods referenced above but not yet reached in the sequential
# source pass. Each will be replaced with a real port when we get to its
# location in b.java. Calling one of these before then will loudly warn
# instead of silently doing nothing, so testing surfaces gaps immediately.
# ---------------------------------------------------------------------------

## original: private void a(int n, int n2, int n3, int n4, int n5)  (b.java:466)
func a_iiiii(n: int, n2: int, n3: int, n4: int, n5: int) -> void:
	# try{...}catch(Exception){} block — GDScript has no catch-all; port body directly.
	# If any runtime error occurs here (bad index etc.) it will crash instead of being
	# silently swallowed like the original. Will revisit if needed once more context is ported.
	void_a_ii(n3 - n, n4 - n2)
	var_int_a = 0
	while var_int_a < 3:
		var_byte_arr_d[var_int_a << 1] = JNum.to_byte(n)
		var_byte_arr_d[(var_int_a << 1) + 1] = JNum.to_byte(n2)
		var_int_a += 1
	e_i(n5)
	var_int_b = 1000
	var_int_a = 0
	while var_int_a < 3:
		if var_byte_arr_e[var_int_a] < var_int_b:
			var_int_b = var_byte_arr_e[var_int_a]
			var_byte_arr_g[0] = JNum.to_byte(var_int_a)
		var_int_a += 1
	var_byte_arr_g[1] = JNum.to_byte((var_byte_arr_g[0] + 1) % 3)
	var_byte_arr_g[2] = JNum.to_byte((var_byte_arr_g[0] + 2) % 3)
	var_byte_d = 0
	var_byte_c = 0
	if var_byte_arr_e[var_byte_arr_g[0]] > 0:
		var_int_a = 0
		while var_int_a < var_byte_arr_f[var_byte_arr_g[0]]:
			var_byte_e = var_byte_d
			var by: int = var_byte_arr_arr_arr_d[var_byte_arr_g[0]][1][var_int_a]
			var by2: int = var_byte_arr_arr_arr_d[var_byte_arr_g[0]][0][var_int_a]
			var_byte_d = JNum.to_byte(0 if var_byte_arr_arr_b[by][by2] == 0 else byte_a_iiii(by2, by, n5))
			if var_byte_e == 0 and var_byte_d != 0:
				if var_byte_c >= 10:
					break  # break out of the while loop (equivalent to break block10 label in Java)
				var_byte_arr_arr_arr_e[0][0][var_byte_c] = JNum.to_byte(n if var_int_a == 0 else var_byte_arr_arr_arr_d[var_byte_arr_g[0]][0][var_int_a - 1])
				var_byte_arr_arr_arr_e[0][1][var_byte_c] = JNum.to_byte(n2 if var_int_a == 0 else var_byte_arr_arr_arr_d[var_byte_arr_g[0]][1][var_int_a - 1])
				var_byte_arr_arr_arr_e[0][2][var_byte_c] = JNum.to_byte(var_int_a - 1)
				var_byte_arr_arr_arr_e[1][0][var_byte_c] = -1
				var_byte_c = JNum.to_byte(var_byte_c + 1)
			elif var_byte_e != 0 and var_byte_d == 0:
				var_byte_arr_arr_arr_e[1][0][var_byte_c - 1] = by2
				var_byte_arr_arr_arr_e[1][1][var_byte_c - 1] = by
				var_byte_arr_arr_arr_e[1][2][var_byte_c - 1] = JNum.to_byte(var_int_a)
				var_byte_arr_h[var_byte_c - 1] = var_f_a.var_byte_arr_arr_b[by][by2]
				var_f_a.var_byte_arr_arr_b[by][by2] = JNum.to_byte(256 - var_byte_c)
			var_int_a += 1

## original: private void void_a(int n, int n2)  (b.java:520)
func void_a_ii(n: int, n2: int) -> void:
	var_byte_a = 0
	if n > 0:
		var_byte_a = JNum.to_byte(var_byte_a + 4)
	else:
		n *= -1
	if n2 > 0:
		var_byte_a = JNum.to_byte(var_byte_a + 2)
	else:
		n2 *= -1
	if n > n2:
		var_byte_a = JNum.to_byte(var_byte_a + 1)
		var_byte_arr_c[0] = JNum.to_byte(n - n2)
		var_byte_arr_c[1] = JNum.to_byte(n2)
		return
	var_byte_arr_c[0] = JNum.to_byte(n2 - n)
	var_byte_arr_c[1] = JNum.to_byte(n)

## original: private void e(int n)  (b.java:542)
func e_i(n: int) -> void:
	var_int_a = 0
	while var_int_a < 3:
		var_byte_arr_f[var_int_a] = JNum.to_byte(var_byte_arr_c[0] + var_byte_arr_c[1])
		var_byte_arr_e[var_int_a] = 0
		var_int_a += 1
	var_int_e = 0
	while var_int_e < 2:
		var_int_c = 0
		var_int_a = var_int_e
		while var_int_a != 2 - 3 * var_int_e:
			var_int_b = 0
			while var_int_b < var_byte_arr_c[var_int_a]:
				var n2: int = var_int_e << 1
				var_byte_arr_d[n2] = JNum.to_byte(var_byte_arr_d[n2] + var_byte_arr_b[var_short_arr_a[0] + var_byte_a * 4 + var_int_a * 2])
				var n3: int = (var_int_e << 1) + 1
				var_byte_arr_d[n3] = JNum.to_byte(var_byte_arr_d[n3] + var_byte_arr_b[var_short_arr_a[0] + var_byte_a * 4 + var_int_a * 2 + 1])
				var_byte_arr_arr_arr_d[var_int_e][0][var_int_c] = var_byte_arr_d[var_int_e << 1]
				var_byte_arr_arr_arr_d[var_int_e][1][var_int_c] = var_byte_arr_d[(var_int_e << 1) + 1]
				var n4: int = var_int_e
				var_byte_arr_e[n4] = JNum.to_byte(var_byte_arr_e[n4] + (0 if var_byte_arr_arr_b[var_byte_arr_d[(var_int_e << 1) + 1]][var_byte_arr_d[var_int_e << 1]] == 0 else byte_a_iiii(var_byte_arr_d[var_int_e << 1], var_byte_arr_d[(var_int_e << 1) + 1], n)))
				var_int_b += 1
				var_int_c += 1
			var_int_a += 1 - 2 * var_int_e
		var_int_e += 1
	var_int_e = 0
	var_int_f = 0
	var_int_g = var_byte_arr_c[1] * 50 / var_byte_arr_c[1] if var_byte_arr_c[1] > 0 else 1000000
	var_int_b = var_int_g
	var_int_a = 0
	while var_int_a < var_byte_arr_c[0] + var_byte_arr_c[1]:
		if var_int_b >= 50 and var_int_e < var_byte_arr_c[0] or var_int_f >= var_byte_arr_c[1]:
			var_byte_arr_d[4] = JNum.to_byte(var_byte_arr_d[4] + var_byte_arr_b[var_short_arr_a[0] + var_byte_a * 4 + 0])
			var_byte_arr_d[5] = JNum.to_byte(var_byte_arr_d[5] + var_byte_arr_b[var_short_arr_a[0] + var_byte_a * 4 + 1])
			var_int_e += 1
			var_int_b -= 50
		else:
			var_byte_arr_d[4] = JNum.to_byte(var_byte_arr_d[4] + var_byte_arr_b[var_short_arr_a[0] + var_byte_a * 4 + 2])
			var_byte_arr_d[5] = JNum.to_byte(var_byte_arr_d[5] + var_byte_arr_b[var_short_arr_a[0] + var_byte_a * 4 + 3])
			var_int_f += 1
			var_int_b += var_int_g
		var_byte_arr_arr_arr_d[2][0][var_int_a] = var_byte_arr_d[4]
		var_byte_arr_arr_arr_d[2][1][var_int_a] = var_byte_arr_d[5]
		var_byte_arr_e[2] = JNum.to_byte(var_byte_arr_e[2] + (0 if var_byte_arr_arr_b[var_byte_arr_d[5]][var_byte_arr_d[4]] == 0 else byte_a_iiii(var_byte_arr_d[4], var_byte_arr_d[5], n)))
		var_int_a += 1

## original: private void f(int n)  (b.java:595)
func f_i(n: int) -> void:
	# try{...}catch(Exception){} — same note as other methods with swallowed exceptions
	var_int_g = 1
	var_int_e = 1
	while var_int_e < 3:
		var_int_h = var_byte_arr_g[var_int_e]
		var_byte_arr_f[var_int_h] = 0
		var_boolean_arr_a[var_int_e - 1] = false
		var_byte_b = var_byte_arr_b[var_short_arr_a[3] + var_byte_arr_arr_arr_d[var_byte_arr_g[0]][0][var_byte_arr_arr_arr_e[0][2][var_int_a] + 1] - var_byte_arr_arr_arr_e[0][0][var_int_a] + (var_byte_arr_arr_arr_d[var_byte_arr_g[0]][1][var_byte_arr_arr_arr_e[0][2][var_int_a] + 1] - var_byte_arr_arr_arr_e[0][1][var_int_a]) * 3 + 4]
		var_byte_arr_d[var_int_h * 2] = var_byte_arr_arr_arr_e[0][0][var_int_a]
		var_byte_arr_d[var_int_h * 2 + 1] = var_byte_arr_arr_arr_e[0][1][var_int_a]
		var_int_b = 0
		while var_int_b < 65:
			var by: int
			var_int_f = 0
			while var_int_f < 8:
				by = JNum.to_byte(var_byte_arr_d[var_int_h * 2] + var_byte_arr_b[var_short_arr_a[1] + var_byte_b])
				var by2: int = JNum.to_byte(var_byte_arr_d[var_int_h * 2 + 1] + var_byte_arr_b[var_short_arr_a[1] + 8 + var_byte_b])
				var condition_check: int = 2 if (by >= var_f_a.var_short_c or by2 >= var_f_a.var_short_d or by < 0 or by2 < 0) else (0 if var_byte_arr_arr_b[by2][by] == 0 else byte_a_iiii(by, by2, n))
				if condition_check == 2:
					var_int_b = 130
					break
				if condition_check == 0:
					if (var_byte_b & 1) > 0:
						by = var_f_a.var_byte_arr_arr_b[var_byte_arr_d[var_int_h * 2 + 1] + var_byte_arr_b[var_short_arr_a[1] + 8 + ((var_byte_b + var_int_g) & 7)]][var_byte_arr_d[var_int_h * 2] + var_byte_arr_b[var_short_arr_a[1] + ((var_byte_b + var_int_g) & 7)]]
						if by < -var_int_a and by >= -10:
							var_byte_arr_e[var_int_h] = JNum.to_byte(-(by + 1))
							var_boolean_arr_a[var_int_e - 1] = true
							var_int_b = 130
							break
						if var_byte_arr_d[var_int_h * 2] + var_byte_arr_b[var_short_arr_a[1] + ((var_byte_b + var_int_g) & 7)] == var_byte_arr_arr_arr_e[0][0][var_int_a] and var_byte_arr_d[var_int_h * 2 + 1] + var_byte_arr_b[var_short_arr_a[1] + 8 + ((var_byte_b + var_int_g) & 7)] == var_byte_arr_arr_arr_e[0][1][var_int_a]:
							var_int_b = 130
							break
					var n2: int = var_int_h * 2
					var_byte_arr_d[n2] = JNum.to_byte(var_byte_arr_d[n2] + var_byte_arr_b[var_short_arr_a[1] + var_byte_b])
					var n3: int = var_int_h * 2 + 1
					var_byte_arr_d[n3] = JNum.to_byte(var_byte_arr_d[n3] + var_byte_arr_b[var_short_arr_a[1] + 8 + var_byte_b])
					break
				var_byte_b = JNum.to_byte((var_byte_b + var_int_g) & 7)
				var_int_f += 1
			if var_int_f >= 8 or (var_byte_arr_d[var_int_h * 2] == var_byte_arr_arr_arr_e[0][0][var_int_a] and var_byte_arr_d[var_int_h * 2 + 1] == var_byte_arr_arr_arr_e[0][1][var_int_a]):
				if var_int_f < 8:
					break
				var_boolean_arr_a[2] = false
				break
			if var_int_b > 127:
				break
			by = var_f_a.var_byte_arr_arr_b[var_byte_arr_d[var_int_h * 2 + 1]][var_byte_arr_d[var_int_h * 2]]
			if by < -var_int_a and by >= -10:
				var_byte_arr_e[var_int_h] = JNum.to_byte(-(by + 1))
				var_boolean_arr_a[var_int_e - 1] = true
				break
			var_byte_arr_arr_arr_d[var_int_h][0][var_int_b] = var_byte_arr_d[var_int_h * 2]
			var_byte_arr_arr_arr_d[var_int_h][1][var_int_b] = var_byte_arr_d[var_int_h * 2 + 1]
			var n4: int = var_int_h
			var_byte_arr_f[n4] = JNum.to_byte(var_byte_arr_f[n4] + 1)
			var_byte_b = JNum.to_byte((var_byte_b - var_int_g * 2) & 7)
			var_int_b += 1
		var_int_g *= -1
		var_int_e += 1

## original: private void void_a(boolean bl)  (b.java:669)
func void_a_z(bl: bool) -> void:
	if not var_boolean_arr_a[0] or (var_byte_arr_f[var_byte_arr_g[1]] > var_byte_arr_f[var_byte_arr_g[2]] and var_boolean_arr_a[1]):
		var_int_e = var_byte_arr_g[1]
		var_byte_arr_g[1] = var_byte_arr_g[2]
		var_byte_arr_g[2] = JNum.to_byte(var_int_e)
	var_int_e = 0
	while var_int_e <= var_byte_arr_arr_arr_e[0][2][var_int_a]:
		var_byte_arr_arr_arr_d[var_byte_arr_g[2]][0][var_int_e] = var_byte_arr_arr_arr_d[var_byte_arr_g[0]][0][var_int_e]
		var_byte_arr_arr_arr_d[var_byte_arr_g[2]][1][var_int_e] = var_byte_arr_arr_arr_d[var_byte_arr_g[0]][1][var_int_e]
		var_int_e += 1
	var_byte_arr_f[var_byte_arr_g[2]] = JNum.to_byte(var_byte_arr_arr_arr_e[0][2][var_int_a] + 1)
	var_int_e = 0
	while var_int_e <= var_byte_arr_f[var_byte_arr_g[1]] and var_int_e + var_byte_arr_f[var_byte_arr_g[2]] < var_int_i:
		var_byte_arr_arr_arr_d[var_byte_arr_g[2]][0][var_int_e + var_byte_arr_f[var_byte_arr_g[2]]] = var_byte_arr_arr_arr_d[var_byte_arr_g[1]][0][var_int_e]
		var_byte_arr_arr_arr_d[var_byte_arr_g[2]][1][var_int_e + var_byte_arr_f[var_byte_arr_g[2]]] = var_byte_arr_arr_arr_d[var_byte_arr_g[1]][1][var_int_e]
		var_int_e += 1
	var_byte_arr_f[var_byte_arr_g[2]] = JNum.to_byte(clamp(var_byte_arr_f[var_byte_arr_g[2]] + var_byte_arr_f[var_byte_arr_g[1]], 0, var_int_i))
	var_int_e = var_byte_arr_g[0]
	var_byte_arr_g[0] = var_byte_arr_g[2]
	var_byte_arr_g[2] = JNum.to_byte(var_int_e)
	if not bl or var_byte_arr_f[var_byte_arr_g[0]] >= var_int_i:
		return
	var_int_g = var_byte_arr_arr_arr_e[1][2][var_byte_arr_e[var_byte_arr_g[1]]]
	var_int_h = var_byte_arr_f[var_byte_arr_g[1]] - var_int_g + var_byte_arr_arr_arr_e[0][2][var_int_a] + 1
	var_int_e = 0
	while var_int_e <= var_byte_arr_f[var_byte_arr_g[2]] - var_int_g and var_int_e + var_byte_arr_f[var_byte_arr_g[0]] < var_int_i:
		var_byte_arr_arr_arr_d[var_byte_arr_g[0]][0][var_int_e + var_byte_arr_f[var_byte_arr_g[0]]] = var_byte_arr_arr_arr_d[var_byte_arr_g[2]][0][var_int_e + var_int_g]
		var_byte_arr_arr_arr_d[var_byte_arr_g[0]][1][var_int_e + var_byte_arr_f[var_byte_arr_g[0]]] = var_byte_arr_arr_arr_d[var_byte_arr_g[2]][1][var_int_e + var_int_g]
		var_int_e += 1
	var_byte_arr_f[var_byte_arr_g[0]] = JNum.to_byte(clamp(var_byte_arr_f[var_byte_arr_g[0]] + var_byte_arr_f[var_byte_arr_g[2]] - var_int_g, 0, var_int_i))
	var_int_a = var_byte_arr_e[var_byte_arr_g[1]]
	var_int_e = var_int_a + 1
	while var_int_e < var_byte_c:
		var_byte_arr_arr_arr_e[0][2][var_int_e] = JNum.to_byte(var_byte_arr_arr_arr_e[0][2][var_int_e] + var_int_h)
		var_byte_arr_arr_arr_e[1][2][var_int_e] = JNum.to_byte(var_byte_arr_arr_arr_e[1][2][var_int_e] + var_int_h)
		var_int_e += 1

## original: private void P()  (b.java:3545)
func P() -> void:
	push_warning("TribesWorld.P() not ported yet (original: private void P(), b.java:3545)")

## original: private int int_a(int n, int n2, int n3)  (b.java:980)
func int_a_iii(n: int, n2: int, n3: int) -> int:
	# Port of b.java:980 — int_a(int,int,int)
	# try{...}catch(Exception){} — same pattern as before
	if n < 0 or n2 < 0 or n >= var_f_a.var_short_c or n2 >= var_f_a.var_short_d:
		return 0
	var_int_k = var_byte_arr_b[var_short_arr_a[39] + var_byte_arr_arr_b[n2][n]]
	if var_int_k == 0 or var_int_k == 1:
		return 0
	if n3 == 1:
		return 1
	var_int_k = var_short_arr_a[39 + var_byte_arr_arr_b[n2][n]]
	var_int_l = var_int_arr_a[var_byte_arr_a[4747 + var_int_v] - 1] & var_byte_arr_b[var_int_k]
	if var_int_l == 0:
		return 0
	var_int_m = 0
	var_int_n = 0
	var_int_o = var_f_a.var_short_c - 1
	var_int_p = var_f_a.var_short_d - 1
	if n3 == 0:
		var_int_m = -3
		var_int_n = -3
		var_int_o += 3
		var_int_p += 3
	elif n3 == 2:
		var_int_m = -6
		var_int_n = -6
		var_int_o += 6
		var_int_p += 6
	var_int_q = 0
	var_int_r = var_int_m
	while var_int_r <= var_int_p:
		var_int_s = var_int_m
		while var_int_s <= var_int_o:
			if var_byte_arr_arr_b[n2 + var_int_r][n + var_int_s] > 0:
				var_int_q += 1
			var_int_s += 1
		var_int_r += 1
	if var_int_q == 0:
		return 0
	var_int_q = 0
	var_int_r = var_int_m
	while var_int_r <= var_int_p:
		var_int_s = var_int_m
		while var_int_s <= var_int_o:
			if var_byte_arr_arr_b[n2 + var_int_r][n + var_int_s] > 0 and (var_byte_arr_b[var_short_arr_a[39] + var_byte_arr_arr_b[n2 + var_int_r][n + var_int_s]] & var_int_l) != 0:
				var_int_q += 1
			var_int_s += 1
		var_int_r += 1
	if var_int_q == 0:
		return 0
	return 1

## original: private void g(int n)  (b.java:743)
func g_i(n: int) -> void:
	# try{...}catch(Exception){} — same note as before
	if var_byte_arr_a[6161 + var_int_v] > 1:
		var_byte_arr_a[6161 + var_int_v] = JNum.to_byte(1 if var_byte_arr_a[6161 + var_int_v] == 2 else 0)
		if var_byte_I == 1 or var_byte_I == 2 or (var_f_a.var_byte_q == 2 and var_int_u == 1 and var_byte_f == 1):
			var_byte_arr_a[7777 + var_int_v] = JNum.to_byte(3)
	if n < 3:
		d_ii(var_int_v, n)
	if var_byte_arr_arr_b[var_byte_arr_a[101 + var_int_v]][var_byte_arr_a[0 + var_int_v]] != var_int_v:
		U()
		return
	a_iii(var_byte_arr_a[3131 + var_int_v], var_byte_arr_a[3232 + var_int_v], n > 0)
	if var_byte_l >= 0 and (var_byte_l != 10 or n < 2):
		var_byte_arr_a[3131 + var_int_v] = var_byte_arr_a[0 + var_int_v]
		var_byte_arr_a[3232 + var_int_v] = var_byte_arr_a[101 + var_int_v]
		Q()
		if var_byte_arr_a[6161 + var_int_v] == 1:
			a_iii(var_byte_l, var_int_v, var_int_v)
		return
	h_i(n)

## original: private void h(int n)  (b.java:776)
func h_i(n: int) -> void:
	var_byte_arr_a[4444 + var_int_v] = var_byte_arr_k[2]
	if var_byte_m == 2 or var_byte_m == 7:
		var_byte_arr_a[7979 + var_int_v] = JNum.to_byte(var_byte_arr_a[2828 + var_int_v] == 60 or n == 0 or ((var_byte_arr_a[2828 + var_int_v] == 2 or var_byte_arr_a[2828 + var_int_v] == 7) and (var_byte_arr_a[7979 + var_int_v] & 0x80) == 0) \
			and var_byte_arr_a[7979 + var_int_v] & 0x7F or var_byte_arr_a[7979 + var_int_v] | 0x80)
	if not (n != 0 and (var_f_a.var_boolean_N or (var_byte_m != 12 and var_byte_m != 16 or (var_byte_arr_b[var_short_arr_a[41] + var_byte_arr_a[6464 + var_int_v]] != 3 and var_byte_arr_b[var_short_arr_a[41] + var_byte_arr_a[6464 + var_int_v]] != 7))) \
		and ((var_f_a.var_boolean_N or var_byte_K < 50) and var_byte_arr_b[var_short_arr_a[41] + var_byte_m] != 0)):
		if var_byte_arr_arr_b[var_byte_arr_a[101 + var_int_v]][var_byte_arr_a[0 + var_int_v]] == var_int_v and \
			(var_byte_arr_b[var_short_arr_a[39] + var_byte_m] != 1 or var_byte_arr_a[8810 + var_byte_arr_k[2]] != var_int_v and var_byte_arr_b[var_short_arr_a[41] + var_byte_m] != 0):
			var_f_a.void_c(var_int_v)
		if var_byte_arr_b[var_short_arr_a[39] + var_byte_m] != 1:
			var_byte_arr_a[6464 + var_int_v] = JNum.to_byte(69 if n == 0 and var_byte_m >= 19 and var_byte_m <= 26 else var_byte_arr_b[var_short_arr_a[29] + var_byte_m])
			var_byte_arr_a[6262 + var_int_v] = var_byte_arr_a[3131 + var_int_v]
			var_byte_arr_a[6363 + var_int_v] = var_byte_arr_a[3232 + var_int_v]
	if not (var_byte_arr_a[1414 + var_int_v] < 12 or n >= 2 and (var_f_a.var_boolean_N or var_byte_m != 12 and var_byte_m != 16 or (var_byte_arr_b[var_short_arr_a[41] + var_byte_arr_a[6464 + var_int_v]] != 3 and var_byte_arr_b[var_short_arr_a[41] + var_byte_arr_a[6464 + var_int_v]] != 7))):
		void_a_ib(var_int_v, var_byte_m)
	if var_byte_arr_a[2828 + var_int_v] == 13:
		if var_byte_arr_a[3131 + var_int_v] > 0 and (var_byte_arr_arr_b[var_byte_arr_a[3232 + var_int_v]][var_byte_arr_a[3131 + var_int_v] - 1] == -127 or var_byte_arr_arr_b[var_byte_arr_a[3232 + var_int_v]][var_byte_arr_a[3131 + var_int_v] - 1] == var_int_v):
			var_n2: int = 3131 + var_int_v
			var_byte_arr_a[var_n2] = JNum.to_byte(var_byte_arr_a[var_n2] - 1)
		if var_byte_arr_a[3131 + var_int_v] < var_f_a.var_short_c - 1 and (var_byte_arr_arr_b[var_byte_arr_a[3232 + var_int_v]][var_byte_arr_a[3131 + var_int_v] + 1] == -127 or var_byte_arr_arr_b[var_byte_arr_a[3232 + var_int_v]][var_byte_arr_a[3131 + var_int_v] + 1] == var_int_v):
			var_n3: int = 3131 + var_int_v
			var_byte_arr_a[var_n3] = JNum.to_byte(var_byte_arr_a[var_n3] + 1)
	if var_byte_arr_b[var_short_arr_a[39] + var_byte_arr_a[2828 + var_int_v]] == 1:
		void_b_ii(var_byte_arr_k[1], var_byte_arr_k[2])

## original: private void a(int n, int n2, boolean bl)  (b.java:809)
func a_iii(n: int, n2: int, bl: bool) -> void:
	if bl:
		var_byte_arr_a[4747 + var_int_v] = var_byte_arr_arr_b[n2][n]
	c_iiii(n, n2, var_int_u, 0)
	var_byte_k = var_byte_arr_k[0]
	var_byte_l = byte_a()
	if var_byte_arr_k[3] == 0:
		var_byte_m = var_byte_arr_b[var_short_arr_a[16] + var_byte_arr_b[var_short_arr_a[17] + var_byte_k] + var_byte_arr_k[1 if var_byte_k != 4 else 2]]
		if var_byte_k == 2:
			if var_byte_arr_k[1] == 6 and var_byte_arr_a[3636 + var_int_v] > 0 and var_byte_arr_a[3535 + var_int_v] <= 13 and not bl:
				var_byte_m = var_byte_arr_b[var_short_arr_a[121] + var_byte_arr_a[3535 + var_int_v]]
			if var_byte_arr_k[1] >= 12 and var_byte_arr_a[8505 + var_byte_arr_k[2]] >= var_byte_arr_b[var_short_arr_a[138] + 182 + var_byte_arr_a[9237 + var_byte_arr_k[2]]]:
				var_byte_m = JNum.to_byte(69)
	else:
		var_byte_m = JNum.to_byte(var_byte_arr_b[var_short_arr_a[19] + var_byte_k - 1] + (JNum.to_byte(1) if bl else 0) if var_byte_arr_a[1414 + var_byte_arr_k[2]] >= 12 or var_byte_arr_k[0] == 2 else 107)
	if var_byte_m <= 9:
		var_byte_m = JNum.to_byte(var_byte_m + var_byte_arr_b[var_short_arr_a[18] + var_byte_arr_a[6565 + var_int_v]])
	if var_f_a.var_byte_q == 3 and var_byte_arr_b[var_short_arr_a[41] + var_byte_m] != 0:
		var_byte_m = JNum.to_byte(69)

## original: private void void_a(int n, byte by)  (b.java:837)
func void_a_ib(n: int, by: int) -> void:
	if var_byte_arr_a[2828 + n] != by:
		var_byte_arr_a[404 + n] = 0
		var_byte_arr_a[2828 + n] = JNum.to_byte(by)
		var_n2: int = 1111 + n
		var_byte_arr_a[var_n2] = JNum.to_byte(var_byte_arr_a[var_n2] & 0xF)
		var_int_B = var_byte_arr_b[var_short_arr_a[38] + by]
		if var_int_B < 0:
			var_int_B = var_byte_arr_a[var_short_arr_b[-var_int_B] + n]
		if by < 83 or by > 85:
			C()


# ---------------------------------------------------------------------------
# Stubs for methods referenced above but not yet reached in the sequential
# source pass. Each will be replaced with a real port when we get to its
# location in b.java. Calling one of these before then will loudly warn
# instead of silently doing nothing, so testing surfaces gaps immediately.
# ---------------------------------------------------------------------------

## original: private void d(int n, int n2)  (b.java:?? — called from g_i)
func d_ii(_n: int, _n2: int) -> void:
	push_warning("TribesWorld.d_ii() not ported yet")

## original: private void U()  (b.java:?? — called from g_i)
func U() -> void:
	push_warning("TribesWorld.U() not ported yet")

## original: private void Q()  (b.java:?? — called from g_i)
func Q() -> void:
	push_warning("TribesWorld.Q() not ported yet")

## original: private void c(int, int, int, int)  (b.java:?? — called from a_iii)
func c_iiii(_n: int, _n2: int, _n3: int, _n4: int) -> void:
	push_warning("TribesWorld.c_iiii() not ported yet")

## original: private byte byte_a()  (b.java:?? — called from a_iii)
func byte_a() -> int:
	push_warning("TribesWorld.byte_a() not ported yet")
	return 0

## original: private void C()  (b.java:?? — called from void_a_ib)
func C() -> void:
	push_warning("TribesWorld.C() not ported yet")

## original: private void void_b(int, int)  (b.java:?? — called from h_i)
func void_b_ii(_n: int, _n2: int) -> void:
	push_warning("TribesWorld.void_b_ii() not ported yet")
