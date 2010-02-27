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

package org.coderepos.text.encoding.validators
{
    import flash.utils.ByteArray;
    import org.coderepos.text.encoding.rules.IRule;

    public class UTF8Validator
    {
        private var _rule:IRule;

        public function UTF8Validator(rule:IRule)
        {
            _rule = rule;
        }

        public function validate(b:ByteArray):Boolean
        {
            var c:uint;
            var n1:uint;
            var n2:uint;
            var n3:uint;
            var n4:uint;
            var n5:uint;

            var unicode:uint;

            b.position = 0;

            if (   b.readUnsignedByte() == 0xef
                && b.readUnsignedByte() == 0xbb
                && b.readUnsignedByte() == 0xbf ) {
                // found BOM, this is UTF-8N
            } else {
                b.position = 0;
            }

            while (b.bytesAvailable > 0) {
                c = b.readUnsignedByte();
                if (c >=0x00 && c <= 0x7f) { // ASCII 0b0XXXXXXX
                    if (!(_rule.validate(c)))
                        return false;
                } else if (c >= 0xc0 && c <= 0xdf) { // 0b110XXXXX
                    if (!(b.bytesAvailable >= 1))
                        break;
                    n1 = b.readUnsignedByte();
                    unicode = ((c & 0x1f) << 6) | (n1 & 0x3f);
                    if (!(_rule.validate(unicode)))
                        return false;
                } else if (c >= 0xe0 && c <= 0xef) { // 0b1110XXXX
                    if (!(b.bytesAvailable >= 2))
                        break;
                    n1 = b.readUnsignedByte();
                    n2 = b.readUnsignedByte();
                    unicode = ((c & 0x0f) << 12)|((n1 & 0x3f)<<6)|(n2 & 0x3f);
                    if (!(_rule.validate(unicode)))
                        return false;
                } else if (c >= 0xf0 && c <= 0xf7) { // 0b11110XXX
                    if (!(b.bytesAvailable >= 3))
                        break;
                    n1 = b.readUnsignedByte();
                    n2 = b.readUnsignedByte();
                    n3 = b.readUnsignedByte();
                    unicode = ((c & 0x07) << 18)|((n1 & 0x3f)<<12)|((n2 & 0x3f)<<6)|(n3 & 0x3f);
                    if (!(_rule.validate(unicode)))
                        return false;
                } else if (c >= 0xf8 && c <= 0xfb) { // 0b111110XX
                    if (!(b.bytesAvailable >= 4))
                        break;
                    n1 = b.readUnsignedByte();
                    n2 = b.readUnsignedByte();
                    n3 = b.readUnsignedByte();
                    n4 = b.readUnsignedByte();
                    unicode = ((c & 0x3))<<24|((n1 & 0x3f)<<18)|((n2 & 0x3f)<<12)|((n3 & 0x3f)<<6)|(n4 & 0x3f);
                    if (!(_rule.validate(unicode)))
                        return false;
                } else if (c == 0xfc || c == 0xfd) { // 0b1111110X
                    if (!(b.bytesAvailable >= 5))
                        break;
                    n1 = b.readUnsignedByte();
                    n2 = b.readUnsignedByte();
                    n3 = b.readUnsignedByte();
                    n4 = b.readUnsignedByte();
                    n5 = b.readUnsignedByte();
                    unicode = ((c & 0x01)<<30)|((n1 & 0x3))<<24|((n2 & 0x3f)<<18)|((n3 & 0x3f)<<12)|((n4 & 0x3f)<<6)|(n5 & 0x3f);
                    if (!(_rule.validate(unicode)))
                        return false;
                }
            }
            return true;
        }
    }
}

