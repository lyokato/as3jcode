package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;
    import org.coderepos.text.encoding.Jcode;

    public class UTF162UTF8Test extends TestCase
    {
        public function UTF162UTF8Test(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new UTF162UTF8Test("testEncode"));
            return ts;
        }

        public function testEncode():void
        {
            // UTF-16
            assertEquals('Encoding Test [utf-16]->[utf-8] [0]', '55Sw5Lit', encode('/v91ME4t'));
            assertEquals('Encoding Test [utf-16]->[utf-8] [1]', '6KGo56S644GZ44KL44CC', encode('/v+IaHk6MFkwizAC'));
            assertEquals('Encoding Test [utf-16]->[utf-8] [2]', '55Sw5Lit44GoQVNDSUk=', encode('/v91ME4tMGgAQQBTAEMASQBJ'));
            assertEquals('Encoding Test [utf-16]->[utf-8] [3]', '55Sw5Lit44Go44Kr44K/44Kr44OK', encode('/v91ME4tMGgwqzC/MKswyg=='));

            // UTF-16BE
            assertEquals('Encoding Test [utf-16be]->[utf-8] [0]', '55Sw5Lit', encode('dTBOLQ=='));
            assertEquals('Encoding Test [utf-16be]->[utf-8] [1]', '6KGo56S644GZ44KL44CC', encode('iGh5OjBZMIswAg=='));
            assertEquals('Encoding Test [utf-16be]->[utf-8] [2]', '55Sw5Lit44GoQVNDSUk=', encode('dTBOLTBoAEEAUwBDAEkASQ=='));
            assertEquals('Encoding Test [utf-16be]->[utf-8] [3]', '55Sw5Lit44Go44Kr44K/44Kr44OK', encode('dTBOLTBoMKswvzCrMMo='));

/* UTF-16 LE doesn't work as expected yet
assertEquals('Encoding Test [utf-16le]->[utf-8] [0]', '55Sw5Lit', encode('MHUtTg=='));
assertEquals('Encoding Test [utf-16le]->[utf-8] [1]', '6KGo56S644GZ44KL44CC', encode('aIg6eVkwizACMA=='));
assertEquals('Encoding Test [utf-16le]->[utf-8] [2]', '55Sw5Lit44GoQVNDSUk=', encode('MHUtTmgwQQBTAEMASQBJAA=='));
assertEquals('Encoding Test [utf-16le]->[utf-8] [3]', '55Sw5Lit44Go44Kr44K/44Kr44OK', encode('MHUtTmgwqzC/MKswyjA='));
*/

        }

        private function encode(base64:String):String
        {
            var srcByte:ByteArray = Base64.decodeToByteArray(base64);
            srcByte.position = 0;
            var encByte:ByteArray = Jcode.utf16_utf8(srcByte);
            return Base64.encodeByteArray(encByte);
        }

    }
}

