#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )

package ${package}.it;

import com.thoughtworks.selenium.DefaultSelenium;
import com.thoughtworks.selenium.Selenium;

import org.openqa.selenium.*;
import org.openqa.selenium.htmlunit.*;
import org.openqa.selenium.firefox.*;
import org.openqa.selenium.chrome.*;
import org.openqa.selenium.ie.*;
import org.junit.*;
import static org.junit.Assert.*;

public class LoginTest {

    WebDriver driver;
	Selenium selenium;

	@Before
	public void startSelenium() {
        selenium = new DefaultSelenium("localhost", 4444, System.getProperty("browsertype"), System.getProperty("remote.public.url"));
        selenium.start();
	}

	@After
	public void stopSelenium() {
		selenium.stop();
	}

	@Test
	public void testLogin() {
		selenium.open("/yourapp/portal.do");
		selenium.type("name=__login_user", "admin");
		selenium.click("css=input[type=\"submit\"]");
		selenium.waitForPageToLoad("30000");
	}

}
