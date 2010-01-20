package org.coderepos.text.encoding.writers
{
    import flash.utils.ByteArra;
    import org.coderepos.text.encoding.Jcode;

    public class ISO2022JPWriter extends EUCJPWriter implements IUnicodeWriter
    {
        override public function getResult():ByteArray
        {
            return Jcode.euc2jis(super.getResult());
        }
    }
}

