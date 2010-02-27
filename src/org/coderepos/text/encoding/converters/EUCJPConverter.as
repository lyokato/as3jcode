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

package org.coderepos.text.encoding.converters
{
    import flash.utils.ByteArray;
    import org.coderepos.text.encoding.writers.IUnicodeWriter;
    import org.coderepos.text.encoding.tables.E2U;

    public class EUCJPConverter implements IUnicodeConverter
    {
        private var _unicodeWriter:IUnicodeWriter;

        public function EUCJPConverter(unicodeWriter:IUnicodeWriter)
        {
            _unicodeWriter = unicodeWriter;
        }

        private function findUnicode(euc:uint):uint
        {
            //if ( euc == 0xa1c0   ) return 0xff3c;
            if ( euc == 0xa1c0   ) return 0x005c; // back slash
            if ( euc == 0x8fa2b7 ) return 0x007e; // dash wave
            var unicode:uint = E2U.find(euc);
            return unicode;
        }

        public function convert(b:ByteArray):ByteArray
        {
            var c:uint;
            var n1:uint;
            var n2:uint;
            var temp:int;
            var unicode:uint;

            b.position = 0;

            while (b.bytesAvailable > 0) {
                c = b.readUnsignedByte();
                temp = b.position;
                if (c >= 0xa1 && c <= 0xfe && b.bytesAvailable > 0) {
                    n1 = b.readUnsignedByte();
                    if (n1 >= 0xa1 && n1 <= 0xfe) {
                        // JIS X 0208
                        unicode = findUnicode((c << 8) | n1);
                        _unicodeWriter.write(unicode);
                    } else {
                        _unicodeWriter.write(c);
                        b.position = temp;
                    }
                } else if (c == 0x8e && b.bytesAvailable > 0) {
                    n1 = b.readUnsignedByte();
                    if (n1 >= 0xa1 && n1 <= 0xdf) {
                        // Hankaku Kana
                        unicode = findUnicode((c << 8) | n1);
                        _unicodeWriter.write(unicode);
                    } else {
                        _unicodeWriter.write(c);
                        b.position = temp;
                    }
                } else if (c == 0x8f && b.bytesAvailable >= 2) {
                    // JIS X 0212
                    n1 = b.readUnsignedByte();
                    n2 = b.readUnsignedByte();
                    if ( n1 >= 0xa1 && n1 <= 0xfe
                      && n2 >= 0xa1 && n2 <= 0xfe) {
                        unicode = findUnicode((c << 16) | (n1 << 8) | n2);
                        _unicodeWriter.write(unicode);
                    } else {
                        _unicodeWriter.write(c);
                        b.position = temp;
                    }
                } else if (c >= 0x00 && c <= 0xff) {
                    unicode = findUnicode(c);
                    _unicodeWriter.write(unicode);
                } else {
                    _unicodeWriter.write(c);
                    b.position = temp;
                }
            }
            return _unicodeWriter.getResult();
        }
    }
}

