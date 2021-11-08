using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace _02.Race
{
    class Program
    {
        static void Main(string[] args)
        {
            Dictionary<string, int> participants = Console.ReadLine()
                .Split(", ")
                .ToDictionary(x => x, x => 0);

            Regex regexName = new Regex(@"[A-Za-z]");
            Regex distance = new Regex(@"\d");

            while (true)
            {
                string line = Console.ReadLine();
                if (line == "end of race")
                {
                    break;
                }

                MatchCollection match = regexName.Matches(line);
                MatchCollection match2 = distance.Matches(line);

                string name = Name(match);
                int totalDistance = Sum(match2);

                if (!participants.ContainsKey(name))
                {
                    continue;
                }
                participants[name] += totalDistance;


            }

            string[] winners = participants.OrderByDescending(x => x.Value)
                .Take(3)
                .Select(x => x.Key)
                .ToArray();

            Console.WriteLine($"1st place: {winners[0]}");
            Console.WriteLine($"2nd place: {winners[1]}");
            Console.WriteLine($"3rd place: {winners[2]}");
        }
        private static string Name(MatchCollection match)
        {
            StringBuilder sb = new StringBuilder();

            foreach (Match item in match)
            {
                sb.Append(item.Value);
            }

            return sb.ToString();
        }
        private static int Sum(MatchCollection match)
        {
            int sum = 0;

            foreach (Match item in match)
            {
                sum += int.Parse(item.Value);
            }

            return sum;
        }
    }
}
