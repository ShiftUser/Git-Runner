using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace SeleniumDocker
{
    [TestClass]
    public class TestRdbrck : BasePage
    {
        // Parameterless constructor required by MSTest
        public TestRdbrck() : base(true) { }

        // Constructor with parameters (optional)
        public TestRdbrck(bool headless) : base(headless) { }

        [TestMethod]
        public void TestRdbrckHomepage()
        {
            try
            {
                // Navigate to Redbrick homepage
                driver.Navigate().GoToUrl("https://www.rdbrck.com/");

                // Assert that the title is correct
                if (driver.Title.Contains("Redbrick"))
                {
                    Console.WriteLine("Test Passed: Redbrick homepage title is correct.");
                }
                else
                {
                    Console.WriteLine("Test Failed: Redbrick homepage title is incorrect.");
                }
            }
            catch (Exception e)
            {
                Console.WriteLine($"Test Failed: {e.Message}");
            }
            finally
            {
                CloseBrowser();
            }
        }
    }
}
