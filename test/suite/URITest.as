package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;
    import org.coderepos.text.encoding.Jcode;

    public class URITest extends TestCase
    {
        public function URITest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new URITest("testURI"));
            return ts;
        }

        public function testURI():void
        {
            var encoded:String = Jcode.encodeURIComponentBytes(Jcode.to_euc("あいうえお"));
            assertEquals('uri encode', encoded, '%A4%A2%A4%A4%A4%A6%A4%A8%A4%AA');

            var decodedBytes:ByteArray = Jcode.decodeURIComponentToBytes(encoded);
            var origin:String = Jcode.from_euc(decodedBytes);
            assertEquals('uri decode to origin', origin, "あいうえお");
        }

    }
}

