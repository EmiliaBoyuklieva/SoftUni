using System;
using System.Text;

namespace _06.ReplaceRepeatingChars
{
    class Program
    {
        static void Main(string[] args)
        {
            string text = Console.ReadLine();
            char prevSymbol = '\0';

            StringBuilder rezult = new StringBuilder();

            foreach (var item in text)
            {
                if (prevSymbol != item)
                {
                    rezult.Append(item);
                }

                prevSymbol = item;
            }

            Console.WriteLine(rezult);
        }
    }
}
