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

package org.coderepos.text.encoding
{
    import flash.utils.ByteArray;

    import org.coderepos.text.encoding.writers.*;
    import org.coderepos.text.encoding.converters.*;
    import org.coderepos.text.encoding.rules.*;
    import org.coderepos.text.encoding.validators.*;
    import org.coderepos.text.encoding.tables.*;

    public class Jcode
    {
        public static const VERSION:String = "1.0.2";

        // validation methods
        public static function is_hiragana(utf8string:String):Boolean
        {
            var b:ByteArray = new ByteArray();
            b.writeUTFBytes(utf8string);
            return (new UTF8Validator(new IS_HIRAGANA())).validate(b);
        }

        public static function is_zenkaku_katakana(utf8string:String):Boolean
        {
            var b:ByteArray = new ByteArray();
            b.writeUTFBytes(utf8string);
            return (new UTF8Validator(new IS_ZENKAKU_KATAKANA())).validate(b);
        }

        public static function is_hankaku_katakana(utf8string:String):Boolean
        {
            var b:ByteArray = new ByteArray();
            b.writeUTFBytes(utf8string);
            return (new UTF8Validator(new IS_HANKAKU_KATAKANA())).validate(b);
        }

        public static function is_katakana(utf8string:String):Boolean
        {
            var b:ByteArray = new ByteArray();
            b.writeUTFBytes(utf8string);
            var rules:IRule = new Rules(new IS_HANKAKU_KATAKANA(), new IS_ZENKAKU_KATAKANA());
            return (new UTF8Validator(rules)).validate(b);
        }

        // hankaku zenkaku
        public static function h2z(utf8String:String):String
        {
            return from_utf16(H2Z.h2z(to_utf16(utf8String)));
        }

        public static function z2h(utf8String:String):String
        {
            return from_utf16(Z2H.z2h(to_utf16(utf8String)));
        }

        public static function decodeURIComponentToBytes(src:String,
            plus2space:Boolean=true):ByteArray
        {
            var char:String;
            var next:String;
            var i:int = 0;
            var len:int = src.length;
            var decoded:ByteArray = new ByteArray();
            while (i < len) {
                char = src.charAt(i++);
                if (char == "+") {
                    if (plus2space)
                        decoded.writeByte(0x20); // SPACE
                    else
                        decoded.writeByte(0x2b); // +
                } else if (char == "%" && i + 2 <= len) {
                    next = src.substring(i, i+2);
                    i += 2;
                    if (next.match(/^[0-9a-zA-Z]{2}$/) != null) {
                        decoded.writeByte(parseInt(next, 16));
                    } else {
                        decoded.writeUTFBytes(char + next);
                    }
                } else {
                    decoded.writeUTFBytes(char);
                }
            }
            decoded.position = 0;
            return decoded;
        }

        public static function encodeURIComponentBytes(bytes:ByteArray,
            space2plus:Boolean=true, useRFC3986:Boolean=false):String
        {
            var encoded:String = "";
            var c:uint;
            while (bytes.bytesAvailable > 0) {
                c = bytes.readUnsignedByte();
                if (c == 0x20) { // SPACE
                    if (space2plus) {
                        encoded += "+";
                    } else {
                        encoded += "%20";
                    }
                } else if (
                       (c >= 0x30 && c <= 0x39) // 0 - 9
                    || (c >= 0x41 && c <= 0x5a) // A - Z
                    || (c >= 0x61 && c <= 0x7a) // A - Z
                    || c == 0x2d // -
                    || c == 0x5f // _
                    || c == 0x2e // .
                    || c == 0x7e // ~
                    ) {
                    encoded += "%" + Number(c).toString(16).toUpperCase()
                } else if (
                       c == 0x21 // !
                    || c == 0x5c // \
                    || c == 0x28 // (
                    || c == 0x29 // )
                    ) {
                    if (useRFC3986) {
                        encoded += "%" + Number(c).toString(16).toUpperCase()
                    } else {
                        encoded += String.fromCharCode(c);
                    }
                } else {
                    encoded += "%" + Number(c).toString(16).toUpperCase()
                }
            }
            return encoded;
        }

        public static function to_utf16(utf8String:String):ByteArray
        {
            var b:ByteArray = new ByteArray();
            b.writeUTFBytes(utf8String);
            return utf8_utf16(b);
        }

        public static function utf8_utf16(utf8Bytes:ByteArray):ByteArray
        {
            return (new UTF8Converter(new UTF16Writer())).convert(utf8Bytes);
        }

        public static function to_utf16be(utf8String:String):ByteArray
        {
            var b:ByteArray = new ByteArray();
            b.writeUTFBytes(utf8String);
            return utf8_utf16be(b);
        }

        public static function utf8_utf16be(utf8Bytes:ByteArray):ByteArray
        {
            return (new UTF8Converter(new UTF16Writer(true))).convert(utf8Bytes);
        }

        public static function utf8_utf16le(utf8Bytes:ByteArray):ByteArray
        {
            return (new UTF8Converter(new UTF16Writer(true, false))).convert(utf8Bytes);
        }

        public static function from_utf16(utf16Bytes:ByteArray):String
        {
            var b:ByteArray = utf16_utf8(utf16Bytes);
            return b.readUTFBytes(b.bytesAvailable);
        }

        public static function utf16_utf8(utf16Bytes:ByteArray):ByteArray
        {
            return (new UTF16Converter(new UTF8Writer())).convert(utf16Bytes);
        }

        public static function utf16_utf8n(utf16Bytes:ByteArray):ByteArray
        {
            return (new UTF16Converter(new UTF8Writer(true))).convert(utf16Bytes);
        }

        public static function to_euc(utf8String:String):ByteArray
        {
            var b:ByteArray = new ByteArray();
            b.writeUTFBytes(utf8String);
            return utf8_euc(b);
        }

        public static function utf8_euc(utf8Bytes:ByteArray):ByteArray
        {
            return (new UTF8Converter(new EUCJPWriter())).convert(utf8Bytes);
        }

        public static function from_euc(eucBytes:ByteArray):String
        {
            var b:ByteArray = euc_utf8(eucBytes);
            return b.readUTFBytes(b.bytesAvailable);
        }

        public static function euc_utf8(eucBytes:ByteArray):ByteArray
        {
            return (new EUCJPConverter(new UTF8Writer())).convert(eucBytes);
        }

        public static function euc_utf8n(eucBytes:ByteArray):ByteArray
        {
            return (new EUCJPConverter(new UTF8Writer(true))).convert(eucBytes);
        }

        public static function to_jis(utf8String:String):ByteArray
        {
            var b:ByteArray = new ByteArray();
            b.writeUTFBytes(utf8String);
            return utf8_jis(b);
        }

        public static function utf8_jis(utf8Bytes:ByteArray):ByteArray
        {
            return euc_jis(utf8_euc(utf8Bytes));
        }

        public static function from_jis(jisBytes:ByteArray):String
        {
            var b:ByteArray = jis_utf8(jisBytes);
            return b.readUTFBytes(b.bytesAvailable);
        }

        public static function jis_utf8(jisBytes:ByteArray):ByteArray
        {
            return euc_utf8(jis_euc(jisBytes));
        }

        public static function jis_utf8n(jisBytes:ByteArray):ByteArray
        {
            return euc_utf8n(jis_euc(jisBytes));
        }

        public static function to_sjis(utf8String:String):ByteArray
        {
            var b:ByteArray = new ByteArray();
            b.writeUTFBytes(utf8String);
            return utf8_sjis(b);
        }

        public static function utf8_sjis(utf8Bytes:ByteArray):ByteArray
        {
            return euc_sjis(utf8_euc(utf8Bytes));
        }

        public static function from_sjis(sjisBytes:ByteArray):String
        {
            var b:ByteArray = sjis_utf8(sjisBytes);
            return b.readUTFBytes(b.bytesAvailable);
        }

        public static function sjis_utf8(sjisBytes:ByteArray):ByteArray
        {
            return euc_utf8(sjis_euc(sjisBytes));
        }

        public static function sjis_utf8n(sjisBytes:ByteArray):ByteArray
        {
            return euc_utf8n(sjis_euc(sjisBytes));
        }

        public static function jis_sjis(jisBytes:ByteArray):ByteArray
        {
            return euc_jis(jis_euc(jisBytes));
        }

        public static function sjis_jis(sjisBytes:ByteArray):ByteArray
        {
            return euc_jis(sjis_euc(sjisBytes));
        }

        public static function jis_euc(jisBytes:ByteArray):ByteArray
        {
            var c:uint;
            var n1:uint;
            var n2:uint;
            var n3:uint;
            var n4:uint;
            var n5:uint;

            var mode:uint = 0; // 0 = ASCII, 1 = JIS X 0208, 2 = JIS X 0212, 3 = Hankaku Kana
            var temp:int;

            var eucBytes:ByteArray = new ByteArray();
            jisBytes.position = 0;

            while (jisBytes.bytesAvailable > 0) {
                c = jisBytes.readUnsignedByte();
                temp = jisBytes.position;
                if (c == 0x1b && jisBytes.bytesAvailable >= 2) { // ESC
                    n1 = jisBytes.readUnsignedByte();
                    n2 = jisBytes.readUnsignedByte();
                    if (n1 == 0x28) { // '('
                        if (n2 == 0x42 || n2 == 0x4a) { // 'B' || 'J'
                            mode = 0; // ASCII
                        } else if (n2 == 0x49) { // 'I'
                            mode = 3; // Hankaku Kana
                        } else {
                            // jisBytes.writeByte(c);
                            jisBytes.position = temp;
                        }
                    } else if (n1 == 0x24) { // '$'
                        if (n2 == 0x40 || n2 == 0x42) { // '@' || 'B'
                            mode = 1; // JIS X 0208 (78JIS, 83JIS)
                        } else if (n2 == 0x28 && jisBytes.bytesAvailable > 0) { // '('
                            n3 = jisBytes.readUnsignedByte();
                            if (n3 == 0x44) { // 'D'
                                mode = 2; // JIS X 0212
                            } else {
                                // jisBytes.writeByte(c);
                                jisBytes.position = temp;
                            }
                        } else {
                            // jisBytes.writeByte(c);
                            jisBytes.position = temp;
                        }
                    } else if (n1 == 0x26 && n2 == 0x40 && jisBytes.bytesAvailable >= 3) { // &@
                        n3 = jisBytes.readUnsignedByte();
                        n4 = jisBytes.readUnsignedByte();
                        n5 = jisBytes.readUnsignedByte();
                        if (n3 == 0x1b && n4 == 0x24 && n5 == 0x42) { /// ESC$B
                            mode = 1; // JIS X 0208 (90|97JIS)
                        } else {
                            // jisBytes.writeByte(c);
                            jisBytes.position = temp;
                        }
                    } else {
                        // jisBytes.writeByte(c);
                        jisBytes.position = temp;
                    }
                } else {
                    if (mode == 0) { // ASCII
                        eucBytes.writeByte(c);
                    } else {
                        if (c >= 0x21 && c <= 0x7e)
                            c = c | 0x80;
                        if (mode == 1) { // JIS X 0208
                            eucBytes.writeByte(c);
                        } else if (mode == 3) { // Hankaku Kana
                        // XXX: need to convert Hankaku -> Zenkaku ?
                            if (c >= 0xa1 && c <= 0xdf)
                                eucBytes.writeByte(0x8e);
                            eucBytes.writeByte(c);
                        } else if (mode == 2) { // JIS X 0212
                            // should check next byte
                            if (c >= 0xa1 && c <= 0xfe && jisBytes.bytesAvailable > 0) {
                                n1 = jisBytes.readUnsignedByte();
                                if (n1 >= 0x21 && n1 <= 0x7e)
                                    n1 = n1 | 0x80;
                                if (n1 >= 0xa1 && n1 <= 0xfe) {
                                    eucBytes.writeByte(0x8f);
                                    eucBytes.writeByte(c);
                                    eucBytes.writeByte(n1);
                                } else {
                                    eucBytes.writeByte(c);
                                    jisBytes.position = temp;
                                }
                            } else {
                                eucBytes.writeByte(c);
                            }
                        }
                    }
                }
            }
            eucBytes.position = 0;
            return eucBytes;
        }

        public static function euc_jis(eucBytes:ByteArray):ByteArray
        {
            var c:uint;
            var n1:uint;
            var n2:uint;
            var temp:int;

            var jisBytes:ByteArray = new ByteArray();
            eucBytes.position = 0;

            var mode:uint = 4; // 0 = ASCII, 1 = JIS X 0208, 2 = JIS X 0212, 3 = Hankaku Kana

            while (eucBytes.bytesAvailable > 0) {

                c = eucBytes.readUnsignedByte();
                temp = eucBytes.position;

                if (c >= 0xa1 && c <= 0xfe && eucBytes.bytesAvailable > 0) {
                    n1 = eucBytes.readUnsignedByte();
                    if (n1 >= 0xa1 && n1 <= 0xfe) {
                        // EUC 2byte character JIS X 0208
                        if (mode != 1) {
                            mode = 1;
                            jisBytes.writeByte(0x1b); // \e
                            jisBytes.writeByte(0x24); // $
                            jisBytes.writeByte(0x42); // B
                        }
                        c  &= 0x7f; //0b01111111;
                        n1 &= 0x7f;
                        jisBytes.writeByte(c);
                        jisBytes.writeByte(n1);
                    } else {
                        jisBytes.writeByte(c);
                        eucBytes.position = temp;
                    }
                } else if (c == 0x8e && eucBytes.bytesAvailable > 0) {
                    n1 = eucBytes.readUnsignedByte();
                    if (n1 >= 0xa1 && n1 <= 0xdf) {
                        // Hankaku Kana 2byte
                        if (mode != 3) {
                            mode = 3;
                            jisBytes.writeByte(0x1b); // \e
                            jisBytes.writeByte(0x28); // (
                            jisBytes.writeByte(0x49); // I
                        }
                        n1 &= 0x7f;
                        jisBytes.writeByte(n1);
                    } else {
                        jisBytes.writeByte(c);
                        eucBytes.position = temp;
                    }
                } else if (c == 0x8f && eucBytes.bytesAvailable >= 2) {
                    n1 = eucBytes.readUnsignedByte();
                    n2 = eucBytes.readUnsignedByte();
                    if ( n1 >= 0xa1 && n1 <= 0xfe
                      && n2 >= 0xa1 && n2 <= 0xfe) {
                        // JIS X 0212 3byte
                        if (mode != 2) {
                            mode = 2;
                            jisBytes.writeByte(0x1b); // \e
                            jisBytes.writeByte(0x24); // $
                            jisBytes.writeByte(0x28); // (
                            jisBytes.writeByte(0x44); // D
                        }
                        n1 &= 0x7f;
                        n2 &= 0x7f;
                        jisBytes.writeByte(n1);
                        jisBytes.writeByte(n2);
                    } else {
                        jisBytes.writeByte(c);
                        eucBytes.position = temp;
                    }
                } else {
                    // ASCII?
                    if (mode != 0) {
                        mode = 0;
                        jisBytes.writeByte(0x1b); // \e
                        jisBytes.writeByte(0x28); // (
                        jisBytes.writeByte(0x42); // B
                    }
                    jisBytes.writeByte(c);
                }
            }

            // this is needed?
            // for compatibility perl's Encode|Jcode module
            if (mode != 0) {
                jisBytes.writeByte(0x1b); // \e
                jisBytes.writeByte(0x28); // (
                jisBytes.writeByte(0x42); // B
            }

            jisBytes.position = 0;
            return jisBytes;
        }

        public static function sjis_euc(sjisBytes:ByteArray):ByteArray
        {
            var c:uint;
            var n1:uint;
            var ku:uint;
            var ten:uint;
            var temp:int;

            var eucBytes:ByteArray = new ByteArray();
            sjisBytes.position = 0;

            while (sjisBytes.bytesAvailable > 0) {

                c = sjisBytes.readUnsignedByte();
                temp = sjisBytes.position;

                if ( ( (c >= 0x81 && c <= 0x9f)
                    || (c >= 0xe0 && c <= 0xfc) ) && sjisBytes.bytesAvailable > 0) {
                    n1 = sjisBytes.readUnsignedByte();
                    if ((n1 >= 0x40 && n1 <= 0x7e)
                     || (n1 >= 0x80 && n1 <= 0xfc)) {
                        // JIS X 0208
                        // convert kuten code
                        if (n1 >= 0x9f) {
                            ku = c * 2;
                            ku -= (c >= 0xe0) ? 0xe0 : 0x60;
                            ten = n1 + 2;
                        } else {
                            ku = c * 2;
                            ku -= (c >= 0xe0) ? 0xe1 : 0x61;
                            ten = n1 + 0x60;
                            if (n1 < 0x7f)
                                ten++;
                        }
                        eucBytes.writeByte(ku);
                        eucBytes.writeByte(ten);
                    } else {
                        eucBytes.writeByte(c);
                        sjisBytes.position = temp;
                    }
                } else if (c >= 0xa1 && c <= 0xdf) {
                    // Hankaku Kana
                    eucBytes.writeByte(0x8e);
                    eucBytes.writeByte(c);
                } else {
                    // ASCII?
                    eucBytes.writeByte(c);
                }

            }
            eucBytes.position = 0;
            return eucBytes;
        }

        public static function euc_sjis(eucBytes:ByteArray):ByteArray
        {
            var c:uint;
            var n1:uint;
            var n2:uint;
            var ku:uint;
            var ten:uint;
            var temp:int;

            var sjisBytes:ByteArray = new ByteArray();
            eucBytes.position = 0;

            while (eucBytes.bytesAvailable > 0) {

                c = eucBytes.readUnsignedByte();
                temp = eucBytes.position;

                if (c >= 0xa1 && c <= 0xfe && eucBytes.bytesAvailable > 0) {
                    n1 = eucBytes.readUnsignedByte();
                    if (n1 >= 0xa1 && n1 <= 0xfe) {
                        // EUC 2byte character JIS X 0208
                        // convert kuten code
                        if (c % 2 == 1) {
                            ku = (c >> 1);
                            ku += (c < 0xdf) ? 0x31 : 0x71;
                            ten = n1 - 0x60;
                            if (n1 < 0xe0)
                                ten--;
                        } else {
                            ku  = (c >> 1);
                            ku += (c < 0xdf) ? 0x30 : 0x70;
                            ten = n1 - 2;
                        }
                        sjisBytes.writeByte(ku);
                        sjisBytes.writeByte(ten);
                    } else {
                        sjisBytes.writeByte(c);
                        eucBytes.position = temp;
                    }
                } else if (c == 0x8e && eucBytes.bytesAvailable > 0) {
                    n1 = eucBytes.readUnsignedByte();
                    if (n1 >= 0xa1 && n1 <= 0xdf) {
                        // Hankaku Kana 2byte
                        sjisBytes.writeByte(n1);
                    } else {
                        sjisBytes.writeByte(c);
                        eucBytes.position = temp;
                    }
                } else if (c == 0x8f && eucBytes.bytesAvailable >= 2) {
                    n1 = eucBytes.readUnsignedByte();
                    n2 = eucBytes.readUnsignedByte();
                    if ( n1 >= 0xa1 && n1 <= 0xfe
                      && n2 >= 0xa1 && n2 <= 0xfe) {
                        // JIS X 0212 3byte
                        // UNDEF on Shift_JIS
                        sjisBytes.writeByte(0x81);
                        sjisBytes.writeByte(0xac);
                    } else {
                        sjisBytes.writeByte(c);
                        eucBytes.position = temp;
                    }
                } else {
                    // ASCII?
                    sjisBytes.writeByte(c);
                    eucBytes.position = temp;
                }
            }
            sjisBytes.position = 0;
            return sjisBytes;
        }
    }
}

