using System;
using System.Linq;

namespace _09.PalindromeIntegers
{
    class Program
    {
        static void Main(string[] args)
        {
            string command = Console.ReadLine();

            bool palindrome = true;

            while (command != "END")
            {
                palindrome = IsPalindrom(command);

                Console.WriteLine(palindrome);

                command = Console.ReadLine();
            }
        }
        static bool IsPalindrom(string word)
        {
            string reversed = string.Concat(word.Reverse());

            if (word == reversed)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
