/*
Copyright (c) Lyo Kato (lyo.kato _at_ gmail.com)

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
*/

package org.coderepos.text.encoding.rules
{
    public class Rules implements IRule
    {
        private var _rules:Array; // Vector.<IRule>

        //public function Rules(rule:IRule=null)
        public function Rules(...args:Array)
        {
            _rules = [];
            var len:int = args.length;
            for (var i:int = 0; i < len; i++)
                _rules.push(args[i]);
        }

        public function add(rule:IRule):void
        {
            _rules.push(rule);
        }

        public function validate(unicode:uint):Boolean
        {
            var len:int = _rules.length;
            for (var i:int = 0; i < len; i++) {
                if (_rules[i].validate(unicode))
                    return true;
            }
            return false;
        }
    }
}

