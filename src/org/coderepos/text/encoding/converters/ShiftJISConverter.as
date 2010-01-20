package org.coderepos.text.encoding.converters
{
    import flash.utils.ByteArray;
    import org.coderepos.text.encoding.Jcode;
    import org.coderepos.text.encoding.writers.IUnicodeWriter;

    public class ShiftJISConverter extends EUCJPConverter implements IUnicodeConverter
    {
        public function ShiftJISConverter(unicodeWriter:IUnicodeWriter)
        {
            super(unicodeWriter);
        }

        public function convert(b:ByteArray):ByteArray
        {
            return super.convert(Jcode.sjis2euc(b));
        }
    }
}

