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
func a_iiiii(_n: int, _n2: int, _n3: int, _n4: int, _n5: int) -> void:
	push_warning("TribesWorld.a_iiiii() not ported yet (original: private void a(int,int,int,int,int), b.java:466)")

## original: private void f(int n)  (b.java:595)
func f_i(_n: int) -> void:
	push_warning("TribesWorld.f_i() not ported yet (original: private void f(int), b.java:595)")

## original: private void void_a(boolean bl)  (b.java:669)
func void_a_z(_bl: bool) -> void:
	push_warning("TribesWorld.void_a_z() not ported yet (original: private void void_a(boolean), b.java:669)")

## original: private void P()  (b.java:3545)
func P() -> void:
	push_warning("TribesWorld.P() not ported yet (original: private void P(), b.java:3545)")

## original: private int int_a(int n, int n2, int n3)  (b.java:980)
func int_a_iii(_n: int, _n2: int, _n3: int) -> int:
	push_warning("TribesWorld.int_a_iii() not ported yet (original: private int int_a(int,int,int), b.java:980)")
	return 0
