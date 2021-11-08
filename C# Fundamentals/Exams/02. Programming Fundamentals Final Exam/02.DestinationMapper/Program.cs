using System;
using System.Collections.Generic;
using System.Linq;

using System.Text.RegularExpressions;

namespace _02.DestinationMapper
{
    class Program
    {
        static void Main(string[] args)
        {
            string text = Console.ReadLine();

            List<string> destinations = new List<string>();
       
            int travelPoints = 0;

            Regex regex = new Regex(@"(=|\/)(?<place>[A-Z][A-Za-z]{2,})\1");

            MatchCollection match = regex.Matches(text);
           

            foreach (Match item in match)
            {

                travelPoints += item.Groups["place"].Value.Count();
                destinations.Add(item.Groups["place"].Value);
            }

            Console.WriteLine($"Destinations: {string.Join(", ",destinations)}");
            Console.WriteLine($"Travel Points: { travelPoints} ");



        }
    }
}
