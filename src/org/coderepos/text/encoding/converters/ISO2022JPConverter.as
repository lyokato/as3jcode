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
    import org.coderepos.text.encoding.Jcode;
    import org.coderepos.text.encoding.writers.IUnicodeWriter;

    public class ISO2022JPConverter extends EUCJPConverter implements IUnicodeConverter
    {
        public function ISO2022JPConverter(unicodeWriter:IUnicodeWriter)
        {
            super(unicodeWriter);
        }

        public function convert(b:ByteArray):ByteArray
        {
            return super.convert(Jcode.jis2euc(b));
        }
    }
}

