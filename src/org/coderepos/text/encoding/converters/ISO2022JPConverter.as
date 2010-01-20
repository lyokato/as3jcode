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

