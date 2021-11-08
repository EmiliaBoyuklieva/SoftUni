using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace _01.Furniture
{
    class Program
    {
        static void Main(string[] args)
        {
            Regex regex = new Regex(@">>(?<name>[A-z]+)<<(?<price>\d*[.]*\d+)!(?<quantity>\d+)");

            List<string> furnitures = new List<string>();

            double totalMoney = 0;

            while (true)
            {
                string line = Console.ReadLine();

                if (line == "Purchase")
                {
                    break;
                }

                Match match = regex.Match(line);

                if (!match.Success)
                {
                    continue;
                }

                string name = match.Groups["name"].Value;
                double price = double.Parse(match.Groups["price"].Value);
                int quantity = int.Parse(match.Groups["quantity"].Value);

                furnitures.Add(name);

                totalMoney += quantity * price;
            }

            Console.WriteLine("Bought furniture:");

            if(furnitures.Count > 0)
            {
                Console.WriteLine(string.Join(Environment.NewLine, furnitures));
            }

            Console.WriteLine($"Total money spend: {totalMoney:F2}");
        }
    }
}
