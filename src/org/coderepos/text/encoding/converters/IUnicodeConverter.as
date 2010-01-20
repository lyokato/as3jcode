package org.coderepos.text.encoding.converters
{
    import flash.utils.ByteArray;

    public interface IUnicodeConverter
    {
        function convert(src:ByteArray):ByteArray;
    }
}
