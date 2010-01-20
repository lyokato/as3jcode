package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;
    import org.coderepos.text.encoding.Jcode;

    public class ValidatorTest extends TestCase
    {
        public function ValidatorTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new ValidatorTest("testHiragana"));
            ts.addTest(new ValidatorTest("testKatakana"));
            return ts;
        }

        public function testHiragana():void
        {
            assertTrue(Jcode.is_hiragana("あいうえお"));
            assertFalse(Jcode.is_hiragana("ASCII"));
            assertFalse(Jcode.is_hiragana("カタカナ"));
            assertFalse(Jcode.is_hiragana("漢字"));
            assertFalse(Jcode.is_hiragana("あいうえおASCIIカナ混合"));
        }

        public function testKatakana():void
        {
            assertFalse('hiragana', Jcode.is_katakana("あいうえお"));
            assertFalse('ascii', Jcode.is_katakana("ASCII"));
            assertTrue('kana', Jcode.is_katakana("カタカナ"));
            assertFalse('kanji', Jcode.is_katakana("漢字"));
            assertFalse('mixed', Jcode.is_katakana("あいうえおASCIIカナ混合"));
        }

    }
}
