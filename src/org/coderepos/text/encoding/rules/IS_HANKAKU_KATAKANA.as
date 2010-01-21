package org.coderepos.text.encoding.rules
{
    public class IS_HANKAKU_KATAKANA implements IRule
    {
        public function IS_HANKAKU_KATAKANA()
        {
        }

        public function validate(unicode:uint):Boolean
        {
            // include ff61 - ff65
            return (unicode >= 0xff66 && unicode <= 0xff9f);
        }
    }
}
