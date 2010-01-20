package org.coderepos.text.encoding.writers
{
    import flash.utils.ByteArray;

    public interface IUnicodeWriter
    {
        function write(unicode:uint):void;
        function getResult():ByteArray;
    }
}

