package suite {
  
  import flexunit.framework.TestSuite;  
  
  public class AllTests extends TestSuite {
    
    public function AllTests() {
      super();
      // Add tests here
      // For examples, see: http://code.google.com/p/as3flexunitlib/wiki/Resources
      addTest(JIS2EUCTest.suite());
      addTest(EUC2JISTest.suite());
      addTest(SJIS2EUCTest.suite());
      addTest(EUC2SJISTest.suite());
      addTest(EUC2UTF8Test.suite());
      addTest(UTF82EUCTest.suite());
      addTest(UTF162UTF8Test.suite());
      addTest(UTF82UTF8Test.suite());
      addTest(UTF82UTF16Test.suite());
      addTest(ValidatorTest.suite());
      addTest(H2ZTest.suite());
      addTest(UTF7IMAPTest.suite());
    }
  }
}
