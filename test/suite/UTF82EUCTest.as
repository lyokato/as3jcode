package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;
    import org.coderepos.text.encoding.Jcode;

    public class UTF82EUCTest extends TestCase
    {
        public function UTF82EUCTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new UTF82EUCTest("testEncode"));
            return ts;
        }

        public function testEncode():void
        {
            assertEquals('Encoding Test [utf-8]->[euc-jp] [0]', 'xcTD5g==', encode('55Sw5Lit'));
            assertEquals('Encoding Test [utf-8]->[euc-jp] [1]', 'yb28qKS5pOuhow==', encode('6KGo56S644GZ44KL44CC'));
            assertEquals('Encoding Test [utf-8]->[euc-jp] [2]', 'xcTD5qTIQVNDSUk=', encode('55Sw5Lit44GoQVNDSUk='));
            assertEquals('Encoding Test [utf-8]->[euc-jp] [3]', 'xcTD5qTIpaulv6Wrpco=', encode('55Sw5Lit44Go44Kr44K/44Kr44OK'));
        }

        private function encode(base64:String):String
        {
            var srcByte:ByteArray = Base64.decodeToByteArray(base64);
            srcByte.position = 0;
            var encByte:ByteArray = Jcode.utf8_euc(srcByte);
            return Base64.encodeByteArray(encByte);
        }
    }
}

