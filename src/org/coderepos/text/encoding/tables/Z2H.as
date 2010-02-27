/*
Copyright (c) Lyo Kato (lyo.kato _at_ gmail.com)

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
*/

package org.coderepos.text.encoding.tables
{
    import flash.utils.ByteArray;

    // Zenkaku(full-width) to Hankaku(half-width) Katakana conversion
    public class Z2H
    {
        private static const Z2H_TABLE:Array = [
            0xff67, 0xff71, 0xff68, 0xff72, 0xff69, 0xff73, 0xff6a, 0xff74, 0xff6b, 0xff75,
            0xff76,   null, 0xff77,   null, 0xff78,   null, 0xff79,   null, 0xff7a,   null,
            0xff7b,   null, 0xff7c,   null, 0xff7d,   null, 0xff7e,   null, 0xff7f,   null,
            0xff80,   null, 0xff81,   null, 0xff6f, 0xff82,   null, 0xff83,   null, 0xff84,   null,
            0xff85, 0xff86, 0xff87, 0xff88, 0xff89,
            0xff8a,   null,   null, 0xff8b,   null,   null, 0xff8c,   null,   null, 0xff8d,   null,  null, 0xff8e,  null,  null,
            0xff8f, 0xff90, 0xff91, 0xff92, 0xff93,
            0xff6c, 0xff94, 0xff6d, 0xff95, 0xff6e, 0xff96,
            0xff97, 0xff98, 0xff99, 0xff9a, 0xff9b,
            0xff9c, 0xff9c, 0xff72, 0xff74, 0xff66, 0xff9d,  null, 0xff76, 0xff79
        ];

        public static function z2h(src:ByteArray, convertKigou:Boolean=true):ByteArray
        {
            var c:uint;
            var result:ByteArray = new ByteArray();

            while (src.bytesAvailable >= 2) {
                c = src.readUnsignedShort();
                if (c >= 0x30a1 && c <= 0x30f6) {
                    if (c == 0x30f4) { // ヴ
                        result.writeShort(0xff73);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30ac) { // ガ
                        result.writeShort(0xff76);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30ae) { // ギ
                        result.writeShort(0xff77);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30b0) { // グ
                        result.writeShort(0xff78);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30b2) { // ゲ
                        result.writeShort(0xff79);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30b4) { // ゴ
                        result.writeShort(0xff7a);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30b6) { // ザ
                        result.writeShort(0xff7b);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30b8) { // ジ
                        result.writeShort(0xff7c);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30ba) { // ズ
                        result.writeShort(0xff7d);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30bc) { // ゼ
                        result.writeShort(0xff7e);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30be) { // ゾ
                        result.writeShort(0xff7f);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30c0) { // ダ
                        result.writeShort(0xff80);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30c2) { // ヂ
                        result.writeShort(0xff81);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30c5) { // ヅ
                        result.writeShort(0xff82);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30c7) { // デ
                        result.writeShort(0xff83);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30c9) { // ド
                        result.writeShort(0xff84);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30d0) { // バ
                        result.writeShort(0xff8a);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30d3) { // ビ
                        result.writeShort(0xff8b);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30d6) { // ブ
                        result.writeShort(0xff8c);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30d9) { // ベ
                        result.writeShort(0xff8d);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30dc) { // ボ
                        result.writeShort(0xff8e);
                        result.writeShort(0xff9e);
                    } else if (c == 0x30d1) { // パ
                        result.writeShort(0xff8a);
                        result.writeShort(0xff9f);
                    } else if (c == 0x30d4) { // ピ
                        result.writeShort(0xff8b);
                        result.writeShort(0xff9f);
                    } else if (c == 0x30d7) { // プ
                        result.writeShort(0xff8c);
                        result.writeShort(0xff9f);
                    } else if (c == 0x30da) { // ペ
                        result.writeShort(0xff8d);
                        result.writeShort(0xff9f);
                    } else if (c == 0x30dd) { // ポ
                        result.writeShort(0xff8e);
                        result.writeShort(0xff9f);
                    } else {
                        result.writeShort(Z2H_TABLE[c - 0x30a1]);
                    }
                } else if (convertKigou && c == 0x3002) {
                    result.writeShort(0xff61);
                } else if (convertKigou && c == 0x300c) {
                    result.writeShort(0xff62);
                } else if (convertKigou && c == 0x300d) {
                    result.writeShort(0xff63);
                } else if (convertKigou && c == 0x3001) {
                    result.writeShort(0xff64);
                } else if (convertKigou && c == 0x30fb) {
                    result.writeShort(0xff65);
                } else if (convertKigou && c == 0x30fc) {
                    result.writeShort(0xff70);
                } else {
                    result.writeShort(c);
                }
            }
            return result;
        }

    }
}

