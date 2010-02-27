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

    // Hankaku(half-width) to Zenkaku(full-width) Katakana conversion
    public class H2Z
    {
        private static const H2Z_TABLE:Array = [
            0x3002, 0x300c, 0x300d, 0x3001, 0x30fb, // U+ff61 - U+ff65
            0x30f2, 0x30a2, 0x30a3, 0x30a5, 0x30a7, // U+ff66 - U+ff6a
            0x30a9, 0x30e3, 0x30e5, 0x30e7, 0x30c3, // U+ff6b - U+ff6f
            0x30fc, 0x30a2, 0x30a4, 0x30a6, 0x30a8, // U+ff70 - U+ff74
            0x30aa, 0x30ab, 0x30ad, 0x30af, 0x30b1, // U+ff75 - U+ff79
            0x30b3, 0x30b5, 0x30b7, 0x30b9, 0x30bb, // U+ff7a - U+ff7e
            0x30bd, 0x30bf, 0x30c1, 0x30c4, 0x30c6, // U+ff7f - U+ff83
            0x30c8, 0x30ca, 0x30cb, 0x30cc, 0x30cd, // U+ff84 - U+ff88
            0x30ce, 0x30cf, 0x30d2, 0x30d5, 0x30d8, // U+ff89 - U+ff8d
            0x30db, 0x30de, 0x30df, 0x30e0, 0x30e1, // U+ff8e - U+ff92
            0x30e2, 0x30e4, 0x30e6, 0x30e8, 0x30e9, // U+ff93 - U+ff97
            0x30ea, 0x30eb, 0x30ec, 0x30ed, 0x30ef, // U+ff99 - U+ff9c
            0x30f3, 0x309b, 0x309c                  // U+ff9d - U+ff9f
        ];

        // This code is based on Java example in O'reilly's CJKV book.
        // And this is just for Non-BOM UTF-16 big endian
        public static function h2z(src:ByteArray):ByteArray
        {
            var c:uint;
            var next:uint;
            var temp:int;
            var result:ByteArray = new ByteArray();

            while (src.bytesAvailable >= 2) {
                c = src.readUnsignedShort();
                temp = src.position;
                if (c >= 0xff61 && c <= 0xff9f) {
                    if (src.bytesAvailable == 0) {
                        result.writeShort(H2Z_TABLE[c - 0xff61]);
                    } else {

                        next = src.readUnsignedShort();

                        if (   next == 0xff9e // kana dakuten
                            || next == 0x3099 // zenkaku dakuten
                            || next == 0x309b // zenkaku dakuten(independent)
                            ) {

                            if (c == 0xff73) { // hankaku ウ

                                result.writeShort(0x30f4); // zenkaku ヴ

                            } else if ( (c >= 0xff76 && c <= 0xff84) // hankaku カキクケコサシスセソタチツテト
                                     || (c >= 0xff8a && c <= 0xff8e) // hankaku ハヒフヘホ
                                ) {

                                result.writeShort(H2Z_TABLE[c - 0xff61] + 1);

                            } else {

                                result.writeShort(H2Z_TABLE[c - 0xff61]);
                                src.position = temp;

                            }

                        } else if (next == 0xff9f // han-dakuten
                                || next == 0x309a // zenkaku han-dakuten
                                || next == 0x309c // zenkaku han-dakuten(independent)
                        ) {
                            if (c >= 0xff8a && c <= 0xff8e) {

                                result.writeShort(H2Z_TABLE[c - 0xff61] + 2);

                            } else {

                                result.writeShort(H2Z_TABLE[c - 0xff61]);
                                src.position = temp;
                            }

                        } else {
                            result.writeShort(H2Z_TABLE[c - 0xff61]);
                            src.position = temp;
                        }
                    }
                } else {
                    result.writeShort(c);
                }
            }
            return result;
        }

    }
}

