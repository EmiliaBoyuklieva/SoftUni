using System;

namespace _02.VowelsCount
{
    class Program
    {
        static void Main(string[] args)
        {
            string text = Console.ReadLine();

            int vowelsCount = GetVowelsCount(text);
            Console.WriteLine(vowelsCount);
        }

        private static int GetVowelsCount(string text)
        {
            int counter = 0;
            text = text.ToLower();

            foreach (char letter in text)
            {
                if (letter == 'a' ||
                    letter == 'e' ||
                    letter == 'o' ||
                    letter == 'u' ||
                    letter == 'y' ||
                    letter == 'i')
                {
                    counter += 1;
                }
            }

            return counter;
        }
    }
}
