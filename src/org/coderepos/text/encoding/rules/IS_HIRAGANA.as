package org.coderepos.text.encoding.rules
{
    public class IS_HIRAGANA implements IRule
    {
        public function IS_HIRAGANA()
        {
        }

        public function validate(unicode:uint):Boolean
        {
            return (unicode >= 0x3040 && unicode <= 0x309f);
        }
    }
}

