package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;
    import org.coderepos.text.encoding.Jcode;

    public class SJIS2EUCTest extends TestCase
    {
        public function SJIS2EUCTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new SJIS2EUCTest("testEncode"));
            return ts;
        }

        public function testEncode():void
        {
            assertEquals('Encoding Test [sjis]->[euc-jp] [0]', 'xcTD5g==', encode('k2OShg=='));
            assertEquals('Encoding Test [sjis]->[euc-jp] [1]', 'yb28qKS5pOuhow==', encode('lVyOpoK3gumBQg=='));
            assertEquals('Encoding Test [sjis]->[euc-jp] [2]', 'xcTD5qTIQVNDSUk=', encode('k2OShoLGQVNDSUk='));
            assertEquals('Encoding Test [sjis]->[euc-jp] [3]', 'xcTD5qTIpaulv6Wrpco=', encode('k2OShoLGg0qDXoNKg2k='));
        }

        private function encode(base64:String):String
        {
            var srcByte:ByteArray = Base64.decodeToByteArray(base64);
            srcByte.position = 0;
            var encByte:ByteArray = Jcode.sjis_euc(srcByte);
            return Base64.encodeByteArray(encByte);
        }
    }
}
