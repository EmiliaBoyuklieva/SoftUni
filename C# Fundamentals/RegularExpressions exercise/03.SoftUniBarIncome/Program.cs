using System;
using System.Text.RegularExpressions;

namespace _03.SoftUniBarIncome
{
    class Program
    {
        static void Main(string[] args)
        {
            Regex regex =
            new Regex(@"\%(?<name>[A-Z][a-z]+)\%[^%$!.]*\<(?<product>\w+)\>[^%$!.]*\|(?<quantity>\d+)\|[^%$!.]*?(?<price>\d+([.]\d+)?)\$");

            double totalIncome = 0;

            while (true)
            {
                string line = Console.ReadLine();

                if (line == "end of shift")
                {
                    break;
                }

                Match match = regex.Match(line);

                if (match.Success)
                {
                    string name = match.Groups["name"].Value;
                    string product = match.Groups["product"].Value;
                    double quantity = double.Parse(match.Groups["quantity"].Value);
                    double price = double.Parse(match.Groups["price"].Value);

                    double income = quantity * price;

                    Console.WriteLine($"{name}: {product} - {income:f2}");

                    totalIncome += income;
                }
            }

            Console.WriteLine($"Total income: {totalIncome:f2}");
        }
    }
}
