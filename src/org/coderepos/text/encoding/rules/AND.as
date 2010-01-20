package org.coderepos.text.encoding.rules
{
    public class AND implements IRule
    {
        private var _rule1:IRule;
        private var _rule2:IRule;

        public function AND(rule1:IRule, rule2:IRule)
        {
            _rule1 = rule1;
            _rule2 = rule2;
        }

        public function validate(unicode:uint):Boolean
        {
            return (_rule1.validate(unicode) && _rule2.validate(unicode));
        }
    }
}

