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

package org.coderepos.text.encoding.writers
{
    import flash.utils.ByteArray;

    public class UTF16Writer implements IUnicodeWriter
    {
        private var _bytes:ByteArray;
        private var _bigEndian:Boolean;

        public function UTF16Writer(useBOM:Boolean=false, bigEndian:Boolean=true)
        {
            _bytes = new ByteArray();
            _bigEndian = bigEndian;
            if (useBOM) {
                if (bigEndian) {
                    _bytes.writeByte(0xfe);
                    _bytes.writeByte(0xff);
                } else {
                    _bytes.writeByte(0xff);
                    _bytes.writeByte(0xfe);
                }
            }
        }

        public function write(unicode:uint):void
        {
            var temp:uint;
            var b1:uint;
            var b2:uint;
            if (unicode > 0xffff) { // larger than UCS-2

                // convert to salogate pair
                temp = unicode - 0x00010000;

                // 10, 10
                // 1101 10yy yyyy yyyy, 1101 11xx xxxx xxxx
                b1 = ((temp >> 10) & 0x03ff) | 0xd800;
                b2 = (temp & 0x03ff) | 0xdc00;
                writeBytes((b1 >> 8) & 0xff, b1 & 0xff);
                writeBytes((b2 >> 8) & 0xff, b2 & 0xff);

            } else { // can be represented by UCS-2

                b1 = (unicode >> 8) & 0xff;
                b2 = unicode & 0xff;
                writeBytes(b1, b2);
            }

        }

        private function writeBytes(b1:uint, b2:uint):void
        {
            if (_bigEndian) {
                _bytes.writeByte(b1);
                _bytes.writeByte(b2);
            } else {
                _bytes.writeByte(b2);
                _bytes.writeByte(b1);
            }
        }

        public function getResult():ByteArray
        {
            _bytes.position = 0;
            return _bytes;
        }
    }
}

