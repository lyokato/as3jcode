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

    public class UTF16Converter implements IUnicodeConverter
    {
        private var _unicodeWriter:IUnicodeWriter;

        public function UTF16Converter(unicodeWriter:IUnicodeWriter)
        {
            _unicodeWriter = unicodeWriter;
        }

        public function convert(b:ByteArray):ByteArray
        {
            var c1:uint;
            var c2:uint;
            var c3:uint;
            var c4:uint;
            var unicode:uint;
            var next:uint;
            var bigEndian:Boolean;

            b.position = 0;

            if (b.bytesAvailable >= 2) {

                c1 = b.readUnsignedByte();
                c2 = b.readUnsignedByte();

                if (c1 == 0xfe && c2 == 0xff) {
                    bigEndian = true;
                } else if (c1 == 0xff && c2 == 0xfe) {
                    bigEndian = false;
                } else {
                    bigEndian = true;
                    b.position = 0;
                }
            }

            while (b.bytesAvailable >= 2) {
                if (bigEndian) {
                    c1 = b.readUnsignedByte();
                    c2 = b.readUnsignedByte();
                } else {
                    c2 = b.readUnsignedByte();
                    c1 = b.readUnsignedByte();
                }

                unicode = (c1 << 8) | c2;

                // if code matches salogate-pair
                if (unicode >= 0xd800 && unicode <= 0xdbff) {

                    if (b.bytesAvailable < 2)
                        break; //throw new Error();

                    if (bigEndian) {
                        c3 = b.readUnsignedByte();
                        c4 = b.readUnsignedByte();
                    } else {
                        c4 = b.readUnsignedByte();
                        c3 = b.readUnsignedByte();
                    }

                    next = (c3 << 8) | c4;
                    _unicodeWriter.write((((unicode - 0xd800) << 10 ) | (next - 0xdc00)) + 0x10000);

                } else {

                    _unicodeWriter.write(unicode);

                }

            }
            return _unicodeWriter.getResult();
        }
    }
}

