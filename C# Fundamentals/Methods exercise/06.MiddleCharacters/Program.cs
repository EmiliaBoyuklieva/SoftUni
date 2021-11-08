using System;

namespace _06.MiddleCharacters
{
    class Program
    {
        static void Main(string[] args)
        {
            string word = Console.ReadLine();
            Console.WriteLine(MiddleCharacters(word));
        }
        static string MiddleCharacters(string word)
        {
            if (word.Length % 2 == 0)
            {
                return $"{word[(word.Length / 2) - 1]}{word[word.Length / 2]}";
            }
            else
            {
                return $"{word[word.Length / 2]}";
            }
        }
    }
}
