using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace SeleniumDocker
{
    public class BasePage
    {
        protected IWebDriver driver;

        public BasePage(bool headless)
        {
            var options = new ChromeOptions();
            if (headless)
            {
                options.AddArgument("--headless");
            }

            driver = new ChromeDriver(options);
        }

        public void CloseBrowser()
        {
            driver.Quit();
        }
    }
}
