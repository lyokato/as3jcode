package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;
    import org.coderepos.text.encoding.Jcode;

    public class EUC2JISTest extends TestCase
    {
        public function EUC2JISTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new EUC2JISTest("testEncode"));
            return ts;
        }

        public function testEncode():void
        {
            //assertEquals('Encoding Test [euc-jp]->[iso-2022-jp] [0]', 'GyRCRURDZhsoQg==', encode('xcTD5g=='));
            assertEquals('Encoding Test [euc-jp]->[iso-2022-jp] [1]', 'GyRCST08KCQ5JGshIxsoQg==', encode('yb28qKS5pOuhow=='));
            assertEquals('Encoding Test [euc-jp]->[iso-2022-jp] [2]', 'GyRCRURDZiRIGyhCQVNDSUk=', encode('xcTD5qTIQVNDSUk='));
            assertEquals('Encoding Test [euc-jp]->[iso-2022-jp] [3]', 'GyRCRURDZiRIJSslPyUrJUobKEI=', encode('xcTD5qTIpaulv6Wrpco='));
        }

        private function encode(base64:String):String
        {
            var srcByte:ByteArray = Base64.decodeToByteArray(base64);
            srcByte.position = 0;
            var encByte:ByteArray = Jcode.euc_jis(srcByte);
            return Base64.encodeByteArray(encByte);
        }
    }
}
