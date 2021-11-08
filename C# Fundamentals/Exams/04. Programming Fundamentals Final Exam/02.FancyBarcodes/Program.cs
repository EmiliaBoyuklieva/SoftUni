using System;
using System.Text.RegularExpressions;

namespace _02.FancyBarcodes
{
    class Program
    {
        static void Main(string[] args)
        {
            Regex regex = new Regex(@"@\#+[A-Z][a-z\dA-Z]{4,}[A-Z]@#{1,}");

            int n = int.Parse(Console.ReadLine());

            for (int i = 0; i < n; i++)
            {
                string text = Console.ReadLine();
                Match match = regex.Match(text);
                string group = string.Empty;

                if (match.Success)
                {
                    Regex regexDigits = new Regex(@"[\d]");
                    MatchCollection matchDigits = regexDigits.Matches(text);

                    foreach (Match item in matchDigits)
                    {
                        group += item.Value;
                    }
                    if (group.Length != 0)
                    {
                        Console.WriteLine($"Product group: {group}");
                    }
                    else
                    {
                        Console.WriteLine($"Product group: 00");
                    }
                }
                else
                {
                    Console.WriteLine("Invalid barcode");
                }
            }
    }
}
