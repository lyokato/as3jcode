package org.coderepos.text.encoding.writers
{
    import flash.utils.ByteArray;
    import org.coderepos.text.encoding.tables.U2E;

    public class EUCJPWriter implements IUnicodeWriter
    {
        private var _bytes:ByteArray;

        public function EUCJPWriter()
        {
            _bytes = new ByteArray();
        }

        public function write(unicode:uint):void
        {
            var euc:uint;

            //if (unicode == 0xff3c) euc = 0xa1c0;
            if (unicode == 0xff3c)
                euc = 0xa2f7;
            else if (unicode == 0x5c)
                euc = 0xa1c0;
            else if (unicode == 0x7e)
                euc = 0x8fa2b7;
            else
                euc = U2E.find(unicode);

            // check under 3 byte
            var n1:uint = (euc & 0x00ff0000)>>16;
            var n2:uint = (euc & 0x0000ff00)>>8;
            var n3:uint = euc & 0x000000ff;

            if (n1 == 0x8f) {
                // JIS X 0212
                _bytes.writeByte(n1);
                _bytes.writeByte(n2);
                _bytes.writeByte(n3);
            } else if (n2 == 0x8e) {
                // Hankaku Kana
                _bytes.writeByte(n2);
                _bytes.writeByte(n3);
            } else if (n2 == 0x00) {
                // ASCII
                _bytes.writeByte(n3);
            } else {
                // JIS X 0208
                _bytes.writeByte(n2);
                _bytes.writeByte(n3);
            }
        }

        public function getResult():ByteArray
        {
            _bytes.position = 0;
            return _bytes;
        }
    }
}

