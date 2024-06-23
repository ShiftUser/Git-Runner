using System;
using System.Diagnostics;

class Program
{
    static void Main(string[] args)
    {
        // Define the path to your solution file
        string solutionPath = @"C:\Users\Supattra Boonchalee\Desktop\Shift\shift-browser-automated-testing\shift-browser-automated-testing.sln"; // Adjust the path accordingly

        // Build the solution
        RunProcess("dotnet", $"build \"{solutionPath}\"");

        // Run the tests
        RunProcess("dotnet", $"test \"{solutionPath}\" --logger \"trx;LogFileName=test_results.trx\"");
    }

    static void RunProcess(string fileName, string arguments)
    {
        // Create a new process start info
        ProcessStartInfo startInfo = new ProcessStartInfo
        {
            FileName = fileName,
            Arguments = arguments,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        // Start the process
        using (Process process = new Process { StartInfo = startInfo })
        {
            process.Start();

            // Read the output (or error)
            string output = process.StandardOutput.ReadToEnd();
            string error = process.StandardError.ReadToEnd();

            process.WaitForExit();

            // Print the output (or error)
            Console.WriteLine(output);
            if (!string.IsNullOrEmpty(error))
            {
                Console.WriteLine("ERROR:");
                Console.WriteLine(error);
            }

            // Check the exit code
            if (process.ExitCode != 0)
            {
                Console.WriteLine($"{fileName} exited with code {process.ExitCode}");
            }
            else
            {
                Console.WriteLine($"{fileName} ran successfully.");
            }
        }
    }
}
