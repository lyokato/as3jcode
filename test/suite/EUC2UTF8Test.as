package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;
    import org.coderepos.text.encoding.Jcode;

    public class EUC2UTF8Test extends TestCase
    {
        public function EUC2UTF8Test(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new EUC2UTF8Test("testEncode"));
            return ts;
        }

        public function testEncode():void
        {
            assertEquals('Encoding Test [euc-jp]->[utf-8] [0]', '55Sw5Lit', encode('xcTD5g=='));
            assertEquals('Encoding Test [euc-jp]->[utf-8] [1]', '6KGo56S644GZ44KL44CC', encode('yb28qKS5pOuhow=='));
            assertEquals('Encoding Test [euc-jp]->[utf-8] [2]', '55Sw5Lit44GoQVNDSUk=', encode('xcTD5qTIQVNDSUk='));
            assertEquals('Encoding Test [euc-jp]->[utf-8] [3]', '55Sw5Lit44Go44Kr44K/44Kr44OK', encode('xcTD5qTIpaulv6Wrpco='));
        }

        private function encode(base64:String):String
        {
            var srcByte:ByteArray = Base64.decodeToByteArray(base64);
            srcByte.position = 0;
            var encByte:ByteArray = Jcode.euc_utf8(srcByte);
            return Base64.encodeByteArray(encByte);
        }
    }
}

