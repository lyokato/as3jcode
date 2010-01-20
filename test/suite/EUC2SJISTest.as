package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;
    import org.coderepos.text.encoding.Jcode;

    public class EUC2SJISTest extends TestCase
    {
        public function EUC2SJISTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new EUC2SJISTest("testEncode"));
            return ts;
        }

        public function testEncode():void
        {
            assertEquals('Encoding Test [euc-jp]->[sjis] [0]', 'k2OShg==', encode('xcTD5g=='));
            assertEquals('Encoding Test [euc-jp]->[sjis] [1]', 'lVyOpoK3gumBQg==', encode('yb28qKS5pOuhow=='));
            assertEquals('Encoding Test [euc-jp]->[sjis] [2]', 'k2OShoLGQVNDSUk=', encode('xcTD5qTIQVNDSUk='));
            assertEquals('Encoding Test [euc-jp]->[sjis] [3]', 'k2OShoLGg0qDXoNKg2k=', encode('xcTD5qTIpaulv6Wrpco='));
        }

        private function encode(base64:String):String
        {
            var srcByte:ByteArray = Base64.decodeToByteArray(base64);
            srcByte.position = 0;
            var encByte:ByteArray = Jcode.euc_sjis(srcByte);
            return Base64.encodeByteArray(encByte);
        }
    }
}
