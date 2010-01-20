package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;
    import org.coderepos.text.encoding.Jcode;

    public class JIS2EUCTest extends TestCase
    {
        public function JIS2EUCTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new JIS2EUCTest("testEncode"));
            return ts;
        }

        public function testEncode():void
        {

        assertEquals('Encoding Test JIS -> EUC [0]', 'xcTD5g==', encode('GyRCRURDZhsoQg=='));
        assertEquals('Encoding Test JIS -> EUC [1]', 'yb28qKS5pOuhow==', encode('GyRCST08KCQ5JGshIxsoQg=='));
        assertEquals('Encoding Test JIS -> EUC [2]', 'xcTD5qTIQVNDSUk=', encode('GyRCRURDZiRIGyhCQVNDSUk='));
        assertEquals('Encoding Test JIS -> EUC [3]', 'xcTD5qTIpaulv6Wrpco=', encode('GyRCRURDZiRIJSslPyUrJUobKEI='));
        }

        private function encode(base64:String):String
        {
            var srcByte:ByteArray = Base64.decodeToByteArray(base64);
            srcByte.position = 0;
            var encByte:ByteArray = Jcode.jis_euc(srcByte);
            return Base64.encodeByteArray(encByte);
        }
    }
}
