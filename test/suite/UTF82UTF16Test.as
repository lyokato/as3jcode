package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;
    import org.coderepos.text.encoding.Jcode;

    public class UTF82UTF16Test extends TestCase
    {
        public function UTF82UTF16Test(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new UTF82UTF16Test("testEncode"));
            return ts;
        }

        public function testEncode():void
        {

// UTF-16BE
assertEquals('Encoding Test [utf-8]->[utf-16be] [0]', 'dTBOLQ==', encode('55Sw5Lit'));
assertEquals('Encoding Test [utf-8]->[utf-16be] [1]', 'iGh5OjBZMIswAg==', encode('6KGo56S644GZ44KL44CC'));
assertEquals('Encoding Test [utf-8]->[utf-16be] [2]', 'dTBOLTBoAEEAUwBDAEkASQ==', encode('55Sw5Lit44GoQVNDSUk='));
assertEquals('Encoding Test [utf-8]->[utf-16be] [3]', 'dTBOLTBoMKswvzCrMMo=', encode('55Sw5Lit44Go44Kr44K/44Kr44OK'));

/* UTF-16
assertEquals('Encoding Test [utf-8]->[utf-16] [0]', '/v91ME4t', encode('55Sw5Lit'));
assertEquals('Encoding Test [utf-8]->[utf-16] [1]', '/v+IaHk6MFkwizAC', encode('6KGo56S644GZ44KL44CC'));
assertEquals('Encoding Test [utf-8]->[utf-16] [2]', '/v91ME4tMGgAQQBTAEMASQBJ', encode('55Sw5Lit44GoQVNDSUk='));
assertEquals('Encoding Test [utf-8]->[utf-16] [3]', '/v91ME4tMGgwqzC/MKswyg==', encode('55Sw5Lit44Go44Kr44K/44Kr44OK'));
*/

        }

        private function encode(base64:String):String
        {
            var srcByte:ByteArray = Base64.decodeToByteArray(base64);
            srcByte.position = 0;
            var encByte:ByteArray = Jcode.utf8_utf16(srcByte);
            return Base64.encodeByteArray(encByte);
        }
    }
}

