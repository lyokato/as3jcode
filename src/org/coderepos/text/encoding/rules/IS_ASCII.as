package org.coderepos.text.encoding.rules
{
    public class IS_ASCII implements IRule
    {
        public function IS_ASCII()
        {
        }

        public function validate(unicode:uint):Boolean
        {
            return (unicode >= 0x21 && unicode <= 0xfe);
        }
    }
}

