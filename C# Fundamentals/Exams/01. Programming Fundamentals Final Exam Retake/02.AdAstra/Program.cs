using System;
using System.Text.RegularExpressions;

namespace _02.AdAstra
{
    class Program
    {
        static void Main(string[] args)
        {
            int caloriesPerDay = 2000;
            Regex regex = new Regex(@"(\#|\|)(?<item>[A-za-z\s]+)\1(?<date>\d{2}\/\d{2}\/\d{2})\1(?<calories>\d{1,4}|10000)\1");

            string text = Console.ReadLine();
            MatchCollection match = regex.Matches(text);
            int totalCalories = 0;

            foreach (Match item in match)
            {
                int calories = int.Parse(item.Groups["calories"].Value);
              
                totalCalories += calories;
            }
            int days = totalCalories / caloriesPerDay;

            Console.WriteLine($"You have food to last you for: {days} days!");

            foreach (Match item in match)
            {
                string name = item.Groups["item"].Value;
                string date =item.Groups["date"].Value;
                int calories = int.Parse(item.Groups["calories"].Value);

                Console.WriteLine($"Item: {name}, Best before: {date}, Nutrition: {calories}");
            }
        }
    }
}
