using System;

namespace _10.TopNumber
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());

            for (int i = 0; i <= n; i++)
            {
                if (IsTopNumber(i))
                {
                    Console.WriteLine(i);
                }
            }
        }

        private static bool IsTopNumber(int number)
        {
            return IsDevisible(number, 8) && ContainsOddDogits(number);
        }

        private static bool ContainsOddDogits(int number)
        {
            while (number != 0)
            {
                int lastDigits = number % 10;

                if (lastDigits % 2 == 1)
                {
                    return true;
                }

                number /= 10;
            }

            return false;
        }

        private static bool IsDevisible(int number, int diveder)
        {
            int sum = 0;

            while (number != 0)
            {
                int lastDigits = number % 10;
                sum += lastDigits;
                number /= 10;
            }

            return sum % diveder == 0;
        }
    }   
}
