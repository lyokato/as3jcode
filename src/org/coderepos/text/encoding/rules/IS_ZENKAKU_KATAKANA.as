package org.coderepos.text.encoding.rules
{
    public class IS_ZENKAKU_KATAKANA implements IRule
    {
        public function IS_ZENKAKU_KATAKANA()
        {
        }

        public function validate(unicode:uint):Boolean
        {
            return (unicode >= 0x30a0 && unicode <= 0x30ff);
        }
    }
}
