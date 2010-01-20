package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;
    import org.coderepos.text.encoding.Jcode;
    import org.coderepos.text.encoding.writers.*;
    import org.coderepos.text.encoding.converters.*;

    public class UTF82UTF8Test extends TestCase
    {
        public function UTF82UTF8Test(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new UTF82UTF8Test("testEncode"));
            return ts;
        }

        public function testEncode():void
        {
            assertEquals('Encoding Test [utf-8]->[utf-8] [0]', 'ASCII', encode('ASCII'));
            assertEquals('Encoding Test [utf-8]->[utf-8] [1]', 'あいうえお', encode('あいうえお'));
        }

        private function encode(s:String):String
        {
            var srcByte:ByteArray = new ByteArray();
            srcByte.writeUTFBytes(s);
            srcByte.position = 0;
            var encByte:ByteArray = (new UTF8Converter(new UTF8Writer())).convert(srcByte);
            encByte.position = 0;
            return encByte.readUTFBytes(encByte.bytesAvailable);
        }
    }
}

