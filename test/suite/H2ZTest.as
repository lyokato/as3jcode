package suite
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    import flash.utils.ByteArray;
    import com.hurlant.util.Base64;
    import org.coderepos.text.encoding.Jcode;

    public class H2ZTest extends TestCase
    {
        public function H2ZTest(meth:String)
        {
            super(meth);
        }

        public static function suite():TestSuite
        {
            var ts:TestSuite = new TestSuite();
            ts.addTest(new H2ZTest("testH2Z"));
            ts.addTest(new H2ZTest("testZ2H"));
            return ts;
        }

        public function testH2Z():void
        {
            assertEquals('h2z', 'アイウエオ', Jcode.h2z("ｱｲｳｴｵ"));
            assertEquals('h2z', 'アイヴエオ', Jcode.h2z("ｱｲｳﾞｴｵ"));
            assertEquals('h2z', 'アイウエオカキクケコナニヌネノハヒフヘホ', Jcode.h2z("ｱｲｳｴｵｶｷｸｹｺﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎ"));
            assertEquals('h2z', 'アイウエオガギグゲコナニヌネノハヒブヘホ', Jcode.h2z("ｱｲｳｴｵｶﾞｷﾞｸﾞｹﾞｺﾅﾆﾇﾈﾉﾊﾋﾌﾞﾍﾎ"));
            assertEquals('h2z', 'アイウエオカキクケコナニヌネノパヒフヘポ', Jcode.h2z("ｱｲｳｴｵｶｷｸｹｺﾅﾆﾇﾈﾉﾊﾟﾋﾌﾍﾎﾟ"));
        }

        public function testZ2H():void
        {
            assertEquals('h2z 1', Jcode.z2h('アイウエオ'), "ｱｲｳｴｵ");
            assertEquals('h2z 2', Jcode.z2h('アイヴエオ'), "ｱｲｳﾞｴｵ");
            assertEquals('h2z 3', Jcode.z2h('アイウエオカキクケコナニヌネノハヒフヘホ'), "ｱｲｳｴｵｶｷｸｹｺﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎ");
            assertEquals('h2z 4', Jcode.z2h('アイウエオガギグゲコナニヌネノハヒブヘホ'), "ｱｲｳｴｵｶﾞｷﾞｸﾞｹﾞｺﾅﾆﾇﾈﾉﾊﾋﾌﾞﾍﾎ");
            assertEquals('h2z 5', Jcode.z2h('アイウエオカキクケコナニヌネノパヒフヘポ'), "ｱｲｳｴｵｶｷｸｹｺﾅﾆﾇﾈﾉﾊﾟﾋﾌﾍﾎﾟ");
        }

    }
}
