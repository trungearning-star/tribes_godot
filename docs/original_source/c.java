/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  javax.microedition.lcdui.Font
 *  javax.microedition.lcdui.Graphics
 */
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import javax.microedition.lcdui.Font;
import javax.microedition.lcdui.Graphics;

public final class c {
    private f owner;
    private String[] shortText;
    private String[] helpText;
    private String[] sceneText;
    private String[] qText;
    private int[] qX;
    private int[] qY;
    private int[] qAlign;
    private int[] qStyle;
    private int qCount;
    private int sceneBase;
    private String[] lines;
    private int wx;
    private int wy;
    private int ww;
    private int wh;
    private int wstyle;
    private static final int MAX_Q = 96;
    private static final int MAX_LINES = 160;
    f var_f_a;
    byte[] var_byte_arr_a;
    short[] var_short_arr_a;
    byte[] var_byte_arr_b;
    short[] var_short_arr_b;
    byte[] var_byte_arr_c;
    short[] var_short_arr_c;
    byte[][] var_byte_arr_arr_a;
    short[][] var_short_arr_arr_a;
    String[] var_java_lang_String_arr_a;
    byte[][] var_byte_arr_arr_b;
    byte[][] var_byte_arr_arr_c;
    byte[] var_byte_arr_d;
    short[] var_short_arr_d;
    short[] var_short_arr_e;
    short[] var_short_arr_f;
    byte[] var_byte_arr_e;
    byte var_byte_a;
    byte var_byte_b;
    byte var_byte_c;
    byte[] var_byte_arr_f;
    int var_int_a;
    InputStream var_java_io_InputStream_a;
    int var_int_b;
    int var_int_c;
    int var_int_d;
    int var_int_e;
    int var_int_f;
    int var_int_g;
    int var_int_h;
    byte var_byte_d;
    int i;
    int j;
    int k;
    int l;
    int m;
    int n;
    int o;
    int p;
    int q;
    short[] var_short_arr_g;
    short[] var_short_arr_h;
    int r;
    int s;
    int t;
    int u;
    int v;
    int w;
    int x;
    int y;
    int z;
    int A;

    public c(f f2) {
        this.owner = f2;
        this.qText = new String[96];
        this.qX = new int[96];
        this.qY = new int[96];
        this.qAlign = new int[96];
        this.qStyle = new int[96];
        this.shortText = this.loadParts("/0/s");
        this.helpText = this.loadParts("/0/t");
        this.sceneText = this.loadParts("/0/d0");
        this.lines = new String[0];
        this.qCount = 0;
        this.sceneBase = 0;
    }

    final void a() {
        this.qCount = 0;
    }

    final void a(int n) {
        this.sceneBase = c.sceneBaseFor(n);
        if (this.sceneText == null || this.sceneText.length == 0) {
            this.sceneText = this.loadParts("/0/d0");
        }
    }

    final void b(int n) {
        if (n == 0) {
            this.shortText = this.loadParts("/0/s");
        } else if (n == 1) {
            this.helpText = this.loadParts("/0/t");
        } else if (n == 2) {
            this.sceneText = this.loadParts("/0/d0");
            this.sceneBase = 0;
        }
    }

    final void a(int n, int n2, int n3, String string, int n4) {
        this.enqueue(n, n2, n3, string, n4);
    }

    final void a(int n, int n2, int n3, int n4, int n5) {
        this.enqueue(n, n2, n3, this.lookupShort(n4), n5);
    }

    final void a(int n, int n2, int n3, int n4, int n5, int n6, int n7) {
        String string;
        int n8 = n;
        if (n4 >= 0) {
            string = this.lookupShort(n4);
            this.enqueue(n8, n2, 0, string, n7);
            n8 += this.textWidth(string) + 2;
        }
        if (n5 >= 0) {
            string = this.lookupShort(n5);
            this.enqueue(n8, n2, 0, string, n7);
            n8 += this.textWidth(string) + 2;
        }
        if (n6 >= 0) {
            string = this.lookupShort(n6);
            this.enqueue(n8, n2, 0, string, n7);
        }
    }

    final void a(Graphics graphics) {
        this.prepareFont(graphics);
        for (int i = 0; i < this.qCount; ++i) {
            this.drawOutlined(graphics, this.qText[i], this.qX[i], this.qY[i], this.qAlign[i], this.qStyle[i]);
        }
        this.qCount = 0;
    }

    final void b() {
    }

    final void a(int n, int n2, int n3) {
    }

    final void b(int n, int n2, int n3, int n4, int n5, int n6, int n7) {
        this.wx = n;
        this.wy = n2;
        this.ww = n3;
        this.wh = n4;
        this.wstyle = n7;
        String string = this.lookupLong(n5);
        this.lines = this.wrapText(string, n3 <= 0 ? 300 : n3);
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.
     */
    final void a(Graphics graphics, int n) {
        int n2;
        this.prepareFont(graphics);
        Font font = graphics.getFont();
        int n3 = font.getHeight();
        int n4 = n3 + 1;
        int n5 = 1;
        int n6 = 1;
        int n7 = this.wh > n5 + n6 ? this.wh - n5 - n6 : this.wh;
        int n8 = n2 = this.wh <= 0 ? this.lines.length : n7 / n4;
        if (n2 < 1) {
            n2 = 1;
        }
        int n9 = graphics.getClipX();
        int n10 = graphics.getClipY();
        int n11 = graphics.getClipWidth();
        int n12 = graphics.getClipHeight();
        try {
            if (this.ww > 0 && this.wh > 0) {
                graphics.setClip(this.wx, this.wy, this.ww, this.wh);
            }
            int n13 = this.wy + n5;
            for (int i = n; i < this.lines.length && i < n + n2; ++i) {
                this.drawOutlined(graphics, this.lines[i], this.wx, n13, 0, this.wstyle);
                n13 += n4;
            }
        }
        finally {
            graphics.setClip(n9, n10, n11, n12);
        }
    }

    private void enqueue(int n, int n2, int n3, String string, int n4) {
        if (string == null) {
            string = "";
        }
        string = this.cleanInline(string);
        if (this.qCount >= 96) {
            return;
        }
        this.qText[this.qCount] = string;
        this.qX[this.qCount] = n;
        this.qY[this.qCount] = n2;
        this.qAlign[this.qCount] = n3;
        this.qStyle[this.qCount] = n4;
        ++this.qCount;
    }

    private String lookupShort(int n) {
        if (n >= 0 && n < this.shortText.length) {
            return this.shortText[n];
        }
        if (n >= 0 && n < this.helpText.length) {
            return this.helpText[n];
        }
        return "";
    }

    private String lookupLong(int n) {
        int n2;
        if (n >= 71 && (n2 = n - 71 + this.sceneBase) >= 0 && this.sceneText != null && n2 < this.sceneText.length) {
            return this.sceneText[n2];
        }
        if (n >= 0 && n < this.helpText.length) {
            return this.helpText[n];
        }
        if (n >= 0 && this.sceneText != null && n < this.sceneText.length) {
            return this.sceneText[n];
        }
        return "";
    }

    private static int sceneBaseFor(int n) {
        int[] nArray = new int[]{0, 3, 15, 18, 20, 22, 24, 26, 28, 29, 30, 31, 33, 34, 35, 36, 44, 45, 46, 57, 58, 59, 62, 64, 65, 67, 68, 70, 72, 77, 81, 84, 85, 86, 97, 102, 108, 109, 111, 116, 117, 119, 123, 128, 137, 143, 145, 148, 149, 165, 167, 181, 184, 190, 197, 203, 204, 207, 208, 211, 212, 216, 219, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234};
        if (n < 0) {
            return 0;
        }
        if (n >= nArray.length) {
            return nArray[nArray.length - 1];
        }
        return nArray[n];
    }

    private String[] loadParts(String string) {
        try {
            int n;
            InputStream inputStream = this.getClass().getResourceAsStream(string);
            if (inputStream == null) {
                return new String[0];
            }
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            byte[] byArray = new byte[512];
            while ((n = inputStream.read(byArray)) > 0) {
                byteArrayOutputStream.write(byArray, 0, n);
            }
            inputStream.close();
            return c.split(c.decodeUtf8(byteArrayOutputStream.toByteArray()), '|');
        }
        catch (Exception exception) {
            return new String[0];
        }
    }

    private static String decodeUtf8(byte[] byArray) {
        char[] cArray = new char[byArray.length];
        int n = 0;
        int n2 = 0;
        while (n2 < byArray.length) {
            int n3;
            int n4;
            if ((n4 = byArray[n2++] & 0xFF) < 128) {
                cArray[n++] = (char)n4;
                continue;
            }
            if ((n4 & 0xE0) == 192 && n2 < byArray.length) {
                n3 = byArray[n2++] & 0x3F;
                cArray[n++] = (char)((n4 & 0x1F) << 6 | n3);
                continue;
            }
            if ((n4 & 0xF0) == 224 && n2 + 1 < byArray.length) {
                n3 = byArray[n2++] & 0x3F;
                int n5 = byArray[n2++] & 0x3F;
                cArray[n++] = (char)((n4 & 0xF) << 12 | n3 << 6 | n5);
                continue;
            }
            cArray[n++] = 63;
        }
        return new String(cArray, 0, n);
    }

    private static String[] split(String string, char c2) {
        int n = 1;
        for (int i = 0; i < string.length(); ++i) {
            if (string.charAt(i) != c2) continue;
            ++n;
        }
        String[] stringArray = new String[n];
        int n2 = 0;
        int n3 = 0;
        for (int i = 0; i < string.length(); ++i) {
            if (string.charAt(i) != c2) continue;
            stringArray[n3++] = string.substring(n2, i);
            n2 = i + 1;
        }
        stringArray[n3] = string.substring(n2);
        return stringArray;
    }

    private void prepareFont(Graphics graphics) {
        try {
            graphics.setFont(Font.getFont((int)0, (int)0, (int)8));
        }
        catch (Exception exception) {
            // empty catch block
        }
    }

    private int textWidth(String string) {
        try {
            return Font.getFont((int)0, (int)0, (int)8).stringWidth(string);
        }
        catch (Exception exception) {
            return string.length() * 6;
        }
    }

    private void drawOutlined(Graphics graphics, String string, int n, int n2, int n3, int n4) {
        if (string == null || string.length() == 0) {
            return;
        }
        Font font = graphics.getFont();
        int n5 = font.stringWidth(string);
        int n6 = n - n5 * n3 / 2;
        graphics.setColor(0);
        graphics.drawString(string, n6 - 1, n2, 20);
        graphics.drawString(string, n6 + 1, n2, 20);
        graphics.drawString(string, n6, n2 - 1, 20);
        graphics.drawString(string, n6, n2 + 1, 20);
        if (n4 == 1) {
            graphics.setColor(0xFFFF00);
        } else if (n4 == 2) {
            graphics.setColor(0xFF8000);
        } else {
            graphics.setColor(0xFFFFFF);
        }
        graphics.drawString(string, n6, n2, 20);
    }

    private String cleanInline(String string) {
        StringBuffer stringBuffer = new StringBuffer();
        for (int i = 0; i < string.length(); ++i) {
            char c2 = string.charAt(i);
            if (c2 >= ' ' && c2 != '&') {
                stringBuffer.append(c2);
                continue;
            }
            if (c2 != '&') continue;
            stringBuffer.append(' ');
        }
        return stringBuffer.toString();
    }

    private String[] wrapText(String string, int n) {
        string = c.normalizeLong(string);
        String[] stringArray = new String[160];
        int n2 = 0;
        int n3 = 0;
        while (n3 <= string.length() && n2 < 160) {
            int n4 = c.indexOf(string, '\n', n3);
            if (n4 < 0) {
                n4 = string.length();
            }
            n2 = this.wrapPara(string.substring(n3, n4), n, stringArray, n2);
            if (n4 == string.length()) break;
            if (n2 < 160) {
                stringArray[n2++] = "";
            }
            n3 = n4 + 1;
        }
        String[] stringArray2 = new String[n2];
        for (int i = 0; i < n2; ++i) {
            stringArray2[i] = stringArray[i];
        }
        return stringArray2;
    }

    private int wrapPara(String string, int n, String[] stringArray, int n2) {
        if ((string = c.trim(string)).length() == 0) {
            if (n2 < 160) {
                stringArray[n2++] = "";
            }
            return n2;
        }
        Font font = Font.getFont((int)0, (int)0, (int)8);
        StringBuffer stringBuffer = new StringBuffer();
        int n3 = 0;
        while (n3 < string.length() && n2 < 160) {
            String string2;
            int n4;
            while (n3 < string.length() && string.charAt(n3) == ' ') {
                ++n3;
            }
            for (n4 = n3; n4 < string.length() && string.charAt(n4) != ' '; ++n4) {
            }
            String string3 = string.substring(n3, n4);
            if (stringBuffer.length() == 0) {
                string2 = string3;
            } else {
                StringBuffer stringBuffer2 = new StringBuffer();
                stringBuffer2.append(stringBuffer.toString());
                stringBuffer2.append(' ');
                stringBuffer2.append(string3);
                string2 = stringBuffer2.toString();
            }
            if (stringBuffer.length() > 0 && font.stringWidth(string2) > n) {
                stringArray[n2++] = stringBuffer.toString();
                stringBuffer.setLength(0);
            } else {
                if (stringBuffer.length() > 0) {
                    stringBuffer.append(' ');
                }
                stringBuffer.append(string3);
                n3 = n4;
            }
            if (stringBuffer.length() != 0 || string3.length() <= 0) continue;
            stringBuffer.append(string3);
            n3 = n4;
        }
        if (stringBuffer.length() > 0 && n2 < 160) {
            stringArray[n2++] = stringBuffer.toString();
        }
        return n2;
    }

    private static String normalizeLong(String string) {
        StringBuffer stringBuffer = new StringBuffer();
        for (int i = 0; i < string.length(); ++i) {
            char c2 = string.charAt(i);
            if (c2 == '&') {
                stringBuffer.append('\n');
                continue;
            }
            if (c2 >= ' ') {
                stringBuffer.append(c2);
                continue;
            }
            stringBuffer.append(' ');
        }
        return stringBuffer.toString();
    }

    private static int indexOf(String string, char c2, int n) {
        for (int i = n; i < string.length(); ++i) {
            if (string.charAt(i) != c2) continue;
            return i;
        }
        return -1;
    }

    private static String trim(String string) {
        int n;
        int n2 = string.length();
        for (n = 0; n < n2 && string.charAt(n) <= ' '; ++n) {
        }
        while (n2 > n && string.charAt(n2 - 1) <= ' ') {
            --n2;
        }
        return string.substring(n, n2);
    }
}

