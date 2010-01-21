package org.coderepos.text.encoding {

    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;

    public class IMAP_UTF7 {

        // Convert UTF-8(AS3 Native String) to Modified-UTF7(IMAP-UTF7)
        // see RFC 3501 section 5.1.3
        public static function encode(utf8string:String):String {

            var c:uint;
            var result:String = "";
            var buffer:ByteArray = new ByteArray();

            var utf16bytes:ByteArray = Jcode.to_utf16(utf8string);

            while (utf16bytes.bytesAvailable >= 2) {

                 c = utf16bytes.readUnsignedShort();
                 if (c == 0x0026) {
                    if (buffer.length > 0) {
                        result += '&'
                        result += encodeModifiedBase64(buffer);
                        result += '-'
                        buffer = new ByteArray();
                    }
                    result += "&-";
                 } else if (c >= 0x0020 && c <= 0x007e) {
                    if (buffer.length > 0) {
                        result += '&'
                        result += encodeModifiedBase64(buffer);
                        result += '-'
                        buffer = new ByteArray();
                    }
                    result += String.fromCharCode(c);
                 } else {
                    buffer.writeShort(c);
                 }
            }
            if (buffer.length > 0) {
                result += '&'
                result += encodeModifiedBase64(buffer);
                result += '-'
            }
            return result;
        }

        public static function encodeModifiedBase64(bytes:ByteArray):String
        {
            bytes.position = 0;
            var b64:String = Base64.encodeByteArray(bytes);
            b64 = b64.replace('/', ',').replace(/\=*$/, "");
            return b64;
        }

        // Convert Modified-UTF7(IMAP-UTF7) to UTF-8(AS3 Native String)
        // see RFC 3501 section 5.1.3
        public static function decode(utf7imap:String):String
        {
            var utf16bytes:ByteArray = new ByteArray();

            var len:int = utf7imap.length;
            var buffer:String;
            var c:uint;
            var next:uint;

            for (var i:int = 0; i<len;) {

                c = utf7imap.charCodeAt(i++);

                //  if found '&', search next '-'
                if (c == 0x26) {

                    buffer = "";

                    while (i + 1 <= len) {

                        next = utf7imap.charCodeAt(i++);

                        // found '-'
                        if (next == 0x2d) {
                            // has string that was encoded with modified base64
                            // '&XXXX-'
                            if (buffer.length > 0) {
                                var bytes:ByteArray = decodeModifiedBase64(buffer);
                                utf16bytes.writeBytes(bytes);
                            } else {
                                // found '&-' that should become '&'
                                utf16bytes.writeShort(0x26);
                            }
                            break;
                        } else {
                            // keep the character into buffer
                            buffer += String.fromCharCode(next);
                            // and go to next loop
                        }
                    }
                } else {
                    utf16bytes.writeShort(c);
                }
            }
            return Jcode.from_utf16(utf16bytes);
        }

        public static function decodeModifiedBase64(b64:String):ByteArray
        {
            b64 = b64.replace(',', '/');
            var padding:int = 4 - (b64.length & 0x03);
            if (padding != 4) {
                while (padding > 0) {
                    b64 += "=";
                    padding--;
                }
            }
            return Base64.decodeToByteArray(b64);
        }

    }
}

