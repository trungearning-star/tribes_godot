# Tình trạng port sang Godot

Nguồn gốc: MIDlet J2ME "Bo Lac Thoi Tien Su" (THQ/BiNPDA), decompile bằng CFR,
7 class: `tribes, d, a, c, e, b, f`. Bản Java gốc (đã decompile) được giữ lại
trong `docs/original_source/` để đối chiếu khi port tiếp phần còn lại.

## Đã port xong (chạy được, có thể mở project.godot để test)

| Class gốc | File Godot | Ghi chú |
|---|---|---|
| `tribes.java` (75 dòng) | `scripts/Main.gd` + `scenes/Main.tscn` | Boot sequence, timing splash giữ nguyên (1s/2s/2s) |
| `d.java` (50 dòng) | `scripts/Splash.gd` + `scenes/Splash.tscn` | Màn hình loading l0/l1/l2, căn giữa như bản gốc |
| `a.java` (116 dòng) | `scripts/AudioPlayer.gd` | Wrapper nhạc nền, map state MIDP Player -> AudioStreamPlayer |
| `c.java` (487 dòng) | `scripts/DialogText.gd` | Hệ thống text: queue, word-wrap, outline draw. Port khá sát 1:1 vì class này không bị obfuscate nặng bằng offset số ma thuật |
| `e.java` (275 dòng) | *(không port trực tiếp)* | Đây là bộ giải mã byte thô của `pi0/pi8/pi9/pd0/a/sa/ma` lúc chưa tách file. Vì bạn đã tách sẵn thành PNG/ogg/wav riêng lẻ nên logic này không cần nữa — chỉ cần ghi chú lại mapping (xem bên dưới) |

## Chưa port — đây là phần lớn và khó nhất

| Class gốc | Số dòng | Vai trò |
|---|---|---|
| `f.java` | 6630 dòng | Canvas chính, game loop (`Runnable`), input, render, gọi vào `b` và `c` |
| `b.java` | 5813 dòng | Logic thế giới/bộ lạc (world/tribe simulation) |

Hai class này **không dùng field có tên rõ nghĩa** — dữ liệu được đóng gói thủ công
vào các mảng byte/short phẳng, truy cập qua phép cộng offset số (ví dụ
`this.var_byte_arr_e[4545 + this.var_byte_arr_g[0]]`). Đây là kiểu tối ưu bộ nhớ
thường thấy trên MIDP-1.0 (heap cực nhỏ), không phải style code thường.

Hệ quả: việc port **không thể** làm kiểu "hiểu ý nghĩa rồi viết lại code sạch" —
phải dịch **cơ học, giữ nguyên y hệt** toàn bộ phép toán offset, cấu trúc mảng,
thứ tự vòng lặp, kiểu số (`byte` tràn dấu qua `(byte)`, `short`...). Làm sai một
offset là sai logic game. Vì khối lượng ~12.400 dòng kiểu này, việc port sẽ được
làm dần theo từng nhóm method trong các lượt tiếp theo, không thể xong trong một
lần.

### Kế hoạch tiếp theo (đề xuất)
1. Port khung `f.gd` (extends Node2D): các field, `paint()` -> `_draw()`,
   `void_a()`/`void_b()` (start/stop), vòng lặp `run()` -> `_process()`.
2. Port input (`keyPressed` tương ứng) — vì mục tiêu cuối là cảm ứng, sẽ thêm
   một lớp map "vùng chạm -> keycode ảo" để tái dùng logic gốc mà không cần sửa,
   rồi sau này mới thay dần bằng UI cảm ứng thật.
3. Port `b.gd` (thế giới) theo từng cụm method mà `f.gd` gọi tới, để luôn có thể
   test được ngay sau mỗi cụm thay vì port xong 5800 dòng mới test.
4. Đối chiếu ngược với bản .jar gốc chạy trên giả lập J2ME (nếu bạn có) để so
   sánh hành vi từng màn hình.

## Checklist chi tiết `b.java` -> `TribesWorld.gd` (5813 dòng gốc)

Port theo đúng thứ tự dòng trong file gốc để dễ đối chiếu. Cập nhật bảng này
mỗi lượt.

| Dòng gốc | Method gốc | Tên trong Godot | Trạng thái |
|---|---|---|---|
| 5-192 | (field declarations) | (var declarations) | ✅ Xong |
| 193-221 | `public b()` | `_init()` | ✅ Xong |
| 222-232 | `final void a(f f2)` | `bind_engine()` | ✅ Xong — có 1 vấn đề kiến trúc chưa giải quyết (xem "Vấn đề đang mở" bên dưới) |
| 233-282 | `final void void_a()` | `reset_state()` | ✅ Xong (gọi `_void_j()` là stub) |
| 283-330 | `private byte a(int,int,int,int,int,int)` | `a_iiiiii()` | ✅ Xong |
| 337-380 | `private byte byte_a(int,int,int,int)` | `byte_a_iiii()` | ✅ Xong |
| 381-403 | `private void void_d(int)` | `void_d_i()` | ✅ Xong |
| 404-418 | `private byte byte_b(int,int,int,int)` | `byte_b_iiii()` | ✅ Xong |
| 419-4989 | ~170 method còn lại | — | ⬜ Chưa làm |
| 4990-... | `final void void_j()` | `_void_j()` | ⬜ Chưa làm (đang là stub) |

**Progress chi tiết trong lượt này** (sau dòng 418, cập nhật đến dòng 1070+):

| Dòng gốc | Method gốc | Tên trong Godot | Trạng thái |
|---|---|---|---|
| 466-518 | `private void a(int,int,int,int,int)` | `a_iiiii()` | ✅ Xong |
| 520-540 | `private void void_a(int,int)` | `void_a_ii()` | ✅ Xong |
| 542-593 | `private void e(int)` | `e_i()` | ✅ Xong |
| 595-667 | `private void f(int)` | `f_i()` | ✅ Xong |
| 669-714 | `private void void_a(boolean)` | `void_a_z()` | ✅ Xong |
| 743-774 | `private void g(int)` | `g_i()` | ✅ Xong |
| 776-807 | `private void h(int)` | `h_i()` | ✅ Xong |
| 809-835 | `private void a(int,int,boolean)` | `a_iii()` | ✅ Xong |
| 837-850 | `private void void_a(int,byte)` | `void_a_ib()` | ✅ Xong |
| 980 | `private int int_a(int,int,int)` | `int_a_iii()` | ✅ Xong |
| 854-873 | `private void void_b(int,int)` | `void_b_ii()` | ✅ Xong |
| 875-920 | `private void void_q()` | `void_q()` | ✅ Xong |
| 922-958 | `private void void_r()` | `void_r()` | ✅ Xong |
| 960-978 | `private void void_b(boolean)` | `void_b_z()` | ✅ Xong |
| 1008-1016 | `private static int int_b(int,int,int)` | `int_b_iii()` | ✅ Xong |
| 1018-1026 | `final void void_b()` | `void_b()` | ✅ Xong |
| 1028-1037 | `final void void_c()` | `void_c()` | ✅ Xong |
| 1039-1070 | `final void void_d()` | `void_d()` | ✅ Xong |
| 1072-... | `final void void_e()` | `void_e()` | 🔄 Đang làm (phần đầu đã port, còn tiếp tục) |

**Stub mới thêm** (các method được gọi từ code đã port nhưng chưa tới lượt port thật):
`d_ii`, `U`, `Q`, `c_iiii`, `byte_a()`, `C`, `void_p`, `ap`, `void_s`, `aq`, `int_a_i` — tất cả đều in `push_warning` khi gọi.

**Stub đang chờ port thật** (gọi vào sẽ in cảnh báo `push_warning`, không phải bug —
là điểm đánh dấu "chưa tới lượt"): `P` (dòng 3545), `_void_j` (dòng 4990), `d_ii`, `U`, `Q`,
`c_iiii`, `byte_a()`, `C`, `void_p`, `ap`, `void_s`, `aq`, `int_a_i`.

## Checklist `f.java` -> chưa bắt đầu (6630 dòng gốc)

Chưa port dòng nào. Sẽ bắt đầu sau khi `b.java` xong, hoặc xen kẽ nếu bạn muốn.

## Vấn đề đang mở (chưa tự ý quyết, cần xác nhận khi gặp usage thật)

1. **Alias mảng giữa `b` và `f`**: xem comment trong `bind_engine()` — Java cho 2
   object cùng trỏ 1 mảng, GDScript Packed*Array copy khi gán. Chưa sửa vì chưa
   thấy chỗ nào thực sự cần tính "sửa qua bên này thấy bên kia" — sẽ sửa đúng lúc
   gặp.

## Quy ước quan trọng đã rút ra trong lúc port (đọc trước khi port tiếp)

1. **`byte[]` Java = có dấu (-128..127)**, KHÔNG dùng `PackedByteArray` của Godot
   (chỉ chứa 0..255, không dấu) — đã sửa toàn bộ field liên quan sang
   `PackedInt32Array` + luôn ghi qua `JNum.to_byte()`.
2. **Method trùng tên (Java overload)** không tồn tại trong GDScript — quy ước
   đặt tên: `<tên gốc>_<mã kiểu tham số>` (i=int, b=byte, z=boolean, s=short).
   Mỗi hàm port đều có comment ghi lại chữ ký gốc + số dòng để tra ngược.
3. **`try{...}catch(Exception){}` nuốt lỗi** xuất hiện liên tục trong code gốc.
   GDScript không có try/catch tổng quát — tạm thời port phần thân try như bình
   thường (không bọc gì), chấp nhận rủi ro crash thay vì nuốt lỗi âm thầm, vì mục
   tiêu là chạy đúng logic chứ không phải giả lập hành vi "im lặng khi lỗi". Nếu
   sau này thấy cần, sẽ bọc bằng cách kiểm tra bounds thủ công ở những chỗ cụ thể.

## Mapping resource (đã làm ở bước trước, ghi lại để tham chiếu)

- `pi0`, `pi8`, `pi9`: chuỗi ảnh PNG nối nhau, mỗi frame có 2 byte độ dài đứng
  trước (đọc trong `e.d()`). Đã tách thành `sprites/pi0/pi0_NNN.png` v.v.
  Số frame thực tế của `pi0`=27 (giới hạn khai báo là 31, dừng sớm khi gặp byte
  0xFF) và `pi9`=6 — khớp đúng số file bạn đã tách. `pi8` không được nạp trong
  `e`'s constructor (chỉ gọi cho index 0 và 1) — logic nạp `pi8` chắc chắn nằm
  trong `f.java`/`b.java`, sẽ xác nhận lại khi port tới đó.
- `pd0`: bảng offset nhị phân dùng để nạp `var_short_arr_arr_b`/`var_byte_arr_arr_j`
  trong `f` (qua `e.b()`) — **không phải ảnh/audio**, đúng như đã giữ nguyên
  không convert. Đã copy vào `assets/raw/pd0.txt` (giữ nguyên bytes, chỉ đổi tên
  để tham chiếu — chưa parse).
- `a` (không đuôi): bảng dữ liệu bản đồ/tile, đọc trong `e.f()` thành
  `var_short_arr_a`/`var_short_arr_b`. Giữ nguyên trong `assets/raw/a.txt`.
- `sa` -> 5 file `audio/bgm/bgm_0..4`: khớp đúng 5 offset trong
  `f.var_short_arr_f`/`var_short_arr_e` mà `e.g()` khai báo — việc tách của bạn
  là đúng.
- `ma` -> 10 file `audio/sfx/sfx_0..9`: khớp đúng 10 offset trong
  `f.var_int_arr_h` mà `e.h()` khai báo. **Lưu ý**: `ma` gốc được code đọc như
  **dữ liệu thô** (`var_byte_arr_v`), không có tiêu đề định dạng chuẩn nào ở
  offset 0x2a2e... nên nên nghe thử từng file `sfx_N.wav` để chắc chắn công cụ
  bạn dùng đã giải mã đúng, chứ không phải chỉ đổi tên byte thô thành `.wav`
  (nếu vậy file sẽ chỉ toàn nhiễu).
