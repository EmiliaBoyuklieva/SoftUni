using System;

namespace _01.ValidUsernames
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] username = Console.ReadLine().Split(", ", StringSplitOptions.RemoveEmptyEntries);

            foreach (var item in username)
            {
                if (IsValidUsername(item))
                {
                    Console.WriteLine(item);
                }
            }
        }
        public static bool IsValidUsername(string username)
        {
            return IsValidLenght(username) && ContainsValidSymbol(username);
        }
        public static bool IsValidLenght(string username)
        {
            return username.Length >= 3 && username.Length <= 16;
        }
        public static bool ContainsValidSymbol(string username)
        {
            foreach (var item in username)
            {
                if (!char.IsLetterOrDigit(item) && item != '-' && item != '_')
                {
                    return false;
                }
            }
            return true;
        }
    }
}
