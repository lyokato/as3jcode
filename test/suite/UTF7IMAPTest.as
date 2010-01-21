package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;
    import org.coderepos.text.encoding.Jcode;
    import org.coderepos.text.encoding.IMAP_UTF7;

    public class UTF7IMAPTest extends TestCase
    {
        public function UTF7IMAPTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new UTF7IMAPTest("testB64"));
            ts.addTest(new UTF7IMAPTest("testUTF7IMAP"));
            return ts;
        }

        public function testB64():void
        {
            testB64Word("日本語");
            testB64Word("ほげほげ");
            testB64Word("abcdeほげほげ");
            testB64Word("abcdeほげほげefg");
        }

        public function testB64Word(s:String):void
        {
            var origin:ByteArray = new ByteArray();
            origin.writeUTFBytes(s);
            origin.position = 0;
            var encoded:String = IMAP_UTF7.encodeModifiedBase64(origin);
            var decoded:ByteArray = IMAP_UTF7.decodeModifiedBase64(encoded);
            decoded.position = 0;
            assertEquals(s, decoded.readUTFBytes(decoded.length));
        }

        public function testUTF7IMAP():void
        {
            var utf7i:String = IMAP_UTF7.encode("INBOX.日本語");
            assertEquals('encode', 'INBOX.&ZeVnLIqe-', utf7i);
            assertEquals('decode', 'INBOX.日本語', IMAP_UTF7.decode('INBOX.&ZeVnLIqe-'));
        }

    }
}
