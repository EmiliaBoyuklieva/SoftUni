using System;

namespace _08.LettersChangeNumbers
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] text = Console.ReadLine()
                .Split(new char[] { ' ', '\t' }, StringSplitOptions.RemoveEmptyEntries);

            double result = 0;

            foreach (var item in text)
            {
                char firtsLetter = item[0];
                char lastLetter = item[item.Length - 1];
                double number = double.Parse(item.Substring(1, item.Length - 2));

                if (char.IsUpper(firtsLetter))
                {
                    number /= firtsLetter - 64;
                }
                else
                {
                    number *= firtsLetter - 96;
                }

                if (char.IsUpper(lastLetter))
                {
                    number -= lastLetter - 64;
                }
                else
                {
                    number += lastLetter - 96;
                }

                result += number;
            }

            Console.WriteLine($"{result:f2}");
        }
    }
}
