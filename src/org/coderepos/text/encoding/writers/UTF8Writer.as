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

    public class UTF8Writer implements IUnicodeWriter
    {
        private var _bytes:ByteArray;

        public function UTF8Writer(useBOM:Boolean=false)
        {
            _bytes = new ByteArray();
            if (useBOM) {
                _bytes.writeByte(0xef);
                _bytes.writeByte(0xbb);
                _bytes.writeByte(0xbf);
            }
        }

        public function write(unicode:uint):void
        {
            if (unicode >= 0x0000 && unicode <= 0x007f) { // ascii (1byte)
                _bytes.writeByte(unicode);
            } else if (unicode >= 0x0080 && unicode <= 0x07ff) { // 2byte
                //5,6
                //110XXXXX, 10YYYYYY
                _bytes.writeByte(((unicode >> 6) & 0x1f) | 0xc0);
                _bytes.writeByte((unicode & 0x3f) | 0x80);
            } else if (unicode >= 0x0800 && unicode <= 0xffff) { // 3byte
                //4,6,6
                //1110XXXX, 10YYYYYY, 10ZZZZZZ
                _bytes.writeByte(((unicode >> 12) & 0x0f) | 0xe0);
                _bytes.writeByte(((unicode >> 6) & 0x3f) | 0x80);
                _bytes.writeByte((unicode & 0x3f) | 0x80);
            } else if (unicode >= 0x010000 && unicode <= 0x1fffff) { // 4byte
                //3,6,6,6
                //11110XXX, 10YYYYYY, 10ZZZZZZ, ...
                _bytes.writeByte(((unicode >> 18) & 0x07) | 0xf0);
                _bytes.writeByte(((unicode >> 12) & 0x3f) | 0x80);
                _bytes.writeByte(((unicode >> 6) & 0x3f) | 0x80);
                _bytes.writeByte((unicode & 0x3f) | 0x80);
            } else if (unicode >= 0x200000 && unicode <= 0x03ffffff) { // 5byte
                //2,6,6,6,6
                //111110XX, 10YYYYYY, ...
                _bytes.writeByte(((unicode >> 24) & 0x03) | 0xf8);
                _bytes.writeByte(((unicode >> 18) & 0x3f) | 0x80);
                _bytes.writeByte(((unicode >> 12) & 0x3f) | 0x80);
                _bytes.writeByte(((unicode >> 6) & 0x3f) | 0x80);
                _bytes.writeByte((unicode & 0x3f) | 0x80);
            } else if (unicode >= 0x04000000 && unicode <= 0x7fffffff) { // 6byte
                //1,6,6,6,6,6
                //1111110X, 10YYYYYY, ...
                _bytes.writeByte(((unicode >> 30) & 0x01) | 0xfc);
                _bytes.writeByte(((unicode >> 24) & 0x3f) | 0x80);
                _bytes.writeByte(((unicode >> 18) & 0x3f) | 0x80);
                _bytes.writeByte(((unicode >> 12) & 0x3f) | 0x80);
                _bytes.writeByte(((unicode >> 6) & 0x3f) | 0x80);
                _bytes.writeByte((unicode & 0x3f) | 0x80);
            }
        }

        public function getResult():ByteArray
        {
            _bytes.position = 0;
            return _bytes;
        }
    }
}

