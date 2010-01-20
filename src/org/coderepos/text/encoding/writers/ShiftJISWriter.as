package org.coderepos.text.encoding.writers
{
    import flash.utils.ByteArra;
    import org.coderepos.text.encoding.Jcode;

    public class ShiftJISWriter extends EUCJPWriter implements IUnicodeWriter
    {
        override public function getResult():ByteArray
        {
            return Jcode.euc2sjis(super.getResult());
        }
    }
}

