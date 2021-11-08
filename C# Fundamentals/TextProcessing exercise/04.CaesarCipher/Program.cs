using System;
using System.Text;

namespace _04.CaesarCipher
{
    class Program
    {
        static void Main(string[] args)
        {
            string message = Console.ReadLine();

            StringBuilder rezult = new StringBuilder();

            foreach (var item in message)
            {
                char encrypted = (char)(item + 3);
                rezult.Append(encrypted);
            }

            Console.WriteLine(rezult);
        }
    }
}
